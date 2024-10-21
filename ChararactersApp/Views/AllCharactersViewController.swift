//
//  AllCharactersViewController.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 16/10/2024.
//

import UIKit
import SDWebImage
import Pagination
import Combine
import Reachability
import SwiftUI

class AllCharactersViewController: UIViewController, UINavigationBarDelegate{
  
    private var dataSource: UICollectionViewDiffableDataSource<Int, CharacterDetailViewModel>!

    @IBOutlet weak var unknownButton: UIButton!
    @IBOutlet weak var deadButton: UIButton!
    @IBOutlet weak var aliveButton: UIButton!
    
    var savedState  = "none"
    
    private var currentPage: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dialogFullScreenView: UIView?
    var dialogLoadingGroup: STLoadingGroup?
    var characterService = CharacterService()
    var characters: [Characters] = []
    
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
        
        self.dataSource = .init(collectionView: collectionView) {collectionView, indexPath, characterViewModel in
             
            let cell =
               collectionView.dequeueReusableCell(withReuseIdentifier: "charactersviewcell", for: indexPath)
               as! CharacterCollectionViewCell
            if characterViewModel.image != "" {
                 let imageurl = URL(string: characterViewModel.image)
                 if ((imageurl) != nil){
                    
                     cell.elfimage.sd_setImage(with: imageurl)
                     cell.elfimage.layer.cornerRadius = 25;
                     cell.elfimage.layer.masksToBounds = true;
                     
                   
                 }
             }
             
             
             cell.name.text = characterViewModel.name
             cell.species.text = characterViewModel.species
             
             cell.view.layer.cornerRadius = 20
             cell.view.layer.masksToBounds = true
             cell.view.layer.borderWidth = 0.5
             cell.view.layer.borderColor = UIColor.lightGray.cgColor
             
             if characterViewModel.species == "Human" {
                 let lightblue = UIColor.brightSkyBlue // 1.0 alpha
                 let semi = lightblue.withAlphaComponent(0.1) // 0.1 alpha
                 cell.view.backgroundColor = semi
             }else if characterViewModel.species == "Dwarf" {
                 let lightpink = UIColor.systemPink // 1.0 alpha
                 let semi = lightpink.withAlphaComponent(0.1) // 0.1 alpha
                 cell.view.backgroundColor = semi
                 }else if characterViewModel.species == "Alien" {
                     let lightpink = UIColor.systemPink // 1.0 alpha
                     let semi = lightpink.withAlphaComponent(0.1) // 0.1 alpha
                     cell.view.backgroundColor = semi
                 }else{
                     cell.view.backgroundColor = .white
                 }

             
             return cell
           }
        
        collectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "charactersviewcell")
        unknownButton.addRoundedCorner(bg: .white)
        deadButton.addRoundedCorner(bg: .white)
        aliveButton.addRoundedCorner(bg: .white)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.pagination.isEnabled = true
        collectionView.pagination.direction = .vertical
        collectionView.pagination.delegate = self
        collectionView.pagination.leadingScreensForPrefetching = 20
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        Task.detached { [self] in
            
                if await self.isNetworkConnected() {
                    await self.fetchCharacters()
                }else{
                    await self.showErrorMessage(Utils.localizedString(forKey:"noNetworkConnected"))
                }
            }
       
    }
    
   
    func fetchCharacters() {
        characters = characterService.getCharacters()
        
     
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
     
            self.characters = self.characterService.filteredCharacters(filter: .alive)
            self.savedState = "Alive"
        let filteredVC = FilteredCharactersViewController(nibName: "FilteredCharactersViewController", bundle: nil)
        filteredVC.savedState = self.savedState
        self.navigationController?.pushViewController(filteredVC, animated: true)
    
     
    }
    
    
    @IBAction func fetchDeadCharacters(_ sender: Any) {
 
            self.characters = self.characterService.filteredCharacters(filter: .dead)
            self.savedState = "Dead"
        let filteredVC = FilteredCharactersViewController(nibName: "FilteredCharactersViewController", bundle: nil)
        filteredVC.savedState = self.savedState
        self.navigationController?.pushViewController(filteredVC, animated: true)
   
    }
    
    
    @IBAction func fetchUnknownCharacters(_ sender: Any) {
      
            self.characters = self.characterService.filteredCharacters(filter: .unknown)
            self.savedState = "Unknown"
        let filteredVC = FilteredCharactersViewController(nibName: "FilteredCharactersViewController", bundle: nil)
        filteredVC.savedState = self.savedState
        self.navigationController?.pushViewController(filteredVC, animated: true)
        
    }
    
    @MainActor func updateCharacters(with charactersResult: CharactersResult) {
        var snapshot = dataSource.snapshot()
        if snapshot.sectionIdentifiers.isEmpty {
          snapshot.appendSections([0])
        }
        let sectionItems = (charactersResult.results ?? [])
            .map({CharacterDetailViewModel(name: $0.name, image: $0.image, species: $0.species, gender: $0.gender.rawValue, status: $0.status.rawValue, location: $0.location.name)})
        snapshot.appendItems(sectionItems, toSection: 0)
        dataSource.apply(snapshot)
      }
    
    func loadCharacters(using pagination: Pagination, in context: PaginationContext) {
        context.start()
        Task {
          do {
            let nextPage = currentPage + 1
              var charactersResult: CharactersResult = CharactersResult(results: [])
              if self.savedState == "none" {
                  charactersResult  = try await characterService.getPaginatedCharacters(page: nextPage)
              }else if self.savedState == "Alive" {
                  charactersResult  = try await characterService.getPaginatedFilteredCharacters(page: nextPage, statusFilter: .alive)
              }else if self.savedState == "Dead" {
                  charactersResult  = try await characterService.getPaginatedFilteredCharacters(page: nextPage, statusFilter: .dead)
              }else if self.savedState == "Unknown" {
                  charactersResult  = try await characterService.getPaginatedFilteredCharacters(page: nextPage, statusFilter: .unknown)
              }
              self.updateCharacters(with: charactersResult)
            self.currentPage = nextPage
              charactersResult.totalPages = self.currentPage
              
              if let totalPages = charactersResult.totalPages {
              pagination.isEnabled = self.currentPage <= totalPages
            }
            context.finish(true)
          } catch {
            context.finish(false)
          }
        }
      }
    

}
extension AllCharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource, PaginationDelegate {
   

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var view = CharacterDetailSwiftUIView()
        view.characters = CharacterDetailViewModel(name: characters[indexPath.item].name, image: characters[indexPath.item].image, species: characters[indexPath.item].species, gender: characters[indexPath.item].gender.rawValue, status: characters[indexPath.item].status.rawValue, location: characters[indexPath.item].location.name)
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
               
                cell.elfimage.sd_setImage(with: imageurl)
                cell.elfimage.layer.cornerRadius = 25;
                cell.elfimage.layer.masksToBounds = true;
                
              
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
    
    func pagination(_ pagination: Pagination, prefetchNextPageWith context: PaginationContext) {
        Task.detached{
            await self.showProgressDialog()
            await self.loadCharacters(using: pagination, in: context)
            await self.hideProgressDialog()
        }
    }
    
}

