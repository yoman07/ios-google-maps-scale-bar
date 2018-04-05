//
//  ScaleBarView.swift
//  Mapa turystyczna
//
//  Created by Roman Barzyczak on 21.10.2016.
//  Copyright © 2016 Mapa Turystyczna. All rights reserved.
//

import UIKit
import GoogleMaps
import Darwin

@IBDesignable
class ScaleBarView: UIView {
    private static let defaultWidth:CGFloat = 200.0
    weak var mapView: GMSMapView?
    @IBOutlet weak var scaleBarConstant: NSLayoutConstraint!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let viewBundle = Bundle(for: type(of: self))
        if let view = viewBundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)![0] as? UIView {
            return view
        }
        return UIView()
    }
    
    fileprivate func commonSetup() {
        let nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let mapView = self.mapView
        else {
            return
        }
        
        let projection = mapView.projection
        let screenWidth = mapView.frame.width
        let barWidth = self.frame.width
        
        self.scaleBarConstant.constant = scaledBarWidth(projection: projection, scaleWidth: barWidth, screenWidth: screenWidth)
        distanceLabel.text = roundedDistanceFormatted(projection: projection, scaleWidth: barWidth, screenWidth: screenWidth)
    }
    
    private func roundedDistanceFormatted(projection: GMSProjection, scaleWidth: CGFloat, screenWidth: CGFloat) -> String {
        let latLngLeft = projection.visibleRegion().farLeft
        let latLngRight = projection.visibleRegion().farRight
        let screenDistance = latLngLeft.distance(from: latLngRight)
        let scaleDistance = scaleWidth/screenWidth * screenDistance
        let roundedDistance = scaleDistance.roundAsDistance()
        return formatDistance(distance: roundedDistance)
    }
    
    private func scaledBarWidth(projection: GMSProjection, scaleWidth: CGFloat, screenWidth: CGFloat) -> CGFloat {
        let latLngLeft = projection.visibleRegion().farLeft
        let latLngRight = projection.visibleRegion().farRight
        let screenDistance = latLngLeft.distance(from: latLngRight)
        let scaleDistance = scaleWidth/screenWidth * screenDistance
        let roundedDistance = scaleDistance.roundAsDistance()
        let scaleRatio = CGFloat(roundedDistance) / screenDistance
        let scaleBarWidth =  screenWidth * scaleRatio
        return CGFloat(scaleBarWidth)
    }
    

    private func formatDistance(distance: Int) -> String {
        if distance < 1000 {
            return String(format: "%d", distance)
        } else {
            return String(format: "%d km", distance/1000)
        }
    }
}

extension CLLocationCoordinate2D {
    func distance(from coordinate: CLLocationCoordinate2D) -> CGFloat {
        let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        return CGFloat(location1.distance(from: location2))
    }
}

extension CGFloat {
    func roundAsDistance() -> Int {
        var roundedDistance = 1
        var i = 0;
        while (1 + pow(CGFloat(i % 3), 2)) * pow(10, floor(CGFloat(i / 3))) < self {
            roundedDistance =  Int(((1 + pow(CGFloat(i % 3), 2)) * pow(10, floor(CGFloat(i / 3)))))
            i+=1
        }
        return roundedDistance
    }
}

