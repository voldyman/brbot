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
 ___                  _            _           _
/ __| __ _ _ __  _ __| |___   _ __| |_  _ __ _(_)_ _
\__ \/ _` | '  \| '_ \ / -_) | '_ \ | || / _` | | ' \
|___/\__,_|_|_|_| .__/_\___| | .__/_|\_,_\__, |_|_||_|
                |_|          |_|         |___/
*/

using doodleIRC;

namespace brbot {

    public class SaySomething : IPlugin {
        public string cus_hook;
        public string info { get;set; }

        public SaySomething () {
            this.cus_hook = "!some";
            this.info = "test plugin";
        }
        public void on_message_h (DoodleIRCServer server, string sender, string channel, string msg) {
            server.write (channel, "Something " + sender);
        }

        public IRCCommand get_cmd () {
            IRCCommand cmd  = IRCCommand () {
                hook = this.cus_hook,
                on_message = on_message_h,
                on_user_join = null,
                on_bot_join = null
            };
            return cmd;
        }
    }
}
