//
//  ProfileComponents.swift
//  Disability Advocacy
//
//  Extracted sub-views and components for the Profile screen.
//

import SwiftUI

// MARK: - Profile Section Wrapper

struct ProfileSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(.tint)
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primaryText)
            }
            
            content
        }
        .padding(LayoutConstants.paddingXL)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardBackground)
        .cornerRadius(LayoutConstants.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cardCornerRadius)
                .stroke(Color("borderColor").opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.1), radius: LayoutConstants.cardShadowRadius, x: 0, y: LayoutConstants.cardShadowRadius / 2)
    }
}

// MARK: - Info Row

struct ProfileInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryText)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.primaryText)
        }
    }
}

// MARK: - Custom Text Field

struct ProfileTextField: View {
    let title: String
    @Binding var text: String
    #if os(iOS)
    var keyboardType: UIKeyboardType = .default
    #endif
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.primaryText)
            
            TextField("Enter \(title.lowercased())", text: $text)
                #if os(iOS)
                .keyboardType(keyboardType)
                #endif
                .textFieldStyle(.plain)
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
                .autocorrectionDisabled()
                #if os(iOS)
                .submitLabel(.next)
                #endif
                .padding(LayoutConstants.spacingM)
                .background(Color.groupedBackground)
                .cornerRadius(LayoutConstants.buttonCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutConstants.buttonCornerRadius)
                        .stroke(Color("borderColor").opacity(0.2), lineWidth: 0.5)
                )
        }
    }
}

// MARK: - Interest Editor

struct InterestEditor: View {
    @Binding var interests: [String]
    @State private var newInterest = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                TextField("Add interest", text: $newInterest)
                    .textFieldStyle(.plain)
                    .padding(LayoutConstants.paddingM)
                    .background(Color.groupedBackground)
                    .cornerRadius(LayoutConstants.buttonCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutConstants.buttonCornerRadius)
                            .stroke(Color("borderColor").opacity(0.2), lineWidth: 0.5)
                    )
                
                Button(action: {
                    if !newInterest.trimmingCharacters(in: .whitespaces).isEmpty {
                        interests.append(newInterest.trimmingCharacters(in: .whitespaces))
                        newInterest = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.tint)
                }
            }
            
            if !interests.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: LayoutConstants.spacingS)], alignment: .leading, spacing: LayoutConstants.spacingS) {
                    ForEach(interests, id: \.self) { interest in
                        HStack(spacing: LayoutConstants.spacingXS) {
                            Text(interest)
                                .font(.caption)
                            Button(action: {
                                interests.removeAll { $0 == interest }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption2)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.15))
                        .foregroundStyle(.tint)
                        .cornerRadius(LayoutConstants.buttonCornerRadius)
                    }
                }
            }
        }
    }
}

// MARK: - Accessibility Needs Editor

struct AccessibilityNeedsEditor: View {
    @Binding var needs: [String]
    @State private var newNeed = ""
    
    let commonNeeds = [
        "Wheelchair Access",
        "Visual Impairment Support",
        "Hearing Impairment Support",
        "Cognitive Accessibility",
        "Mobility Assistance",
        "Sign Language Interpreter",
        "Captioning Services",
        "Assistive Technology"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Quick add buttons
            Text(String(localized: "Common Needs"))
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], alignment: .leading, spacing: 8) {
                ForEach(commonNeeds, id: \.self) { need in
                    Button(action: {
                        if !needs.contains(need) {
                            needs.append(need)
                        }
                    }) {
                        Text(need)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(needs.contains(need) ? Color("accentGreen").opacity(0.2) : Color.groupedBackground)
                            .foregroundStyle(needs.contains(need) ? Color("accentGreen") : .primaryText)
                            .cornerRadius(LayoutConstants.buttonCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(needs.contains(need) ? Color("accentGreen") : Color("borderColor").opacity(0.2), lineWidth: 1)
                            )
                    }
                    .accessibilityLabel(needs.contains(need) ? "\(need), selected" : "\(need), not selected")
                    .accessibilityHint("Double tap to \(needs.contains(need) ? "remove" : "add") this accessibility need")
                    .accessibilityAddTraits(needs.contains(need) ? .isSelected : [])
                }
            }
            
            // Custom need input
            HStack {
                TextField(String(localized: "Add custom need"), text: $newNeed)
                    .textFieldStyle(.plain)
                    .padding(LayoutConstants.paddingM)
                    .background(Color.groupedBackground)
                    .cornerRadius(LayoutConstants.buttonCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutConstants.buttonCornerRadius)
                            .stroke(Color("borderColor").opacity(0.2), lineWidth: 0.5)
                    )
                    .accessibilityLabel(String(localized: "Add custom accessibility need"))
                    .accessibilityHint(String(localized: "Enter a custom accessibility need that is not in the list above"))
                
                Button(action: {
                    if !newNeed.trimmingCharacters(in: .whitespaces).isEmpty {
                        needs.append(newNeed.trimmingCharacters(in: .whitespaces))
                        newNeed = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.tint)
                }
                .accessibilityLabel(String(localized: "Add custom need"))
                .accessibilityHint(String(localized: "Add the custom accessibility need entered in the text field"))
            }
            
            // Current needs with remove option
            if !needs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(needs, id: \.self) { need in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color("accentGreen"))
                            Text(need)
                                .font(.subheadline)
                            Spacer()
                            Button(action: {
                                needs.removeAll { $0 == need }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .accessibilityLabel("Remove \(need)")
                                    .accessibilityHint("Double tap to remove this accessibility need")
                                    .foregroundStyle(Color.secondaryText)
                            }
                        }
                        .padding(LayoutConstants.spacingM)
                        .background(Color("accentGreen").opacity(0.1))
                        .cornerRadius(LayoutConstants.buttonCornerRadius)
                    }
                }
            }
        }
    }
}

