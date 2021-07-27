package kim.hanbin.travelmap.controller

import kim.hanbin.travelmap.service.MainService
import org.apache.commons.io.FileUtils
import org.springframework.http.MediaType
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.multipart.MultipartFile
import java.io.File
import java.io.IOException
import java.io.InputStream
import javax.annotation.Resource


@Controller
class MainController {
    @Resource(name = "mainService")
    private lateinit var mainService: MainService

    @RequestMapping("/index.do")
    fun index(model: Model): String {
        val list: List<String> = mainService.selectList()
        //model.addAttribute("data", "Hello, Spring from IntelliJ! :)")
        return "index"
    }

    @RequestMapping("/upload.do", method = [RequestMethod.POST], consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    @ResponseBody
    fun upload(model: Model, @RequestParam("file") multipartFile: MultipartFile): String {
        val targetFile = File("/TravelMap/uploadFiles/" + multipartFile.originalFilename)
        try {
            val fileStream: InputStream = multipartFile.inputStream
            FileUtils.copyInputStreamToFile(fileStream, targetFile)
        } catch (e: IOException) {
            FileUtils.deleteQuietly(targetFile)
            e.printStackTrace()
            return "fail"
        }
        return "success"
    }

    @RequestMapping("/upload_test.do")
    fun upload_test(model: Model): String {

        return "upload_test"
    }
}