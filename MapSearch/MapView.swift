//
//  MapView.swift
//  mapsearch
//
//  Created by Seraphin DESUMEUR on 04/04/2018.
//  Copyright © 2018 Seraphin DESUMEUR. All rights reserved.
//

import Foundation
import Mapbox

@objc protocol MapViewDelegate {
    func regionWillChange()
    func regionDidChange(latitude: Double, longitude: Double)
}

final class MapView: UIView {
    
    @IBOutlet var delegate: MapViewDelegate?
    
    private let mapBoxStyle = "mapbox://styles/mapbox/streets-v10"
    private let defaultZoomLevel: Double = 13
    private var mapboxView = MGLMapView()
    
    var centerCoordinate: CLLocationCoordinate2D {
        return mapboxView.centerCoordinate
    }
    
    var zoomLevel: Double {
        return mapboxView.zoomLevel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setCenter(_ coordinate: CLLocationCoordinate2D, zoomLevel: Double? = nil) {
        mapboxView.setCenter(coordinate, zoomLevel: zoomLevel ?? defaultZoomLevel, animated: true)
    }
    
    private func commonInit() {
        mapboxView = MGLMapView(frame: bounds, styleURL: URL(string: mapBoxStyle))
        mapboxView.delegate = self
        mapboxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(mapboxView)
    }
}

extension MapView: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        delegate?.regionWillChange()
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        delegate?.regionDidChange(latitude: mapView.centerCoordinate.latitude,
                                  longitude: mapView.centerCoordinate.longitude)
    }
}
