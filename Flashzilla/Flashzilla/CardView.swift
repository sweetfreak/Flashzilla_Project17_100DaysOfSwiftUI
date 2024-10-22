//
//  CardView.swift
//  Flashzilla
//
//  Created by Jesse Sheehan on 10/19/24.
//

import SwiftUI

extension Shape {
    func fill(using offset: CGSize) -> some View {
        if offset.width == 0 {
            self.fill(.white)
        } else if offset.width < 0 {
            self.fill(.red)
        } else {
            self.fill(.green)
        }
    }
}

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @State private var offset = CGSize.zero //no drag, by default
    @State private var isShowingAnswer = false
    
    let card: Card
    var removal: ((Bool) -> Void)? = nil // takes no parameters, returns nothing.
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1-Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25)
                        .fill(using: offset)
                        //.fill(offset.width == 0 ? .white :
                        //offset.width > 0 ? .green : .red)
                    //ternary inside a ternary is a bad idea!
                )
                .shadow(radius: 10)
            
            VStack {
                //more accessiible:
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
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
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        //remove the card
                        if offset.width > 0 {
                            removal?(false) // will only be called if it has a value)
                        } else {
                            removal?(true)
                            offset = .zero
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}
