import UIKit

class SignUpViewController: UIViewController {
    
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let emailTextField = UITextField()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupUI()
    }
    
    func setupUI() {
        firstNameTextField.placeholder = "First Name"
        lastNameTextField.placeholder = "Last Name"
        emailTextField.placeholder = "Email"
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = .black
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func signUp() {
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        let parameters: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "username": username,
            "password": password
        ]
        
        print("Sending parameters: \(parameters)") // Debugging
        
        guard let url = URL(string: "https://script.google.com/macros/s/AKfycbwf-sxXTpeREQbyADpWfjF96OYdR-5DffPDCPb8_lWFNb0SN-Gr8AsYyfUo4kSEwh_nDA/exec") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("Error creating JSON body: \(error.localizedDescription)")
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Response JSON: \(json)") // Debugging
                        if json["status"] as? String == "success" {
                            DispatchQueue.main.async {
                                print("Sign up successful!")
                                // Navigate to main tab bar controller
                                let tabBarController = UITabBarController()
                                let feedVC = FeedViewController()
                                feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), tag: 0)
                                let searchVC = SongSearchViewController()
                                searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
                                let nowPlayingVC = NowPlayingViewController()
                                nowPlayingVC.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(systemName: "music.note"), tag: 2)
                                
                                tabBarController.viewControllers = [feedVC, searchVC, nowPlayingVC]
                                self.navigationController?.pushViewController(tabBarController, animated: true)
                            }
                        } else {
                            print("Sign up failed: \(json["message"] ?? "Unknown error")")
                        }
                    }
                } catch let error {
                    print("Error parsing response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

