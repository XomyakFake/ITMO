package Moves.PhysicalMoves;
import ru.ifmo.se.pokemon.*;
public final class QuickAttack extends PhysicalMove{
    public QuickAttack(){
        super(Type.NORMAL, 40,100,1,1);
    }
    @Override
    protected String describe(){
        return "Использует атаку Quick Attack";}
}

