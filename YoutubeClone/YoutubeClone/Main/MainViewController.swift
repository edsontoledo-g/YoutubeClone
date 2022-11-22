//
//  MainViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit

class MainViewController: BaseViewController {
    var rootPageViewController: RootPageViewController!
    
    @IBOutlet var tabsView: TabsView!
    
    private var options: [String] = ["HOME", "VIDEOS", "PLAYLIST", "CHANNEL", "ABOUT"]
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        tabsView.buildView(options: options)
        tabsView.delegate = self
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
        currentIndex = index
        tabsView.selectedItem = IndexPath(item: index, section: 0)
        
        if let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
            tabsView.updateUnderlineView(xOrigin: currentCell.frame.origin.x, width: currentCell.frame.width)
        }
    }
}

extension MainViewController: TabsViewDelegate {
    func didSelectOption(index: Int) {
        var direction: UIPageViewController.NavigationDirection
        
        if let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
            tabsView.updateUnderlineView(xOrigin: currentCell.frame.origin.x, width: currentCell.frame.width)
        }
        
        if index > currentIndex {
            direction = .forward
        } else {
            direction = .reverse
        }
        currentIndex = index
        
        rootPageViewController.setViewControllers(
            [rootPageViewController.subviewControllers[currentIndex]],
            direction: direction,
            animated: true
        )
    }
}
