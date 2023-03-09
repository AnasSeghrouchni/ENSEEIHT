import java.lang.annotation.*;

/** Indicate that a class is a utility class and thus only defines
  * static methods Utility.
  * 
  */
@Documented
@Retention( RetentionPolicy.CLASS )
@Target( ElementType.TYPE) 
public @interface Utility {
}
