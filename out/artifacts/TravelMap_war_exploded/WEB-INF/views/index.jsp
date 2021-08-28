<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-07-25
  Time: 오전 12:15
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>kimhanbin!</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.5.0-beta4/html2canvas.min.js"
            integrity="sha512-OqcrADJLG261FZjar4Z6c4CfLqd861A3yPNMb+vRQ2JwzFT49WT4lozrh3bcKxHxtDTgNiqgYbEUStzvZQRfgQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.0/core.min.js"
            integrity="sha512-t8vdA86yKUE154D1VlNn78JbDkjv3HxdK/0MJDMBUXUjshuzRgET0ERp/0MAgYS+8YD9YmFwnz6+FWLz1gRZaw=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.0/cipher-core.min.js"
            integrity="sha512-8tSa8JGzVhm1quXtz7BpvEm3wFvwtHkXmYkaEmaU1t7WghNxPdZLjGchi2pARJF2zhwQygyozEegjFROONKsBw=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.0/aes.min.js"
            integrity="sha512-4b1zfeOuJCy8B/suCMGNcEkMcQkQ+/jQ6HlJIaYVGvg2ZydPvdp7GY0CuRVbNpSxNVFqwTAmls2ftKSkDI9vtA=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.0/pbkdf2.min.js"
            integrity="sha512-E1FCVqEhkBCsxW0xRseAo/Mf/u+7cqKxQQ5R4RNHMHH3CxYpQmeSnXL9Tcf6amYSgy/dR3/utZt2TFY05OGabQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.0/hmac-sha256.min.js"
            integrity="sha512-HMqYytekgCbPoNWBm9oazvuOJ8sFpw+FWBHRi2QM0f/bV5djDV1sRzWzu5Jq7MAUlm+zDAUCgi/vHBBlUGLroQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/oboe.js/2.1.5/oboe-browser.min.js"
            integrity="sha512-PYfVBAaO2h0KZ2CZ4a3dSXBxnZgmVw9tkSacfjgPv9qQxrzwayQP1s9rJYES4SCmQ+VYfGMGiaiUH76oIPqw6Q=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
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
