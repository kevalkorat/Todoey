//
//  ViewController.swift
//  Todoey
//
//  Created by Keval Korat on 5/14/21.
//  Copyright © 2021 Keval Korat. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeKitViewController {
    
    var items: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    var category: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = category?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let currentItem = items?[indexPath.row] {
            cell.textLabel?.text = currentItem.title
            if let colour = UIColor(hexString: category!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.tintColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.accessoryType = currentItem.isDone == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no items added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let currentItem = items?[indexPath.row] {
            do {
                try realm.write {
                    currentItem.isDone = !(currentItem.isDone)
                }
            } catch {
                print("error updating the data")
                
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        //create alert
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        //create action
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what happens when user presses ok button
            
            if let currentCategory = self.category {
                
                do {
                    try self.realm.write {
                        let item = Item()
                        print(item.dateCreated)
                        
                        item.title = textField.text!
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("error saving the data, \(error.localizedDescription)")
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add an item here"
            textField = alertTextField
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems() {
        
        items = category?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    
    override func deleteCells(at indexPath: IndexPath) {
        if let itemForDeletion = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch  {
                print("error deleting the item, \(error)")
                
            }
        }
    }
    
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        loadItems()
        
        
        searchBar.resignFirstResponder()
        
    }
}

