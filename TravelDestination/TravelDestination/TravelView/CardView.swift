//
//  CardView.swift
//  TravelDestination
//
//  Created by ashika kalmady on 8/2/24.
//

import SwiftUI

/// View to display a single destination card
struct CardView: View {
    var destination: Destination
   
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .overlay {
                    Image(destination.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(width: 330, height: 500)
                        .overlay(
                            Text(destination.name)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .padding(),
                            alignment: .leading
                        )
                }
                .frame(width: 340, height: 510)
            
            if destination.showHeart {
               Text("❤️")
                    .font(.system(size: 200))
                    .transition(.scale)
                    .opacity(destination.showHeart ? 1 : 0)
                    .animation(.easeInOut, value: destination.showHeart)
            }
            
            if destination.showSadFace {
                Text("🙁")
                    .font(.system(size: 200))
                    .transition(.scale)
                    .opacity(destination.showSadFace ? 1 : 0)
                    .animation(.easeInOut, value: destination.showSadFace)
            }
        }
    }
}


#Preview {
    CardView(destination: Destination(name: "Paris", imageName: "Paris,France"))
}
