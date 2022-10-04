using System;
using System.Linq;
using System.Threading;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;

class Program
{ 

    static void Main(string[] args)
    {
        //dcpr.main.Connector("init");
        string[] argsN = new string[] { "martin on Reaper" , "1", "tempMissionMP", "Competitor" , "1" , "1" };
        dcpr.main.Connector("init");
        Thread.Sleep(10000);
        test("missionstart", argsN);
        Thread.Sleep(10000);
        test("updateScore", new string[] { "10", "3" });
    }

    static void test(string function, string[] args)
    {
        StringBuilder output = new StringBuilder();
        output.Append(function + ";");
        string[] argsNew = new string[args.Length];
        for (int i = 0; i < args.Length; i++)
        {
            string transform = args[i].Replace("\"", string.Empty);
            argsNew[i] = transform;
            output.Append(transform + ";");
        }
        dcpr.main.Connector(function, args);
        Console.WriteLine(output);
    }
}
