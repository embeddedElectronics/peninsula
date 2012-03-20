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
        /// <summary>
        /// 设置进度条最大值
        /// </summary>
        public void SetMaximum()
        {
            progressBar1.Maximum = objectForm.progress_Total;
        }
        /// <summary>
        /// 设置进度条当前值
        /// </summary>
        public void SetProBar()
        {
            progressBar1.Value = objectForm.progress_Done;
            if (progressBar1.Value == progressBar1.Maximum)
            {
                this.Close();
            }
        }
        /// <summary>
        /// 设置进度条当前值
        /// </summary>
        /// <param name="progress_Done">当前值</param>
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
            label1.Text = progressBar1.Value.ToString() + @"/" + progressBar1.Maximum.ToString();
        }

    }
}
