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
    public partial class ProgressForm : Form
    {
        MainForm objectForm;
        public ProgressForm(MainForm _objectForm)
        {
            InitializeComponent();
            objectForm = _objectForm;
        }
        public void SetMaximum()
        {
            progressBar1.Maximum = objectForm.progress_Total;
        }
        public void SetProBar()
        {
            progressBar1.Value = objectForm.progress_Done;
            if (progressBar1.Value == progressBar1.Maximum)
            {
                this.Close();
            }
        }
        public void SetProBar(int progress_Done)
        {
            progressBar1.Value = progress_Done;
            if (progressBar1.Value == progressBar1.Maximum)
            {
                this.Close();
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            SetProBar();
        }
    }
}
