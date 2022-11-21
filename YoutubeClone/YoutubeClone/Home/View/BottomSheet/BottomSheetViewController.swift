//
//  BottomSheetViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/11/22.
//

import UIKit

class BottomSheetViewController: UIViewController {
    @IBOutlet var overlayView: UIView!
    @IBOutlet var optionsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressOverlay(_:)))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        optionsContainer.animateBottomSheet(show: true)
    }
    
    @objc
    func didPressOverlay(_ sender: UITapGestureRecognizer) {
        optionsContainer.animateBottomSheet(show: false) {
            self.dismiss(animated: false)
        }
    }
}
