//
//  AllCharactersViewController.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 16/10/2024.
//

import UIKit
import RickMortySwiftApi
import Combine
import Kingfisher
import Reachability
import SwiftUI

class AllCharactersViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet weak var unknownButton: UIButton!
    @IBOutlet weak var deadButton: UIButton!
    @IBOutlet weak var aliveButton: UIButton!
    
    var savedStated  = "none"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dialogFullScreenView: UIView?
    var dialogLoadingGroup: STLoadingGroup?
    let rmClient = RMClient()
    var charactersVm = CharacterService()
    var characters: [RMCharacterModel] = []
    
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
       
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = "Characters"
        label.textAlignment = .left
      
        let stackView = UIStackView(arrangedSubviews: [label])
            stackView.distribution = .equalSpacing
            stackView.alignment = .leading
            stackView.axis = .vertical

            let customTitle = UIBarButtonItem.init(customView: stackView)
            self.navigationItem.leftBarButtonItems = [customTitle]
       
        
        collectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "charactersviewcell")
        unknownButton.addRoundedCorner(bg: .white)
        deadButton.addRoundedCorner(bg: .white)
        aliveButton.addRoundedCorner(bg: .white)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
            Task.detached {
                if await self.isNetworkConnected() {
                    await self.showProgressDialog()
                    if await self.savedStated == "none" {
                        await self.fetchCharacters()
                    } else if await self.savedStated == "Alive" {
                        await self.fetchAliveCharacters()
                    }else if await self.savedStated == "Dead" {
                        await self.fetchDeadCharacters()
                    }else if await self.savedStated == "Unknown" {
                        await self.fetchUnknownCharacters()
                    }
                    await self.hideProgressDialog()
                }else{
                    await self.showErrorMessage(Utils.localizedString(forKey:"noNetworkConnected"))
                }
            }
       
    }
    
   
    func fetchCharacters() async {
        do {
            characters = try await rmClient.character().getAllCharacters()
            self.collectionView.reloadData()
        } catch (let error) {
          print(error)
        }
    }
    
    func fetchAliveCharacters() async {
            characters = charactersVm.filteredCharacters(filter: .alive)
             self.collectionView.reloadData()
        
    }
    
    func fetchDeadCharacters() async {
            characters = charactersVm.filteredCharacters(filter: .dead)
             self.collectionView.reloadData()
        
    }
    
    func fetchUnknownCharacters() async {
        characters = charactersVm.filteredCharacters(filter: .unknown)
             self.collectionView.reloadData()
        
    }
    
    
    public func showProgressDialog(){
        dialogLoadingGroup = STLoadingGroup(side: 80, style: .arch)
        
        if dialogFullScreenView == nil {
            dialogFullScreenView = UIView(frame: self.view.frame)
            dialogFullScreenView?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 0.3)
        }
        
        if !(dialogFullScreenView?.isDescendant(of: self.view))!{
            self.view.addSubview(dialogFullScreenView!)
            dialogFullScreenView?.fillScreenLayoutConstrains()
        }
        
        dialogLoadingGroup?.show(dialogFullScreenView)
        dialogLoadingGroup?.startLoading()
    }
    
    public func hideProgressDialog(){
        dialogLoadingGroup?.stopLoading()
        dialogFullScreenView?.removeFromSuperview()
    }
    
    public func showErrorMessage(_ message: String){
        UIHelper.showErrorMessage(message)
    }
    
    public func isNetworkConnected () async -> Bool{
        do  {
            let reachability = try Reachability()
            return reachability.connection != .unavailable
        }catch (let error) {
            print(error)
          }
       return false
    }
    
    public func showNoNetworkConnectedMessage(){
        UIHelper.showErrorMessage(Utils.localizedString(forKey: "noNetworkConnected"))
    }
    
    
    @IBAction func fetchAliveCharacters(_ sender: Any) {
       characters = charactersVm.filteredCharacters(filter: .alive)
        self.collectionView.reloadData()
        
    }
    
    
    @IBAction func fetchDeadCharacters(_ sender: Any) {
        characters = charactersVm.filteredCharacters(filter: .dead)
        self.collectionView.reloadData()
    }
    
    
    @IBAction func fetchUnknownCharacters(_ sender: Any) {
        characters = charactersVm.filteredCharacters(filter: .unknown)
        self.collectionView.reloadData()
    }
    

}
extension AllCharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var view = CharacterDetailSwiftUIView(rmClient: rmClient, index: indexPath.row, characters: characters)
        view.presentingVC = self
        let hostingVC = UIHostingController(rootView: view )
        present(hostingVC, animated: true, completion: nil)
      
        }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        var cell : CharacterCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charactersviewcell", for: indexPath) as! CharacterCollectionViewCell
       
        
       if characters[indexPath.row].image != "" {
            let imageurl = URL(string: characters[indexPath.row].image)
            if ((imageurl) != nil){
               
                let processor = RoundCornerImageProcessor(cornerRadius:50)
                cell.elfimage.kf.setImage(with: imageurl, placeholder: nil, options: [.processor(processor)])
                
              
            }
        }
        
        
        cell.name.text = characters[indexPath.row].name
        cell.species.text = characters[indexPath.row].species
        
        cell.view.layer.cornerRadius = 20
        cell.view.layer.masksToBounds = true
        cell.view.layer.borderWidth = 0.5
        cell.view.layer.borderColor = UIColor.lightGray.cgColor
        
        if characters[indexPath.row].species == "Human" {
            let lightblue = UIColor.brightSkyBlue // 1.0 alpha
            let semi = lightblue.withAlphaComponent(0.1) // 0.1 alpha
            cell.view.backgroundColor = semi
        }else if characters[indexPath.row].species == "Dwarf" {
            let lightpink = UIColor.systemPink // 1.0 alpha
            let semi = lightpink.withAlphaComponent(0.1) // 0.1 alpha
            cell.view.backgroundColor = semi
            }else if characters[indexPath.row].species == "Alien" {
                let lightpink = UIColor.systemPink // 1.0 alpha
                let semi = lightpink.withAlphaComponent(0.1) // 0.1 alpha
                cell.view.backgroundColor = semi
            }else{
                cell.view.backgroundColor = .white
            }

        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let kHeight = 128
            return CGSizeMake(collectionView.bounds.size.width, CGFloat(kHeight))
    }
    
}

