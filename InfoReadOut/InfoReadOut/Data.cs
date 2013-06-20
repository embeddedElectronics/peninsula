using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace InfoReadOut
{
    public class Data
    {
        public int[,] BlackL, BlackR;
        public int[] BlackLine, A;
        public Int16[] AT;
        public Int32 SPD, SPT;
        public Data(int height)
        {
            BlackL = new int[height, 2];
            BlackR = new int[height, 2];
            BlackLine = new int[height];
            A = new Int32[3];
            AT = new Int16[3];
        }
        public override String ToString()
        {
            String temp = "";

            temp += "Accelerometer:";
            foreach (Int64 i in this.A)
            {
                temp += String.Format(" {0}", i);
            }
            temp += "\r\nGyro:";
            foreach (Int64 i in this.AT)
            {
                temp += String.Format(" {0}", i);
            }
            temp += String.Format("\r\nVelocimetry:{0} Motor:{1}", this.SPD, this.SPT);
            return temp;
        }
    }
}
