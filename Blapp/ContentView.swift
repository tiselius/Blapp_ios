//
//  ContentView.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-15.
//

import SwiftUI

struct ContentView: View {
    var distanceLbl = UILabel(frame: CGRect(x: 0, y: 500, width: 200, height: 50))
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello new changes")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
