//
//  LetterTemplate.swift
//  Disability Advocacy iOS
//
//  Letter template model for advocacy letters
//

import Foundation

struct LetterTemplate: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let category: LetterCategory
    let templateText: String
    let placeholders: [Placeholder]
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: LetterCategory,
        templateText: String,
        placeholders: [Placeholder] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.templateText = templateText
        self.placeholders = placeholders
    }
}

enum LetterCategory: String, Codable, CaseIterable {
    case legislator = "Legislator"
    case employer = "Employer"
    case serviceProvider = "Service Provider"
    case school = "School/University"
    case accommodation = "Accommodation Request"
    case complaint = "Complaint"
    
    var icon: String {
        switch self {
        case .legislator: return "person.2.fill"
        case .employer: return "briefcase.fill"
        case .serviceProvider: return "building.2.fill"
        case .school: return "graduationcap.fill"
        case .accommodation: return "wheelchair"
        case .complaint: return "exclamationmark.triangle.fill"
        }
    }
}

struct Placeholder: Identifiable, Codable {
    let id: UUID
    let key: String
    let label: String
    let required: Bool
    var value: String
    
    init(id: UUID = UUID(), key: String, label: String, required: Bool = true, value: String = "") {
        self.id = id
        self.key = key
        self.label = label
        self.required = required
        self.value = value
    }
}

// MARK: - Sample Templates

extension LetterTemplate {
    static let sampleTemplates: [LetterTemplate] = [
        LetterTemplate(
            title: "Accommodation Request - Workplace",
            description: "Request reasonable accommodations from your employer",
            category: .employer,
            templateText: """
            [Your Name]
            [Your Address]
            [City, State ZIP]
            [Date]
            
            [Employer Name]
            [Employer Address]
            [City, State ZIP]
            
            Dear [Employer Name/Human Resources],
            
            I am writing to request a reasonable accommodation under the Americans with Disabilities Act (ADA) for my position as [Your Position] at [Company Name].
            
            I have a disability that requires the following accommodation(s): [Describe Accommodation]
            
            This accommodation will enable me to perform the essential functions of my job effectively. I am happy to discuss alternative accommodations or provide additional medical documentation if needed.
            
            I would appreciate the opportunity to meet and discuss this request at your earliest convenience. Please let me know a convenient time for us to discuss this matter.
            
            Thank you for your consideration.
            
            Sincerely,
            [Your Name]
            """,
            placeholders: [
                Placeholder(key: "Your Name", label: "Your Name", required: true),
                Placeholder(key: "Your Address", label: "Your Address", required: true),
                Placeholder(key: "City, State ZIP", label: "City, State, ZIP Code", required: true),
                Placeholder(key: "Date", label: "Date", required: true),
                Placeholder(key: "Employer Name", label: "Employer/Human Resources Name", required: true),
                Placeholder(key: "Employer Address", label: "Employer Address", required: false),
                Placeholder(key: "Your Position", label: "Your Position", required: true),
                Placeholder(key: "Company Name", label: "Company Name", required: true),
                Placeholder(key: "Describe Accommodation", label: "Describe Your Accommodation Request", required: true)
            ]
        ),
        LetterTemplate(
            title: "Contact Your Legislator",
            description: "Write to your elected representative about disability rights",
            category: .legislator,
            templateText: """
            [Your Name]
            [Your Address]
            [City, State ZIP]
            [Date]
            
            The Honorable [Legislator Name]
            [Office Address]
            [City, State ZIP]
            
            Dear [Title] [Legislator Name],
            
            I am writing as a constituent and a person with a disability to express my concerns about [Issue/Topic].
            
            [Describe your concern and how it affects you and the disability community]
            
            I urge you to support legislation that protects and expands the rights of people with disabilities. Specifically, I would like you to consider [Specific Action or Bill].
            
            Thank you for your time and consideration. I look forward to your response.
            
            Sincerely,
            [Your Name]
            """,
            placeholders: [
                Placeholder(key: "Your Name", label: "Your Name", required: true),
                Placeholder(key: "Your Address", label: "Your Address", required: true),
                Placeholder(key: "City, State ZIP", label: "City, State, ZIP Code", required: true),
                Placeholder(key: "Date", label: "Date", required: true),
                Placeholder(key: "Legislator Name", label: "Legislator Name", required: true),
                Placeholder(key: "Office Address", label: "Legislator Office Address", required: false),
                Placeholder(key: "Title", label: "Title (Representative/Senator)", required: true),
                Placeholder(key: "Issue/Topic", label: "Issue or Topic", required: true),
                Placeholder(key: "Describe your concern", label: "Describe Your Concern", required: true),
                Placeholder(key: "Specific Action or Bill", label: "Specific Action or Bill Number", required: false)
            ]
        ),
        LetterTemplate(
            title: "Service Provider Accommodation",
            description: "Request accommodations from service providers",
            category: .serviceProvider,
            templateText: """
            [Your Name]
            [Your Address]
            [City, State ZIP]
            [Date]
            
            [Service Provider Name]
            [Service Provider Address]
            [City, State ZIP]
            
            Dear [Contact Person],
            
            I am writing to request accommodations for my disability when using your services at [Service/Location].
            
            I require the following accommodations: [Describe Accommodations]
            
            These accommodations are necessary for me to access your services on an equal basis with others. Under the Americans with Disabilities Act, you are required to provide reasonable accommodations unless doing so would cause undue hardship.
            
            I would appreciate confirmation that these accommodations can be provided. Please contact me at [Your Phone/Email] to discuss this matter further.
            
            Thank you for your attention to this matter.
            
            Sincerely,
            [Your Name]
            """,
            placeholders: [
                Placeholder(key: "Your Name", label: "Your Name", required: true),
                Placeholder(key: "Your Address", label: "Your Address", required: false),
                Placeholder(key: "City, State ZIP", label: "City, State, ZIP Code", required: false),
                Placeholder(key: "Date", label: "Date", required: true),
                Placeholder(key: "Service Provider Name", label: "Service Provider Name", required: true),
                Placeholder(key: "Service Provider Address", label: "Service Provider Address", required: false),
                Placeholder(key: "Contact Person", label: "Contact Person Name", required: false),
                Placeholder(key: "Service/Location", label: "Service or Location", required: true),
                Placeholder(key: "Describe Accommodations", label: "Describe Required Accommodations", required: true),
                Placeholder(key: "Your Phone/Email", label: "Your Phone or Email", required: true)
            ]
        )
    ]
}



