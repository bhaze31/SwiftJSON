import Testing
import Foundation
@testable import SwiftJSON

struct JSONTests {
    @Test("It can encode and decode JSON") func testJSONSerialization() {
        let dictionary: [String: Codable] = [
            "user_id": 123,
            "user_name": "John Doe",
            "user_email": "john.doe@example.com",
            "user_average_rating": 4.5,
            "user_address": [
                "street_number": "123 Main St",
                "city": "Anytown",
                "state": "CA",
                "zip": "12345"
            ],
            "user_nicknames": ["John", "Johnny", "JD"]
        ]

        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary)
            let json = try! JSONDecoder().decode(JSON.self, from: data)
            guard let keys = try? json.keys() else {
                Issue.record("Failed to retrieve keys")
                return
            }
            #expect(keys.count == 6, "Expected 6 keys, but got \(keys.count)")

            ["user_id", "user_name", "user_email", "user_average_rating", "user_address", "user_nicknames"].forEach { key in
                #expect(keys.contains(key), "Expected key '\(key)' to be present")
            }

            guard let jsonData = try? json.dictionaryData() else {
                Issue.record("Failed to retrieve dictionary")
                return
            }

            #expect(jsonData["user_id"]?.intValue() == 123)
            #expect(jsonData["user_name"]?.stringValue() == "John Doe")
            #expect(jsonData["user_email"]?.stringValue() == "john.doe@example.com")
            #expect(jsonData["user_average_rating"]?.doubleValue() == 4.5)
            guard let nicknames = jsonData["user_nicknames"]?.arrayValue() else {
                Issue.record("Failed to retrieve nicknames")
                return
            }
            #expect(nicknames.count == 3)
            guard let address = try? jsonData["user_address"]?.dictionaryData() else {
                Issue.record("Failed to retrieve address")
                return
            }
            #expect(address["street_number"]?.stringValue() == "123 Main St")
            #expect(address["city"]?.stringValue() == "Anytown")
            #expect(address["state"]?.stringValue() == "CA")
            #expect(address["zip"]?.stringValue() == "12345")
        } catch {
            Issue.record(error)
        }
    }
}
