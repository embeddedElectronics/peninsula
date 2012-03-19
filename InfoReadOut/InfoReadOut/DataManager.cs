using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace InfoReadOut
{
    public class DataManager
    {
        public static void BitmapSave(Bitmap _toSave, String _fileName)
        {
            _toSave.Save(_fileName);
        }
    }
}
