package kim.hanbin.travelmap.vo

data class UserVO(
    val id: Int,
    val uid: String,
    val nickname: String,
    val regTime: String
) {
    constructor(
        uid: String,
        nickname: String
    ) : this(0, uid, nickname, "")
}