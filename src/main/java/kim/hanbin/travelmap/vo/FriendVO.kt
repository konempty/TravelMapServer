package kim.hanbin.travelmap.vo

data class FriendVO(val id:Long,val nickname:String,val isPartially:Boolean) {

    constructor (id:Long,nickname:String):this(id,nickname,true)
}