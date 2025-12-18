package labpro3;

import java.util.List;

public interface Storage {
    List<Item> getstorageitems();
    void removeitem(Item item);
    void additem(Item item);
}

