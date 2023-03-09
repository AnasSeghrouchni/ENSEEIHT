import java.awt.*;
import java.awt.event.*;
import java.rmi.*;
import java.io.*;
import java.net.*;
import java.util.*;
import java.lang.*;
import java.rmi.registry.*;


public class Irc_follow extends Frame {
	public TextArea		text;
	public TextField	data;
	SharedObject		sentence;
	static String		myName;

	public static void main(String argv[]) {
		
		if (argv.length != 1) {
			System.out.println("java Irc_follow <name>");
			return;
		}
		myName = argv[0];
	
		// initialize the system
		Client.init();
		
		// look up the Irc_follow object in the name server
		// if not found, create it, and register it in the name server
		SharedObject s = Client.lookup("Irc_follow");
		if (s == null) {
			s = Client.create(new Sentence());
			Client.register("Irc_follow", s);
		}
		// create the graphical part
		new Irc_follow(s);
	}

	public Irc_follow(SharedObject s) {
	
		setLayout(new FlowLayout());
	
		text=new TextArea(10,60);
		text.setEditable(false);
		text.setForeground(Color.red);
		add(text);
	
		data=new TextField(60);
		add(data);
	
		Button write_button = new Button("write");
		write_button.addActionListener(new writeListener_u(this));
		add(write_button);
		Button read_button = new Button("read");
		read_button.addActionListener(new readListener_u(this));
		add(read_button);
		Button follow_button = new Button("s'abonner");
		follow_button.addActionListener(new followListener(this));
		add(follow_button);
		Button unfollow_button = new Button("se désabonner");
		unfollow_button.addActionListener(new unfollowListener(this));
		add(unfollow_button);

		setSize(470,300);
		text.setBackground(Color.black); 
		show();
		
		sentence = s;
	}
}



class readListener_u implements ActionListener {
	Irc_follow Irc_follow;
	public readListener_u (Irc_follow i) {
		Irc_follow = i;
	}
	public void actionPerformed (ActionEvent e) {
		
		// lock the object in read mode
		Irc_follow.sentence.lock_read();
		
		// invoke the method
		String s = ((Sentence)(Irc_follow.sentence.obj)).read();
		
		// display the read value
		Irc_follow.text.append(s+"\n");
		Irc_follow.sentence.unlock();
	}
}

class writeListener_u implements ActionListener {
	Irc_follow Irc_follow;
	public writeListener_u (Irc_follow i) {
        	Irc_follow = i;
	}
	public void actionPerformed (ActionEvent e) {
		
		// get the value to be written from the buffer
        	String s = Irc_follow.data.getText();
        	
    	// lock the object in write mode
		Irc_follow.sentence.lock_write();
		
		// invoke the method
		((Sentence)(Irc_follow.sentence.obj)).write(Irc_follow.myName+" wrote "+s);
		Irc_follow.data.setText("");
		Irc_follow.sentence.unlock();
	}
}



class followListener implements ActionListener {
	Irc_follow Irc_follow;
	public followListener (Irc_follow i) {
        	Irc_follow = i;
	}
	public void actionPerformed (ActionEvent e) {

		// unlock the object
		Irc_follow.sentence.follow();
	}
}

class unfollowListener implements ActionListener {
	Irc_follow Irc_follow;
	public unfollowListener (Irc_follow i) {
        	Irc_follow = i;
	}
	public void actionPerformed (ActionEvent e) {
	// unlock the object
	Irc_follow.sentence.unfollow();
	}
}

