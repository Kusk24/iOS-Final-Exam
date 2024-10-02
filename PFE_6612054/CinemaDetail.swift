//
//  CinemaDetail.swift
//  PFE_6612054
//
//  Created by Win Yu Maung on 02/10/2024.
//

import UIKit
import WebKit

class CinemaDetail: UIViewController {
    @IBOutlet weak var Myimage: UIImageView!
    @IBOutlet weak var CinemaName: UILabel!
    @IBOutlet weak var Cinemalocation: UILabel!
    @IBOutlet weak var CinemaOpening: UILabel!
    @IBOutlet weak var CinemaPhone: UILabel!
    @IBOutlet weak var CinemaContent: WKWebView! // Make sure it's a WKWebView and connected properly
    
    var cinema: Cinema!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if cinema.cinema_name_en?.caseInsensitiveCompare("Paragon Cineplex") == .orderedSame {
            Myimage.image = UIImage(named: "paragon")
        } else if cinema.cinema_name_en?.caseInsensitiveCompare("ICON CINECONIC") == .orderedSame {
            Myimage.image = UIImage(named: "icon")
        } else if cinema.cinema_name_en?.caseInsensitiveCompare("Quartier Cineart") == .orderedSame {
            Myimage.image = UIImage(named: "emq")
        } else if cinema.cinema_name_en?.caseInsensitiveCompare("IMAX Laser") == .orderedSame {
            Myimage.image = UIImage(named: "imax")
        } else {
            Myimage.image = UIImage(named: "major") // Default image
        }
        
        CinemaName.text = cinema.cinema_name_en
        CinemaPhone.text = cinema.cinema_tel
        Cinemalocation.text = cinema.zone_name_en
        CinemaOpening.text = cinema.cinema_office_hour_en
        if let content = cinema.cinema_content_main {
            CinemaContent.loadHTMLString(content, baseURL: nil)
        }
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
