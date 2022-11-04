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
    var subviewControllers = [UIViewController]()
    var currentIndex = 0 {
        didSet {
            setViewControllers([subviewControllers[currentIndex]], direction: .forward, animated: true)
        }
    }
    weak var rootPageDelegate: RootPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
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
