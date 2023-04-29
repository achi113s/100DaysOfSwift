//
//  ViewController.swift
//  Project16Maps
//
//  Created by Giorgio Latour on 4/28/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.", url: URL(string: "https://en.wikipedia.org/wiki/London")!)
    let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", url: URL(string: "https://en.wikipedia.org/wiki/Oslo")!)
    let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", url: URL(string: "https://en.wikipedia.org/wiki/Paris")!)
    let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", url: URL(string: "https://en.wikipedia.org/wiki/Rome")!)
    let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", url: URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C.")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)
        
        let mapTypeButton = UIButton(type: .detailDisclosure)
        mapTypeButton.translatesAutoresizingMaskIntoConstraints = false
        mapTypeButton.backgroundColor = .systemBackground
        mapTypeButton.layer.cornerRadius = 10
        mapTypeButton.addTarget(self, action: #selector(mapTypeSelect), for: .touchUpInside)
        view.addSubview(mapTypeButton)
        
        NSLayoutConstraint.activate([
            mapTypeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            mapTypeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapTypeButton.heightAnchor.constraint(equalToConstant: 40),
            mapTypeButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .yellow
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
            annotationView?.markerTintColor = .yellow
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
//        let placeName = capital.title
//        let placeInfo = capital.info
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
        let webVC = WebDetailViewController()
        webVC.url = capital.url
        navigationController?.present(webVC, animated: true)
    }
    
    @objc func mapTypeSelect(_ sender: UIButton) {
        let ac = UIAlertController(title: "Map Type", message: "What map type would you like to use?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { action in
            self.mapView.preferredConfiguration = MKStandardMapConfiguration()
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { action in
            self.mapView.preferredConfiguration = MKHybridMapConfiguration()
        }))
        ac.addAction(UIAlertAction(title: "Imagery", style: .default, handler: { action in
            self.mapView.preferredConfiguration = MKImageryMapConfiguration()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

