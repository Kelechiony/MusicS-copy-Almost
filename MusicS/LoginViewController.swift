
import UIKit

class LoginViewController: UIViewController {
    
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupUI()
    }
    
    func setupUI() {
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .black
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField, loginButton])
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
    
    @objc func login() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        guard let url = URL(string: "https://script.google.com/macros/s/AKfycbzS_pCSuyPAxDBH-e83tWFAIu783nzAcnOFgU-Ed9xfu8ZzK9zyyTo2z0ovC8HKmDufpQ/exec") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], json["status"] as? String == "success" {
                        DispatchQueue.main.async {
                            // Navigate to feed
                            let feedVC = FeedViewController()
                            self.present(feedVC, animated: true, completion: nil)
                        }
                    } else {
                        print("Login failed")
                    }
                } catch let error {
                    print("Error parsing response: \(error.localizedDescription)")
                }
            } else {
                print("Error logging in")
            }
        }.resume()
    }
}
