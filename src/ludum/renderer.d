module ludum.renderer;

import common.animation;
import common.resset;
import framework.drawing;
import framework.surface;
import framework.font;
import game.particles;
import gui.renderbox;
import ludum.entity;
import ludum.level;
import ludum.shape;
import ludum.player;
import ludum.trap;
import ludum.game;
import utils.color;
import utils.factory;
import utils.log;
import utils.vector2;
import utils.rect2;
import utils.time;
import math = tango.math.Math;

public abstract class EntityRenderer {
    void render(Canvas c, Entity entity, ParticleWorld particles);

    void handleEvent(char[] event, Entity source, WorldRenderer world) {
    }

    public ClassInfo supports();
}

public alias StaticFactory!("renderer", EntityRenderer, ResourceSet) RendererFactory;

public class WorldRenderer {
    private EntityRenderer[ClassInfo] mRenderers;
    private ParticleWorld mParticles;

    public this(ResourceSet resources) {
        foreach (char[] cls; RendererFactory.classes) {
            auto inst = RendererFactory.instantiate(cls, resources);
            mRenderers[inst.supports] = inst;
        }
        mParticles = new ParticleWorld();
    }

    public void renderWorld(Canvas c, Entity entity) {
        render(c, entity, true);
    }

    private void render(Canvas c, Entity entity, bool root) {
        c.pushState();
        c.translate(toVector2i(entity.pos));
        if (auto renderer = entity.classinfo in mRenderers) {
            (*renderer).render(c, entity, mParticles);
        }
        foreach (Entity child; entity) {
            render(c, child, false);
        }
        if (root) {
            mParticles.setViewArea(toRect2i(Rect2f(Vector2f(0), entity.boundingBox.size)));
            mParticles.draw(c);
        }
        c.popState();
    }

    public void processEvents(StoredEvent[] events) {
        foreach (ev; events) {
            if (auto renderer = ev.source.classinfo in mRenderers) {
                (*renderer).handleEvent(ev.event, ev.source, this);
            }
        }
    }

    ParticleWorld particles() {
        return mParticles;
    }

    private void register(T)(EntityRenderer renderer) {
        mRenderers[T.classinfo] = renderer;
    }
}

public class LevelBlockRenderer : EntityRenderer {
    public this(ResourceSet resources) {
    }

    void render(Canvas c, Entity entity, ParticleWorld particles) {
        auto block = cast(LevelBlock)entity;
        auto box = cast(ShapeBlock)block.shape;
        c.drawFilledRect(Rect2i.Span(Vector2i(0), toVector2i(box.size)), Color.Black);
    }

    public ClassInfo supports() {
        return LevelBlock.classinfo;
    }

    static this() {
        RendererFactory.register!(typeof(this))("levelBlock");
    }
}

public class LevelImageRenderer : EntityRenderer {
    private ResourceSet mResources;

    public this(ResourceSet resources) {
        mResources = resources;
    }

    void render(Canvas c, Entity entity, ParticleWorld particles) {
        auto imgEntity = cast(LevelImage)entity;
        auto box = cast(ShapeBlock)imgEntity.shape;
        Surface img = mResources.get!(Surface)(imgEntity.img);
        c.drawStretched(img, Vector2i(0), toVector2i(box.size), ImageDrawStyle.stretch);
    }

    public ClassInfo supports() {
        return LevelImage.classinfo;
    }

    static this() {
        RendererFactory.register!(typeof(this))("levelImage");
    }
}

public class LevelTextRenderer : EntityRenderer {
    private ResourceSet mResources;
    private Font mFont;

    public this(ResourceSet resources) {
        mResources = resources;
        mFont = gFontManager.loadFont("normal");
    }

    void render(Canvas c, Entity entity, ParticleWorld particles) {
        auto textEntity = cast(LevelText)entity;
        auto box = cast(ShapeBlock)textEntity.shape;

        drawBox(c, Vector2i(0), toVector2i(box.size), textEntity.box);

        Vector2i fs = mFont.textSize(textEntity.text);
        mFont.drawText(c, toVector2i(box.size)/2 - fs/2, textEntity.text);
    }

    public ClassInfo supports() {
        return LevelText.classinfo;
    }

    static this() {
        RendererFactory.register!(typeof(this))("levelText");
    }
}

LogStruct!("renderer") log;

public class PlayerRenderer : EntityRenderer {
    private Animation animStand, animWalk, animRun;
    private ParticleType pHit, pDie;

    public this(ResourceSet resources) {
        animStand = resources.get!(Animation)("player_stand");
        animWalk= resources.get!(Animation)("player_walk");
        animRun = resources.get!(Animation)("player_run");
        pHit = resources.get!(ParticleType)("p_hit");
        pDie = resources.get!(ParticleType)("p_blood");
    }

    void render(Canvas c, Entity entity, ParticleWorld particles) {
        auto player = cast(Player)entity;
        AnimationParams params;
        params.p[0] = cast(int)(player.rotation*180.0f/math.PI);
        if (player.move == Vector2i(0)) {
            animStand.draw(c, Vector2i(0), params, timeCurrentTime);
        } else if (player.sprint && player.stamina > 0) {
            animRun.draw(c, Vector2i(0), params, timeCurrentTime);
        } else {
            animWalk.draw(c, Vector2i(0), params, timeCurrentTime);
        }
        /*float radius = (cast(ShapeCircle)player.shape).radius;
        c.drawCircle(Vector2i(0), cast(int)radius, Color.Black);
        c.drawLine(toVector2i(-Vector2f(radius, 0).rotated(player.rotation)),
                   toVector2i(Vector2f(radius, 0).rotated(player.rotation)), Color.Black);*/
    }

    void handleEvent(char[] event, Entity source, WorldRenderer world) {
        if (event == "playerHit") {
            world.particles.emitParticle(source.pos, Vector2f(0), pHit);
        }
        if (event == "playerDie") {
            world.particles.emitParticle(source.pos, Vector2f(0), pDie);
        }
    }

    public ClassInfo supports() {
        return Player.classinfo;
    }

    static this() {
        RendererFactory.register!(typeof(this))("player");
    }
}

public class ArrowRenderer : EntityRenderer {
    public this(ResourceSet resources) {
    }

    void render(Canvas c, Entity entity, ParticleWorld particles) {
        auto arrow = cast(ArrowEntity)entity;
        auto circle = cast(ShapeCircle)arrow.shape;

        c.drawCircle(Vector2i(0), cast(int)circle.radius, Color(1,0,0));
    }

    public ClassInfo supports() {
        return ArrowEntity.classinfo;
    }

    static this() {
        RendererFactory.register!(typeof(this))("arrow");
    }
}
