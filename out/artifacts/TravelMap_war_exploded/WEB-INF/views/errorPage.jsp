<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-07-26
  Time: 오후 3:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error Page</title>
</head>
<body>
<c:set var="code" value="${requestScope['javax.servlet.error.status_code']/100}"/>

<p><c:choose>
    <c:when test="${code == 4}">잘못 된 요청입니다.</c:when>
    <c:when test="${code == 5}">잠시후 다시시도해주시기 바랍니다.</c:when>
    <c:otherwise>잘못 된 요청입니다.</c:otherwise>

</c:choose></p>


<a href="${pageContext.request.contextPath}/">HOME</a>
</body>
</html>
