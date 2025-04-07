import SwiftUI

public struct PaywallOption: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let priceText: String

    public init(id: String, title: String, subtitle: String? = nil, priceText: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.priceText = priceText
    }
}

public struct ProPaywallView: View {
    let title: String
    let features: [String]
    let options: [PaywallOption]
    let selectedID: String
    let onSelect: (PaywallOption) -> Void
    let onSubscribe: (PaywallOption) -> Void
    let policyLinks: [(title: String, url: URL)]
    let onClose: (() -> Void)?
    let onRestore: (() -> Void)?

    public init(
        title: String,
        features: [String],
        options: [PaywallOption],
        selectedID: String,
        onSelect: @escaping (PaywallOption) -> Void,
        onSubscribe: @escaping (PaywallOption) -> Void,
        policyLinks: [(title: String, url: URL)],
        onClose: (() -> Void)? = nil,
        onRestore: (() -> Void)? = nil
    ) {
        self.title = title
        self.features = features
        self.options = options
        self.selectedID = selectedID
        self.onSelect = onSelect
        self.onSubscribe = onSubscribe
        self.policyLinks = policyLinks
        self.onClose = onClose
        self.onRestore = onRestore
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                if let onClose = onClose {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .padding()
                    }
                }

                Spacer()

                if let onRestore = onRestore {
                    Button("恢复购买") {
                        onRestore()
                    }
                    .padding(.trailing)
                    .font(.subheadline)
                }
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(title)
                        .font(.title3)
                        .bold()

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(features, id: \.self) { feature in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(feature)
                            }
                        }
                    }

                    VStack(spacing: 12) {
                        ForEach(options) { option in
                            Button(action: {
                                onSelect(option)
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(option.title)
                                            .font(.headline)
                                        if let subtitle = option.subtitle {
                                            Text(subtitle)
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    Spacer()
                                    Text(option.priceText)
                                        .font(.headline)
                                }
                                .padding()
                                .frame(height: 70)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            option.id == selectedID ? Color.black : Color.gray.opacity(0.3),
                                            lineWidth: option.id == selectedID ? 2 : 1
                                        )
                                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    Text("自动续订说明：订阅将在到期前24小时自动续订，可随时在App Store设置中取消。")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }

            VStack(spacing: 12) {
                Button(action: {
                    if let selected = options.first(where: { $0.id == selectedID }) {
                        onSubscribe(selected)
                    }
                }) {
                    Text("订阅 " + (options.first(where: { $0.id == selectedID })?.priceText ?? ""))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                HStack(spacing: 6) {
                    ForEach(policyLinks.indices, id: \.self) { index in
                        let link = policyLinks[index]
                        Button(link.title) {
                            UIApplication.shared.open(link.url)
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)

                        if index < policyLinks.count - 1 {
                            Text("·").foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            .padding(.horizontal)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}