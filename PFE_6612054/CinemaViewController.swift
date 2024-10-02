//
//  CinemaViewController.swift
//  PFE_6612054
//
//  Created by Win Yu Maung on 02/10/2024.
//

import UIKit

class CinemaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var cinemas: [Cinema] = []
    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    var favoriteCinemas: [Cinema] = [] // Array to store favorite cinemas
    var isShowingFavorites = false // Flag to indicate if we're showing favorites
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the data source and delegate for the table view
        MyTableView.dataSource = self
        MyTableView.delegate = self

        // Load favorite cinemas from UserDefaults
        loadFavoriteCinemas()

        // Fetch cinema data
        fetchCinemas { result in
            switch result {
            case .success(let cinemas):
                // Store the fetched cinemas and reload the table view
                self.cinemas = cinemas
                DispatchQueue.main.async {
                    self.MyTableView.reloadData()
                }
            case .failure(let error):
                // Handle error case
                print("Error fetching cinemas: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - UITableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingFavorites ? favoriteCinemas.count : cinemas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaTableCell", for: indexPath) as! CinemaTableCell
        
        // Fetch the corresponding cinema from the array based on the segment
        let cinema = isShowingFavorites ? favoriteCinemas[indexPath.row] : cinemas[indexPath.row]
        
        // Set the cinema name label text
        cell.CinemaName.text = cinema.cinema_name_en ?? "Unknown Cinema"

        // Set image based on the cinema name
        if cinema.cinema_name_en?.caseInsensitiveCompare("Paragon Cineplex") == .orderedSame {
            cell.MyImage.image = UIImage(named: "paragon")
        } else if cinema.cinema_name_en?.caseInsensitiveCompare("ICON CINECONIC") == .orderedSame {
            cell.MyImage.image = UIImage(named: "icon")
        } else if cinema.cinema_name_en?.caseInsensitiveCompare("Quartier Cineart") == .orderedSame {
            cell.MyImage.image = UIImage(named: "emq")
        } else if cinema.cinema_name_en?.caseInsensitiveCompare("IMAX Laser") == .orderedSame {
            cell.MyImage.image = UIImage(named: "imax")
        } else {
            cell.MyImage.image = UIImage(named: "major") // Default image
        }

        // Handle star (favorite) toggle
        if favoriteCinemas.contains(where: { $0.cinema_name_en == cinema.cinema_name_en }) {
            cell.FavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) // Filled star
        } else {
            cell.FavoriteButton.setImage(UIImage(systemName: "star"), for: .normal) // Empty star
        }

        // Add action to the star button
        cell.FavoriteButton.tag = indexPath.row
        cell.FavoriteButton.addTarget(self, action: #selector(toggleFavorite(_:)), for: .touchUpInside)
        cell.CinemaLocation.text = cinema.zone_name_en
        
        return cell
    }

    // Toggle favorite when the star button is clicked
    @objc func toggleFavorite(_ sender: UIButton) {
        let index = sender.tag
        let cinema = isShowingFavorites ? favoriteCinemas[index] : cinemas[index]
        
        if let favoriteIndex = favoriteCinemas.firstIndex(where: { $0.cinema_name_en == cinema.cinema_name_en }) {
            // Remove from favorites if already in the list
            favoriteCinemas.remove(at: favoriteIndex)
        } else {
            // Add to favorites
            favoriteCinemas.append(cinema)
        }

        // Save the updated favorite cinemas to UserDefaults
        saveFavoriteCinemas()
        
        DispatchQueue.main.async {
            self.MyTableView.reloadData()
        }
    }

    // Set row height for table view cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = storyboard?.instantiateViewController(withIdentifier: "CinemaDetail") as! CinemaDetail
        detail.cinema = isShowingFavorites ? favoriteCinemas[indexPath.row] : cinemas[indexPath.row]
        detail.modalPresentationStyle = .popover
        present(detail, animated: true)
    }
    
    // Handle segment control switching between "All Cinema" and "Favorite"
    @IBAction func SegmentControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            // Show favorite cinemas
            isShowingFavorites = true
        } else {
            // Show all cinemas
            isShowingFavorites = false
        }
        MyTableView.reloadData()
    }
    
    func saveFavoriteCinemas() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoriteCinemas) {
            UserDefaults.standard.set(encoded, forKey: "favoriteCinemas")
        }
    }

    func loadFavoriteCinemas() {
        if let savedFavorites = UserDefaults.standard.object(forKey: "favoriteCinemas") as? Data {
            let decoder = JSONDecoder()
            if let loadedFavorites = try? decoder.decode([Cinema].self, from: savedFavorites) {
                favoriteCinemas = loadedFavorites
            }
        }
    }
}

