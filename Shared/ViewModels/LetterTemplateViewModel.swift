//
//  LetterTemplateViewModel.swift
//  Disability Advocacy iOS
//
//  View model for letter template generator
//

import Foundation
import Observation

@MainActor
@Observable
class LetterTemplateViewModel {
    var templates: [LetterTemplate] = []
    var selectedTemplate: LetterTemplate?
    var filledPlaceholders: [UUID: String] = [:]
    var generatedLetter: String = ""
    var isLoading: Bool = false
    
    nonisolated init() {
        // Templates will be loaded on MainActor when loadTemplates() is called
        // This allows initialization from non-isolated contexts
    }
    
    func loadTemplates() {
        templates = LetterTemplate.sampleTemplates
    }
    
    func selectTemplate(_ template: LetterTemplate) {
        selectedTemplate = template
        filledPlaceholders = [:]
        generatedLetter = ""
        // Initialize placeholders with empty values
        for placeholder in template.placeholders {
            filledPlaceholders[placeholder.id] = ""
        }
    }
    
    func updatePlaceholder(id: UUID, value: String) {
        filledPlaceholders[id] = value
    }
    
    func generateLetter() {
        guard let template = selectedTemplate else { return }
        
        var letter = template.templateText
        
        // Replace placeholders with filled values
        for placeholder in template.placeholders {
            let value = filledPlaceholders[placeholder.id] ?? ""
            letter = letter.replacingOccurrences(of: "[\(placeholder.key)]", with: value)
        }
        
        // Replace date placeholder with current date if not filled
        if letter.contains("[Date]") && (filledPlaceholders.values.first { $0.isEmpty } != nil) {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            letter = letter.replacingOccurrences(of: "[Date]", with: formatter.string(from: Date()))
        }
        
        generatedLetter = letter
    }
    
    func canGenerateLetter() -> Bool {
        guard let template = selectedTemplate else { return false }
        
        // Check if all required placeholders are filled
        for placeholder in template.placeholders where placeholder.required {
            guard let value = filledPlaceholders[placeholder.id], !value.trimmingCharacters(in: .whitespaces).isEmpty else {
                return false
            }
        }
        
        return true
    }
    
    func clearLetter() {
        selectedTemplate = nil
        filledPlaceholders = [:]
        generatedLetter = ""
    }
}



