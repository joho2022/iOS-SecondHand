//
//  UserLocationProvider.swift
//  secondhand
//
//  Created by 조호근 on 6/25/24.
//

import Foundation

protocol UserLocationProvider {
    func addLocation(_ address: Address)
    func removeLocation(_ address: Address)
    func setDefaultLocation(location: Location)
}
