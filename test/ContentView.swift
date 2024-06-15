//
//  ContentView.swift
//  test
//
//  Created by 鈴木慎吾 on 2024/06/15.
//

import SwiftUI

struct Item: Identifiable {
    var id = UUID()
    var name: String
    var detailView: AnyView
}


struct ContentView: View {
    let items = [
        Item(name: "Mesh Gradient", detailView: AnyView(MeshGradientView())),
        Item(name: "Scroll effects", detailView: AnyView(ScrollEffectsView())),
        Item(name: "SF Symbols6", detailView: AnyView(SFSymbols6View()))
    ]
    var body: some View {
        NavigationView {
            VStack{
                List(items) { item in
                    NavigationLink(destination: MeshGradientView()) {
                        Text(item.name)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
