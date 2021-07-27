<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-07-25
  Time: 오전 12:15
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<html>
<head>
    <title>kimhanbin!</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.5.0-beta4/html2canvas.min.js"
            integrity="sha512-OqcrADJLG261FZjar4Z6c4CfLqd861A3yPNMb+vRQ2JwzFT49WT4lozrh3bcKxHxtDTgNiqgYbEUStzvZQRfgQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"
            integrity="sha512-Qlv6VSKh1gDKGoJbnyA5RMXYcvnpIqhO++MhIM2fStMcGT9i2T//tSwYFlcyoRRDcDZ+TYHpH8azBBCyhpSeqw=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">

    <script>
        function initMap() {
            var seoul = {lat: 37.5642135, lng: 127.0016985};
            var map = new google.maps.Map(
                document.getElementById('map'), {
                    zoom: 12,
                    center: seoul
                });

        }

        $(function () {
            alert("hello")
            /*html2canvas($("#downloadImage"), {

                onrendered: function(canvas) {

                    canvas.toBlob(function(blob) {

                        saveAs(blob, 'image.png');

                    });

                }

            });*/
        })

        function b64toFile(b64Data, filename) {
            const sliceSize = 512;
            const byteCharacters = atob(b64Data);
            const byteArrays = [];

            for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                let slice = byteCharacters.slice(offset, offset + sliceSize);
                let byteNumbers = new Array(slice.length);

                for (var i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }
                var byteArray = new Uint8Array(byteNumbers);
                byteArrays.push(byteArray);
            }
            return new File(byteArrays, filename, {type: "image/jpeg"});
        }
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
