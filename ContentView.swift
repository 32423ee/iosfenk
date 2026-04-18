import SwiftUI

struct ContentView: View {
    @State private var isLoading = false
    @State private var visitorId: String?
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Fingerprint Pro iOS Demo")
                    .font(.headline)

                if let visitorId {
                    VStack(spacing: 8) {
                        Text("Visitor ID")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(visitorId)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .textSelection(.enabled)
                    }
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }

                Button {
                    Task {
                        await identify()
                    }
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        Text(isLoading ? "Identifying..." : "Get Visitor ID")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)

                Spacer()
            }
            .padding()
            .navigationTitle("Device ID")
        }
    }

    @MainActor
    private func identify() async {
        isLoading = true
        defer { isLoading = false }

        visitorId = nil
        errorMessage = nil

        do {
            guard let apiKey, !apiKey.isEmpty else {
                throw FingerprintProDemoError.missingApiKey
            }
            let service = FingerprintProService(apiKey: apiKey)
            visitorId = try await service.getVisitorId()
        } catch {
            errorMessage = String(describing: error)
        }
    }

    private var apiKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "FINGERPRINTPRO_API_KEY") as? String
    }
}

enum FingerprintProDemoError: LocalizedError {
    case missingApiKey

    var errorDescription: String? {
        switch self {
        case .missingApiKey:
            "Missing FINGERPRINTPRO_API_KEY in Info.plist"
        }
    }
}

#Preview {
    ContentView()
}
