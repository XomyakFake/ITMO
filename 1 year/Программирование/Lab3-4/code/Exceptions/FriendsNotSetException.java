package labpro3.Exceptions;

public class FriendsNotSetException extends RuntimeException {
    @Override
    public String getMessage() {
        return "У Незнайки нет друзей";
    }
}
