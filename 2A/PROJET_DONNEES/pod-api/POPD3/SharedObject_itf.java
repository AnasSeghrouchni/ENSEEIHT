public interface SharedObject_itf {
	public Object read();
	public void write(Object o);
	public int getVersion();
}