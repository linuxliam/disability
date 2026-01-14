//
//  EventsView.swift
//  Disability Advocacy iOS
//
//  Events calendar and listings
//

import SwiftUI

struct EventsView: View {
    @Environment(AppState.self) var appState
    @State private var viewModel = EventsViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // MARK: - Filter Buttons
    private var filterButtonRow: some View {
        VStack(spacing: LayoutConstants.spacingS) {
            Picker(String(localized: "Category"), selection: $viewModel.selectedCategory) {
                Text(String(localized: "All Categories")).tag(Optional<EventCategory>.none)
                ForEach(EventCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(Optional(category))
                }
            }
            .pickerStyle(.menu)
            
            Picker(String(localized: "Date"), selection: $viewModel.dateFilter) {
                ForEach(EventDateFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.events.isEmpty {
                VStack(spacing: 0) {
                    // Filter row placeholder
                    HStack {
                        SkeletonView()
                            .frame(width: 120, height: 32)
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                    .padding(.vertical, LayoutConstants.paddingM)
                    
                    // List skeletons
                    List {
                        ForEach(0..<6) { _ in
                            EventSkeletonRow()
                        }
                    }
                    .listStyle(.plain)
                }
            } else if let errorMessage = viewModel.errorMessage {
                EmptyStateView(
                    icon: "exclamationmark.triangle",
                    title: String(localized: "Unable to Load Events"),
                    message: errorMessage
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 0) {
                    // Category Picker
                    filterButtonRow
                        .padding(.vertical, LayoutConstants.paddingM)
                    
                    // Events List
                    if viewModel.filteredEvents.isEmpty && !viewModel.isLoading {
                        EmptyStateView(
                            icon: "calendar",
                            title: String(localized: "No events found"),
                            message: viewModel.selectedCategory != nil
                                ? String(localized: "Try selecting a different category or clearing the filter.")
                                : String(localized: "Check back soon for upcoming events."),
                            primaryActionTitle: viewModel.selectedCategory != nil ? String(localized: "Clear filter") : String(localized: "Refresh"),
                            primaryAction: {
                                if viewModel.selectedCategory != nil {
                                    viewModel.clearFilters()
                                } else {
                                    viewModel.loadEvents()
                                }
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Group {
                            #if os(macOS)
                            GeometryReader { geometry in
                                ScrollView {
                                    VStack(alignment: .leading, spacing: LayoutConstants.sectionHeaderSpacing) {
                                        AppSectionHeader(
                                            title: viewModel.selectedCategory.map { LocalizedStringKey($0.rawValue) } ?? "Upcoming Events",
                                            systemImage: "calendar"
                                        )
                                        .padding(.bottom, LayoutConstants.spacingS)
                                        
                                        LazyVGrid(columns: AdaptiveLayout.gridColumns(for: .regular, availableWidth: geometry.size.width), spacing: LayoutConstants.cardGap) {
                                            ForEach(viewModel.filteredEvents) { event in
                                                NavigationLink(value: event) {
                                                    EventCard(event: event)
                                                }
                                                .buttonStyle(.plain)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, LayoutConstants.screenHorizontalPadding)
                                    .padding(.top, LayoutConstants.paddingM)
                                    .padding(.bottom, LayoutConstants.paddingXXL)
                                    .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            #else
                            List {
                                Section {
                                    ForEach(viewModel.filteredEvents) { event in
                                        NavigationLink(value: event) {
                                            EventRow(event: event)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                } header: {
                                    AppSectionHeader(
                                        title: viewModel.selectedCategory.map { LocalizedStringKey($0.rawValue) } ?? "Upcoming Events",
                                        systemImage: "calendar"
                                    )
                                }
                            }
                                    #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
                            #endif
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "Events"))
        .platformInlineNavigationTitle()
        .toolbar {
            ToolbarItem(placement: PlatformUI.trailingToolbarItemPlacement) {
                ProfileToolbarButton()
            }
        }
        .appListBackground()
        .appScreenChrome()
        .refreshable {
            viewModel.loadEvents()
        }
        .task {
            if viewModel.events.isEmpty {
                viewModel.loadEvents()
            }
        }
    }
}

struct EventRow: View {
    let event: Event
    
    // Use native Calendar API instead of DateFormatter
    private var dayOfMonth: String {
        String(Calendar.current.component(.day, from: event.date))
    }
    
    private var monthAbbrev: String {
        Calendar.current.shortMonthSymbols[Calendar.current.component(.month, from: event.date) - 1]
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: LayoutConstants.spacingM) {
            // Date Display
            VStack(spacing: LayoutConstants.spacingXS) {
                Text(dayOfMonth)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(monthAbbrev)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
            }
            .frame(width: 50)
            .padding(.vertical, LayoutConstants.spacingS)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(LayoutConstants.buttonCornerRadius)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Date: \(event.date.formatted(date: .abbreviated, time: .omitted))")
            
            // Event Details
            VStack(alignment: .leading, spacing: LayoutConstants.paddingS) {
                Text(event.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .accessibilityAddTraits(.isHeader)
                
                Text(event.description)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
                    .lineLimit(2)
                
                HStack {
                    Label(locationText, systemImage: locationIcon)
                        .font(.caption)
                        .foregroundStyle(Color.secondaryText)
                    
                    if event.accessibilityNotes != nil {
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle.fill")
                                .font(.caption)
                            Text(String(localized: "Accessibility info available"))
                                .font(.caption)
                        }
                        .foregroundStyle(.tint)
                        .accessibilityLabel(String(localized: "Accessibility information available"))
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, LayoutConstants.paddingS)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(event.title), \(event.date.formatted(date: .abbreviated, time: .shortened)). \(locationText)")
        .accessibilityHint(String(localized: "Double tap to view event details and add to calendar"))
    }
    
    private var locationText: String {
        event.isVirtual ? String(localized: "Virtual") : event.location
    }
    
    private var locationIcon: String {
        event.isVirtual ? "video.fill" : "mappin.circle.fill"
    }
    
    // Use native Date.formatted() API for string formatting when needed
    private func formattedDateString(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
}

@MainActor
struct EventDetailView: View {
    let event: Event
    @Bindable private var calendarManager = CalendarManager.shared
    @State private var isAddingToCalendar = false
    
    var body: some View {
        List {
            Section {
                AppDetailHeader(
                    title: event.title,
                    subtitle: nil,
                    icon: "calendar",
                    iconColor: .triadSecondary,
                    chipText: event.category.rawValue,
                    chipStyle: .secondary
                ) {
                    VStack(spacing: 4) {
                        Text(dayOfMonth)
                            .font(.title3.weight(.bold))
                        Text(monthAbbrev)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 56, height: 56)
                    .background(Color.triadSecondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.triadSecondary)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            Section("About This Event") {
                Text(event.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }
            
            if let notes = event.accessibilityNotes {
                Section("Accessibility Information") {
                    Label {
                        Text(notes)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    } icon: {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.tint)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section {
                actionButtons
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }
        }
        #if os(iOS)
                #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        #else
        .listStyle(.inset)
        #endif
        .appScreenChrome()
        .navigationTitle(String(localized: "Event Details"))
        .platformInlineNavigationTitle()
        .frame(maxWidth: AdaptiveLayout.contentMaxWidth(for: .regular))
        .frame(maxWidth: .infinity)
        .alert(String(localized: "Calendar"), isPresented: $calendarManager.showAlert) {
            Button(String(localized: "OK"), role: .cancel) { }
        } message: {
            Text(calendarManager.alertMessage)
        }
        .alert(String(localized: "Calendar Access Required"), isPresented: $calendarManager.showSettingsAlert) {
            Button(String(localized: "Open Settings")) {
                calendarManager.openAppSettings()
            }
            Button(String(localized: "Cancel"), role: .cancel) { }
        } message: {
            Text(String(localized: "Calendar access is required to add events. Please enable it in Settings to continue."))
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: LayoutConstants.spacingM) {
                    // Add to Calendar Button
                    Button(action: {
                        HapticManager.medium()
                        isAddingToCalendar = true
                        Task {
                            let success = await calendarManager.addEventToCalendar(event: event)
                            isAddingToCalendar = false
                            if success {
                                HapticManager.success()
                            } else {
                                HapticManager.error()
                            }
                        }
                    }) {
                        HStack {
                            if isAddingToCalendar {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.headline)
                            }
                            Text(isAddingToCalendar ? String(localized: "Adding to Calendar...") : String(localized: "Add to Calendar"))
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: LayoutConstants.buttonHeight)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .cornerRadius(LayoutConstants.buttonCornerRadius)
                    }
                    .disabled(isAddingToCalendar)
                    
                    // Registration Link
                    if let url = event.registrationURL, let registrationURL = URL(string: url) {
                        Link(destination: registrationURL) {
                            HStack {
                                Image(systemName: "link")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text(String(localized: "Register for Event"))
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: LayoutConstants.buttonHeight)
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .cornerRadius(LayoutConstants.buttonCornerRadius)
                        }
                    }
                    
                    // Event Link (if different from registration)
                    if let eventURLString = event.eventURL, 
                       eventURLString != event.registrationURL,
                       let eventURL = URL(string: eventURLString) {
                        Link(destination: eventURL) {
                            HStack {
                                Image(systemName: "safari")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text(String(localized: "View Event Details"))
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: LayoutConstants.buttonHeight)
                            .background(Color.cardBackground)
                            .foregroundStyle(.tint)
                            .cornerRadius(LayoutConstants.buttonCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: LayoutConstants.buttonCornerRadius)
                                    .stroke(Color.accentColor, lineWidth: 2)
                            )
                        }
                    }
                }
        }
    
    // Use native Calendar API instead of DateFormatter
    private var dayOfMonth: String {
        String(Calendar.current.component(.day, from: event.date))
    }
    
    private var monthAbbrev: String {
        Calendar.current.shortMonthSymbols[Calendar.current.component(.month, from: event.date) - 1].uppercased()
    }
}
