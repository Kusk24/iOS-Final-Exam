//
//  DetailViewController.swift
//  PFE_6612054
//
//  Created by Win Yu Maung on 02/10/2024.
//

import UIKit
import AVKit
import Kingfisher

class DetailViewController: UIViewController {
    var TheMovie: Movie?
    @IBOutlet weak var widescreen: UIImageView!
    @IBOutlet weak var Title_en: UILabel!
    @IBOutlet weak var Genre: UILabel!
    @IBOutlet weak var ReleaseDate: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var Synopsis: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Title_en.text = TheMovie?.title_en ?? "Unknown Title"
        Genre.text = TheMovie?.genre ?? "Unknown Genre"
        ReleaseDate.text = TheMovie?.release_date ?? "Unknown Release Date"
        Synopsis.text = TheMovie?.synopsis_en ?? "Unknown Synopsis"
        
        if let duration = TheMovie?.duration {
            Duration.text = "\(duration) min"
        }

        // Setting up widescreen image using Kingfisher
        if let widescreenURLString = TheMovie?.widescreen_url, let url = URL(string: widescreenURLString) {
            widescreen.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            widescreen.image = UIImage(named: "placeholder")
        }

        // Adding tap gesture to play video when the widescreen image is clicked
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playTrailer))
        widescreen.isUserInteractionEnabled = true
        widescreen.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Play trailer video when widescreen image is tapped
    @objc func playTrailer() {
        guard let trailerURLString = TheMovie?.tr_mp4, let url = URL(string: trailerURLString) else {
            print("Trailer URL is invalid or missing")
            return
        }

        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        // Present the video player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}
