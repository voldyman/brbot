     ____       ____        _
    |  _ \     |  _ \      | |
    | |_) |_ __| |_) | ___ | |_
    |  _ <| '__|  _ < / _ \| __|
    | |_) | |  | |_) | (_) | |_
    |____/|_|  |____/ \___/ \__|

irc bot written in vala using [doodleIRC](https://github.com/voldyman/doodleIRC).

##To Build

    $ mkdir build
    $ cmake .. && make
    $ ./brbot

##Extending

BrBot supports plugins, you can see the sample plugin included with the project.

Just implement the Plugin interface and add you plugin in the main function.

    //in void main
    var sme = new SaySomething (); //SaySomething is a sample plugin
    cmds.append (sme.get_cmd ());

and you are done.
