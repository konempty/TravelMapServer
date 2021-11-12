package kim.hanbin.travelmap.vo


data class TrackingVO(
    val id: Long,
    val userID: Long,
    val shareNum: UByte,
    val salt: String?,
    val trackingName: String,
    val filename: String,
    val regTime: String,
    val isPermitted: Boolean = true
) {
    constructor(
        userID: Long,
        share: UByte,
        salt: String?,
        name: String,
        filename: String
    ) : this(0, userID, share, salt, name, filename, "")

    constructor(
        id: Long,
        userID: Long
    ) : this(id, userID, 0u, null, "", "", "")

    constructor(
        id: Long,
        userID: Long,
        share: UByte,
        salt: String?,
        name: String,
        isPermitted: Boolean,
        regTime: String
    ) : this(id, userID, share, salt, name, "filename", regTime, isPermitted)

    constructor(
        id: Long,
        userID: Long,
        share: UByte,
        salt: String?,
        name: String,
        isPermitted: Boolean,
        filename: String,
        regTime: String
    ) : this(id, userID, share, salt, name, filename, regTime, isPermitted)
}