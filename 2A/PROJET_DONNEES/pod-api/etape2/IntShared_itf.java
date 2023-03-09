public interface IntShared_itf extends SharedObject_itf{
    @write
    public void write(int n);
    @read
	public int read();
}
