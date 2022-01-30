module ludum.game;

import framework.config;
import game.input;
import ludum.entity;
import ludum.level;
import ludum.player;
import ludum.shape;
import utils.configfile;
import utils.timesource;
import utils.random;
import utils.vector2;
import utils.rect2;
import utils.log;

LogStruct!("game") log;

public struct StoredEvent {
    char[] event;
    Entity source;
}

public class Game {
    private {
        TimeSource mTime;
        Random mRandom;
        Entity mRootEntity;
        Player mPlayer;
        MoveStateXY mMoveState;
        MoveStateXY mMoveStateTurn;
        Level mLevel;
        char[][] mLevelList;
        int mLevelIdx = 0;
        ConfigNode mGameConfig;
        StoredEvent[] mStoredEvents;
    }

    public {
        InputGroup input;
    }

    public this(ConfigNode config) {
        mGameConfig = config;

        mTime = new TimeSource("ludum");
        mTime.update();

        mRandom = new Random(0); //xxx seed

        input = new InputGroup();
        input.addT("move", &cmdMove);
        input.addT("turn", &cmdTurn);
        input.addT("sprint", &cmdSprint);
        input.addT("fire", &cmdFire);
        input.addT("reset", &cmdReset);

        mRootEntity = new World(config.getSubNode("world"));

        mLevelList = config.getValue("levels", mLevelList);
        loadNextLevel();

        spawnPlayer();
    }

    void loadNextLevel() {
        killLevel();
        if (mLevelIdx < mLevelList.length) {
            loadLevel(mLevelList[mLevelIdx]);
            mLevelIdx++;
        }
    }

    void resetLevel() {
        killLevel();
        loadLevel(mLevelList[mLevelIdx-1]);
    }

    public void loadLevel(char[] level) {
        killLevel();
        auto levelConfig = loadConfig("ludum/" ~ level ~ ".conf");
        mLevel = new Level(levelConfig);
        mRootEntity.add(mLevel);
    }

    private void killLevel() {
        if (mLevel) {
            mLevel.kill();
        }
    }

    void spawnPlayer() {
        if (mPlayer) {
            mPlayer.kill();
        }
        mPlayer = new Player(mGameConfig.getSubNode("player"));
        mRootEntity.add(mPlayer);
    }

    private bool cmdMove(char[] dir, bool down) {
        mMoveState.handleKeys(dir, down);
        mPlayer.move = mMoveState.direction;
        return true;
    }

    private bool cmdTurn(char[] dir, bool down) {
        mMoveStateTurn.handleKeys(dir, down);
        mPlayer.rotate = mMoveStateTurn.direction.x;
        return true;
    }

    private bool cmdSprint(bool down) {
        mPlayer.sprint = down;
        return true;
    }

    private bool cmdFire(bool down) {
        return true;
    }

    private bool cmdReset() {
        resetLevel();
        spawnPlayer();
        return true;
    }

    public void simulate() {
        mTime.update();

        mRootEntity.simulate(this);
    }

    public TimeSourcePublic time() {
        return mTime;
    }

    public Entity rootEntity() {
        return mRootEntity;
    }

    public void triggerEvent(char[] event, Entity source) {
        rootEntity.inOrder((ref Entity entity) {
            if (auto t = cast(EventTarget)entity) {
                t.trigger(this, event, source);
            }
            return true;
        });
        if (event == "die") {
            mPlayer.health = 0;
        }
        mStoredEvents ~= StoredEvent(event, source);
    }

    public Player player() {
        return mPlayer;
    }

    public Level level() {
        return mLevel;
    }

    public StoredEvent[] grabEvents() {
        auto res = mStoredEvents;
        mStoredEvents = null;
        return res;
    }
}


public class World : Entity, EventTarget {
    bool hasWon;

    public this(ConfigNode config) {
        pos = Vector2f(0);
        auto block = new ShapeBlock();
        block.size = config.getValue("size", block.size);
        shape = block;
    }

    Rect2f boundingBox() {
        return Rect2f.Span(pos, (cast(ShapeBlock)shape).size);
    }

    void trigger(Game game, char[] event, Entity source) {
        if (event == "victory") {
            float lastHp = game.player.health;
            game.player.kill();
            hasWon = true;
            game.loadNextLevel();
            game.spawnPlayer();
            game.player.health = lastHp;
        }
    }
}
