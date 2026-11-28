//
//  flintApp.swift
//  flint
//
//  Created by Dylan Karunanayake on 26/11/2026.
//

import SwiftUI
import AppKit

@main
struct flintApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

final class LauncherPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    override func cancelOperation(_ sender: Any?) {
        orderOut(nil)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: LauncherPanel!

    private let glassSize: CGFloat = 287.5
    private let margin: CGFloat = 20 // needed to remove unwanted shadow formatting

    func applicationDidFinishLaunching(_ notification: Notification) {
        let panelSide = glassSize + margin * 2
        let size = NSSize(width: panelSide, height: panelSide)

        panel = LauncherPanel(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.hidesOnDeactivate = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        let container = NSView(frame: NSRect(origin: .zero, size: size))
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.clear.cgColor

        let hosting = NSHostingView(rootView: LauncherView()) // Render launcher

        // Glass
        let glass = NSGlassEffectView()
        glass.cornerRadius = LauncherView.outerRadius
        glass.contentView = hosting
        glass.frame = container.bounds.insetBy(dx: margin, dy: margin)
        glass.autoresizingMask = [.width, .height]
        glass.style = .regular
        glass.tintColor = nil

        container.addSubview(glass)
        panel.contentView = container

        positionPanel()
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func positionPanel() {
        guard let screen = NSScreen.main else { return }
        let frame = screen.visibleFrame
        let size = panel.frame.size

        // Calculate points to place the launchpad
        let x = frame.midX - size.width / 2
        let y = frame.midY - size.height / 2 + frame.height * 0.2 // 20% vertical offset upwards

        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}

// The outer container on which the actual usable launcher content sits on
struct LauncherView: View {
    static let outerRadius: CGFloat = 70
    static let inset: CGFloat = 18

    var body: some View {
        ContentLayer()
            .padding(Self.inset)
            .containerShape(.rect(cornerRadius: Self.outerRadius))
    }
}
