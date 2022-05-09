//
//  SentMemeCollectionViewController.swift
//  MemeMe2
//
//  Created by Ashrakat Sherif on 10/10/2021.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    var memes = [Meme]()
    
    

    @IBOutlet weak var memeCollectionView:UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
        
        let itemSize = UIScreen.main.bounds.width/3 - 3
        
        
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        flowLayout.itemSize = CGSize(width: itemSize, height:itemSize)
        flowLayout.sectionInset = UIEdgeInsets(top:20, left:0, bottom:10, right:0)
    }
    
    override func  viewWillAppear ( _ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        memeCollectionView.reloadData()
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let memeGeneratorVC = storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as! MemeEditorViewController
        
        present(memeGeneratorVC, animated: true, completion: nil)
        
    }
    
}
extension MemeCollectionViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.cellImageView.image = meme.memedImage
        
        
        return cell
    }
    func collectionView (_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeGeneratorVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetail
    
        memeGeneratorVC.meme = memes[indexPath.row]
        present(memeGeneratorVC, animated: true, completion: nil)
    }
}

