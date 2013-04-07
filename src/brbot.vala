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
/*
 ____       ____        _
|  _ \     |  _ \      | |
| |_) |_ __| |_) | ___ | |_
|  _ <| '__|  _ < / _ \| __|
| |_) | |  | |_) | (_) | |_
|____/|_|  |____/ \___/ \__|
*/
using doodleIRC;

namespace brbot {
    public delegate void IRCCommandFunc (DoodleIRCServer server, string sender, string channel, string msg = "");

    public struct IRCCommand {
        string hook;
        IRCCommandFunc? on_message;
        IRCCommandFunc? on_user_join;
        IRCCommandFunc? on_bot_join;
    }

    public interface IPlugin {
        public abstract IRCCommand get_cmd ();
        public abstract string info { get;set; }
    }

    public class BrBot {
        private DoodleIRCServer server;
        public List<IRCCommand?> cmds;
        public BrBot (DoodleIRCServer _server, List<IRCCommand?> _cmds) {
            this.server = _server;
            this.cmds = _cmds.copy ();

            this.register_hooks ();
        }

        private void register_hooks () {

            this.cmds.foreach ((cmd) => {
                /* Check if the plugin handles on_message signal */
                if (cmd.on_message != null) {
                    this.server.on_message.connect ((sender, channel, msg) => {
                        if (msg.has_prefix (cmd.hook))
                            cmd.on_message (this.server, sender, channel, msg);
                    });
                }
                /* Check if the plugin handles on_user_join singal */
                if (cmd.on_user_join != null) {
                    this.server.on_user_join.connect ((channel, nick) => {
                        cmd.on_user_join (this.server, channel, nick);
                    });
                }
                /* Check if the plugin handles on_bot_join signal */
                if (cmd.on_bot_join != null) {
                    this.server.on_join_complete.connect ((channel, nick) => {
                        cmd.on_bot_join (this.server, channel, nick);
                    });
                }
            });
        }

        public static void main () {
            var chan = "#botwar";
            var nick = "brbot";

            var user = User () {
                username="brbot",
                hostname="really",
                servername=" d",
                realname="eBot"
            };

            var server = new DoodleIRCServer ("irc.freenode.net", user, nick);
            server.connect.begin ();
            server.join_chan (chan);

            List<IRCCommand?> cmds = new List<IRCCommand?> ();
            /* Something Handler */
            var sme = new SaySomething ();
            cmds.append (sme.get_cmd ());

            /* Memo Handler */
            var memo = new Memo ();
            cmds.append (memo.get_cmd ());

            var bot = new BrBot (server, cmds);
            new MainLoop ().run ();
        }
    }
}
