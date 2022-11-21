//
//  HomeViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    var presenter = HomePresenter()
    private var objectArray = [[Any]]()
    private var sectionTitleArray = [String]()
    
    @IBOutlet var tableViewHome: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        configureTableView()
        
        Task {
            await presenter.getHomeObjects()
        }
    }
    
    func configureTableView() {
        let nibChannel = UINib(nibName: "\(ChannelCell.self)", bundle: nil)
        tableViewHome.register(nibChannel, forCellReuseIdentifier: "\(ChannelCell.self)")
        
        let nibVideo = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        tableViewHome.register(nibVideo, forCellReuseIdentifier: "\(VideoCell.self)")
        
        let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        tableViewHome.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorStyle = .none
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = objectArray[indexPath.section]
        
        if let channel = item as? [ChannelResponse.Item] {
            guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCell.self)", for: indexPath) as? ChannelCell else {
                fatalError("Couldn't dequeue reusable cell with identifier: \(ChannelCell.self)")
            }
            channelCell.configure(with: channel[indexPath.row])
            
            return channelCell
        } else if let playlistItems = item as? [PlaylistItemResponse.Item] {
            guard let playlistItemCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
                fatalError("Couldn't dequeue reusable cell with identifier: \(VideoCell.self)")
            }
            playlistItemCell.configure(with: playlistItems[indexPath.row])
            playlistItemCell.didPressMoreButton = { [weak self] in
                self?.configureBottomSheet()
            }
            
            return playlistItemCell
        } else if let videos = item as? [VideoResponse.Item] {
            guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
                fatalError("Couldn't dequeue reusable cell with identifier: \(VideoCell.self)")
            }
            videoCell.configure(with: videos[indexPath.row])
            videoCell.didPressMoreButton = { [weak self] in
                self?.configureBottomSheet()
            }
            
            return videoCell
        } else if let playlists = item as? [PlaylistResponse.Item] {
            guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
                fatalError("Couldn't dequeue reusable cell with identifier: \(PlaylistCell.self)")
            }
            playlistCell.configure(with: playlists[indexPath.row])
            playlistCell.didPressMoreButton = { [weak self] in
                self?.configureBottomSheet()
            }
            
            return playlistCell
        }
        
        fatalError("")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleArray[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureBottomSheet() {
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
}

extension HomeViewController: HomePresenterDelegate {
    func getData(array: [[Any]], sectionTitleArray: [String]) {
        objectArray = array
        self.sectionTitleArray = sectionTitleArray
        tableViewHome.reloadData()
    }
}
