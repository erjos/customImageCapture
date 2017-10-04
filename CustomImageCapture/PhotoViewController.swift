import UIKit
import AVFoundation
import Foundation

class PhotoViewController: UIViewController {

    var labelString: String?
    var croppedImage: UIImage?
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    
    @IBAction func didPressCancel(_ sender: Any) {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressUse(_ sender: Any) {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        //alternatively may be able to create an unwind inline using the unwind method
        performSegue(withIdentifier: "unwindCheckView", sender: self)
    }
    @IBAction func didPressRedo(_ sender: Any) {
        
        //prep for photo
        self.previewView.isHidden = false
        self.capturedImage.isHidden = true
        self.captureButton.isHidden = false
        self.buttonView.isHidden = true
    }
    
    @IBAction func didPressTakePhoto(_ sender: Any) {
        //Configure Data Connection
        
        
        if let videoConnection = stillImageOutput!.connection(with: .video){
            //now we have a connection object that has data flowing from our desired input to our desired output - we can capture
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                var dataProvider = CGDataProvider.init(data: imageData! as CFData)
                var cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                var image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.up)
                self.croppedImage = self.cropToPreviewLayer(originalImage: image)
                
                self.capturedImage.image = self.croppedImage
                
                //prep for viewing
                self.previewView.isHidden = true
                self.capturedImage.isHidden = false
                self.captureButton.isHidden = true
                self.buttonView.isHidden = false
            })
        }
    }
    
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewWillAppear(_ animated: Bool) {
       
        captureSession = AVCaptureSession()
        //I think we want to change this to medium later as this resolution is too high
        captureSession!.sessionPreset = .photo
        //configure the capture device
        var backCamera = AVCaptureDevice.default(for: .video)
        
        var error: NSError?
        guard var input = try? AVCaptureDeviceInput.init(device: backCamera!) else {
            //initialize error if the try fails
            error = NSError()
            return
        }
        
        //check that there was no error and that input is valid for capture session
        if (error == nil && captureSession!.canAddInput(input)) {
            captureSession!.addInput(input)
        }
        
        //Output configuration
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession!.addOutput(stillImageOutput!)
        
        //configure live preview
            //create preview layer and connect to capture session
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            //add preview layer to view on storyboard
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = .landscapeRight
        previewView.layer.addSublayer(previewLayer!)
        captureSession?.startRunning()
        capturedImage.isHidden = true
        buttonView.isHidden = true
    }
    
    private func cropToPreviewLayer(originalImage: UIImage) -> UIImage {
        let outputRect = previewLayer?.metadataOutputRectConverted(fromLayerRect: (previewLayer?.bounds)!)
        var cgImage = originalImage.cgImage!
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: (outputRect?.origin.x)! * width, y: (outputRect?.origin.y)! * height, width: (outputRect?.size.width)! * width, height: (outputRect?.size.height)! * height)
        
        cgImage = cgImage.cropping(to: cropRect)!
        let croppedUIImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: originalImage.imageOrientation)
        
        return croppedUIImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //set the bounds of the preview to match that of the containing view
        previewLayer!.frame = previewView.bounds
        self.view.bringSubview(toFront: overlayView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideLabel.text = labelString!
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//extension ViewController : AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        let picture = photo
//    }
//}

