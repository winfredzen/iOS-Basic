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
            
            //            Button {
            //                print("Delete button tapped")
            //            } label: {
            //                Label(
            //                    title: {
            //                        Text("Delete")
            //                            .fontWeight(.semibold)
            //                            .font(.title)
            //                    },
            //                    icon: {
            //                        Image(systemName: "trash")
            //                            .font(.title)
            //                    }
            //                )
            //                .padding()
            //                .foregroundColor(.white)
            //                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
            //                .cornerRadius(40)
            //                .shadow(color: .gray, radius: 20.0, x: 20, y: 10)
            //            }
            
            //            Button(action: {
            //                print("Delete tapped!")
            //            }) {
            //                HStack {
            //                    Image(systemName: "trash")
            //                        .font(.title)
            //                    Text("Delete")
            //                        .fontWeight(.semibold)
            //                        .font(.title)
            //                }
            //                .frame(minWidth: 0, maxWidth: .infinity)
            //                .padding()
            //                .foregroundColor(.white)
            //                .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]),
            //                                           startPoint: .leading,
            //                                           endPoint: .trailing))
            //                .cornerRadius(40)
            //                .padding(.horizontal, 20)
            //            }
            
            
            //            Button {
            //                print("Share button tapped")
            //            } label: {
            //                Label(
            //                    title: {
            //                        Text("Share")
            //                            .fontWeight(.semibold)
            //                            .font(.title)
            //                    },
            //                    icon: {
            //                        Image(systemName: "square.and.arrow.up")
            //                            .font(.title)
            //                    }
            //                )
            //            }
            //            .buttonStyle(GradientBackgroundStyle())
            //
            //            Button {
            //                print("Edit button tapped")
            //            } label: {
            //                Label(
            //                    title: {
            //                        Text("Edit")
            //                            .fontWeight(.semibold)
            //                            .font(.title)
            //                    },
            //                    icon: {
            //                        Image(systemName: "square.and.pencil")
            //                            .font(.title)
            //                    }
            //                )
            //            }
            //            .buttonStyle(GradientBackgroundStyle())
            //
            //            Button {
            //                print("Delete button tapped")
            //            } label: {
            //                Label(
            //                    title: {
            //                        Text("Delete")
            //                            .fontWeight(.semibold)
            //                            .font(.title)
            //                    },
            //                    icon: {
            //                        Image(systemName: "trash")
            //                            .font(.title)
            //                    }
            //                )
            //            }
            //            .buttonStyle(GradientBackgroundStyle())
            
            
            //            Button {
            //            } label: {
            //                Text("Buy me a coffee")
            //            }
            //            .tint(.purple)
            //            .buttonStyle(.borderedProminent)
            //            .buttonBorderShape(.capsule)
            //            .controlSize(.large)
            
            //
            
            Button("Delete", role: .destructive) {
                print("Delete")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
        }
    }
}

struct GradientBackgroundStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

#Preview {
    ContentView()
}
