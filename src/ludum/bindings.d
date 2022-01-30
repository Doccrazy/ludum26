module ludum.bindings;

import framework.event;
import framework.keybindings;
import framework.main;
import utils.misc;
import utils.vector2;

public class BindingAdapter {
    private {
        bool delegate(char[] cmd) mHandler;
        KeyBindings mBindings;
        //key currently held down (used for proper key-up notification)
        BindKey[] mKeyDown;
        //additional buffer for mKeyDown to simplify code
        BindKey[] mKeyDownBuffer;
    }

    public this(bool delegate(char[] cmd) handler, KeyBindings bindings) {
        mHandler = handler;
        mBindings = bindings;
    }

    public bool onKeyDown(KeyInfo ki, Vector2i mousePos) {
        //if repeated, consider as handled, but throw away anyway
        if (ki.isRepeated)
            return true;

        bool handled = doKeyEvent(ki, mousePos);

        if (handled) {
            //xxx only some key bindings (as handled in doKeyEvent) actually
            //  want a key-up event; in this case one wouldn't need this
            BindKey key = BindKey.FromKeyInfo(ki);
            key.mods = 0;
            mKeyDown ~= key;
        }

        return handled;
    }

    public void onKeyUp(KeyInfo ki, Vector2i mousePos) {
        //doKeyEvent(ki);
        //explicitly check key state in case - this is needed because the key-up
        //  events can be inconsistent to the key bindings (e.g. consider the
        //  sequence left-down, ctrl-down, left-up, ctrl-up: we receive left-up
        //  with the ctrl modifier set, which doesn't match the normal left-key
        //  binding => code for left-up is never executed)
        //xxx maybe move this into simulate() (polling) and simplify the GUI
        //  code (possibly move all this into widget.d?)
        mKeyDownBuffer.length = 0;
        foreach (BindKey k; mKeyDown) {
            //still pressed?
            if (gFramework.getKeyState(k.code)
                && gFramework.getModifierSetState(k.mods))
            {
                //entry survives
                mKeyDownBuffer ~= k;
            } else {
                //synthesize key-up event
                KeyInfo nki;
                nki.code = k.code;
                nki.mods = k.mods;
                nki.isDown = false;
                doKeyEvent(nki, mousePos);
            }
        }
        swap(mKeyDown, mKeyDownBuffer);
    }

    private bool doKeyEvent(KeyInfo ki, Vector2i mousePos) {
        BindKey key = BindKey.FromKeyInfo(ki);
        key.mods = 0;
        char[] bind = mBindings.findBinding(key);

        bind = processBinding(bind, ki, mousePos);

        return doInput(bind);
    }

    public void onMouseMove(MouseInfo mouse) {
        //if in use, this causes excessive traffic in network mode
        //but code that uses this is debug code anyway, and it doesn't matter
        KeyInfo ki;
        ki.isDown = true;
        ki.mods = gFramework.getModifierSet();
        char[40] buffer = void;
        doInput(processBinding("mouse_move %mx %my", ki, mouse.pos, buffer));
    }

    //takes a binding string from KeyBindings and replaces params
    //  %d -> true if key was pressed, false if released
    //  %mx, %my -> mouse position
    //also, will not trigger an up event for commands without %d param
    //buffer can be memory of any size that will be used to reduce heap allocs
    private char[] processBinding(char[] bind, KeyInfo ki, Vector2i mousePos, char[] buffer = null)
    {
        bool isUp = !ki.isDown;
        //no up/down parameter, and key was released -> no event
        if (str.find(bind, "%d") < 0 && isUp)
            return null;
        auto txt = StrBuffer(buffer);
        txt.sink(bind);
        str.buffer_replace_fmt(txt, "%d", "{}", !isUp);
        str.buffer_replace_fmt(txt, "%mx", "{}", mousePos.x);
        str.buffer_replace_fmt(txt, "%my", "{}", mousePos.y);
        return txt.get;
    }

    private bool doInput(char[] s) {
        if (!s.length)
            return false;
        return mHandler(s);
    }
}
