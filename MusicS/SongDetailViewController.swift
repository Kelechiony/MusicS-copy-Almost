import UIKit

class SongDetailViewController: UIViewController {

    var song: Song?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if song is not nil before updating UI
        if let song = song {
            titleLabel.text = song.songTitle // Update to the correct property name representing the song title
            artistLabel.text = song.artistName
            albumLabel.text = song.albumTitle ?? "Unknown Album"
            
            if let url = URL(string: song.albumArtworkURL!) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.artworkImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        } else {
            // Handle case where song is nil
            titleLabel.text = "Song Not Available"
            artistLabel.text = ""
            albumLabel.text = ""
            artworkImageView.image = nil
        }
    }
}

