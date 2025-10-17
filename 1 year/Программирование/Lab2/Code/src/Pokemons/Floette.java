package Pokemons;
import Moves.PhysicalMoves.Facade;
import Moves.SpecialMoves.MagicalLeaf;
import Moves.PhysicalMoves.RazorLeaf;
import ru.ifmo.se.pokemon.*;
public class Floette extends Flabebe{
    public Floette(String name, int level){
        super(name,level);
        if(level >= 1 && level <= 100){
            setType(Type.FAIRY);
            setStats(54,45,47,75,98,52);
            setMove(new Facade(), new MagicalLeaf(), new RazorLeaf());
        }
        else{
            System.out.println("Неправильный уровень покемона");
            System.exit(1);
        }   
    }
}
