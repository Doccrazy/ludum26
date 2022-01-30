module lumbricus;

//enable tango backtracing (on exceptions)
debug import tango.core.tools.TraceExceptions;

import framework.filesystem;
import framework.globalsettings;
import framework.imgread;
import framework.main;
import common.init;
import common.gui_init;
import toplevel = common.toplevel;
import utils.misc;

version = Game;

//these imports register classes in a factory on module initialization
//so be carefull not to remove them accidentally

//drivers etc.
import framework.stuff;

import game.gui.welcome;
import ludum.gametask;
import common.localeswitch;

void lmain(char[][] args) {
    args = args[1..$];
    bool is_server = getarg(args, "server");

    init(args);

    gFramework.initialize();
    gFramework.setCaption("Time of Wheels");

    try {
        gFramework.setIcon(loadImage("lumbricus-icon.png"), "MAINICON");
    } catch (CustomException e) {
    }

    initGUI();

    //installs callbacks to framework, which get called in the mainloop
    new toplevel.TopLevel();

    gFramework.run();

    saveSettings();

    gFramework.deinitialize();
}

int main(char[][] args) {
    return wrapMain(args, &lmain);
}
