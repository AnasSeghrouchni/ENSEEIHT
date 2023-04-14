package Pack;

import java.io.IOException;
import java.util.Collection;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Serv
 */
@WebServlet("/Serv")
public class Serv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	@EJB
	Facade facade;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Serv() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
                                                            
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String op = request.getParameter("op");
		System.out.println(op);
		if (op.equals("ajoutPersonne")) {
				String nom = request.getParameter("nom");
				String prenom = request.getParameter("prenom");
				System.out.println(nom);
				facade.ajoutPersonne(nom, prenom);
				request.getRequestDispatcher("index.html").forward(request, response);
			}
		if (op.equals("ajoutAdresse")) {
			String rue = request.getParameter("rue");
			String ville = request.getParameter("ville");
			System.out.println(rue);
			facade.ajoutAdresse(rue, ville);
			request.getRequestDispatcher("index.html").forward(request, response);
		}
		if (op.equals("associer")) {
			Collection<Personne> lp = facade.listePersonnes();
			Collection<Adresse> la = facade.listeAdresses();
			request.setAttribute("lp",lp);
			request.setAttribute("la",la);
			request.getRequestDispatcher("associer.jsp").forward(request, response);
		}           
		if (op.equals("bind")) {
			String idp = request.getParameter("idp");
			String ida = request.getParameter("ida");
			facade.associer(Integer.valueOf(idp), Integer.valueOf(ida));
			request.getRequestDispatcher("index.html").forward(request, response);
		}
		if (op.equals("lister")) {
			Collection<Personne> lp = facade.listePersonnes();
			request.setAttribute("lp",lp);
			request.getRequestDispatcher("lister.jsp").forward(request, response);
		}

	}

}
