import UIKit

class CheckViewController: UIViewController {

    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var rearImage: UIImageView!
    
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
