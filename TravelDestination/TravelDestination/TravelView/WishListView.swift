//
//  WishListView.swift
//  TravelDestination
//
//  Created by ashika kalmady on 8/2/24.
//

import SwiftUI

/// View to display the wishlist of destinations
struct WishlistView: View {
    @Binding var destinations: [Destination]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(destinations.filter { $0.isWishListed }) { destination in
                        DestinationGridItemView(destination: destination)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.5), value: destination)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Wishlist")
        }
    }
}

/// View to display a single destination in the wishlist grid
struct DestinationGridItemView: View {
    var destination: Destination
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(destination.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
                .cornerRadius(10)
            
            Text(destination.name)
                .font(.headline)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 5)
    }
}
