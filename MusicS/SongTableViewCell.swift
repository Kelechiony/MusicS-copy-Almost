import UIKit

class SongTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let userNameLabel = UILabel()
    let likeCountLabel = UILabel()
    let commentCountLabel = UILabel()
    let albumArtworkImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(userNameLabel)
        addSubview(likeCountLabel)
        addSubview(commentCountLabel)
        addSubview(albumArtworkImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCountLabel.translatesAutoresizingMaskIntoConstraints = false
        albumArtworkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            albumArtworkImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            albumArtworkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumArtworkImageView.widthAnchor.constraint(equalToConstant: 40),
            albumArtworkImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: albumArtworkImageView.trailingAnchor, constant: 10),
            
            userNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            userNameLabel.leadingAnchor.constraint(equalTo: albumArtworkImageView.trailingAnchor, constant: 10),
            
            likeCountLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            likeCountLabel.leadingAnchor.constraint(equalTo: albumArtworkImageView.trailingAnchor, constant: 10),
            
            commentCountLabel.topAnchor.constraint(equalTo: likeCountLabel.bottomAnchor, constant: 5),
            commentCountLabel.leadingAnchor.constraint(equalTo: albumArtworkImageView.trailingAnchor, constant: 10),
            commentCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

