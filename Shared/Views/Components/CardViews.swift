//
//  CardViews.swift
//  Disability Advocacy
//
//  Reusable card components for both iOS and macOS.
//

import SwiftUI

// MARK: - Card Elevation
enum CardElevation {
    case flat
    case standard
    case elevated
    case prominent
    
    var shadowRadius: CGFloat {
        switch self {
        case .flat: return 0
        case .standard: return 10
        case .elevated: return 16
        case .prominent: return 24
        }
    }
    
    var shadowOpacity: Double {
        switch self {
        case .flat: return 0
        case .standard: return 0.12
        case .elevated: return 0.18
        case .prominent: return 0.25
        }
    }
}

// MARK: - Card View Modifiers
struct CardModifier: ViewModifier {
    var cornerRadius: CGFloat
    var padding: CGFloat
    var elevation: CardElevation
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
            )
            .shadow(
                color: Color.black.opacity(elevation.shadowOpacity * 0.5),
                radius: elevation.shadowRadius,
                x: 0,
                y: elevation.shadowRadius / 4
            )
    }
    
    init(cornerRadius: CGFloat = 16, padding: CGFloat = 20, elevation: CardElevation = .standard) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.elevation = elevation
    }
}

struct ElevatedCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .modifier(CardModifier(cornerRadius: cornerRadius, padding: padding, elevation: .elevated))
    }
}

struct CompactCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 12
    var padding: CGFloat = 16
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.primary.opacity(0.05), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle(cornerRadius: CGFloat = 16, padding: CGFloat = 20, elevation: CardElevation = .standard) -> some View {
        self.modifier(CardModifier(cornerRadius: cornerRadius, padding: padding, elevation: elevation))
    }
    
    func prominentCardStyle(cornerRadius: CGFloat = 18, padding: CGFloat = 24) -> some View {
        self.modifier(CardModifier(cornerRadius: cornerRadius, padding: padding, elevation: .prominent))
    }
    
    func secondaryCardStyle(cornerRadius: CGFloat = 16, padding: CGFloat = 20) -> some View {
        self
            .padding(padding)
            .background(Color.secondaryCardBackground)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.secondaryText.opacity(0.08), lineWidth: 0.5)
            )
            .shadow(
                color: Color.black.opacity(0.06),
                radius: 8,
                x: 0,
                y: 2
            )
    }
    
    func elevatedCardStyle(cornerRadius: CGFloat = 16, padding: CGFloat = 20) -> some View {
        self.modifier(ElevatedCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
    
    func compactCardStyle(cornerRadius: CGFloat = 12, padding: CGFloat = 16) -> some View {
        self.modifier(CompactCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
}

// MARK: - Generic Card Containers
struct AppGridCard<Content: View>: View {
    let content: Content
    let minHeight: CGFloat
    
    init(minHeight: CGFloat = 180, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(LayoutConstants.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: minHeight)
            .background(Color.cardBackground)
            .cornerRadius(LayoutConstants.cardCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )
    }
}

struct CardContainer<Content: View>: View {
    let content: Content
    var style: CardStyle = .standard
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = 20
    
    enum CardStyle {
        case standard
        case elevated
        case compact
    }
    
    init(style: CardStyle = .standard, cornerRadius: CGFloat = 16, padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        Group {
            switch style {
            case .standard:
                content.cardStyle(cornerRadius: cornerRadius, padding: padding)
            case .elevated:
                content.elevatedCardStyle(cornerRadius: cornerRadius, padding: padding)
            case .compact:
                content.compactCardStyle(cornerRadius: cornerRadius, padding: padding)
            }
        }
    }
}

// MARK: - Specialized Headers
struct AppDetailHeader<Trailing: View>: View {
    let title: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    let chipText: String?
    let chipStyle: AppChip.Style
    let trailing: Trailing
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        iconColor: Color = .triadPrimary,
        chipText: String? = nil,
        chipStyle: AppChip.Style = .primary,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.chipText = chipText
        self.chipStyle = chipStyle
        self.trailing = trailing()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(iconColor)
                    .frame(width: 56, height: 56)
                    .background(iconColor.opacity(0.1))
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 6) {
                    if let chipText = chipText {
                        AppChip(text: chipText, style: chipStyle)
                    }
                    
                    Text(title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                trailing
            }
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondaryText)
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
}

// MARK: - Entity Cards
struct ResourceCard: View {
    let resource: Resource
    @Environment(AppState.self) var appState
    
    private var isFavorite: Bool {
        appState.isFavorite(resource.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConstants.contentGap) {
            HStack(alignment: .firstTextBaseline, spacing: LayoutConstants.spacingS) {
                AppChip(text: resource.category.rawValue, style: .primary)

                Spacer(minLength: 8)

                Button {
                    Task { await appState.toggleFavorite(resource.id) }
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? Color.semanticError : Color.secondary)
                        .imageScale(.medium)
                }
                .buttonStyle(.plain)
            }

            Text(resource.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(TextAlignment.leading)

            Text(resource.description)
                .secondaryBody()
                .lineLimit(2)
                .multilineTextAlignment(TextAlignment.leading)

            if !resource.tags.isEmpty {
                HStack(spacing: 8) {
                    ForEach(resource.tags.prefix(2), id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundStyle(.tint)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 2)
            }
        }
        .appCard(padding: LayoutConstants.paddingL, elevation: .standard)
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: LayoutConstants.spacingL) {
            VStack(spacing: 2) {
                Text(dayOfMonth)
                    .font(.title3.weight(.bold))
                    .monospacedDigit()
                Text(monthAbbrev)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 50, height: 50)
            .background(Color.triadSecondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .foregroundStyle(.triadSecondary)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Label {
                    Text(event.isVirtual ? String(localized: "Virtual") : event.location)
                        .emphasizedCaption()
                } icon: {
                    Image(systemName: event.isVirtual ? "video.fill" : "mappin.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.triadSecondary)
                }
            }

            Spacer(minLength: 0)
            
            Image(systemName: "chevron.right")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.tertiaryText)
        }
        .appCard(padding: LayoutConstants.paddingM, elevation: .standard)
    }
    
    private var dayOfMonth: String {
        String(Calendar.current.component(.day, from: event.date))
    }
    
    private var monthAbbrev: String {
        Calendar.current.shortMonthSymbols[Calendar.current.component(.month, from: event.date) - 1].uppercased()
    }
}

struct AppNavigationGridCard<V: Hashable>: View {
    let title: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    let value: V
    
    init(title: String, subtitle: String? = nil, icon: String, iconColor: Color = .triadPrimary, value: V) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.value = value
    }
    
    var body: some View {
        NavigationLink(value: value) {
            AppGridCard(minHeight: 140) {
                VStack(alignment: .leading, spacing: LayoutConstants.spacingM) {
                    Image(systemName: icon)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(iconColor)
                        .frame(width: 44, height: 44)
                        .background(iconColor.opacity(0.1))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.primary)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondaryText)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    HStack {
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.tertiaryText)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct NewsArticleGridCard: View {
    let article: NewsArticle
    
    var body: some View {
        AppGridCard {
            VStack(alignment: .leading, spacing: LayoutConstants.spacingM) {
                HStack {
                    AppChip(text: article.category, style: .primary)
                    Spacer()
                    Text(article.date, style: .date)
                        .captionText()
                }
                
                VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
                    Text(article.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primaryText)
                        .lineLimit(2)
                    
                    Text(article.summary)
                        .lineLimit(4)
                        .secondaryBody()
                }
                
                Spacer(minLength: 0)
                
                HStack {
                    Label(article.source, systemImage: "newspaper.fill")
                        .emphasizedCaption()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiaryText)
                }
            }
        }
    }
}

struct AdvocacyToolGridCard: View {
    let tool: AdvocacyTool
    
    var body: some View {
        AppGridCard {
            VStack(alignment: .leading, spacing: LayoutConstants.spacingM) {
                Image(systemName: tool.icon)
                    .font(.title)
                    .foregroundStyle(tool.color)
                    .frame(width: 48, height: 48)
                    .background(tool.color.opacity(0.1))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
                    Text(tool.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primaryText)
                    
                    Text(tool.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondaryText)
                        .lineLimit(3)
                }
                
                Spacer(minLength: 0)
                
                HStack {
                    Text(String(localized: "Use Tool"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(tool.color)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundStyle(tool.color)
                }
            }
        }
    }
}

struct CommunityPostGridCard: View {
    let post: CommunityPost
    
    var body: some View {
        AppGridCard {
            VStack(alignment: .leading, spacing: LayoutConstants.spacingM) {
                HStack {
                    AppChip(text: post.category.rawValue, style: .tertiary)
                    Spacer()
                    Text(post.datePosted, style: .date)
                        .font(.caption)
                        .foregroundStyle(.tertiaryText)
                }
                
                VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
                    Text(post.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primaryText)
                        .lineLimit(2)
                    
                    Text(post.content)
                        .font(.subheadline)
                        .foregroundStyle(.secondaryText)
                        .lineLimit(3)
                }
                
                Spacer(minLength: 0)
                
                HStack {
                    Label(post.author, systemImage: "person.circle")
                        .emphasizedCaption()
                    
                    Spacer()
                    
                    HStack(spacing: LayoutConstants.spacingM) {
                        Label("\(post.likes)", systemImage: "heart.fill")
                            .foregroundStyle(.triadSecondary)
                        Label("\(post.replies.count)", systemImage: "bubble.right.fill")
                            .foregroundStyle(.triadPrimary)
                    }
                    .font(.caption.weight(.bold))
                }
            }
        }
    }
}

struct SearchResultGridCard: View {
    let result: SearchResult
    
    var body: some View {
        AppGridCard {
            VStack(alignment: .leading, spacing: LayoutConstants.spacingM) {
                HStack {
                    AppChip(text: result.type.rawValue.capitalized, style: result.type == .resource ? .primary : .secondary)
                    Spacer()
                    Image(systemName: result.icon)
                        .foregroundStyle(result.type == .resource ? .triadPrimary : .triadSecondary)
                }
                
                VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
                    Text(result.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primaryText)
                        .lineLimit(2)
                    
                    Text(result.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondaryText)
                        .lineLimit(3)
                }
                
                Spacer(minLength: 0)
                
                HStack {
                    Text(String(localized: "View Details"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundStyle(.tertiaryText)
                }
            }
        }
    }
}

struct DisabilityLawGridCard: View {
    let law: DisabilityLaw
    
    var body: some View {
        AppGridCard {
            VStack(alignment: .leading, spacing: LayoutConstants.spacingM) {
                HStack {
                    AppChip(text: "Enacted \(law.year)", style: .tertiary)
                    Spacer()
                    Image(systemName: "shield.fill")
                        .foregroundStyle(.triadPrimary)
                }
                
                VStack(alignment: .leading, spacing: LayoutConstants.spacingS) {
                    Text(law.name)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primaryText)
                        .lineLimit(2)
                    
                    Text(law.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondaryText)
                        .lineLimit(3)
                }
                
                Spacer(minLength: 0)
                
                HStack {
                    Text(String(localized: "View Details"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.triadPrimary)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundStyle(.triadPrimary)
                }
            }
        }
    }
}
