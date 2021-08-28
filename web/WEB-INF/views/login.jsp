<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-08-20
  Time: 오후 10:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">

    <script src="https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-auth.js"></script>
    <title>로그인을 해주세요</title>
</head>
<body>

<script>
    $(function () {
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
    })
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
                                redirect()
                            } else {
                                /*
                                *
            return "{\"success\":false, \"result\":\"noUID\"}"
        }
        return "{\"success\":false, \"result\":\"invalidUser\"}"*/
                                if (json.result == "noUID") {
                                    alert("신규회원은 닉네임을 정해주셔야 사용가능합니다!");
                                    openPopup()
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

            alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
        });
    }

    function openPopup() {
        const option = "width = 500, height = 500, top = 100, left = 200, location = no, scrollbars = no, toolbars = no";
        const win = window.open("nicknamePopup.do", "닉네임 입력", option);
        if (win == null || typeof (win) == "undefined" || (win == null && win.outerWidth == 0) || (win != null && win.outerHeight == 0) || win.test == "undefined") {
            alert("팝업 차단 기능이 설정되어있습니다.\n\n차단 기능을 해제(팝업허용) 한 후 다시 시도해주세요.\n\n만약 팝업 차단 기능을 해제하지 않으면\n닉네임을 설정하실수 없습니다.");
            if (win) {
                win.close();
            }
        } else if (win) {
            if (win.innerWidth === 0) {
                alert("팝업 차단 기능이 설정되어있습니다.\n\n차단 기능을 해제(팝업허용) 한 후 다시 시도해주세요.\n\n만약 팝업 차단 기능을 해제하지 않으면\n닉네임을 설정하실수 없습니다.");
            }
        }
    }

    function redirect() {

        window.location = <c:choose><c:when test="${empty param.redirect}">'./index.do'
        </c:when><c:otherwise>'<c:out value="${param.redirect}" />'
        </c:otherwise></c:choose>
    }

    function logout() {
        firebase.auth().signOut().then(() => {
            $.ajax({
                url: './logout.do',
                type: 'get',
                success: function (data) {
                    if (data == 'success')
                        alert("성공")
                    else
                        alert("실패")


                },
                error: function (request, error) {
                    //alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                    alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
                }
            })
        }).catch((error) => {
            alert("문제가 발생했습니다. 잠시후 다시 시도해주세요.");
        });
    }
</script>

<button onclick="googleLogin()">구글 로그인</button>
<button onclick="appleLogin()">애플 로그인</button>
<button onclick="facebookLogin()">페이스북 로그인</button>
<button onclick="twitterLogin()">트위터 로그인</button>
<button onclick="logout()">로그아웃</button>

</body>
</html>
