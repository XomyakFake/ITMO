package labpro3.persons;
import labpro3.locations.Location;

public abstract class Person {
    private final String name;
    private int age;
    private Location currLocation;

    private final int str;

    public Person(String name, int age){
        this.name = name;
        this.age = age;
        this.str = calcStr(age);
    }

    private int calcStr(int age){
        if (age < 5) return 1;
        if (age < 10) return 2;
        return 3;
    }
    public int getStr(){return str;}
    public Location getLocation(){return currLocation;}
    public String getName() {return name;}
    public int getAge() {return age;}

    public void setLocation(Location location){this.currLocation = location;}

    public void moveTo(Location newLocation){
        if(currLocation != null){
            currLocation.removePerson(this);}
        newLocation.addPerson(this);
        }

    @Override
    public String toString(){
        return name + age;
    }

    public abstract void act();

}
