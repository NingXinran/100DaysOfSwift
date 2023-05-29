//
//  ViewController.swift
//  Project1
//
//  Created by Ning, Xinran on 16/5/23.
//

import UIKit

class ViewController: UITableViewController {

  var pictures = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Add title
    title = "Storm Viewer"

    navigationController?.navigationBar.prefersLargeTitles = true

    performSelector(inBackground: #selector(loadImages), with: nil)
  }

  @objc func loadImages() {
    // Load nssl images
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)

    for item in items {
      if item.hasPrefix("nssl") {
        pictures.append(item)
      }
    }
    pictures.sort()

    DispatchQueue.main.async { [weak self] in
      print("Back on main thread")
      self?.tableView.reloadData()
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text=pictures[indexPath.row]
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as?  DetailViewController {
      vc.selectedImage = pictures[indexPath.row]
      vc.selectedTitle = String(format: "Picture %d of %d", indexPath.row+1, pictures.count)
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

