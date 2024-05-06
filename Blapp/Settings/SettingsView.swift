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
    @State private var referenceLabel = UserDefaults.standard.string(forKey: "selectedReferenceOption") ?? "Plastic card"
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedVolumeUnit = VolumeUnit(rawValue: UserDefaults.standard.string(forKey: "selectedVolumeUnit") ?? VolumeUnit.deciliters.rawValue) ?? .deciliters


    
    var body: some View {
        
        NavigationStack {
            ZStack{
                Image("Settings_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    List {
                        Section() {
                            NavigationLink(destination: ReferenceObjectView( referenceLabel: $referenceLabel))
                            {
                                HStack{
                                    Image("Reference_object")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 80)
                                }
                            }
                        }
                        Section(){
                            NavigationLink(destination: ChooseLiquidView(liquidLabel: $liquidLabel)) {
                                HStack{
                                    Image("Liquid")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 80)
                                    Spacer()
                                    Text(liquidLabel)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        Section(){
                            NavigationLink(destination: ChooseUnitView(selectedVolumeUnit: $selectedVolumeUnit)) {
                                HStack{
                                    Image("Units")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 80)
                                    Spacer()
                                    Text(selectedVolumeUnit.rawValue == VolumeUnit.deciliters.rawValue ? "Deciliters" : "Ounces")
                                                                            .foregroundColor(.gray)
                                }
                            }
                        }
                        Section() {
                            NavigationLink(destination: AboutUsView()) {
                                HStack{
                                    Image("AboutUs")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 80)
                                }
                            }
                        }//Section
                    }//List
                    .navigationTitle("Settings")
                    .listStyle(PlainListStyle()) //
                    .background(Color.clear) // Set background color of the List to clear

                }//VStack
                Button(action: {
                        dismiss()
                           }) {
                               Image("Return")
                                   .resizable()
                                   .frame(width: 120, height: 120)
                                   .foregroundColor(.black) // Set the color of the return button
                           }
                           .offset(x: -140, y: 320) // Adjust the offset to position the button
            }//ZStack
        }//NavigationStack
        .navigationViewStyle(.stack)
    }//View
}//End Struct
#Preview {
    SettingsView()
}


