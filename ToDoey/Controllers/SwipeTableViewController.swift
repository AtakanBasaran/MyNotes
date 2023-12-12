//
//  SwipeTableViewController.swift
//  ToDoey
//
//  Created by Atakan Başaran on 10.12.2023.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60

    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    

    
    //MARK: - SwipeCellKit Methods

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)         
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        let modifyAction = SwipeAction(style: .destructive, title: "Modify") { action, indexPath in
            self.modifyObject(at: indexPath)
        }
        modifyAction.image = UIImage(systemName: "pencil.circle.fill")
        modifyAction.backgroundColor = .systemBlue
        
        let favoriteAction = SwipeAction(style: .destructive, title: "Favorite") { action, indexPath in
            self.favoriteObject(at: indexPath)
        }
        favoriteAction.backgroundColor = .systemYellow
        favoriteAction.image = UIImage(systemName: "star.fill")

        return [deleteAction, modifyAction, favoriteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .border
        options.expansionStyle = .destructiveAfterFill
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
    
    }
    
    func modifyObject(at indexPath: IndexPath) {
        
    }
    
    func favoriteObject(at indexPath: IndexPath) {
        
    }
    

}
