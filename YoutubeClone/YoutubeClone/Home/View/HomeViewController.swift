//
//  HomeViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit
import FloatingPanel

class HomeViewController: UIViewController {
    var presenter = HomePresenter()
    private var objectArray = [[Any]]()
    private var sectionTitleArray = [String]()
    var fpc: FloatingPanelController!
    
    @IBOutlet var tableViewHome: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        configureTableView()
        configureFloatingPanel()
        
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
        tableViewHome.contentInset = UIEdgeInsets(top: -32.0, left: 0.0, bottom: -80.0, right: 0.0)
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
        
        let item = objectArray[indexPath.section]
        var videoId: String = ""
        
        if let playlistItems = item as? [PlaylistItemResponse.Item] {
            videoId = playlistItems[indexPath.row].contentDetails?.videoId ?? ""
        } else if let videos = item as? [VideoResponse.Item] {
            videoId = videos[indexPath.row].id ?? ""
        } else {
            return
        }
        
        presentViewPanel(videoId: videoId)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        
        if velocity < -5 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > 5 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
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

extension HomeViewController: FloatingPanelControllerDelegate {
    func presentViewPanel(videoId: String) {
        let contentVC = PlayVideoViewController()
        contentVC.videoId = videoId
        fpc.set(contentViewController: contentVC)
        present(fpc, animated: true)
    }
    
    func configureFloatingPanel() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.layout = MyFloatingPanelLayout()
        fpc.surfaceView.contentPadding = UIEdgeInsets(top: -56.0, left: 0.0, bottom: -56.0, right: 0.0)
    }
    
    class MyFloatingPanelLayout: FloatingPanelLayout {
        let position: FloatingPanelPosition = .bottom
        let initialState: FloatingPanelState = .full
        let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 56.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
