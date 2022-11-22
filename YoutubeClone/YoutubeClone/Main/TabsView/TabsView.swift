//
//  TabsView.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import UIKit

protocol TabsViewDelegate: AnyObject {
    func didSelectOption(index: Int)
}

class TabsView: UIView {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(UINib(nibName: "\(OptionCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(OptionCell.self)")
        
        return collection
    }()
    
    var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "whiteColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var options: [String] = []
    weak var delegate: TabsViewDelegate?
    
    var selectedItem = IndexPath(item: 0, section: 0)
    var widthConstraint = NSLayoutConstraint()
    var leadingConstraint = NSLayoutConstraint()
    
    func buildView(options: [String]) {
        self.options = options
        collectionView.reloadData()
        configureCollectionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.configureUnderlineView()
        }
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureUnderlineView() {
        guard let currentCell = collectionView.cellForItem(at: selectedItem) else {
            return
        }
        
        addSubview(underlineView)
        
        leadingConstraint = underlineView.leadingAnchor.constraint(equalTo: currentCell.leadingAnchor)
        widthConstraint = underlineView.widthAnchor.constraint(equalToConstant: currentCell.frame.width)
        
        NSLayoutConstraint.activate([
            underlineView.heightAnchor.constraint(equalToConstant: 2.0),
            leadingConstraint,
            widthConstraint,
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func tabWidth(index: Int) -> CGFloat {
        let numberOfCharacters = options[index].count
        let width = CGFloat(numberOfCharacters) * 12.0
        let leftInset: CGFloat = 16.0
        
        return width + leftInset
    }
    
    func updateUnderlineView(xOrigin: CGFloat, width: CGFloat) {
        widthConstraint.constant = width
        leadingConstraint.constant = xOrigin
        layoutIfNeeded()
    }
}

extension TabsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(OptionCell.self)", for: indexPath) as? OptionCell else {
            fatalError()
        }
        
        if indexPath.row == 0 {
            cell.highlightTitle(UIColor(named: "whiteColor")!)
        } else {
            cell.isSelected = (selectedItem.item == indexPath.row)
        }
        
        cell.configure(with: options[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath
        delegate?.didSelectOption(index: indexPath.item)
    }
}

extension TabsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = tabWidth(index: indexPath.item)
        
        return CGSize(width: width, height: frame.height)
    }
}
