module ludum.player;

import ludum.entity;
import ludum.shape;
import ludum.game;
import ludum.trap;
import math = tango.math.Math;
import utils.math;
import utils.misc;
import utils.log;
import utils.configfile;

LogStruct!("player") log;

public class Player : Entity {
    const float cSpeed = 40f;
    const float cTurnSpeed = math.PI;

    const float cMaxHealth = 100f;
    const float cSprintSpeed = 70f;
    const float cMaxStamina = 100f;
    const float cSprintStaminaPerSec = 75f;
    const float cStaminaRegenPerSec = 25f;

    float rotation = 0;
    float health = cMaxHealth;
    float stamina = cMaxStamina;

    Vector2i move;
    int rotate = 0;
    bool sprint;

    bool[char[]] activeTriggers;
    bool[char[]] activeTriggersOld;

    public this(ConfigNode config) {
        pos = config.getValue("pos", pos);
        rotation = config.getValue("rotation", rotation) / 180.0f*math.PI;
        health = config.getValue("health", health);
        auto circle = new ShapeCircle();
        circle.radius = 7;
        shape = circle;
    }

    protected void doSimulate(Game game) {
        handleMovement(game);
        handleTriggers(game);
    }

    private void handleMovement(Game game) {
        float delta = game.time.difference.secsf;

        Vector2f posBak = pos;
        if (move != Vector2i(0)) {
            Vector2f dMove = toVector2f(move)*delta;
            if (sprint && stamina > 0) {
                dMove = dMove*cSprintSpeed;
                stamina = math.max(0f, stamina - cSprintStaminaPerSec*delta);
            } else {
                dMove = dMove*cSpeed;
            }
            if (dMove.y > 0) {
                dMove = dMove/2;
            }
            dMove = dMove.rotated(rotation);
            pos.x = pos.x + dMove.x;
            if (game.rootEntity.collideSolid(this)) {
                pos.x = posBak.x;
            }
            pos.y = pos.y + dMove.y;
            if (game.rootEntity.collideSolid(this)) {
                pos.y = posBak.y;
            }
        }
        if (rotate != 0) {
            rotation = realmod(rotation + rotate*cTurnSpeed*delta, cast(float)math.PI*2f);;
        }
        if (!sprint) {
            stamina = math.min(cMaxStamina, stamina + cStaminaRegenPerSec*delta);
        }
        if (health <= 0) {
            stamina = 0;
            game.triggerEvent("playerDie", this);
            kill();
        }
        //log.notice("Stamina = {}", stamina);
    }

    void handleTriggers(Game game) {
        swap(activeTriggers, activeTriggersOld);
        activeTriggers = null;
        game.rootEntity.collide(this, (Entity hit) {
            if (auto trig = cast(TriggerEntity)hit) {
                activeTriggers[trig.event] = true;
                if (trig.event in activeTriggersOld) {
                    return;
                }
                triggerHit(game, trig.event);
            }
        });
    }

    private void triggerHit(Game game, char[] event) {
        game.triggerEvent(event, this);
    }

    public void damage(Game game, float amount) {
        health = math.max(0f, health - amount);
        game.triggerEvent("playerHit", this);
    }
}
