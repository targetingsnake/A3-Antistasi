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
        }
        private static Thread t;
        private static int q;
        private static ConcurrentQueue<string> que;

        static void FetchAvatar(Discord.ImageManager imageManager, Int64 userID)
        {
            imageManager.Fetch(Discord.ImageHandle.User(userID), (result, handle) =>
            {
                {
                    if (result == Discord.Result.Ok)
                    {
                        // You can also use GetTexture2D within Unity.
                        // These return raw RGBA.
                        var data = imageManager.GetData(handle);
                        Console.WriteLine("image updated {0} {1}", handle.Id, data.Length);
                    }
                    else
                    {
                        Console.WriteLine("image error {0}", handle.Id);
                    }
                }
            });
        }

        private static void UpdateActivity(Discord.Discord discord)
        {
            var activityManager = discord.GetActivityManager();
            var lobbyManager = discord.GetLobbyManager();

            var activity = new Discord.Activity
            {
                State = "olleh",
                Details = "foo details",
                Timestamps =
                {
                    Start = 5,
                },
                Assets =
                {
                    LargeImage = "foo largeImageKey",
                    LargeText = "foo largeImageText",
                    SmallImage = "foo smallImageKey",
                    SmallText = "foo smallImageText",
                },
                Party = {
                   Id = "",
                   Size = {
                        CurrentSize = 1,
                        MaxSize = 39,
                   },
                },
                Instance = true,
            };
            activityManager.UpdateActivity(activity, result =>
            {
                Console.WriteLine("Update Activity {0}", result);

                // Send an invite to another user for this activity.
                // Receiver should see an invite in their DM.
                // Use a relationship user's ID for this.
                // activityManager
                //   .SendInvite(
                //       364843917537050624,
                //       Discord.ActivityActionType.Join,
                //       "",
                //       inviteResult =>
                //       {
                //           Console.WriteLine("Invite {0}", inviteResult);
                //       }
                //   );
            });
        }
        public static void ThreadLoop()
        {
            var clientID = Environment.GetEnvironmentVariable("DISCORD_CLIENT_ID");
            if (clientID == null)
            {
                clientID = "1024314409482452992";
            }
            var discord = new Discord.Discord(Int64.Parse(clientID), (UInt64)Discord.CreateFlags.Default);
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
                UpdateActivity(discord);
                var currentUser = userManager.GetCurrentUser();
                Console.WriteLine(currentUser.Username);
                Console.WriteLine(currentUser.Id);
            };
            // If you store Discord user ids in a central place like a leaderboard and want to render them.
            // The users manager can be used to fetch arbitrary Discord users. This only provides basic
            // information and does not automatically update like relationships.
            userManager.GetUser(450795363658366976, (Discord.Result result, ref Discord.User user) =>
            {
                if (result == Discord.Result.Ok)
                {
                    Console.WriteLine("user fetched: {0}", user.Username);

                    // Request users's avatar data.
                    // This can only be done after a user is successfully fetched.
                    FetchAvatar(imageManager, user.Id);
                }
                else
                {
                    Console.WriteLine("user fetch error: {0}", result);
                }
            });

            var relationshipManager = discord.GetRelationshipManager();
            // It is important to assign this handle right away to get the initial relationships refresh.
            // This callback will only be fired when the whole list is initially loaded or was reset
            relationshipManager.OnRefresh += () =>
            {
                // Filter a user's relationship list to be just friends
                relationshipManager.Filter((ref Discord.Relationship relationship) => { return relationship.Type == Discord.RelationshipType.Friend; });
                // Loop over all friends a user has.
                Console.WriteLine("relationships updated: {0}", relationshipManager.Count());
                for (var i = 0; i < Math.Min(relationshipManager.Count(), 10); i++)
                {
                    // Get an individual relationship from the list
                    var r = relationshipManager.GetAt((uint)i);
                    Console.WriteLine("relationships: {0} {1} {2} {3}", r.Type, r.User.Username, r.Presence.Status, r.Presence.Activity.Name);

                    // Request relationship's avatar data.
                    FetchAvatar(imageManager, r.User.Id);
                }
            };
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
                    Thread.Sleep(1000 / 60);
                }
            }
            finally
            {
                discord.Dispose();
            }
        }
        public static void Connector(string s)
        {
            que.Enqueue(s);
        }
    }
}
