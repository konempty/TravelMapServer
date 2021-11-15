package kim.hanbin.travelmap.impl

import com.google.firebase.auth.FirebaseAuth
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import kim.hanbin.travelmap.dao.MainDAO
import kim.hanbin.travelmap.service.MainService
import kim.hanbin.travelmap.vo.TrackingVO
import kim.hanbin.travelmap.vo.UserVO
import org.apache.commons.io.FileUtils
import org.apache.log4j.Logger
import org.springframework.stereotype.Service
import org.springframework.ui.Model
import org.springframework.web.multipart.MultipartHttpServletRequest
import java.io.File
import java.io.IOException
import java.io.InputStream
import java.nio.charset.Charset
import java.util.*
import javax.annotation.Resource
import javax.servlet.http.HttpServletRequest


@Service("mainService")
class MainServiceImpl : MainService {
    var log: Logger = Logger.getLogger(this.javaClass.toString())

    @Resource(name = "mainDAO")
    private lateinit var mainDAO: MainDAO

    @Throws(Exception::class)
    override fun selectList(): List<String> {

        return mainDAO.selectTestList()
    }

    @Throws(Exception::class)
    override fun processLogin(request: HttpServletRequest, token: String): String {
        val decodedToken = FirebaseAuth.getInstance().verifyIdToken(token)
        val uid = decodedToken.uid
        if (uid != null) {
            val user = mainDAO.getUser(uid)
            if (user != null) {
                val session = request.session
                session.setAttribute("user", user)
                return "{\"success\":true, \"result\":\"${user.nickname}\"}"
            }
            return "{\"success\":false, \"result\":\"noUID\"}"
        }
        return "{\"success\":false, \"result\":\"invalidUser\"}"
    }

    override fun loginCheck(request: HttpServletRequest): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {
            return "Logedin"
        }
        return "noLogedin"
    }

    override fun processLogout(request: HttpServletRequest): String {
        val session = request.session
        return if (session != null) {
            session.invalidate()
            "success"
        } else {
            "fail"
        }
    }

    @Throws(Exception::class)
    override fun checkNickname(nickname: String): String {
        return if (mainDAO.checkNickname(nickname) == 0)
            "available"
        else
            "unavailable"

    }

    @Throws(Exception::class)
    override fun registerUser(request: HttpServletRequest, token: String, nickname: String): String {
        val decodedToken = FirebaseAuth.getInstance().verifyIdToken(token)
        val uid = decodedToken.uid
        if (uid != null) {
            var user = UserVO(uid, nickname)

            user = mainDAO.registerUser(user)
            val session = request.session
            session.setAttribute("user", user)
            return "{\"success\":true}"
        }
        return "{\"success\":false, \"result\":\"invalidUser\"}"
    }

    @Throws(Exception::class)
    override fun processDeleteUser(request: HttpServletRequest): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {
            val files = mainDAO.getUserTrackingList(user)
            for (file in files) {
                deleteFile(file.filename)
            }
            mainDAO.deleteUser(user)
            return "{\"success\":true}"
        }
        return "{\"success\":false, \"result\":\"noUID\"}"
    }


    @Throws(Exception::class)
    override fun processUploadFile(request: MultipartHttpServletRequest): String {
        val multipartFile = request.getFile("file")!!
        val share = request.getParameter("share").toUByte()
        val salt = request.getParameter("salt")
        var name = request.getParameter("trackingName")
        val isEncoded = request.getParameter("isEncoded")?.toBooleanStrictOrNull()
        if (isEncoded == true) {
            name = String(Base64.getDecoder().decode(name), Charset.forName("UTF-8"))
        }
        val splits = multipartFile.originalFilename!!.split(".")
        val extension = splits[splits.size - 1].uppercase(Locale.KOREA)
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {
            if (extension == "JSON" || extension == "ENC") {
                var filename = multipartFile.originalFilename!!
                var targetFile = File("/TravelMap/uploadFiles/$filename")
                var count = 1
                while (targetFile.exists()) {
                    filename = count.toString() + multipartFile.originalFilename
                    targetFile = File("/TravelMap/uploadFiles/$filename")
                    count++
                }
                try {
                    val fileStream: InputStream = multipartFile.inputStream
                    FileUtils.copyInputStreamToFile(fileStream, targetFile)
                } catch (e: IOException) {
                    FileUtils.deleteQuietly(targetFile)
                    e.printStackTrace()
                    return "{\"success\":false, \"result\":\"IOException\"}"
                }

                val result = mainDAO.insertFile(TrackingVO(user.id, share, salt, name, filename))
                return "{\"success\":true, \"result\":${result}}"
            }
            return "{\"success\":false, \"result\":\"invalidFileExtension\"}"
        }

        //위 코드 실패시 차선책
        /*val filename = request.getParameter("name")
        val upload = ServletFileUpload()
        try {
            val iter = upload.getItemIterator(request)
            while (iter.hasNext()) {
                val item = iter.next()
                val name = item.fieldName
                val stream = item.openStream()
                if (item.isFormField) {
                    println("Field Name:" + name + "Value:" + Streams.asString(stream))
                } else {
                    val out: OutputStream = FileOutputStream("incoming.gz")
                    IOUtils.copy(stream, out)
                    stream.close()
                    out.close()
                }
            }
        } catch (e: FileUploadException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }*/


        return "{\"success\":false, \"result\":\"noUID\"}"
    }

    @Throws(Exception::class)
    override fun deleteFile(request: HttpServletRequest, id: Long): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {
            val hashMap = HashMap<String, Long>()
            hashMap["id"] = id
            hashMap["userid"] = user.id
            val file = mainDAO.getFile(hashMap)
            if (file != null)
                deleteFile(file.filename)
            return if (mainDAO.deleteFile(TrackingVO(id, user.id)) == 1)
                "{\"success\":true}"
            else
                "{\"success\":false, \"result\":\"noDelete\"}"
        }
        return "{\"success\":false, \"result\":\"noUID\"}"
    }

    private fun deleteFile(filename: String) {


        val targetFile = File("/TravelMap/uploadFiles/$filename")
        if (targetFile.exists()) {
            if (targetFile.delete()) {
                println("파일삭제 성공")
            } else {
                println("파일삭제 실패")
            }
        } else {
            println("파일이 존재하지 않습니다.")
        }
    }

    override fun processRouting(model: Model, id: Long): String {
        val hashMap = HashMap<String, Long>()
        hashMap["id"] = id
        hashMap["userid"] = -1
        val fileVO = mainDAO.getFile(hashMap) ?: return "errorPage"
        if (fileVO.shareNum.toInt() == 2)
            model.addAttribute("salt", "S.salt=${fileVO.salt};")
        model.addAttribute("trackingData", "S.shareNum=${fileVO.shareNum};S.userID=${fileVO.userID};S.nickname=${mainDAO.getUserNickname(fileVO.userID)};S.trackingName=${fileVO.trackingName};")

        return "routing"
    }

    override fun getUserId(nickname: String): Long {
        val result = mainDAO.getUserId(nickname)
        if (result != null)
            return result
        return -1
    }

    override fun addFriendRequest(request: HttpServletRequest, id: Long): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {
            val map = mutableMapOf<String, Long>()
            map["userId"] = user.id
            map["friendId"] = id
            if (user.id==id||mainDAO.checkFriendRequest(map) != 0) {
                return "alreadyRequested"
            } else {
                mainDAO.addFriendRequest(map)
                return "success"
            }
        }
        return "noUID"
    }

    override fun deleteFriend(request: HttpServletRequest, id: Long): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {
            val map = mutableMapOf<String, Long>()
            map["userId"] = user.id
            map["friendId"] = id
            mainDAO.deleteFriend(map) //내 신청도 지우고
            map["userId"] = id
            map["friendId"] = user.id
            mainDAO.deleteFriend(map) //상대방 신청도 지운다
            return "success"
        }
        return "noUID"
    }



    override fun getFriendRequestedList(request: HttpServletRequest): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {

            val obj = JsonObject()
            obj.addProperty("success", true)
            val list = mainDAO.getFriendRequestedList(user)
            val arr = JsonArray()
            for (item in list) {
                val obj2 = JsonObject()
                obj2.addProperty("id",item.id)
                obj2.addProperty("nickname",item.nickname)
                arr.add(obj2)
            }
            obj.add("list", arr)
            return obj.toString()
        }
        return "{\"success\":false, \"result\":\"noUID\"}"
    }

    override fun getFriendList(request: HttpServletRequest): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {

            val obj = JsonObject()
            obj.addProperty("success", true)
            val list = mainDAO.getFriendList(user)
            val arr = JsonArray()
            for (item in list) {
                val obj2 = JsonObject()
                obj2.addProperty("id",item.id)
                obj2.addProperty("nickname",item.nickname)
                obj2.addProperty("isPartially",item.isPartially)
                arr.add(obj2)
            }
            obj.add("list", arr)
            return obj.toString()
        }
        return "{\"success\":false, \"result\":\"noUID\"}"
    }

    override fun checkPermission(request: HttpServletRequest, id: Long): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {


            val map = mutableMapOf<String, Long>()
            map["userId"] = user.id
            map["friendId"] = id
            return (user.id==id||mainDAO.checkPermission(map)).toString()
        }
        return "noUID"
    }

    @Throws(Exception::class)
    override fun fileDownload(request: HttpServletRequest, id: Long): File? {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        val hashMap = HashMap<String, Long>()
        hashMap["id"] = id
        hashMap["userid"] = user?.id ?: 0

        val fileVO = mainDAO.getFile(hashMap)
        if (fileVO?.isPermitted != true)
            return null
        return File("/TravelMap/uploadFiles/" + fileVO.filename)
    }

}