import UIKit
import CoreData

class ShoppingListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppConstants.Color.paleGreen
        self.title = "Shopping List"
    }
}
