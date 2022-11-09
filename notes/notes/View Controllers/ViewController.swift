import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: - Type declarations
    
    private enum Constants {
        static let buttonCornerRadius = CGFloat(42.5)
    }
    
    // MARK: - Properties
    
    let persistentContainer: NSPersistentContainer
    
    let todayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.setTitle("⭐️ Today", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    let shoppingListButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.setTitle("🛍️ Shopping List", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    let ideasButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.setTitle("💡 Ideas", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    let quotesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.setTitle("✏️ Quotes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    // MARK: - Init
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // todo: show progress indicator
        self.persistentContainer.loadPersistentStores { _, optionalError in
            if let loadPersistentStoreError = optionalError {
                print(loadPersistentStoreError.localizedDescription)
            }
            
            // todo: remove progress indicator
            
            self.setupUI()
        }
    }
    
    private func setupUI() {
        let screenWidth = UIScreen.main.bounds.width
        let edgeToButtonOffset = CGFloat(20)
        let buttonToButtonOffset = CGFloat(10)
        let buttonWidth = (screenWidth - (edgeToButtonOffset * 2) - buttonToButtonOffset) / 2
        
        self.navigationItem.title = "Notes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.todayButton)
        self.view.addSubview(self.shoppingListButton)
        self.view.addSubview(self.ideasButton)
        self.view.addSubview(self.quotesButton)
        
        
        // Constraints: Buttons
        self.todayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.todayButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: edgeToButtonOffset),
            self.todayButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: edgeToButtonOffset),
            self.todayButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            self.todayButton.heightAnchor.constraint(equalTo: self.todayButton.widthAnchor)
        ])
        
        self.shoppingListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.shoppingListButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: edgeToButtonOffset),
            self.shoppingListButton.leftAnchor.constraint(equalTo: self.todayButton.rightAnchor, constant: buttonToButtonOffset),
            self.shoppingListButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            self.shoppingListButton.heightAnchor.constraint(equalTo: self.shoppingListButton.widthAnchor)
        ])
        
        self.ideasButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.ideasButton.topAnchor.constraint(equalTo: self.todayButton.bottomAnchor, constant: buttonToButtonOffset),
            self.ideasButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: edgeToButtonOffset),
            self.ideasButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            self.ideasButton.heightAnchor.constraint(equalTo: self.ideasButton.widthAnchor)
        ])
        
        self.quotesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.quotesButton.topAnchor.constraint(equalTo: self.shoppingListButton.bottomAnchor, constant: buttonToButtonOffset),
            self.quotesButton.leftAnchor.constraint(equalTo: self.ideasButton.rightAnchor, constant: buttonToButtonOffset),
            self.quotesButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            self.quotesButton.heightAnchor.constraint(equalTo: self.quotesButton.widthAnchor)
        ])
        
        
        // Buttons logic
        self.todayButton.addTarget(self, action: #selector(self.didTapTodayButton), for: .touchUpInside)
        self.shoppingListButton.addTarget(self, action: #selector(self.didTapShoppingListButton), for: .touchUpInside)
        self.ideasButton.addTarget(self, action: #selector(self.didTapIdeasButton), for: .touchUpInside)
        self.quotesButton.addTarget(self, action: #selector(self.didTapQuotesButton), for: .touchUpInside)
        
    }

    
    // MARK: Functions
    
    @objc func didTapTodayButton() {
        let todayViewController = TodayViewController(context: self.persistentContainer.viewContext)
        self.navigationController?.pushViewController(todayViewController, animated: true)
    }
    
    @objc func didTapShoppingListButton() {
        let shoppingListViewController = ShoppingListViewController()
        self.navigationController?.pushViewController(shoppingListViewController, animated: true)
    }
    
    @objc func didTapIdeasButton() {
        let ideasViewController = IdeasViewController()
        self.navigationController?.pushViewController(ideasViewController, animated: true)
    }
    
    @objc func didTapQuotesButton() {
        let quotesViewController = QuotesViewController()
        self.navigationController?.pushViewController(quotesViewController, animated: true)
    }

}

