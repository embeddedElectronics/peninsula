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
    public partial class DataForm : Form
    {
        public DataForm()
        {
            InitializeComponent();
        }

        public void SetStartPostion(Point parentLocation)
        {
            this.Location = new Point(parentLocation.X - this.Size.Width - 10, parentLocation.Y);
        }
    }
}
