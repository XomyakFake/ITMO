package labpro3.persons;

import labpro3.locations.Location;
import labpro3.locations.City;
import java.util.List;
import java.util.ArrayList;
import labpro3.Item;
import labpro3.Storage;
import labpro3.Exceptions.NoStorageHereException;

public class Girl extends Person {
    public Girl(String name, int age) {
        super(name, age);
    }
    private boolean knowsNews = false;
    private static boolean dvig = false;
    private List<Item> inventory = new ArrayList<>();
    private int currLoad = 0;

    public boolean knowsNews() {
        return knowsNews;
    }

   public void learnNews() {
    if (knowsNews) return;
    knowsNews = true; 
    System.out.print(getName() + " узнает новость. ");
    if (getLocation() instanceof Storage storage) {
        takefoodfromstorage(storage);
    } 
    else {
        try {
            throw new NoStorageHereException();
        } catch (NoStorageHereException e) {
            System.out.println(e.getMessage());
            }
        }
    }

    public void takefoodfromstorage(Storage storage){
        List<Item> good = new ArrayList<>(storage.getstorageitems());
        for(Item item : good){
            if (cantakeitem(item)){
                storage.removeitem(item);
            }
        }
    }

    public void shareNews(Person other) {
        if (!knowsNews) return;                    
        if (!(other instanceof Girl girl)) return; 

        if (!girl.knowsNews) {
            System.out.print(this.getName() + " рассказала новость " + girl.getName() + ". ");
            girl.learnNews();  
            girl.act(); 
        }
    }


    @Override
    public void act() {
        if (!knowsNews) return;

        boolean newsSpread; 
        do {
            newsSpread = false;
            Location current = getLocation();
            if (current == null) break;


            for (Person p : current.getPersons()) {
                if (p instanceof Girl girl && !girl.knowsNews) {
                    shareNews(girl);
                    newsSpread = true;
                }
            }

            if (!newsSpread) {
                Location next = City.findLocationgirl();
                if (next != null && next != current) {
                    moveTo(next);
                    newsSpread = true; 
                }
            }

        } while (newsSpread); 
        if (City.allgirlsknows() && getLocation() != City.getHospitalStreet()) {
            moveTo(City.getHospitalStreet());
            if(!dvig){
                dvig = true;
                System.out.print(" Девочки двинулись на больничную улицу.");}
        }
    }

    public boolean cantakeitem(Item item){
        if(currLoad + item.weight() > getStr()){
            return false;
        }
        else{
            inventory.add(item);
            currLoad += item.weight();
            System.out.print(getName() + " взяла " + item.name()+ ".");
            return true;
        }
    }

    public List<Item> getInventory(){
        return List.copyOf(inventory);
    }

    public void removeitem(Item item){
        inventory.remove(item);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Girl girl)) return false;
        return getName().equals(girl.getName()) && getAge() == girl.getAge();
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(getName(), getAge());
    }

    @Override
    public String toString() {
        return getName() + (knowsNews ? " (знает)" : " (не знает)");
}

}
