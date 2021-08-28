<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-08-21
  Time: 오후 1:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">

    <script src="https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-auth.js"></script>
    <title>닉네임을 설정해 주세요</title>
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
                                    window.opener.redirect();
                                    close();

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


    })

</script>
<p>타인에게 보여질 닉네임을 입력해주세요.
    최대 10자까지 가능하며 한번 정하면
    다시는 바꿀수 없으니신중히 정해주세요!</p>
<label for="nickname">닉네임 : </label><input id="nickname" maxlength="10">
<button id="submit">확인</button>
</body>
</html>
