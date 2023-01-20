//
//  QRGeneratorViewController.swift
//  Scanner
//
//  Created by Alanis Danahe Esquivel Salvador on 18/01/23.
//

import UIKit

class QRGeneratorViewController: UIViewController {
    
    
    @IBOutlet weak var textGenerar: NSLayoutConstraint!
    
    @IBOutlet weak var imagenVisualizarQR: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textGenerar.delegate = self

        imagenVisualizarQR.image = generateQRCode(from: "https://github.com/oscar-nv")
        
    }
    
    func generateQRCode(from string: String) ->UIImage?{
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 4, y: 4)
            
            if let output = filter.outputImage?.transformed(by: transform){
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func generarButton(_ sender: UIBarButtonItem) {
       // imagenVisualizarQR.image = generateQRCode(from: textGenerar.text ?? "Hola aahdgajhd")
      //  textGenerar.text = ""
      //  textGenerar.endEditing(true)
        
    }
    

}

/*extension QRGeneratorViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textGenerar.text = ""
        imagenVisualizarQR.image = nil
        
    }
 }/**/*/
