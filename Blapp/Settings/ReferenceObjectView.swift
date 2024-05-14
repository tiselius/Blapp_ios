//
//  ReferenceObjectView.swift
//  SpilledUITest
//
//  Created by Aron Tiselius on 2024-04-29.
//
import SwiftUI
import UIKit

struct ReferenceObjectView: View {
    @AppStorage("useReference") var useReference: Bool = false
    @Binding var referenceLabel : String
    @ObservedObject var referenceManager = ReferenceManager.shared // Use observed object
    @State private var newReferenceName: String = ""
    @State private var newReferenceArea: Float = 0.0
    @State private var newReferenceAreaParsed: Float = 0.0
    @State private var temporaryNameForNewReference : String = ""
    @State private var couldAddReference : Bool = false
    @FocusState private var secondTextFieldFocused : Bool
    @State private var showingAddReference = false
    
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
                        Section(footer: Text("Uses a reference object to get a real-life scale. \nCan only be turned off if a camera with depth capture is available.")) {
                            Toggle(
                                "Use reference object",
                                systemImage: "skew", isOn: noDepthCameraAvailable ? .constant(true): $useReference)
                            .onChange(of: useReference, perform: { value in
                                UserDefaults.standard.set(value, forKey: "useReference")
                            })
                        }.foregroundColor(.primary)
                        if useReference {
                            ForEach(referenceManager.references) { reference in
                                Button(action: {
                                    referenceLabel = reference.name
                                    applyReferenceSetting(for: reference)
                                }) {
                                    HStack {
                                        Image(systemName: reference.image)
                                        Text(reference.name)
                                        Spacer()
                                        if(reference.removeable == true){
                                            Button(action: {
                                                referenceManager.removeReference(reference)
                                                referenceLabel = referenceManager.references[0].name
                                                applyReferenceSetting(for: referenceManager.references[0])
                                            }){Text("Remove").foregroundColor(.red)}
                                        }//If removabel
                                        if referenceLabel == reference.name {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }//IF referenceLbl
                                    }//Hstack
                                }//Button
                            }.foregroundColor(.primary)//Foreach
                            if(referenceManager.references.count < 5){
                                Button(action: {
                                    showingAddReference = true
                                }) {
                                    HStack {
                                        Image("Custom_Liquid")
                                            .resizable()
                                            .frame(width: 45, height: 45)
                                            .foregroundColor(.black)
                                        Text("Add a new reference")
                                            .font(.system(size: 17))
                                    }//Hstack
                                }//Button
                            }
                            }//Section
                    }//List
                    .listStyle(.plain)
                    .background(Color.clear)
                }//VStack
                .sheet(isPresented: $showingAddReference) {
                    GeometryReader{ geometry in
                        ZStack{
                            Color(red: 1, green: 0.49, blue: 0.53).edgesIgnoringSafeArea(.all)
                            VStack(spacing: 20) {
                        
                            Text("Add Custom Reference")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                                TextField(
                                    "Name",
                                    text: $temporaryNameForNewReference
                                ).onSubmit {
                                    secondTextFieldFocused = true
                                }
                                .disableAutocorrection(true)
                                TextField(
                                    "Area in m^2",
                                    value: $newReferenceArea,
                                    formatter: NumberFormatter()
                                    
                                )
                                .focused($secondTextFieldFocused)
                                .submitLabel(.done)
                                .onSubmit {
                                    if temporaryNameForNewReference != "" && referenceManager.nameExists(referenceName: temporaryNameForNewReference) == false{
                                        newReferenceName = temporaryNameForNewReference
                                        
                                        if self.newReferenceArea > 0 {
                                            couldAddReference = true
                                        }
                                    }
                                }//On Submit
                            
                            if(couldAddReference == true){
                                Button(action: {let newRef = Reference(name: newReferenceName, image: "ladybug", area: newReferenceAreaParsed, removeable: true)
                                    referenceManager.addReference(newRef)
                                    referenceLabel = newRef.name
                                    applyReferenceSetting(for: newRef)
                                    print("added reference")
                                    couldAddReference = false
                                    newReferenceArea = 0.0
                                    temporaryNameForNewReference = ""
                                    showingAddReference = false
                                }
                                )
                                {
                                    HStack{
                                        Text("Add a new Reference")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color.white)
                                            .background(Color(red: 1.0, green: 0.71, blue: 0.87))
                                            .cornerRadius(10)
                                            .shadow(radius: 2)
                                    }//HStack
                                }//Button
                            }
                            }//If could add reference
                        }//Vstack
                        .textFieldStyle(.roundedBorder)
                    }//GeometryReader
                    .presentationDetents([.height(300)])
                }//Sheet
            }//ZStack
        }//NavigationView
        .navigationTitle("Reference Object")
    }//Body
}//Struct
