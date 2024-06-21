import UIKit

class FeedViewController: UITableViewController {

    var songs = [Song]() {
        didSet {
            saveSongs()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongTableViewCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        self.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewSongPosted(notification:)), name: NSNotification.Name("NewSongPosted"), object: nil)
        
        loadSongs()

        // Show the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("NewSongPosted"), object: nil)
    }

    @objc func handleNewSongPosted(notification: Notification) {
        if let newSongInfo = notification.object as? [String: String],
           let userId = newSongInfo["userId"],
           let userName = newSongInfo["userName"],
           let title = newSongInfo["title"],
           let artist = newSongInfo["artist"],
           let songURL = newSongInfo["songURL"] {
            let newSong = Song(userId: userId, userName: userName, songTitle: title, artistName: artist, songURL: songURL)
            songs.insert(newSong, at: 0)
            tableView.reloadData()
        }
    }

    @objc func refreshFeed() {
        refreshControl?.endRefreshing()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        let song = songs[indexPath.row]
        cell.titleLabel.text = song.songTitle
        cell.userNameLabel.text = song.artistName
        // Assuming you have an extension or a method to load image from URL
        // cell.albumArtworkImageView.load(url: song.albumArtworkURL)
        return cell
    }

    func saveSongs() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(songs) {
            UserDefaults.standard.set(encoded, forKey: "savedSongs")
        }
    }

    func loadSongs() {
        if let savedSongsData = UserDefaults.standard.object(forKey: "savedSongs") as? Data {
            let decoder = JSONDecoder()
            if let savedSongs = try? decoder.decode([Song].self, from: savedSongsData) {
                songs = savedSongs
            }
        }
    }
}

