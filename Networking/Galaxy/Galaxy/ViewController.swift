

import UIKit

class GalaxyViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var button: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // We will use this to keep track of our state for now
    var isDownloading: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the initial state
        isDownloading = false;
        toggleViews(isDownloading: false)
    }
    
    // Whenever the button is clicked, toggle between the two states
    // downloading, and not downloading
    @IBAction func downloadOrCancel() {
        
        if isDownloading {
            cancelTheDownload()
        } else {
            startTheDownload()
        }
    }
    
    // Here's where we will start the downloading magic
    
    func startTheDownload() {
        isDownloading = true
        toggleViews(isDownloading: true)
        
        // Make the url
        let url = URL(string: GalaxyURLs.nextURLString)!

        // Create the download task
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            var galaxyImage: UIImage?
            
            if let error = error {
                print(error)
                galaxyImage = nil
            }
            
            if let data = data {
                galaxyImage = UIImage(data: data)
            }
            
            // Pass these lines back to the main thread
            DispatchQueue.main.async {
                self.imageView.image = galaxyImage
                self.isDownloading = false
                self.toggleViews(isDownloading: false)
            }
        }
        
        // Start the task
        task.resume()
        
        print("leaving startTheDownload")
    }
    
    func cancelTheDownload() {
        isDownloading = false
        toggleViews(isDownloading: false)
    }
    
    // Use this method to toggle the state of the UI
    func toggleViews(isDownloading: Bool) {
    
        // Button
        let buttonTitle = isDownloading ? "Cancel" : "Start"
        button.setTitle(buttonTitle, for: .normal)
        
        // Activity Indicator
        if isDownloading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        // Image View
        imageView.isHidden = isDownloading
    }
    
    // This is just a way to experiment with work that takes
    // a long time. Counts the number of prime values between 
    // 1 and size
    func busyWork(_ size: Int) {
        var primeCount = 3
        for value in 5...size {
            var isPrime = true;
            let highestFactor = Int(sqrt(Double(value)))
            for potentialFactor in 2...highestFactor {
                if (value % potentialFactor == 0) {
                    isPrime = false
                }
            }
            
            if isPrime {
                primeCount += 1
            }
        }
        
        print(primeCount)
    }
}
