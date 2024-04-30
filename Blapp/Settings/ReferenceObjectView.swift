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
    @State private var newReferenceArea: String = ""
    @State private var newReferenceAreaParsed: Float = 0.0
    @State private var temporaryNameForNewReference : String = ""
    @State private var couldAddReference : Bool = false
    @FocusState private var secondTextFieldFocused : Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Reference object"), footer: Text("Uses a reference object to get a real-life scale. \nCan only be turned off if a camera with depth capture is available.")) {
                    Toggle(
                        "Use reference object",
                        systemImage: "skew", isOn: noDepthCameraAvailable ? .constant(true): $useReference)
                    .onChange(of: useReference, perform: { value in
                        UserDefaults.standard.set(value, forKey: "useReference")
                    })
                }
                .foregroundColor(.primary)
                
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
                                }
                                if referenceLabel == reference.name {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }.foregroundColor(.primary)
                    
                    if(referenceManager.references.count < 5){
                        Section{
                            VStack {
                                TextField(
                                    "Name",
                                    text: $temporaryNameForNewReference
                                ).onSubmit {
                                    secondTextFieldFocused = true
                                }
                                .disableAutocorrection(true)
                                TextField(
                                    "Area in m^2",
                                    text: $newReferenceArea
                                    
                                )
                                .focused($secondTextFieldFocused)
                                .submitLabel(.done)
                                    .onSubmit {
                                        if temporaryNameForNewReference != "" && referenceManager.nameExists(referenceName: temporaryNameForNewReference) == false{
                                            newReferenceName = temporaryNameForNewReference
                                            
                                            
                                            if let parsedArea = Float(newReferenceArea){
                                                self.newReferenceAreaParsed = parsedArea
                                            }
                                            if self.newReferenceAreaParsed > 0 {
                                                couldAddReference = true
                                            }
                                        }
                                    }
                            }
                            .textFieldStyle(.roundedBorder)
                            
                            if(couldAddReference == true){
                                Button(action: {let newRef = Reference(name: newReferenceName, image: "ladybug", area: newReferenceAreaParsed, removeable: true)
                                    referenceManager.addReference(newRef)
                                    referenceLabel = newRef.name
                                    applyReferenceSetting(for: newRef)
                                    print("added reference")
                                    couldAddReference = false
                                    newReferenceArea = ""
                                    temporaryNameForNewReference = ""
                                    newReferenceAreaParsed = 0
                                }
                                )
                                {
                                    HStack{
                                        Image(systemName: "")
                                        Text("add new reference")
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
