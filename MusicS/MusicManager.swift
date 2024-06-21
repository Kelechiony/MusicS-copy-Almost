import MusicKit

class MusicManager {
    static let shared = MusicManager()
    
    func searchSongs(with query: String, completion: @escaping ([Song]) -> Void) {
            Task {
                do {
                    let request = MusicCatalogSearchRequest(term: query, types: [MusicKit.Song.self])
                    let response = try await request.response()
                    
                    let songs = response.songs.map { musicKitSong in
                        Song(
                            userId: "userId_placeholder",
                            userName: "userName_placeholder",
                            songTitle: musicKitSong.title ?? "Unknown Title",
                            artistName: musicKitSong.artistName ?? "Unknown Artist",
                            songURL: musicKitSong.url?.absoluteString ?? ""
                        )
                    }
                    
                    completion(songs)
                } catch {
                    print("Error searching songs: \(error)")
                    completion([])
                }
            }
        }
    }

