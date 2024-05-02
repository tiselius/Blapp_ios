//
//  SettingsView.swift
//  Blapp
//
//  Created by Aron Tiselius on 2024-04-29.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isChooseLiquidViewPresented = false
    @State private var isChooseLanguageViewChosen = false
    @State private var isAboutUsPresented = false
    @State private var liquidLabel = UserDefaults.standard.string(forKey: "selectedLiquidOption") ?? "Blood"
    @State private var languageLabel = UserDefaults.standard.string(forKey: "selectedLanguageOption") ?? "Svenska"
    @State private var referenceLabel = UserDefaults.standard.string(forKey: "selectedReferenceOption") ?? "Plastic card"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section() {
                    NavigationLink(destination: ReferenceObjectView( referenceLabel: $referenceLabel))
                    {
                        HStack{
                            Image(systemName: "square.dashed")
                            Text("Reference object")
                        }
                    }
                }
                Section(header: Text("Liquids")){
                    NavigationLink(destination: ChooseLiquidView(liquidLabel: $liquidLabel)) {
                        HStack{
                            Image(systemName: "drop.circle")
                            Text("Liquid")
                            Spacer()
                            Text(liquidLabel)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("Language")){
                    NavigationLink( destination: ChooseLanguageView(languageLabel: $languageLabel)) {
                        HStack{
                            Image(systemName: "globe")
                            Text("Language")
                            Spacer()
                            Text(languageLabel)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Section(header: Text("About us")) {
                    NavigationLink(destination: AboutUsView()) {
                        HStack{
                            Image(systemName: "figure.wave.circle")
                            Text("About us")
                        }
                    }
                }
            }.navigationTitle("Settings")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Label("Dismiss", systemImage: "chevron.left")
                        }
                    }
                })
            
            
        }
    }
}
#Preview {
    SettingsView()
}


