package labpro3.persons;

import labpro3.locations.Location;
import labpro3.locations.City;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import labpro3.Item;
import labpro3.Storage;
import labpro3.Exceptions.NoStorageHereException;

public class Girl extends Person {
    private boolean knowsNews = false;
    private static boolean hospitalMovementInitiated = false;
    private final List<Item> inventory = new ArrayList<>();
    private int currentLoad = 0;
    
    public Girl(String name, int age) {
        super(name, age);
    }
    
    @Override
    public void act() {
        if (!isInformed()) {
            return;
        }
        
        spreadInformationToOthers();
        considerHospitalMovement();
    }
    
    private void spreadInformationToOthers() {
        boolean informationSpread;
        
        do {
            informationSpread = false;
            Location current = getLocation();
            
            if (current == null) {
                break;
            }
            
            // Поделиться новостью с другими девочками на текущей локации
            for (Person person : current.getPersons()) {
                if (person instanceof Girl otherGirl && canShareWith(otherGirl)) {
                    shareInformation(otherGirl);
                    informationSpread = true;
                }
            }
            
            // Если новость не удалось распространить, переместиться
            if (!informationSpread) {
                Location nextLocation = City.findLocationgirl();
                if (shouldMoveTo(nextLocation, current)) {
                    moveTo(nextLocation);
                    informationSpread = true;
                }
            }
            
        } while (informationSpread);
    }
    
    private boolean canShareWith(Girl otherGirl) {
        return !otherGirl.isInformed() && !otherGirl.equals(this);
    }
    
    private boolean shouldMoveTo(Location destination, Location current) {
        return destination != null && !destination.equals(current);
    }
    
    private void considerHospitalMovement() {
        if (City.allgirlsknows() && !isAtHospitalStreet()) {
            moveToHospitalStreet();
        }
    }
    
    private boolean isAtHospitalStreet() {
        Location hospital = City.getHospitalStreet();
        return hospital != null && hospital.equals(getLocation());
    }
    
    private void moveToHospitalStreet() {
        Location hospital = City.getHospitalStreet();
        if (hospital != null) {
            moveTo(hospital);
            announceHospitalMovement();
        }
    }
    
    private void announceHospitalMovement() {
        if (!hospitalMovementInitiated) {
            hospitalMovementInitiated = true;
            System.out.println("Все девочки направляются к Больничной улице.");
        }
    }
    
    public void learnNews() {
        if (isInformed()) {
            return;
        }
        
        becomeInformed();
        gatherSuppliesIfPossible();
    }
    
    private void becomeInformed() {
        knowsNews = true;
        System.out.println(getName() + " узнала важную новость.");
    }
    
    private void gatherSuppliesIfPossible() {
        Location current = getLocation();
        
        if (current instanceof Storage storage) {
            collectItemsFromStorage(storage);
        } else {
            handleNoStorageSituation();
        }
    }
    
    private void collectItemsFromStorage(Storage storage) {
        if (storage == null) {
            return;
        }
        
        // Создаем копию списка, чтобы избежать ConcurrentModificationException
        List<Item> availableItems = new ArrayList<>(storage.getstorageitems());
        
        for (Item item : availableItems) {
            if (item != null && canCarryItem(item)) {
                // Удаляем предмет из хранилища
                storage.removeitem(item);
                addToInventory(item);
                System.out.println(getName() + " взяла " + item.name() + " со склада.");
            }
        }
    }
    
    private void handleNoStorageSituation() {
        try {
            throw new NoStorageHereException();
        } catch (NoStorageHereException e) {
            System.out.println(e.getMessage());
        }
    }
    
    public void shareInformation(Person recipient) {
        if (!isInformed() || !(recipient instanceof Girl)) {
            return;
        }
        
        Girl otherGirl = (Girl) recipient;
        if (!otherGirl.isInformed()) {
            System.out.println(getName() + " делится новостью с " + otherGirl.getName() + ".");
            otherGirl.learnNews();
        }
    }
    
    public boolean canCarryItem(Item item) {
        if (item == null) {
            return false;
        }
        
        int potentialLoad = currentLoad + item.weight();
        return potentialLoad <= getStr();
    }
    
    public boolean cantakeitem(Item item) {
        if (!canCarryItem(item)) {
            System.out.println(getName() + " не может нести " + item.name() + " (превышен лимит).");
            return false;
        }
        
        addToInventory(item);
        return true;
    }
    
    private void addToInventory(Item item) {
        inventory.add(item);
        currentLoad += item.weight();
        System.out.println(getName() + " теперь несет " + item.name() + " (" + item.weight() + " ед.).");
    }
    
    public void removeitem(Item item) {
        if (item != null && inventory.remove(item)) {
            currentLoad = Math.max(0, currentLoad - item.weight());
        }
    }
    
    public void takefoodfromstorage(Storage storage) {
        collectItemsFromStorage(storage);
    }
    
    public boolean knowsNews() {
        return isInformed();
    }
    
    public boolean isInformed() {
        return knowsNews;
    }
    
    public List<Item> getInventory() {
        return Collections.unmodifiableList(inventory);
    }
    
    public int getCurrentLoad() {
        return currentLoad;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Girl girl = (Girl) obj;
        return getAge() == girl.getAge() && 
               getName().equals(girl.getName());
    }
    
    @Override
    public int hashCode() {
        return 31 * getName().hashCode() + getAge();
    }
    
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Девочка: ").append(getName())
          .append(" (").append(getAge()).append(" лет) - ")
          .append(isInformed() ? "в курсе" : "не в курсе");
        
        if (currentLoad > 0) {
            sb.append(", груз: ").append(currentLoad).append(" ед.");
        }
        
        if (!inventory.isEmpty()) {
            sb.append(", предметы: ");
            for (int i = 0; i < inventory.size(); i++) {
                if (i > 0) sb.append(", ");
                sb.append(inventory.get(i).name());
            }
        }
        
        return sb.toString();
    }
}
