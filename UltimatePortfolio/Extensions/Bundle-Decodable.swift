//
//  Bundle-Decodable.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/21/22.
//
// swiftlint:disable line_length

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type,
                              from file: String,
                              dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                              keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle ")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data from \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(type, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(type) from \(file) due to missing key: \(key.stringValue) - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(type) from \(file) due to type mismatch: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(type) from \(file) due to missing value: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Failed to decode file from bundle due to invalid json: \(context.debugDescription)")
        } catch {
            fatalError("Failed to decode file: \(error.localizedDescription)")
        }
    }
}
