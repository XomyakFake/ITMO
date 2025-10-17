package Moves.StatusMoves;
import ru.ifmo.se.pokemon.*;
public final class RockPolish extends StatusMove{
    public RockPolish(){
        super(Type.ROCK, 0,100);
    }
    @Override
    protected void applySelfEffects(Pokemon p){
        p.setMod(Stat.SPEED, +2);
    }
    
    @Override
    protected String describe(){
        return "Использует Rock Polish";
    }
}

