package Moves.SpecialMoves;
import ru.ifmo.se.pokemon.*;
public final class SludgeBomb extends SpecialMove{
    public SludgeBomb(){
        super(Type.POISON, 90,100);
    }
    private boolean poisonFlag = false;
    @Override
    protected void applyOppEffects(Pokemon p){
        int poisonChance = (int)(Math.random() * 101);
        if(poisonChance <= 30){
            poisonFlag = true;
            Effect.poison(p);
        }
    }
    @Override
    protected String describe(){
        if(poisonFlag) return "Повезло! Использует атаку Sludge Bomb и отравляет противника";
        else return "Использует атаку Sludge Bomb";
    }
}

