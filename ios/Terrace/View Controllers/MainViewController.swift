//
//  ViewController.swift
//  imagear
//
//  Created by Avery Lamp on 1/9/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    class func instantiate() -> ViewController? {
//        let storyboard = UIStoryboard(name: String(describing: ViewController.self),
//                                      bundle: nil)
//        guard let mainVC = storyboard.instant
//        return mainVC
        return nil
    }
}

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(MAECVWrapper.openCVVersionString())

    }

    @IBAction func clickedLibraryButton(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate  = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)

    }

}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

    }

}
