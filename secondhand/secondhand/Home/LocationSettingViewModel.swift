//
//  LocationSettingViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import SwiftUI

class LocationSettingViewModel: ObservableObject {
    @Published var selectedLocations: [Address] = []
    
    private let userManager: (UserProvider & UserLocationProvider)
    
    init(userManager: (UserProvider & UserLocationProvider)) {
        self.userManager = userManager
        
        setupDefaultLocation()
    }
    
    func addLocation(_ location: Address) {
        if selectedLocations.count < 2 {
            selectedLocations.append(location)
            userManager.addLocation(location)
        }
    }
    
    func removeLocation(_ location: Address) {
        selectedLocations.removeAll { $0 == location }
        userManager.removeLocation(location)
    }
    
    private func setupDefaultLocation() {
        if let user = userManager.user {
            self.selectedLocations = user.locations.map { Address(from: $0) }
        } else {
            self.selectedLocations = [Address(roadAddr: "", emdNm: "역삼동")]
        }
    }
}
