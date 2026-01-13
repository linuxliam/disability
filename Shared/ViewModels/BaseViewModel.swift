//
//  BaseViewModel.swift
//  Disability Advocacy
//
//  Base view model protocol for common functionality
//

import Foundation

@MainActor
protocol BaseViewModelProtocol: AnyObject {
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
    var showError: Bool { get set }
}

extension BaseViewModelProtocol {
    func handleError(_ error: Error) {
        if let appError = error as? AppError {
            errorMessage = appError.errorDescription
        } else {
            errorMessage = error.localizedDescription
        }
        showError = true
    }
    
    func clearError() {
        errorMessage = nil
        showError = false
    }
}

