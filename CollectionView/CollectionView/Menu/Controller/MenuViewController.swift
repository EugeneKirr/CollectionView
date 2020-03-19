//
//  MenuViewController.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 18/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var amountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var repeatedSegmentedControl: UISegmentedControl!

    @IBAction func tapPlayButton(_ sender: UIButton) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let collectionVC = main.instantiateViewController(identifier: "CollectionVC") as? CollectionViewController else { return }
        collectionVC.delegate = self
        self.navigationController?.pushViewController(collectionVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension MenuViewController: CollectionViewControllerDelegate {
    
    var cellAmount: Int {
        return 8*(amountSegmentedControl.selectedSegmentIndex + 1)
    }
    var repeatedValues: Int {
        return Int(pow(2.0, Double(repeatedSegmentedControl.selectedSegmentIndex + 1) ))
    }
    
}
