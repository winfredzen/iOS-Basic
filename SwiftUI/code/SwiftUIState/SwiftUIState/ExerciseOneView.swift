//
//  ExerciseOneView.swift
//  SwiftUIState
//
//  Created by 王振 on 2024/1/10.
//

import SwiftUI

struct ExerciseOneView: View {
    
    @State private var counter = 1
    
    var body: some View {
        VStack {
            CounterButton(counter: $counter, color: .blue)
            CounterButton(counter: $counter, color: .green)
            CounterButton(counter: $counter, color: .red)
        }
    }
}

struct CounterButton: View {
    @Binding var counter: Int
    
    var color: Color
    
    var body: some View {
        Button {
            // Switch between the play and stop button
            counter += 1
        } label: {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(color)
                .overlay {
                    Text("\(counter)")
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
        }
    }
}

#Preview {
    ExerciseOneView()
}
