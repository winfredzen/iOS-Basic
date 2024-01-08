//
//  ContentView.swift
//  SwiftUIImage
//
//  Created by 王振 on 2024/1/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Image(systemName: "cloud.heavyrain")
//            .font(.system(size: 100))
//            .foregroundColor(.blue)
//            .shadow(color: .gray, radius: 10, x: 0, y: 10)
        
//        Image("paris")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .overlay(
//                Text("If you are lucky enough to have lived in Paris as a young man, then wherever you go for the rest of your life it stays with you, for Paris is a moveab le feast.\n\n- Ernest Hemingway")
//                .fontWeight(.heavy)
//                .font(.system(.headline, design: .rounded))
//                .foregroundColor(.white)
//                .padding()
//                .background(Color.black)
//                .cornerRadius(10)
//                .opacity(0.8)
//                .padding(),
//                alignment: .top
//            )
        
//        Image("paris")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .overlay(
//                Rectangle()
//                    .foregroundColor(.black)
//                    .opacity(0.4)
//        )
        
//        Image("paris")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .overlay(
//                Color.black.opacity(0.4)
//                    .overlay(
//                        Text("Paris")
//                            .font(.largeTitle)
//                            .fontWeight(.black)
//                            .foregroundColor(.white)
//                            .frame(width: 200)
//                    )
//        )
        
//        Image(systemName: "cloud.sun.rain")
//            .symbolRenderingMode(.palette)
//            .foregroundStyle(.indigo, .yellow, .gray)
        
        
        Image(systemName: "slowmo", variableValue: 0.6)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.indigo)
            .font(.largeTitle)
        
    }
}

#Preview {
    ContentView()
}
