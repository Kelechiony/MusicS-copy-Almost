//  LocalStorageService.swift
//  MusicS
//
//  Created by Kelechi Onyenachi on 6/9/24.
//

import Foundation

class LocalStorageService {
    var songs: [Song] = []
    var comments: [Comment] = []

    func fetchSongs() -> [Song]? {
        // Fetch songs logic...
        return songs
    }
    
    func likeSong(songId: String) {
        // Like song logic...
    }
    
    func postSong(song: Song) {
        songs.append(song)
    }
    
    func postComment(songId: String, comment: Comment) {
        // Post comment logic...
        comments.append(comment)
    }
}





