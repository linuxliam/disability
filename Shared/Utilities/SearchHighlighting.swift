//
//  SearchHighlighting.swift
//  Disability Advocacy
//
//  Utilities for highlighting search terms in text
//

import SwiftUI

/// Represents a highlighted text segment
struct HighlightedTextSegment {
    let text: String
    let isHighlighted: Bool
}

/// Utility for highlighting search terms in text
struct SearchHighlighting {
    /// Splits text into segments with highlighted portions
    static func highlight(_ text: String, query: String) -> [HighlightedTextSegment] {
        guard !query.isEmpty, !text.isEmpty else {
            return [HighlightedTextSegment(text: text, isHighlighted: false)]
        }
        
        let lowerText = text.lowercased()
        let lowerQuery = query.lowercased()
        var segments: [HighlightedTextSegment] = []
        var currentIndex = text.startIndex
        
        // Find all occurrences of the query (case-insensitive)
        var searchRange = lowerText.startIndex..<lowerText.endIndex
        while let range = lowerText.range(of: lowerQuery, range: searchRange) {
            // Add text before the match
            if currentIndex < range.lowerBound {
                let beforeText = String(text[currentIndex..<range.lowerBound])
                if !beforeText.isEmpty {
                    segments.append(HighlightedTextSegment(text: beforeText, isHighlighted: false))
                }
            }
            
            // Add the highlighted match
            let matchText = String(text[range.lowerBound..<range.upperBound])
            segments.append(HighlightedTextSegment(text: matchText, isHighlighted: true))
            
            currentIndex = range.upperBound
            searchRange = range.upperBound..<lowerText.endIndex
        }
        
        // Add remaining text
        if currentIndex < text.endIndex {
            let remainingText = String(text[currentIndex..<text.endIndex])
            if !remainingText.isEmpty {
                segments.append(HighlightedTextSegment(text: remainingText, isHighlighted: false))
            }
        }
        
        return segments.isEmpty ? [HighlightedTextSegment(text: text, isHighlighted: false)] : segments
    }
    
    /// Highlights multiple query terms (for phrase searches)
    static func highlightMultiple(_ text: String, queries: [String]) -> [HighlightedTextSegment] {
        guard !queries.isEmpty else {
            return [HighlightedTextSegment(text: text, isHighlighted: false)]
        }
        
        // For multiple queries, highlight all matches
        var segments: [HighlightedTextSegment] = [HighlightedTextSegment(text: text, isHighlighted: false)]
        
        for query in queries where !query.isEmpty {
            var newSegments: [HighlightedTextSegment] = []
            let lowerQuery = query.lowercased()
            
            for segment in segments {
                if segment.isHighlighted {
                    // Already highlighted, keep as is
                    newSegments.append(segment)
                } else {
                    // Check if this segment contains the query
                    let highlighted = highlight(segment.text, query: query)
                    newSegments.append(contentsOf: highlighted)
                }
            }
            
            segments = newSegments
        }
        
        return segments
    }
}

