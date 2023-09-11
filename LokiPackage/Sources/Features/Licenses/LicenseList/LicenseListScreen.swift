import SwiftUI
import LogCore

public struct LicenseListScreen: View {
    @State private var selectedLicense: LicensesPlugin.License?

    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        NavigationSplitView {
            List(LicensesPlugin.licenses, selection: $selectedLicense) { license in
                NavigationLink(license.name, value: license)
            }
            .navigationTitle(L10n.licenses)
            .licenseListScreenToolbar(onCloseButtonClick: { dismiss() })
        } detail: {
            if let selectedLicense {
                LicenseDetailScreen(license: selectedLicense)
            } else {
                Text(L10n.selectALicense)
                    .foregroundColor(.secondary)
            }
        }
    }

    public init() {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
    }
}

// MARK: - Privates

private extension View {
    func licenseListScreenToolbar(
        onCloseButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onCloseButtonClick()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct LicenseListScreen_Previews: PreviewProvider {
    static var previews: some View {
        LicenseListScreen()
    }
}
#endif
