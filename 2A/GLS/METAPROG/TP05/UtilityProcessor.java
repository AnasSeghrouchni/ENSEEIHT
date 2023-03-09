import javax.annotation.processing.*;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.*;
import java.util.*;
import javax.tools.Diagnostic.Kind;

/** Check that a class marked {@code @Utility} is indeed a utility class. */
@SupportedAnnotationTypes("Utility")
@SupportedSourceVersion(SourceVersion.RELEASE_11)
public class UtilityProcessor extends AbstractProcessor {

	@Override
	public boolean process(
			Set<? extends TypeElement> annotations,
			RoundEnvironment roundingEnvironment)
	{
		Messager messager = processingEnv.getMessager();
		messager.printMessage(Kind.NOTE,
				"UtilityProcessor executed.");
		//messager.printMessage(Kind.WARNING,
				//"The provided UtilityProcessor class is wrong.  Correct it!");
		for (TypeElement te : annotations) {
			for (Element elt : roundingEnvironment.getElementsAnnotatedWith(te)) {
				if (elt.getKind() == ElementKind.CLASS) {	// elt is a class
					// Check that the class is declared final
					if (elt.getModifiers().contains(Modifier.FINAL)) {
						// Check that enclosed elements are static
			            List<? extends Element> enclosedElements = elt.getEnclosedElements();
			            for(Element e : enclosedElements) {
			            	if (e.getKind() != ElementKind.CONSTRUCTOR) {
				            	if (e.getModifiers().contains(Modifier.STATIC)) {
				            	}
				            	else {					
				            		messager.printMessage(Kind.ERROR,
										"@Utility apply on static elements:", e);
				            	}
			            	}
			            	else {
			            		if (e.getModifiers().contains(Modifier.PRIVATE) && e.==null) {
				            		messager.printMessage(Kind.NOTE,
										"@Utility est vraiment carré", elt);
			            		}
			            		else {
				            		messager.printMessage(Kind.ERROR,
										"@Utility doit avoir au moins un constructeur par default:", e);
			            		}
			            	}
			            }
					} else{
	            		messager.printMessage(Kind.ERROR,
							"@Utility sur les classes final:", elt);
					}
				} else {
					messager.printMessage(Kind.ERROR,
							"@Utility applies to class only:", elt);
				}
			}
		}
		return true;
	}

}
