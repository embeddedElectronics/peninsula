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
    public partial class FilterForm : Form
    {
        MyConfig mc;
        public FilterForm(ref MyConfig _mc)
        {
            InitializeComponent();
            mc = _mc;
        }

        private void FilterForm_Load(object sender, EventArgs e)
        {
            textBox_ImageFile.Text = mc.Filter_ImageFile;
            textBox_DataFile.Text = mc.Filter_DataFile;
        }

        private void FilterForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            mc.Filter_ImageFile = textBox_ImageFile.Text;
            mc.Filter_DataFile = textBox_DataFile.Text;
        }
    }
}
