module ludum.hud.health;

import common.resset;
import framework.drawing;
import framework.surface;
import gui.renderbox;
import gui.widget;
import ludum.game;
import ludum.player;
import utils.configfile;
import utils.time;

class HealthBar : Widget {
    private {
        Game mGame;
        BoxProperties mBox;
        Surface mHealthFull, mHealthEmpty;
        Surface mStaminaFull, mStaminaEmpty;
    }

    this(Game game, ResourceSet resources, ConfigNode config) {
        setVirtualFrame(false);
        mGame = game;

        mBox.loadFrom(config.getSubNode("box"));

        mHealthFull = resources.get!(Surface)("health_full");
        mHealthEmpty = resources.get!(Surface)("health_empty");
        mStaminaFull = resources.get!(Surface)("stamina_full");
        mStaminaEmpty = resources.get!(Surface)("stamina_empty");

        minSize = Vector2i(mHealthFull.size.x, mHealthFull.size.y + mStaminaFull.size.y + 5) + Vector2i(mBox.borderWidth*2+4);
    }

    protected void onDraw(Canvas canvas) {
        auto time = timeCurrentTime;
        auto player = mGame.player;

        drawBox(canvas, Vector2i(0), size, mBox);

        Vector2i pos = Vector2i(mBox.borderWidth+2);
        canvas.draw(mHealthEmpty, pos);
        canvas.drawPart(mHealthFull, pos, Vector2i(0), Vector2i(cast(int)(mHealthFull.size.x*(player.health / player.cMaxHealth)), mHealthFull.size.y));

        pos = Vector2i(mBox.borderWidth+2) + Vector2i(0, mHealthFull.size.y + 5);
        canvas.draw(mStaminaEmpty, pos);
        canvas.drawPart(mStaminaFull, pos, Vector2i(0), Vector2i(cast(int)(mStaminaFull.size.x*(player.stamina / player.cMaxStamina)), mStaminaFull.size.y));
    }
}
