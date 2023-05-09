import java.io.*;
import java.nio.file.NotLinkException;
import java.text.Normalizer;

public class SharedObject implements Serializable, SharedObject_itf {
	private int version;
	private Object o;

	public SharedObject(int v,Object o) {
		this.o = o;
		this.version = v;
	}

	public Object read() {
		return o;
	}

	public void write(Object o) {
		this.version++;
		this.o = o;
	}

	public int get_version() {
		return this.version;
	}
}