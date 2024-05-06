//
//  ChooseUnit.swift
//  Blapp
//
//  Created by Dawa Arkhang on 2024-05-06.
//

// VolumeUnitToggleView.swift

import SwiftUI

struct ChooseUnitView: View {
    @Binding var selectedVolumeUnit: VolumeUnit

    var body: some View {
        Toggle(isOn: Binding<Bool>(
            get: { self.selectedVolumeUnit == .ounces },
            set: { newValue in
                self.selectedVolumeUnit = newValue ? .ounces : .deciliters
                updateSelectedVolumeUnit(self.selectedVolumeUnit)
            }
        )) {
            Text("Use Ounces")
        }
    }
}




