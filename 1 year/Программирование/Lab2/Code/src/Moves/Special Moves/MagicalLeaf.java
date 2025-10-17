package Moves.SpecialMoves;
import ru.ifmo.se.pokemon.*;
public final class MagicalLeaf extends SpecialMove{
    public MagicalLeaf(){
        super(Type.GRASS, 40,100);
    }
    @Override
    protected boolean checkAccuracy(Pokemon p1, Pokemon p2){
        return true;
    }
    @Override
    protected String describe(){
        return "Использует атаку Magical Leaf";}
}