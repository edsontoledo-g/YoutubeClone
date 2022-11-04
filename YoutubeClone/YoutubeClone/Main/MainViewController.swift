//
//  MainViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit

class MainViewController: UIViewController {
    var rootPageViewController: RootPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RootPageViewController {
            rootPageViewController = destination
            rootPageViewController.rootPageDelegate = self
        }
    }
}

extension MainViewController: RootPageViewControllerDelegate {
    func currentPage(_ index: Int) {
        
    }
}
