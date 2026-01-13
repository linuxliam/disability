//
//  OnboardingView.swift
//  Disability Advocacy iOS
//
//  Onboarding flow for new users
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: String(localized: "Welcome to Disability Advocacy"),
            description: String(localized: "Your comprehensive resource for disability rights, community support, and advocacy tools."),
            icon: "hand.raised.fill",
            color: .triadPrimary
        ),
        OnboardingPage(
            title: String(localized: "Discover Resources"),
            description: String(localized: "Access a library of resources covering legal rights, employment, education, healthcare, and more."),
            icon: "book.fill",
            color: .triadPrimary
        ),
        OnboardingPage(
            title: String(localized: "Stay Connected"),
            description: String(localized: "Join events, participate in community discussions, and stay updated with the latest news."),
            icon: "person.3.fill",
            color: .triadTertiary
        ),
        OnboardingPage(
            title: String(localized: "Advocacy Tools"),
            description: String(localized: "Use our tools to write letters, learn about your rights, and advocate for yourself and others."),
            icon: "megaphone.fill",
            color: .triadSecondary
        )
    ]
    
    var body: some View {
        ZStack {
            Color.groupedBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                #if os(iOS)
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                #endif
                
                // Bottom Actions
                VStack(spacing: LayoutConstants.spacingL) {
                    // Skip/Next Button
                    HStack {
                        if currentPage < pages.count - 1 {
                            Button(String(localized: "Skip")) {
                                completeOnboarding()
                            }
                            .font(.body)
                            .foregroundStyle(.secondaryText)
                            
                            Spacer()
                            
                            Button(String(localized: "Next")) {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                            .font(.headline)
                            .foregroundStyle(.tint)
                        } else {
                            Button(String(localized: "Get Started")) {
                                completeOnboarding()
                            }
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: LayoutConstants.buttonHeight)
                            .background(Color.accentColor)
                            .cornerRadius(LayoutConstants.buttonCornerRadius)
                        }
                    }
                    .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                    .padding(.top, LayoutConstants.paddingXL)
                }
                .padding(.bottom, LayoutConstants.paddingXL)
            }
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        withAnimation {
            isPresented = false
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: LayoutConstants.paddingXXXL) {
            Spacer()
            
            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(page.color)
                .frame(width: 160, height: 160)
                .background(page.color.opacity(0.1))
                .clipShape(Circle())
            
            // Title
            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
            
            // Description
            Text(page.description)
                .font(.body)
                .foregroundStyle(.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(LayoutConstants.lineSpacing)
                .padding(.horizontal, LayoutConstants.contentHorizontalPadding)
            
            Spacer()
        }
        .padding(.vertical, LayoutConstants.paddingXXXL)
    }
}



