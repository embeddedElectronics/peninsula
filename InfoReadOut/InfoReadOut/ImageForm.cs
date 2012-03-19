using System;
using System.Drawing;
using System.Windows.Forms;


namespace InfoReadOut
{
    public partial class ImageForm : Form
    {
        Bitmap img;
        public ImageForm()
        {
            InitializeComponent();
        }
        /// <summary>
        /// 图像显示刷新
        /// </summary>
        /// <param name="_img">要显示的图像</param>
        public void ImageRefresh(Bitmap _img)
        {
            img = _img;
            pictureBox.Image = img;
        }
        private void ImageForm_Shown(object sender, EventArgs e)
        {
            int xWidth = SystemInformation.WorkingArea.Width;//获取屏幕宽度
            int yHeight = SystemInformation.WorkingArea.Height;//高度
            this.Location = new Point((xWidth - this.Size.Width) / 2, (yHeight - this.Size.Height) / 2);//这里需要再减去窗体本身的宽度和高度的一半
        }
        private void pictureBox_MouseDown(object sender, MouseEventArgs e)
        {
            Point mouse = this.PointToClient(Control.MousePosition);
            int imgX = mouse.X / 6;
            int imgY = mouse.Y / 6;
            Color myColor = img.GetPixel(mouse.X, mouse.Y);
            toolTip1.Show(imgX.ToString() + ":" + imgY.ToString() + ":" + myColor.G.ToString(), this.pictureBox);
        }

        private void pictureBox_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            toolTip1.Hide(this);
        }

        private void ImageForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.Hide();
        }
    }
}
