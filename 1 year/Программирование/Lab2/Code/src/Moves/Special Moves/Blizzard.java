package Moves.SpecialMoves;
import ru.ifmo.se.pokemon.*;
public final class Blizzard extends SpecialMove{
    public Blizzard(){
        super(Type.ICE, 110,70);
    }
    private boolean freezeFlag = false;
    @Override
    protected void applyOppEffects(Pokemon p){
        int freezeChance = (int)(Math.random() * 101);
        if(freezeChance <= 10){
            freezeFlag = true;
            Effect.freeze(p);
        }
    }
    @Override
    protected String describe(){
        if(freezeFlag) return "Повезло! Использует атаку Blizzard и замораживает";
        else return "Использует атаку Blizzard";
    }
}

