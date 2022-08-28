//
//  ViewController.swift
//  Project16
//
//  Created by Derya Çayıroğlu on 27.08.2022.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics", wikiUrl: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", wikiUrl: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light", wikiUrl: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wikiUrl: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", wikiUrl: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        let ankara = Capital(title: "Ankara", coordinate: CLLocationCoordinate2D(latitude: 39.925533, longitude: 32.866287), info: "The Capital of Turkiye", wikiUrl: "https://en.wikipedia.org/wiki/Ankara")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington, ankara])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(chooseMapType))
    }

    @objc func chooseMapType() {
        let ac = UIAlertController(title: "Choose Map Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default) {_ in
            self.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "MutedStandard", style: .default) {_ in
            self.mapView.mapType = .mutedStandard
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) {_ in
            self.mapView.mapType = .hybrid
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) {_ in
            self.mapView.mapType = .satellite
        })
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        if let pin = annotationView as? MKPinAnnotationView {
            pin.pinTintColor = UIColor.magenta
        }
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default){_ in
            self.openWiki(url: capital.wikiUrl)
        })
        present(ac, animated: true)
    }

    func openWiki(url: String){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController{
            vc.webSite = url
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

