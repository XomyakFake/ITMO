package labpro3.locations;

import java.util.ArrayList;
import java.util.List;
import labpro3.persons.Person;
import labpro3.persons.Girl;

public abstract class Location{
    private final String name;
    private final List<Person> persons = new ArrayList<>();

    public Location(String name){
        this.name = name;
    }

    public String getName(){
        return name;
    }

    public void addPerson(Person p){
        persons.add(p);
        p.setLocation(this);
    }

    public void removePerson(Person p){
        persons.remove(p);
        p.setLocation(null);
    }

    public List<Person> getPersons(){
        return List.copyOf(persons);
    }
    
    public boolean allgirlsknows(){
        for(Person p : persons){
            if(p instanceof Girl girl && !girl.knowsNews()){
                return false;
            }
        }
        return true;
    }
    
    @Override
    public String toString(){
        return "Локация - " + name + " кол-во людей - " + persons.size();
    }
}
