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
    @State private var newLiquidSurfaceTension: Float = 0.0
    @State private var newLiquidDensity: Float = 0.0
    @State private var newLiquidSurfaceTensionParsed: Float = 0.0
    @State private var newLiquidDensityParsed: Float = 0.0
    @State private var temporaryNameForNewLiquid: String = ""
    @State private var couldAddLiquid: Bool = false
    @FocusState private var secondTextFieldFocused: Bool
    @FocusState private var thirdTextFieldFocused: Bool
    @State private var showingAddLiquid = false

    var body: some View {
        NavigationView {
            ZStack{
                Image("Liquids_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    List {
                            Section() {
                                ForEach(liquidManager.liquids) { liquid in
                                    Button(action: {
                                        applyLiquidSetting(for: liquid)
                                        liquidLabel = liquid.name
                                    }, label: {
                                        HStack {
                                            Image(liquid.image)
                                                .resizable()
                                                .frame(width: 40, height: 40)

                                            Text(liquid.name)
                                                .font(.custom("YuseiMagic-Regular", size: 17))
                                                .foregroundColor(.black)
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
                                        }//Hstack
                                    })
                                }
                            }.foregroundColor(.primary)//Section
                        VStack{
                            if liquidManager.liquids.count < 5 {
                                Button(action: {
                                    showingAddLiquid = true
                                }) {
                                    HStack {
                                        Image("Custom_Liquid")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .foregroundColor(.black)
                                        Text("Add a new liquid")
                                            .font(.custom("YuseiMagic-Regular", size: 17))
                                    }//Hstack
                                }//Button
                            }//If BUTTON
                        }//Section
                    }//List
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }//VStack
                .sheet(isPresented: $showingAddLiquid) {
                    // Pop-up view
                    GeometryReader { geometry in
                        ZStack {
                            Color(red: 1, green: 0.49, blue: 0.53).edgesIgnoringSafeArea(.all)
                            VStack {
                                Spacer()
                                Text("Add Custom Liquid")
                                    .font(.custom("YuseiMagic-Regular", size: 20))
                                    .foregroundColor(Color.white)
                                Spacer()
                                ScrollView {
                                    VStack(spacing: 20) {
                                        TextField(
                                            "Name",
                                            text: $temporaryNameForNewLiquid
                                        )
                                        .padding()
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .onSubmit {
                                            secondTextFieldFocused = true
                                        }
                                        TextField(
                                            "Density in kg / m^3",
                                            value: $newLiquidDensity,
                                            formatter: NumberFormatter()
                                        )
                                        .padding()
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .focused($secondTextFieldFocused)
                                        .onSubmit {
                                            thirdTextFieldFocused = true
                                        }
                                        TextField(
                                            "Surface tension in N/m",
                                            value: $newLiquidSurfaceTension,
                                            formatter: NumberFormatter()
                                        )
                                        .padding()
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .focused($thirdTextFieldFocused)
                                        .submitLabel(.done)
                                        .onSubmit {
                                            if temporaryNameForNewLiquid != "" && liquidManager.nameExists(liquidName: temporaryNameForNewLiquid) == false {
                                                newLiquidName = temporaryNameForNewLiquid
                                                }
                                            if self.newLiquidSurfaceTension > 0.0 && self.newLiquidDensity > 0.0 {
                                                    couldAddLiquid = true
                                                }
                                            }
                                        }
                                    .padding()
                                    .background(Color(red: 1, green: 0.49, blue: 0.53))
                                    .cornerRadius(20)
                                    if couldAddLiquid {
                                        Button(action: {
                                            let newLiq = Liquid(name: newLiquidName, surfaceTension: Double(newLiquidSurfaceTensionParsed), density: Double(newLiquidDensityParsed), removeable: true, image: "Water_Liquid")
                                            liquidManager.addLiquid(newLiq)
                                            liquidLabel = newLiq.name
                                            applyLiquidSetting(for: newLiq)
                                            print("added liquid")
                                            print(newLiq)
                                            print(newLiquidName)
                                            print(newLiquidSurfaceTensionParsed)
                                            couldAddLiquid = false
                                            newLiquidSurfaceTension = 0.0
                                            newLiquidDensity = 0.0
                                            temporaryNameForNewLiquid = ""
                                            newLiquidDensityParsed = 0
                                            newLiquidSurfaceTensionParsed = 0
                                            showingAddLiquid = false
                                        })
                                        {
                                            HStack {
                                                Text("Add a new liquid")
                                                    .font(.custom("YuseiMagic-Regular", size: 20))
                                                    .foregroundColor(Color.white)
                                                    .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                                                    .cornerRadius(10)
                                                    .shadow(radius: 2)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //.frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                    }//Gemoetry Reader
                    .presentationDetents([.medium])
                }//Sheet
            }//Zstack
        }//NavigationView
    }//Body
}//Struct

#Preview {
    ChooseLiquidView(liquidLabel: .constant("Your initial label text"))
}
