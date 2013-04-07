// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/***
    BEGIN LICENSE

    Copyright (C) 2013 Akshay Shekher <voldyman666@gmail.com>
    This program is free software: you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License version 3, as published
    by the Free Software Foundation.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranties of
    MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
    PURPOSE.  See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program.  If not, see <http://www.gnu.org/licenses/>

    END LICENSE
***/

using doodleIRC;

namespace brbot {

    public class Memo : IPlugin {

        private struct Command {
            public string channel;
            public string message;
            public string from_nick;
            public string to_nick;
        }

        /* Contains all the messages */
        private Gee.HashMap<string, Command?> messages;
        public string cus_hook;
        public string info { get;set; }

        public Memo () {
            this.cus_hook = "!memo";
            this.info = "Memo recorder";

            messages = new Gee.HashMap<string, Command?> ();
        }

        public IRCCommand get_cmd () {
            IRCCommand cmd  = IRCCommand () {
                hook = this.cus_hook,
                on_message = on_message_h,
                on_user_join = on_user_join_h,
                on_bot_join = null
            };
            return cmd;
        }

        public void on_user_join_h (DoodleIRCServer server, string channel, string nick) {
            server.write (nick, "Hello");
            if (messages.has_key (nick)) {
                Command cur_cmd = messages.get (nick);
                if (channel == cur_cmd.channel) {
                    print ("Same Channel\n\n");
                    server.notice (cur_cmd.to_nick, "Memo from:"+cur_cmd.from_nick+", "+cur_cmd.message);
                    messages.unset (nick);
                }
            }
        }

        public void on_message_h (DoodleIRCServer server, string sender, string channel, string msg) {
            Command cur_cmd = parse_msg (msg, sender, channel);
            print ("\n"+msg);
            server.notice (sender, "Memo saved");
            messages.set (sender, cur_cmd);
        }

        private Command parse_msg (string msg, string sender, string chan) {
            string _msg = msg.split ("!memo")[1];
            string[] message_parts = _msg.split ("|");
            string user_message = message_parts[0].strip ();
            string to_user_nick = message_parts [1].strip ();
            print ("\n===\n%s\n%s\n%s".printf (user_message, to_user_nick, chan));
            return Command () {
                message = user_message,
                to_nick = to_user_nick,
                from_nick = sender,
                channel = chan
            };
        }
    }
}
