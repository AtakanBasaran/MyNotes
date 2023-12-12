//
//  ViewController.swift
//  ToDoey
//
//  Created by Atakan Başaran on 9.12.2023.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm() //since we try initialize when our app starts, we can use ! here
    var categoryArray: Results<Category>? //! did not use it since it can be nil

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.separatorStyle = .none
        overrideUserInterfaceStyle = .light
        tableView.backgroundColor = UIColor(red: 0.09, green: 0.63, blue: 0.52, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let color = UIColor(red: 0.09, green: 0.63, blue: 0.52, alpha: 1.00)
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.backgroundColor = color
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = color
    }

    //MARK: - Add Category
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) { action in
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                //            self.categoryArray.append(newCategory) //since result is auto-updating container type in Realm returned from object queries, there is no need to append
                //Random number for random colors
                newCategory.redNo = Float.random(in: 0...1)
                newCategory.greenNo = Float.random(in: 0...1)
                newCategory.blueNo = Float.random(in: 0...1)
                
                self.saveData(with: newCategory)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true)
        
    }
    
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) //By using super we get a function from our superclass, the function returns cell and we add other features we want by modifying the cell we got
        var content = cell.defaultContentConfiguration()
        
        //if categoryArray do not exist, create a default color
        let redNo = CGFloat(categoryArray?[indexPath.row].redNo ?? 0.2)
        let greenNo = CGFloat(categoryArray?[indexPath.row].greenNo ?? 0.3)
        let blueNo = CGFloat(categoryArray?[indexPath.row].blueNo ?? 0.4)
        let randomColor = UIColor(red: redNo, green: greenNo, blue: blueNo, alpha: 1)
        
        cell.backgroundColor = randomColor //Random color for every cell
        //Since I used default values for categoryArray with ??, I did not need to add above code in the if let
        if let category = categoryArray?[indexPath.row] {
            content.text = category.name
            if category.favorite == true {
                content.image = UIImage(systemName: "star.fill")
            } 
        } else {
            content.text = "No Category Added Yet"
        }
        
        cell.contentConfiguration = content
        return cell
        
        //The difference between super.func and override func, we can use super to get superclass function and its body and we can add some features or we can just override it so that we dont get the body of the function in the superClass if we dont need to superclass functionality
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goItems", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow { //optional indexPath
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }    
    
    //MARK: - Realm Data
    
    func saveData(with category: Category) {
        do {
            try realm.write { //Commiting changes
                realm.add(category)
            }
        } catch {
            print("Save error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {        
        categoryArray = realm.objects(Category.self).sorted(byKeyPath: "favorite", ascending: false) //Sorted to show favorite categories at the top of the table view
        tableView.reloadData()
    }
    
    //We delete objects by overriding the super class function
    override func updateModel(at indexPath: IndexPath) {
        
        if let category = self.categoryArray?[indexPath.row] {
           do {
               try self.realm.write {
                   self.realm.delete(category)
               }
           } catch {
               print("Delete Error, \(error)")
           }
       }
    }
    
    override func modifyObject(at indexPath: IndexPath) {
        
        if let category = self.categoryArray?[indexPath.row] {
            
            var textField = UITextField()
            let alertController = UIAlertController(title: "Modify Category", message: "", preferredStyle: .alert)
            
            alertController.addTextField { alertTextField in
                alertTextField.text = category.name
                textField = alertTextField
            }
            let actionAdd = UIAlertAction(title: "Modify", style: .default) { action in
                if textField.text != "" {
                    do {
                        try self.realm.write {
                            // Update the properties of the existing object
                            category.name = textField.text!
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Name update error, \(error)")
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
        
        if let category = categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    category.favorite = !category.favorite //favorite or unfavorite
                    self.tableView.reloadData()
                }
            } catch {
                print("Favorite update error, \(error)")
            }
            
        }
    }
   
}


