import UIKit

// Custom colors used accross app
extension UIColor {
    static let appliedBackground = UIColor(red: 148/255, green: 194/255, blue: 61/255, alpha: 1)
    static let appliedText = UIColor(red: 51/255, green: 121/255, blue: 54/255, alpha: 1)
    
    static let phoneScreenBackground = UIColor(red: 241/255, green: 125/255, blue: 53/255, alpha: 1)
    static let phoneScreenText = UIColor(red: 140/255, green: 71/255, blue: 29/255, alpha: 1)
    
    static let onSiteBackground = UIColor(red: 224/255, green: 31/255, blue: 31/255, alpha: 1)
    static let onSiteText = UIColor(red: 110/255, green: 0/255, blue: 0/255, alpha: 1)
    
    static let offerBackground = UIColor(red: 255/255, green: 197/255, blue: 53/255, alpha: 1)
    static let offerText = UIColor(red: 138/255, green: 108/255, blue: 24/255, alpha: 1)
    
    public static var semanticApplied: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .black
            } else {
                /// Return the color for Light Mode
                return .appliedBackground
            }
        }
    }()
    
    public static var semanticPhoneScreen: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .black
            } else {
                /// Return the color for Light Mode
                return .phoneScreenBackground
            }
        }
    }()
    
    public static var semanticOnSite: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .black
            } else {
                /// Return the color for Light Mode
                return .onSiteBackground
            }
        }
    }()
    
    public static var semanticOffer: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .black
            } else {
                /// Return the color for Light Mode
                return .offerBackground
            }
        }
    }()
        
    public static var semanticAppliedText: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .appliedBackground
            } else {
                /// Return the color for Light Mode
                return .appliedText
            }
        }
    }()
    
    public static var semanticPhoneScreenText: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .phoneScreenBackground
            } else {
                /// Return the color for Light Mode
                return .phoneScreenText
            }
        }
    }()
    
    public static var semanticOnSiteText: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .onSiteBackground
            } else {
                /// Return the color for Light Mode
                return .onSiteText
            }
        }
    }()
    
    public static var semanticOfferText: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .offerBackground
            } else {
                /// Return the color for Light Mode
                return .offerText
            }
        }
    }()
        
    public static var semanticAppliedBorder: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .appliedBackground
            } else {
                /// Return the color for Light Mode
                return UIColor(white: 0, alpha: 0)
            }
        }
    }()
    
    public static var semanticPhoneScreenBorder: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .phoneScreenBackground
            } else {
                /// Return the color for Light Mode
                return .clear
            }
        }
    }()
    
    public static var semanticOnSiteBorder: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .onSiteBackground
            } else {
                /// Return the color for Light Mode
                return .clear
            }
        }
    }()
    
    public static var semanticOfferBorder: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .offerBackground
            } else {
                /// Return the color for Light Mode
                return .clear
            }
        }
    }()
    
    public static var semanticDateAdded: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return .lightGray
            } else {
                /// Return the color for Light Mode
                return .white
            }
        }
    }()
    
    public static var semanticFilterText: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
            } else {
                /// Return the color for Light Mode
                return .systemGray
            }
        }
    }()
    
    public static var semanticFilterBorder: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
            } else {
                /// Return the color for Light Mode
                return .lightGray
            }
        }
    }()
    
    public static var semanticSettingsBackground: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return UIColor(red: 0, green: 0, blue: 1/255, alpha: 1)
            } else {
                /// Return the color for Light Mode
                return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            }
        }
    }()
    
    public static var semanticSettingsTableview: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return UIColor(red: 23/255, green: 24/255, blue: 25/255, alpha: 1)
            } else {
                /// Return the color for Light Mode
                return .white
            }
        }
    }()
}

// Helper function for setting the logo image
extension UIImageView {
    func setLogoImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                DispatchQueue.main.async {
                    UIView.transition(with: self,
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: { self.image = UIImage(systemName: "questionmark.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 1)) },
                    completion: nil)
                    self.tintColor = .black
                    self.tag = 0
                }
                return
            }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.tag = 0
                UIView.transition(with: self,
                duration: 0.15,
                options: .transitionCrossDissolve,
                animations: { self.image = image },
                completion: nil)
            }
        }
    }
}

