import UIKit
import MediaPlayer
import MusicKit

class SongSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI Elements
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Songs, Albums, Artists"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private var topResults: [MusicCatalogSearchable] = []
    private var songs: [MusicKit.Song] = []
    private var albums: [MusicKit.Album] = []
    private var isFetching = false
    private var currentQuery: String = ""
    private var currentOffset = 0
    private let limit = 20 // Number of results to fetch per request
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkAppleMusicAuthorization()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TopResultCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SongCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
    }
    
    // MARK: - Apple Music Authorization
    private func checkAppleMusicAuthorization() {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("Apple Music is authorized")
        case .restricted, .denied:
            print("Apple Music access restricted or denied")
        case .notDetermined:
            requestAppleMusicAuthorization()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    private func requestAppleMusicAuthorization() {
        MPMediaLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.checkAppleMusicAuthorization() // Recheck after authorization request
            }
        }
    }
    
    // MARK: - Song Search
    private func searchSongs(with query: String) {
        guard !isFetching else { return }
        isFetching = true
        
        Task {
            do {
                var request = MusicCatalogSearchRequest(term: query, types: [MusicKit.Song.self, MusicKit.Album.self])
                request.limit = limit
                request.offset = currentOffset
                
                let response = try await request.response()
                
                // Update results based on the response
                self.topResults.append(contentsOf: response.topResults.compactMap { $0 as? MusicCatalogSearchable })
                self.songs.append(contentsOf: response.songs)
                self.albums.append(contentsOf: response.albums)
                
                self.currentOffset += self.limit
                self.isFetching = false
                self.tableView.reloadData()
                
            } catch {
                print("Failed to search songs: \(error.localizedDescription)")
                isFetching = false
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return topResults.count
        case 1:
            return songs.count
        case 2:
            return albums.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopResultCell", for: indexPath)
            let topResult = topResults[indexPath.row]
            if let song = topResult as? MusicKit.Song {
                cell.textLabel?.text = song.title
                cell.textLabel?.textColor = .white
                cell.backgroundColor = .black
                // Load artwork if available
                if let artworkURL = song.artwork?.url(width: 60, height: 60) {
                    loadArtwork(from: artworkURL, into: cell.imageView)
                }
            } else if let album = topResult as? MusicKit.Album {
                cell.textLabel?.text = album.title
                cell.textLabel?.textColor = .white
                cell.backgroundColor = .black
                // Load artwork if available
                if let artworkURL = album.artwork?.url(width: 60, height: 60) {
                    loadArtwork(from: artworkURL, into: cell.imageView)
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
            let song = songs[indexPath.row]
            cell.textLabel?.text = "\(song.title) by \(song.artistName)"
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .black
            // Load artwork if available
            if let artworkURL = song.artwork?.url(width: 60, height: 60) {
                loadArtwork(from: artworkURL, into: cell.imageView)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
            let album = albums[indexPath.row]
            cell.textLabel?.text = "\(album.title) by \(album.artistName)"
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .black
            // Load artwork if available
            if let artworkURL = album.artwork?.url(width: 60, height: 60) {
                loadArtwork(from: artworkURL, into: cell.imageView)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Top Results"
        case 1:
            return "Songs"
        case 2:
            return "Albums"
        default:
            return nil
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            currentQuery = query
            currentOffset = 0
            topResults.removeAll()
            songs.removeAll()
            albums.removeAll()
            tableView.reloadData()
            searchSongs(with: query)
            searchBar.resignFirstResponder() // Hide the keyboard
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == albums.count - 1 && !isFetching {
            searchSongs(with: currentQuery)
        }
    }
    
    // MARK: - Artwork Loading
    private func loadArtwork(from url: URL, into imageView: UIImageView?) {
        guard let imageView = imageView else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }
}

