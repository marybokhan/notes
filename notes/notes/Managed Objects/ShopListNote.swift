import Foundation
import CoreData

class ShopListNote: NSManagedObject {
    
    @NSManaged var date: Date
    @NSManaged var text: String
    
    func set(text: String) {
        self.text = text
        self.date = Date()
    }
    
    static func createFetchRequest() -> NSFetchRequest<ShopListNote> {
        return NSFetchRequest<ShopListNote>(entityName: "ShopListNote")
    }
}
