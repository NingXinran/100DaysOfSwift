//
//  ViewController.swift
//  Project4
//
//  Created by Ning, Xinran on 22/5/23.
//

import UIKit
import WebKit

class ViewController: UITableViewController {  // Parent class first, then protocols

  // Our websites
  var websites = ["hackingwithswift.com", "youtube.com", "viki.com"]


  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Mini Browser"
    navigationController?.navigationBar.prefersLargeTitles = true

  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return websites.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
    cell.textLabel?.text = websites[indexPath.row]
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let wv = WebViewController()
    wv.website = websites[indexPath.row]
    navigationController?.pushViewController(wv, animated: true)
  }
}

