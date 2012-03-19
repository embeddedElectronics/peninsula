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
    public partial class ImageForm : Form
    {
        Bitmap img;
        public ImageForm(Bitmap _img)
        {
            InitializeComponent();
            img = _img;
        }

        private void ImageForm_Load(object sender, EventArgs e)
        {
            pictureBox.Image = img;
        }
    }
}
