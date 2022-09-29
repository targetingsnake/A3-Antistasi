using System;
using System.Linq;
using System.Threading;
using System.Text;
using System.Runtime.InteropServices;

class Program
{
    // Request user's avatar data. Sizes can be powers of 2 between 16 and 2048
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

    // Update user's activity for your game.
    // Party and secrets are vital.
    // Read https://discordapp.com/developers/docs/rich-presence/how-to for more details.
    static void UpdateActivity(Discord.Discord discord)
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
                End = 6,
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

    static void Main(string[] args)
    {
        dcpr.main.Connector("init");
        // Use your client ID from Discord's developer site.
        

    }
}
