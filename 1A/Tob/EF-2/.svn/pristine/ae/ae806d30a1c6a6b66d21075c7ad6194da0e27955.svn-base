package Visuals;

import java.awt.Color;
import java.awt.Font;

import javax.swing.DefaultListCellRenderer;
import javax.swing.DefaultListModel;
import javax.swing.JList;
import javax.swing.SwingConstants;

// a revoir...
public class RawScore extends JList<String> {

    /**
	 * 
	 */
	private static final long serialVersionUID = -5961076311036240243L;
	DefaultListModel<String> text;

    public RawScore(DefaultListModel<String> text) {
        super(text);
        this.text = text;
        Color myGreen = new Color(51, 149, 110);
        this.setBackground(myGreen);
        this.setFont(new Font("Arial", Font.BOLD, 10));
        this.setLayoutOrientation(HORIZONTAL_WRAP);
        this.setOpaque(false);
        this.setVisibleRowCount(1);
        this.setFixedCellWidth(120);
        DefaultListCellRenderer renderer = (DefaultListCellRenderer) this.getCellRenderer();
        renderer.setHorizontalAlignment(SwingConstants.CENTER);
    }

    public static String[] convertir(long[] long_tableau) {
        String[] titre_tableau = {  "Normal Pop. : ", "Total Pop. : ", "Food produced : ", "Total Housing : ",  "Raw Production : " };
        String[] string_tableau = new String[long_tableau.length];
        for (int i = 0; i < long_tableau.length; i++) {
            string_tableau[i] = titre_tableau[i] + long_tableau[i];
        }
        return string_tableau;
    }

    public static DefaultListModel<String> createModel(long[] stats) {
        DefaultListModel<String> result = new DefaultListModel<String>();
        String content[] = convertir(stats);
        for (String string : content) {
            result.addElement(string);
        }
        return result;
    }

    public void setScore(long[] long_tableau) {
        String content[] = convertir(long_tableau);
        for (int i = 0; i < long_tableau.length; i++) {
            text.setElementAt(content[i], i);
        }
    }

}
