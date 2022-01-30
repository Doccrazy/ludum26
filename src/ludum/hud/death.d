module ludum.hud.death;

import common.resset;
import framework.drawing;
import framework.surface;
import framework.font;
import gui.renderbox;
import gui.widget;
import ludum.game;
import ludum.player;
import utils.configfile;
import utils.time;

class DeathMarker : Widget {
    private {
        Game mGame;
        BoxProperties mBox;
        Font mFont;
        char[] mMessage;
    }

    this(Game game, ResourceSet resources, ConfigNode config) {
        setVirtualFrame(false);
        mGame = game;
        mFont = gFontManager.loadFont("big");

        mBox.loadFrom(config.getSubNode("box"));
        mMessage = config["message"];

        minSize = mFont.textSize(mMessage) + Vector2i(mBox.borderWidth*2+4);
    }

    protected void onDraw(Canvas canvas) {
        auto time = timeCurrentTime;
        auto player = mGame.player;

        if (player.health <= 0) {
            drawBox(canvas, Vector2i(0), size, mBox);

            mFont.drawText(canvas, Vector2i(mBox.borderWidth+2), mMessage);
        }
    }
}
