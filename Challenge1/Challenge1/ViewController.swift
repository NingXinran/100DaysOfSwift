//
//  ViewController.swift
//  Challenge1
//
//  Created by Ning, Xinran on 22/5/23.
//

import UIKit

class ViewController: UITableViewController {

  var pictures = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Country Flags"
    navigationController?.navigationBar.prefersLargeTitles = true

    // Import images
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)

    for item in items {
      if item.contains("@2x") {
        pictures.append(item)
      }
    }


  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }

  // Populate cells
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.imageView?.image = UIImage(named: pictures[indexPath.row])
    cell.textLabel?.text = pictures[indexPath.row].split(separator: "@")[0].uppercased()
    cell.textLabel?.adjustsFontSizeToFitWidth = true
    return cell
  }

  // What happens when its clicked
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // load the view controller in the storyboard as a DetailViewController
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      // If this was successful, present the image
      let currentCell = tableView.cellForRow(at: indexPath)
      vc.selectedImage = currentCell?.imageView?.image
      vc.selected = currentCell?.textLabel?.text
      navigationController?.pushViewController(vc, animated: true)
    }
  }


}

