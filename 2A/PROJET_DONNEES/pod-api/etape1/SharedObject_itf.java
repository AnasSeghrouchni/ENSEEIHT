public interface SharedObject_itf {
	public void lock_read();
	public void lock_write();
	public void unlock();
	public int get_id();
}