
import java.awt.Button;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Frame;
import java.awt.TextArea;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.security.SecureClassLoader;
import java.util.Enumeration;
import java.util.Vector;

import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.MessageListener;
import javax.jms.MessageProducer;
import javax.jms.Session;
import javax.jms.StreamMessage;
import javax.jms.Topic;
import javax.print.attribute.standard.Destination;
import javax.xml.crypto.Data;

import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;

public class Irc {
	public static TextArea		text;
	public static TextField		data;
	public static Frame 		frame;

	public static String url = ActiveMQConnection.DEFAULT_BROKER_URL;
	public static String subject = "MyQueue";

	public static Vector<String> users = new Vector<String>();
	public static String myName;

	public static ConnectionFactory	connectionFactory;
	public static Connection       	connection;
	public static Session		session;
	public static MessageConsumer	consumer;
	public static MessageProducer	producer;
	public static Topic		topic;

	public static void main(String argv[]) {

		if (argv.length != 1) {
			System.out.println("java Irc <name>");
			return;
		}
		myName = argv[0];

		// creation of the GUI 
		frame=new Frame();
		frame.setLayout(new FlowLayout());

		text=new TextArea(10,55);
		text.setEditable(false);
		text.setForeground(Color.red);
		frame.add(text);

		data=new TextField(55);
		frame.add(data);

		Button write_button = new Button("write");
		write_button.addActionListener(new writeListener());
		frame.add(write_button);

		Button connect_button = new Button("connect");
		connect_button.addActionListener(new connectListener());
		frame.add(connect_button);

		Button who_button = new Button("who");
		who_button.addActionListener(new whoListener());
		frame.add(who_button);

		Button leave_button = new Button("leave");
		leave_button.addActionListener(new leaveListener());
		frame.add(leave_button);

		frame.setSize(470,300);
		text.setBackground(Color.black); 
		frame.setVisible(true);
	}

	/* allow to print something in the window */
	public static void print(String msg) {
		try {
			text.append(msg+"\n");

		} catch (Exception ex) {
			ex.printStackTrace();
		}	
	}
}



// action invoked when the "write" button is clicked
class writeListener implements ActionListener {
	public void actionPerformed (ActionEvent ae) {
		try {
			System.out.println("write button pressed");
			String msg = Irc.myName + ": " + Irc.data.getText();
			StreamMessage s = Irc.session.createStreamMessage();
			s.writeString(msg);
			Irc.producer.send(s);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}

// action invoked when the "connect" button is clicked
class connectListener implements ActionListener {
	public void actionPerformed (ActionEvent ae) {
		try {  
			System.out.println("connect button pressed");
			Irc.connectionFactory = new ActiveMQConnectionFactory(Irc.url);
			Irc.connection = Irc.connectionFactory.createConnection();
			Irc.connection.start();
			Irc.session = Irc.connection.createSession(false,Session.AUTO_ACKNOWLEDGE);
			Irc.users.addElement(Irc.myName);
			Irc.topic = Irc.session.createTopic(Irc.subject);
			Irc.producer = Irc.session.createProducer(Irc.topic);
			Irc.consumer = Irc.session.createConsumer(Irc.topic);
			Irc.consumer.setMessageListener(new readListener());
			StreamMessage s = Irc.session.createStreamMessage();
			s.writeString("id");
			Irc.producer.send(s);

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}  



// action invoked when the "who" button is clicked
class whoListener implements ActionListener {
	public void actionPerformed (ActionEvent ae) {
		try {
			System.out.println("who button pressed");
			for(String s : Irc.users){
				Irc.print(s);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}


// action invoked when the "leave" button is clicked
class leaveListener implements ActionListener {
	public void actionPerformed (ActionEvent ae) {
		try {
			System.out.println("leave button pressed");
			StreamMessage s = Irc.session.createStreamMessage();
			s.writeString("leave");
			s.writeString(Irc.myName);
			Irc.producer.send(s);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}

class readListener implements MessageListener {
	public void onMessage(Message msg) {
		try {
		StreamMessage textmsg = (StreamMessage)msg;
		String id = textmsg.readString();

		if(id.equals("id")){
			StreamMessage s = Irc.session.createStreamMessage();
			s.writeString("connect");
			s.writeString(Irc.myName);
			Irc.producer.send(s);
		}
		else if(id.equals("leave")){
			String ms1 = textmsg.readString();
			Irc.users.remove(ms1);
		}
		else if(id.equals("connect")){
			String ms1 = textmsg.readString();
			if (!Irc.users.contains(ms1)){
				Irc.users.addElement(ms1);
			}
		}
		else{
			Irc.print(id);
		}		
		
	} catch (Exception ex) {
		ex.printStackTrace();
	}
	}
};