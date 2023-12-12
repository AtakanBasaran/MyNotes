//
//  ToDoViewController.swift
//  ToDoey
//
//  Created by Atakan Başaran on 9.12.2023.
//

import UIKit
import RealmSwift

class ToDoViewController: SwipeTableViewController {
    
    var items: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        overrideUserInterfaceStyle = .light //light mode only for the app
    }
    
    override func viewWillAppear(_ animated: Bool) { //This method is safer to add color to the navigation bar since we can run viewDidLoad func before navigationController is setup
        super.viewWillAppear(animated)
        
        if let selectedCategory = selectedCategory {
            
            title = selectedCategory.name
            
            let redNo = CGFloat(selectedCategory.redNo)
            let greenNo = CGFloat(selectedCategory.greenNo)
            let blueNo = CGFloat(selectedCategory.blueNo)
            let color = UIColor(red: redNo, green: greenNo, blue: blueNo, alpha: 1)
            
            searchBar.barTintColor = color
            navigationController?.navigationBar.barTintColor = color
            navigationController?.navigationBar.backgroundColor = color
            navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = color
        }
    }
    
    //MARK: - Add Item
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) { action in
            
            if textField.text != "" {
                if let selectedCategory = self.selectedCategory {
                    do {
                        try self.realm.write { //All of the saving action also saved in realm
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.date = Date()
                            selectedCategory.items.append(newItem) //to make relation between them, we added the new item to our category items list
                            //   self.itemArray.append(newItem) -> Result type is self uptading, no need to apend
                        }
                    } catch {
                        print("Save error, \(error)")
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true)
    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        var content = cell.defaultContentConfiguration()
        if let item = items?[indexPath.row] {
            
            content.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            //colorNo is used to make selectedCategory.color lighter
            let colorNo = CGFloat(indexPath.row) / CGFloat(items!.count)
            let redNo = CGFloat(selectedCategory!.redNo)
            let greenNo = CGFloat(selectedCategory!.greenNo)
            let blueNo = CGFloat(selectedCategory!.blueNo)
            
            let color = UIColor(red: redNo + colorNo - 0.1, green: greenNo + colorNo - 0.1, blue: blueNo + colorNo - 0.1, alpha: 1)
            cell.backgroundColor = color
            if item.favorite == true {
                content.image = UIImage(systemName: "star.fill")
            }
        } else {
            content.text = "No Items Added"
        }
        cell.contentConfiguration = content

        return cell
    }
    
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write { //updating realm
                    item.done = !item.done
                    tableView.reloadData()
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Realm Data
    
    func loadData() {
        items = selectedCategory?.items.sorted(byKeyPath: "favorite", ascending: false) //We used relationship between category and item
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Delete error, \(error)")
            }
        }
    }
    
    override func modifyObject(at indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            
            var textField = UITextField()
            let alertController = UIAlertController(title: "Modify Item", message: "", preferredStyle: .alert)
            
            alertController.addTextField { alertTextField in
                alertTextField.text = item.title
                textField = alertTextField
            }
            let actionAdd = UIAlertAction(title: "Modify", style: .default) { action in
                if textField.text != "" { 
                    do {
                        try self.realm.write {
                            // Update the properties of the existing object
                            item.title = textField.text!
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Update error \(error)")
                    }
                    
                }
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                self.tableView.reloadData()
            }
            
            alertController.addAction(actionAdd)
            alertController.addAction(actionCancel)
            present(alertController, animated: true)
        }
    }
    
    override func favoriteObject(at indexPath: IndexPath) {
        
        if let items = items?[indexPath.row] {
            do {
                try self.realm.write {
                    items.favorite = !items.favorite //favorite or unfavorite
                    self.tableView.reloadData()
                }
            } catch {
                print("Favorite item update error, \(error)")
            }
        }
    }
}

    
    
    //MARK: - Search Bar
    
extension ToDoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            items = items?.filter( "title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
            
        }
    }
    
}
    
        


