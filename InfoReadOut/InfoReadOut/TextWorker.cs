using System;
using System.IO;
using System.Globalization;
using System.Collections.Generic;

namespace InfoReadOut
{
    public class TextWorker
    {
        #region Read

        /// <summary>  
        /// 图像信息读入(+2重载)
        /// </summary>  
        /// <param name="_fileName">文件名</param>  
        /// <param name="_width">图像的宽</param>  
        /// <param name="_height">图像的高</param> 
        /// <param name="_useless">无用字符消除</param>
        /// <param name="_front">首行缩进</param>  
        /// <param name="_behind">尾行缩进</param>  
        /// <returns>得到的byte数组</returns>   
        public static byte[] Readin(String _fileName, UInt16 _width, UInt16 _height, UInt16 _useless, UInt16 _front, UInt16 _behind)
        {
            try
            {
                // Create an instance of StreamReader to read from a file.
                // The using statement also closes the StreamReader.
                using (StreamReader sr = new StreamReader(_fileName))
                {
                    String line, info = "";
                    // Read and display lines from the file until the end of 
                    // the file is reached.
                    while ((line = sr.ReadLine()) != null)
                    {
                        if (_useless != 0)
                        {
                            _useless--;
                        }
                        else
                        {
                            info += UsefulReadout(line, _front, _behind) + " ";
                        }

                    }
                    return ConvertInfo(info, _width, _height);
                }
            }
            catch (Exception e)
            {
                // Let the user know what went wrong.
                MessageSender.e = e;
                return new byte[1];
            }
        }
        /// <summary>  
        /// 图像信息读入(+2重载)
        /// </summary>  
        /// <param name="_fileName">文件名</param>  
        /// <param name="_width">图像的宽</param>  
        /// <param name="_height">图像的高</param> 
        /// <param name="_useless">无用字符消除</param>
        /// <param name="_front">首行缩进</param>  
        /// <param name="_behind">尾行缩进</param>  
        /// <param name="_needDecode">需要解码</param>
        /// <returns>得到的byte数组</returns>   
        public static byte[] Readin(String _fileName, UInt16 _width, UInt16 _height, UInt16 _useless, UInt16 _front, UInt16 _behind, Boolean _needDecode)
        {
            try
            {
                // Create an instance of StreamReader to read from a file.
                // The using statement also closes the StreamReader.
                using (StreamReader sr = new StreamReader(_fileName))
                {
                    String line, info = "";
                    // Read and display lines from the file until the end of 
                    // the file is reached.
                    while ((line = sr.ReadLine()) != null)
                    {
                        if (_useless != 0)
                        {
                            _useless--;
                        }
                        else
                        {
                            info += UsefulReadout(line, _front, _behind) + " ";
                        }

                    }
                    return ConvertInfo(info, _width, _height, _needDecode);
                }
            }
            catch (Exception e)
            {
                // Let the user know what went wrong.
                MessageSender.e = e;
                return new byte[1];
            }
        }
        /// <summary>  
        /// 图像信息读入
        /// </summary>  
        /// <param name="_fileName">文件名</param>  
        /// <param name="_width">图像的宽</param>  
        /// <param name="_height">图像的高</param> 
        /// <param name="_useless">无用字符消除</param>
        /// <param name="_front">首行缩进</param>  
        /// <param name="_behind">尾行缩进</param>  
        /// <param name="_needDecode">需要解码</param>
        /// <returns>得到的byte数组</returns>   
        public static byte[] ReadinSD(String _fileName, UInt16 _width, UInt16 _height, UInt16 _useless, UInt16 _front, UInt16 _behind, Boolean _needDecode)
        {
            try
            {
                // Create an instance of StreamReader to read from a file.
                // The using statement also closes the StreamReader.
                using (FileStream fs = File.OpenRead(_fileName))
                {
                    byte[] data;
                    if (_needDecode)
                    {
                        data = new byte[_width * _height / 8];
                    }
                    else
                    {
                        data = new byte[_width * _height];
                    }
                    // Read and display lines from the file until the end of 
                    // the file is reached.
                    fs.Read(data, 0, data.Length);
                    return ConvertInfo(data, _width, _height, _needDecode);
                }
            }
            catch (Exception e)
            {
                // Let the user know what went wrong.
                MessageSender.e = e;
                return new byte[1];
            }
        }

        public static Data ReadRestInfo(String _fileName, UInt16 _width, UInt16 _height, Boolean _needDecode)
        {
            Data d = new Data(_height);
            try
            {
                using (FileStream fs = File.OpenRead(_fileName))
                {
                    int startPos;
                    if (_needDecode)
                    {
                        startPos = _width * _height / 8;
                    }
                    else
                    {
                        startPos = _width * _height;
                    }
                    Byte[] data = new Byte[fs.Length - startPos];

                    fs.Seek(startPos, SeekOrigin.Begin);
                    fs.Read(data, 0, data.Length);

                    for (int i = 0; i < data.Length; i++)
                    {
                        if (i < _height * 2)
                        {
                            d.BlackR[i / 2, 0] = data[i];
                            d.BlackR[i / 2, 1] = data[i + 1];
                            i++;
                        }
                        else
                        {
                            if (i < _height * 4)
                            {
                                d.BlackL[i / 2 - _height, 0] = data[i];
                                d.BlackL[i / 2 - _height, 1] = data[i + 1];
                                i++;
                            }
                            else
                            {
                                if (i < _height * 5)
                                {
                                    d.BlackLine[i - _height * 4] = data[i];
                                }
                                else
                                {
                                    if (i < _height * 5 + 12)
                                    {
                                        d.A[0] = (Int32)(data[i] | (data[i + 1] << 8) | (data[i + 2] << 16) | (data[i + 3] << 24));
                                        i += 4;
                                        d.A[1] = (Int32)(data[i] | (data[i + 1] << 8) | (data[i + 2] << 16) | (data[i + 3] << 24));
                                        i += 4;
                                        d.A[2] = (Int32)(data[i] | (data[i + 1] << 8) | (data[i + 2] << 16) | (data[i + 3] << 24));
                                        i += 4;
                                    }
                                    else
                                    {
                                        if (i < _height * 5 + 24)
                                        {
                                            d.AT[0] = (Int16)(data[i] | (data[i + 1] << 8));
                                            i += 4;
                                            d.AT[1] = (Int16)(data[i] | (data[i + 1] << 8));
                                            i += 4;
                                            d.AT[2] = (Int16)(data[i] | (data[i + 1] << 8));
                                            i += 4;
                                        }
                                        else
                                        {
                                            if (i < _height * 5 + 28)
                                            {
                                                d.SPD = (Int32)(data[i] | (data[i + 1] << 8) | (data[i + 2] << 16) | (data[i + 3] << 24));
                                                i += 4;
                                            }
                                            else
                                            {
                                                if (i < _height * 5 + 32)
                                                {
                                                    d.SPT = (Int32)(data[i] | (data[i + 1] << 8) | (data[i + 2] << 16) | (data[i + 3] << 24));
                                                    i += 4;
                                                }
                                                else
                                                {
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
            }
            return d;
        }
        #endregion

        /// <summary>  
        /// 将有用的图像信息提取
        /// </summary>  
        /// <param name="_line">一行字符串</param>  
        /// <param name="_front">首行缩进</param>  
        /// <param name="_behind">尾行缩进</param>  
        /// <returns>处理过的字符串</returns>  
        private static String UsefulReadout(String _line, UInt16 _front, UInt16 _behind)
        {
            try
            {
                if (_line != "")
                {
                    _line = _line.Substring(_front);
                    _line = _line.Substring(0, _line.Length - _behind);
                    _line = _line.TrimEnd(" ".ToCharArray());
                }

            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
            }

            return _line;
        }

        #region ConvertInfo
        /// <summary>  
        /// 字符串转换成数值(+1重载)
        /// </summary>  
        /// <param name="_info">字符串</param>  
        /// <param name="_width">图像的宽</param>  
        /// <param name="_height">图像的高</param>  
        /// <returns>得到的byte数组</returns>  
        private static byte[] ConvertInfo(String _info, UInt16 _width, UInt16 _height)
        {
            byte[] bytearray = new byte[_width * _height];
            UInt16 hex, width = _width, height = _height;
            String debug;
            try
            {

                foreach (String s in _info.Split(' '))
                {
                    debug = s;
                    if (s != "")
                    {
                        hex = UInt16.Parse(s, NumberStyles.HexNumber);
                        bytearray[width + (height - 1) * _width - 1] = Convert.ToByte(hex);
                        width--;
                        if (width == 0)
                        {
                            width = _width;
                            height--;
                        }
                        if (_height == 0)
                        {
                            break;
                        }
                    }

                }


            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
            }
            return bytearray;
        }
        /// <summary>  
        /// 字符串转换成数值(+1重载)
        /// </summary>  
        /// <param name="_info">字符串</param>  
        /// <param name="_width">图像的宽</param>  
        /// <param name="_height">图像的高</param> 
        /// <param name="_needDecode">需要解码</param>
        /// <returns>得到的byte数组</returns>  
        private static byte[] ConvertInfo(String _info, UInt16 _width, UInt16 _height, Boolean _needDecode)
        {
            byte[] bytearray = new byte[_width * _height];
            UInt16 hex, width = _width, height = _height;
            String debug;
            try
            {

                foreach (String s in _info.Split(' '))
                {
                    debug = s;
                    if (s != "")
                    {
                        hex = UInt16.Parse(s, NumberStyles.HexNumber);
                        if (_needDecode)
                        {
                            foreach (UInt16 _hex in Decode(hex))
                            {
                                bytearray[width + (height - 1) * _width - 1] = Convert.ToByte(_hex);
                                width--;
                                if (width == 0)
                                {
                                    width = _width;
                                    height--;
                                }
                                if (_height == 0)
                                {
                                    break;
                                }
                            }
                        }
                        else
                        {
                            bytearray[width + (height - 1) * _width - 1] = Convert.ToByte(hex);
                            width--;
                            if (width == 0)
                            {
                                width = _width;
                                height--;
                            }
                            if (_height == 0)
                            {
                                break;
                            }
                        }
                    }

                }


            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
            }
            return bytearray;
        }
        /// <summary>  
        /// Byte转换成数值
        /// </summary>  
        /// <param name="_info">字符串</param>  
        /// <param name="_width">图像的宽</param>  
        /// <param name="_height">图像的高</param> 
        /// <param name="_needDecode">需要解码</param>
        /// <returns>得到的byte数组</returns>  
        private static byte[] ConvertInfo(Byte[] _info, UInt16 _width, UInt16 _height, Boolean _needDecode)
        {
            byte[] bytearray = new byte[_width * _height];
            UInt16 hex, width = _width, height = _height;
            try
            {

                foreach (Byte b in _info)
                {
                    hex = b;
                    if (_needDecode)
                    {
                        foreach (UInt16 _hex in Decode(hex))
                        {
                            bytearray[width + (height - 1) * _width - 1] = Convert.ToByte(_hex);
                            width--;
                            if (width == 0)
                            {
                                width = _width;
                                height--;
                            }
                            if (_height == 0)
                            {
                                break;
                            }
                        }
                    }
                    else
                    {
                        bytearray[width + (height - 1) * _width - 1] = Convert.ToByte(hex);
                        width--;
                        if (width == 0)
                        {
                            width = _width;
                            height--;
                        }
                        if (_height == 0)
                        {
                            break;
                        }
                    }


                }


            }
            catch (System.Exception ex)
            {
                MessageSender.e = ex;
            }
            return bytearray;
        }
        #endregion

        private static UInt16[] Decode(UInt16 _info)
        {
            UInt16[] info = new UInt16[8];
            for (int i = 0; i < 8; i++)
            {
                if ((_info & Convert.ToUInt16(1)) == 1)
                {
                    info[i] = 255;
                }
                else
                {
                    info[i] = 0;
                }
                _info = (UInt16)(_info >> 1);
            }
            return info;
        }
        public static void WriteOut()
        {

        }

    }
}
