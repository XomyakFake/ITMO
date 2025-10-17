package Pokemons;
import Moves.PhysicalMoves.QuickAttack;
import Moves.PhysicalMoves.RockSlide;
import Moves.StatusMoves.Swagger;
import Moves.StatusMoves.RockPolish;
import ru.ifmo.se.pokemon.*;
public final class Terrakion extends Pokemon{
    public Terrakion(String name, int level){
        super(name,level);
        if(level >= 1 && level <= 100){
            setType(Type.ROCK, Type.FIGHTING);
            setStats(91,129,90,72,90,108);
            setMove(new QuickAttack(), new RockSlide(), new Swagger(), new RockPolish());
        }
        else{
            System.out.println("Неправильный уровень покемона");
            System.exit(1);
        }   
    }
}
