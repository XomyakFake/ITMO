package labpro3.locations;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import labpro3.persons.Person;
import labpro3.persons.Girl;

public class City {
    private static final List<Location> locations = new ArrayList<>();
    private static final HospitalStreet hs = new HospitalStreet();

    public static HospitalStreet getHospitalStreet(){
        return hs;
    }

    public void addLocation(Location loc) {
        locations.add(loc);
    }

    public static boolean allgirlsknows() {
        for (Location loc : locations) {
            if (!loc.allgirlsknows()) {
                return false;
            }
        }
        return true;
    }

    public static Location findLocationgirl(){
        for(Location l : locations){
            for(Person p : l.getPersons()){
                if(p instanceof Girl girl && !girl.knowsNews()){
                    return l;
                }
            }
        }
        return null;
    }

    public static Location getRandomLocation(){
        Random r = new Random();
        return locations.get(r.nextInt(locations.size()));
    }
}