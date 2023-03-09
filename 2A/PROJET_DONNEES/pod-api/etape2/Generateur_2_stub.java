import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.*;

public class Generateur_2_stub {

    public static void create_stub(String itf){
        Class c;
        try {
            c = Class.forName(itf);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }
        String name = itf.substring(0, itf.length() - 4);
		
		String stub = name + "_stub";
		
		FileWriter fw = null;
		try {
		    fw = new FileWriter(stub+".java");
		} catch (IOException e) {
		    e.printStackTrace();
		    return;
		}
		
		PrintWriter pw = new PrintWriter(fw);

		pw.println("public class "+ stub + " extends SharedObject " +
		"implements " + itf + ", java.io.Serializable { \n");

		pw.println("\tpublic "+stub+"(int id, Object o){");
		pw.println("\t\tsuper(id, o);");
		pw.println("\t}\n");

		Method[] methods = c.getDeclaredMethods();
		
		for (int i = 0; i < methods.length; i++) {
		    String methodName = methods[i].getName();
		    Class returnType = methods[i].getReturnType();
		    Class[] paramTypes = methods[i].getParameterTypes();
		    pw.print("\tpublic " + returnType.getName() + " " + methodName + "(");
		    for (int j = 0; j < paramTypes.length; j++) {
		        pw.print(paramTypes[j].getName() + " arg" + j);
		        if (j < paramTypes.length - 1) {
		            pw.print(", ");
		        }
		    }
			
			pw.println("){");
			if (methods[i].isAnnotationPresent(read.class)) {
				pw.println("\t\tthis.lock_read();");
			}
			else if (methods[i].isAnnotationPresent(write.class)) {
				pw.println("\t\tthis.lock_write();");
			}

			pw.println("\t\t"+ name + " s = (" + name + ")obj;");
			String ret = "";

			if (!returnType.getName().equals("void")){
				ret = returnType.getName() + " ret = ";
			}
			pw.print("\t\t" + ret + "s." + methodName + "(");
			
			for (int j = 0; j < paramTypes.length; j++) {
				pw.print("arg"+j);
				if (j!=paramTypes.length-1){
					pw.print(",");
				} 
			}

			pw.println(");");
			if (methods[i].isAnnotationPresent(read.class)) {
				pw.println("\t\tthis.unlock();");
			}
			else if (methods[i].isAnnotationPresent(write.class)) {
				pw.println("\t\tthis.unlock();");
			}
			if (!returnType.getName().equals("void")){
				pw.println("\t\treturn ret;");
			}
			pw.println("\t}\n");
	}
	pw.println("}");
	pw.flush();
	pw.close();
    }

    public static void main (String[] args) {
		
		if (args.length != 1) {
            System.err.println("Usage: java GeneratorStub <class name>");
            return;
        }
		String nom = args[0];
		create_stub(nom);
	}
}