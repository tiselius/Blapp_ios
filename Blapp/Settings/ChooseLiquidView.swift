//
//  ChooseLiquidView.swift
//  SpilledUITest
//
//  Created by Aron Tiselius on 2024-04-29.
//
import SwiftUI
import UIKit


struct ChooseLiquidView: View {
    @Binding var liquidLabel: String
    @ObservedObject var liquidManager = LiquidManager.shared // Use observed object
    @State private var newLiquidName: String = ""
    @State private var newLiquidSurfaceTension: String = ""
    @State private var newLiquidDensity: String = ""
    @State private var newLiquidSurfaceTensionParsed: Float = 0.0
    @State private var newLiquidDensityParsed: Float = 0.0
    @State private var temporaryNameForNewLiquid: String = ""
    @State private var couldAddLiquid: Bool = false
    @FocusState private var secondTextFieldFocused: Bool
    @FocusState private var thirdTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Liquid type")) {
                    ForEach(liquidManager.liquids) { liquid in
                        Button(action: {
                            applyLiquidSetting(for: liquid)
                            liquidLabel = liquid.name
                        }, label: {
                            HStack {
                                Text(liquid.name)
                                Spacer()
                                if(liquid.removeable == true){
                                    Button(action: {
                                        liquidManager.removeLiquid(liquid)
                                        liquidLabel = liquidManager.liquids[0].name
                                        applyLiquidSetting(for: liquidManager.liquids[0])
                                    }){Text("Remove").foregroundColor(.red)}
                                }
                                if liquidLabel == liquid.name {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        })
                    }
                }.foregroundColor(.primary)

                if liquidManager.liquids.count < 5 {
                    VStack {
                        TextField(
                            "Name",
                            text: $temporaryNameForNewLiquid
                        ).onSubmit {
                            secondTextFieldFocused = true
                        }
                        .disableAutocorrection(true)
                        TextField(
                            "Density in kg / m^3",
                            text: $newLiquidDensity
                            
                        )
                            .focused($secondTextFieldFocused)
                            .onSubmit {
                                thirdTextFieldFocused = true
                            }
                        TextField(
                            "Surface tension in N/m",
                            text: $newLiquidSurfaceTension
                            
                        )
                            .focused($thirdTextFieldFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                if temporaryNameForNewLiquid != "" && liquidManager.nameExists(liquidName: temporaryNameForNewLiquid) == false {
                                    newLiquidName = temporaryNameForNewLiquid
                                    
                                    if let parsedLiquidSurfaceTension = Float(newLiquidSurfaceTension) {
                                        self.newLiquidSurfaceTensionParsed = parsedLiquidSurfaceTension
                                    }
                                    if let parsedLiquidDensity = Float(newLiquidDensity) {
                                        self.newLiquidDensityParsed = parsedLiquidDensity
                                    }
                                    if self.newLiquidSurfaceTensionParsed > 0 && self.newLiquidDensityParsed > 0 {
                                        couldAddLiquid = true
                                    }
                                }
                            }
                    }.textFieldStyle(.roundedBorder)

                        if couldAddLiquid {
                            Button(action: {
                                let newLiq = Liquid(name: newLiquidName, surfaceTension: Double(newLiquidSurfaceTensionParsed), density: Double(newLiquidDensityParsed), removeable: true)
                                liquidManager.addLiquid(newLiq)
                                liquidLabel = newLiq.name
                                applyLiquidSetting(for: newLiq)
                                print("added liquid")
                                couldAddLiquid = false
                                newLiquidSurfaceTension = ""
                                newLiquidDensity = ""
                                temporaryNameForNewLiquid = ""
                                newLiquidDensityParsed = 0
                                newLiquidSurfaceTensionParsed = 0
                            })
                            {
                                HStack {
                                    Image(systemName: "")
                                    Text("Add a new liquid")
                                }
                            }
                        }
                    }
                }

            }
        }
    }


