package Moves.PhysicalMoves;
import ru.ifmo.se.pokemon.*;
public final class BodySlam extends PhysicalMove{
    public BodySlam(){
        super(Type.NORMAL, 85,100);
    }
    private boolean paralyzeFlag = false;
    @Override
    protected void applyOppEffects(Pokemon p){
        int freezeChance = (int)(Math.random() * 101);
        if(freezeChance <= 30){
            paralyzeFlag = true;
            Effect.paralyze(p);
        }
    }
    @Override
    protected String describe(){
        if(paralyzeFlag) return "Повезло! Использует атаку BodySlam и парализует";
        else return "Использует атаку BodySlam";
    }
}

