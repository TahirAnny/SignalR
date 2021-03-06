<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="SignalRChat.Chat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SignalR Chat : Chat Page</title>

    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Content/style.css" rel="stylesheet" />
    <link href="Content/font-awesome.css" rel="stylesheet" />

    <script src="Scripts/jQuery-1.9.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.2.2.min.js"></script>
    <script src="Scripts/date.format.js"></script>
    <!--Reference the autogenerated SignalR hub script. -->
    <script src="signalr/hubs"></script>


    <script type="text/javascript">

        $(function () {

            // Declare a proxy to reference the hub. 
            var chat = $.connection.chatHub;
            // Create a function that the hub can call to broadcast messages.
            chat.client.broadcastMessage = function (name, message) {
                // Html encode display name and message. 
                var encodedName = $('<div />').text(name).html();
                var encodedMsg = $('<div />').text(message).html();
                // Add the message to the page. 
                $('#discussion').append('<li><strong>' + encodedName
                    + '</strong>:&nbsp;&nbsp;' + encodedMsg + '</li>');
            };

            // Create a function that the hub can call to broadcast private messages
            chat.client.sendPrivateMessage = function (name, message) {
                // Html encode display name and message. 
                var encodedName = $('<div />').text(name).html();
                var encodedMsg = $('<div />').text(message).html();
                // Add the message to the page. 
                $('#discussion').append('<li><strong>' + encodedName
                    + '</strong>:&nbsp;&nbsp;' + encodedMsg + '</li>');
            };


            // Get the user name and store it to prepend to messages.
            $('#displayname').val(prompt('Enter your name:', ''));
            $('#CurrentUser').append($('#displayname').val());
            // Set initial focus to message input box.  
            $('#message').focus();
            // Start the connection.
            $.connection.hub.start().done(function () {

                //send to all user
                $('#sendmessage').click(function () {

                    var msg = $("#message").val();

                    if (msg.length > 0) {
                        debugger;
                        var userName = $('#displayname').val();
                        chat.server.send(userName, msg);
                        $('#message').val('').focus();
                    }
                });

                //send to a sepcific user
                $('#sendToSingleUser').click(function () {

                    var msg = $("#message").val();

                    if (msg.length > 0) {
                        debugger;
                        var userName = $('#displayname').val();
                        chat.server.sendToSingleUser(userName, msg);
                        $('#message').val('').focus();
                    }
                });
            });
        });

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" ></asp:ScriptManager>
        <div class="content-wrapper">
            <div class="row">
                 <div class="container">
                    <label id="CurrentUser"> </label>
                    <input type="text" id="message" />
                    <input type="button" id="sendmessage" value="Send" />
                    <input type="button" id="sendToSingleUser" value="Send Single User" />
                    <input type="hidden" id="displayname" />
                    <ul id="discussion">
                    </ul>
                </div>
            </div>
        </div>

         <script src="Scripts/bootstrap.min.js"></script>

    </form>
</body>
</html>
