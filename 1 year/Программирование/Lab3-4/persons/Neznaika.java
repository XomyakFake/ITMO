package labpro3.persons;

import labpro3.Exceptions.FriendsNotSetException;
import labpro3.locations.City;
import labpro3.locations.HospitalStreet;

public class Neznaika extends Person {
    private boolean leave = false;
    private final Friends[] friendslist;

    public Neznaika(Friends[] friends) {
        super("Незнайка", 12);
        if (friends.length == 0) {
            throw new FriendsNotSetException();
        }
        this.friendslist = friends; 
    }

    public void readytoleave() {
        leave = true;
    }

    @Override
    public void act() {
        setLocation(City.getHospitalStreet().getHospital());
        if(!leave){
            return;
        }
        HospitalStreet hs = City.getHospitalStreet();
        moveTo(hs);
        for (Friends f : friendslist) {
            f.act();
        }

        System.out.print(" Незнайка вышел на улицу к девочкам вместе со своими товарищами: ");
        for (Friends f : friendslist) {
            System.out.print(f.getName() + " ");
        }
        leave = false;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Neznaika n)) return false;
        return getName().equals(n.getName()) && getAge() == n.getAge();
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