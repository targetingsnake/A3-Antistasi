using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;

namespace dcpr
{
    public static class State
    {
        static State()
        {
            KDA i_kda = new KDA
            {
                Assists = 0,
                Death = 0,
                Kills = 0
            };
            i_server = new Server
            {
                displayName = false,
                Name = "",
                missionName = "",
                roleDescription = "",
                slotCount = 0,
                currentPlayerCount = 0,
                joinTime = (int)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds,
                stats = i_kda,
                id = "",
                isUncon = false,
                isDead = false
            };
            i_editor = new Editor
            {
                scenarioName = "",
                testing = false
            };
            i_clientState = clientStarting;
        }
        public struct KDA
        {
            public int Kills;
            public int Death;
            public int Assists;
        }
        public struct Server
        {
            public bool displayName;
            public string Name;
            public string missionName;
            public string roleDescription;
            public int slotCount;
            public int currentPlayerCount;
            public int joinTime;
            public bool isUncon;
            public bool isDead;
            public string id;
            public KDA stats;
        }
        public struct Editor
        {
            public string scenarioName;
            public bool testing;
        }

        private static int i_clientState;
        private static Editor i_editor;
        private static Server i_server;
        public const int clientStarting = 0;
        public const int clientInMenu = 1;
        public const int clientOnServer = 2;
        public const int clientInEditor = 3;
        public static Server server
        {
            get
            {
                return i_server;
            }
        }
        public static int clientState
        {
            get
            {
                return i_clientState;
            }
        }
        public static void setServer(string[] input)
        {
            bool displayName = input[1] == "1";
            int slotCount = 0;
            int maxSlot = 0;
            if (Int32.TryParse(input[4], out int sC))
            {
                slotCount = sC;
            }
            if (Int32.TryParse(input[5], out int cp))
            {
                maxSlot = cp;
            }
            setServer(input[0], displayName, input[2], input[3], slotCount, maxSlot);

        }
        public static void setServer(string name, bool displayName, string missionName, string roleName, int slotCount, int playercount)
        {
            i_server.joinTime = (int)DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;
            i_server.displayName = displayName;
            i_server.Name = name;
            i_server.missionName = missionName;
            i_server.roleDescription = roleName;
            i_server.slotCount = slotCount;
            i_server.currentPlayerCount = playercount;
            i_server.stats.Kills = 0;
            i_server.stats.Assists = 0;
            i_server.stats.Death = 0;
            using (SHA512 sha512hash = SHA512.Create())
            {
                i_server.id = GetHash(sha512hash, name + missionName);
            }
            if (i_clientState != clientInEditor)
            {
                i_clientState = clientOnServer;
            }
        }

        private static string GetHash(HashAlgorithm hashAlgorithm, string input)
        {

            // Convert the input string to a byte array and compute the hash.
            byte[] data = hashAlgorithm.ComputeHash(Encoding.UTF8.GetBytes(input));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            var sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }
        public static void updatePlayercount(string[] args)
        {
            int players = 0;
            if (int.TryParse(args[0], out players))
            {
                i_server.currentPlayerCount = players;
            }
        }
        public static void updatePlayercount(int playercount)
        {
            i_server.currentPlayerCount = playercount;
        }
        public static void updateScore(string[] killsAndDeath)
        {
            int kills = 0;
            int death = 0;
            if (int.TryParse(killsAndDeath[0], out kills))
            {
                i_server.stats.Kills = kills;
            }
            if (int.TryParse(killsAndDeath[1], out death))
            {
                i_server.stats.Death = death;
            }
        }
        public static void updateScore(int kills, int death)
        {
            i_server.stats.Kills = kills;
            i_server.stats.Death = death;
        }
        public static void addAssist()
        {
            i_server.stats.Assists += 1;
        }
        public static void leaveServer()
        {
            i_clientState = clientInMenu;
        }
        public static void leaveEditor()
        {
            i_clientState = clientInMenu;
        }
        public static void startTesting()
        {
            i_editor.testing = true;
        }
        public static void endTesting()
        {
            i_editor.testing = false;
        }
        public static bool setUnconState
        {
            set
            {
                i_server.isUncon = value;
            }
        }
        public static bool setDeathState

        {
            set
            {
                i_server.isDead = value;
            }            
        }
        public static bool setTest
        {
            set
            {
                i_editor.testing = value;
            }
        }
        public static void inMenu()
        {
            i_clientState = clientInMenu;
        }
    }
}
