package kim.hanbin.travelmap.dao

import kim.hanbin.travelmap.vo.FriendVO
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

    fun getUserTrackingList(user: UserVO): List<TrackingVO> {
        return selectList("main.getUserTrackingList", user) as List<TrackingVO>
    }

    fun getFile(map: HashMap<String, Long>): TrackingVO? {
        return selectOne("main.getTracking", map) as TrackingVO?
    }

    fun deleteFile(file: TrackingVO): Int {
        return delete("main.deleteTracking", file)
    }

    fun getUserId(nickname: String): Long? {
        return selectOne("main.getUserId", nickname) as Long?
    }

    fun getUserNickname(id: Long): String {
        return selectOne("main.getUserNickname", id) as String
    }

    fun checkFriendRequest(map: MutableMap<String, Long>): Int {
        return selectOne("main.checkFriendRequest", map) as Int
    }

    fun addFriendRequest(map: MutableMap<String, Long>) {
        insert("main.addFriendRequest", map)
    }


    fun deleteFriend(map: MutableMap<String, Long>) {
        delete("main.deleteFriend", map)
    }


    fun getFriendRequestedList(user: UserVO): List<FriendVO> {
        return selectList("main.getFriendRequestedList", user) as List<FriendVO>
    }

    fun getFriendList(user: UserVO): List<FriendVO> {
        return selectList("main.getFriendList", user) as List<FriendVO>

    }

    fun checkFriend(map: MutableMap<String, Long>): Boolean {
        return selectOne("main.checkFriend", map) as Boolean
    }

}