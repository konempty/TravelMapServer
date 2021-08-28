package kim.hanbin.travelmap

import org.springframework.util.FileCopyUtils
import org.springframework.web.servlet.view.AbstractView
import java.io.File
import java.io.FileInputStream
import java.io.OutputStream
import java.net.URLEncoder
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


class FileDownload : AbstractView() {
    fun Download() {
        contentType = "application/download; utf-8"
    }

    @Throws(Exception::class)
    override fun renderMergedOutputModel(
        model: Map<String?, Any?>,
        request: HttpServletRequest, response: HttpServletResponse
    ) {
        // TODO Auto-generated method stub
        val file: File = model["downloadFile"] as File
        //println("DownloadView --> file.getPath() : " + file.path)
        //println("DownloadView --> file.getName() : " + file.name)
        response.contentType = contentType
        response.setContentLength(file.length().toInt())

        //String userAgent = request.getHeader("User-Agent");

        //boolean ie = userAgent.indexOf("MSIE") > -1;
        var fileName: String? = null

        //if(ie){
        //브라우저 정보에 따라 utf-8변경
        fileName = if (request.getHeader("User-Agent").indexOf("MSIE") > -1) {
            URLEncoder.encode(file.name, "utf-8")
        } else {
            String(file.name.toByteArray())
        } // end if;
        response.setHeader("Content-Disposition", "attachment; filename=\"$fileName\";")
        response.setHeader("Content-Transfer-Encoding", "binary")
        val out: OutputStream = response.outputStream
        var fis: FileInputStream? = null

        //파일 카피 후 마무리
        try {
            fis = FileInputStream(file)
            FileCopyUtils.copy(fis, out)
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            if (fis != null) {
                try {
                    fis.close()
                } catch (e: Exception) {
                }
            }
        } // try end;
        out.flush()
    }
}