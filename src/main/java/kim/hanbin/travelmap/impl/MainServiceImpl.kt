package kim.hanbin.travelmap.impl

import com.google.common.base.Utf8
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
import java.net.URLDecoder
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
        return if(session!=null){
            session.invalidate()
            "success"
        }else{
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
        if(isEncoded ==true) {
           name= String(Base64.getDecoder().decode(name), Charset.forName("UTF-8"))
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
    override fun deleteFile(request: HttpServletRequest, id: Int): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {
            return if (mainDAO.deleteFile(TrackingVO(id, user.id)) == 1)
                "{\"success\":true}"
            else
                "{\"success\":false, \"result\":\"noDelete\"}"
        }
        return "{\"success\":false, \"result\":\"noUID\"}"
    }

    override fun processRouting(model: Model, id: Int): String {
        val hashMap = HashMap<String, Int>()
        hashMap["id"] = id
        hashMap["userid"] = -1
        val fileVO = mainDAO.getFile(hashMap) ?: return "errorPage"
        if (fileVO.shareNum.toInt() == 2)
            model.addAttribute("salt", "S.salt=${fileVO.salt};")
if(!fileVO.isPermited)
    fileVO.filename = ""

        return "routing"
    }

    override fun getUserId(nickname: String): Int {
        val result = mainDAO.getUserId(nickname)
        if(result!=null)
            return result
       return -1
    }

    override fun addFriendRequest(request: HttpServletRequest, id: Int): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if(user!=null){
            val map = mutableMapOf<String,Int>()
            map["userId"] = user.id
            map["friendId"] = id
            if(mainDAO.checkFriendRequest(map)!=0){
                return "alreadyRequested"
            }else{
                mainDAO.addFriendRequest(map)
                return "success"
            }
        }
        return "noUID"
    }

    override fun deleteFriend(request: HttpServletRequest, id: Int): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if(user!=null){
            val map = mutableMapOf<String,Int>()
            map["userId"] = user.id
            map["friendId"] = id
            if(mainDAO.checkFriendRequest(map)==0){
                return "noRequest"
            }else{
                mainDAO.deleteFriend(map)
                return "success"
            }
        }
        return "noUID"
    }

    override fun getFriendRequestList(request: HttpServletRequest): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {

           val obj =  JsonObject()
            obj.addProperty("success",true)
            val list =  mainDAO.getFriendRequestList(user)
            val arr = JsonArray()
            for(item in list){
                arr.add(item)
            }
            obj.add("list",arr)
            return obj.toString()
        }
        return "{\"success\":false, \"result\":\"noUID\"}"
    }

    override fun getFriendRequestedList(request: HttpServletRequest): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {

            val obj =  JsonObject()
            obj.addProperty("success",true)
            val list =  mainDAO.getFriendRequestedList(user)
            val arr = JsonArray()
            for(item in list){
                arr.add(item)
            }
            obj.add("list",arr)
            return obj.toString()
        }
        return "{\"success\":false, \"result\":\"noUID\"}"
    }

    override fun getFriendList(request: HttpServletRequest): String {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        if (user != null) {

            val obj =  JsonObject()
            obj.addProperty("success",true)
            val list =  mainDAO.getFriendList(user)
            val arr = JsonArray()
            for(item in list){
                arr.add(item)
            }
            obj.add("list",arr)
            return obj.toString()
        }
        return "{\"success\":false, \"result\":\"noUID\"}"
    }

    @Throws(Exception::class)
    override fun fileDownload(request: HttpServletRequest, id: Int): File? {
        val session = request.session
        val user = session.getAttribute("user") as? UserVO
        val hashMap = HashMap<String, Int>()
        hashMap["id"] = id
        hashMap["userid"] = user?.id ?: 0

        val fileVO = mainDAO.getFile(hashMap)
        if(fileVO?.isPermited==false)
            fileVO.filename = ""
        return fileVO?.let { File("/TravelMap/uploadFiles/" + fileVO.filename) }
    }

}