//
//  WorkoutPlayer.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 16/11/2023.
//

import SwiftUI

struct WorkoutPlayerCard: View {
    
    @State var workout: Workout {
        didSet {
            WorkoutManager.shared.fetchElements(for: workout)
            workoutElementsToPlay = setUpWorkoutElements(workout.elementsObjects)
            if workoutElementsToPlay.count > 0 {
                currentElement = workoutElementsToPlay[0]
            }
            if workoutElementsToPlay.count > 1 {
                nextElement = workoutElementsToPlay[1]
            } else {
                nextElement = nil
            }
        }
    }
    @State var workoutElementsToPlay: [WorkoutElementObject]!
    @State private var currentElement: WorkoutElementObject! {
        didSet {
            if let duration = (currentElement as? Rest)?.duration ?? (currentElement as? Exercise)?.duration  {
                isPausedDisabled = false
                timerAmount = duration
            } else {
                isPausedDisabled = true
                isPaused = false
            }
        }
    }
    @State private var currentElementIndex: Int = 0
    @State private var nextElement: WorkoutElementObject?
    
    @State private var isPaused: Bool = false
    @State private var isPausedDisabled: Bool = true
    
    @State private var timerAmount = 0.0
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    init() {
        _workout = State(initialValue: WorkoutManager.shared.playingWorkout!)
        WorkoutManager.shared.fetchElements(for: workout)
        
        _workoutElementsToPlay = State(initialValue: setUpWorkoutElements(workout.elementsObjects))
        if workoutElementsToPlay.count > 0 {
            _currentElement = State(initialValue: workoutElementsToPlay[0])
        }
        if workoutElementsToPlay.count > 1 {
            _nextElement = State(initialValue: workoutElementsToPlay[1])
        } else {
            nextElement = nil
        }
        if let duration = (currentElement as? Rest)?.duration ?? (currentElement as? Exercise)?.duration  {
            isPausedDisabled = false
            _timerAmount = State(initialValue: duration)
        } else {
            isPausedDisabled = true
            isPaused = false
        }
    }
    
    var body: some View {
        let offset: CGFloat = 5
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Asset.Colors.gray3.swiftUIColor)
                .offset(y: offset)
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Asset.Colors.gray3.swiftUIColor)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Asset.Colors.gray2.swiftUIColor)
                .padding(5)
            
            VStack(spacing: 10) {
                HStack {
                    Text(workout.title)
                        .font(FontFamily.PoppinsExtraBold.regular.swiftUIFont(fixedSize: 24))
                        .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button {
                        WorkoutManager.shared.playingWorkout = nil
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 30, weight: .heavy))
                            .frame(width: 20, height: 20)
                            .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                    }
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Asset.Colors.gray3.swiftUIColor)
                    HStack(spacing: 15) {
                        if currentElement is Exercise {
                            Text((currentElement as! Exercise).title)
                                .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 20))
                                .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                                .lineLimit(2)
                                .padding(.leading, 5)
                        } else if currentElement is Rest {
                            Text("Repos")
                                .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 20))
                                .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                                .lineLimit(2)
                                .padding(.leading, 5)
                        }
                        
                        Spacer()
                        
                        if let _ = (currentElement as? Rest)?.duration ?? (currentElement as? Exercise)?.duration {
                            Text(TimeFormatter.formatToString(timeInMilliseconds: UInt(timerAmount * 1000)))
                                .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 24))
                                .foregroundColor(Asset.Colors.green.swiftUIColor)
                                .lineLimit(2)
                                .padding(.trailing, 10)
                                .onReceive(timer) { _ in
                                    guard timerAmount > 0.0 else {
                                        goToNextElement()
                                        return
                                    }
                                    if !isPaused {
                                        timerAmount -= 1
                                    }
                                }
                        } else if currentElement is Exercise {
                            Button {
                                goToNextElement()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Asset.Colors.green.swiftUIColor)
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .font(.system(size: 30, weight: .heavy))
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Asset.Colors.gray3.swiftUIColor)
                                }
                            }
                            .frame(width: 30)
                        }
                    }
                    .padding(5)
                }
                .frame(height: 80)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Asset.Colors.gray3.swiftUIColor)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.turn.down.right")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 30, weight: .heavy))
                                .frame(width: 15, height: 15)
                                .foregroundColor(Asset.Colors.gray2.swiftUIColor)
                            Text("Suivant")
                                .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 16))
                                .foregroundColor(Asset.Colors.gray2.swiftUIColor)
                                .lineLimit(2)
                            Spacer()
                        }
                        .frame(height: 18)
                        
                        if nextElement is Exercise {
                            Text((nextElement as! Exercise).title)
                                .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 20))
                                .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                                .lineLimit(2)
                                .padding(.leading, 5)
                        } else if nextElement is Rest {
                            Text("Repos \(TimeFormatter.formatToString(timeInMilliseconds: UInt((nextElement as! Rest).duration! * 1000)))")
                                .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 20))
                                .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                                .lineLimit(2)
                        } else {
                            HStack {
                                Spacer()
                                
                                Text("Terminé")
                                    .font(FontFamily.DMSans.regular.swiftUIFont(fixedSize: 20))
                                    .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                                    .lineLimit(2)
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 10)
                }
                .frame(height: 80)
                
                Spacer()
                
                HStack {
                    Button {
                        if workoutElementsToPlay.count > 0 {
                            currentElement = workoutElementsToPlay[0]
                        }
                        if workoutElementsToPlay.count > 1 {
                            nextElement = workoutElementsToPlay[1]
                        } else {
                            nextElement = nil
                        }
                        currentElementIndex = 0
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 30, weight: .heavy))
                            .frame(width: 25, height: 25)
                            .foregroundColor(Asset.Colors.gray1.swiftUIColor)
                    }
                    
                    Spacer()
                    
                    Button {
                        isPaused.toggle()
                    } label: {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 30, weight: .heavy))
                            .frame(width: 25, height: 25)
                            .foregroundColor(isPausedDisabled ? Asset.Colors.gray3.swiftUIColor : Asset.Colors.gray1.swiftUIColor)
                    }
                    .disabled(isPausedDisabled)
                }
                .padding(.horizontal, 5)
            }
            .padding(.horizontal, 15)
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
        .frame(height: 300)
        .onReceive(NotificationCenter.default.publisher(for: .WorkoutToPlaySelected)) { notification in
            if let isAWorkoutSelected = notification.object as? Bool, isAWorkoutSelected {
                workout = WorkoutManager.shared.playingWorkout!
            }
        }
    }
    
    private func goToNextElement() {
        guard let nextElement = nextElement else {
            return
        }
        
        currentElementIndex += 1
        currentElement = nextElement
       
        if currentElementIndex + 1 < workoutElementsToPlay.count {
            self.nextElement = workoutElementsToPlay[currentElementIndex + 1]
        } else {
            self.nextElement = nil
        }
    }
    
    private func setUpWorkoutElements(_ workoutElements: [WorkoutElementObject]) -> [WorkoutElementObject] {
        var result: [WorkoutElementObject] = []
        workoutElements.forEach { element in
            switch element {
            case is Sets:
                result.append(contentsOf: setUpSetElements(element as! Sets))
            default:
                result.append(element)
            }
        }
        return result
    }
    
    private func setUpSetElements(_ set: Sets) -> [WorkoutElementObject] {
        var result: [WorkoutElementObject] = []
        WorkoutManager.shared.fetchElements(for: set)
        for _ in 0..<set.numberOfSets {
            set.elementsObjects.forEach { element in
                result.append(element)
            }
            if let restTime = set.restBetweenSet {
                let rest = Rest()
                rest.duration = restTime
                result.append(rest)
            }
        }
        
        return result
    }
}

#Preview {
    WorkoutPlayerCard()
}
