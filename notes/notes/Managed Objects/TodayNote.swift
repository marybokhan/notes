import Foundation
import CoreData

class TodayNote: NSManagedObject {
    
    @NSManaged var date: Date
    @NSManaged var text: String
    
    func set(text: String) {
        self.text = text
        self.date = Date()
    }
    
    static func createFetchRequest() -> NSFetchRequest<TodayNote> {
        return NSFetchRequest<TodayNote>(entityName: "TodayNote")
    }
    
}
