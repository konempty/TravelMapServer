package kim.hanbin.travelmap.vo


data class TrackingVO(
    val id: Int,
    val userID: Int,
    val shareNum: UByte,
    val salt: String?,
    val trackingName: String,
    val filename: String,
    val regTime: String
) {
    constructor(
        userID: Int,
        share: UByte,
        salt: String?,
        name: String,
        filename: String
    ) : this(0, userID, share, salt, name, filename, "")

    constructor(
        id: Int,
        userID: Int
    ) : this(id, userID, 0u, null, "", "", "")

    constructor(
        id: Int,
        userID: Int,
        share: UByte,
        salt: String?,
        name: String,
        regTime: String
    ) : this(id, userID, share, salt, name, "filename", regTime)
}