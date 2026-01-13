//
//  WindowManager.swift
//  Disability Advocacy
//
//  Window state restoration and management (macOS only)
//

import Foundation
#if os(macOS)
import AppKit
import SwiftUI

@MainActor
class WindowManager {
    static let shared = WindowManager()
    
    private let windowStateKey = "windowState"
    
    private init() {}
    
    func saveWindowState(for window: NSWindow) async {
        let state = WindowState(
            frame: window.frame,
            isZoomed: window.isZoomed,
            isMiniaturized: window.isMiniaturized
        )
        
        do {
            let encoded = try JSONEncoder().encode(state)
            UserDefaults.standard.set(encoded, forKey: windowStateKey)
        } catch {
        }
    }
    
    func restoreWindowState(for window: NSWindow) async {
        guard let data = UserDefaults.standard.data(forKey: windowStateKey) else {
            return
        }
        
        do {
            let state = try JSONDecoder().decode(WindowState.self, from: data)
            window.setFrame(state.frame, display: true)
            
            if state.isZoomed {
                window.zoom(nil)
            }
        } catch {
        }
    }
    
    func resetWindowState() async {
        UserDefaults.standard.removeObject(forKey: windowStateKey)
    }
}

struct WindowState: Codable {
    let frame: CGRect
    let isZoomed: Bool
    let isMiniaturized: Bool
    
    enum CodingKeys: String, CodingKey {
        case originX, originY, width, height, isZoomed, isMiniaturized
    }
    
    init(frame: CGRect, isZoomed: Bool, isMiniaturized: Bool) {
        self.frame = frame
        self.isZoomed = isZoomed
        self.isMiniaturized = isMiniaturized
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let originX = try container.decode(CGFloat.self, forKey: .originX)
        let originY = try container.decode(CGFloat.self, forKey: .originY)
        let width = try container.decode(CGFloat.self, forKey: .width)
        let height = try container.decode(CGFloat.self, forKey: .height)
        self.frame = CGRect(x: originX, y: originY, width: width, height: height)
        self.isZoomed = try container.decode(Bool.self, forKey: .isZoomed)
        self.isMiniaturized = try container.decode(Bool.self, forKey: .isMiniaturized)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(frame.origin.x, forKey: .originX)
        try container.encode(frame.origin.y, forKey: .originY)
        try container.encode(frame.width, forKey: .width)
        try container.encode(frame.height, forKey: .height)
        try container.encode(isZoomed, forKey: .isZoomed)
        try container.encode(isMiniaturized, forKey: .isMiniaturized)
    }
}

// MARK: - Window Restoration View Modifier

struct WindowRestoration: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(WindowRestorationRepresentable())
    }
}

extension View {
    func restoreWindowState() -> some View {
        modifier(WindowRestoration())
    }
}

struct WindowRestorationRepresentable: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        
        Task {
            if let window = view.window {
                await WindowManager.shared.restoreWindowState(for: window)
                
                // Observe window state changes
                NotificationCenter.default.addObserver(
                    forName: NSWindow.didResizeNotification,
                    object: window,
                    queue: .main
                ) { _ in
                    Task {
                        await WindowManager.shared.saveWindowState(for: window)
                    }
                }
                
                NotificationCenter.default.addObserver(
                    forName: NSWindow.didMoveNotification,
                    object: window,
                    queue: .main
                ) { _ in
                    Task {
                        await WindowManager.shared.saveWindowState(for: window)
                    }
                }
            }
        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
#else
// iOS doesn't need window management
@MainActor
class WindowManager {
    static let shared = WindowManager()
    private init() {}
}
#endif


