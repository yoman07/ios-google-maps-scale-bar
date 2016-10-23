# Displaying scale bar on Google Maps iOS


How to use ?

1. You can add scaleBar via xib or storyboard. 
2. Set mapView:   scaleBarView.mapView = self.mapView . 
3. Add delegate for your GMSMapView and add
func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {        
self.scaleBarView.setNeedsLayout()
    }
