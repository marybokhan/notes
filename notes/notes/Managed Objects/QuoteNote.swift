import Foundation
import CoreData

class QuoteNote: NSManagedObject {
    
    @NSManaged var date: Date
    @NSManaged var text: String
    
    func set(text: String) {
        self.text = text
        self.date = Date()
    }
    
    static func new(context: NSManagedObjectContext) -> QuoteNote {
        let newNote = QuoteNote(context: context)
        newNote.text = ""
        newNote.date = Date()
        return newNote
    }
    
    static func createFetchRequest() -> NSFetchRequest<QuoteNote> {
        return NSFetchRequest<QuoteNote>(entityName: "QuoteNote")
    }
}
