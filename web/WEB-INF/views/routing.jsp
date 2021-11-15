<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-08-07
  Time: 오후 12:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <title>Routing</title>

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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tween.js/18.6.4/tween.umd.js"
            integrity="sha512-lIKG1kC5TMb1Zx32vdz1n31YJMZRknVY20U9MJ28hD3y2c0OKN0Ce5NhJji78v8zX5UOSsm+MTBOcJt7yMBnSg=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">
    <script>
        let db;
        $(function () {

            const IorA = navigator.userAgent.toLowerCase();

            if (IorA.indexOf("android") !== -1) {
                $('#atag').attr("href", "intent://travelmap/#Intent;scheme=scheme;package=kim.hanbin.gpstracker;S.browser_fallback_url=https%3A%2F%2Fnaver.com;${trackingData}S.id=<c:out value="${param.id}" />;${salt}end")

            } else if (IorA.indexOf("iphone") !== -1) {
                $('#atag').attr("href", "travelmap://?S.id=<c:out value="${param.id}" />;${trackingData}${salt}")

            } else {
                //location.href = "https://naver.com";

            }

            let openRequest = indexedDB.open("store", 1);

            openRequest.onupgradeneeded = function (event) {
                db = event.target.result;
                if (!db.objectStoreNames.contains('images')) { // if there's no "books" store
                    db.createObjectStore('images', {keyPath: ['trackId', 'imageId']})
                        .createIndex("trackId", "trackId", {unique: false});
                }
                if (!db.objectStoreNames.contains('tracks')) { // if there's no "books" store
                    db.createObjectStore('tracks', {keyPath: 'trackId'}); // create it
                }
            };

            openRequest.onerror = function () {
                console.error("Error", openRequest.error);
            };

            openRequest.onsuccess = function () {
                db = openRequest.result;

            };
        })


        function b64toFile(b64Data, filename) {
            const sliceSize = 512;
            const byteCharacters = atob(b64Data);
            const byteArrays = [];

            for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                let slice = byteCharacters.slice(offset, offset + sliceSize);
                let byteNumbers = new Array(slice.length);

                for (let i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }
                const byteArray = new Uint8Array(byteNumbers);
                byteArrays.push(byteArray);
            }
            JSONStream

            return new File(byteArrays, filename, {type: "image/jpeg"});
        }

        function decrypt(pass) {
            let saltBase64 = ""

            const sliceSize = 512;
            const byteCharacters = atob(saltBase64);
            const salt = [];
            const iv = CryptoJS.enc.Utf8.parse("9362469649674046")

            for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                let slice = byteCharacters.slice(offset, offset + sliceSize);
                let byteNumbers = new Array(slice.length);

                for (let i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }
                const byteArray = new Uint8Array(byteNumbers);
                salt.push(byteArray);
            }

            const key = CryptoJS.PBKDF2(pass, salt, {
                hasher: CryptoJS.algo.SHA256,
                iterations: 1000
            });

            let decrypt = CryptoJS.AES.createDecryptor(key, {
                iv: iv,
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7
            });

            let encryptedFilename = "https://dl.dropboxusercontent.com/u/30823828/myFile_encrypted.txt";

            let oReq = new XMLHttpRequest();
            oReq.open("GET", encryptedFilename, true);
            oReq.responseType = "arraybuffer";

            oReq.onload = function (oEvent) {
                let data = oReq.response;
                let json = ""
                if (data) {
                    const dataSize = data.size
                    let from = 0
                    while (from < dataSize) {
                        let to = 2048;
                        if (from + to >= dataSize)
                            to = dataSize

                        json += wordToString(decrypt.process(data.slice(size, to)))
                        from = to
                    }
                }
            };

            oReq.send(null);

        }

        function wordToString(wordArray) {
            let byteArray = [], word, i, j, str = "";
            for (i = 0; i < wordArray.length; ++i) {
                word = wordArray[i];
                for (j = 3; j >= 0; --j) {
                    byteArray.push((word >> 8 * j) & 0xFF);
                }
            }
            for (i = 0; i < byteArray.length; ++i) {
                str += escape(String.fromCharCode(byteArray[i]));
            }
            return str;
        }


        let map;

        let reducedPicture;
        let clusters;
        let markerCluster;
        let data;
        let res;

        function json() {
            $("#blocker").css("visibility", "visible");


            reducedPicture = []
            markers = []
            let i = 0
            let objectStore = db.transaction("tracks", "readwrite").objectStore("tracks");
            let request = objectStore.get(${param.id});
            //////////////////////////
            /*var objectStore = db.transaction("images", "readwrite").objectStore("images");
            var request = objectStore.get(










            ${param.id});
            request.onsuccess = function(event) {
                console.log(request.result)
            }*/

            //////////////////////////
            request.onerror = function (event) {
                console.log("err");
            };
            request.onsuccess = function (event) {
                // Do something with the request.result!
                if (request.result) {
                    data = request.result.data;
                    objectStore = db.transaction("images", "readwrite").objectStore("images");
                    let index = objectStore.index("trackId");
                    index.openCursor(IDBKeyRange.bound(${param.id}, ${param.id})).onsuccess = function (event) {
                        let cursor = event.target.result;
                        if (cursor) {
                            let res = cursor.value;
                            processImage(res, res.imageId)
                            cursor.continue();
                        } else {
                            //alert("Got all customers: " + customers);
                            addObjectOnMap();
                        }
                    };

                } else {
                    oboe('/fileDownload.do?trackingNum=${param.id}')
                        .node('!.*', function (data) {
                            if (data.eventNum == 5) {
                                let transaction = db.transaction("images", "readwrite");
                                let images = transaction.objectStore("images");
                                processImage(data, i)


                                let image = {
                                    trackId:${param.id},
                                    imageId: i,
                                    lat: data.lat,
                                    lng: data.lng,
                                    data: data.data
                                };
                                i += 1;
                                let request = images.add(image);
                                request.onsuccess = function () { // (4)
                                    console.log("Book added to the store", request.result);
                                };

                                request.onerror = function () {
                                    console.log("Error", request.error);
                                };
                                //sessionStorage.setItem(, img.src);
                                return oboe.drop;
                            }
                            //console.log('You have a friend called', data);
                        })
                        .done(function (parsedJson) {
                            data = parsedJson.filter(function (el) {
                                return el != null;
                            });
                            let track = {
                                trackId:${param.id},
                                data: data
                            };
                            let transaction = db.transaction("tracks", "readwrite");
                            let tracks = transaction.objectStore("tracks");
                            let request = tracks.add(track);
                            request.onsuccess = function () { // (4)
                                console.log("Book added to the store", request.result);
                            };

                            request.onerror = function () {
                                console.log("Error", request.error);
                            };
                            addObjectOnMap();
                        })
                }
            };

        }

        let markers;

        function processImage(data, i) {
            const myLatLng = {lat: data.lat, lng: data.lng};

            markers.push(new google.maps.Marker({
                position: myLatLng,
                label: String(i),
            }))
            let canvas = document.createElement('canvas');
            let ctx = canvas.getContext('2d');
            canvas.width = 640
            let img = new Image()
            img.onload = function () {

                // set size proportional to image
                canvas.height = canvas.width * (img.height / img.width);

                // step 1 - resize to 50%
                let oc = document.createElement('canvas'),
                    octx = oc.getContext('2d');

                oc.width = img.width * 0.5;
                oc.height = img.height * 0.5;
                octx.drawImage(img, 0, 0, oc.width, oc.height);

                // step 2
                octx.drawImage(oc, 0, 0, oc.width * 0.5, oc.height * 0.5);

                // step 3, resize to final size
                ctx.drawImage(oc, 0, 0, oc.width * 0.5, oc.height * 0.5,
                    0, 0, canvas.width, canvas.height);
                reducedPicture.push(canvas.toDataURL("image/jpeg"));
            }
            img.src = "data:image/jpeg;base64," + data.data

            return img.src
        }

        function addObjectOnMap() {
            setPolyline();
            setCluster();
            getStartPoint()
        }

        function setPolyline() {

            let Coordinates = [];

            for (let item of data) {
                switch (item.eventNum) {
                    case 0:
                        const Path = new google.maps.Polyline({
                            path: Coordinates,
                            geodesic: true,
                            strokeColor: "#FF0000",
                            strokeOpacity: 1.0,
                            strokeWeight: 2,
                        });
                        Path.setMap(map);
                        Coordinates = []
                        break;
                    case 3:
                        Coordinates.push({lat: item.lat, lng: item.lng})
                        break;
                }
            }
            const Path = new google.maps.Polyline({
                path: Coordinates,
                geodesic: true,
                strokeColor: "#FF0000",
                strokeOpacity: 1.0,
                strokeWeight: 2,
            });
            Path.setMap(map);
        }

        function setCluster() {
            markerCluster = new MarkerClusterer(map, markers, {
                zoomOnClick: false
            });
            google.maps.event.addListener(markerCluster, 'clusteringend', function () {

//iterate over all clusters
                clusters = this.getClusters();
                setTimeout("timer()", 10);

            });
            google.maps.event.addListener(markerCluster, 'clusterclick', function (cluster) {
                alert("click")
            });
            $("#blocker").css("visibility", "hidden");
        }

        const zoomLevels = [20, 18, 16]
        let nextIdx = 0;
        let isDiscrete = true;
        let lastLoc;
        let angle;
        let zoomlevel = 0;
        const seoul = {lat: 37.5642135, lng: 127.0016985};
        let isStop = true;
        let isPause = true
        let isAccuratePoint = true

        const cameraOptions = {
            center: seoul,
            //gestureHandling: "none",
            //rotateControl: false,
            //zoomControl: false,
            tilt: 0,
            heading: 0,
            zoom: 12,
        };
        const mapOptions = {
            ...cameraOptions,
            mapId: "845b54e68e28c9b4",
        };
        //import { Tween, update, Easing } from "<%=request.getContextPath()%>/resource/js/tween.cjs.min.js";

        function getStartPoint() {
            zoomlevel = 0
            nextIdx = 0
            isDiscrete = false;
            for (let item of data) {
                nextIdx++;
                if (item.eventNum == 3) {
                    lastLoc = item
                    /*
                    *  centerMarker?.remove()
                centerMarker = mMap.addMarker(
                    MarkerOptions()
                        .position(item.latLng!!)
                        .icon(BitmapDescriptorFactory.defaultMarker(229f))
                )*/
                    for (let idx = nextIdx; idx < data.length; idx++) {
                        if (data[idx].eventNum == 3) {
                            nextIdx = idx
                            let item2 = data[idx]
                            angle = bearing(lastLoc.lat, lastLoc.lng, item2.lat, item2.lng)
                            break;
                        } else if (item.eventNum == 4) {
                            zoomlevel = item.trackingSpeed
                        } else {
                            isDiscrete = true
                        }
                    }

                    animation = new TWEEN.Tween(cameraOptions) // Create a new tween that modifies 'cameraOptions'.
                    animation.to({
                        tilt: 90,
                        heading: angle,
                        zoom: zoomLevels[zoomlevel],
                        center: {lat: lastLoc.lat, lng: lastLoc.lng}
                    }, 1000) // Move to destination in 15 second.
                        .easing(TWEEN.Easing.Quadratic.Out) // Use an easing function to make the animation smooth.
                        .onUpdate(() => {
                            map.moveCamera(cameraOptions);
                        })
                        .start(); // Start the tween immediately.


                    requestAnimationFrame(animate);
                    break;
                } else if (item.eventNum == 4) {
                    zoomlevel = item.trackingSpeed
                }
            }
        }

        function btn2() {
            html2canvas($("#capture")[0], {
                background: '#FFFFFF',
                onrendered: function (canvas) {
                    var base64image = canvas.toDataURL("image/jpeg");
                    $("#capture2").css("background-image", "url('" + base64image.replace(/(\r\n|\n|\r)/gm, "") + "')");
                }
            });
            /*html2canvas(document.body, {
                backgroundColor:"#FFFFFF"
        }).then(function(canvas) {
                var base64image = canvas.toDataURL("image/jpeg");
                $("#capture2").css("background-image", "url('" + base64image.replace(/(\r\n|\n|\r)/gm, "") + "')");
            });*/
        }

        function timer() {
            for (let i = 0; i < clusters.length; i++) {
                if (clusters[i].markers_ && clusters[i].markers_.length > 1) {
                    if (clusters[i].clusterIcon_.div_) {
                        let idx = Number(clusters[i].markers_[0].label)
                        clusters[i].clusterIcon_.div_.innerHTML = '<div class = "customCluster" style="background-image: url(' + reducedPicture[idx] + ')">'
                    } else {
                        setTimeout("timer()", 10);
                    }
                }

            }
        }

        function initMap() {
            map = new google.maps.Map(
                document.getElementById('map'), mapOptions);

        }

        function bearing(
            latitude1,
            longitude1,
            latitude2,
            longitude2
        ) {
            // 현재 위치 : 위도나 경도는 지구 중심을 기반으로 하는 각도이기 때문에 라디안 각도로 변환한다.
            const Cur_Lat_radian = latitude1 * (Math.PI / 180)
            const Cur_Lon_radian = longitude1 * (Math.PI / 180)


            // 목표 위치 : 위도나 경도는 지구 중심을 기반으로 하는 각도이기 때문에 라디안 각도로 변환한다.
            const Dest_Lat_radian = latitude2 * (Math.PI / 180)
            const Dest_Lon_radian = longitude2 * (Math.PI / 180)

            // radian distance
            let radian_distance = 0.0
            radian_distance = Math.acos(
                Math.sin(Cur_Lat_radian) * Math.sin(Dest_Lat_radian)
                + Math.cos(Cur_Lat_radian) * Math.cos(Dest_Lat_radian) * Math.cos(Cur_Lon_radian - Dest_Lon_radian)
            )

            // 목적지 이동 방향을 구한다.(현재 좌표에서 다음 좌표로 이동하기 위해서는 방향을 설정해야 한다. 라디안값이다.
            const radian_bearing = Math.acos(
                (Math.sin(Dest_Lat_radian) - Math.sin(Cur_Lat_radian)
                    * Math.cos(radian_distance)) / (Math.cos(Cur_Lat_radian) * Math.sin(
                    radian_distance
                ))
            ) // acos의 인수로 주어지는 x는 360분법의 각도가 아닌 radian(호도)값이다.
            let true_bearing
            if (Math.sin(Dest_Lon_radian - Cur_Lon_radian) < 0) {
                true_bearing = radian_bearing * (180 / Math.PI)
                true_bearing = 360 - true_bearing
            } else {
                true_bearing = radian_bearing * (180 / Math.PI)
            }
            return true_bearing
        }

        let animation;

        function nextTracking() {
            if (nextIdx == data.length) {
                isStop = true
                isPause = true
                //버튼을 재생이미지로
                isAccuratePoint = true
                return
            }
            let item = data[nextIdx]

            nextIdx++
            switch (item.eventNum) {
                case 0:
                    isDiscrete = true
                    nextTracking()
                    break;
                case 3:
                    if (!isPause) {
                        if (!isDiscrete) {
                            angle = bearing(lastLoc.lat, lastLoc.lng, item.lat, item.lng)
                        }
                        animation = new TWEEN.Tween(cameraOptions) // Create a new tween that modifies 'cameraOptions'.
                        animation.to({
                            tilt: 90,
                            heading: angle,
                            zoom: zoomLevels[zoomlevel],
                            center: {lat: lastLoc.lat, lng: lastLoc.lng}
                        }, 3500) // Move to destination in 15 second.
                            .easing(TWEEN.Easing.Quadratic.Out) // Use an easing function to make the animation smooth.
                            .onUpdate(() => {
                                map.moveCamera(cameraOptions);
                            })
                            .onComplete(() => {
                                lastLoc = item
                                nextTracking()
                            })
                            .start(); // Start the tween immediately.


                        requestAnimationFrame(animate);
                    }
                    break;
                case 4:
                    zoomlevel = item.trackingSpeed
                    nextTracking()
                    break;

            }
        }

        // Setup the animation loop.
        function animate(time) {
            requestAnimationFrame(animate);
            TWEEN.update(time);
        }

        function stopAnimation() {
            animation.stop()
        }

        function goFoward() {
            if (nextIdx <= data.length) {
                stopAnimation()
                let item = data[nextIdx - 1]
                angle = bearing(lastLoc.lat, lastLoc.lng, item.lat, item.lng)
                cameraOptions.angle = angle
                map.moveCamera(cameraOptions)

                lastLoc = item
                isAccuratePoint = true
                nextTracking()
            }
        }

        function goPrev() {
            if (nextIdx != data.length && isStop)
                return
            stopAnimation()
            let back = (isAccuratePoint && !isStop) ? 2 : 1;
            isStop = false
            let item = data[nextIdx - back]
            for (let idx = nextIdx - back; idx > -1; idx--) {
                let item2 = data[idx]
                if (item2.eventNum == 3) {
                    item = item2
                    break;
                }
                nextIdx--
            }
            let isFound = [false, false, false]
            let prevItem = item
            let isDiscrete = false

            for (let idx = nextIdx - back - 1; idx > -1; idx--) {
                let item2 = data[idx]
                if (item2.eventNum == 3) {
                    if (isFound[0]) {
                        if (!isFound[1]) {
                            isFound[1] = true
                            if (!isDiscrete)
                                angle = bearing(item2.lat, item2.lng, prevItem.lat, prevItem.lng
                                )
                            if (isFound[2]) {
                                break;
                            }
                        }
                    } else {
                        nextIdx = idx + 1
                        prevItem = item2
                        isFound[0] = true
                    }
                } else if (item2.eventNum == 4) {
                    if (isFound[0] && !isFound[2]) {
                        isFound[2] = true
                        zoomlevel = item2.trackingSpeed
                        if (isFound[1])
                            break
                    }
                } else {
                    if (idx == 0 && isPause) {

                        isStop = true
                    }
                    isDiscrete = true
                }
            }
            isAccuratePoint = true
            if (prevItem.eventNum == 3) {
                angle = bearing(lastLoc.lat, lastLoc.lng, item.lat, item.lng)
                cameraOptions.angle = angle
                cameraOptions.zoom = zoomLevels[zoomlevel]
                cameraOptions.center = {lat: lastLoc.lat, lng: lastLoc.lng}
                map.moveCamera(cameraOptions)
            }
            nextTracking()

        }

        let speed = 1

        /*function resumeAnimation() {
            let destLoc = null
            for (let i = nextIdx - 1; i < data.length; i++) {
                if (data[i].eventNum == 3) {
                    destLoc = data[i]
                    break;
                }
            }
            if (destLoc != null) {
                if (isPause)
                    return

                let orgDist = lastLoc.sphericalDistance(destLoc)
                let currDist = mMap.cameraPosition.target.sphericalDistance(destLoc)
                let animateTime

                if (isDiscrete) {
                    isDiscrete = false
                    animateTime = 1

                } else {
                    animateTime = 3000 / speed
                }
                var ratio = currDist / orgDist

                if (isAuto && ratio > 0.5) {

                    angle = bearing(
                        lastLoc.latitude,
                        lastLoc.longitude,
                        destLoc.latitude,
                        destLoc.longitude
                    )
                    ratio -= 0.5
                    val
                    time = (1000 / speed * ratio / 0.5).toLong()
                    mMap.animateCamera(
                        CameraUpdateFactory.newCameraPosition(
                            CameraPosition.Builder().target(mMap.cameraPosition.target)
                                .bearing(angle)
                                .zoom(zoomLevels[zoomlevel]).tilt(90F).
                    build()
                ),
                    time.toInt(),
                        null
                )

                    delay(time - 500 / speed)
                } else {
                    animateTime = (animateTime * currDist / orgDist / 0.5).toInt().coerceAtLeast(1)
                }
                mMap.animateCamera(CameraUpdateFactory.newCameraPosition(
                    CameraPosition.Builder().target(destLoc).bearing(angle)
                        .zoom(zoomLevels[zoomlevel]).tilt(90
                F
            ).
                build()
            ),

                animateTime,
                    object
            :
                GoogleMap.CancelableCallback
                {
                    override
                    fun
                    onFinish()
                    {
                        lastLoc = destLoc
                        nextTracking()
                    }

                    override
                    fun
                    onCancel()
                    {

                    }
                }
            )

            }
        }*/

    </script>
</head>

<style>
    .gmnoprint,
    .gm-fullscreen-control,
    .gmnoscreen {
        display: none;
    }

    html {
        font-family: 'Jua', sans-serif;
    }

    .customCluster {
        background-size: 100% 100%;
        background-position: center;
        width: 100%;
        height: 100%;
        border-radius: 10%;
        border: 4px solid #ffffff;
    }

    #blocker {
        position: fixed;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        z-index: 1;
        padding: 20px;
        box-sizing: border-box;
        background-color: rgba(0, 0, 0, 0.75);
        text-align: center;
    }

    .container {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .center {
        margin: 0;
        position: absolute;
        top: 50%;
        left: 50%;
        -ms-transform: translate(-50%, -50%);
        transform: translate(-50%, -50%);
    }

    .whiteText {
        color: white;
        font-size: x-large
    }
</style>
<body>


<a id = "atag">a
    tag</a>
<button onclick="json()"></button>
<button onclick="btn2()"></button>
<!--div id="capture"
     style="width: 66px;height: 66px;border-radius: 10%;border: 2px solid #ffffff;background-image: url('https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m3.png');">

</div>
<div id="capture2" style="width: 66px;height: 66px;border-radius: 10%;border: 2px solid #ffffff;">

</div-->
<div id="map" style="width:100%; height: 100vh;"></div>

<script async defer
        src="https://maps.googleapis.com/maps/api/js?v=beta&key=AIzaSyB8iqDaOP-shG0WVvUm4IASMinBvtjyU2w&callback=initMap&region=kr"></script>
<script src="https://unpkg.com/@googlemaps/markerclustererplus/dist/index.min.js"></script>
<div class="container" style="visibility: hidden" id="blocker">
    <div class="center">
        <p class="whiteText">여행 기록을 불러오고있습니다.</p>
        <p class="whiteText">잠시만 기다려 주세요.</p></div>
</div>
</body>
</html>
