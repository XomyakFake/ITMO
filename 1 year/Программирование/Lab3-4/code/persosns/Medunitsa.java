package labpro3.persons;


import labpro3.locations.Hospital;
import labpro3.locations.HospitalStreet;
import labpro3.locations.Location;
import java.util.ArrayList;
import labpro3.locations.City;

public class Medunitsa extends Person {
    private final Neznaika neznaika;

    public Medunitsa(String name, int age, Neznaika neznaika) {
        super(name, age);
        this.neznaika = neznaika;
    }

    @Override
    public void act() {
        HospitalStreet hs = City.getHospitalStreet();
        Hospital hospital = hs.getHospital();
        setLocation(hospital);

        if (hs.CountGirls()) {
            System.out.print(" В больницу могли пустить такое количество желающих и девочки оставили Незнайке угощения: ");
            hospital.letInVisitors(hs);
        } else {
            System.out.print(" Конечно, в больницу не могли пустить такое количество желающих. Медуница вышла на крыльцо и сказала, что больные ни в чем не нуждаются, поэтому все должны разойтись по домам и не шуметь здесь под окнами.");

            if (hs.ishospitalleave()) {
                neznaika.readytoleave();
                System.out.print(" Но малышки не хотели расходиться. Незнайка должен выйти из больницы.");
            } else {
                for (Person p : new ArrayList<>(hs.getPersons())){
                    if(p instanceof Girl girl){
                        Location randomLoc = City.getRandomLocation();
                        if(randomLoc != girl.getLocation()){
                            girl.moveTo(randomLoc);
                        }
                    }
                }
                System.out.print(" Девочки разошлись по домам, не увидев Незнайку.");
            }
        }
    }
}
