using System;
using System.Drawing;
using System.Windows.Forms;
using System.Collections.Generic;


namespace InfoReadOut
{
    public partial class ImageForm : Form
    {
        List<Bitmap> img;
        int index = 0;
        public ImageForm()
        {
            InitializeComponent();
        }
        /// <summary>
        /// 图像显示刷新
        /// </summary>
        /// <param name="_img">要显示的图像</param>
        public void ImageRefresh(List<Bitmap> _img)
        {
            img = _img;
            pictureBox.Image = img[0];
        }
        private void ImageForm_Shown(object sender, EventArgs e)
        {
            int xWidth = SystemInformation.WorkingArea.Width;//获取屏幕宽度
            int yHeight = SystemInformation.WorkingArea.Height;//高度
            this.Location = new Point((xWidth - this.Size.Width) / 2, (yHeight - this.Size.Height) / 2);//这里需要再减去窗体本身的宽度和高度的一半
        }
        private void pictureBox_MouseDown(object sender, MouseEventArgs e)
        {
            Bitmap _img = (Bitmap)pictureBox.Image;
            switch (e.Button)
            {
                case MouseButtons.Left:
                    Point mouse = this.PointToClient(Control.MousePosition);
                    int imgX = (_img.Size.Width - mouse.X) / 6;
                    int imgY = (_img.Size.Height - mouse.Y) / 6;
                    Color myColor = _img.GetPixel(mouse.X, mouse.Y);
                    toolTip1.Show(imgX.ToString() + ":" + imgY.ToString() + ":" + myColor.G.ToString(), this.pictureBox);
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
        public void ImageSwitch()
        {
            pictureBox.Image = img[index];
        }
        private void ImageForm_KeyDown(object sender, KeyEventArgs e)
        {
            
            switch (e.KeyCode)
            {
                case Keys.Left:
                    if (index>0)
                    {
                        index--;
                    }
            	    break;
                case Keys.Right:
                    if (index < img.Count-1)
                    {
                        index++;
                    }
                    break;
            }
            ImageSwitch();
        }
    }
}
