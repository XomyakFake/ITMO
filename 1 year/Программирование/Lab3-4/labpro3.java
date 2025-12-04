package labpro3;

import labpro3.locations.*;
import labpro3.persons.*;


public class labpro3 {
    public static void main(String[] args) {

        City city = new City(); 
        HospitalStreet hospitalStreet = City.getHospitalStreet();
        Hospital hospital = hospitalStreet.getHospital();

        Street mainStreet = new Street("Главная улица");

        city.addLocation(mainStreet);

        House house1 = new House("Дом 1");
        House house2 = new House("Дом 2");
        city.addLocation(house1);
        city.addLocation(house2);

        Girl galochka = new Girl("Галочка", 10);
        Girl kubyshka = new Girl("Кубышка", 11);
        Girl girl3 = new Girl("Лизка", 9);
        Girl girl4 = new Girl("Машка", 8);
        Girl girl5 = new Girl("Светка", 10);
        Girl girl6 = new Girl("Нинка", 7);


        house1.addPerson(galochka);
        house1.addPerson(kubyshka);
        mainStreet.addPerson(girl3);
        house2.addPerson(girl4);
        house2.addPerson(girl5);
        house2.addPerson(girl6);

        System.out.print("По всему городу разнеслась весть о знаменитом путешественнике Незнайке и его товарищах, которые попали в больницу.");
        galochka.learnNews();
        galochka.act();

        Friends f1 = new Friends("Тюбик",10);
        Friends f2 = new Friends("Гусля",10);
        Friends[] friendslist = {f1, f2};

        Neznaika neznaika = new Neznaika(friendslist);
        Medunitsa medunitsa = new Medunitsa("Медуница", 25, neznaika);
        hospital.addPerson(medunitsa);
        medunitsa.act();
        neznaika.act();
    }
}


/* Сценарий: 
Незнайка и товарищи попадают в больницу. 
Галочка узнаёт об этом, берёт угощения и бежит рассказывать подругам. 
Когда они узнают, они тоже берут угощения и идут рассказывать своим подругам.
Когда все девочки узнали о новости, они отправляются на Больничную улицу. 
Если девочек немного, Медуница впускает их в больницу, где они угощают Незнайку вкусняшками. 
Иначе Медуница прогоняет их. Случайным образом девочки могут узнать, что Незнайка сегодня выйдет из больницы, и остаются ждать, чтобы отдать угощения. 
Если об этом не узнают, то возвращаются по домам. */