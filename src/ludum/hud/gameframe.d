module ludum.hud.gameframe;

import common.resset;
import framework.drawing;
import framework.surface;
import framework.event;
import framework.keybindings;
import framework.main;
import framework.sound;
import game.input;
import game.particles;
import gui.widget;
import gui.container;
import gui.label;
import ludum.game;
import ludum.bindings;
import ludum.renderer;
import ludum.player;
import ludum.hud.health;
import ludum.hud.death;
import utils.configfile;
import utils.vector2;
import utils.rect2;
import utils.misc;
import utils.time;
import utils.log;

LogStruct!("frame") log;

public class GameFrame : SimpleContainer {
    private {
        Game mGame;
        BindingAdapter mBindingAdapter;
        InputGroup mInput;
        ResourceSet mResources;
        Source mMusic;
        WorldRenderer mRenderer;
        Surface mHelp;
        bool mShowHelp = true;
        char[] mLastMusic;
    }

    public this(Game game, ConfigNode config, ResourceSet resources) {
        focusable = true;
        isClickable = true;

        mGame = game;
        mResources = resources;
        auto bindings = new KeyBindings();
        bindings.loadFrom(config.getSubNode("bindings"));
        mBindingAdapter = new BindingAdapter(&doInput, bindings);

        mInput = new InputGroup();
        mInput.addT("fire", &cmdFire);
        mInput.addT("place", &cmdPlace);

        mRenderer = new WorldRenderer(mResources);

        ConfigNode hud = config.getSubNode("hud");
        initHud(game, resources, hud);
    }

    private void initHud(Game game, ResourceSet resources, ConfigNode config) {
        add(new HealthBar(game, resources, config.getSubNode("healthbar")),
            WidgetLayout.Aligned(1, 1, Vector2i(5, 5)));
        add(new DeathMarker(game, resources, config.getSubNode("death")),
            WidgetLayout.Aligned(0, 0));
        mHelp = resources.get!(Surface)("help");
    }

    private bool cmdFire(bool down) {
        if (down) {
            Player player = mGame.player;
        }
        return true;
    }

    private bool cmdPlace(int mx, int my) {
        log.warn("Pos {} {}", mx, my);
        return true;
    }

    private void initMusic(char[] music) {
        if (mMusic) {
            mMusic.stop();
        }
        auto res = mResources.get!(Sample)(music);
        mMusic = res.createSource();
        mMusic.looping = true;
        mMusic.play();
    }

    void fadeoutMusic(Time t) {
        mMusic.stop(t);
    }

    void kill() {
        mMusic.stop();
    }

    override bool greedyFocus() {
        return true;
    }

    override void simulate() {
        if (mGame.level.music != mLastMusic) {
            initMusic(mGame.level.music);
            mLastMusic = mGame.level.music;
        }
    }

    override bool onKeyDown(KeyInfo ki) {
        mShowHelp = false;
        return mBindingAdapter.onKeyDown(ki, mousePos);
    }
    override void onKeyUp(KeyInfo ki) {
        mBindingAdapter.onKeyDown(ki, mousePos);
    }

    override void onMouseMove(MouseInfo mouse) {
        mBindingAdapter.onMouseMove(mouse);
    }

    private bool doInput(char[] s) {
        bool handled = false;

        //prefer local input handler
        if (!handled && mInput.checkCommand("", s))
            handled = mInput.execCommand("", s);

        if (!handled && mGame.input.checkCommand("", s)) {
            mGame.input.execCommand("", s);
            handled = true;
        }

        return handled;
    }

    override void onDraw(Canvas c) {
        mRenderer.processEvents(mGame.grabEvents);
        mRenderer.renderWorld(c, mGame.rootEntity);
        if (mShowHelp) {
            c.draw(mHelp, Vector2i(0));
        }
    }

    override void onDrawFocus(Canvas c) {
    }

    override Vector2i layoutSizeRequest() {
        return toVector2i(mGame.rootEntity.boundingBox.size);
    }
}
