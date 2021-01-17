import UIKit

class FilterViewController: UIViewController {
    
    // MARK: - Properties
    let searchBar = UISearchBar()
    
    let separatorLine = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        style()
        layout()
    }
    
}

extension FilterViewController {
    
    func style() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        
        let searchBarTextField = searchBar.value(forKey: "searchField") as! UITextField
        searchBarTextField.layer.borderWidth = 1.5
        searchBarTextField.layer.cornerRadius = 8
        searchBarTextField.layer.borderColor = UIColor.semanticFilterBorder.cgColor
        searchBarTextField.enablesReturnKeyAutomatically = false
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = .lightGray
        
    }
    
    func layout() {
        view.addSubview(searchBar)
        view.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            
            separatorLine.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
}
