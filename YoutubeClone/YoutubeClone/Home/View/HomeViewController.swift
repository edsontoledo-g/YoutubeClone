//
//  HomeViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    var presenter = HomePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        
        Task {
            await presenter.getHomeObjects()
        }
    }
}

extension HomeViewController: HomePresenterDelegate {
    func getData(array: [[Any]]) {
        print(array)
    }
}
