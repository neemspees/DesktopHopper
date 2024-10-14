//
//  DesktopHopperApp.swift
//  DesktopHopper
//
//  Created by Kim Bouchouaram on 30/09/2024.
//

import SwiftUI
import KeyboardShortcuts

@main
struct DesktopHopperApp: App {
    var body: some Scene {
        MenuBarExtra("Desktop Hopper", systemImage: "square.and.line.vertical.and.square") {
            Text("Desktop Hopper")
            Button("Hop Up") {
                Hopper.hop(direction: .Up)
            }
            Button("Hop Down") {
                Hopper.hop(direction: .Down)
            }
            Button("Hop Left") {
                Hopper.hop(direction: .Left)
            }
            Button("Hop Right") {
                Hopper.hop(direction: .Right)
            }
            Divider()
            SettingsLink()
            Button("Quit", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        }
        Settings {
            SettingsScreen()
        }
    }
    
    
    init() {
        KeyboardShortcuts.onKeyUp(for: .hopUp) { Hopper.hop(direction: .Up) }
        KeyboardShortcuts.onKeyUp(for: .hopDown) { Hopper.hop(direction: .Down) }
        KeyboardShortcuts.onKeyUp(for: .hopLeft) { Hopper.hop(direction: .Left) }
        KeyboardShortcuts.onKeyUp(for: .hopRight) { Hopper.hop(direction: .Right) }
    }
}

struct SettingsScreen: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Hop up:", name: .hopUp)
            KeyboardShortcuts.Recorder("Hop down:", name: .hopDown)
            KeyboardShortcuts.Recorder("Hop left:", name: .hopLeft)
            KeyboardShortcuts.Recorder("Hop right:", name: .hopRight)
        }.padding(.all, 20)
    }
}

extension KeyboardShortcuts.Name {
    static let hopUp = Self("hopUp")
    static let hopDown = Self("hopDown")
    static let hopLeft = Self("hopLeft")
    static let hopRight = Self("hopRight")
}

struct Hopper {
    enum HopDirection {
        case Up
        case Down
        case Left
        case Right
    }
    
    static func hop(direction: HopDirection) {
        if (NSScreen.screens.count < 2) {
            return
        }
        
        let mainScreen = NSScreen.screens
            .first{ screen in screen.frame.standardized.contains(NSEvent.mouseLocation) }
        
        if (mainScreen == nil) {
            return
        }
        
        let newScreen = NSScreen.screens
            .filter{ screen in screen.hash != mainScreen!.hash }
            .first{ screen in
                if (direction == HopDirection.Up) {
                    return screen.frame.origin.y > mainScreen!.frame.origin.y
                }
                
                if (direction == HopDirection.Down) {
                    return screen.frame.origin.y < mainScreen!.frame.origin.y
                }
                
                if (direction == HopDirection.Left) {
                    return screen.frame.origin.x < mainScreen!.frame.origin.x
                }
                
                return screen.frame.origin.x > mainScreen!.frame.origin.x
            }
        
        if (newScreen == nil) {
            return
        }
        
        debugPrint("Mouse position before move",NSEvent.mouseLocation)
        
        debugPrint(mainScreen!.localizedName, mainScreen!.visibleFrame.origin)
        debugPrint(newScreen!.localizedName, newScreen!.visibleFrame.origin)
        
        let targetPosition = CGPoint(x: newScreen!.frame.standardized.midX, y: newScreen!.frame.standardized.origin.y * -1 + newScreen!.frame.standardized.height * 0.5)
        
        
        debugPrint("Target position", newScreen!.localizedName, targetPosition)
        
        CGDisplayMoveCursorToPoint(0, targetPosition)
    }
}
