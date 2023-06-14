//
//  ViewController.swift
//  Project22iBeacons
//
//  Created by Giorgio Latour on 6/14/23.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    var alertHasBeenShown: Bool = false
    
    var proximityCircle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        proximityCircle = UIView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
        proximityCircle.translatesAutoresizingMaskIntoConstraints = false
        proximityCircle.backgroundColor = .blue
        proximityCircle.layer.cornerRadius = 128
        view.addSubview(proximityCircle)
        
        NSLayoutConstraint.activate([
            proximityCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            proximityCircle.centerYAnchor.constraint(equalTo: distanceReading.bottomAnchor, constant: 150),
            proximityCircle.heightAnchor.constraint(equalToConstant: 256),
            proximityCircle.widthAnchor.constraint(equalToConstant: 256)
        ])
        
        
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.proximityCircle.transform = CGAffineTransform.identity.scaledBy(x: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.proximityCircle.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.proximityCircle.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.proximityCircle.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            
            if alertHasBeenShown == false {
                let ac = UIAlertController(title: "Beacon Found", message: "An iBeacon has been found.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { action in
                    self.alertHasBeenShown = true
                }
                ac.addAction(okAction)
                present(ac, animated: true)
            }
        } else {
            update(distance: .unknown)
        }
    }
}

// iBeacons are identified with a UUID, a major number, and a minor number.
