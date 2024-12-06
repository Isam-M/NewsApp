//
//  CountriesRepository.swift
//  NewsAppExam
//
//  Created by Isam Melioui on 04/12/2024.
//

import Foundation
import SwiftData
import UIKit

struct CountryData: Decodable {
    let name: String
    let code: String
}

class CountriesRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func initializeCountries() {
        let existingCountries = try? context.fetch(FetchDescriptor<Country>())

        if existingCountries?.isEmpty ?? true {
            if let countries = loadCountriesFromJSON() {
                for country in countries {
                    context.insert(Country(name: country.name, code: country.code))
                }
                do {
                    try context.save()
                    print("Countries initialized from JSON")
                } catch {
                    print("Failed to save countries: \(error)")
                }
            } else {
                print("Failed to load countries from JSON")
            }
        }
    }

    private func loadCountriesFromJSON() -> [CountryData]? {
        guard let asset = NSDataAsset(name: "countries", bundle: Bundle.main) else {
            print("Error: Could not find countries.json in DataAssets")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode([CountryData].self, from: asset.data)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

}
