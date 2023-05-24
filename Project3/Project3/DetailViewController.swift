//
//  DetailViewController.swift
//  Project1
//
//  Created by Ning, Xinran on 16/5/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: String?
    var selectedTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load title
        title = selectedTitle

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        navigationItem.largeTitleDisplayMode = .never

        // Load the image whose name is specified in selectedImage
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

  @objc func shareTapped(){
    guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
      print("No image found.")
      return
    }
    let vc = UIActivityViewController(activityItems: [image, selectedImage ?? ""], applicationActivities: [])
    vc.popoverPresentationController?.sourceItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
