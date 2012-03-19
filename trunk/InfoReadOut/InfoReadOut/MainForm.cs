using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace InfoReadOut
{
    public partial class MainForm : Form
    {
        public MyConfig config = new MyConfig();
        public Bitmap ImageSend;

        public MainForm()
        {
            InitializeComponent();
            Init();
        }
        public void Init()
        {
            if (ConfigWorker.FileDetect() == ConfigWorker.States.Exception)
            {
                ConfigWorker.CreatNew(ref config);
            }
            if (ConfigWorker.Load(ref config) == ConfigWorker.States.OK)
            {
                openFileDialog.InitialDirectory = config.FolderPath;
                folderBrowserDialog.SelectedPath = config.FolderPath;
                textBox_Width.Text = config.Width.ToString();
                textBox_Height.Text = config.Height.ToString();
                textBox_Useless.Text = config.Useless.ToString();
                textBox_Front.Text = config.Front.ToString();
                textBox_Behind.Text = config.Behind.ToString();
            }
            
        }
        private void button_OpenFile_Click(object sender, EventArgs e)
        {
            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {

                MessageBox.Show(openFileDialog.FileName);
                config.FolderPath = System.IO.Path.GetDirectoryName(openFileDialog.FileName);
                ImageSend = ImageWorker.ImageDraw(
                    TextWorker.Readin(openFileDialog.FileName, config.Width, config.Height, config.Front, config.Behind),
                    config.Width, config.Height,6);
            }

        }

        private void button_OpenFolder_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                MessageBox.Show(folderBrowserDialog.SelectedPath);
                config.FolderPath = folderBrowserDialog.SelectedPath;
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
            ImageForm imgForm = new ImageForm(ImageSend);
            imgForm.Show();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            int xWidth = SystemInformation.WorkingArea.Width;//获取屏幕宽度
            int yHeight = SystemInformation.WorkingArea.Height;//高度
            this.Location = new Point(xWidth - this.Size.Width, yHeight - this.Size.Height);//这里需要再减去窗体本身的宽度和高度的一半
            this.Show();
        }
    }
}
