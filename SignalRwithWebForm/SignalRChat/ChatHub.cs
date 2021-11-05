using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;


namespace SignalRChat
{
    public static class UserHandler
    {
        // just remember when you will restart the app, object will get reset
        public static HashSet<string> ConnectedIds = new HashSet<string>();
        public static HashSet<string> ConnectedUsers = new HashSet<string>();
    }
    public class ChatHub :Hub
    {

        public void Send(string name, string message)
        {
            // registering the users
            UserHandler.ConnectedIds.Add(Context.ConnectionId);
            UserHandler.ConnectedUsers.Add(name);
            // Call the broadcastMessage method to update clients.
            Clients.All.broadcastMessage(name, message);
        }

        public void SendToSingleUser(string userName, string message)
        {

            string fromUserId = Context.ConnectionId;
            //removing the currrent user ID & name
            UserHandler.ConnectedIds.Remove(fromUserId);
            UserHandler.ConnectedUsers.Remove(userName);

            //taking a random user for sending message
            string toUserId = UserHandler.ConnectedIds.First();
            string toUserName = UserHandler.ConnectedUsers.First();

            if (toUserId != null && fromUserId != null)
            {
                // send to 
                Clients.Client(toUserId).sendPrivateMessage(userName, message);

                // send to caller user
                Clients.Caller.sendPrivateMessage(userName, message);
            }

        }
    }
}