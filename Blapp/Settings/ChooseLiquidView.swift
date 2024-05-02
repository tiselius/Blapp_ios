//
//  ChooseLiquidView.swift
//  SpilledUITest
//
//  Created by Aron Tiselius on 2024-04-29.
//
import SwiftUI
import UIKit
let options = ["Blood", "Water", "Liquid Lava"]


struct ChooseLiquidView: View {
    @Binding var liquidLabel: String
    let options = ["Blood", "Water", "Liquid Lava"]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Liquid type")) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            applyLiquidSetting(for: option)
                            liquidLabel = option
                        }, label: {
                            HStack {
                                Text(option)
                                Spacer()
                                if liquidLabel == option
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




//#Preview {
//    ChooseLiquidView(liquidLabel: $liquidLabel)
//}
