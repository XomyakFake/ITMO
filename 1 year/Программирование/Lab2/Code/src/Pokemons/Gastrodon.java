package Pokemons;
import Moves.PhysicalMoves.BodySlam;
import Moves.SpecialMoves.Blizzard;
import Moves.SpecialMoves.MuddyWater;
import Moves.SpecialMoves.SludgeBomb;
import ru.ifmo.se.pokemon.*;
public final class Gastrodon extends Shellos{
    public Gastrodon(String name, int level){
        super(name,level);
        if(level >= 1 && level <= 100){
            setType(Type.WATER, Type.GROUND);
            setStats(111,83,68,92,82,39);
            setMove(new Blizzard(), new BodySlam(), new MuddyWater(), new SludgeBomb());
        }
        else{
            System.out.println("Неправильный уровень покемона");
            System.exit(1);
        }   
    }
}
