import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBAction func didPressTakePhoto(_ sender: Any) {
        //Configure Data Connection
        if let videoConnection = stillImageOutput!.connection(with: .video){
            //now we have a connection object that has data flowing from our desired input to our desired output - we can capture
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                var dataProvider = CGDataProvider.init(data: imageData! as CFData)
                var cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                var image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                self.capturedImage.image = image
            })
            //Below is what we would use for ios11
            //let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            //stillImageOutput?.capturePhoto(with: settings , delegate: self)
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
        previewView.layer.addSublayer(previewLayer!)
        captureSession?.startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //set the bounds of the preview to match that of the containing view
        previewLayer!.frame = previewView.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

