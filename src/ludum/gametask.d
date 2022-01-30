module ludum.gametask;

import framework.config;
import framework.sound;
import common.task;
import common.resources;
import common.resset;
import common.task;
import game.particles;
import ludum.hud.gameframe;
import ludum.game;
import gui.window;
import utils.configfile;
import utils.random : rngShared;
import utils.time;
import utils.vector2;
import utils.misc;

import tango.math.Math : abs;

public class GameTask : IKillable {
    private {
        Game mGame;
        WindowWidget mWindow;
        ResourceSet mResources;
        GameFrame mGameFrame;
        bool mDead;
    }

    public this(char[] args = "") {
        ConfigNode config = loadConfig("ludum/ludum.conf");
        ConfigNode pl = config.getPath("game.player", true);
        if (args == "easy") {
            pl.setValue("health", 100);
        } else if (args == "medium") {
            pl.setValue("health", 75);
        } else {
            pl.setValue("health", 50);
        }

        mResources = gResources.loadResSet("ludum/ludum.conf");
        loadParticles();

        mGame = new Game(config.getSubNode("game"));

        mGameFrame = new GameFrame(mGame, config, mResources);
        mWindow = gWindowFrame.createWindow(mGameFrame, "Time of Wheels");

        addTask(&onFrame);
    }

    private void loadParticles() {
        auto conf = loadConfig("ludum/particles.conf");
        foreach (ConfigNode node; conf.getSubNode("particles")) {
            ParticleType p = new ParticleType();
            p.read(mResources, node);
            mResources.addResource(p, node.name);
        }
    }

    private bool onFrame() {
        if (mWindow.wasClosed())
            kill();
        if (mDead)
            return false;

        mGame.simulate();

        return true;
    }

    override void kill() {
        mGameFrame.kill();
        mDead = true;
    }

    static this() {
        registerTaskClass!(typeof(this))("ludum");
    }
}
