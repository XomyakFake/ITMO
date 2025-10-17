package Moves.PhysicalMoves;
import ru.ifmo.se.pokemon.*;
public final class RockSlide extends PhysicalMove{
    public RockSlide(){
        super(Type.ROCK, 75,90);
    }
    private boolean flinchFlag = false;
    @Override
    protected void applyOppEffects(Pokemon p){
        int freezeChance = (int)(Math.random() * 101);
        if(freezeChance <= 30){
            flinchFlag = true;
            Effect.flinch(p);
        }
    }
    @Override
    protected String describe(){
        if (flinchFlag) return "Повезло! Использует атаку Rock Slide и вызывает страх";
        else return "Использует атаку Rock Slide";
    }
}

