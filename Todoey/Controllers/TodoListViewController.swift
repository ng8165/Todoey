//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    var items: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            navigationItem.title = selectedCategory?.name
            loadItems()
        }
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
                                    
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
                cell.backgroundColor = color
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
                cell.textLabel?.textColor = cell.tintColor
            }
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = items?[indexPath.row] {

            do {
                try realm.write {
                    data.done = !data.done
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        
        var textField = UITextField()
        alert.addTextField { field in
            textField = field
            field.placeholder = "Create new item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let selectedCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item(title: textField.text ?? "", done: false)
                        selectedCategory.items.append(item)
                    }
                } catch {
                    print(error)
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - SwipeTableViewController Methods
    
    override func updateModel(at indexPath: IndexPath) {
        if let deleteItem = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deleteItem)
                }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - SearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
