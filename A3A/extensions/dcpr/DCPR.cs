#if ARMA

using System;
using System.Text;
using System.Runtime.InteropServices;
using RGiesecke.DllExport;
using System.Collections.Generic;

namespace dcpr
{
    class exports
    {

        public static ExtensionCallback callback;
        public delegate int ExtensionCallback([MarshalAs(UnmanagedType.LPStr)] string name, [MarshalAs(UnmanagedType.LPStr)] string function, [MarshalAs(UnmanagedType.LPStr)] string data);

#if WIN64
        [DllExport("RVExtensionRegisterCallback", CallingConvention = CallingConvention.Winapi)]
#else
		[DllExport("_RVExtensionRegisterCallback@4", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RVExtensionRegisterCallback([MarshalAs(UnmanagedType.FunctionPtr)] ExtensionCallback func)
        {
            callback = func;
        }

#if WIN64
        [DllExport("RVExtensionVersion", CallingConvention = CallingConvention.Winapi)]
#else
    [DllExport("_RVExtensionVersion@8", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RvExtensionVersion(StringBuilder output, int outputSize)
        {
            output.Append("Test-Extension v1.0");
        }

#if WIN64
        [DllExport("RVExtension", CallingConvention = CallingConvention.Winapi)]
#else
		[DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
#endif
        public static void RvExtension(StringBuilder output, int outputSize,
            [MarshalAs(UnmanagedType.LPStr)] string function)
        {
            main.Connector(function);
            output.Append(function);
        }

#if WIN64
        [DllExport("RVExtensionArgs", CallingConvention = CallingConvention.Winapi)]
#else
		[DllExport("_RVExtensionArgs@20", CallingConvention = CallingConvention.Winapi)]
#endif
        public static int RvExtensionArgs(StringBuilder output, int outputSize,
            [MarshalAs(UnmanagedType.LPStr)] string function,
            [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.LPStr, SizeParamIndex = 4)] string[] args, int argCount)
        {
            output.Append(function + ";");
            string[] argsNew = new string[args.Length];
            for (int i = 0; i < args.Length; i++)
            {
                string transform = args[i].Replace("\"", string.Empty);
                argsNew[i] = transform;
                output.Append(transform + ";");
            }
            main.Connector(function, argsNew);

            return 0;
        }
    }
}
#endif