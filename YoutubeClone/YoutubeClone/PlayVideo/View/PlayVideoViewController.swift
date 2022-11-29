//
//  PlayVideoViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/11/22.
//

import UIKit
import YouTubeiOSPlayerHelper

class PlayVideoViewController: BaseViewController {
    var videoId: String = ""
    var presenter = PlayVideoPresenter()
    var goingToBeCollapsed: ((Bool) -> Void)?
    var isPlayingVideo = false {
        didSet {
            playVideoButton.setImage(UIImage(systemName: isPlayingVideo ? "pause.fill" : "play.fill"), for: .normal)
        }
    }
    
    lazy var collapseVideoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = UIColor(named: "whiteColor")
        button.addTarget(self, action: #selector(collapsedViewButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var topInsetSafeArea: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var progressBar: UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = .red
        progress.trackTintColor = .clear
        progress.progress = 0.0
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }()
    
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet var tableViewVideos: UITableView!
    @IBOutlet var tipView: UIView!
    @IBOutlet var videoTitleLabel: UILabel!
    @IBOutlet var channelTitleLabel: UILabel!
    @IBOutlet var playVideoButton: UIButton!
    @IBOutlet var safeAreaInsetView: UIView!
    
    
    @IBOutlet var playerViewTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        
        configurePlayerView()
        configureTableView()
        configureCloseButton()
        generalConfigure()
        configureTopInsetSafeArea()
        configureProgressBar()
        
        Task {
            await presenter.getVideos(videoId: videoId)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .viewPosition, object: nil)
    }
    
    private func loadDataFromAPI() {
        Task { [weak self] in
            await self?.presenter.getVideos(videoId: videoId)
        }
    }
    
    func generalConfigure() {
        NotificationCenter.default.addObserver(self, selector: #selector(floatingPanelChanged(notification:)), name: .viewPosition, object: nil)
    }
    
    func configurePlayerView() {
        playerView.delegate = self
        
        let playerVars: [AnyHashable: Any] = ["playsinline": 1, "controls": 1, "autohide": 1, "showInfo": 0, "modestbranding": 0]
        playerView.load(withVideoId: videoId, playerVars: playerVars)
    }
    
    func configureTableView() {
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
        
        let nibVideoHeader = UINib(nibName: "\(VideoHeaderCell.self)", bundle: nil)
        tableViewVideos.register(nibVideoHeader, forCellReuseIdentifier: "\(VideoHeaderCell.self)")
        
        let nibVideoFullWidth = UINib(nibName: "\(VideoFullWidthCell.self)", bundle: nil)
        tableViewVideos.register(nibVideoFullWidth, forCellReuseIdentifier: "\(VideoFullWidthCell.self)")
    }
    
    func configureCloseButton() {
        playerView.addSubview(collapseVideoButton)
        
        NSLayoutConstraint.activate([
            collapseVideoButton.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 8.0),
            collapseVideoButton.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 8.0),
            collapseVideoButton.widthAnchor.constraint(equalToConstant: 25.0),
            collapseVideoButton.heightAnchor.constraint(equalToConstant: 25.0)
        ])
    }
    
    func configureTopInsetSafeArea() {
        view.addSubview(topInsetSafeArea)
        
        NSLayoutConstraint.activate([
            topInsetSafeArea.widthAnchor.constraint(equalTo: view.widthAnchor),
            topInsetSafeArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topInsetSafeArea.topAnchor.constraint(equalTo: view.topAnchor),
            topInsetSafeArea.bottomAnchor.constraint(equalTo: playerView.topAnchor)
        ])
    }
    
    func configureProgressBar() {
        tipView.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(equalTo: tipView.widthAnchor),
            progressBar.centerXAnchor.constraint(equalTo: tipView.centerXAnchor),
            progressBar.bottomAnchor.constraint(equalTo: tipView.bottomAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 6.0)
        ])
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        isPlayingVideo ? playerView.pauseVideo() : playerView.playVideo()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func tipViewButtonPressed(_ sender: UIButton) {
        goingToBeCollapsed?(false)
    }
    
    @objc
    func collapsedViewButtonPressed() {
        goingToBeCollapsed?(true)
    }
    
    @objc
    func floatingPanelChanged(notification: Notification) {
        guard let value = notification.object as? [String: String] else {
            return
        }
        
        if value["position"] == "top" {
            tipView.isHidden = true
            playerViewTrailingConstraint.constant = 0.0
            collapseVideoButton.isHidden = false
            safeAreaInsetView.isHidden = true
            view.layoutIfNeeded()
        } else {
            tipView.isHidden = false
            playerViewTrailingConstraint.constant = view.bounds.width * 0.75
            collapseVideoButton.isHidden = true
            safeAreaInsetView.isHidden = false
            view.layoutIfNeeded()
        }
    }
}

extension PlayVideoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.relatedVideosArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.relatedVideosArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.relatedVideosArray[indexPath.section]
        guard let video = item[indexPath.row] as? VideoResponse.Item else {
            fatalError()
        }
        
        if indexPath.section == 0 {
            guard let videoHeaderCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoHeaderCell.self)", for: indexPath) as? VideoHeaderCell else {
                fatalError()
            }
            videoHeaderCell.configure(video: video, channel: presenter.channel)
            
            return videoHeaderCell
        } else {
            guard let videoFullWidthCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoFullWidthCell.self)", for: indexPath) as? VideoFullWidthCell else {
                fatalError()
            }
            videoFullWidthCell.configure(with: video)
            
            return videoFullWidthCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PlayVideoViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .ended:
            isPlayingVideo = false
        case .playing:
            isPlayingVideo = true
        case .paused:
            isPlayingVideo = false
        case .cued:
            isPlayingVideo = false
        default:
            break
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        playerView.duration { duration, error in
            self.progressBar.progress = playTime / Float(duration)
        }
    }
}

extension PlayVideoViewController: PlayVideoViewProtocol {
    func getRelatedVideosFinished() {
        tableViewVideos.reloadData()
    }
}
