//
//  ViewController.swift
//  NutLabelInformation
//
//  Created by Jhennyfer Rodrigues de Oliveira on 24/06/21.
//

import UIKit


class ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, PresentViewControllerDelegate  {
    
//    var bool = true
    let imageClassification = ImageClassification()
    let textRecognition = TextRecognition()
    let imagePickerVC = UIImagePickerController()
    var choosenImage: UIImage!
    
    @IBOutlet weak var buttonChoosePhoto: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonChoosePhoto.layer.cornerRadius = 20
        imageClassification.delegate = self
        textRecognition.delegate = self
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let backButton = UIBarButtonItem()
           backButton.title = "Back"
           self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func showImagePicker() {
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.allowsEditing = false
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageClassification.classifyImage(image)
            choosenImage = image
            textRecognition.recognizeText(image: image)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func presentSecondViewController(quantGordura: Double, quantAcucar: Double, quantSodio: Double) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "secondView") as! SecondViewController
        vc.quantAcucar = quantAcucar
        vc.quantSodio = quantSodio
        vc.quantGordura = quantGordura
        vc.choosenImageFromBefore.image = choosenImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlertView() {
        // create the alert
        let alert = UIAlertController(title: "The image couldn't be identified", message: "Maybe the image you uploaded is not a nutritional label, if it is, consider taking a picture in a better light.  ", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

