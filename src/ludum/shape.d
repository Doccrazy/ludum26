module ludum.shape;

import utils.vector2;
import utils.rect2;
import utils.log;

public abstract class Shape {
    public abstract bool collide(Shape other, Vector2f offset);
}

public class ShapeBlock : Shape {
    Vector2f size = Vector2f(1);

    public bool collide(Shape other, Vector2f offset) {
        ShapeBlock block = cast(ShapeBlock)other;
        if (block) {
            Rect2f rMe = Rect2f(Vector2f(0, 0), size);
            Rect2f rOther = Rect2f.Span(offset, block.size);
            return rMe.intersects(rOther);
        }
        ShapeCircle circle = cast(ShapeCircle)other;
        if (circle) {
            Rect2f rMe = Rect2f(Vector2f(0, 0), size);
            return rMe.collideCircle(offset, circle.radius);
        }
        return false;
    }
}

public class ShapeCircle : Shape {
    float radius = 10f;

    public bool collide(Shape other, Vector2f offset) {
        ShapeCircle circle = cast(ShapeCircle)other;
        if (circle) {
            return offset.length() <= radius + circle.radius;
        }
        return false;
    }
}

