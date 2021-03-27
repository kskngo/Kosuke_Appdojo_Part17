//
//  TableViewController.swift
//  Kosuke_Appdojo_Part13
//
//  Created by Kosuke Nagao on 2021/03/12.
//

import UIKit

class TableViewController: UITableViewController {
    private var indexForEditing: Int?

    private enum Segue: String {
        case add = "Add"
        case edit = "Edit"
    }

    private var fruitsItems = [
        FruitsItem(name: "りんご", isChecked: false),
        FruitsItem(name: "みかん", isChecked: true),
        FruitsItem(name: "バナナ", isChecked: false),
        FruitsItem(name: "パイナップル", isChecked: true)
    ]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruitsItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        cell.configure(fruitsItem: fruitsItems[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fruitsItems[indexPath.row].isChecked.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fruitsItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction private func exitCancel(segue: UIStoryboardSegue) {
    }

    @IBAction private func exitAdd(segue: UIStoryboardSegue) {
    }

    @IBAction private func exitEdit(segue: UIStoryboardSegue) {
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        indexForEditing = indexPath.row
        performSegue(withIdentifier: "Edit", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController else { return }
        guard let addItemViewController =
                navigationController.topViewController as? AddItemViewController else { return }
        guard let identifier = segue.identifier else { return }
        guard let segue = Segue(rawValue: identifier) else { return }

        switch segue {
        case .edit:
            guard let indexForEditing = indexForEditing else { return }

            addItemViewController.mode = .edit(
                target: fruitsItems[indexForEditing],
                completion: { [weak self] fruitsItem in
                    guard let fruitsItem = fruitsItem else { return }

                    self?.fruitsItems[indexForEditing] = fruitsItem
                    self?.tableView.reloadRows(at: [IndexPath(row: indexForEditing, section: 0)], with: .automatic)
                    self?.indexForEditing = nil
                }
            )
        case .add:
            addItemViewController.mode = .add(completion: { [weak self] fruitsItem in
                guard let fruitsItem = fruitsItem else { return }

                self?.fruitsItems.append(fruitsItem)
                self?.tableView.reloadData()
            })
        }
    }
}

struct FruitsItem {
    var name: String
    var isChecked: Bool
}
