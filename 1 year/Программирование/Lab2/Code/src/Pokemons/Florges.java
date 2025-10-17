package Pokemons;
import Moves.PhysicalMoves.Facade;
import Moves.SpecialMoves.MagicalLeaf;
import Moves.PhysicalMoves.RazorLeaf;
import Moves.StatusMoves.Rest;
import ru.ifmo.se.pokemon.*;
public final class Florges extends Floette{
    public Florges(String name, int level){
        super(name,level);
        if(level >= 1 && level <= 100){
            setType(Type.FAIRY);
            setStats(78,65,68,112,154,75);
            setMove(new Facade(), new MagicalLeaf(), new RazorLeaf(), new Rest());
        }
        else{
            System.out.println("Неправильный уровень покемона");
            System.exit(1);
        }   
    }
}
