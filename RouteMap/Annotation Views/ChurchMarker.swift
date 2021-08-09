//
//  ChurchMarker.swift
//  ChurchMarker
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class ChurchMarker: MKMarkerAnnotationView {
    let vm: ViewModel
    
    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = .systemGreen
            glyphImage = #imageLiteral(resourceName: "cross")
            displayPriority = .defaultHigh
            animatesWhenAdded = true
            canShowCallout = true
            clusteringIdentifier = "Cluster"
            
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))
            
            let visitedBtn = UIButton(type: .custom)
            let visitedImg = UIImage(systemName: "checkmark.circle", withConfiguration: config)
            visitedBtn.setImage(visitedImg, for: .normal)
            visitedBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
            visitedBtn.addTarget(self, action: #selector(toggleVisitedChurch), for: .touchUpInside)
            leftCalloutAccessoryView = visitedBtn
            
            let infoBtn = UIButton(type: .custom)
            let infoImg = UIImage(systemName: "safari", withConfiguration: config)
            infoBtn.setImage(infoImg, for: .normal)
            infoBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
            infoBtn.addTarget(self, action: #selector(openChurchUrl), for: .touchUpInside)
            rightCalloutAccessoryView = infoBtn
        }
    }
    
    init(vm: ViewModel, annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.vm = vm
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toggleVisitedChurch() {
        if let church = annotation as? Church {
            vm.toggleVisitedChurch(church: church)
        }
    }
    
    @objc func openChurchUrl() {
        if let church = annotation as? Church {
            vm.openChurchUrl(church: church)
        }
    }
}
