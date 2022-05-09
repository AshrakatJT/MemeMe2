//
//  SentMemeTableViewController.swift
//  MemeMe2
//
//  Created by Ashrakat Sherif on 10/10/2021.
//

import UIKit

class MemeTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var  memes = [Meme]()
    

    @IBOutlet weak var memeTableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        memeTableView.delegate = self
        memeTableView.dataSource = self
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func  viewWillAppear ( _ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        memeTableView.reloadData()
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    let memeGeneratorVC = storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as! MemeEditorViewController
        present(memeGeneratorVC, animated: true, completion: nil)
    }


}

extension MemeTableViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath)
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        
        return cell
    }
    
    
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeGeneratorVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetail
        
        memeGeneratorVC.meme = memes[indexPath.row]
        present(memeGeneratorVC, animated: true, completion: nil)
    }
}

