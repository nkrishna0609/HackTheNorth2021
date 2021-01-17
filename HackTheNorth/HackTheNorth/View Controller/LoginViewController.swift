import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let titleName = UILabel()
    var nameField = UITextField()
    var passField = UITextField()
    let loginBtn = UIButton(type: .system)
    let signUpBtn = UIButton(type: .system)
    let mountain = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }
    
    func setupTextField(placeHolder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeHolder
        textField.layer.cornerRadius = 10

        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 10
        textField.layer.shadowOffset = CGSize(width: 0, height: 10)
        textField.backgroundColor = .white
        
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }
    
    func style() {
        titleName.translatesAutoresizingMaskIntoConstraints = false
        titleName.text = "ShelfLife"
        titleName.textColor = .appliedBackground
        titleName.font = UIFont.boldSystemFont(ofSize: 56)
            
        nameField = self.setupTextField(placeHolder: "Email")
        passField = self.setupTextField(placeHolder: "Password")
        passField.autocorrectionType = .no
        passField.autocorrectionType = .no
        passField.isSecureTextEntry = true
        
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.setTitle("Sign In", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginBtn.backgroundColor = .appliedBackground
        loginBtn.layer.cornerRadius = 10
        loginBtn.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.setTitle("Don't have an account? Sign Up", for: .normal)
        signUpBtn.setTitleColor(.systemGray, for: .normal)
        signUpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signUpBtn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        mountain.translatesAutoresizingMaskIntoConstraints = false
        mountain.image = UIImage(named: "grocery")
        mountain.contentMode = .scaleAspectFit
    }
    
    func layout() {
        view.addSubview(titleName)
        view.addSubview(nameField)
        view.addSubview(passField)
        view.addSubview(loginBtn)
        view.addSubview(signUpBtn)
        view.addSubview(mountain)
        
        NSLayoutConstraint.activate([
            titleName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            titleName.widthAnchor.constraint(equalToConstant: 400),
            
            nameField.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 90),
            nameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            nameField.heightAnchor.constraint(equalToConstant: 60),
            
            passField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            passField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            passField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            passField.heightAnchor.constraint(equalToConstant: 60),
        
            loginBtn.topAnchor.constraint(equalTo: passField.bottomAnchor, constant: 20),
            loginBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            loginBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            loginBtn.heightAnchor.constraint(equalToConstant: 60),
            
            signUpBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 4),
            signUpBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mountain.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
            mountain.widthAnchor.constraint(equalToConstant: 450),
            mountain.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    
    @objc func loginTapped() {
        // Handle sign in
        guard let username = nameField.text else { return }
        guard let password = passField.text else { return }
        
        //Firebase authentication
        Auth.auth().signIn(withEmail: username, password: password, completion: { (result, error) in
            if error != nil {
                // Handle incorrect input
                let ac = UIAlertController(title: "Invalid Email or Password", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try Again", style: .default))
                self.present(ac, animated: true)
            } else {
                // Handle sucessful sign in
                let vc = HomeViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.uid = result!.user.uid
                self.present(vc, animated: true)
            }
        })
    }
    
    @objc func signUpTapped() {
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
