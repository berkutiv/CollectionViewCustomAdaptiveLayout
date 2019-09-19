//
//  ViewController.swift
//  CustomCollectionViewApp
//
//  Created by Tigran on 20.09.2018.
//  Copyright © 2018 Tigran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var titles = ["Water", "Watermelon", "Cola", "tralallalalallalalalallatralallalalallalalalallalalatralallalalallalalalallalalalala", "Da", "Sho", "La","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La", "Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La", "Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La", "Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La", "Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da", "Sho", "La","Water", "Watermelon", "Cola", "tralallalalallalalalallalala", "Da"]
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var numbers = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...20 {
            numbers.append(i)
        }
        
        let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout
        layout?.delegate = self
    }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
}

//MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if traitCollection.horizontalSizeClass == .compact {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCellCollectionViewCell
            cell.numberLabel.text = titles[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "padCell", for: indexPath) as! PadCollectionViewCell
            cell.number.text = "Pad " + titles[indexPath.row]
            
            return cell
        }
    }
}

//MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            cell.transform = .identity
        }, completion: nil)
        
    }
}


extension ViewController: CustomCollectionViewDelegate {
    func theNumberOfItemsInCollectionView() -> Int {
        return numbers.count 
    }
    
    func getTitles() -> [String] {
        return titles
    }
    
    func getTraitCollection() -> UITraitCollection {
        return traitCollection
    }
}
