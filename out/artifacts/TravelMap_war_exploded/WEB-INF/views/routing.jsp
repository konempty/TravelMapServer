<%--
  Created by IntelliJ IDEA.
  User: 1117p
  Date: 2021-08-07
  Time: 오후 12:09
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
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

</head>
<body>
<script>
    $(function () {
        const IorA = navigator.userAgent.toLowerCase();

        if (IorA.indexOf("android") !== -1) {
            //alert("???");
            //location.href = "intent://travelmap/#Intent;scheme=scheme;package=kim.hanbin.gpstracker;S.browser_fallback_url=https%3A%2F%2Fnaver.com;end";
        } else if (IorA.indexOf("iphone") !== -1) {
            // iphone 일 때
        } else {
            //location.href = "https://naver.com";

        }
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


    function json() {
        oboe('/fileDownload.do?trackingNum=${param.id}')
            .node('!.*', function (name) {
                console.log('You have a friend called', name);
            });
    }



</script>
<a href="intent://travelmap/#Intent;scheme=scheme;package=kim.hanbin.gpstracker;S.browser_fallback_url=https%3A%2F%2Fnaver.com;S.id=<c:out value="${param.id}" />;${salt}end">a
    tag</a>

<button onclick="json()"></button>
</body>
</html>
