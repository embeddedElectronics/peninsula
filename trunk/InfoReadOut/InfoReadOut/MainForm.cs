using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using System.Threading;

namespace InfoReadOut
{
    public partial class MainForm : Form
    {
        public MyConfig config = new MyConfig();
        public List<Bitmap> ImageSend;
        public List<Byte[]> ImageData;
        public List<Bitmap>[] ThreadImageSend;
        public List<Byte[]>[] ThreadImageData;
        public List<String[]> DataSend = new List<String[]>();
        ImageForm imgForm = new ImageForm();
        //DataForm dataForm = new DataForm();
        ProgressForm progressForm;
        public int progress_Done, progress_Total;
        String[] ImageFileNames;

        public MainForm()
        {
            InitializeComponent();
            Init();
        }
        /// <summary>
        /// 初始化窗口配置
        /// </summary>
        public void Init()
        {
            if (ConfigWorker.FileDetect() == ConfigWorker.States.Exception)
            {
                ConfigWorker.CreatNew(ref config);
            }
            if (ConfigWorker.Load(ref config) == ConfigWorker.States.OK)
            {
                openFileDialog.InitialDirectory = config.FilesPath;
                folderBrowserDialog.SelectedPath = config.FolderPath;
                checkBox_NeedDecode.Checked = config.NeedDecode;
                checkBox_IsSDFile.Checked = config.SDFile;
                textBox_Width.Text = config.Width.ToString();
                textBox_Height.Text = config.Height.ToString();
                textBox_Useless.Text = config.Useless.ToString();
                textBox_Front.Text = config.Front.ToString();
                textBox_Behind.Text = config.Behind.ToString();
                textBox_ThreadNum.Text = config.ThreadNum.ToString();
            }
            else
            {
                ConfigWorker.CreatNew(ref config);
            }

        }
        private void button_OpenFile_Click(object sender, EventArgs e)
        {
            openFileDialog.InitialDirectory = config.FilesPath;
            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                ImageSend = new List<Bitmap>();
                config.FilesPath = System.IO.Path.GetDirectoryName(openFileDialog.FileName);
                ImageFileNames = openFileDialog.FileNames;
                button_Show_Click(this, e);
            }

        }

        private void button_OpenFolder_Click(object sender, EventArgs e)
        {
            folderBrowserDialog.SelectedPath = config.FolderPath;
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                ImageSend = new List<Bitmap>();
                config.FolderPath = folderBrowserDialog.SelectedPath;
                DirectoryInfo selectedFolder = new DirectoryInfo(config.FolderPath);
                FileInfo[] selectedImageFiles = selectedFolder.GetFiles(config.Filter_ImageFile);
                int index = selectedImageFiles.Count();
                ImageFileNames = new String[index];
                while (index > 0)
                {
                    ImageFileNames[index - 1] = selectedImageFiles[index - 1].FullName;
                    index--;
                }

                button_Show_Click(this, e);


            }
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            config.NeedDecode = checkBox_NeedDecode.Checked;
            config.SDFile = checkBox_IsSDFile.Checked;
            config.Width = Convert.ToUInt16(textBox_Width.Text.ToString());
            config.Height = Convert.ToUInt16(textBox_Height.Text.ToString());
            config.Useless = Convert.ToUInt16(textBox_Useless.Text.ToString());
            config.Front = Convert.ToUInt16(textBox_Front.Text.ToString());
            config.Behind = Convert.ToUInt16(textBox_Behind.Text.ToString());
            config.ThreadNum = Convert.ToUInt16(textBox_ThreadNum.Text.ToString());
            ConfigWorker.Save(config);
        }

        private void textBox_Width_TextChanged(object sender, EventArgs e)
        {
            try
            {
                config.Width = Convert.ToUInt16(textBox_Width.Text.ToString());

            }
            catch { }
        }

        private void textBox_Height_TextChanged(object sender, EventArgs e)
        {
            try
            {
                config.Height = Convert.ToUInt16(textBox_Height.Text.ToString());

            }
            catch { }
        }

        private void textBox_Useless_TextChanged(object sender, EventArgs e)
        {
            try
            {
                config.Useless = Convert.ToUInt16(textBox_Useless.Text.ToString());

            }
            catch { }
        }

        private void textBox_Front_TextChanged(object sender, EventArgs e)
        {
            try
            {
                config.Front = Convert.ToUInt16(textBox_Front.Text.ToString());

            }
            catch { }
        }

        private void textBox_Behind_TextChanged(object sender, EventArgs e)
        {
            try
            {
                config.Behind = Convert.ToUInt16(textBox_Behind.Text.ToString());

            }
            catch { }
        }

        private void button_Show_Click(object sender, EventArgs e)
        {
            try
            {
                ImageSend = new List<Bitmap>();
                ImageData = new List<Byte[]>();
                ThreadImageSend = new List<Bitmap>[config.ThreadNum];
                ThreadImageData = new List<Byte[]>[config.ThreadNum];
                Thread _thread = new Thread(ShowThread);

                progress_Done = 0;
                progress_Total = ImageFileNames.Count();
                progressForm = new ProgressForm(this);
                progressForm.SetMaximum();
                _thread.Start();
                progressForm.ShowDialog();
                _thread.Join();
                for (int i = 0; i < config.ThreadNum; i++)
                {
                    ImageSend.AddRange(ThreadImageSend[i]);
                    ImageData.AddRange(ThreadImageData[i]);
                }
                imgForm.SetConfig(config);
                imgForm.ImageRefresh(ImageSend);
                //dataForm.SetStartPostion(imgForm.Location);
                //dataForm.Show();
                imgForm.Show();

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }
        private void ShowThread()
        {
            Thread[] subThread = new Thread[config.ThreadNum];
            for (int i = 0; i < config.ThreadNum; i++)
            {
                subThread[i] = new Thread(ShowSubThread);
                subThread[i].Start(i);
            }
        }
        private void ShowSubThread(object data)
        {
            ThreadImageData[(int)data] = new List<Byte[]>();
            ThreadImageSend[(int)data] = new List<Bitmap>();
            if (checkBox_IsSDFile.Checked == false)
            {
                for (int i = (int)data * (progress_Total / config.ThreadNum); i < ((config.ThreadNum == (int)data) ? (progress_Total / config.ThreadNum) * ((int)data + 1) : progress_Total); i++)
                {
                    String fileName = ImageFileNames[i];
                    Byte[] imageData = TextWorker.Readin(fileName, config.Width, config.Height, config.Useless, config.Front, config.Behind, checkBox_NeedDecode.Checked);
                    ThreadImageData[(int)data].Add(imageData);
                    Bitmap bitmap = ImageWorker.ImageDraw(imageData, config.Width, config.Height, config.Magnify);
                    ThreadImageSend[(int)data].Add(bitmap);
                    progress_Done++;
                }
            }
            else
            {
                for (int i = (int)data * (progress_Total / config.ThreadNum); i < ((config.ThreadNum == (int)data) ? (progress_Total / config.ThreadNum) * ((int)data + 1) : progress_Total); i++)
                {
                    String fileName = ImageFileNames[i];
                    Byte[] imageData = TextWorker.ReadinSD(fileName, config.Width, config.Height, config.Useless, config.Front, config.Behind, checkBox_NeedDecode.Checked);
                    ThreadImageData[(int)data].Add(imageData);
                    Bitmap bitmap = ImageWorker.ImageDraw(imageData, config.Width, config.Height, config.Magnify);
                    ThreadImageSend[(int)data].Add(bitmap);
                    progress_Done++;
                }
            }
        }
        private void MainForm_Load(object sender, EventArgs e)
        {
            int xWidth = SystemInformation.WorkingArea.Width;//获取屏幕宽度
            int yHeight = SystemInformation.WorkingArea.Height;//高度
            this.Location = new Point(xWidth - this.Size.Width, yHeight - this.Size.Height);
        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {

            if (checkBox_IsSDFile.Checked == false)
            {
                for (int i = 0; i < progress_Total / 2; i++)
                {
                    String fileName = ImageFileNames[i];
                    Byte[] imageData = TextWorker.Readin(fileName, config.Width, config.Height, config.Useless, config.Front, config.Behind, checkBox_NeedDecode.Checked);
                    ImageData.Insert(i, imageData);
                    Bitmap bitmap = ImageWorker.ImageDraw(imageData, config.Width, config.Height, config.Magnify);
                    ImageSend.Insert(i, bitmap);
                    progress_Done++;
                }
            }
            else
            {
                for (int i = 0; i < progress_Total / 2; i++)
                {
                    String fileName = ImageFileNames[i];
                    Byte[] imageData = TextWorker.ReadinSD(fileName, config.Width, config.Height, config.Useless, config.Front, config.Behind, checkBox_NeedDecode.Checked);
                    ImageData.Insert(i, imageData);
                    Bitmap bitmap = ImageWorker.ImageDraw(imageData, config.Width, config.Height, config.Magnify);
                    ImageSend.Insert(i, bitmap);
                    progress_Done++;
                }
            }

        }

        private void button_Filter_Click(object sender, EventArgs e)
        {
            FilterForm ff = new FilterForm(ref config);
            ff.ShowDialog();
        }

        private void button_Transform_Click(object sender, EventArgs e)
        {
            try
            {
                progress_Done = 0;
                progress_Total = ImageFileNames.Count();
                progressForm = new ProgressForm(this);
                progressForm.SetMaximum();
                backgroundWorker2.RunWorkerAsync();
                progressForm.ShowDialog();
                //dataForm.SetStartPostion(imgForm.Location);
                //dataForm.Show();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void backgroundWorker2_DoWork(object sender, DoWorkEventArgs e)
        {
            String str;
            foreach (String fileName in ImageFileNames)
            {
                Byte[] imageData;
                using (FileStream fs = File.OpenRead(fileName))
                {
                    imageData = new byte[fs.Length];
                    // Read and display lines from the file until the end of 
                    // the file is reached.
                    fs.Read(imageData, 0, imageData.Length);
                }

                str = BitConverter.ToString(imageData);
                str = str.Replace("-", " ");
                using (StreamWriter sw = new StreamWriter(fileName))
                {
                    sw.Write(str);
                }
                progress_Done++;

            }
        }

        private void textBox_ThreadNum_TextChanged(object sender, EventArgs e)
        {
            try
            {
                config.ThreadNum = Convert.ToUInt16(textBox_ThreadNum.Text.ToString());

            }
            catch { }
        }
    }
}
