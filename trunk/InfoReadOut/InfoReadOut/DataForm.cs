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
        List<Data> FormData;
        int Index = 0;
        public DataForm()
        {
            InitializeComponent();
        }

        public void SetStartPostion(Point parentLocation)
        {
            this.Location = new Point(parentLocation.X - this.Size.Width - 10, parentLocation.Y);
        }

        public void DataRefresh(List<Data> _data)
        {
            FormData = _data;
            GC.Collect();
            Index = 0;
            textBox_Data.Text = FormData[0].ToString();
        }

        public void DisplayData(int index)
        {
            Index = index;
            textBox_Data.Text = FormData[Index].ToString();
        }
    }
}
