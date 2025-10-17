import Pokemons.*;
import ru.ifmo.se.pokemon.*;

public class lab2 {
    public static void main(String[] args){
        Battle battle = new Battle();
        Pokemon Terrakion = new Terrakion("Теракион", 1);
        Pokemon Shellos = new Shellos("Шелос", 1);
        Pokemon Gastrodon = new Gastrodon("Гастродон", 1);
        Pokemon Florges = new Florges("Флоргес", 1);
        Pokemon Floette = new Floette("Флоет", 1);
        Pokemon Flabebe = new Flabebe("Флабеб", 1);
        Pokemon[] pokemonList = {Terrakion, Shellos, Gastrodon, Florges, Floette, Flabebe};
        for (int i = 0; i < pokemonList.length; i++){
            if (i < pokemonList.length /2){
                battle.addAlly(pokemonList[i]);
            }
            else {
                battle.addFoe(pokemonList[i]);
            }
        }
        battle.go();
    }
}
