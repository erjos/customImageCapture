import UIKit

class CheckViewController: UIViewController {

    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var rearImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frontTap = UITapGestureRecognizer(target: self, action: #selector(self.openCamera))
        let rearTap = UITapGestureRecognizer(target: self, action: #selector(self.openCamera))
        frontImage.addGestureRecognizer(frontTap)
        rearImage.addGestureRecognizer(rearTap)
    }

    @objc func openCamera(){
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        performSegue(withIdentifier: "showPhoto", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
