//
//  CharacterDetailSwiftUIView.swift
//  ChararactersApp
//
//  Created by Dina Mansour  on 17/10/2024.
//

import SwiftUI
import RickMortySwiftApi
import Kingfisher

struct CharacterDetailSwiftUIView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var path = NavigationPath()
    var rmClient = RMClient()
    var index: Int = 0
    var characters: [RMCharacterModel] = []
    
   
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ZStack(alignment: .topLeading) {
                            
                            
                            if URL(string: characters[index].image) != nil {
                                KFImage(URL(string: characters[index].image))
                                    .cancelOnDisappear(true)
                                    .placeholder {
                                    ZStack {
                                        Color(.black)
                                            Image("morty")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .layoutPriority(-1)
                                                                }
                                                            }
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
                                    .padding(.vertical, 20)
                            }
                            
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 150) {
                                
                                Text(characters[index].name)
                                    .font(.title2.bold())
                                    .padding(.horizontal, 8)
                                Text(characters[index].status)
                                    .font(.callout)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5.0)
                                            .fill(.blue.opacity(0.3))
                                    )
                                    .padding(.horizontal, 8)
                            }
                            
                            
                            
                            
                            
                            
                            
                            HStack {
                                
                                Text(characters[index].species)
                                    .font(.title2)
                                    .foregroundStyle(Color(.systemGray))
                                    .padding(.horizontal, 8)
                                
                                Text(" . ")
                                    .font(.title2)
                                    .foregroundStyle(Color(.systemGray))
                                
                                
                                Text(characters[index].gender)
                                    .font(.title2)
                                    .foregroundStyle(Color(.systemGray))
                                
                            }
                            
                            
                            HStack {
                                Text("Location   :")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal, 8)
                                
                                Text(characters[index].location.name)
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
