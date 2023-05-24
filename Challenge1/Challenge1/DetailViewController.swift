//
//  DetailViewController.swift
//  Challenge1
//
//  Created by Ning, Xinran on 22/5/23.
//

import UIKit

class DetailViewController: UIViewController {

  // Create a property that contains an image, which is populated by the storybooard
  @IBOutlet var imageView: UIImageView!

  var selectedImage: UIImage?
  var selected: String?

  override func viewDidLoad() {
        super.viewDidLoad()

        title = selected
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
          imageView.image = imageToLoad
        }

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }

  @objc func shareImage() {
    let vc = UIActivityViewController(activityItems: [selected!, selectedImage!], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)

  }

  // Add share button
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
