//
//  ChooseLiquidView.swift
//  SpilledUITest
//
//  Created by Aron Tiselius on 2024-04-29.
//
import SwiftUI
import UIKit

struct ChooseLanguageView: View {
    @Binding var languageLabel: String
    
    let options = ["Svenska", "English", "Rastafarian"]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Language")) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            languageLabel = option
                            applyLanguageSetting(for: option)
                        }, label: {
                            HStack {
                                Text(option)
                                Spacer()
                                if languageLabel == option
                                {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        })
                    }
                }.foregroundColor(.primary)
            }
        }

    }

}

