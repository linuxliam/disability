//
//  ColorsTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for Color extensions
//

import XCTest
import SwiftUI
@testable import DisabilityAdvocacy_iOS

final class ColorsTests: XCTestCase {
    
    // MARK: - Background Colors Tests
    
    func testAppBackground_IsNotNil() {
        // When
        let color = Color.appBackground
        
        // Then
        XCTAssertNotNil(color, "App background color should not be nil")
    }
    
    func testGroupedBackground_IsNotNil() {
        // When
        let color = Color.groupedBackground
        
        // Then
        XCTAssertNotNil(color, "Grouped background color should not be nil")
    }
    
    func testCardBackground_IsNotNil() {
        // When
        let color = Color.cardBackground
        
        // Then
        XCTAssertNotNil(color, "Card background color should not be nil")
    }
    
    func testSecondaryCardBackground_IsNotNil() {
        // When
        let color = Color.secondaryCardBackground
        
        // Then
        XCTAssertNotNil(color, "Secondary card background color should not be nil")
    }
    
    // MARK: - Text Colors Tests
    
    func testPrimaryText_IsNotNil() {
        // When
        let color = Color.primaryText
        
        // Then
        XCTAssertNotNil(color, "Primary text color should not be nil")
    }
    
    func testSecondaryText_IsNotNil() {
        // When
        let color = Color.secondaryText
        
        // Then
        XCTAssertNotNil(color, "Secondary text color should not be nil")
    }
    
    func testTertiaryText_IsNotNil() {
        // When
        let color = Color.tertiaryText
        
        // Then
        XCTAssertNotNil(color, "Tertiary text color should not be nil")
    }
    
    // MARK: - Surface Colors Tests
    
    func testSurfaceSecondary_IsNotNil() {
        // When
        let color = Color.surfaceSecondary
        
        // Then
        XCTAssertNotNil(color, "Surface secondary color should not be nil")
    }
    
    func testSurfaceElevated_IsNotNil() {
        // When
        let color = Color.surfaceElevated
        
        // Then
        XCTAssertNotNil(color, "Surface elevated color should not be nil")
    }
    
    // MARK: - Semantic Colors Tests
    
    func testSemanticSuccess_IsNotNil() {
        // When
        let color = Color.semanticSuccess
        
        // Then
        XCTAssertNotNil(color, "Semantic success color should not be nil")
    }
    
    func testSemanticError_IsNotNil() {
        // When
        let color = Color.semanticError
        
        // Then
        XCTAssertNotNil(color, "Semantic error color should not be nil")
    }
    
    func testSemanticWarning_IsNotNil() {
        // When
        let color = Color.semanticWarning
        
        // Then
        XCTAssertNotNil(color, "Semantic warning color should not be nil")
    }
    
    func testSemanticInfo_IsNotNil() {
        // When
        let color = Color.semanticInfo
        
        // Then
        XCTAssertNotNil(color, "Semantic info color should not be nil")
    }
    
    // MARK: - Brand Colors Tests
    
    func testTriadPrimary_IsNotNil() {
        // When
        let color = Color.triadPrimary
        
        // Then
        XCTAssertNotNil(color, "Triad primary color should not be nil")
    }
    
    func testTriadSecondary_IsNotNil() {
        // When
        let color = Color.triadSecondary
        
        // Then
        XCTAssertNotNil(color, "Triad secondary color should not be nil")
    }
    
    func testTriadTertiary_IsNotNil() {
        // When
        let color = Color.triadTertiary
        
        // Then
        XCTAssertNotNil(color, "Triad tertiary color should not be nil")
    }
}
