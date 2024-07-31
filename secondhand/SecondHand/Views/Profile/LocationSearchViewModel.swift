//
//  LocationSearchViewModel.swift
//  SecondHand
//
//  Created by 조호근 on 6/5/24.
//

import Combine
import Foundation
import os

class LocationSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchResults: [Address] = []
    @Published var isLoading: Bool = false
    
    private var currentPage: Int = 1
    private var canLoadMorePages = true
    private var cancellables = Set<AnyCancellable>()
    
    private let addressService: AddressServiceProtocol
    
    init(addressService: AddressServiceProtocol) {
        self.addressService = addressService
        
        $searchQuery
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.searchResults = []
                self?.currentPage = 1
                self?.canLoadMorePages = true
                self?.fetchResults()
            }
            .store(in: &cancellables)
    }
    
    private func fetchResults() {
        guard !searchQuery.isEmpty && canLoadMorePages else { return }
        isLoading = true
        addressService.fetchRoadAddresses(keyword: searchQuery, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newResults):
                    self?.searchResults.append(contentsOf: newResults)
                    self?.currentPage += 1
                    self?.canLoadMorePages = !newResults.isEmpty
                case .failure(let error):
                    os_log("[ AddressService ]: \(error)")
                }
            }
        }
    }
    
    func loadMoreResult() {
        fetchResults()
    }
}
