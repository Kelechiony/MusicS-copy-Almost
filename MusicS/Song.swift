import UIKit
import MusicKit

struct Song: Codable {
    var userId: String
    var userName: String
    var songTitle: String
    var artistName: String
    var albumTitle: String?
    var albumArtworkURL: String?
    var songURL: String
    var likeCount: Int
    var commentCount: Int
    var userProfileImageURL: String
    
    init(userId: String, userName: String, songTitle: String, artistName: String, songURL: String, likeCount: Int = 0, commentCount: Int = 0, userProfileImageURL: String = "") {
        self.userId = userId
        self.userName = userName
        self.songTitle = songTitle
        self.artistName = artistName
        self.albumTitle = nil
        self.albumArtworkURL = nil
        self.songURL = songURL
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.userProfileImageURL = userProfileImageURL
    }
}

