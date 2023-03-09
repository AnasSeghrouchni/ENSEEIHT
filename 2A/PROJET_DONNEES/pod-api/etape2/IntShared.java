public class IntShared implements java.io.Serializable {
    private int data;
    public IntShared() {
        this.data = 0;
    }
    public void write(int n) {
        data += n;
    }
    public int read() {
        return data;
    }
}
