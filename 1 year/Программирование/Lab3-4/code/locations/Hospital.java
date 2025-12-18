package labpro3.locations;
import java.util.ArrayList;
import java.util.List;

import labpro3.Item;
import labpro3.persons.Person;
import labpro3.persons.Girl;

public class Hospital extends House{
    private final List<Item> storage = new ArrayList<>();

    public Hospital() {
        super("Больница");
    }
    
    public void letInVisitors(HospitalStreet hs){
        for (Person p : new ArrayList<>(hs.getPersons())){
            if(p instanceof Girl girl){
                p.moveTo(this);
                for(Item item : new ArrayList<>(girl.getInventory())){
                    additem(item);
                    girl.removeitem(item);
                    System.out.println(girl.getName() + " оставила " + item.name() + " Незнайке");

                }
            }
        }
        
    }

    @Override
    public List<Item> getstorageitems() {
        return List.copyOf(storage);
    }

    @Override
    public void additem(Item item) {
        storage.add(item);
    }

    @Override
    public void removeitem(Item item) {
        storage.remove(item);
    }
}
