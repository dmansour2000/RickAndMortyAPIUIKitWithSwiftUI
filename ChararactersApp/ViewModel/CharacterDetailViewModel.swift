//
//  CharacterDetailViewModel.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 20/10/2024.
//

struct CharacterDetailViewModel: Hashable {
    let name: String
    let image: String
    let species: String
    let gender: String
    let status: String
    let location: String


    init(name: String, image: String, species: String, gender: String, status: String, location: String) {
        self.name = name
        self.image = image
        self.species = species
        self.gender = gender
        self.status = status
        self.location = location
  }
}
