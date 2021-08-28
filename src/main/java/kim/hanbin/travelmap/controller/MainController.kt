package kim.hanbin.travelmap.controller

import kim.hanbin.travelmap.service.MainService
import org.springframework.http.MediaType
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.servlet.ModelAndView
import javax.annotation.Resource
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


@Controller
class MainController {
    @Resource(name = "mainService")
    private lateinit var mainService: MainService

    @RequestMapping("/")
    fun redirect(httpResponse: HttpServletResponse) {
        httpResponse.sendRedirect("/index.do")
    }

    @RequestMapping("/index.do")
    fun index(model: Model): String {
        val list: List<String> = mainService.selectList()
        return "index"
    }

    @RequestMapping("/routing.do")
    fun routing(model: Model, @RequestParam id: Int): String {

        return mainService.processRouting(model, id)
    }


    @RequestMapping("/upload_test.do")
    fun uploadTest(model: Model): String {
        return "upload_test"
    }

    @RequestMapping("/registerUser.do")
    @ResponseBody
    fun registerUser(request: HttpServletRequest, @RequestParam token: String, @RequestParam nickname: String): String {
        return mainService.registerUser(request, token, nickname)
    }

    @RequestMapping("/checkNickname.do", method = [RequestMethod.POST])
    @ResponseBody
    fun checkNickname(request: HttpServletRequest, @RequestParam nickname: String): String {
        return mainService.checkNickname(nickname)
    }

    @RequestMapping("/loginProcess.do", method = [RequestMethod.POST])
    @ResponseBody
    fun loginProcess(request: HttpServletRequest, @RequestParam token: String): String {
        return mainService.processLogin(request, token)
    }


    @RequestMapping("/login.do")
    fun login(request: HttpServletRequest): String {
        return "login"
    }

    @RequestMapping("/logout.do")
    @ResponseBody
    fun logout(request: HttpServletRequest): String {
        return mainService.processLogout(request)
    }

    @RequestMapping("/nicknamePopup.do")
    fun nicknamePopup(request: HttpServletRequest): String {
        return "nicknamePopup"
    }

    @RequestMapping("/deleteUser.do")
    @ResponseBody
    fun deleteUser(request: HttpServletRequest): String {
        return mainService.processDeleteUser(request)
    }


    @RequestMapping("/upload.do", method = [RequestMethod.POST], consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    @ResponseBody
    fun upload(request: MultipartHttpServletRequest): String {
        return mainService.processUploadFile(request)
    }

    @RequestMapping("/fileDownload.do")
    fun fileDownload(request: HttpServletRequest, @RequestParam("trackingNum") id: Int): ModelAndView {
        val file = mainService.fileDownload(request, id)
        return if (file != null)
            ModelAndView("download", "downloadFile", file)
        else
            ModelAndView("index")
    }

    @RequestMapping("/deleteFile.do")
    @ResponseBody
    fun deleteFile(request: HttpServletRequest, @RequestParam("trackingNum") id: Int): String {
        return mainService.deleteFile(request, id)
    }
}