import UIKit

class MainViewController: UIViewController {
    
    let signUpButton = UIButton()
    let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupUI()
    }
    
    func setupUI() {
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.setTitleColor(.red, for: .normal)
        signUpButton.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.blue, for: .normal)
        loginButton.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [signUpButton, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func showSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func showLogin() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

