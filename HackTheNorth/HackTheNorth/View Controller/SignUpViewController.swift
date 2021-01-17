import UIKit
import FirebaseFirestore
import Firebase

class SignUpViewController: UIViewController {
    
    let titleName = UILabel()
    var nameField = UITextField()
    var passField = UITextField()
    var phNumberField = UITextField()
    let signUpBtn = UIButton(type: .system)
    let mountain = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
        titleName.text = "Sign Up"
        titleName.textColor = .appliedBackground
        titleName.font = UIFont.boldSystemFont(ofSize: 56)
        
        nameField = self.setupTextField(placeHolder: "Email")
        passField = self.setupTextField(placeHolder: "Password")
        passField.autocorrectionType = .no
        passField.autocorrectionType = .no
        passField.isSecureTextEntry = true
        
        phNumberField = self.setupTextField(placeHolder: "Phone Number")
        phNumberField.keyboardType = .numberPad
        
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpBtn.backgroundColor = .appliedBackground
        signUpBtn.layer.cornerRadius = 10
        signUpBtn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        mountain.translatesAutoresizingMaskIntoConstraints = false
        mountain.image = UIImage(named: "grocery")
        mountain.contentMode = .scaleAspectFit
    }
    
    func layout() {
        view.addSubview(titleName)
        view.addSubview(nameField)
        view.addSubview(passField)
        view.addSubview(phNumberField)
        view.addSubview(signUpBtn)
        view.addSubview(mountain)
        
        NSLayoutConstraint.activate([
            titleName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            titleName.widthAnchor.constraint(equalToConstant: 400),
            
            nameField.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 40),
            nameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            nameField.heightAnchor.constraint(equalToConstant: 60),
            
            passField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            passField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            passField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            passField.heightAnchor.constraint(equalToConstant: 60),
            
            phNumberField.topAnchor.constraint(equalTo: passField.bottomAnchor, constant: 20),
            phNumberField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            phNumberField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            phNumberField.heightAnchor.constraint(equalToConstant: 60),
            
            signUpBtn.topAnchor.constraint(equalTo: phNumberField.bottomAnchor, constant: 20),
            signUpBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            signUpBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            signUpBtn.heightAnchor.constraint(equalToConstant: 60),
            
            
            mountain.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
            mountain.widthAnchor.constraint(equalToConstant: 450),
            mountain.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    
    @objc func signUpTapped() {
        // Handle submit
        let email = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phNumber = (phNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        // Check if email and password were formatted correctly
        if email != "" && password != "" && phNumber != "" {
            if password!.count >= 6 {
                // Firebase authentication - create user
                Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
                    if error != nil {
                        self.showError(error!.localizedDescription)
                    } else {
                        let db = Firestore.firestore()
                        db.collection("users").document(result!.user.uid).setData(["uid": phNumber])
                        self.successHandler()
                    }
                }
            } else {
                showError("Password must be greater than 6 characters")
            }
        } else {
            showError("Please fill all fields!")
        }
    }
    
    func showError(_ err: String) {
        //Show error if user makes a mistake
        let ac = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        return
    }
    
    func successHandler() {
            // Show login screen if user has successfully signed up
            let ac = UIAlertController(title: "Success", message: "Account successfully created, please login", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(ac, animated: true)
            return
        }
}
