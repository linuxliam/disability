//
//  RightsInfo.swift
//  Disability Advocacy iOS
//
//  Rights information model for knowledge base
//

import Foundation

struct RightsInfo: Identifiable, Codable {
    let id: UUID
    let title: String
    let category: RightsCategory
    let law: String
    let summary: String
    let keyPoints: [String]
    let detailedDescription: String
    let relatedResources: [String]
    
    init(
        id: UUID = UUID(),
        title: String,
        category: RightsCategory,
        law: String,
        summary: String,
        keyPoints: [String],
        detailedDescription: String,
        relatedResources: [String] = []
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.law = law
        self.summary = summary
        self.keyPoints = keyPoints
        self.detailedDescription = detailedDescription
        self.relatedResources = relatedResources
    }
}

enum RightsCategory: String, Codable, CaseIterable {
    case employment = "Employment"
    case education = "Education"
    case housing = "Housing"
    case transportation = "Transportation"
    case healthcare = "Healthcare"
    case publicAccommodations = "Public Accommodations"
    case voting = "Voting"
    case technology = "Technology & Digital"
    
    var icon: String {
        switch self {
        case .employment: return "briefcase.fill"
        case .education: return "graduationcap.fill"
        case .housing: return "house.fill"
        case .transportation: return "bus.fill"
        case .healthcare: return "cross.case.fill"
        case .publicAccommodations: return "building.2.fill"
        case .voting: return "checkmark.circle.fill"
        case .technology: return "laptopcomputer"
        }
    }
}

// MARK: - Sample Rights Information

extension RightsInfo {
    static let sampleRights: [RightsInfo] = [
        RightsInfo(
            title: "Reasonable Accommodations in the Workplace",
            category: .employment,
            law: "Americans with Disabilities Act (ADA) Title I",
            summary: "The ADA requires employers to provide reasonable accommodations to qualified employees with disabilities, unless doing so would cause undue hardship.",
            keyPoints: [
                "Employers must provide accommodations if they don't cause 'undue hardship'",
                "Accommodations can include modified work schedules, equipment, or job restructuring",
                "You must be qualified for the job and have a disability as defined by the ADA",
                "Request accommodations in writing and provide medical documentation if requested",
                "Employers cannot retaliate for requesting accommodations"
            ],
            detailedDescription: """
            Under Title I of the Americans with Disabilities Act (ADA), employers with 15 or more employees must provide reasonable accommodations to qualified employees with disabilities. A reasonable accommodation is any change to the work environment or way things are done that enables a person with a disability to perform the essential functions of their job.
            
            Types of reasonable accommodations include:
            - Modifying work schedules or policies
            - Providing assistive technology or equipment
            - Restructuring job duties
            - Making facilities accessible
            - Providing qualified readers or interpreters
            
            To request an accommodation:
            1. Inform your employer of your disability (you don't need to disclose the specific disability)
            2. Request a specific accommodation
            3. Provide medical documentation if requested
            4. Engage in an interactive process with your employer
            
            Your employer cannot:
            - Retaliate against you for requesting accommodations
            - Refuse accommodations without engaging in the interactive process
            - Require you to pay for accommodations
            """,
            relatedResources: [
                "Job Accommodation Network (JAN)",
                "Equal Employment Opportunity Commission (EEOC)",
                "ADA National Network"
            ]
        ),
        RightsInfo(
            title: "Accessibility in Public Schools",
            category: .education,
            law: "Individuals with Disabilities Education Act (IDEA) & Section 504",
            summary: "Students with disabilities have the right to a free appropriate public education (FAPE) and reasonable accommodations in educational settings.",
            keyPoints: [
                "All students with disabilities are entitled to a free appropriate public education (FAPE)",
                "Schools must provide accommodations and modifications under Section 504",
                "Students may be eligible for an Individualized Education Program (IEP) under IDEA",
                "Schools must provide accessible facilities, materials, and instruction",
                "Parents have the right to participate in educational planning"
            ],
            detailedDescription: """
            Students with disabilities have rights under both the Individuals with Disabilities Education Act (IDEA) and Section 504 of the Rehabilitation Act.
            
            Section 504 ensures that students with disabilities have equal access to educational opportunities. This includes:
            - Reasonable accommodations in the classroom
            - Accessible facilities and materials
            - Appropriate modifications to curriculum when needed
            - Equal participation in extracurricular activities
            
            IDEA provides additional services for students who need specialized instruction. This includes:
            - Development of an Individualized Education Program (IEP)
            - Specialized instruction and related services
            - Placement in the least restrictive environment
            - Regular review and adjustment of services
            
            If you believe your child's needs are not being met:
            1. Request an evaluation for services
            2. Participate in IEP/504 plan meetings
            3. Document concerns in writing
            4. Request mediation or due process if needed
            """,
            relatedResources: [
                "Office of Special Education Programs (OSEP)",
                "National Center for Learning Disabilities",
                "Parent Center Hub"
            ]
        ),
        RightsInfo(
            title: "Accessibility in Public Transportation",
            category: .transportation,
            law: "Americans with Disabilities Act (ADA) Title II & III",
            summary: "Public transportation systems must be accessible to people with disabilities, including buses, trains, and facilities.",
            keyPoints: [
                "Public transit must be accessible and provide paratransit services",
                "Bus and rail systems must have accessible vehicles and stations",
                "Service animals must be allowed on public transportation",
                "Transit operators must provide assistance when needed",
                "Complaints about accessibility violations can be filed with the FTA"
            ],
            detailedDescription: """
            Under the ADA, public transportation systems must ensure accessibility for people with disabilities. This includes fixed-route bus and rail systems, as well as complementary paratransit services.
            
            Requirements include:
            - Accessible vehicles with features like ramps, lifts, and securement areas
            - Accessible stations and stops
            - Announcements of stops and routes
            - Training for operators on accessibility
            - Complementary paratransit services for those who cannot use fixed-route service
            
            Paratransit services must:
            - Operate in the same areas and times as fixed-route service
            - Have comparable fares
            - Not require advance reservations of more than one day
            - Provide door-to-door service when needed
            
            If you experience accessibility issues:
            1. Report the issue to the transit agency immediately
            2. File a complaint with the transit agency
            3. Contact the Federal Transit Administration (FTA) if the issue is not resolved
            """,
            relatedResources: [
                "Federal Transit Administration (FTA)",
                "ADA National Network",
                "Easter Seals Project ACTION"
            ]
        ),
        RightsInfo(
            title: "Accessibility in Healthcare Settings",
            category: .healthcare,
            law: "Americans with Disabilities Act (ADA) Title III & Section 504",
            summary: "Healthcare providers must provide effective communication and accessible facilities to patients with disabilities.",
            keyPoints: [
                "Healthcare providers must provide effective communication aids and services",
                "Medical facilities must be physically accessible",
                "Providers cannot refuse service based on disability",
                "Auxiliary aids and services must be provided at no cost to the patient",
                "Service animals must be allowed in healthcare facilities"
            ],
            detailedDescription: """
            Healthcare providers are required under the ADA to ensure that patients with disabilities receive equal access to medical services. This includes both physical accessibility and effective communication.
            
            Providers must:
            - Ensure facilities are accessible (ramps, accessible exam rooms, etc.)
            - Provide auxiliary aids and services for effective communication (interpreters, captioning, etc.)
            - Allow service animals
            - Modify policies and procedures when necessary
            - Provide accessible medical equipment when available
            
            Effective communication may include:
            - Sign language interpreters
            - Real-time captioning
            - Written materials in accessible formats
            - Assistive listening devices
            - Qualified readers
            
            Providers cannot:
            - Charge patients for auxiliary aids and services
            - Refuse to treat patients with disabilities
            - Place unnecessary restrictions on service animals
            - Use family members as interpreters (except in emergencies)
            """,
            relatedResources: [
                "Department of Justice - Healthcare and the ADA",
                "National Association of the Deaf",
                "American Foundation for the Blind"
            ]
        ),
        RightsInfo(
            title: "Website and Digital Accessibility",
            category: .technology,
            law: "Americans with Disabilities Act (ADA) & Section 508",
            summary: "Digital content and services must be accessible to people with disabilities, including websites, apps, and digital documents.",
            keyPoints: [
                "Websites and digital services must be accessible to people with disabilities",
                "Content should meet WCAG 2.1 Level AA standards",
                "Federal agencies must comply with Section 508 requirements",
                "Digital accessibility includes screen reader compatibility, keyboard navigation, and alternative text",
                "Video content should include captions and audio descriptions"
            ],
            detailedDescription: """
            While the ADA doesn't explicitly mention websites, courts have consistently ruled that websites are covered under Title III as "places of public accommodation." Additionally, Section 508 requires federal agencies to make their electronic and information technology accessible.
            
            Accessibility standards (WCAG 2.1 Level AA) require:
            - Text alternatives for images and media
            - Keyboard-accessible navigation
            - Sufficient color contrast
            - Resizable text
            - Clear headings and structure
            - Form labels and error messages
            - Captions for video content
            - Screen reader compatibility
            
            Common accessibility barriers include:
            - Missing alt text for images
            - Inaccessible forms
            - Poor color contrast
            - Videos without captions
            - Inaccessible PDFs
            - Keyboard traps
            
            If you encounter accessibility barriers:
            1. Contact the website or service provider
            2. Document the barriers (screenshots, descriptions)
            3. File a complaint with the Department of Justice
            4. Consider filing a lawsuit if the barriers are not addressed
            """,
            relatedResources: [
                "Web Content Accessibility Guidelines (WCAG)",
                "Section 508",
                "WebAIM",
                "ADA.gov"
            ]
        )
    ]
}



