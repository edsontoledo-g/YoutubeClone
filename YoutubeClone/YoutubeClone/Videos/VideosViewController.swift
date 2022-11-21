//
//  VideosViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit

class VideosViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var presenter = VideosPresenter()
    var videoList: [VideoResponse.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        presenter.delegate = self
        Task {
            await presenter.getVideos()
        }
    }
    
    func configureTableView() {
        let nibVideos = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        tableView.register(nibVideos, forCellReuseIdentifier: "\(VideoCell.self)")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videoList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
            fatalError()
        }
        
        cell.configure(with: video)
        cell.didPressMoreButton = { [weak self] in
            self?.configureBottomSheet()
        }
        
        return cell
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

extension VideosViewController: VideosViewProtocol {
    func getVideos(videoList: [VideoResponse.Item]) {
        self.videoList = videoList
        self.tableView.reloadData()
    }
}
