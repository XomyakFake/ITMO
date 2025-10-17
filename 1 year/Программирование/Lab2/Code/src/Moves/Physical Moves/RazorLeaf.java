package Moves.PhysicalMoves;
import ru.ifmo.se.pokemon.*;
public final class RazorLeaf extends PhysicalMove{
    public RazorLeaf(){
        super(Type.GRASS, 55,95);
    }
    @Override
    protected double calcCriticalHit(Pokemon att, Pokemon def){
        return (att.getStat(Stat.SPEED) / 512) + 1;
    }
    @Override
    protected String describe(){
        return "Использует атаку Razor Leaf, нанося урон и увеличивая шанс критического удара на 1";}
}