//
//  ContentView.swift
//  Flashzilla
//
//  Created by Jesse Sheehan on 10/16/24.
//

import SwiftUI

/* //Day 86 - disabling user interactivity with allowsHitTesting() and enabling with contentShape(.rect)
struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Hello")
            Spacer()
                .frame(height: 100)
            Text("World")
        }
        .contentShape(.rect) // without this, only the words were tappable, but now the inbetween space is tappable, too
        .onTapGesture {
            print("VStack Tapped")
        }
        
        /*        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle Tapped")
                }
            Circle()
                .fill(.red)
                .frame(width: 300, height: 300)
                .contentShape(.rect) // now even outside the circle will be tapped as if it was the circle.
                .onTapGesture {
                    print("Circle Tapped")
                }
               // .allowsHitTesting(false) //this will ignore the circle!
        }
        */
    }
}
 */

/* //DAY 86 - Swift Gestures
struct ContentView: View {
    
    @State private var currentAmount = 0.0
    @State private var currentAngle = Angle.zero
    @State private var finalAmount = 1.0
    @State private var finalAngle = Angle.zero
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }
        
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        let combined = pressGesture.sequenced(before: dragGesture)
        
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
        
        /*
        VStack {
            Text("Hello, world!")
                .onTapGesture {
                    //if multiple gestures could be triggered, SwiftUI uses the child gesture, however you can change that with the high priority tag
                    print("Text Tapped")
                }
        }
        /* Don't use this if you want this prioritized!
        .onTapGesture {
            print("VStack Tapped")
        }
        */
        //.highPriorityGesture(
        .simultaneousGesture( // this - triggers BOTH
            TapGesture()
                .onEnded {
                    print("VStack Tapped")
                }
            
        )
        */
        
            /*
             Text("Hello, world!")
            /*
                .onTapGesture(count: 4) {
                    print("Quadruple Tapped!")
                }
                .onLongPressGesture(minimumDuration: 2) {
                    print("Long pressed - 2 seconds")
                } onPressingChanged: { inProgress in
                    print("In progress: \(inProgress)")
                }
            */
                //.scaleEffect(finalAmount + currentAmount)
                .rotationEffect(currentAngle + finalAngle)
                .gesture(
                    /*
                    MagnifyGesture()
                        .onChanged { value in
                            currentAmount = value.magnification - 1
                        }
                        .onEnded { value in
                            finalAmount += currentAmount
                            currentAmount = 0
                        }
                     */
                    /*
                    RotateGesture()
                        .onChanged { value in
                            currentAngle = value.rotation
                        }
                        .onEnded { value in
                            finalAngle += currentAngle
                            currentAngle = .zero
                        }
                     */
                    )
             */
    }
}
 */

#Preview {
    ContentView()
}
