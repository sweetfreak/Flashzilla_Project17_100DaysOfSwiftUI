//
//  CardView.swift
//  Flashzilla
//
//  Created by Jesse Sheehan on 10/19/24.
//

import SwiftUI

struct CardView: View {
    
    @State private var offset = CGSize.zero //no drag, by default
    @State private var isShowingAnswer = false
    
    let card: Card
    var removal: (() -> Void)? = nil // takes no parameters, returns nothing.
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        //this order matters, especially with offsets and rotations!
        .frame(width: 450, height: 250) // this is the smallest iPhone's biggest size
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50))) // when this is above 1, it'll be opaque (good), but as you get further than 50 pts (pixels?) away, it'll start to become translucent
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        //remove the card
                        removal?() // will only called if it has a value)
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

#Preview {
    CardView(card: .example)
}