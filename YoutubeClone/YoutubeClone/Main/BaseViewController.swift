//
//  BaseViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import UIKit

enum LoadingViewState {
    case show
    case hide
}

protocol BaseViewProtocol {
    func loadingView(_ state: LoadingViewState)
    func showError(_ error: String, completionHandler: (() -> Void)?)
}

class BaseViewController: UIViewController {
    var loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func configureNavigationBar() {
        let shareButton = createNavigationBarButton(selector: #selector(shareButtonPressed), image: UIImage(named: "cast"), inset: 8.0)
        let searchButton = createNavigationBarButton(selector: #selector(searchButtonPressed), image: UIImage(named: "magnifying"), inset: 8.0)
        let moreButton = createNavigationBarButton(selector: #selector(moreButtonPressed), image: UIImage(named: "dots"), inset: 8.0)
        
        let stackView = UIStackView(arrangedSubviews: [shareButton, searchButton, moreButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: 120.0)
        ])
        
        let barButtonItem = UIBarButtonItem(customView: stackView)
        barButtonItem.tintColor = .clear
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func createNavigationBarButton(selector: Selector, image: UIImage?, inset: CGFloat) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(named: "whiteColor")
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        return button
    }
    
    @objc
    func shareButtonPressed() {
        
    }
    
    @objc
    func searchButtonPressed() {
        
    }
    
    @objc
    func moreButtonPressed() {
        
    }
    
    private func showLoading() {
        view.addSubview(loadingIndicator)
        
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
    }
    
    private func hideLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
}

extension BaseViewController: BaseViewProtocol {
    func showError(_ error: String, completionHandler: (() -> Void)? = nil) {
        let ac = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        ac.addAction(UIAlertAction(title: "Try again!", style: .default, handler: { _ in
            completionHandler?()
        }))
        
        self.present(ac, animated: true)
    }
    
    func loadingView(_ state: LoadingViewState) {
        switch state {
        case .show:
            showLoading()
        case .hide:
            hideLoading()
        }
    }
}
