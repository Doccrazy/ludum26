module utils.rect2;
import utils.vector2;
import utils.misc : min, max, myformat, realmod;

//T is the most underlying type, i.e. float or int
//NOTE: most member functions expect the rect to be in "normal" form
//      (see normalize() for definition)
public struct Rect2(T) {
    alias Vector2!(T) Point;
    Point p1, p2;

    /+
     +  p1 (0)   pA (3)
     +  pB (1)   p2 (2)
     +  number in (x) for return value of Rect2.edge(x)
     +/
    Point pA() {
        return Point(p2.x, p1.y);
    }
    Point pB() {
        return Point(p1.x, p2.y);
    }

    public static Rect2 opCall(Point p1, Point p2) {
        Rect2 r;
        r.p1 = p1;
        r.p2 = p2;
        return r;
    }
    public static Rect2 opCall(T x1, T y1, T x2, T y2) {
        return Rect2(Point(x1, y1), Point(x2, y2));
    }
    // opCall(Vector2i(0,0), b)
    public static Rect2 opCall(Point b) {
        Rect2 r;
        r.p2 = b;
        return r;
    }

    //rect at point p with that size
    public static Rect2 Span(Point p, Point size) {
        return Rect2(p, p + size);
    }
    public static Rect2 Span(T x, T y, T sx, T sy) {
        return Rect2(x, y, x+sx, y+sy);
    }

    //return a rectangle that could be considered to be "empty"
    // .isNormal() will return false, and the first .extend() will make the
    // rectangle to exactly the extended point, and also makes isNormal()==true
    public static Rect2 Abnormal() {
        Rect2 r;
        r.p1 = Point(T.max);
        r.p2 = Point(T.min);
        return r;
    }

    Point opIndex(uint index) {
        //is that kosher?
        return ((&p1)[0..2])[index];
    }
    void opIndexAssign(Point val, uint index) {
        ((&p1)[0..2])[index] = val;
    }

    //get one of edge 0-3
    // 0 = p1, 1 = pB(), 2 = p2, 3 = pA()
    //4 wraps around to 0 etc.
    Point edge(uint i) {
        return Point((*this)[(i/2) % 2].x, (*this)[((i+1)/2) % 2].y);
    }

    //translate rect by the vector r
    Rect2 opAdd(Point r) {
        Rect2 res = *this;
        res.p1 += r;
        res.p2 += r;
        return res;
    }
    Rect2 opSub(Point r) {
        return *this + (-r);
    }

    void opAddAssign(Point r) {
        p1 += r;
        p2 += r;
    }
    void opSubAssign(Point r) {
        p1 -= r;
        p2 -= r;
    }

    Point size() {
        return p2 - p1;
    }

    Point center() {
        return p1 + (p2-p1)/2;
    }

    bool isNormal() {
        return (p1.x1 <= p2.x1) && (p1.x2 <= p2.x2);
    }

    //normal means: (p1.x1 <= p2.x1) && (p1.x2 <= p2.x2) is true
    void normalize() {
        Rect2 n;
        n.p1.x1 = min(p1.x1, p2.x1);
        n.p1.x2 = min(p1.x2, p2.x2);
        n.p2.x1 = max(p1.x1, p2.x1);
        n.p2.x2 = max(p1.x2, p2.x2);
        *this = n;
    }

    //extend rectangle so that p is inside the rectangle
    //"this" must be "normal"
    //"border" sets so to say the size of the point, should be 1 or 0
    //(isInside(p) will return true)
    void extend(Point p, T border = 1) {
        if (p.x1 < p1.x1) p1.x1 = p.x1;
        if (p.x2 < p1.x2) p1.x2 = p.x2;
        if (p.x1 >= p2.x1) p2.x1 = p.x1+border;
        if (p.x2 >= p2.x2) p2.x2 = p.x2+border;
        if (border) {
            assert(isInside(p));
        } else {
            assert(isInsideB(p));
        }
    }
    //same as above for rectangles
    void extend(Rect2 r) {
        extend(r.p1, 0);
        extend(r.p2, 0);
    }

    //move all 4 borders by this value
    //xxx maybe should clip for too large negative values
    void extendBorder(Point value) {
        p1 -= value;
        p2 += value;
        if (p1.x > p2.x)
            p1.x = p2.x = (p1.x+p2.x)/2;
        if (p1.y > p2.y)
            p1.y = p2.y = (p1.y+p2.y)/2;
    }

    //fit this Rect2 into another Rect2 r
    //isInside will return true for r.p1 and r.p2
    void fitInside(Rect2 r) {
        if (p1.x < r.p1.x)
            p1.x = r.p1.x;
        if (p1.y < r.p1.y)
            p1.y = r.p1.y;
        if (p2.x >= r.p2.x)
            p2.x = r.p2.x-1;
        if (p2.y >= r.p2.y)
            p2.y = r.p2.y-1;
    }
    //same for isInsideB
    void fitInsideB(Rect2 r) {
        if (p1.x < r.p1.x)
            p1.x = r.p1.x;
        if (p1.y < r.p1.y)
            p1.y = r.p1.y;
        if (p2.x > r.p2.x)
            p2.x = r.p2.x;
        if (p2.y > r.p2.y)
            p2.y = r.p2.y;
    }

    bool isInside(Point p) {
        return (p.x1 >= p1.x1 && p.x2 >= p1.x2 && p.x1 < p2.x1 && p.x2 < p2.x2);
    }
    bool isInsideB(Point p) {
        return (p.x1 >= p1.x1 && p.x2 >= p1.x2
            && p.x1 <= p2.x1 && p.x2 <= p2.x2);
    }

    //border is exclusive
    bool intersects(in Rect2 rc) {
        return intersects(rc.p1, rc.p2);
    }
    bool intersects(in Point rc_p1, in Point rc_p2) {
        return (rc_p2.x1 > p1.x1 && rc_p2.x2 > p1.x2
            && rc_p1.x1 < p2.x1 && rc_p1.x2 < p2.x2);
    }

    //return true if this contains rc completely
    bool contains(in Rect2 rc) {
        return (p1.x1 <= rc.p1.x1 && p2.x1 >= rc.p2.x1
            && p1.x2 <= rc.p1.x2 && p2.x2 >= rc.p2.x2);
    }

    //the common rectangle covered by both rectangles
    //result.isNormal() will return false if there's no intersection
    Rect2 intersection(in Rect2 rc) {
        Rect2 r;
        r.p1.x1 = max(p1.x1, rc.p1.x1);
        r.p1.x2 = max(p1.x2, rc.p1.x2);
        r.p2.x1 = min(p2.x1, rc.p2.x1);
        r.p2.x2 = min(p2.x2, rc.p2.x2);
        return r;
    }

    //fast and incorrect check if the circle is inside the rect
    //actually only checks the circle bounding box
    //in some corner cases (literally), the function will return true, even if
    //  the rect and circle don't really collide
    //this matters only when the circle is big compared to the rect
    bool collideCircleApprox(Point pos, T radius) {
        return (pos.x + radius > p1.x
            && pos.x - radius < p2.x
            && pos.y + radius > p1.y
            && pos.y - radius < p2.y);
    }

    bool collideCircle(Point pos, T radius) {
        return isInside(pos)
            || (pA() - p1).collideCircle(p1 - pos, radius)
            || (pB() - p1).collideCircle(p1 - pos, radius)
            || (p2 - pA()).collideCircle(pA() - pos, radius)
            || (p2 - pB()).collideCircle(pB() - pos, radius);
    }

    //substract the rectangles in list from this, and return what's left over
    //the rects in list may intersect, and the resulting rects won't intersect
    Rect2[] substractRects(Rect2[] list) {
        Rect2[] cur = [*this]; //cur = what's left over
        foreach (ref rem; list) {
            Rect2[] cur2;
            foreach (ref rc; cur) {
                //substract rem from rc, which either removes rc2, possibly
                //modifies it, or adds up to 3 additional rectangles
                if (!rc.intersects(rem)) {
                    cur2 ~= rc;
                    continue;
                } else if (rem.contains(rc)) {
                    //remove this one, so don't readd
                    continue;
                }
                //intersect in some irky way => up to 4 rects
                //top/bottom and the 4 corners
                if (rc.p1.y < rem.p1.y) {
                    cur2 ~= Rect2(rc.p1, Point(rc.p2.x, rem.p1.y));
                }
                if (rc.p2.y > rem.p2.y) {
                    cur2 ~= Rect2(Point(rc.p1.x, rem.p2.y), rc.p2);
                }
                //left/right
                T y1 = max(rem.p1.y, rc.p1.y);
                T y2 = min(rem.p2.y, rc.p2.y);
                if (rc.p1.x < rem.p1.x) {
                    cur2 ~= Rect2(Point(rc.p1.x, y1), Point(rem.p1.x, y2));
                }
                if (rc.p2.x > rem.p2.x) {
                    cur2 ~= Rect2(Point(rem.p2.x, y1), Point(rc.p2.x, y2));
                }
            }
            cur = cur2;
        }
        return cur;
    }

    //clip pt to this rect; isInsideB(clip(pt)) will always return true
    //(isInside() won't; also NaNs may mess it all up when using floats)
    Point clip(in Point pt)
    //removed because sometimes it's inconvenient out(r) {assert(isInsideB(r));}
    body {
        Point r = pt;
        if (r.x2 > p2.x2)
            r.x2 = p2.x2;
        if (r.x2 < p1.x2)
            r.x2 = p1.x2;
        if (r.x1 > p2.x1)
            r.x1 = p2.x1;
        if (r.x1 < p1.x1)
            r.x1 = p1.x1;
        return r;
    }

    //return this rectangle centered at pos
    Rect2 centeredAt(Point pos) {
        auto s = size();
        pos -= s/2;
        return *this + pos;
    }

    //assuming there's an object with the rect rc, move it inside the "this"
    //  rect; if it's already inside, don't move
    Rect2 moveInside(Rect2 rc) {
        if (rc.p1.x < p1.x)
            rc += Point(p1.x - rc.p1.x, 0);
        if (rc.p2.x > p2.x)
            rc -= Point(rc.p2.x - p2.x, 0);
        if (rc.p1.y < p1.y)
            rc += Point(0, p1.y - rc.p1.y);
        if (rc.p2.y > p2.y)
            rc -= Point(0, rc.p2.y - p2.y);
        return rc;
    }

    //extend rect so, that the rect starts and ends on tile boundaries
    void fitTileGrid(Point tilesize) {
        void doalign(ref T p, T sz, bool roundup) {
            T offs = realmod(p, sz);
            if (offs == 0)
                return;
            if (!roundup) {
                p -= offs;
            } else {
                p += sz - offs;
            }
        }
        doalign(p1.x, tilesize.x, false);
        doalign(p1.y, tilesize.y, false);
        doalign(p2.x, tilesize.x, true);
        doalign(p2.y, tilesize.y, true);
    }

    char[] toString() {
        return myformat("[{} - {}]", p1, p2);
    }
}

alias Rect2!(int) Rect2i;
alias Rect2!(float) Rect2f;

Rect2f toRect2f(Rect2i r) {
    return Rect2f(toVector2f(r.p1), toVector2f(r.p2));
}

Rect2i toRect2i(Rect2f r) {
    return Rect2i(toVector2i(r.p1), toVector2i(r.p2));
}
