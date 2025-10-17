package Pokemons;
import Moves.PhysicalMoves.BodySlam;
import Moves.SpecialMoves.Blizzard;
import Moves.SpecialMoves.MuddyWater;
import ru.ifmo.se.pokemon.*;
public class Shellos extends Pokemon{
    public Shellos(String name, int level){
        super(name,level);
        if(level >= 1 && level <= 100){
            setType(Type.WATER);
            setStats(76,48,48,57,62,34);
            setMove(new Blizzard(), new BodySlam(), new MuddyWater());
        }
        else{
            System.out.println("Неправильный уровень покемона");
            System.exit(1);
        }   
    }
}
