import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol DidUploadDelegate {
    func didUpload()
}

class AddItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pageCollectionView: UICollectionView!
    var nextButton: UIButton!
    var barcodeImage: UIImage?
    var expirationImage: UIImage?
    var barcode = ""
    var expirationURL = ""
    var username: String!
    var delegate: DidUploadDelegate?
    lazy var vision = Vision.vision()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        style()
        layout()
        pageCollectionView.register(NewItemCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func style() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        pageCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .white
        
        nextButton = UIButton(type: .system)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(UIImage(systemName: "arrowtriangle.right.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        nextButton.tintColor = .appliedBackground
        
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    func layout() {
        view.addSubview(pageCollectionView)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            pageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            pageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageCollectionView.heightAnchor.constraint(equalToConstant: 750),
            
            nextButton.topAnchor.constraint(equalTo: pageCollectionView.bottomAnchor),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func nextTapped() {
        for cell in pageCollectionView.visibleCells {
            let indexPath = pageCollectionView.indexPath(for: cell)
            if indexPath?.item == 0 {
                pageCollectionView.isPagingEnabled = false
                pageCollectionView.scrollToItem(at: [0, 1], at: .centeredHorizontally, animated: true)
                pageCollectionView.isPagingEnabled = true
                nextButton.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
            }
            else {
                if let expirationImage = expirationImage, let _ = barcodeImage {
                    let md = StorageMetadata()
                    md.contentType = "image/png"
                    
                    guard let compressedExpiration: Data = expirationImage.jpegData(compressionQuality: 0.5) else { return }
                    
                    let fileName = UUID().uuidString
                    let storage = Storage.storage(url: "gs://htn_expiry_date_bucket").reference().child(fileName + ".png")
                    storage.putData(compressedExpiration, metadata: md) { (metadata, error) in
                        if error == nil {
                            storage.downloadURL(completion: { (myurl, error) in
                                self.expirationURL = "https://storage.googleapis.com/htn_expiry_date_bucket/" + fileName + ".png"
                                print(self.expirationURL)
                                APIManager.shared.uploadItem(username: self.username, srcImg: self.expirationURL, barcodeText: self.barcode) { (res) in
                                    if res == true {
                                        self.delegate?.didUpload()
                                    }
                                }
                        
                            })
                        }else{
                            print("error \(String(describing: error))")
                        }
                    }
                    dismiss(animated: true)
                } else {
                    print("Missing one or more images")
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewItemCollectionViewCell
        cell.delegate = self
        cell.updateTitle(title: "Upload Barcode")
        if let image = barcodeImage {
            cell.setImage(image: image)
        }
        if indexPath.item == 1 {
            cell.updateTitle(title: "Upload Expiration Date")
            cell.setImage(image: nil)
            if let image = expirationImage {
                cell.setImage(image: image)
            }
        }
        return cell
    }
    
    internal func checkForCodeInImage(image: UIImage) {
        let detector = vision.barcodeDetector(options: VisionBarcodeDetectorOptions(formats: .all))
        let vImage = VisionImage(image: image)
        var text = ""
        detector.detect(in: vImage) { features, error in
            guard error == nil, let barcodes = features, barcodes.isEmpty == false else {
                text = "rip"
                return
            }

            for barcode in barcodes {

                guard let rawValue = barcode.rawValue else {
                    continue
                }

                let corners = barcode.cornerPoints
                let displayValue = barcode.displayValue

                print("Corners: \(String(describing: corners))")
                print("Found: \(String(describing: displayValue))")

                text.append(rawValue)
                text.append("\n\n")
                
                self.barcode = "\(String(describing: displayValue!))"
            }
        }
    }
    
}

extension AddItemViewController: UploadDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func uploadTapped() {
        let ac = UIAlertController(title: "Source", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: { [weak self] _ in
            self?.showPicker(fromCamera: false)
        }))
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            self?.showPicker(fromCamera: true)
        }))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func showPicker(fromCamera: Bool) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if fromCamera {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        for cell in pageCollectionView.visibleCells {
            let indexPath = pageCollectionView.indexPath(for: cell)
            if indexPath?.item == 0 {
                self.barcodeImage = image
                self.checkForCodeInImage(image: image)
            }
            else {
                self.expirationImage = image
            }
        }
        
        pageCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
        
    }
    
}
