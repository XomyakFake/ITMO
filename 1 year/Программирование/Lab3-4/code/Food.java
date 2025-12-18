package labpro3;

public enum Food{
    ПИРОГИ("пироги",2),
    ВАРЕНЬЕ("варенье",1),
    ПАСТИЛА("пастила",1),
    КОМПОТ("пастила",2),
    ТОРТ("торт",3);
    
    private final String name;
    private final int weight;

    Food(String name, int weight) {
        this.name = name;
        this.weight = weight;
    }

    public String getName() {
        return name;
    }

    public int getWeight() {
        return weight;
    }

    
}