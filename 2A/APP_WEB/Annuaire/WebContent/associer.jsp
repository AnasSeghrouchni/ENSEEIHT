<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="Pack.*" %>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action= "Serv" method="post">
Chosir la personne: <br>
<%Collection<Personne> lp = (Collection<Personne>)request.getAttribute("lp");
Collection<Adresse> la = (Collection<Adresse>)request.getAttribute("la");
%>
<%for (Personne p : lp ){%>
	<input type='radio' name='idp' value='<%=p.getId()%>' > <%=p.getNom() %> <%=p.getPrenom() %> <br>
	<%} %>
Choisir l'adresse: <br>
<%for (Adresse a : la ){%>
	<input type='radio' name='ida' value='<%=a.getId()%>' > <%=a.getRue()%> <%=a.getVille() %> <br>
	<%} %>
<input type="hidden" name="op" value="bind">
<input type="submit" value="OK">
</body>
</html>