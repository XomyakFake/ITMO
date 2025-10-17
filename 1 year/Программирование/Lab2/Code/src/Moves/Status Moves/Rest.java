package Moves.StatusMoves;
import ru.ifmo.se.pokemon.*;
public final class Rest extends StatusMove{
    public Rest(){
        super(Type.PSYCHIC, 0,100);
    }
    @Override
    protected void applySelfEffects(Pokemon p){
        p.restore();
        Effect e = new Effect().turns(2);
        e.sleep(p);
    }
    @Override
    protected String describe(){
        return "Использует Rest засыпая на 2 хода, но полностью восстанавливает здоровье";}
}