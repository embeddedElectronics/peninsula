using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Forms;

namespace InfoReadOut
{
    public partial class MainForm : Form
    {
        public MyConfig config = new MyConfig();
        public List<Bitmap> ImageSend = new List<Bitmap>();
        ImageForm imgForm = new ImageForm();
        ProgressForm progressForm;
        public int progress_Done, progress_Total;
        String[] FileNames;

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
                textBox_Width.Text = config.Width.ToString();
                textBox_Height.Text = config.Height.ToString();
                textBox_Useless.Text = config.Useless.ToString();
                textBox_Front.Text = config.Front.ToString();
                textBox_Behind.Text = config.Behind.ToString();
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
                FileNames = openFileDialog.FileNames;
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
                FileInfo[] selectedFiles = selectedFolder.GetFiles("*.txt");
                int index = selectedFiles.Count();
                FileNames = new String[index];

                while (index > 0)
                {
                    FileNames[index - 1] = selectedFiles[index - 1].FullName;
                    index--;
                }
                button_Show_Click(this, e);
            }
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            config.Width = Convert.ToUInt16(textBox_Width.Text.ToString());
            config.Height = Convert.ToUInt16(textBox_Height.Text.ToString());
            config.Useless = Convert.ToUInt16(textBox_Useless.Text.ToString());
            config.Front = Convert.ToUInt16(textBox_Front.Text.ToString());
            config.Behind = Convert.ToUInt16(textBox_Behind.Text.ToString());
            ConfigWorker.Save(config);
            imgForm.Dispose();
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
                progress_Done = 0;
                progress_Total = FileNames.Count();
                progressForm = new ProgressForm(this);
                progressForm.SetMaximum();
                backgroundWorker1.RunWorkerAsync();
                progressForm.ShowDialog();
                imgForm.ImageRefresh(ImageSend);
                imgForm.Show();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
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
            foreach (String fileName in FileNames)
            {
                Bitmap bitmap = ImageWorker.ImageDraw(
                                   TextWorker.Readin(fileName, config.Width, config.Height, config.Useless, config.Front, config.Behind),
                                   config.Width, config.Height, 6);
                ImageSend.Add(bitmap);
                progress_Done++;

            }

        }
    }
}
