using System;
using System.Drawing;
using System.Windows.Forms;
using System.Collections.Generic;


namespace InfoReadOut
{
    public partial class ImageForm : Form
    {
        List<Bitmap> img, imgProc;
        String[] imgFileNames;
        MyConfig config;
        DataForm dataForm;
        int index = 0;
        bool bProc = true, bMoreData = false;
        public ImageForm()
        {
            InitializeComponent();
        }
        public void SetConfig(MyConfig _config, DataForm _dataForm)
        {
            config = _config;
            dataForm = _dataForm;
        }
        /// <summary>
        /// 图像显示刷新
        /// </summary>
        /// <param name="_img">要显示的图像</param>
        public void ImageRefresh(List<Bitmap> _img, List<Bitmap> _imgProc, String[] _imgFileNames)
        {
            img = _img;
            imgProc = _imgProc;
            imgFileNames = _imgFileNames;
            GC.Collect();
            bMoreData = true;
            index = 0;
            pictureBox.Image = imgProc[0];
        }
        /// <summary>
        /// 图像显示刷新
        /// </summary>
        /// <param name="_img">要显示的图像</param>
        public void ImageRefresh(List<Bitmap> _img, String[] _imgFileNames)
        {
            img = _img;
            imgFileNames = _imgFileNames;
            GC.Collect();
            bMoreData = false;
            index = 0;
            pictureBox.Image = img[0];
        }
        private void ImageForm_Shown(object sender, EventArgs e)
        {
            int xWidth = SystemInformation.WorkingArea.Width;//获取屏幕宽度
            int yHeight = SystemInformation.WorkingArea.Height;//高度
            this.Location = new Point((xWidth - this.Size.Width) / 2, (yHeight - this.Size.Height) / 2);//这里需要再减去窗体本身的宽度和高度的一半
            dataForm.SetStartPostion(this.Location);
        }
        private void pictureBox_MouseDown(object sender, MouseEventArgs e)
        {
            Bitmap _img = (Bitmap)pictureBox.Image;
            switch (e.Button)
            {
                case MouseButtons.Left:
                    Point mouse = this.PointToClient(Control.MousePosition);
                    int imgX = (_img.Size.Width - mouse.X) / config.Magnify;
                    int imgY = (_img.Size.Height - mouse.Y) / config.Magnify;
                    Color myColor = _img.GetPixel(mouse.X, mouse.Y);
                    toolTip1.Show(imgX.ToString() + ":" + imgY.ToString() + "\n" +
                        myColor.G.ToString() + ":" + (index + 1).ToString() + "\n" +
                        System.IO.Path.GetFileName(imgFileNames[index]), this.pictureBox);
                    break;
                case MouseButtons.Right:
                    toolTip1.Hide(this);
                    break;
            }
        }
        private void ImageForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.Hide();
            e.Cancel = true;
        }
        /// <summary>
        /// 图像切换
        /// </summary>
        public void ImageSwitch()
        {
            if (bMoreData)
            {
                if (bProc)
                {
                    pictureBox.Image = imgProc[index];
                }
                else
                {
                    pictureBox.Image = img[index];
                }
            }
            else
            {
                pictureBox.Image = img[index];
            }
        }
        private void ImageForm_KeyDown(object sender, KeyEventArgs e)
        {

            switch (e.KeyCode)
            {
                case Keys.Left:
                    if (index > 0)
                    {
                        index--;
                    }
                    break;
                case Keys.Right:
                    if (index < img.Count - 1)
                    {
                        index++;
                    }
                    break;
                case Keys.C:
                    if (bProc == true)
                    {
                        bProc = false;
                    }
                    else
                    {
                        bProc = true;
                    }
                    break;
            }
            dataForm.DisplayData(index);
            ImageSwitch();
        }
    }
}
