import SwiftUI

struct ProfileToolbarButton: View {
    var body: some View {
        NavigationLink(value: "profile") {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
        }
        .accessibilityLabel(String(localized: "Profile"))
    }
}
