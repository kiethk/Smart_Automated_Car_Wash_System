<%-- 
    Document   : error
    Created on : Jun 3, 2026, 2:28:06 PM
    Author     : kieth
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Something wrong happened.</h1>
        <% if (request.getAttribute("ERROR_MSG") != null) { %>
        <p><%= request.getAttribute("ERROR_MSG")%></p>
        <% } %>
    </body>
</html>
