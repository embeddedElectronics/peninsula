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
        public List<Bitmap> ImageProc;
        public List<Byte[]> ImageData;
        public List<Data> MoreData;
        public List<Bitmap>[] ThreadImageSend;
        public List<Bitmap>[] ThreadImageProc;
        public List<Byte[]>[] ThreadImageData;
        public List<Data>[] ThreadMoreData;
        ImageForm imgForm = new ImageForm();
        DataForm dataForm = new DataForm();
        ProgressForm progressForm;
        public int progress_Done, progress_Total;
        int[] ThreadS, ThreadE;     //Tell Thread Where Data Start and End
        String[] ImageFileNames;

        public MainForm()
        {
            InitializeComponent();
            Init();
        }
        #region Config
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
                checkBox_MoreData.Checked = config.MoreData;
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
        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            config.NeedDecode = checkBox_NeedDecode.Checked;
            config.SDFile = checkBox_IsSDFile.Checked;
            config.MoreData = checkBox_MoreData.Checked;
            config.Width = Convert.ToUInt16(textBox_Width.Text.ToString());
            config.Height = Convert.ToUInt16(textBox_Height.Text.ToString());
            config.Useless = Convert.ToUInt16(textBox_Useless.Text.ToString());
            config.Front = Convert.ToUInt16(textBox_Front.Text.ToString());
            config.Behind = Convert.ToUInt16(textBox_Behind.Text.ToString());
            config.ThreadNum = Convert.ToUInt16(textBox_ThreadNum.Text.ToString());
            ConfigWorker.Save(config);
        }
        #endregion

        #region Open

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

        #endregion

        #region Show

        private void button_Show_Click(object sender, EventArgs e)
        {
            try
            {
                ImageProc = new List<Bitmap>();
                ImageSend = new List<Bitmap>();
                ImageData = new List<Byte[]>();
                MoreData = new List<Data>();
                ThreadImageProc = new List<Bitmap>[config.ThreadNum];
                ThreadImageSend = new List<Bitmap>[config.ThreadNum];
                ThreadImageData = new List<Byte[]>[config.ThreadNum];
                ThreadMoreData = new List<Data>[config.ThreadNum];
                Thread _thread = new Thread(ShowThread);

                GC.Collect();
                progress_Done = 0;
                progress_Total = ImageFileNames.Count();
                progressForm = new ProgressForm(this);
                progressForm.SetMaximum();
                ThreadSE();
                _thread.Start();
                progressForm.ShowDialog();
                _thread.Join();
                for (int i = 0; i < config.ThreadNum; i++)
                {
                    ImageSend.AddRange(ThreadImageSend[i]);
                    ImageProc.AddRange(ThreadImageProc[i]);
                    ImageData.AddRange(ThreadImageData[i]);
                    MoreData.AddRange(ThreadMoreData[i]);
                }
                if (checkBox_MoreData.Checked)
                {
                    imgForm.ImageRefresh(ImageSend, ImageProc, ImageFileNames);
                } 
                else
                {
                    imgForm.ImageRefresh(ImageSend, ImageFileNames);
                }
                imgForm.Show();
                dataForm.DataRefresh(MoreData);
                dataForm.Show();

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }
        private void ThreadSE()
        {
            ThreadS = new int[config.ThreadNum];
            ThreadE = new int[config.ThreadNum];
            int c = progress_Total / config.ThreadNum;
            int t = progress_Total % config.ThreadNum;
            ThreadS[0] = 0;
            ThreadE[0] = c + (t > 0 ? 1 : 0) - 1;
            if (ThreadE[0] < (progress_Total - 1))
            {
                for (int i = 1; i < config.ThreadNum; i++)
                {
                    ThreadS[i] = ThreadE[i - 1] + 1;
                    ThreadE[i] = ThreadS[i] + c + (t > i ? 1 : 0) - 1;
                }
            }
            else
            {
                for (int i = 1; i < config.ThreadNum; i++)
                {
                    ThreadS[i] = 0;
                    ThreadE[i] = -1;
                }
            }

        }
        #endregion

        #region ShowThread

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
            int num = (int)data;
            ThreadImageData[num] = new List<Byte[]>();
            ThreadImageSend[num] = new List<Bitmap>();
            ThreadImageProc[num] = new List<Bitmap>();
            ThreadMoreData[num] = new List<Data>();

            if (checkBox_IsSDFile.Checked == false)
            {
                for (int i = ThreadS[num]; i <= ThreadE[num]; i++)
                {
                    String fileName = ImageFileNames[i];
                    Data moreData = new Data(config.Height); Bitmap bitmap;
                    Byte[] imageData = TextWorker.Readin(fileName, config.Width, config.Height, config.Useless, config.Front, config.Behind, checkBox_NeedDecode.Checked);
                    if (checkBox_MoreData.Checked)
                    {
                        moreData = TextWorker.ReadRestInfo(fileName, config.Width, config.Height, checkBox_NeedDecode.Checked);
                        ThreadMoreData[num].Add(moreData);
                    }
                    ThreadImageData[num].Add(imageData);
                    if (checkBox_MoreData.Checked)
                    {
                        bitmap = ImageWorker.ImageDraw(imageData, config.Width, config.Height, config.Magnify, moreData);
                        ThreadImageProc[num].Add(bitmap);
                    }
                    bitmap = ImageWorker.ImageDraw(imageData, config.Width, config.Height, config.Magnify);
                    ThreadImageSend[num].Add(bitmap);
                    progress_Done++;
                }
            }
            else
            {
                for (int i = ThreadS[num]; i <= ThreadE[num]; i++)
                {
                    String fileName = ImageFileNames[i];
                    Data moreData = new Data(config.Height); Bitmap bitmap;
                    Byte[] imageData = TextWorker.ReadinSD(fileName, config.Width, config.Height, config.Useless, config.Front, config.Behind, checkBox_NeedDecode.Checked);
                    if (checkBox_MoreData.Checked)
                    {
                        moreData = TextWorker.ReadRestInfo(fileName, config.Width, config.Height, checkBox_NeedDecode.Checked);
                        ThreadMoreData[num].Add(moreData);
                    }
                    ThreadImageData[num].Add(imageData);
                    if (checkBox_MoreData.Checked)
                    {
                        bitmap = ImageWorker.ImageDraw(imageData, config.Width, config.Height, config.Magnify, moreData);
                        ThreadImageProc[num].Add(bitmap);
                    }
                    bitmap = ImageWorker.ImageDraw(imageData, config.Width, config.Height, config.Magnify);
                    ThreadImageSend[num].Add(bitmap);
                    progress_Done++;
                }
            }
        }
        #endregion

        #region OtherProcess

        private void MainForm_Load(object sender, EventArgs e)
        {
            int xWidth = SystemInformation.WorkingArea.Width;//获取屏幕宽度
            int yHeight = SystemInformation.WorkingArea.Height;//高度
            this.Location = new Point(xWidth - this.Size.Width, yHeight - this.Size.Height);
            imgForm.SetConfig(config, dataForm);
        }

        private void button_Filter_Click(object sender, EventArgs e)
        {
            FilterForm ff = new FilterForm(ref config);
            ff.ShowDialog();
        }

        #endregion

        #region TransformData

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
                    imageData = new byte[config.Width * config.Height / 8];
                    // Read and display lines from the file until the end of 
                    // the file is reached.
                    fs.Read(imageData, 0, imageData.Length);
                }

                str = BitConverter.ToString(imageData);
                str = str.Replace("-", " ");
                using (StreamWriter sw = new StreamWriter("IF" + fileName))
                {
                    sw.Write(str);
                }
                progress_Done++;

            }
        }

        #endregion

        #region TextBoxProcess

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

        private void textBox_ThreadNum_TextChanged(object sender, EventArgs e)
        {
            try
            {
                config.ThreadNum = Convert.ToUInt16(textBox_ThreadNum.Text.ToString());

            }
            catch { }
        }
        #endregion
    }
}
