module ludum.trap;

import ludum.entity;
import ludum.shape;
import ludum.game;
import utils.configfile;
import utils.vector2;
import utils.log;
import utils.time;
import utils.timer;

LogStruct!("trap") log;

public class TriggerEntity : Entity {
    char[] event;

    public this(ConfigNode config) {
        pos = config.getValue("pos", Vector2f(0));
        if (config.getValue!(char[])("type", "circle") == "circle") {
            auto circle = new ShapeCircle();
            circle.radius = config.getValue("radius", circle.radius);
            shape = circle;
        } else {
            auto block = new ShapeBlock();
            block.size = config.getValue("size", block.size);
            shape = block;
        }
        event = config.getValue!(char[])("event", "hit");
        solid = false;
    }

    static this() {
        EntityFactory.register!(typeof(this))("trigger");
    }
}

public class ShooterEntity : Entity, EventTarget {
    char[] event = "hit";
    Time delay;
    ConfigNode[] spawns;
    private Timer mTimer;

    public this(ConfigNode config) {
        event = config.getValue("event", event);
        delay = config.getValue("time", delay);
        foreach (ConfigNode node; config) {
            if (node.name == "entity") {
                spawns ~= node;
            }
        }
        solid = false;
    }

    public void trigger(Game game, char[] event, Entity source) {
        if (event == this.event) {
            spawnIt(game);
        }
    }

    protected void doSimulate(Game game) {
        if (delay != Time.Null) {
            if (!mTimer) {
                mTimer = new Timer(delay, (Timer sender) {
                    spawnIt(game);
                });
                mTimer.enabled = true;
            }
            mTimer.update();
        }
    }

    private void spawnIt(Game game) {
        foreach (ConfigNode spawn; spawns) {
            auto entity = EntityFactory.instantiate(spawn["type"], spawn);
            game.level.add(entity);
        }
    }

    static this() {
        EntityFactory.register!(typeof(this))("shooter");
    }
}

public class ArrowEntity : Entity {
    Vector2f velocity = Vector2f(0);
    bool inSolid = true;
    float damage = 25f;

    public this(ConfigNode config) {
        pos = config.getValue("pos", pos);
        velocity = config.getValue("velocity", velocity);
        auto circle = new ShapeCircle();
        circle.radius = 5f;
        circle.radius = config.getValue("radius", circle.radius);
        shape = circle;
        damage = config.getValue("damage", damage);
        solid = false;
    }

    protected void doSimulate(Game game) {
        float delta = game.time.difference.secsf;

        bool shouldDie;
        bool hit = game.rootEntity.collideSolid(this);
        if (hit && !inSolid) {
            shouldDie = true;
        }
        inSolid = hit;

        pos = pos + velocity*delta;

        if (game.player.collideSolid(this)) {
            game.player.damage(game, damage);
            shouldDie = true;
        }
        if (shouldDie) {
            kill();
        }
    }

    static this() {
        EntityFactory.register!(typeof(this))("arrow");
    }
}
