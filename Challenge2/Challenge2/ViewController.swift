//
//  ViewController.swift
//  Challenge2
//
//  Created by Ning, Xinran on 24/5/23.
//

import UIKit

class ViewController: UITableViewController {

  var items = [String]()  // the list of items to add to

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "My Shopping List"
    items.append("This is your first item. Tap on '+' to add more.")

    // Add item buttonn
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptToAdd))
    let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
    navigationItem.rightBarButtonItems = [shareButton, addButton]

  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }

  @objc func promptToAdd() {
    let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
    ac.addTextField()

    let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
      guard let item = ac?.textFields?[0].text else { return }
      self?.submit(item: item)
    }
    ac.addAction(addAction)
    present(ac, animated: true)
  }

  func submit(item: String){
    items.insert(item, at: 0)
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }

  @objc func clearList(){
    items.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }

  @objc func shareAction() {
    let itemsMessage = items.joined(separator: "\n")
    let vc = UIActivityViewController(activityItems: [itemsMessage], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
}
