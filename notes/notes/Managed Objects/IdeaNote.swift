import Foundation
import CoreData

class IdeaNote: NSManagedObject {
    
    @NSManaged var date: Date
    @NSManaged var text: String
    
    func set(text: String) {
        self.text = text
        self.date = Date()
    }
    
    static func new(context: NSManagedObjectContext) -> IdeaNote {
        let newNote = IdeaNote(context: context)
        newNote.text = ""
        newNote.date = Date()
        return newNote
    }
    
    static func createFetchRequest() -> NSFetchRequest<IdeaNote> {
        return NSFetchRequest<IdeaNote>(entityName: "IdeaNote")
    }
}
