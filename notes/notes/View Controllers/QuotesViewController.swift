import UIKit
import CoreData

class QuotesViewController: UIViewController {
    
    // MARK: - Properties
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var notes = [QuoteNote]()
    let context: NSManagedObjectContext
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let fetchRequest = QuoteNote.createFetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            self.notes = try self.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        self.setupUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private logic
    
    private func setupUI() {
        self.title = "Quotes"
        self.view.backgroundColor = AppConstants.Color.palePurple
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNote))
        
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    @objc private func addNote() {
        let newNote = QuoteNote.new(context: self.context)
        self.notes.append(newNote)
        self.edit(note: newNote)
    }
    
    private func edit(note: QuoteNote) {
        let noteViewController = NoteEditViewController()
        noteViewController.textView.text = note.text
        noteViewController.completionHandler = { newText in
            note.set(text: newText)
            self.notes.sort(by: {$0.date > $1.date })
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(noteViewController, animated: true)
    }
}

extension QuotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.notes[indexPath.row]
        self.edit(note: note)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension QuotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = self.notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = self.notes.remove(at: indexPath.row)
        self.context.delete(note)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
