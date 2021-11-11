<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-07-25
  Time: 오전 12:15
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>kimhanbin!</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <script>
        function initMap() {
            const seoul = {lat: 37.5642135, lng: 127.0016985};
            const map = new google.maps.Map(
                document.getElementById('map'), {
                    zoom: 12,
                    center: seoul
                });

        }

        $(function () {

            //alert("hello")
            /*html2canvas($("#downloadImage"), {

                onrendered: function(canvas) {

                    canvas.toBlob(function(blob) {

                        saveAs(blob, 'image.png');

                    });

                }

            });*/
        })


    </script>
    <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB8iqDaOP-shG0WVvUm4IASMinBvtjyU2w&callback=initMap&region=kr"></script>

</head>
<style>
    .gmnoprint,
    .gm-fullscreen-control,
    .gmnoscreen {
        display: none;
    }

</style>
<body>
<div id="map" style="width:100%; height: 100vh;"></div>

</body>
</html>
