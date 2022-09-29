using System;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;

namespace dcpr
{
    static class main
    {
        static main()
        {
            t = new Thread(new ThreadStart(ThreadLoop));
            t.Start();
            que = new ConcurrentQueue<string>();
            discordpresence = new Discord.Activity
            {
                State = "In Menus",
                Instance = false
            };
        }
        private static Thread t;
        private static ConcurrentQueue<string> que;
        private static Discord.Discord discord;
        private static Discord.Activity discordpresence;


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
            // If you want to verify information from your game's server then you can
            // grab the access token and send it to your server.
            //
            // This automatically looks for an environment variable passed by the Discord client,
            // if it does not exist the Discord client will focus itself for manual authorization.
            //
            // By-default the SDK grants the identify and rpc scopes.
            // Read more at https://discordapp.com/developers/docs/topics/oauth2
            // applicationManager.GetOAuth2Token((Discord.Result result, ref Discord.OAuth2Token oauth2Token) =>
            // {
            //     Console.WriteLine("Access Token {0}", oauth2Token.AccessToken);
            // });

            var activityManager = discord.GetActivityManager();

            // This is used to register the game in the registry such that Discord can find it.
            // This is only needed by games acquired from other platforms, like Steam.
            // activityManager.RegisterCommand();

            var imageManager = discord.GetImageManager();

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

            // Pump the event look to ensure all callbacks continue to get fired.
            try
            {
                while (true)
                {
                    discord.RunCallbacks();
                    if (que.TryDequeue(out string s))
                    {
                        preConfiguration(s);
                    }
                    Thread.Sleep(1000 / 60);
                }
            }
            finally
            {
                discord.Dispose();
            }
        }

        private static void preConfiguration(string s)
        {
            string switchKey = s;
            if (s.Contains("@@@"))
            {
                string[] expands = s.Split(new string[] { "@@@" }, StringSplitOptions.None);
                switchKey = expands[0];
            }
            bool update = true;
            switch (switchKey.ToLower())
            {
                case "init":
                case "missionstart":
                case "missionend":
                case "editorstart":
                case "editorend":
                case "teststart":
                case "testend":
                case "uncon":
                case "respawn":
                case "wakeup":
                    break;
                case "updatekill":
                    State.addKill();
                    break;
                case "updatedeath":
                    State.addDeath();
                    break;
                case "updateassist":
                    State.addAssist();
                    break;
                default:
                    update = false;
                    break;
            }
            if (update)
            {
                updateDCPresence();
            }
        }

        private static void updateDCPresence()
        {
            switch (State.clientState)
            {
                case State.clientInMenu:
                    discordpresence = new Discord.Activity
                    {
                        State = "In Menus",
                        Instance = false
                    };
                    break;
                case State.clientOnServer:
                    string detailsStement = (State.server.isUncon ? "Unconsicous as " : (State.server.isDead ? "Dead as " : "AS ")) + State.server.roleDescription;
                    discordpresence = new Discord.Activity
                    {
                        State = State.server.missionName,
                        Details = detailsStement,
                        Party =
                    {
                        Id = State.server.id,
                        Size =
                        {
                            CurrentSize = State.server.currentPlayerCount,
                            MaxSize = State.server.slotCount
                        }
                    },
                        Timestamps =
                    {
                        Start = State.server.joinTime
                    },
                        Instance = true
                    };
                    break;
                default:
                    discordpresence = new Discord.Activity
                    {
                        State = "In Menus",
                        Instance = false
                    };
                    break;
            };
            UpdateActivity();
        }

    public static void Connector(string s)
    {
        que.Enqueue(s);
    }
}
}
