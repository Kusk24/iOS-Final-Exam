//
//  ViewController.swift
//  PFE_6612054
//
//  Created by Win Yu Maung on 02/10/2024.
//

import UIKit
import Kingfisher

//https://www.majorcineplex.com/apis/get_movie_avaiable
//https://www.majorcineplex.com/apis/get_cinema
var mymovies: [Movie] = []
var filteredMovies: [Movie] = []
var isShowingNowShowing = true // Default to show "Now Showing" movies

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CinemaCollectionCell", for: indexPath) as! CinemaCollectionCell
        
        let movie = filteredMovies[indexPath.row]

        if let posterURL = movie.poster_url, let url = URL(string: posterURL) {
            cell.Poster.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            cell.Poster.image = UIImage(named: "placeholder") // Default placeholder
        }
        
        cell.Genre.text = movie.genre!
        cell.Title_en.text = movie.title_en!
        cell.ReleaseDate.text = movie.release_date!
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Detail = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        Detail.TheMovie = filteredMovies[indexPath.row]
        Detail.modalPresentationStyle = .popover
        present(Detail, animated: true)
    }
    
    @IBOutlet weak var MyCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MyCollectionView.dataSource = self
        MyCollectionView.delegate = self
        
        // Fetch the movies and reload the collection view after data is fetched
        fetchMovies { result in
            switch result {
            case .success(let movies):
                mymovies = movies
                // Reload the collection view on the main thread after fetching the movies
                self.filterMovies()
            case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
    
    func filterMovies() {
        if isShowingNowShowing {
            // Filter for "Now Showing" movies where `now_showing` is "1"
            filteredMovies = mymovies.filter { $0.now_showing == "1" }
        } else {
            // Filter for "Upcoming" movies where `now_showing` is nil or an empty string
            filteredMovies = mymovies.filter { $0.now_showing == "" || $0.now_showing == nil }
        }
        
        // Reload collection view data on the main thread after filtering
        DispatchQueue.main.async {
            self.MyCollectionView.reloadData()
        }
    }
    
    // MARK: - Segmented Control Action
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isShowingNowShowing = true // Show "Now Showing" movies
        } else {
            isShowingNowShowing = false // Show "Upcoming" movies
        }
        
        // Filter movies based on the selected segment
        filterMovies()
    }
    
}

    

