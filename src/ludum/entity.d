module ludum.entity;

import ludum.game;
import ludum.shape;
import utils.vector2;
import utils.list2;
import utils.rect2;
import utils.configfile;
import utils.factory;

public alias StaticFactory!("entity", Entity, ConfigNode) EntityFactory;

public abstract class Entity {
    Vector2f pos;
    Shape shape;
    bool solid = true;

    private {
        ObjectList!(Entity, "sim_node") mChildren;
        ObjectList!(Entity, "new_node") mNewChildren;
        bool mIsAlive = true;
    }

    ObjListNode!(typeof(this)) sim_node;
    ObjListNode!(typeof(this)) new_node;

    public this() {
        mChildren = new typeof(mChildren)();
        mNewChildren = new typeof(mNewChildren)();
    }

    void add(Entity child) {
        mNewChildren.add(child);
    }

    public int opApply(int delegate(inout Entity) del) {
        foreach (Entity e; mChildren) {
            int res = del(e);
            if (res)
                return res;
        }
        return 0;
    }

    public bool inOrder(bool delegate(inout Entity) del) {
        bool res = del(this);
        if (!res)
            return res;
        foreach (Entity e; mChildren) {
            res = e.inOrder(del);
            if (!res) {
                return res;
            }
        }
        return true;
    }

    final void simulate(Game game) {
        doSimulate(game);
        foreach (Entity obj; mNewChildren) {
            mChildren.add(obj);
            mNewChildren.remove(obj);
        }
        foreach (Entity obj; mChildren) {
            obj.simulate(game);
        }
        foreach (Entity obj; mChildren) {
            if (!obj.objectAlive()) {
                mChildren.remove(obj);
            }
        }
    }

    protected void doSimulate(Game game) {
    }

    final bool objectAlive() {
        return mIsAlive;
    }

    protected void onKill() {
    }

    //when kill() is called, the object is considered to be deallocated on the
    //  next game frame (actually, it may be left to the GC or something, but
    //  we need explicit lifetime for scripting)
    //questionable whether this should be public or protected; public for now,
    //  because it was already public before
    final void kill() {
        if (!mIsAlive)
            return;
        mIsAlive = false;
        onKill();
    }

    bool collideSolid(Entity other) {
        bool hit = false;
        collide(other, (Entity entity) {
            if (entity.solid) {
                hit = true;
            }
        });
        return hit;
    }

    void collide(Entity other, void delegate(Entity hitEntity) onHit, Vector2f offset = Vector2f(0)) {
        if (other == this || !objectAlive || !other.objectAlive) {
            return;
        }
        if (mChildren.count > 0) {
            foreach (Entity obj; mChildren) {
                obj.collide(other, onHit, offset + pos);
            }
        } else if (shape && other.shape) {
            if (shape.collide(other.shape, other.pos - (pos + offset)) || other.shape.collide(shape, pos + offset - other.pos)) {
                if (onHit) {
                    onHit(this);
                }
            }
        }
    }

    Rect2f boundingBox() {
        return Rect2f(pos, Vector2f(0));
    }
}

public interface EventTarget {
    public void trigger(Game game, char[] event, Entity source);
}

unittest {
    ShapeBlock b = new ShapeBlock();
    b.size = Vector2f(100, 50);
    ShapeCircle c = new ShapeCircle();
    c.radius = 10;
    assert(b.collide(c, Vector2f(-5, -5)));
    assert(b.collide(c, Vector2f(40, -5)));
    assert(b.collide(c, Vector2f(50, 25)));
    assert(!b.collide(c, Vector2f(111, 25)));
}
