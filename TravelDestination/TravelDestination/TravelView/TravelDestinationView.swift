//
//  TravelDestinationView.swift
//  TravelDestination
//
//  Created by ashika kalmady on 8/2/24.
//

import SwiftUI

/// View to display a stack of swipable destination cards
struct TravelDestinationView: View {
    @State private var destinations: [Destination] = [
        Destination(name: "Agra, India", imageName: "Agra,India"),
        Destination(name: "Lisbon, Portugal", imageName: "Lisbon,Portugal"),
        Destination(name: "Paris, France", imageName: "Paris,France"),
        Destination(name: "London, UK", imageName: "London,Uk"),
        Destination(name: "Oregon, USA", imageName: "Oregon,USA"),
        Destination(name: "Sydney, Australia", imageName: "Sydney,Australia")
    ]
    
    @State private var currentIndex: Int = 0
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scaleEffect: Double = 1
    @State private var initialOffsets: [CGSize] = []
    @State private var initialRotations: [Double] = []
    @State private var opacity: Double = 1.0
    @State private var showWishlistHeart: Bool = false
    @State private var heartPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
    @State private var heartScale: CGFloat = 1.0
    @State private var heartOpacity: Double = 1.0
    @State private var wishlistCount: Int = 0
    
    init() {
        // Initialize the random offsets and rotations
        var offsets: [CGSize] = []
        var rotations: [Double] = []
        for _ in destinations.indices {
            offsets.append(CGSize(width: Double.random(in: -10...10), height: Double.random(in: -10...10)))
            rotations.append(Double.random(in: -10...10))
        }
        _initialOffsets = State(initialValue: offsets)
        _initialRotations = State(initialValue: rotations)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(destinations.indices, id: \.self) { index in
                    if index >= currentIndex {
                        CardView(destination: destinations[index])
                            .offset(index == currentIndex ? offset : initialOffsets[index])
                            .rotationEffect(.degrees(index == currentIndex ? rotation : initialRotations[index]))
                            .opacity(index == currentIndex ? opacity : 1.0)
                            .scaleEffect(index == currentIndex ? scaleEffect : 1)
                            .animation(.spring(), value: offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        offset = gesture.translation
                                        rotation = Double(gesture.translation.width / 20)
                                        let progress = gesture.translation.width / UIScreen.main.bounds.width
                                        scaleEffect = 1 - abs(progress * 0.5)
                                        opacity = 1 - abs(progress * 0.5)
                                        
                                        withAnimation {
                                            destinations[index].showHeart = gesture.translation.width > 20
                                            destinations[index].showSadFace = gesture.translation.width <= 20
                                        }
                                    }
                                    .onEnded { gesture in
                                        if abs(gesture.translation.width) > 150 {
                                            // Swiped sufficiently left or right
                                            withAnimation {
                                                offset = CGSize(width: gesture.translation.width > 0 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width, height: 0)
                                                rotation = gesture.translation.width > 0 ? 30 : -30
                                                if gesture.translation.width > 0 {
                                                    destinations[currentIndex].isWishListed = true
                                                    showWishlistHeartEffect()
                                                }
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                currentIndex += 1
                                                resetCardStates()
                                            }
                                        } else {
                                            // Revert to original position
                                            resetCardStates()
                                        }
                                    }
                            )
                            .zIndex(Double(destinations.count - index))
                    }
                }
                
                // Wishlist Heart Effect
                if showWishlistHeart {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                        .scaleEffect(heartScale)
                        .transition(.scale)
                        .opacity(heartOpacity)
                        .position(heartPosition)
                        .zIndex(Double(destinations.count))
                }
            }
            .padding()
            .navigationTitle("Travel Destinations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: WishlistView(destinations: $destinations)) {
                        Image(systemName: wishlistCount > 0 ?  "heart.fill" :  "heart")
                            .font(.system(size: 30))
                        
                    }
                }
            }
        }
    }
    
    /// Shows the heart animation when a destination is added to the wishlist
    private func showWishlistHeartEffect() {
           // Reset the heart's initial state before starting the animation
           heartPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
           heartScale = 1.0
           heartOpacity = 1.0
           
           withAnimation {
               showWishlistHeart = true
               heartScale = 1.5
           }
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               withAnimation {
                   heartScale = 1.0
                   heartPosition = CGPoint(x: UIScreen.main.bounds.width - 40, y: -80) // Top-right corner position
               }
           }
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               withAnimation {
                   heartScale = 0.1
                   heartOpacity = 0.0
               }
           }
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               showWishlistHeart = false
               resetHeartState()
               updateWishlistCount()
           }
       }
    
    /// Updates the count of wishlisted destinations
    private func updateWishlistCount() {
           wishlistCount = destinations.filter { $0.isWishListed }.count
       }
    
    /// Resets the heart's state after the animation
    private func resetHeartState() {
           heartPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
           heartScale = 1.0
           heartOpacity = 1.0
       }
    
    /// Resets the state of the cards after a swipe
    private func resetCardStates() {
        offset = .zero
        rotation = 0
        scaleEffect = 1
        opacity = 1
        for index in destinations.indices {
            destinations[index].showHeart = false
            destinations[index].showSadFace = false
        }
    }
    
    /// Generates a random offset for the cards
    private func randomOffset(for index: Int) -> CGSize {
        return CGSize(width: Double.random(in: -10...10), height: Double.random(in: -10...10))
    }
    
    /// Generates a random rotation for the cards
    private func randomRotation(for index: Int) -> Double {
        return Double.random(in: -10...10)
    }
}


#Preview {
    TravelDestinationView()
}
