//
//  TikTokViewController.swift
//  uiNavigationController
//
//  Created by Miguel on 14/11/24.
//

import UIKit

class TikTokViewController: UIViewController {

    @IBOutlet weak var tiktokCollectionView: UICollectionView!
    @IBOutlet weak var tiktokCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        tiktokCollectionViewFlowLayout.scrollDirection = .vertical
        tiktokCollectionViewFlowLayout.minimumLineSpacing = 0

        tiktokCollectionView.setCollectionViewLayout(tiktokCollectionViewFlowLayout, animated: false)
        tiktokCollectionView.isPagingEnabled = true
        tiktokCollectionView.dataSource = self
        tiktokCollectionView.delegate = self
        tiktokCollectionView.decelerationRate = .fast
        tiktokCollectionView.backgroundColor = .black
        tiktokCollectionView.contentInsetAdjustmentBehavior = .never  // Disabled automatic adjust of safe area in CollectionView
        tiktokCollectionView.register(UINib(nibName: "TikTokCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TikTokCollectionViewCell")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TikTokViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TikTokCollectionViewCell", for: indexPath) as! TikTokCollectionViewCell
        return cell
    }
}

extension TikTokViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tiktokCollectionView.frame.width, height: tiktokCollectionView.frame.height) // Cell size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Space between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Space between columns
    }
}
