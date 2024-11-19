//
//  TikTokViewController.swift
//  uiNavigationController
//
//  Created by Miguel on 14/11/24.
//

import UIKit

struct TikTokData {
    var user: String
    var profileImage: UIImage
    var description: String
    var videoName: String
}

class TikTokViewController: UIViewController {

    @IBOutlet weak var tiktokCollectionView: UICollectionView!
    @IBOutlet weak var tiktokCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var tiktokTopSectionView: UIStackView!
    @IBOutlet weak var tiktokBottomTabContainerView: UIView!
    
    var dataSource: [TikTokData] = [
        .init(user: "Miguel Zabala F.", profileImage: ._1, description: "This is my first post in this TikTok clone 😮‍💨", videoName: "video1"),
        .init(user: "Migue", profileImage: ._2, description: "What's up my friends 🫡, this is my second post in this TikTok clone", videoName: "video2"),
        .init(user: "mig.code", profileImage: ._4, description: "This UI🥶 was created with storyboards!", videoName: "video3"),
        .init(user: "Miguel Zabala F.", profileImage: ._1, description: "This is my first post in this TikTok clone 😮‍💨", videoName: "video4"),
        .init(user: "Migue", profileImage: ._2, description: "What's up my friends 🫡, this is my second post in this TikTok clone", videoName: "video5"),
    ]
    
    private var previousVisibleIndex: IndexPath?
    private var hasExecutedFunctionForFirstCell = false
    private var speedContainer: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        tiktokCollectionViewFlowLayout.scrollDirection = .vertical
        tiktokCollectionViewFlowLayout.minimumLineSpacing = 0

        tiktokCollectionView.setCollectionViewLayout(tiktokCollectionViewFlowLayout, animated: false)
        tiktokCollectionView.isPagingEnabled = true
        tiktokCollectionView.showsVerticalScrollIndicator = false
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
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentCellData = dataSource[indexPath.row]
        let isTheFristCell = indexPath.row == 0
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TikTokCollectionViewCell", for: indexPath) as! TikTokCollectionViewCell
        cell.setupTikTokData(with: currentCellData, isTheFistVideo: isTheFristCell && !self.hasExecutedFunctionForFirstCell)
        self.hasExecutedFunctionForFirstCell = true
        cell.delegate = self
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

extension TikTokViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateVisibleIndex(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateVisibleIndex(scrollView)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Start to drag")
        self.updateVisibleIndex(scrollView, isDragging: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("End to drag")
        updateVisibleIndex(scrollView, isDragging: false)
    }
    
    private func updateVisibleIndex(_ scrollView: UIScrollView, isDragging: Bool = false) {
        if let collectionView = scrollView as? UICollectionView {
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            if let visibleIndexPath = collectionView.indexPathForItem(at: CGPoint(x: visibleRect.midX, y: visibleRect.midY)) {
                let visibleCell = collectionView.cellForItem(at: visibleIndexPath) as? TikTokCollectionViewCell
                // Verifica si el índice visible ha cambiado
                if previousVisibleIndex != visibleIndexPath {
                    // Pausar el video de la celda anterior si existe
                    if let previousIndex = previousVisibleIndex,
                       let previousCell = collectionView.cellForItem(at: previousIndex) as? TikTokCollectionViewCell {
                        previousCell.onPreviousCellConfiguration()
                        print("Paused previous video with index: \(previousIndex.row)")
                    }

                    // Actualizar la celda visible actual
                    if let visibleCell = visibleCell {
                        visibleCell.onVisibleCellConfiguration()
                        print("Played video with index: \(visibleIndexPath.row)")
                    }

                    // Actualiza el índice visible previo
                    previousVisibleIndex = visibleIndexPath
                    print("New previous index: \(visibleIndexPath.row)")
                }
                visibleCell?.setIsDragging(isDragging)
            }
        }
    }
}

extension TikTokViewController: TikTokCollectionViewCellDelegate {
    func onX2SpeedEnabled(_ isEnabled: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.tiktokTopSectionView.layer.opacity = isEnabled ? 0 : 1
        }
        self.onX2Configuration(isEnabled)
    }
    
    func onX2Configuration(_ isEnabled: Bool) {
        // 1. Inicializa el contenedor solo si no existe
        if speedContainer == nil {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.backgroundColor = .clear
            self.tiktokBottomTabContainerView.addSubview(container)
            
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: tiktokBottomTabContainerView.topAnchor),
                container.bottomAnchor.constraint(equalTo: tiktokBottomTabContainerView.bottomAnchor),
                container.leadingAnchor.constraint(equalTo: tiktokBottomTabContainerView.leadingAnchor),
                container.trailingAnchor.constraint(equalTo: tiktokBottomTabContainerView.trailingAnchor)
            ])
            
            // 2. Crear y configurar el StackView
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 8 // Espaciado entre elementos
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -8)
            ])
            
            // 3. Configurar elementos del StackView
            let label = UILabel()
            label.text = "Speed: 2x"
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            label.textColor = .white
            
            let x2ImageView = UIImageView(image: UIImage(systemName: "forward.fill"))
            x2ImageView.tintColor = .white
            x2ImageView.contentMode = .scaleAspectFit
            
            // Añadir elementos al StackView
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(x2ImageView)
            
            // 4. Almacena la referencia del contenedor
            self.speedContainer = container
        }
        
        guard let speedContainer = speedContainer else { return }

        // 5. Ocultar contenido de `tiktokBottomTabContainerView` excepto el contenedor
        for subview in tiktokBottomTabContainerView.subviews {
            if subview !== speedContainer {
                UIView.animate(withDuration: 0.25) {
                    subview.alpha = isEnabled ? 0 : 1
                }
            }
        }
        
        // 6. Actualizar visibilidad y animar el contenedor
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            speedContainer.alpha = isEnabled ? 1 : 0
            speedContainer.transform = isEnabled ? .identity : CGAffineTransform(translationX: 0, y: 15)
        }
    }
}
