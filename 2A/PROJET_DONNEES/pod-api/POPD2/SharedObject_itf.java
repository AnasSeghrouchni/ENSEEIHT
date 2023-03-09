public interface SharedObject_itf {
	public void lock_read();
	public void lock_write();
	public void unlock();
	public void maj(Object obj);
	public int get_id();
}