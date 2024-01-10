//
//  ContentView.swift
//  SwiftUIButton
//
//  Created by 王振 on 2024/1/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            //            Button {
            //                print("Hello World tapped!")
            //            } label: {
            //                Text("Hello Word")
            //            }
            
            //            Button(action: {
            //                print("Hello World tapped!")
            //            }, label: {
            //                Text("Hello Word")
            //            })
            
            //            Button {
            //                print("Hello World tapped!")
            //            } label: {
            //                Text("Hello Word")
            //                    .padding()
            //                    .background(Color.purple)
            //                    .cornerRadius(40)
            //                    .foregroundColor(.white)
            //                    .font(.title)
            //                    .padding(10)
            //                    .overlay {
            //                        RoundedRectangle(cornerRadius: 40)
            //                            .stroke(.purple, lineWidth: 5)
            //                    }
            //
            //            }
            
            //            Button(action: {
            //                print("Delete button tapped!")
            //            }) {
            //                HStack {
            //                    Image(systemName: "trash")
            //                        .font(.title)
            //                    Text("Delete")
            //                        .fontWeight(.semibold)
            //                        .font(.title)
            //                }
            //                .padding()
            //                .foregroundColor(.white)
            //                .background(.red)
            //                .cornerRadius(40)
            //
            //            }
            
            Button {
                print("Delete button tapped")
            } label: {
                Label(
                    title: {
                        Text("Delete")
                            .fontWeight(.semibold)
                            .font(.title)
                    },
                    icon: {
                        Image(systemName: "trash")
                            .font(.title)
                    }
                )
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                .cornerRadius(40)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
