module ludum.level;

import gui.renderbox;
import ludum.entity;
import ludum.shape;
import utils.configfile;
import utils.factory;
import utils.vector2;
import utils.rect2;

public class LevelPanel : Entity {
    public this(ConfigNode config) {
        pos = config.getValue("pos", pos);
        foreach (ConfigNode item; config) {
            if (EntityFactory.exists(item.name)) {
                add(EntityFactory.instantiate(item.name, item));
            }
        }
    }

    static this() {
        EntityFactory.register!(typeof(this))("panel");
    }
}

public class LevelBlock : Entity {
    public this(ConfigNode config) {
        pos = config.getValue("pos", pos);
        auto block = new ShapeBlock();
        block.size = config.getValue("size", block.size);
        shape = block;
    }

    static this() {
        EntityFactory.register!(typeof(this))("block");
    }
}

public class LevelImage : Entity {
    char[] img = "";

    public this(ConfigNode config) {
        pos = config.getValue("pos", pos);
        auto block = new ShapeBlock();
        block.size = config.getValue("size", block.size);
        shape = block;
        img = config.getValue("img", img);
        solid = config.getValue("solid", false);
    }

    static this() {
        EntityFactory.register!(typeof(this))("image");
    }
}

public class LevelText : Entity {
    char[] text;
    BoxProperties box;

    public this(ConfigNode config) {
        box.borderWidth = 0;

        pos = config.getValue("pos", pos);
        auto block = new ShapeBlock();
        block.size = config.getValue("size", block.size);
        shape = block;
        text = config.getValue("text", text);
        solid = config.getValue("solid", false);
        box.loadFrom(config.getSubNode("box"));
    }

    static this() {
        EntityFactory.register!(typeof(this))("text");
    }
}

public class Level : Entity {
    char[] music;

    public this(ConfigNode config) {
        music = config.getValue("music", music);
        foreach (ConfigNode item; config) {
            if (EntityFactory.exists(item.name)) {
                add(EntityFactory.instantiate(item.name, item));
            }
        }
    }
}
