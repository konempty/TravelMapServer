package kim.hanbin.travelmap.dao

import org.springframework.stereotype.Repository

@Repository("mainDAO")
class MainDAO : AbstractDAO() {
    fun selectTestList(): List<String> {
        return selectList("main.selectBoardList") as List<String>
    }
}