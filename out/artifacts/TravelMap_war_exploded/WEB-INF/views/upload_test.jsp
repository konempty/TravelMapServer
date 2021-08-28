<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-07-26
  Time: 오후 8:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form action="${pageContext.request.contextPath}/upload.do" method="post" enctype="multipart/form-data">
    <input type="file" name="file">
    <input type="submit">
</form>
</body>
</html>
