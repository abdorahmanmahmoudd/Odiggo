//
//  FavouriteProductsManager.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 26/01/2021.
//

import Foundation

struct FavouriteProduct: Codable {
    var productId: Int
    var isFavourite: Bool = false
}

final class FavouriteProductsManager {
    
    private let defaults = UserDefaults.standard
    
    static let shared = FavouriteProductsManager()
        
    private init() {
        
        if storedFavouriteProducts() == nil {
            _ = storeFavouriteProducts(with: [])
        }
    }
}

// MARK: Datasource
extension FavouriteProductsManager {
    
    private func storeFavouriteProducts(with favourites: [FavouriteProduct]) -> Bool {
        do {
            defaults.set(try PropertyListEncoder().encode(favourites),
                                      forKey: Constants.FavouriteProductsManager.repository)
            return true

        } catch {
            debugPrint("failed to store favourite products with error: \(error.localizedDescription)")
        }
        return false
    }

    private func storedFavouriteProducts() -> [FavouriteProduct]? {
        do {
            if let data = defaults.object(forKey: Constants.FavouriteProductsManager.repository) as? Data {
                return try PropertyListDecoder().decode([FavouriteProduct].self, from: data)
            }

        } catch {
            debugPrint("Failed while decoding favourite products with error: \(error.localizedDescription)")
        }

        return nil
    }
    
    func upsertProduct(_ product: FavouriteProduct?) -> Bool {
        
        guard let product = product else {
            return false
        }
        
        guard var favourites = storedFavouriteProducts() else {
            return false
        }
        
        if let index = favourites.firstIndex(where: { $0.productId == product.productId }) {
            favourites[index].isFavourite = product.isFavourite
            
        } else {
            favourites.append(product)
        }
        
        return storeFavouriteProducts(with: favourites)
    }
    
    func isFavourite(_ id: Int) -> Bool {
        
        guard let favourites = storedFavouriteProducts() else {
            return false
        }
        
        return favourites.first(where: { $0.productId == id })?.isFavourite ?? false
    }
    
    func product(of id: Int) -> FavouriteProduct? {
        
        guard let favourites = storedFavouriteProducts() else {
            return nil
        }
        
        return favourites.first(where: { $0.productId == id }) ?? nil
    }
}
