import Foundation
import FingerprintPro

final class FingerprintProService {
    private let client: FingerprintProClient

    init(apiKey: String) {
        let configuration = Configuration(apiKey: apiKey)
        self.client = FingerprintProFactory.getInstance(configuration)
    }

    func getVisitorId() async throws -> String {
        try await client.getVisitorId()
    }
}
