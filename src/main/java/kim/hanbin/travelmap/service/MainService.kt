package kim.hanbin.travelmap.service

interface MainService {
    @Throws(Exception::class)
    fun selectList(): List<String>

}
