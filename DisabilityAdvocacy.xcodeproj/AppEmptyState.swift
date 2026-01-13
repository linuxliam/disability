import SwiftUI

struct AppEmptyState: View {
    let title: String
    let systemImage: String
    let description: String
    
    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            Text(description).secondaryBody()
        }
    }
}
