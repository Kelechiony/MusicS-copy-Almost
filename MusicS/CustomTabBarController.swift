import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupMiddleButton()
        setupAppleMusicTab()
    }
    
    func setupTabs() {
        let feedVC = FeedViewController()
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), selectedImage: nil)
        
        let favoritesVC = NowPlayingViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: nil)
        
        viewControllers = [feedVC, favoritesVC]
    }
    
    func setupMiddleButton() {
        let middleButton = UIButton(type: .custom)
        middleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        middleButton.tintColor = .systemBlue
        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
        
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(middleButton)
        
        NSLayoutConstraint.activate([
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -8),
            middleButton.widthAnchor.constraint(equalToConstant: 44),
            middleButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func middleButtonTapped() {
        let postSongVC = PostSongViewController()
        postSongVC.modalPresentationStyle = .overFullScreen
        present(postSongVC, animated: true, completion: nil)
    }
    @objc func loginSuccessful() {
        // Perform any necessary actions after successful login
        // Create an instance of your CustomTabBarController
        let tabBarController = CustomTabBarController()
        // Set it as the root view controller
        UIApplication.shared.windows.first?.rootViewController = tabBarController
    }

    func setupAppleMusicTab() {
        let appleMusicVC = SongSearchViewController() // Replace with your Apple Music search view controller
        appleMusicVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        
        let appleMusicNavigationController = UINavigationController(rootViewController: appleMusicVC)
        viewControllers?.append(appleMusicNavigationController)
    }
}

