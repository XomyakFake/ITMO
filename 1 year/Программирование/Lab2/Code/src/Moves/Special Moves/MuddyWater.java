package Moves.SpecialMoves;
import ru.ifmo.se.pokemon.*;
public final class MuddyWater extends SpecialMove{
    public MuddyWater(){
        super(Type.WATER,90,85);
    }
    private boolean low = false;
    @Override
    protected void applyOppEffects(Pokemon p){
        int freezeChance = (int)(Math.random() * 101);
        if(freezeChance <= 30){
            low = true;
            p.setMod(Stat.ACCURACY, -1);
        }
    }
    @Override
    protected String describe(){
        if(low) return "Повезло! Использует атаку MuddyWater и уменьшает точность противника";
        else return "Использует атаку MuddyWater";
    }
}
