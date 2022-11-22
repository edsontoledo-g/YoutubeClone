//
//  RootPageViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit

protocol RootPageViewControllerDelegate: AnyObject {
    func currentPage(_ index: Int)
}

class RootPageViewController: UIPageViewController {
    enum ScrollDirection: Int {
        case stop = 0
        case right = 1
        case left = -1
    }
    
    var subviewControllers = [UIViewController]()
    var currentIndex = 0
    weak var rootPageDelegate: RootPageViewControllerDelegate?
    var startOffset: CGFloat = 0.0
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        rootPageDelegate?.currentPage(0)
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        subviewControllers = [
            HomeViewController(),
            VideosViewController(),
            PlaylistsViewController(),
            ChannelsViewController(),
            AboutViewController()
        ]
        
        subviewControllers.enumerated().forEach { $0.element.view.tag = $0.offset }
        setViewControllers([subviewControllers[0]], direction: .forward, animated: true)
    }
}

// MARK: - UIPageViewControllerDelegate
extension RootPageViewController: UIPageViewControllerDelegate {
    
}

// MARK: - UIPageViewControllerDataSource
extension RootPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = subviewControllers.firstIndex(of: viewController) ?? 0
        
        if index <= 0 {
            return nil
        }
        
        return subviewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = subviewControllers.firstIndex(of: viewController) ?? 0
        
        if index >= subviewControllers.count - 1 {
            return nil
        }
        
        return subviewControllers[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subviewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let index = pageViewController.viewControllers?.first?.view.tag {
            currentIndex = index
            rootPageDelegate?.currentPage(index)
        }
    }
}
