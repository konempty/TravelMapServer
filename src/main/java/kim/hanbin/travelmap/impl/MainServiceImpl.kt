package kim.hanbin.travelmap.impl

import kim.hanbin.travelmap.dao.MainDAO
import kim.hanbin.travelmap.service.MainService
import org.springframework.stereotype.Service
import java.util.logging.Logger
import javax.annotation.Resource

@Service("mainService")
class MainServiceImpl : MainService {
    var log: Logger = Logger.getLogger(this.javaClass.toString())

    @Resource(name = "mainDAO")
    private lateinit var sampleDAO: MainDAO


    override fun selectList(): List<String> {

        return sampleDAO.selectTestList()
    }
}