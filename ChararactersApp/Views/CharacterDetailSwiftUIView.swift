//
//  CharacterDetailSwiftUIView.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 17/10/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterDetailSwiftUIView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var path = NavigationPath()
    var character: CharacterDetailViewModel = CharacterDetailViewModel(name: "Morty", image: "https://picsum.photos/id/27/200/300", species: "Human", gender: "Male", status: "Alive", location: "Earth")
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ZStack(alignment: .topLeading) {
                            
                            
                            if URL(string: character.image) != nil {
                                WebImage(url: URL(string: character.image))
                                    .cancelOnDisappear(true)
                                
                                    .resizable()
                                    .frame(height: 300)
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(35.0)
                                
                                
                                
                                
                            }
                            Button(action: {
                                
                                self.presentationMode.wrappedValue.dismiss()
                                
                                
                                
                                
                            }) {
                                Image(systemName: "arrow.backward").padding()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 70.0)
                                            .fill(.white)
                                    )
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 30)
                            }
                            
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 150) {
                                
                                Text(character.name)
                                    .font(.title2.bold())
                                    .padding(.horizontal, 8)
                                Text(character.status)
                                    .font(.callout)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5.0)
                                            .fill(.blue.opacity(0.3))
                                    )
                                    .padding(.horizontal, 8)
                            }
                            
                            
                            
                            
                            
                            
                            
                            HStack {
                                
                                Text(character.species)
                                    .font(.title2)
                                    .foregroundStyle(Color(.systemGray))
                                    .padding(.horizontal, 8)
                                
                                Text(" . ")
                                    .font(.title2)
                                    .foregroundStyle(Color(.systemGray))
                                
                                
                                Text(character.gender)
                                    .font(.title2)
                                    .foregroundStyle(Color(.systemGray))
                                
                            }
                            
                            
                            HStack {
                                Text("Location   :")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal, 8)
                                
                                Text(character.location)
                                    .font(.title3)
                                
                            }
                            
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .preferredColorScheme(.light)
            }
            
        }
        .navigationBarHidden(true)
        
    }
    
}




#Preview {
    CharacterDetailSwiftUIView()
}
