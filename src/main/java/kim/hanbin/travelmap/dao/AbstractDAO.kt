package kim.hanbin.travelmap.dao

import org.apache.commons.logging.Log
import org.apache.commons.logging.LogFactory
import org.mybatis.spring.SqlSessionTemplate

import org.springframework.beans.factory.annotation.Autowired


open class AbstractDAO {
    protected var log: Log = LogFactory.getLog(AbstractDAO::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSessionTemplate
    private fun printQueryId(queryId: String) {
        if (log.isDebugEnabled) {
            log.debug("\t QueryId  \t:  $queryId")
        }
    }

    fun insert(queryId: String, params: Any?): Int {
        printQueryId(queryId)
        return sqlSession.insert(queryId, params)
    }

    fun update(queryId: String, params: Any?): Int {
        printQueryId(queryId)
        return sqlSession.update(queryId, params)
    }

    fun delete(queryId: String, params: Any?): Int {
        printQueryId(queryId)
        return sqlSession.delete(queryId, params)
    }

    fun selectOne(queryId: String): Any? {
        printQueryId(queryId)
        return sqlSession.selectOne(queryId)
    }

    fun selectOne(queryId: String, params: Any?): Any? {
        printQueryId(queryId)
        return sqlSession.selectOne(queryId, params)
    }

    fun selectList(queryId: String): List<*> {
        printQueryId(queryId)
        return sqlSession.selectList<Any>(queryId)
    }

    fun selectList(queryId: String, params: Any?): List<*> {
        printQueryId(queryId)
        return sqlSession.selectList<Any>(queryId, params)
    }
}