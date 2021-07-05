//
//  TextRecognition.swift
//  NutLabelInformation
//
//  Created by Jhennyfer Rodrigues de Oliveira on 24/06/21.
//

import Foundation
import UIKit
import Vision

class TextRecognition {
    var textFromImage = ""
    var delegate: PresentViewControllerDelegate!
    public func recognizeText(image: UIImage?) {
        
        guard let cgimage = image?.cgImage else {return}
        
        //handler
        let handler = VNImageRequestHandler(cgImage: cgimage, options: [:])
        
        //request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            
            let text = results.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "/ ")
            
            let lowercasedText = text.lowercased()
            let allText =  lowercasedText.components(separatedBy: "/ ")
            
            var newArray: [String:String] = ["Gorduras Saturadas": "", "Sódio": "" , "Açúcar": ""]
            for i in 0...allText.count-1 {
                var newValueChangingCommaToDot = ""
                if i < allText.count-1 {
                    newValueChangingCommaToDot = allText[i+1].replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
                }
                if allText[i] == "gorduras saturadas" || allText[i] == "gordura saturada" {
                    newArray["Gorduras Saturadas"] = newValueChangingCommaToDot
                } else if allText[i] == "sodio" || allText[i] == "sódio" {
                    newArray["Sódio"] = newValueChangingCommaToDot
                    
                } else if allText[i] == "acucar" || allText[i] == "açucar" || allText[i] == "açúcar" || allText[i] == "acucares" || allText[i] == "açúcares" || allText[i] == "açucares" {
                    newArray["Açúcar"] = newValueChangingCommaToDot
                }
            }
     
            print(newArray)
            
            
            var finalArrayOfNutricionalLabels: [String:Double] = ["Gorduras Saturadas": 0 , "Sódio": 0  , "Açúcar": 0 ]
            for (key,_) in newArray {
                
                guard let arrayValue = newArray[key] else {return}
                if arrayValue != "" {
                    let arrayOfNumbersAndMeasure = arrayValue.components(separatedBy: " ")
                    if arrayOfNumbersAndMeasure[1] == "g" {
                        finalArrayOfNutricionalLabels[key] = Double(arrayOfNumbersAndMeasure[0])
                    } else if arrayOfNumbersAndMeasure[1] == "mg" {
                        guard let wrappedNumber = Double(arrayOfNumbersAndMeasure[0]) else {return}
                        finalArrayOfNutricionalLabels[key] = wrappedNumber/1000
                    }
                }
                
            }
            
            // pass the info to the sec screen
            guard let acucar = finalArrayOfNutricionalLabels["Açúcar"] else {return}
            guard let gordura = finalArrayOfNutricionalLabels["Gorduras Saturadas"] else {return}
            guard let sodio = finalArrayOfNutricionalLabels["Sódio"] else {return}
            
            self?.delegate.presentSecondViewController(quantGordura: gordura, quantAcucar: acucar, quantSodio: sodio)
            print(finalArrayOfNutricionalLabels)
            DispatchQueue.main.async {
                self?.textFromImage = text

                
            }
        }
 
        // process request
        
        do {
            try handler.perform([request])
        } catch {
            print("error")
        }
        
    }
}

