import UIKit
import CoreData

class TodayViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var notes = [TodayNote]()
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let fetchRequest = TodayNote.createFetchRequest()
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
    
    
    
    private func setupUI() {
        self.title = "Today"
        self.view.backgroundColor = AppConstants.Color.paleYellow
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = .clear
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
    
    @objc func addNote() {
        let newNote = TodayNote(context: self.context) // создание новой заметки
        self.notes.append(newNote)
        self.edit(note: newNote)
    }
    
    private func edit(note: TodayNote) {
        let noteEditViewController = NoteEditViewController()
        noteEditViewController.textView.text = note.text
        noteEditViewController.completionHandler = { newText in
            note.set(text: newText)
            self.notes.sort(by: { $0.date > $1.date })
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(noteEditViewController, animated: true)
    }
}

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todayNote = self.notes[indexPath.row]
        self.edit(note: todayNote)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todayNote = self.notes[indexPath.row]
        cell.textLabel?.text = todayNote.text
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = self.notes.remove(at: indexPath.row)
        self.context.delete(note)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
