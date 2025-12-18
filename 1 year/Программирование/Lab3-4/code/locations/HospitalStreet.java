package labpro3.locations;

import java.util.Random;
import labpro3.persons.Person;
import labpro3.persons.Girl;

public class HospitalStreet extends Street {
    private Random random = new Random();
    private static boolean hospitalleave;
    private final Hospital h = new Hospital();

    public HospitalStreet() {
        super("Больничная улица");
    }
    
    public Hospital getHospital(){
        return h;
    }

    public void hospitalleave(){
        hospitalleave = random.nextInt(100) < 50;
    }

    public boolean ishospitalleave(){
        hospitalleave();
        return hospitalleave;
    }

    public boolean CountGirls(){
        int count = 0;
        for(Person p : getPersons()){
            if (p instanceof Girl){
                count += 1;
            }
        }
        return count < 5;
    }
}