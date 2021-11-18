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
    <title>여행기록 열람</title>

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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.2/jquery.modal.min.js"
            integrity="sha512-ztxZscxb55lKL+xmWGZEbBHekIzy+1qYKHGZTWZYH1GUwxy0hiA18lW6ORIMj4DHRgvmP/qGcvqwEyFFV7OYVQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>


    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.2/jquery.modal.min.css"
          integrity="sha512-T3VL1q6jMUIzGLRB9z86oJg9PgF7A55eC2XkB93zyWSqQw3Ju+6IEJZYBfT7E9wOHM7HCMCOZSpcssxnUn6AeQ=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">
    <script src="https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.10.0/firebase-auth.js"></script>
    <script>
        let db;


        function onApp() {
            const IorA = navigator.userAgent.toLowerCase();
            if (IorA.indexOf("android") !== -1) {
                location.href = "intent://travelmap/#Intent;scheme=scheme;package=kim.hanbin.gpstracker;S.browser_fallback_url=https%3A%2F%2Fnaver.com;${trackingData}S.id=<c:out value="${param.id}" />;${salt}end";
            } else if (IorA.indexOf("iphone") !== -1) {
                location.href = "travelmap://?S.id=<c:out value="${param.id}" />;${trackingData}${salt}";
            }
        }

        function onWeb() {
            const firebaseConfig = {
                apiKey: "AIzaSyBmQPeh5_UQ4ylofvDywhi1_Z0vzv7AVQo",
                authDomain: "gps-tracker-303405.firebaseapp.com",
                projectId: "gps-tracker-303405",
                storageBucket: "gps-tracker-303405.appspot.com",
                messagingSenderId: "377112735045",
                appId: "1:377112735045:web:733f931edd1ecc7b12a22c",
                measurementId: "G-PRGEZVF5XT"
            };
            // Initialize Firebase
            firebase.initializeApp(firebaseConfig);
            firebase.auth().useDeviceLanguage();
            <c:choose>
            <c:when test="${sessionScope.user != null}">
            <c:choose>
            <c:when test="${isPermitted}">
            $("#coverView").html("여행기록을 불러오는 중입니다.<br/>잠시만 기다려주세요.")
            reducedPicture = []
            markers = []
            let i = 0
            let objectStore = db.transaction("tracks", "readwrite").objectStore("tracks");
            let request = objectStore.get(${param.id});

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
                                    console.log("Image added to the store", request.result);
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
                                console.log("Tracking added to the store", request.result);
                            };

                            request.onerror = function () {
                                console.log("Error", request.error);
                            };
                            addObjectOnMap();

                        })
                }
            };
            </c:when>
            <c:otherwise>
            $("#coverView").html("친구신청을 해주세요")
            $("#fiendModal").modal();
            </c:otherwise>
            </c:choose>
            </c:when>
            <c:otherwise>
            $("#coverView").html("로그인을 해주세요!")
            $('#loginSelect').modal();
            $('#nickname').keyup(function () {
                if ($(this).val().length > $(this).attr('maxlength')) {
                    $(this).val($(this).val().substr(0, $(this).attr('maxlength')));
                }
            });

            $("#submit").click(function () {
                const nickname = $("#nickname").val()
                $.ajax({
                    url: './checkNickname.do',
                    type: 'post',
                    data: {"nickname": nickname},
                    success: function (data) {

                        if (data == 'available') {
                            firebase.auth().currentUser.getIdToken(/* forceRefresh */ true).then(function (idToken) {

                                $.ajax({
                                    url: './registerUser.do',
                                    type: 'post',
                                    data: {"token": idToken, "nickname": nickname},
                                    dataType: "json",
                                    success: function (data) {

                                        alert(nickname + '님 환영합니다!');
                                        $('#nickNameModal').modal('hide');
                                        window.location.reload()
                                    },
                                    error: function (request, error) {
                                        //alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                                        alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
                                    }
                                })
                            }).catch(function (error) {
                                alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
                            });
                        } else {
                            alert('중복된 닉네임입니다. 다른 닉네임을 입력해주세요.');
                        }

                    },
                    error: function (request, error) {
                        //alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                        alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
                    }
                })
            })

            </c:otherwise>
            </c:choose>

        }

        let provider = new firebase.auth.GoogleAuthProvider();

        function googleLogin() {
            provider = new firebase.auth.GoogleAuthProvider();
            loginProcess()
        }

        function appleLogin() {
            provider = new firebase.auth.OAuthProvider('apple.com');
            loginProcess()
        }

        function facebookLogin() {
            provider = new firebase.auth.FacebookAuthProvider();
            loginProcess()
        }

        function twitterLogin() {
            provider = new firebase.auth.TwitterAuthProvider();
            loginProcess()
        }

        function loginProcess() {
            firebase.auth()
                .signInWithPopup(provider)
                .then((result) => {

                    const user = result.user;
                    user.getIdToken(/* forceRefresh */ true).then(function (idToken) {
                        $.ajax({
                            url: './loginProcess.do',
                            type: 'post',
                            data: {"token": idToken},
                            dataType: "json",
                            success: function (json) {
                                if (json.success) {
                                    alert(json.result + '님 환영합니다!');
                                    window.location.reload()
                                } else {
                                    /*
                                    *
                return "{\"success\":false, \"result\":\"noUID\"}"
            }
            return "{\"success\":false, \"result\":\"invalidUser\"}"*/
                                    if (json.result == "noUID") {
                                        alert("신규회원은 닉네임을 정해주셔야 사용가능합니다!");
                                        $('#nickNameModal').modal('show');
                                    } else {
                                        alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
                                    }
                                }
                                //alert(json);
                            },
                            error: function (request, error) {
                                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                            }
                        })
                    }).catch(function (error) {
                        // Handle error
                        alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
                    });

                    // ...
                }).catch((error) => {
                // Handle Errors here.
                var errorCode = error.code;
                var errorMessage = error.message;
                // The email of the user's account used.
                var email = error.email;
                // The firebase.auth.AuthCredential type that was used.
                var credential = error.credential;
                // ...
                if ("auth/popup-closed-by-user" != errorCode) {
                    alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
                }
            });
        }

        $(function () {

            const IorA = navigator.userAgent.toLowerCase();

            <c:choose>
            <c:when test="${shareNum eq 2}">
            if (IorA.indexOf("android") !== -1 || IorA.indexOf("iphone") !== -1) {
                $("#coverView").html("<div style='width: 60%;height: 20%'>이 기록은 앱으로만 확인할수 있습니다!<div style='height:20%'></div><button onclick='onApp()' class='gradientButton'>앱에서 보기</button></div>")
            } else {
                $('#coverView').css("font-size", "xx-large")
                $("#coverView").text("이 기록은 앱으로만 확인할수 있습니다!")

            }

            </c:when>
            <c:otherwise>
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

            if (IorA.indexOf("android") !== -1 || IorA.indexOf("iphone") !== -1) {
                $("#coverView").html("<div style='width: 60%;height: 20%'><button onclick='onApp()' class='gradientButton'>앱에서 보기</button><div style='height:20%'></div><button onclick='onWeb()' class='gradientButton'>웹으로 보기</button></div>")
            } else {
                $('#coverView').css("font-size", "xx-large")
                setTimeout(function () {

                    onWeb()
                }, 1000);


            }


            </c:otherwise>
            </c:choose>

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
                            strokeColor: "#000000",
                            strokeOpacity: 1.0,
                            strokeWeight: 5,
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
                strokeColor: "#000000",
                strokeOpacity: 1.0,
                strokeWeight: 2,
            });
            Path.setMap(map);
        }

        function setCluster() {
            markerCluster = new MarkerClusterer(map, markers, {
                zoomOnClick: false,
                minimumClusterSize: 2
            });
            google.maps.event.addListener(markerCluster, 'clusteringend', function () {

//iterate over all clusters
                clusters = this.getClusters();
                setTimeout("timer()", 10);

            });
            google.maps.event.addListener(markerCluster, 'clusterclick', function (cluster) {


                $("#dynamicTbody").empty();
                let html = ""
                $("#photoListModal").modal()
                for (i = 0; i < cluster.markers_.length; i++) {
                    if (i % 3 == 0) {
                        html += '<tr>';
                    }
                    let idx = Number(cluster.markers_[i].label)
                    html += '<td><div class="ImageListClass" style="width: 100%;height: 100%;background-image: url(' + reducedPicture[idx] + ')"></div></td>'
                    if (i % 3 == 2) {
                        html += '</tr>';
                    }
                }
                $("#dynamicTbody").html(html);
            });
            $("#coverView").css("visibility", "hidden");
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

                        clusters[i].clusterIcon_.div_.innerHTML = '<div class = "customCluster" style="background-image: url(' + reducedPicture[idx] + ')"><div class="circle">' + parseInt($(clusters[i].clusterIcon_.div_).text()) + '</div>'
                    } else {
                        setTimeout("timer()", 10);
                    }
                }

            }
        }

        function initMap() {
            map = new google.maps.Map(
                document.getElementById('map'), mapOptions);
            map.setOptions({
                draggable: false,
                zoomControl: false,
                scrollwheel: false,
                disableDoubleClickZoom: true,
                gestureHandling: 'none'
            });

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
                $("#StEdImg").attr("src", "${pageContext.request.contextPath}/resource/img/play-button.png")
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
                        let animateTime = 1
                        if (!isDiscrete) {
                            angle = bearing(lastLoc.lat, lastLoc.lng, item.lat, item.lng)
                            animateTime = 3000 / speed
                        }
                        animation = new TWEEN.Tween(cameraOptions) // Create a new tween that modifies 'cameraOptions'.
                        animation.to({
                            tilt: 90,
                            heading: angle,
                            zoom: zoomLevels[zoomlevel],
                            center: item
                        }, animateTime) // Move to destination in 15 second.
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

        function goForward() {
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
        let isAuto = true

        function resumeAnimation() {
            let destLoc = null
            for (let i = nextIdx - 1; i < data.length; i++) {
                if (data[i].eventNum == 3) {
                    destLoc = {lat: data[i].lat, lng: data[i].lng}
                    break;
                }
            }
            if (destLoc != null) {
                if (isPause)
                    return

                let orgDist = google.maps.geometry.spherical.computeDistanceBetween(lastLoc, destLoc)
                let currDist = google.maps.geometry.spherical.computeDistanceBetween(map.center, destLoc)
                let animateTime

                if (isDiscrete) {
                    isDiscrete = false
                    animateTime = 1

                } else {
                    animateTime = 3000 / speed
                }
                let ratio = currDist / orgDist;

                if (isAuto && ratio > 0.5) {

                    angle = bearing(
                        lastLoc.latitude,
                        lastLoc.longitude,
                        destLoc.latitude,
                        destLoc.longitude
                    )
                    ratio -= 0.5
                    animation = new TWEEN.Tween(cameraOptions) // Create a new tween that modifies 'cameraOptions'.
                    animation.to({
                        tilt: 90,
                        heading: angle,
                        zoom: zoomLevels[zoomlevel],
                        center: destLoc
                    }, animateTime) // Move to destination in 15 second.
                        .easing(TWEEN.Easing.Quadratic.Out) // Use an easing function to make the animation smooth.
                        .onUpdate(() => {
                            map.moveCamera(cameraOptions);
                        })
                        .onComplete(() => {
                            lastLoc = destLoc
                            nextTracking()
                        })
                        .start(); // Start the tween immediately.


                    requestAnimationFrame(animate);
                } else {
                    animateTime = parseInt(animateTime * currDist / orgDist / 0.5)
                    if (animateTime < 1)
                        animateTime = 1

                    animation = new TWEEN.Tween(cameraOptions) // Create a new tween that modifies 'cameraOptions'.
                    animation.to({
                        tilt: 90,
                        heading: angle,
                        zoom: zoomLevels[zoomlevel],
                        center: destLoc
                    }, animateTime) // Move to destination in 15 second.
                        .easing(TWEEN.Easing.Quadratic.Out) // Use an easing function to make the animation smooth.
                        .onUpdate(() => {
                            map.moveCamera(cameraOptions);
                        })
                        .onComplete(() => {
                            lastLoc = destLoc
                            nextTracking()
                        })
                        .start(); // Start the tween immediately.


                    requestAnimationFrame(animate);
                }


            }
        }

        function addFriend() {
            $.ajax({
                url: './addFriendRequest.do',
                type: 'post',
                data: {"id": ${userID}},
                success: function (data) {

                    if (data == 'success' || data == 'alreadyRequested') {
                        alert("신청되었습니다. 친구신청 수락 되면 다시 시도해주세요.")
                        $("#coverView").html("친구신청 수락 되면 다시 시도해주세요.")
                        cancelFriendModal()
                    } else {
                        alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.")
                    }

                },
                error: function (request, error) {
                    //alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                    alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
                }
            })

        }

        function cancelFriendModal() {
            $("#fiendModal .close-modal").click()
        }

        function startStEd() {
            isPause = !isPause
            if (isStop) {
                $("#StEdImg").attr("src", "${pageContext.request.contextPath}/resource/img/pause.png")
                isStop = false
                getStartPoint()
                nextTracking()
            } else if (isPause) {
                $("#StEdImg").attr("src", "${pageContext.request.contextPath}/resource/img/play-button.png")
                stopAnimation()
            } else {
                $("#StEdImg").attr("src", "${pageContext.request.contextPath}/resource/img/pause.png")
                resumeAnimation()
            }
        }


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

    .ImageListClass {
        padding-top: 200;
        background-size: 100% 100%;
        background-position: center;
    }

    ::-webkit-scrollbar {
        display: block;
    }

    #coverView {
        position: fixed;
        padding: 0;
        margin: 0;

        top: 0;
        left: 0;

        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.8);
        display: flex;
        justify-content: center;
        align-items: center;
        color: white;
        font-size: x-large;
    }

    button {
        border: none;
        background: white;
    }

    .gradientButton {
        background-image: linear-gradient(to right, rgb(107, 69, 242), rgb(55, 138, 221));
        color: white;
        width: 100%;
        height: 40%;
        font-size: x-large;
        border-radius: 10px;
    }

    .gradientButtonMedium {
        background-image: linear-gradient(to right, rgb(107, 69, 242), rgb(55, 138, 221));
        color: white;
        width: 100%;
        height: 5%;
        font-size: x-large;
        border-radius: 10px;
    }

    .gradientButtonSmall {
        background-image: linear-gradient(to right, rgb(107, 69, 242), rgb(55, 138, 221));
        color: white;
        width: 48%;
        height: 5%;
        font-size: x-large;
        border-radius: 10px;
    }

    button {
        font-family: 'Jua', sans-serif;

    }

    .blocker {
        background: rgba(0, 0, 0, 0);
    }

    .modal {
        font-size: xx-large;
        background: rgb(36, 41, 64);
        color: white;
        width: 75%;
    }

    #map {
        position: relative;
    }

    #map:after {
        width: 22px;
        height: 40px;
        display: block;
        content: ' ';
        position: absolute;
        top: 50%;
        left: 50%;
        margin: -40px 0 0 -11px;
        background: url('https://maps.gstatic.com/mapfiles/markers2/boost-marker-mapview.png');
        background-size: 22px 40px; /* Since I used the HiDPI marker version this compensates for the 2x size */
        pointer-events: none; /* This disables clicks on the marker. Not fully supported by all major browsers, though */
    }

    .circle {
        font-family: 'Jua', sans-serif;
        width: 30px;
        height: 30px;
        line-height: 2.7;
        -webkit-border-radius: 25px;
        -moz-border-radius: 25px;
        border-radius: 25px;
        background: rgb(55, 128, 221);
        position: absolute;
        top: -10;
        left: -10;
        text-align: center;
        color: white;
    }
</style>
<body>

<div id="loginSelect" class="modal">
    <p>로그인을 해주세요!</p>
    <button class="gradientButtonMedium" onclick="googleLogin()">구글 로그인</button>
    <div style="height: 3%"></div>
    <button class="gradientButtonMedium" onclick="appleLogin()">애플 로그인</button>
    <div style="height: 3%"></div>
    <button class="gradientButtonMedium" onclick="facebookLogin()">페이스북 로그인</button>
    <div style="height: 3%"></div>
    <button class="gradientButtonMedium" onclick="twitterLogin()">트위터 로그인</button>
</div>
<div id="nickNameModal" class="modal">
    <p style="font-size: x-large;">타인에게 보여질 닉네임을 입력해주세요.
        최대 10자까지 가능하며 한번 정하면
        다시는 바꿀수 없으니 신중히 정해주세요!</p>
    <label style="font-size: x-large;" for="nickname">닉네임 : </label><input id="nickname" maxlength="10"
                                                                           style="font-size: x-large;">
    <div style="height: 10px"></div>
    <button id="submit" class="gradientButtonMedium">확인</button>
</div>
<div id="fiendModal" class="modal">
    <p style="font-size: x-large;">해당 여행 기록은 친구에게만 공개되어있습니다.
        ${nickname}님에게 친구신청 하시겠습니까?</p>
    <button class="gradientButtonSmall" id="ok" onclick="addFriend()">예</button>
    <button class="gradientButtonSmall" style="float: right" id="no" onclick="cancelFriendModal()">아니요</button>
</div>
<div id="photoListModal" class="modal" style="height: 50%">
    <div style="overflow: scroll;height: 100%;width: 100%">
    <table style="width: 100%;height: 100%;border: 1px;" id="dynamicTable">
        <tbody id="dynamicTbody">

        </tbody>
    </table>
    </div>
</div>
<div id="map" style="width:100%; height: 93%;"></div>
<div style="height: 7%;text-align: center">
    <button style="width: 30%;height: 100%;float: left" onclick="goPrev()"><img style="max-height: 100%;"
                                                                                src="${pageContext.request.contextPath}/resource/img/rewind-button.png"
                                                                                alt=""></button>
    <button style="width: 30%;height: 100%" onclick="startStEd()"><img id="StEdImg" style="max-height: 100%;"
                                                                       src="${pageContext.request.contextPath}/resource/img/play-button.png"
                                                                       alt=""></button>
    <button style="width: 30%;height: 100%;float: right" onclick="goForward()"><img style="max-height: 100%;"
                                                                                    src="${pageContext.request.contextPath}/resource/img/foward-button.png"
                                                                                    alt=""></button>
</div>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?v=beta&key=AIzaSyB8iqDaOP-shG0WVvUm4IASMinBvtjyU2w&callback=initMap&region=kr&libraries=geometry"></script>
<script src="https://unpkg.com/@googlemaps/markerclustererplus/dist/index.min.js"></script>
<div id="coverView">잠시만 기다려 주세요.
</div>

</body>
</html>
