public class IntShared_stub extends SharedObject implements IntShared_itf, java.io.Serializable { 

	public IntShared_stub(int id, Object o){
		super(id, o);
	}

	public void write(int arg0){
		this.lock_write();
		IntShared s = (IntShared)obj;
		s.write(arg0);
		this.unlock();
	}

	public int read(){
		this.lock_read();
		IntShared s = (IntShared)obj;
		int ret = s.read();
		this.unlock();
		return ret;
	}

}
