using System;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Diagnostics;

namespace dcpr
{
    static class main
    {
        static main()
        {
            que = new ConcurrentQueue<string>();
            queArgs = new ConcurrentQueue<CommandAndArgument>();
            discordpresence = new Discord.Activity
            {
                State = "Starting Arma",
                Instance = false
            };
            t = new Thread(new ThreadStart(ThreadLoop));
            t.Start();
        }
        private static Thread t;
        private static ConcurrentQueue<string> que;
        private static ConcurrentQueue<CommandAndArgument> queArgs;
        private static Discord.Discord discord;
        private static Discord.Activity discordpresence;
        public static string AssetLargeImage = "antistasi_the_mod_1024";
        private struct CommandAndArgument
        {
            public string command;
            public string[] args;
        }
        private static void UpdateActivity()
        {
            var activityManager = discord.GetActivityManager();
            var lobbyManager = discord.GetLobbyManager();


            activityManager.UpdateActivity(discordpresence, result =>
            {
                Console.WriteLine("Update Activity {0}", result);
            });
        }
        public static void ThreadLoop()
        {
            bool changed = false;
            bool discordDetected = false;
            bool discordRunning = true;
            while (true)
            {
                if (main.discordRunning())
                {
                    discordDetected = true;
                }
                else
                {
                    changed = true;
                }
                if (discordDetected)
                {
                    try
                    {
                        if (changed && !discordRunning)
                        {
                            Thread.Sleep(60000); // wait for discord to start so discord don't closes the application
                            changed = false;
                        }
                        runDiscord(true);
                    }
                    catch
                    {
                        discordRunning = false;
                    }
                }
                else
                {
                    Console.WriteLine("test");
                    checkQuesForUpdate(false);
                }
                changed = true;
                discordDetected = false;
                Thread.Sleep(1000 / 60);
            }

        }

        private static bool discordRunning()
        {
            Process[] procs = Process.GetProcesses();
            foreach (Process p in procs)
            {
                if (p.ProcessName.IndexOf("discord", StringComparison.InvariantCultureIgnoreCase) >= 0)
                {
                    return true;
                }
            }
            return false;

        }
        private static void checkQuesForUpdate()
        {
            checkQuesForUpdate(true);
        }
        private static void checkQuesForUpdate(bool UpdateDC)
        {
            if (que.TryDequeue(out string s))
            {
                preConfiguration(s, UpdateDC);
            }
            if (queArgs.TryDequeue(out CommandAndArgument t))
            {
                preConfigureAR(t.command, t.args, UpdateDC);
            }
        }
        private static void runDiscord()
        {
            runDiscord(false);
        }
        private static void runDiscord(bool forceUpdate)
        {
            var clientID = Environment.GetEnvironmentVariable("DISCORD_CLIENT_ID");
            if (clientID == null)
            {
                clientID = "1024314409482452992";
            }
            discord = new Discord.Discord(Int64.Parse(clientID), (UInt64)Discord.CreateFlags.Default);
            discord.SetLogHook(Discord.LogLevel.Debug, (level, message) =>
            {
                Console.WriteLine("Log[{0}] {1}", level, message);
            });

            var applicationManager = discord.GetApplicationManager();
            // Get the current locale. This can be used to determine what text or audio the user wants.
            Console.WriteLine("Current Locale: {0}", applicationManager.GetCurrentLocale());
            // Get the current branch. For example alpha or beta.
            Console.WriteLine("Current Branch: {0}", applicationManager.GetCurrentBranch());

            var activityManager = discord.GetActivityManager();

            // This is used to register the game in the registry such that Discord can find it.
            // This is only needed by games acquired from other platforms, like Steam.
            // activityManager.RegisterCommand();

            var userManager = discord.GetUserManager();
            // The auth manager fires events as information about the current user changes.
            // This event will fire once on init.
            //
            // GetCurrentUser will error until this fires once.
            userManager.OnCurrentUserUpdate += () =>
            {
                var currentUser = userManager.GetCurrentUser();
                Console.WriteLine(currentUser.Username);
                Console.WriteLine(currentUser.Id);
            };
            // If you store Discord user ids in a central place like a leaderboard and want to render them.
            // The users manager can be used to fetch arbitrary Discord users. This only provides basic
            // information and does not automatically update like relationships.

            var relationshipManager = discord.GetRelationshipManager();
            // It is important to assign this handle right away to get the initial relationships refresh.
            // This callback will only be fired when the whole list is initially loaded or was reset

            // All following relationship updates are delivered individually.
            // These are fired when a user gets a new friend, removes a friend, or a relationship's presence changes.
            relationshipManager.OnRelationshipUpdate += (ref Discord.Relationship r) =>
            {
                Console.WriteLine("relationship updated: {0} {1} {2} {3}", r.Type, r.User.Username, r.Presence.Status, r.Presence.Activity.Name);
            };
            if (forceUpdate)
            {
                updateDCPresence();
            }
            // Pump the event look to ensure all callbacks continue to get fired.
            try
            {
                while (true)
                {
                    discord.RunCallbacks();
                    checkQuesForUpdate();
                    Thread.Sleep(1000 / 60);
                }
            }
            finally
            {
                discord.Dispose();
            }
        }

        private static void preConfigureAR(string s, string[] args)
        {
            preConfigureAR(s, args, true);
        }
        private static void preConfigureAR(string s, string[] args, bool UpdateDC)
        {
            bool update = true;
            switch (s.ToLower())
            {
                case "init":
                    break;
                case "missionstart":
                    State.setUnconState = false;
                    State.setDeathState = false;
                    State.setServer(args);
                    break;
                case "missionend":
                case "editorend":
                case "menu":
                    State.inMenu();
                    break;
                case "editorstart":
                    break;
                case "teststart":
                    State.setTest = true;
                    break;
                case "testend":
                    State.setTest = false;
                    break;
                case "uncon":
                    State.setUnconState = true;
                    break;
                case "respawn":
                    State.setDeathState = false;
                    break;
                case "died":
                    State.setDeathState = true;
                    break;
                case "wakeup":
                    State.setUnconState = false;
                    break;
                case "updatescore":
                    State.updateScore(args);
                    break;
                case "updateassist":
                    State.addAssist();
                    break;
                case "updateplayercount":
                    State.updatePlayercount(args);
                    break;
                default:
                    update = false;
                    break;
            }
            if (update && UpdateDC)
            {
                updateDCPresence();
            }
        }
        private static void preConfiguration(string s)
        {
            preConfiguration(s, true);
        }
        private static void preConfiguration(string s, bool Update)
        {
            string switchKey = s;
            string[] expands = new string[] { };
            if (s.Contains("@@@"))
            {
                expands = s.Split(new string[] { "@@@" }, StringSplitOptions.None);
                switchKey = expands[0];
                preConfigureAR(switchKey, expands.Where((val, idx) => idx != 0).ToArray(), Update);
            }
            else
            {
                preConfigureAR(switchKey, new string[] { }, Update);
            }
        }

        private static void updateDCPresence()
        {
            switch (State.clientState)
            {
                case State.clientStarting:
                    discordpresence = new Discord.Activity
                    {
                        State = "Starting Arma 3",
                        Instance = false,
                        Assets =
                            {
                                LargeImage = AssetLargeImage,
                                LargeText = "Antistasi - The Mod"
                            }
                    };
                    break;
                case State.clientInMenu:
                    discordpresence = new Discord.Activity
                    {
                        State = "In Menus",
                        Instance = false,
                        Assets =
                            {
                                LargeImage = AssetLargeImage,
                                LargeText = "Antistasi - The Mod"
                            }
                    };
                    break;
                case State.clientOnServer:
                    playOnServer();
                    break;
                case State.clientInEditor:
                    discordpresence = new Discord.Activity
                    {
                        State = "In Menus",
                        Instance = false,
                        Assets =
                            {
                                LargeImage = AssetLargeImage,
                                LargeText = "Antistasi - The Mod"
                            }
                    };
                    break;
                default:
                    discordpresence = new Discord.Activity
                    {
                        State = "In Menus",
                        Instance = false,
                        Assets =
                            {
                                LargeImage = AssetLargeImage,
                                LargeText = "Antistasi - The Mod"
                            }
                    };
                    break;
            };
            UpdateActivity();
        }

        private static void playOnServer()
        {
            string kda = State.server.stats.Kills + "/" + State.server.stats.Death + "/" + State.server.stats.Assists;
            string detailsStement = (State.server.isUncon ? "Unconsicous as " : (State.server.isDead ? "Dead as " : "As ")) + State.server.roleDescription + " " + kda;
            discordpresence = new Discord.Activity
            {
                State = detailsStement,
                Details = State.server.Name,
                Timestamps =
                    {
                        Start = State.server.joinTime
                    },
                Instance = true,
                Assets =
                    {
                        LargeImage = AssetLargeImage,
                        LargeText = "Antistasi - The Mod"
                    }
            };
            if (State.server.slotCount > 0 && State.server.currentPlayerCount > 0)
            {
                Discord.ActivityParty p = new Discord.ActivityParty
                {
                    Id = State.server.id,
                    Size =
                            {
                                CurrentSize = State.server.currentPlayerCount,
                                MaxSize = State.server.slotCount
                            },
                };
                discordpresence.Party = p;
            }
        }

        public static void Connector(string s)
        {
            que.Enqueue(s);
        }

        public static void Connector(string s, string[] argsInput)
        {
            queArgs.Enqueue(new CommandAndArgument
            {
                command = s,
                args = argsInput
            });
        }
    }
}
