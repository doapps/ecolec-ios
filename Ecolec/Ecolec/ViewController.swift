//
//  ViewController.swift
//  Ecolec
//
//  Created by Nicolas on 6/1/19.
//  Copyright © 2019 Nicolas. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    
    var categories: [String] = ["Todos", "Carton", "Vidrios", "Plastico", "Metal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        
        
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDown(_:)))
        downSwipeGesture.direction = .down
        messageView.addGestureRecognizer(downSwipeGesture)
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleUp(_:)))
        upSwipeGesture.direction = .up
        messageView.addGestureRecognizer(upSwipeGesture)
    }

    @objc func handleUp(_ gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.4) {
            self.messageHeightConstant.constant = 200
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func handleDown(_ gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.4) {
            self.messageHeightConstant.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
    
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=-12.1354657,-77.02224&destination=\(destination.latitude),\(destination.longitude)&mode=walking&key=AIzaSyDCK9g4uqPTkM_-BPKAZfvK2BPF7wsoLJM")!
        print(url)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                print(error!.localizedDescription)
                return
            }
            let json = JSON(data)
            print(json)
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult else {
                print("error in JSONSerialization")
                return
            }

            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            print(routes)

            if routes.count > 0 {
                guard let route = routes[0] as? [String: Any] else {
                    return
                }

                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    return
                }

                guard let polyLineString = overview_polyline["points"] as? String else {
                    return
                }
                self.drawPath(from: polyLineString, coordinates: CLLocationCoordinate2D.init(latitude: destination.latitude, longitude: destination.longitude))
            }else {
                print("No hay rutas")
            }
         
            
            //Call this method to draw path on map
            
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String, coordinates: CLLocationCoordinate2D){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
        let marker = GMSMarker(position: coordinates)
        marker.map = mapView
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 17.0)
        print(locValue)
        fetchRoute(from: locValue, to: CLLocationCoordinate2D.init(latitude: -12.134820, longitude: -77.017359))
        self.mapView?.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1001) as! UILabel
        label.text = categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let label = cell?.contentView.viewWithTag(1001) as! UILabel
        label.textColor = .blue
        print(categories[indexPath.row])
    }
}
