//
//  MusicSearchViewController.swift
//  Music Search App
//
//  Created by Allan Pagdanganan on 21/06/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import Foundation

class MusicSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var musicSearchBar: UISearchBar!
    @IBOutlet weak var musicTableView: UITableView!
    
    let datafetcher = DataFetcher()
    var tracks = [Track]()
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicTableView.isHidden = true
        musicTableView.rowHeight = UITableView.automaticDimension
        musicTableView.estimatedRowHeight = 120.0
    }
    
    // MARK: - Table View Delegate and Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"musicTableViewCell") as! MusicTableViewCell
        
        let track = tracks[indexPath.row]
        cell.trackNameLbl.text = track.trackName
        cell.artistNameLbl.text = track.artistName
        cell.albumNameLbl.text = track.albumName
        cell.playPauseBtn.imageView?.image = UIImage(named: "play-icon")
        
        let task = URLSession.shared.dataTask(with: track.trackImageURL, completionHandler: { (data, response, error) in
            guard let data = data,
                let image = UIImage(data: data) else {
                    return
            }
            DispatchQueue.main.async {
                cell.trackImageView.image = image
            }
        })
        task.resume()
        
        return cell
    }
    
    // MARK: - Search Bar Delegate
    
    @IBAction func searchMusic(_ sender: Any) {
        musicSearchBar.endEditing(true)
        
        guard let searchText = musicSearchBar.text else {
            return
        }
        fetchItems(with: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else {
            return
        }
        fetchItems(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        musicSearchBar.endEditing(true)
        
        guard let searchText = searchBar.text else {
            return
        }
        fetchItems(with: searchText)
    }
    
    // - Data Parse and Display
    
    func fetchItems(with term: String) {
        let queries: [String: String] = [
            "term":"\(String(term))",
            "media":"music",
            "entity":"song",
        ]
        
        datafetcher.fetchItems(matching: queries) { (track) in
            guard let track = track else {
                return
            }
            self.updateUI(with: track)
        }
    }
    
    func updateUI(with tracks: [Track]) {
        DispatchQueue.main.async {
            if(tracks.count == 0) {
                self.musicTableView.isHidden = true
            } else {
                self.tracks = tracks
                self.musicTableView.isHidden = false
                self.musicTableView.reloadData()
            }
        }
    }
}

