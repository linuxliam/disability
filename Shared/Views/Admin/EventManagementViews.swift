//
//  EventManagementViews.swift
//  Disability Advocacy
//
//  Views for managing and editing event content.
//

import SwiftUI

@MainActor
struct ManageEventsView: View {
    @State private var events: [Event] = []
    @State private var showingEditView = false
    @State private var selectedEvent: Event?
    
    var body: some View {
        List {
            Section {
                ForEach(events) { event in
                    Button {
                        selectedEvent = event
                        showingEditView = true
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.title)
                                .font(.body.weight(.bold))
                                .foregroundStyle(.primary)
                            HStack {
                                Text(event.category.rawValue)
                                Text("•")
                                Text(event.date, style: .date)
                            }
                            .font(.caption)
                            .foregroundStyle(Color.secondaryText)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteEvents)
            } header: {
                AppSectionHeader(
                    title: "Events",
                    systemImage: "calendar.badge.plus",
                    actionTitle: "Add",
                    action: {
                        selectedEvent = nil
                        showingEditView = true
                    }
                )
                .tint(.triadPrimary)
            }
        }
                #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        .appListBackground()
        .navigationTitle(String(localized: "Manage Events"))
        .sheet(isPresented: $showingEditView) {
            NavigationStack {
                EventEditView(event: selectedEvent) { updatedEvent in
                    if let _ = selectedEvent {
                        EventsManager.shared.updateEvent(updatedEvent)
                    } else {
                        EventsManager.shared.addEvent(updatedEvent)
                    }
                    loadEvents()
                }
            }
        }
        .onAppear(perform: loadEvents)
    }
    
    @MainActor
    private func loadEvents() {
        events = EventsManager.shared.getAllEvents()
    }
    
    @MainActor
    private func deleteEvents(at offsets: IndexSet) {
        for index in offsets {
            EventsManager.shared.deleteEvent(id: events[index].id)
        }
        loadEvents()
    }
}

@MainActor
struct EventEditView: View {
    @Environment(\.dismiss) var dismiss
    
    let event: Event?
    let onSave: (Event) -> Void
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var location: String = ""
    @State private var isVirtual: Bool = false
    @State private var registrationURL: String = ""
    @State private var eventURL: String = ""
    @State private var category: EventCategory = .workshop
    @State private var accessibilityNotes: String = ""
    
    var body: some View {
        Form {
            Section(header: Text(String(localized: "Details"))) {
                TextField(String(localized: "Title"), text: $title)
                TextField(String(localized: "Description"), text: $description, axis: .vertical)
                    .lineLimit(3...5)
                
                DatePicker(String(localized: "Date"), selection: $date)
                
                Picker(String(localized: "Category"), selection: $category) {
                    ForEach(EventCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
            }
            
            Section(header: Text(String(localized: "Location & Type"))) {
                Toggle(String(localized: "Virtual Event"), isOn: $isVirtual)
                TextField(String(localized: "Location"), text: $location)
            }
            
            Section(header: Text(String(localized: "Links (Optional)"))) {
                TextField(String(localized: "Registration URL"), text: $registrationURL)
                    #if os(iOS)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    #endif
                TextField(String(localized: "Event URL"), text: $eventURL)
                    #if os(iOS)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    #endif
            }
            
            Section(header: Text(String(localized: "Accessibility"))) {
                TextField(String(localized: "Accessibility Notes"), text: $accessibilityNotes, axis: .vertical)
                    .lineLimit(2...3)
            }
        }
        .navigationTitle(event == nil ? String(localized: "New Event") : String(localized: "Edit Event"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Cancel")) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Save")) {
                    let newEvent = Event(
                        id: event?.id ?? UUID(),
                        title: title,
                        description: description,
                        date: date,
                        location: location,
                        isVirtual: isVirtual,
                        registrationURL: registrationURL.isEmpty ? nil : registrationURL,
                        eventURL: eventURL.isEmpty ? nil : eventURL,
                        category: category,
                        accessibilityNotes: accessibilityNotes.isEmpty ? nil : accessibilityNotes
                    )
                    onSave(newEvent)
                    dismiss()
                }
                .disabled(title.isEmpty || description.isEmpty || location.isEmpty)
            }
        }
        .onAppear {
            if let e = event {
                title = e.title
                description = e.description
                date = e.date
                location = e.location
                isVirtual = e.isVirtual
                registrationURL = e.registrationURL ?? ""
                eventURL = e.eventURL ?? ""
                category = e.category
                accessibilityNotes = e.accessibilityNotes ?? ""
            }
        }
    }
}
