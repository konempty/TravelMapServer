package kim.hanbin.travelmap.service

import org.springframework.ui.Model
import org.springframework.web.multipart.MultipartHttpServletRequest
import java.io.File
import javax.servlet.http.HttpServletRequest

interface MainService {
    @Throws(Exception::class)
    fun selectList(): List<String>

    @Throws(Exception::class)
    fun processLogin(request: HttpServletRequest, token: String): String

    @Throws(Exception::class)
    fun loginCheck(request: HttpServletRequest): String

    @Throws(Exception::class)
    fun processLogout(request: HttpServletRequest): String

    @Throws(Exception::class)
    fun checkNickname(nickname: String): String

    @Throws(Exception::class)
    fun registerUser(request: HttpServletRequest, token: String, nickname: String): String

    @Throws(Exception::class)
    fun processUploadFile(request: MultipartHttpServletRequest): String

    @Throws(Exception::class)
    fun fileDownload(request: HttpServletRequest, id: Int): File?

    @Throws(Exception::class)
    fun processDeleteUser(request: HttpServletRequest): String

    @Throws(Exception::class)
    fun deleteFile(request: HttpServletRequest, id: Int): String

    @Throws(Exception::class)
    fun processRouting(model: Model, id: Int): String

    @Throws(Exception::class)
    fun getUserId(nickname: String): Int

    @Throws(Exception::class)
    fun addFriendRequest(request: HttpServletRequest, id: Int): String

    @Throws(Exception::class)
    fun deleteFriend(request: HttpServletRequest, id: Int): String

    @Throws(Exception::class)
    fun getFriendRequestList(request: HttpServletRequest): String

    @Throws(Exception::class)
    fun getFriendRequestedList(request: HttpServletRequest): String

    @Throws(Exception::class)
    fun getFriendList(request: HttpServletRequest): String


}
