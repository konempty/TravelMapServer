package kim.hanbin.travelmap.dao

import kim.hanbin.travelmap.vo.TrackingVO
import kim.hanbin.travelmap.vo.UserVO
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional

@Repository("mainDAO")
open class MainDAO : AbstractDAO() {
    fun selectTestList(): List<String> {
        return selectList("main.selectBoardList") as List<String>
    }

    fun getUser(uid: String): UserVO? {
        return selectOne("main.getUser", uid) as UserVO?
    }

    fun checkNickname(nickname: String): Int {
        return selectOne("main.checkNickname", nickname) as Int
    }

    @Transactional
    open fun registerUser(user: UserVO): UserVO {
        insert("main.registerUser", user)
        return selectOne("main.getUser", user.uid) as UserVO
    }

    fun deleteUser(user: UserVO): Int {
        return delete("main.deleteUser", user)
    }

    @Transactional
    open fun insertFile(file: TrackingVO): Int {
        insert("main.insertTracking", file)
        return selectOne("main.getMaxTrackingID") as Int
    }

    fun getFile(map: Map<String, Int>): TrackingVO? {
        return selectOne("main.getTracking", map) as TrackingVO?
    }

    fun deleteFile(file: TrackingVO): Int {
        return delete("main.deleteTracking", file)
    }

    fun getUserId(nickname: String): Int? {
        return selectOne("main.getUserId", nickname) as Int?
    }

    fun checkFriendRequest(map: Map<String, Int>): Int {
        return selectOne("main.checkFriendRequest", map) as Int
    }

    fun addFriendRequest(map: Map<String, Int>) {
        insert("main.addFriendRequest", map)
    }


    fun deleteFriend(map: MutableMap<String, Int>) {
        delete("main.deleteFriend", map)
    }


    fun getFriendRequestList(user: UserVO): List<String> {
        return selectList("main.getFriendRequestList", user) as List<String>
    }

    fun getFriendRequestedList(user: UserVO): List<String> {
        return selectList("main.getFriendRequestedList", user) as List<String>
    }

    fun getFriendList(user: UserVO): List<String> {
        return selectList("main.getFriendList", user) as List<String>

    }

}