//
//  ViewController.swift
//  Scanner
//
//  Created by Alanis Danahe Esquivel Salvador on 18/01/23.
//

import UIKit
import Vision
import VisionKit
import PDFKit
import PhotosUI

class ViewController: UIViewController {

    
    @IBOutlet weak var previewDoc: UIImageView!
    
    let pdfVista = PDFView()
    let scanVC = VNDocumentCameraViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfVista.delegate = self
        scanVC.delegate = self
        
        previewDoc.isUserInteractionEnabled = true
        previewDoc.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(previsualizar)))
        present(scanVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfVista.frame = view.bounds
    }

    func cargarPDF(){
        previewDoc.addSubview(pdfVista)
        
        //crear el documento a mostrar
        let documento = PDFDocument()
        guard let pagina = PDFPage(image: previewDoc.image ?? UIImage(systemName: "car")!) else {return}
        documento.insert(pagina, at: 0)
        
        pdfVista.document = documento
        
        // Diseño y visualización
        pdfVista.autoScales = true
        pdfVista.usePageViewController(true)
    }
    
    @objc func previsualizar(){
        performSegue(withIdentifier: "verDocumento", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDocumento" {
            let documento = segue.destination as! VerDocumentoViewController
            documento.recibirDocumentoMostrar = previewDoc.image
        }
    }
    
    
    @IBAction func abrirGaleriaBtn(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func GuardarPDFBtn(_ sender: Any) {
        cargarPDF()
        
        let alerta = UIAlertController(title: "ATENCION", message: "¿Desea guardar este documento como PDF?", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "SI", style: .default){ _ in
            let vc = UIActivityViewController(activityItems:
                [self.pdfVista.document?.dataRepresentation()!], applicationActivities: [])
            self.present(vc, animated: true)
        }
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .destructive)
        alerta.addAction(accionCancelar)
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    @IBAction func otraVezBtn(_ sender: Any) {
        present(scanVC, animated: true)
    }
    
    @IBAction func qrGenerator(_ sender: Any) {
       
    }
    
    
}
extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        if scan.pageCount > 0 {
            previewDoc.image = scan.imageOfPage(at: 0)
            controller.dismiss(animated: true)
        }
    }
}

extension ViewController: PDFViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            
            previewDoc.image = imagenSeleccionada
            
            cargarPDF()
            picker.dismiss(animated: true)
        }
    }
}
