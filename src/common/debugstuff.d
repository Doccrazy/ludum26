module common.debugstuff;

import common.globalconsole;
import common.gui_init;
import common.init; //import to force log initialization
import common.resources;
import common.stats;
import common.task;
import framework.commandline;
import framework.config;
import framework.event;
import framework.filesystem;
import framework.keybindings;
import framework.main;
import framework.sound;
import gui.boxcontainer;
import gui.button;
import gui.console;
import gui.label;
import gui.tablecontainer;
import gui.widget;
import gui.window;
import utils.array;
import utils.configfile;
import utils.factory;
import utils.log;
import utils.misc;
import utils.mybox;
import utils.output;
import utils.perf;
import utils.stream;
import utils.time;
import utils.vector2;

import str = utils.string;

import memory = tango.core.Memory;
import conv = tango.util.Convert;
import cstdlib = tango.stdc.stdlib;

//some more debugging - these use static this to register themselves
import common.resview;
import gui.test;

debug {
} else {
    //not debug
    static assert("debugstuff.d should be included in debug mode only");
}

static if (is(typeof(&memory.GC.getDebug))) {
    const GCStatsHack = true;
} else {
    const GCStatsHack = false;
}

//version = ENABLE_GC_TRACE;

//gc_stats() API, which Tango doesn't expose to the user for very retarded
//  reasons, and there have been various attempts to expose such functionality
//  to the user, which all failed - see Tango #1702
//well, fuck this, instead I'll just using some violence to access this
struct GCStats //from gcstats.d
{
    size_t poolsize;        // total size of pool
    size_t usedsize;        // bytes allocated
    size_t freeblocks;      // number of blocks marked FREE
    size_t freelistsize;    // total of memory on free lists
    size_t pageblocks;      // number of blocks marked PAGE
}
extern (C) GCStats gc_stats(); //from gc.d

Time gGcTime = Time.Null;
Time gGcLastTime = Time.Null;
size_t gGcFreed = 0;
size_t gGcCounter;

//was added after 0.99.9 to trunk (xxx: remove the static if on next release)
static if (is(typeof(&memory.GC.monitor))) {

Time gGcStart;
//these callbacks are called by the GC on start/end of a collection
//they must be async-signal safe (they also are protected by the gc lock)
void gc_monitor_begin() {
    gGcCounter++;
    gGcStart = perfThreadTime();
}
//no idea what these params are; they return sizes, but why the hell are
//  these ints, and not size_t? (they may fix it later)
void gc_monitor_end(int a, int b) {
    gGcLastTime = perfThreadTime() - gGcStart;
    gGcTime += gGcLastTime;
    gGcFreed += a;
}
static this() {
    //not using toDelegate() here, because the wrappers would be GC'ed
    memory.GC.monitor(() { gc_monitor_begin(); },
        (int a, int b) { gc_monitor_end(a, b); });
}

}

//sorry for the kludge; just for statistics
version (linux) {
    //gnu libc specific
    //http://www.gnu.org/s/libc/manual/html_node/Statistics-of-Malloc.html
    struct mallinfo_s {
        //note: these are C ints
        int arena;
        int ordblks;
        int smblks;
        int hblks;
        int hblkhd;
        int usmblks;
        int fsmblks;
        int uordblks;
        int fordblks;
        int keepcost;
    }
    extern (C) mallinfo_s mallinfo();

    //stats[0] = allocated size
    //stats[1] = free size
    //stats[2] = mmap'ed size
    void get_cmalloc_stats(size_t[3] stats) {
        auto mi = mallinfo();
        stats[0] = mi.arena;
        stats[1] = 0; //???
        stats[2] = mi.hblkhd;
    }
} else {
    void get_cmalloc_stats(size_t[3] stats) {
        stats[] = 0;
    }
}

Stuff gStuff;

static this() {
    new Stuff();
}

class Stuff {
    Time[PerfTimer] mLastTimerValues;
    long[char[]] mLastCounterValues;
    size_t[char[]] mLastSizeStatValues;

    const cTimerStatsUpdateTimeMs = 1000;

    Time mLastTimerStatsUpdate;
    int mLastTimerStatsFrames;
    bool mLastTimerInitialized;
    int mTimerStatsGeneration;

    PerfTimer mFrameTime;

    int mPrevGCCount;

    bool mKeyNameIt = false;

    private this() {
        assert(!gStuff);
        gStuff = this;

        mFrameTime = newTimer("frame_time");

        auto cmds = gCommands;
        cmds.registerCommand("gc", &testGC, "", ["bool?=true"]);
        cmds.registerCommand("gcmin", &cmdGCmin, "");

        gCatchInput ~= &nameit;
        cmds.registerCommand("nameit", &cmdNameit, "");

        cmds.registerCommand("res_load", &cmdResLoad, "", ["text"]);
        cmds.registerCommand("res_unload", &cmdResUnload, "", []);

        cmds.registerCommand("dir", &cmdDir, "", ["text"]);

        static if (GCStatsHack) {
            gLog.notice("precise GC: {}", memory.GC.getDebug()
                .precise_scanning());
            //warning: assumes 'this' is always referenced by the rootset
            //  (same issue as with GC.monitor())
            memory.GC.getDebug.setcollectcb(&collectcb);
            version (ENABLE_GC_TRACE) {
                memory.GC.getDebug.setalloccb(&alloccb);
            }

            cmds.registerCommand("gciter", &cmdGCIter, "");
            cmds.registerCommand("gctrace", &cmdGCTrace, "", ["text", "int?=1"]);
            cmds.registerCommand("gcarrtrace", &cmdGCArrayTrace, "",
                ["text"]);
            cmds.registerCommand("gcsweeps", &cmdGCSweeps, "");
            cmds.registerCommand("gcsweeps_alloc", &cmdGCSweepsAlloc, "");
        }

        gFramework.onFrameEnd = &onFrameEnd;
        addTask(&onFrame);
    }

    private bool onFrame() {
        debug {
            int gccount = gGcCounter;
            if (gccount != mPrevGCCount) {
                gLog.minor("GC run detected ({} total)", gccount);
                mPrevGCCount = gccount;
            }
        }

        setCounter("soundchannels", gSoundManager.activeSources());

        return true;
    }

    private void onFrameEnd() {
        mFrameTime.stop();

        Time cur = timeCurrentTime();
        if (!mLastTimerInitialized) {
            mLastTimerStatsUpdate = cur;
            mLastTimerStatsFrames = 1;
            mLastTimerInitialized = true;
        }
        if (cur - mLastTimerStatsUpdate >= timeMsecs(cTimerStatsUpdateTimeMs)) {
            mTimerStatsGeneration++;
            mLastTimerStatsUpdate = cur;
            int div = mLastTimerStatsFrames;
            mLastTimerStatsFrames = 0;
            foreach (PerfTimer cnt; gTimers) {
                assert(!cnt.active, "timers must be off across frames");
                auto t = cnt.time();
                mLastTimerValues[cnt] = t / div;
                cnt.reset();
            }
            foreach (char[] name, ref long cnt; gCounters) {
                mLastCounterValues[name] = cnt;
                cnt = 0;
            }
            foreach (char[] name, ref size_t sz; gSizeStats) {
                mLastSizeStatValues[name] = sz;
                sz = 0;
            }
        }
        mLastTimerStatsFrames++;

        mFrameTime.start();
    }

    void listTimers(void delegate(char[] name, Time value) cb) {
        foreach (char[] name, PerfTimer cnt; gTimers) {
            Time* pt = cnt in mLastTimerValues;
            Time t = Time.Never;
            if (pt)
                t = *pt;
            cb(name, t);
        }
    }
    void listCounters(void delegate(char[] name, long value) cb) {
        foreach (char[] name, long cnt; gCounters) {
            long* pt = name in mLastCounterValues;
            long t = 0;
            if (pt)
                t = *pt;
            cb(name, t);
        }
    }
    void listSizeStats(void delegate(char[] name, size_t sz) cb) {
        foreach (char[] name, size_t sz; gSizeStats) {
            size_t* ps = name in mLastSizeStatValues;
            size_t s = 0;
            if (ps)
                s = *ps;
            cb(name, s);
        }
    }

    private void testGC(MyBox[] args, Output write) {
        if (args[0].unbox!(bool)) {
            auto n = gFramework.releaseCaches(false);
            write.writefln("release caches: {} house shoes", n);
        }
        size_t getsize() { return gc_stats().usedsize; }
        auto counter = new PerfTimer();
        auto a = getsize();
        counter.start();
        memory.GC.collect();
        counter.stop();
        auto b = getsize();
        write.writefln("GC fullcollect: {}, free'd {}", counter.time,
            str.sizeToHuman(a - b));
        memory.GC.minimize();
        auto c = getsize();
        write.writefln("  ...minimize: {}", str.sizeToHuman(c - b));
    }
    private void cmdGCmin(MyBox[] args, Output write) {
        memory.GC.minimize();
    }
    private void cmdGCIter(MyBox[] args, Output write) {
        static if (GCStatsHack)
            doiter();
    }
    private void cmdGCTrace(MyBox[] args, Output write) {
        static if (GCStatsHack)
            dotrace(args[0].unbox!(char[]), args[1].unbox!(int));
    }
    private void cmdGCArrayTrace(MyBox[] args, Output write) {
        static if (GCStatsHack)
            //pure evil
            doarraytrace(cast(void*)cstdlib.strtoul((args[0].unbox!(char[])~'\0').ptr, null, 16));
    }
    private void cmdGCSweeps(MyBox[] args, Output write) {
        static if (GCStatsHack)
            showsweepstats();
    }
    private void cmdGCSweepsAlloc(MyBox[] args, Output write) {
        static if (GCStatsHack)
            showallocatorstats();
    }

    private void cmdNameit(MyBox[] args, Output write) {
        mKeyNameIt = true;
    }

    private bool nameit(InputEvent event) {
        //something similar will be needed for a proper keybindings editor
        if (!mKeyNameIt)
            return false;
        if (!event.isKeyEvent || !event.keyEvent.isDown)
            return false;

        BindKey key = BindKey.FromKeyInfo(event.keyEvent);

        gLog.notice("Key: '{}' '{}', code={} mods={}",
            key.unparse(), translateKeyshortcut(key), key.code, key.mods);

        //modifiers are also keys, ignore them
        if (!event.keyEvent.isModifierKey()) {
            mKeyNameIt = false;
        }

        return true;
    }

    private void cmdResUnload(MyBox[] args, Output write) {
        gResources.unloadAll();
    }

    private void cmdResLoad(MyBox[] args, Output write) {
        char[] s = args[0].unbox!(char[])();
        gResources.loadResources(s);
    }

    private void cmdDir(MyBox[] args, Output write) {
        char[] s = args[0].unbox!(char[])();
        write.writefln("list '{}':", s);
        gFS.listdir(s, "*", true, (char[] d) {
            write.writefln("  {}", d);
            return true;
        });
    }

    static if (GCStatsHack) {
        private void collectcb(memory.BlockInfo b) {
            docollect(b.ptr, b.blksize, b.tag, b.trace);
        }

        private void* alloccb(memory.BlockInfo b) {
            return doalloc(b);
        }
    }
}


class StatsWindow {
    Stuff bla;
    int lastupdate = -1;
    WindowWidget wnd;
    TableContainer table;
    //stores strings for each line (each line 40 bytes)
    //this is to avoid memory allocation each frame
    char[40][] buffers;

    this() {
        bla = gStuff;
        table = new TableContainer(2, 0, Vector2i(10, 0));
        //rettet die statistik
        wnd = gWindowFrame.createWindow(table, "Statistics");
        auto props = wnd.properties;
        props.zorder = WindowZOrder.High;
        wnd.properties = props;

        addTask(&onFrame);
    }

    private bool onFrame() {
        if (wnd.wasClosed())
            return false;

        if (bla.mTimerStatsGeneration != lastupdate) {
            lastupdate = bla.mTimerStatsGeneration;

            int line = 0;

            char[] lineBuffer() {
                if (buffers.length <= line)
                    buffers.length = line+1;
                return buffers[line];
            }

            void addLine(char[] a, char[] b) {
                Label la, lb;
                if (line >= table.height) {
                    table.setSize(table.width, line+1);
                }
                if (!table.get(0, line)) {
                    la = new Label();
                    lb = new Label();
                    table.add(la, 0, line);
                    table.add(lb, 1, line, WidgetLayout.Aligned(+1, 0));
                } else {
                    la = cast(Label)table.get(0, line);
                    lb = cast(Label)table.get(1, line);
                }
                la.text = a;
                lb.text = b;

                line++;
            }

            void number(char[] name, long n) {
                addLine(name, myformat_s(lineBuffer(), "{}", n));
            }
            void size(char[] name, size_t s) {
                addLine(name, str.sizeToHuman(s, lineBuffer()));
            }
            void time(char[] name, Time t) {
                addLine(name, t.toString_s(lineBuffer()));
            }

            auto gcs = gc_stats();

            size("gc.poolsize", gcs.poolsize);
            size("gc.usedsize", gcs.usedsize);
            size("gc.freelistsize", gcs.freelistsize);
            number("gc.freeblocks", gcs.freeblocks);
            number("gc.pageblocks", gcs.pageblocks);
            number("GC count", gGcCounter);
            time("GC collect time", gGcLastTime);
            time("GC collect time (sum)", gGcTime);
            size("GC free'd", gGcFreed);

            size_t[3] mstats;
            get_cmalloc_stats(mstats);
            size("C malloc", mstats[0]);
            size("C malloc-mmap", mstats[2]);

            size("C malloc (BigArray)", gBigArrayMemory);

            number("Weak objects", gFramework.weakObjectsCount);

            bla.listTimers(&time);
            bla.listCounters(&number);
            bla.listSizeStats(&size);

            //avoid that the window resizes on each update
            wnd.acceptSize();
        }

        return true;
    }

    static this() {
        registerTaskClass!(typeof(this))("stats");
    }
}

//GUI to disable or enable log targets
class LogConfig {
    CheckBox[char[]] mLogButtons;
    BoxContainer mLogList;
    WindowWidget mWindow;

    this() {
        mLogList = new BoxContainer(false);
        auto main = new BoxContainer(false);
        main.add(mLogList);
        auto save = new Button();
        save.text = "Save to disk";
        save.onClick = &onSave;
        main.add(save);

        addLogs();

        mWindow = gWindowFrame.createWindow(main, "Logging Configuration");

        addTask(&onFrame);
    }

    void onToggle(CheckBox sender) {
        foreach (char[] name, CheckBox b; mLogButtons) {
            if (sender is b) {
                registerLog(name).minPriority =
                    sender.checked ? LogPriority.Trace : LogPriority.Minor;
                return;
            }
        }
    }

    void onSave(Button sender) {
        char[] fname = "logconfig.conf";
        ConfigNode config = loadConfig(fname, true);
        config = config ? config : new ConfigNode();
        auto logs = config.getSubNode("logs");
        foreach (char[] name, Log log; gAllLogs) {
            logs.setValue!(bool)(name, log.minPriority <= LogPriority.Trace);
        }
        saveConfig(config, fname);
    }

    void addLogs() {
        foreach (char[] name, Log log; gAllLogs) {
            auto pbutton = name in mLogButtons;
            CheckBox button = pbutton ? *pbutton : null;
            if (!button) {
                //actually add
                button = new CheckBox();
                button.text = name;
                button.onClick = &onToggle;
                mLogButtons[name] = button;
                mLogList.add(button);
            }
            button.checked = log.minPriority <= LogPriority.Trace;
        }
    }

    private bool onFrame() {
        if (mWindow.wasClosed())
            return false;
        //every frame check for new log entries; stupid but robust
        addLogs();
        return true;
    }

    static this() {
        registerTaskClass!(typeof(this))("logconfig");
    }
}

static this() {
    registerTask("console", (char[] args) {
        gWindowFrame.createWindowFullscreen(new GuiConsole(getCommandLine()),
            "Console");
        return Object.init;
    });
}

static if (GCStatsHack) {

import tango.core.Array;
import tango.core.tools.StackTrace;
import tango.core.tools.Demangler;

class Unknown {
    char[] toString() { return "<?> unknown type"; }
}

void doiter() {
    scope xx = new BigArray!(memory.BlockInfo);
    memory.GC.collect();
    memory.GC.getDebug().iterate((memory.BlockInfo blk) {
        xx.length = xx.length + 1;
        xx[][$-1] = blk;
        return true;
    });
    scope Unknown anon = new Unknown;
    struct Foo {
        Object type;
        size_t size;
        size_t rsize;
        size_t count;
    }
    Foo[Object] stuff;
    foreach (ref memory.BlockInfo b; xx[]) {
        Object c = b.tag ? b.tag : anon;
        auto p = c in stuff;
        if (!p) {
            stuff[c] = Foo.init;
            p = c in stuff;
            p.type = c;
        }
        p.size += b.size;
        p.rsize += b.blksize;
        p.count++;
    }
    Foo[] moo = stuff.values;
    sort(moo, (Foo a, Foo b) {
        return a.rsize < b.rsize;
    });
    size_t sum, rsum, count;
    foreach (ref x; moo) {
        Trace.formatln("{}   {} ({} {})", x.count, x.type.toString, str.sizeToHuman(x.rsize),
            str.sizeToHuman(0)); //x.count * x.type.init.length));
        sum += x.size;
        rsum += x.rsize;
        count += x.count;
    }
    Trace.formatln("#={} types={} sum={}, rsum={}", count, moo.length, str.sizeToHuman(sum), str.sizeToHuman(rsum));
    foreach (ref f; moo) {
        stuff.remove(f.type);
    }
    stuff.rehash;
    delete moo;
}

//look for objects whose class name contains x
//trace the nth found object
void dotrace(char[] x, int nth) {
    scope bits_st = new BigArray!(ubyte);
    //spanning all of the 4GB address room, in 16 byte units (8 bit => 16*8 per byte)
    bits_st.length = 33554432;
    ubyte[] bits = bits_st[];
    bits[] = 0;
    memory.GC.collect();
    memory.BlockInfo start;
    auto dbg = memory.GC.getDebug();
    dbg.iterate((memory.BlockInfo blk) {
        if ((blk.tag && str.find(blk.tag.toString, x) >= 0)
            || (x == "?" && !blk.tag))
        {
            nth--;
            if (nth == 0) {
                start = blk;
                return false;
            }
        }
        return true;
    });
    if (!start.ptr) {
        Trace.formatln("nothing found");
        return;
    }

    bool dotrace(int maxdepth, memory.BlockInfo trace) {
        if (maxdepth < 0)
            return false;

        //prevent exponential complexity
        size_t px = (cast(size_t)trace.ptr) / 16;
        auto bp = px/8;
        auto bit = 1 << (px%8);
        if (bits[bp] & bit)
            return false;
        bits[bp] |= bit;

        Trace.formatln("tracing: {} {} {}", trace.ptr, trace.size,
            trace.tag ? trace.tag.toString : "<?>");

        bool retval;
        dbg.trace(trace.ptr, trace.ptr + trace.size, (memory.TraceInfo info) {

            Trace.formatln(" => {}", info.ref_from);
            auto pp = *cast(void**)(info.ref_from);
            assert(pp >= trace.ptr && pp < trace.ptr + trace.size);

            memory.BlockInfo ntrace;

            if (info.is_gc) {
                if (!dbg.getinfo(info.ref_from, ntrace)) {
                    assert(false, "internal error");
                }
                if (dotrace(maxdepth - 1, ntrace)) {
                    goto success;
                }
                return true;
            }

            Trace.formatln("terminate at: {} -> {}", info.ref_from, trace.ptr);

            //recursion termination
            if (info.is_dataseg)
                Trace.formatln("data segment");
            if (info.is_stack)
                Trace.formatln("stack");
            if (info.is_range)
                Trace.formatln("range/root");
        success:
            if (ntrace.ptr) {
                assert(info.ref_from - ntrace.ptr < ntrace.size);
                Trace.formatln("- {} ({}+{}) => {} {} : {}", info.ref_from,
                    ntrace.ptr, info.ref_from - ntrace.ptr, trace.ptr,
                    trace.size, trace.tag ? trace.tag.toString : "<?>");
            } else {
                Trace.formatln("- {} => {} {} : {}", info.ref_from, trace.ptr,
                    trace.size, trace.tag ? trace.tag.toString : "<?>");
            }
            retval = true;
            return false;
        });
        return retval;
    }

    if (!dotrace(100, start)) {
        Trace.formatln("failed.");
    }
    Trace.formatln("was tracing: {} {} {}", start.ptr, start.size,
        start.tag ? start.tag.toString : "<?>");
}

//assume p points to array memory (i.e. the stuff starting at arr.ptr)
//find all array slice descriptors pointing to it and print how much of the
//  array is covered
void doarraytrace(void* p) {
    auto dbg = memory.GC.getDebug();
    memory.BlockInfo blk;
    if (!dbg.getinfo(p, blk)) {
        Trace.formatln("not a GC block");
        return;
    }
    Trace.formatln("found ptr={} size={} type={}", blk.ptr, blk.size, blk.tag);
    auto tia = cast(TypeInfo_Array)blk.tag;
    if (!tia) {
        Trace.formatln("doesn't seem to be an array");
        return;
    }
    size_t sz = tia.next.tsize;
    size_t maxlen = blk.size / sz;
    Trace.formatln("   item type={} size={}", tia.next, sz);
    Trace.formatln("   maxlen={}", maxlen);
    Trace.formatln("trace:");
    size_t smin = maxlen;
    size_t smax = 0;
    dbg.trace(blk.ptr, blk.ptr + blk.size, (memory.TraceInfo info) {
        void* from = info.ref_from;
        struct Array {
            size_t length; //in items, not bytes
            void* ptr;
        }
        Array* slice = cast(Array*)(from - size_t.sizeof);
        size_t offset = (slice.ptr - blk.ptr) / sz;
        smin = min(smin, offset);
        smax = max(smax, offset + slice.length);
        Trace.formatln("  {} start={} length={}", from, offset, slice.length);
        return true;
    });
    Trace.formatln("min={} max={}", smin, smax);
    if (sz == size_t.sizeof && blk.size < 10) {
        Trace.formatln("dumping array as void*[]...");
        for (uint n = 0; n < blk.size/(void*).sizeof; n++) {
            void* d = *((cast(void**)blk.ptr) + n);
            Trace.formatln("    [{}] = {}", n, d);
        }
    }
}

struct TagRecord {
    Object tag;
    size_t count;
    size_t memory;
}

//BigArray is used because it uses malloc()
BigArray!(TagRecord) gTags;

struct AllocatorRecord {
    void* allocator;
    size_t count;
    size_t memory;
}

BigArray!(AllocatorRecord) gAllocs;

static this() {
    gTags = new typeof(gTags)();
    gAllocs = new typeof(gAllocs)();
}

void docollect(void* ptr, size_t size, Object tag, void* allocator) {
    collect_tag(size, tag);
    collect_allocator(size, allocator);
}

void collect_tag(size_t size, Object tag) {
    TagRecord[] arr = gTags[];
    foreach (ref r; arr) {
        if (r.tag is tag) {
            r.count++;
            r.memory += size;
            return;
        }
    }
    gTags ~= TagRecord(tag, 1, size);
}

void collect_allocator(size_t size, void* allocator) {
    AllocatorRecord[] arr = gAllocs[];
    foreach (ref r; arr) {
        if (r.allocator is allocator) {
            r.count++;
            r.memory += size;
            return;
        }
    }
    gAllocs ~= AllocatorRecord(allocator, 1, size);
}

//show stats what has been collected
void showsweepstats() {
    scope copy = new BigArray!(TagRecord)();
    synchronized (memory.GC.getDebug.gclock()) {
        copy ~= gTags[];
        //reset stats
        gTags.length = 0;
    }
    sort(copy[], (TagRecord a, TagRecord b) {
        return a.memory < b.memory;
    });
    size_t all_count, all_memory;
    foreach (TagRecord r; copy[]) {
        Trace.formatln("{} {} ({})", r.count, r.tag ? r.tag.toString() : "?",
            str.sizeToHuman(r.memory));
        all_memory += r.memory;
        all_count += r.count;
    }
    Trace.formatln("sum=#{} / {}", all_count, str.sizeToHuman(all_memory));
}

void showallocatorstats() {
    scope copy = new BigArray!(AllocatorRecord)();
    synchronized (memory.GC.getDebug.gclock()) {
        copy ~= gAllocs[];
        //reset stats
        gAllocs.length = 0;
    }
    sort(copy[], (AllocatorRecord a, AllocatorRecord b) {
        return a.memory < b.memory;
    });

    char[] format_caller(void* caller) {
        if (!caller)
            return "???";

        //more or less stolen from StackTrace.d
        Exception.FrameInfo fInfo;
        fInfo.address = cast(size_t)caller;
        rt_symbolizeFrameInfo(fInfo, null, null);
        fInfo.func = demangler.demangle(fInfo.func);

        return myformat("{}:{} => {}", fInfo.file, fInfo.line, fInfo.func);
    }

    foreach (AllocatorRecord r; copy[]) {
        Trace.formatln("{} => #={} sum={}", format_caller(r.allocator),
            r.count, str.sizeToHuman(r.memory));
    }
}

//all these runtime functions are entrypoints to gc_malloc()
//the functions are compiler specific - this is for dmd
//any other compiler: unsupported, though easy to support (have to extract
//  list of runtime functions from rt/lifetime.d)
const char[][] cRTFns = ["_d_newclass", "_d_newarrayT", "_d_newarrayiT",
    "_d_newarraymT", "_d_newarraymiT",
    "_d_arraysetlengthT", "_d_arraysetlengthiT", "_d_arrayappendT",
    "_d_arrayappendcT", "_d_arrayappendcd", "_d_arrayappendwd",
    "_d_arraycatT", "_d_arraycatnT", "_d_arrayliteralT", "_adDupT",
    //"new" AA ABI - assumes patched compiler
    //xxx many of these functions call other runtime functions => inexact
    "_d_aaGet", "_d_aaValues", "_d_aaKeys", "_d_aaRehash", "_d_aaLiteral"];

struct FunctionEntry {
    void* start, end;
    //debugging
    char[] entry;
    char[] toString() { return myformat("{:x}-{:x} {}", start, end, entry); }
}

FunctionEntry[] g_rt_fns;

//need to fill g_rt_fns
//what we actually need is to find out if a specific address points inside of
//  a runtime function (i.e. if the caller is a runtime function; the address
//  will point to/after a call instruction in the function)
version (linux) {
    //for some reason, this module exposes all its internal stuff
    import tango.core.tools.LinuxStackTrace;
    static this() {
        //adapted from elfSymbolizeFrameInfo() from StackTrace.d
        foreach(symName,symAddr,symEnd,pub;StaticSectionInfo) {
            if (arraySearch(cRTFns, symName) >= 0) {
                g_rt_fns ~= FunctionEntry(cast(void*)symAddr,
                    cast(void*)symEnd, symName);
            }
        }
        //Trace.formatln("{}", g_rt_fns);
    }
}

void* find_alloc_caller() {
    const cDepth = 20; //must be deep enough to hit the runtime function
    size_t size = cDepth*size_t.sizeof;
    void*[] pbt = cast(void*[])(cstdlib.alloca(size)[0..size]);
    //both TraceContext params are probably unneeded and can be null (?)
    int flags; //but this appartently can't be a null-ptr?
    size_t cnt = rt_addrBacktrace(null, null, cast(size_t*)pbt.ptr, pbt.length,
        &flags);
    //find first RT function
    int cur = cnt - 1;
    while (cur >= 0) {
        void* addr = pbt[cur];
        foreach (ref e; g_rt_fns) {
            if (addr >= e.start && addr < e.end) {
                //return the function that calls the RT function
                if (cur + 1 < pbt.length) {
                    return pbt[cur + 1];
                }
            }
        }
        cur--;
    }
    //unknown
    return null;
}

void* doalloc(memory.BlockInfo b) {
    return find_alloc_caller();
}

}
