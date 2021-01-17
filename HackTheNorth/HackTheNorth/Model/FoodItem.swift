import Foundation
import CoreData


struct FoodItem {
    public var foodName: String?
    public var expirationDate: Date?
    public var dateAdded: Date?
    public var foodImg: String?
    
    func daysUntilExpiration() -> Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: self.expirationDate!).day! + 1
    }
}
