package labpro3.locations;

import java.util.ArrayList;
import java.util.List;
import labpro3.Storage;
import labpro3.Item;
import labpro3.Food;

public class House extends Location implements Storage{
    private final List<Item> storage = new ArrayList<>();

    public House(String name){
        super(name);
        for(Food f : Food.values()){
            storage.add(new Item(f.getName(), f.getWeight()));
        }
    }

    @Override
    public List<Item> getstorageitems(){
        return List.copyOf(storage);
    }

    @Override
    public void removeitem(Item item){
        storage.remove(item);
    }

    @Override
    public void additem(Item item){
        storage.add(item);
    }
    
    @Override
    public String toString(){
        return "Дом " + getName() + 
            " жильцов " + getPersons().size();
    }
}