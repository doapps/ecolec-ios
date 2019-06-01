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
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyCNdN_RVfg_3Gm_GHAGFlmqOW1FBpWOzWc")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            
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
                self.drawPath(from: polyLineString)
            }else {
                print("No hay rutas")
            }
         
            
            //Call this method to draw path on map
            
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        fetchRoute(from: (location?.coordinate)!, to: CLLocationCoordinate2D.init(latitude: -12.177010, longitude: -76.993988))
        self.mapView?.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
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
