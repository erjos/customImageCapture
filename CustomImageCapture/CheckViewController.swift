import UIKit
import Foundation

class CheckViewController: UIViewController {

    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var rearImage: UIImageView!
    
    //can convert these to type DATA by using UIImagePNGRepresentation() method to convert
    var front: UIImage?
    var back: UIImage?
    
    var sideLabel: String?
    
    override func viewDidAppear(_ animated: Bool) {
        view.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frontTap = UITapGestureRecognizer(target: self, action: #selector(self.openCamera))
        let rearTap = UITapGestureRecognizer(target: self, action: #selector(self.openCamera))
        frontImage.addGestureRecognizer(frontTap)
        rearImage.addGestureRecognizer(rearTap)
    }
    
    @IBAction func unwindToCheckView(_ segue: UIStoryboardSegue){
        let photoVC = segue.source as! PhotoViewController
        guard let image = photoVC.croppedImage else {
            return
        }
        
        if(photoVC.labelString == "FRONT OF CHECK"){
            front = image
            frontImage.image = image
        } else {
            back = image
            rearImage.image = image
        }
    }

    @objc func openCamera(_ sender: UITapGestureRecognizer){
        sideLabel = (sender.view == frontImage) ? "FRONT OF CHECK" : "BACK OF CHECK"
        self.view.isHidden = true
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        performSegue(withIdentifier: "showPhoto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photoVC = segue.destination as! PhotoViewController
        photoVC.labelString = sideLabel
    }
}
