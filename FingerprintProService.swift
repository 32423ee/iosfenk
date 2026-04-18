import Foundation
import FingerprintPro

final class FingerprintProService {
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func getVisitorId() async throws -> String {
        let configuration = Configuration(apiKey: apiKey)
        let client = FingerprintProFactory.getInstance(configuration)
        return try await client.getVisitorId()
    }
}
