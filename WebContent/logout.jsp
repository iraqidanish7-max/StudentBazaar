<%@ page language="java" %>
<%
    session.invalidate();  // destroy session
    response.sendRedirect("login.jsp?status=loggedout");
%>