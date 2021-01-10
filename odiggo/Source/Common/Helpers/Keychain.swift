//
//  Keychain.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 09/01/2021.
//

import Foundation

/**
 Keychain structure for reading and storing passwords for specified user accounts
 */
struct Keychain {

    /// The keychain configuration
    let configuration: Configuration

    /**
     Gets the secure data for specified key..
     - Parameter key: The key under which the data is stored.
     - Returns: The secure data or nil in case the data is not found or an error occurrs.
     */
    func data(for key: String) -> Data? {
        let query = [
            kSecAttrService: configuration.service,
            kSecAttrAccount: Data(key.utf8),
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: kCFBooleanTrue as Any,
        ] as CFDictionary

        var data: AnyObject?
        let status = SecItemCopyMatching(query, &data)

        if status == errSecSuccess, let data = data as? Data {
            return data
        }

        return nil
    }

    /**
     Sets data for specified key.
     - Parameter data: The secure data
     - Parameter key: The key under which the data will be stored
     - Returns: `true` if the action succeeds or `false` in case of an error
     */
    func set(_ data: Data, for key: String) -> Bool {

        // First try inserting
        if insert(data, for: Data(key.utf8)) {
            return true
        }

        // If it failed, try updating
        return update(data, for: Data(key.utf8))
    }

    /**
     Convenience method. Sets secure string for specified key.
     - Parameter string: The secure string
     - Parameter key: The key under which the data will be stored
     - Returns: `true` if the action succeeds or `false` in case of an error
     */
    func set(_ string: String, for key: String) -> Bool {
        return set(Data(string.utf8), for: key)
    }

    /**
     Deletes data for specified key..
     - Parameter key: The key under which the data is stored
     - Returns: `true` if the action succeeds or `false` in case of an error
     */
    @discardableResult
    func deleteData(for key: String) -> Bool {
        let query = [
            kSecAttrService: configuration.service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let status = SecItemDelete(query)
        return status == errSecSuccess
    }

    /**
     Deletes all entries from the keychain (for the `service` specified in `configuration`).
     - Returns: `true` if the action succeeds or `false` in case of an error
     */
    @discardableResult
    func reset() -> Bool {
        let query = [kSecClass: kSecClassGenericPassword, kSecAttrService: configuration.service] as CFDictionary
        let status = SecItemDelete(query)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

// MARK: - Private methods
extension Keychain {

    private func insert(_ data: Data, for key: Data) -> Bool {
        let query = [
            kSecAttrService: configuration.service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data,
        ] as CFDictionary

        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }

    private func update(_ data: Data, for key: Data) -> Bool {
        let query = [
            kSecAttrService: configuration.service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let updateDict = [kSecValueData: data] as CFDictionary

        let status = SecItemUpdate(query, updateDict)
        return status == errSecSuccess
    }
}

extension Keychain {

    /**
     Keychain configuration structure.
     For now, only the service can be specified and if need be, we can add shared
     keychain by defining an accessGroup in the future.
     */
    struct Configuration {
        let service: String

        static var userAuthentication: Configuration {
            return Configuration(service: "Odiggo.Authentication")
        }
    }
}
