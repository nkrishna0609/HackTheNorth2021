import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate, DidUploadDelegate {

    // MARK: - Properties
    var uid: String!
    var username = ""
    
    let headerVC = HeaderViewController()
    let filterVC = FilterViewController()
    let foodVC = FoodViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addHeaderVC()
        addFilterVC()
        addFoodVC()
        let db = Firestore.firestore()
        let ref = db.collection("users").document(uid)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!["uid"]
                self.username = dataDescription as! String
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                print(self.username)
                APIManager.shared.getAllItems(username: self.username) { (items) in
                    print(items.count)
                    for item in items {
                        self.foodVC.foodList.append(FoodItem(foodName: item.product_name,
                                                             expirationDate: dateFormatterGet.date(from: item.exp_date),
                                                             dateAdded: dateFormatterGet.date(from: item.add_date),
                                                             foodImg: item.preview_img_url))
                    }
                    DispatchQueue.main.async {
                        self.foodVC.foodCollectionView.reloadData()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func didUpload() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        APIManager.shared.getAllItems(username: self.username) { (items) in
            print(items.count)
            self.foodVC.foodList.removeAll()
            for item in items {
                self.foodVC.foodList.append(FoodItem(foodName: item.product_name,
                                                     expirationDate: dateFormatterGet.date(from: item.exp_date),
                                                     dateAdded: dateFormatterGet.date(from: item.add_date),
                                                     foodImg: item.preview_img_url))
            }
            DispatchQueue.main.async {
                self.foodVC.foodCollectionView.reloadData()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd"
//        // Fetch companies from core data and sort by date
//        do {
//            foodVC.foodList = [FoodItem(foodName: "Wonder Bread", expirationDate: dateFormatterGet.date(from: "2021-01-23"), dateAdded: Date()),
//                                FoodItem(foodName: "Milk", expirationDate: dateFormatterGet.date(from: "2021-01-18"), dateAdded: Date()),
//                                FoodItem(foodName: "Broccoli", expirationDate: dateFormatterGet.date(from: "2021-01-12"), dateAdded: Date()),
//                                FoodItem(foodName: "Eggs", expirationDate: dateFormatterGet.date(from: "2021-01-21"), dateAdded: Date())]
//            foodVC.foodList.sort(by: { $0.daysUntilExpiration() < $1.daysUntilExpiration() })
//            foodVC.foodCollectionView.reloadData()
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }
    
    // Add header VC as child
    func addHeaderVC() {
        addChild(headerVC)
        view.addSubview(headerVC.view)
        headerVC.didMove(toParent: self)
        setHeaderVCConstraints()
        headerVC.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    func setHeaderVCConstraints() {
        headerVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerVC.view.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // Add filter VC as chidl
    func addFilterVC() {
        addChild(filterVC)
        view.addSubview(filterVC.view)
        filterVC.didMove(toParent: self)
        setFilterVCConstraints()
        filterVC.searchBar.delegate = self
    }
    
    func setFilterVCConstraints() {
        filterVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterVC.view.topAnchor.constraint(equalTo: headerVC.view.bottomAnchor),
            filterVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filterVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            filterVC.view.heightAnchor.constraint(equalToConstant: 96)
        ])
    }
    
    // Add jobs VC as child
    func addFoodVC() {
        addChild(foodVC)
        view.addSubview(foodVC.view)
        foodVC.didMove(toParent: self)
        setJobsVCConstraints()
        foodVC.deleteDelegate = self
    }
    
    func setJobsVCConstraints() {
        foodVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            foodVC.view.topAnchor.constraint(equalTo: filterVC.view.bottomAnchor),
            foodVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            foodVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            foodVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Add Job Delegate
extension HomeViewController{
    
    // Function called when the top right Add Button is tapped
    @objc func addTapped(){
        let vc = AddItemViewController()
        vc.modalPresentationStyle = .fullScreen
        if filterVC.searchBar.isFirstResponder {
            filterVC.searchBar.resignFirstResponder()
            filterVC.searchBar.text = nil
        }
        vc.username = self.username
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - Search Bar Delegate
extension HomeViewController: UISearchBarDelegate {
    
    // When user taps search button in keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // Search for results as user types
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        foodVC.foodList = foodVC.foodList.filter {
            $0.foodName!.lowercased().hasPrefix(searchText.lowercased())
        }
        
        foodVC.foodCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}


// MARK: - Delete or Edit Button Delegate
extension HomeViewController: DeleteButtonDelegate {
    
    // User deleted a job
    func deleteTapped(at food: FoodItem) {
        // Remove locally
        for i in 0..<foodVC.foodList.count {
            if foodVC.foodList[i].dateAdded == food.dateAdded {
                foodVC.foodList.remove(at: i)
                break
            }
        }
    }
    
}
