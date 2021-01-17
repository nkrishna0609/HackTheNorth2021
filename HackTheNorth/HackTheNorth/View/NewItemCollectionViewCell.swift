import UIKit

class NewItemCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let image = UIImageView()
    let uploadButton = UIButton(type: .system)
    var delegate: UploadDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitle(title: String) {
        titleLabel.text = title
    }
    
    func setImage(image: UIImage?) {
        self.image.image = image
    }
    
    func style() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .appliedBackground
        titleLabel.numberOfLines = 0
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemGray
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = 10
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        uploadButton.backgroundColor = .appliedBackground
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.layer.cornerRadius = 10
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)

    }
    
    @objc func uploadTapped() {
        delegate?.uploadTapped()
    }
    
    func layout() {
        addSubview(titleLabel)
        addSubview(image)
        addSubview(uploadButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 75),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 500),
            
            image.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            image.heightAnchor.constraint(equalToConstant: 350),
        
            uploadButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            uploadButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            uploadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            uploadButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

protocol UploadDelegate {
    func uploadTapped()
}
