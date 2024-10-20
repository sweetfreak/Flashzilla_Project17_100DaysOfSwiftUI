//
//  ContentView.swift
//  Flashzilla
//
//  Created by Jesse Sheehan on 10/16/24.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y:offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled

    @State private var cards = [Card]()
    @State private var showingEditScreen = false
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    
    var body: some View {
        ZStack {
            Image(decorative:"background") //voiceover won't read it out now
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again?", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) {time in
            guard isActive else {return}
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init) /*{ //this only works because it requires no initializaers
                                                                                                 EditCards()
                                                                                                 } */
        .onAppear(perform: resetCards)
        
    }
        func removeCard(at index: Int) {
            guard index >= 0 else { return }
            
            cards.remove(at: index)
            
            if cards.isEmpty {
                isActive = false
            }
        }
        
        func resetCards() {
            //cards = Array<Card>(repeating: .example, count: 10)
            timeRemaining = 100
            isActive = true
            loadData()
        }
        
        func loadData() {
            if let data = UserDefaults.standard.data(forKey: "Cards") {
                if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                    cards = decoded
                }
            }
        }
    
}

/*  //Day 87 - Support specific accessibility neds with swiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    
    
    @Environment(\.accessibilityReduceMotion) var accessibilityReduceMotion
    @State private var scale = 1.0
    
    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency
    
    
    var body: some View {
        
        VStack {
            Button("Hello World!") {
                withOptionalAnimation {
                    scale *= 1.5
                }
                
//                if accessibilityReduceMotion {
//                    scale *= 1.5
//                } else {
//                    withAnimation {
//                        scale *= 1.5
//                    }
//                }
            }
            .scaleEffect(scale)
            
            Spacer()
            
            Text("Hello, friends")
                .padding()
                .background(accessibilityReduceTransparency ? .black : .black.opacity(0.5))
                .foregroundStyle(.white)
                .clipShape(.capsule)
            
            Spacer()
            HStack {
                if accessibilityDifferentiateWithoutColor {
                    Image(systemName: "checkmark.circle")
                }
                
                Text("Success")
            }
            .padding()
            .background(accessibilityDifferentiateWithoutColor ? .black : .green)
            .foregroundStyle(.white)
            .clipShape(.capsule)
        }
    }
}
 */

/*
//Day 87 - be notified when app is in background/foreground
struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        Text("Hello, world")
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    print("Active")
                } else if newPhase == .inactive {
                    print("Inactive") //means might be active, but user can't access for some reason, like if you swipe up to switch apps, or a notification appears, or screentime, or control center is pulled down.
                } else if newPhase == .background {
                    print("Background")
                }
            }
    }
}
*/

/* //Day 87 - trigger events repeatedly using a timer
struct ContentView: View {
    
    @State private var counter = 0
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    //tolerance - optional property that allows iOS to perform timer coalescing - which is the adjusting of a timer/notification going off, which is helpful when saving battery power, but less helpful when the time needs to be closer to exact (it's best effort, though - not 100% guaranteed).
    
    var body: some View {
        Text("Hello, World")
            .onReceive(timer) { time in
                if counter == 5 {
                    timer.upstream.connect().cancel()
                } else {
                    print("The Time is now \(time)")
                }
                counter += 1
            }
    }
//    func cancelTimer() {
//        timer.upstream.connect().cancel()
//    }
}
 */


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
