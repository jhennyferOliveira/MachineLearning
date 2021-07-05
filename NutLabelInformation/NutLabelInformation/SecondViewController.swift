//
//  SecondViewController.swift
//  NutLabelInformation
//
//  Created by Jhennyfer Rodrigues de Oliveira on 24/06/21.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var choosenImage: UIImageView!
    var choosenImageFromBefore = UIImageView()

    @IBOutlet weak var labelSodio: UILabel!
    @IBOutlet weak var progressSodio: UIProgressView!
    var quantSodio: Double = 0
    
    @IBOutlet weak var progressGordura: UIProgressView!
    @IBOutlet weak var labelGordura: UILabel!
    var quantGordura:Double = 0
    
    @IBOutlet weak var progressAcucar: UIProgressView!
    @IBOutlet weak var labelAcucar: UILabel!
    var quantAcucar:Double = 0
    
    @IBOutlet weak var infoButton: UIButton!
    
    override func viewDidLoad() {
//        overrideUserInterfaceStyle = .light
        
        choosenImage.image = choosenImageFromBefore.image
        choosenImage.layer.cornerRadius = 20
        choosenImage.clipsToBounds = true
        progressSodio.setProgress(Float(quantSodio)/2.4, animated: false)
        progressGordura.setProgress(Float(quantGordura)/22, animated: false)
        progressAcucar.setProgress(Float(quantAcucar)/50, animated: false)
        
        labelSodio.text = String(format: "%.2f", quantSodio/2.4 * 100) + "%"
        labelAcucar.text = String(format: "%.2f", quantAcucar/50 * 100) + "%"
        labelGordura.text = String(format: "%.2f", quantGordura/22 * 100) + "%"
    }
    
    
    @IBAction func alertView() {
        // create the alert
        let alert = UIAlertController(title: "Informativo", message: "Todos os valores são baseados nos valores permitidos pela OMS e ANVISA. Máximo de sódio: 2,4g, Máximo de açúcar: 50g, Máximo de gordura saturada: 22g. Se o valor da porcentagem aparecer como 0 verifique o rótulo pois pode ter ocorrido erro ao reconhecer o texto  ", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }

    
}
