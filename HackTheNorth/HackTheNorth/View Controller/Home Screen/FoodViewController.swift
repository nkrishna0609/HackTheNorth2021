import UIKit

class FoodViewController: UIViewController {
    
    // MARK: - Properties
    var selectIndex: Int = -1
    var foodCollectionView: UICollectionView!
    let cvLayout = UICollectionViewFlowLayout()
    let reuseIdentifier = "Cell"
    var foodList = [FoodItem]()
    var deleteDelegate: DeleteButtonDelegate!
    
    static var animatedCells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        style()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // If portrait orientation else landscape
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            cvLayout.itemSize = CGSize(width: view.frame.width - 45, height: 110)
        } else {
            cvLayout.itemSize = CGSize(width: view.frame.width/2 - 45, height: 110)
        }
    
        foodCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Style and Layout
extension FoodViewController {
    func style() {
        cvLayout.sectionInset = UIEdgeInsets(top: 2, left: 22.5, bottom: 15, right: 22.5)
        foodCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: cvLayout)
        foodCollectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.translatesAutoresizingMaskIntoConstraints = false
        foodCollectionView.backgroundColor = .systemBackground
    }
    
    func layout() {
        view.addSubview(foodCollectionView)
        
        NSLayoutConstraint.activate([
            foodCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            foodCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UIColletionViewDelegate, UICollectionViewDataSource
extension FoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FoodCollectionViewCell
        
        cell.setFood(foodList[indexPath.item])
        cell.indexPath = indexPath
        
        return cell
    }

    // Add delete and edit contextual buttons
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            // Delete button
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                let ac = UIAlertController(title: "Are you sure you want to delete this food?", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    return
                }))
                ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                    self?.deleteDelegate.deleteTapped(at: (self?.foodList[indexPath.item])!)
                    self?.foodList.remove(at: indexPath.item)
                    collectionView.reloadData()
                }))
                
                self?.present(ac, animated: true)
            }

            return UIMenu(title: "", children: [delete])
        }
    }

}


protocol DeleteButtonDelegate {
    func deleteTapped(at food: FoodItem)
}
