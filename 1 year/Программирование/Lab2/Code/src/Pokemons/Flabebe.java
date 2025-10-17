package Pokemons;
import Moves.PhysicalMoves.Facade;
import Moves.SpecialMoves.MagicalLeaf;
import ru.ifmo.se.pokemon.*;
public class Flabebe extends Pokemon{
    public Flabebe(String name, int level){
        super(name,level);
        if(level >= 1 && level <= 100){
            setType(Type.FAIRY);
            setStats(41,38,39,61,79,42);
            setMove(new Facade(), new MagicalLeaf());
        }
        else{
            System.out.println("Неправильный уровень покемона");
            System.exit(1);
        }   
    }
}
