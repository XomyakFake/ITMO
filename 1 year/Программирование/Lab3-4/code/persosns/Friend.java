package labpro3.persons;

import labpro3.locations.City;

public class Friend extends Person {
    public Friend(String name, int age) {
        super(name, age);
    }

    @Override
    public void act() {
        setLocation(City.getHospitalStreet().getHospital());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Friend f)) return false;
        return getName().equals(f.getName()) && getAge() == f.getAge();
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(getName(), getAge());
    }

    @Override
    public String toString() {
        return getName();
}
}