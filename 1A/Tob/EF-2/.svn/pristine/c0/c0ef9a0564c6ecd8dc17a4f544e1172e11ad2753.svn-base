package Utils;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.NoSuchFileException;
import java.nio.file.Paths;


public class Utils {

    static public String readFile(String filePath) throws InvalidPathException, NoSuchFileException {
        String result = "";
        try {
            result = Files.readString(Paths.get(filePath));
        } catch (IOException e) {
            throw new NoSuchFileException(filePath);
        }
        return result;
    }
}
