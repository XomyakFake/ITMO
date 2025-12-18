package labpro3.Exceptions;

public class NoStorageHereException extends Exception {
    @Override
    public String getMessage() {
        return "Девочка не может найти угощения. ";
    }
}
