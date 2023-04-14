<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="Pack.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lister</title>
</head>
<body>
<%Collection<Personne> lp = (Collection<Personne>)request.getAttribute("lp"); %>
<%for (Personne p : lp){%>
	<%=p.getNom()%> <%=p.getPrenom()%> <br>
	<%for (Adresse a : (p.getAdd())){ %>
		 &nbsp<%=a.getRue() %> <%=a.getVille()%> <br>
	<%}%>
<%}%> 


</body>
</html>