import UIKit
import MusicKit

class PostSongViewController: UIViewController {
    
    var songTitleTextField: UITextField!
    var artistNameTextField: UITextField!
    var albumArtworkURLTextField: UITextField!
    var songURLTextField: UITextField!
    var searchResults = [Song]()
    var searchButton: UIButton! // Ensure the searchButton is declared here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupUI()
    }
    
    func setupUI() {
        // Initialize text fields
        songTitleTextField = createTextField(placeholder: "Song Title")
        artistNameTextField = createTextField(placeholder: "Artist Name")
        albumArtworkURLTextField = createTextField(placeholder: "Album Artwork URL")
        songURLTextField = createTextField(placeholder: "Song URL")
        
        // Initialize search button
        searchButton = UIButton(type: .system)
        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        
        // Add subviews to the view
        view.addSubview(songTitleTextField)
        view.addSubview(artistNameTextField)
        view.addSubview(albumArtworkURLTextField)
        view.addSubview(songURLTextField)
        view.addSubview(searchButton)
        
        // Set constraints for UI elements
        setConstraints()
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func setConstraints() {
        // Use Auto Layout to set up constraints for UI elements
        let margin = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            songTitleTextField.topAnchor.constraint(equalTo: margin.topAnchor, constant: 20),
            songTitleTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            songTitleTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            artistNameTextField.topAnchor.constraint(equalTo: songTitleTextField.bottomAnchor, constant: 20),
            artistNameTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            artistNameTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            albumArtworkURLTextField.topAnchor.constraint(equalTo: artistNameTextField.bottomAnchor, constant: 20),
            albumArtworkURLTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            albumArtworkURLTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            songURLTextField.topAnchor.constraint(equalTo: albumArtworkURLTextField.bottomAnchor, constant: 20),
            songURLTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            songURLTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            searchButton.topAnchor.constraint(equalTo: songURLTextField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    @objc func signUpSuccessful() {
        // Perform any necessary actions after successful sign-up
        // Dismiss the current view controller
        dismiss(animated: true) {
            // Present the PostSongViewController after dismissal
            let postSongVC = PostSongViewController()
            postSongVC.modalPresentationStyle = .fullScreen
            self.present(postSongVC, animated: true, completion: nil)
        }
    }

    
    @objc func searchButtonTapped() {
        guard let query = songTitleTextField.text, !query.isEmpty else {
            return
        }
        
        MusicManager.shared.searchSongs(with: query) { [weak self] songs in
            self?.searchResults = songs
            DispatchQueue.main.async {
                if let tableView = self?.view.viewWithTag(100) as? UITableView {
                    tableView.reloadData()
                } else if let collectionView = self?.view.viewWithTag(100) as? UICollectionView {
                    collectionView.reloadData()
                } else {
                    print("Error: View with tag 100 is not a table view or collection view.")
                }
            }
        }
    }
}

