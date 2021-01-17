import UIKit

class FoodCollectionViewCell: UICollectionViewCell, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    let imageMainView = UIView()
    let foodImageView = UIImageView()
    let foodNameLabel = UILabel()
    let expirationDateLabel = UILabel()
    let foodDetailsStackView = UIStackView()
    let dateAdded = UILabel()
    
    var foodItem: FoodItem?
    var indexPath: IndexPath!

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2.5
        style()
        layout()
    }
    
    // Set colors for all UI
    func updateColors(for food: FoodItem) {
        let days = food.daysUntilExpiration()
 
        if days > 5 {
            backgroundColor = .semanticApplied
            expirationDateLabel.textColor = .semanticAppliedText
            foodImageView.layer.borderColor = UIColor.semanticAppliedBorder.cgColor
            self.layer.borderColor = UIColor.semanticAppliedBorder.cgColor
        }
        else if days > 3 {
            backgroundColor = .semanticOffer
            expirationDateLabel.textColor = .semanticOfferText
            foodImageView.layer.borderColor = UIColor.semanticOfferBorder.cgColor
            self.layer.borderColor = UIColor.semanticOfferBorder.cgColor
        }
        else if days >= 1 {
            backgroundColor = .semanticPhoneScreen
            expirationDateLabel.textColor = .semanticPhoneScreenText
            foodImageView.layer.borderColor = UIColor.semanticPhoneScreenBorder.cgColor
            self.layer.borderColor = UIColor.semanticPhoneScreenBorder.cgColor
        }
        else {
            backgroundColor = .semanticOnSite
            expirationDateLabel.textColor = .semanticOnSiteText
            foodImageView.layer.borderColor = UIColor.semanticOnSiteBorder.cgColor
            self.layer.borderColor = UIColor.semanticOnSiteBorder.cgColor
        }
    }
    
    // If user changed to dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateColors(for: foodItem!)
        
    }
    
    // Function called from parent VC
    func setFood(_ food: FoodItem) {
        self.foodItem = food
        
        foodImageView.setLogoImage(from: food.foodImg!)

        foodNameLabel.text = food.foodName!
        
        let days = food.daysUntilExpiration()
        
        if days > 0 && days != 1 {
            expirationDateLabel.text = "Expires in \(days) days"
        }
        else if days == 1 {
            expirationDateLabel.text = "Expires tomorrow"
        }
        else if days < 0 && days != -1 {
            expirationDateLabel.text = "Expired \(days * -1) days ago"
        }
        else if days == -1 {
            expirationDateLabel.text = "Expired yesterday"
        }
        else {
            expirationDateLabel.text = "Expires today"
        }
        
        updateColors(for: food)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateAdded.text = "added on \(dateFormatter.string(from: food.dateAdded!))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Style and Layout

extension FoodCollectionViewCell {
    
    func style() {
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.backgroundColor = .white
        foodImageView.layer.cornerRadius = 10
        foodImageView.clipsToBounds = true
        foodImageView.layer.borderWidth = 2.5
        
        imageMainView.addSubview(foodImageView)

        foodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        foodNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        foodNameLabel.textColor = .white
        
        expirationDateLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)

        foodDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        foodDetailsStackView.axis = .vertical
        foodDetailsStackView.spacing = 5
        
        foodDetailsStackView.addArrangedSubview(foodNameLabel)
        foodDetailsStackView.addArrangedSubview(expirationDateLabel)
        
        dateAdded.translatesAutoresizingMaskIntoConstraints = false
        dateAdded.font = UIFont.italicSystemFont(ofSize: 12)
        dateAdded.textColor = .semanticDateAdded
    }

    
    func layout() {
        addSubview(imageMainView)
        addSubview(foodDetailsStackView)
        addSubview(dateAdded)
        
        NSLayoutConstraint.activate([
            foodImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            foodImageView.heightAnchor.constraint(equalToConstant: 65),
            foodImageView.widthAnchor.constraint(equalToConstant: 65),
            
            
            foodDetailsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            foodDetailsStackView.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 16),
            foodDetailsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            dateAdded.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            dateAdded.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        foodDetailsStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        imageMainView.frame = CGRect(x: 16, y: 25, width: 65, height: 65)
        imageMainView.clipsToBounds = false
        imageMainView.layer.shadowColor = UIColor.black.cgColor
        imageMainView.layer.shadowOpacity = 0.5
        imageMainView.layer.shadowOffset = CGSize.zero
        imageMainView.layer.shadowRadius = 2
        imageMainView.layer.shadowPath = UIBezierPath(roundedRect: imageMainView.bounds, cornerRadius: 10).cgPath
        
    }
    
    // Favorite button tapped
    @objc func favoriteTapped(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

    }
}

// MARK: - Favorite Button Tapped Protocol

protocol FavoriteButtonDelegate {
    
    func favoriteButtonTapped(at indexPath: IndexPath)
    func favoriteButtonUnTapped(at indexPath: IndexPath)
    
}
