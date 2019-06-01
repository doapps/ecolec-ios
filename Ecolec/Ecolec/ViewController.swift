//
//  ViewController.swift
//  Ecolec
//
//  Created by Nicolas on 6/1/19.
//  Copyright © 2019 Nicolas. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageHeightConstant: NSLayoutConstraint!
    
    var categories: [String] = ["Todos", "Carton", "Vidrios", "Plastico", "Metal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

