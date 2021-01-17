import UIKit

class HeaderViewController: UIViewController {
    
    // MARK: - Properties
    let timerImage = UIImageView()
    let titleLabel = UILabel()
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        style()
        layout()
    }
}

extension HeaderViewController {
    func style() {
        timerImage.translatesAutoresizingMaskIntoConstraints = false
        timerImage.image = UIImage(systemName: "timer", withConfiguration: UIImage.SymbolConfiguration(pointSize: 26))
        timerImage.tintColor = .appliedBackground
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        titleLabel.text = "ShelfLife"
        titleLabel.textColor = .appliedBackground
        titleLabel.sizeToFit()
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32)), for: .normal)
        addButton.tintColor = .appliedBackground
    }
    
    func layout() {
        view.addSubview(timerImage)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            timerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            timerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            titleLabel.leadingAnchor.constraint(equalTo: timerImage.trailingAnchor, constant: 4),
            
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}
