//
//  ViewController.swift
//  Waterworld
//
//  Created by Vladimir Kavlakan on 2/6/18.
//  Copyright © 2018 Vladimir Kavlakan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewFrame: CGRect!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionViewFrame == nil || collectionView.frame.equalTo(collectionViewFrame) == false {
            collectionViewFrame = collectionView.frame
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setNeedsLayout()
        }
    }
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = Game()
        game.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @IBAction func restart(_ sender: Any) {
        game.restart()
    }
    
}



// MARK: - Game delegate
extension ViewController: GameDelegate {
    func gameRestarted(_ game: Game) {
        collectionView.reloadData()
    }
    
    func gameDidTurn(_ game: Game) {
        collectionView.reloadData()
    }
    
    func gameEnded(_ game: Game) {
        let alertController = UIAlertController(title: "Game over", message: nil, preferredStyle: .alert)
        let restart = UIAlertAction(title: "Restart", style: UIAlertActionStyle.destructive) { (_) in
            game.restart()
        }
        alertController.addAction(restart)
        present(alertController, animated: true, completion: nil)
    }
}



// MARK: - Collection view delegate flow layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalItemCount = game.board.size.width
        let itemWidth = floor(collectionView.bounds.width / CGFloat(horizontalItemCount))
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



// MARK: - Collection view delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        game.makeTurn()
    }
}



// MARK: - Collection view data source
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.board.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = game.board.inhabitant(at: indexPath.item)?.image
        return cell
    }
    
}
