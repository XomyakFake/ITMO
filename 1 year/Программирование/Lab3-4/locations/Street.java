package labpro3.locations;

import java.util.ArrayList;
import java.util.List;

public class Street extends Location{
    private final List<House> houses = new ArrayList<>();

    public Street(String name){
        super(name);
    }

    public void addHouse(House house) {
        houses.add(house);
    }

    public List<House> getHouses() {
        return List.copyOf(houses);
    }

    @Override
    public String toString() {
        return "Street: " + getName() + 
            ", houses=" + houses.size() +
            ", persons=" + getPersons().size();
    }
}