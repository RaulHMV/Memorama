//
//  juegoViewController.swift
//  Memorama
//
//  Created by Victor on 12/5/25.
//

import UIKit

class juegoViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var clvTablero: UICollectionView!
    
    @IBOutlet weak var lblTiempo: UILabel!
    
    @IBOutlet weak var lblPuntos: UILabel!
    
    
    @IBAction func Salir(_ sender: UIButton) {
    }
}
