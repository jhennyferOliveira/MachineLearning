//
//  ImageClassification.swift
//  NutLabelInformation
//
//  Created by Jhennyfer Rodrigues de Oliveira on 24/06/21.
//

import Foundation
import CoreML
import Vision
import UIKit

protocol PresentViewControllerDelegate {
    func presentSecondViewController(quantGordura: Double, quantAcucar: Double, quantSodio: Double)
    func showAlertView()
}
class ImageClassification {
    var delegate: PresentViewControllerDelegate!
    var resultsLabel: String = ""
    // 1 Define an image analysis request that’s created when first accessed
    private lazy var classificationRequest: VNCoreMLRequest = {
      do {
        //2 Create instance of the model
        let model = try VNCoreMLModel(for: ClassifiesNutritionalLabels().model)
        
        // instead of printing we are going to process the results
        let request = VNCoreMLRequest(
            model: model,
            completionHandler: { [weak self] request, error in
              // add this
              self?.processObservations(for: request, error: error)
            })
        
        //the input image to match what the model expects
        request.imageCropAndScaleOption = .scaleFit
        return request
      } catch {
        // 5 Handle model load errors by killing the app
        fatalError("Failed to load Vision ML model: \(error)")
      }
    }()
    
    func classifyImage(_ image: UIImage) {
      // 1 Gets the orientation of the image and the CIImage representation.
      guard let orientation = CGImagePropertyOrientation(
        rawValue: UInt32(image.imageOrientation.rawValue)) else {
        return
      }
      guard let ciImage = CIImage(image: image) else {
        fatalError("Unable to create \(CIImage.self) from \(image).")
      }
      // 2 Kicks off an asynchronous classification request in a background queue. You create a handler to perform the Vision request, and then schedule the request.
      DispatchQueue.global(qos: .userInitiated).async {
        let handler =
          VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
        do {
          try handler.perform([self.classificationRequest])
        } catch {
          print("Failed to perform classification.\n\(error.localizedDescription)")
        }
      }
    }
    
    func processObservations(
      for request: VNRequest,
      error: Error?) {
      // 1
      DispatchQueue.main.async {
        // 2
        if let results = request.results
          as? [VNClassificationObservation] {
          if results.isEmpty {
            self.resultsLabel = "nothing found"
          } else {
//            self.resultsLabel = String(
//              format: "%@ %.1f%%",
//              results[0].identifier,
//              results[0].confidence * 100)
            
            if results[0].identifier == "rotulo" {
                print("rotulo")
//                self.delegate.presentSecondViewController(quantGordura: <#Double#>, quantAcucar: <#Double#>, quantSodio: <#Double#>)
                
                
            } else {
                self.delegate.showAlertView()
            }
          }
        } else if let error = error {
          self.resultsLabel =
            "error: \(error.localizedDescription)"
        }

      }
    }
    
}
