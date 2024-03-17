//
//  EventTapManager.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 2/27/24.
//

import Foundation
import Carbon
import Cocoa

class EventTapManager {

    var eventTap: CFMachPort?

    init(lightning: GPTAppDelegate) {
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let event = Optional(event) else { return nil }
                let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                let flags = event.flags
                let desiredFlags: CGEventFlags = [.maskControl, .maskShift]
                let isPressed = flags.contains(desiredFlags) && keyCode == 49
                if isPressed {
                    DispatchQueue.main.async {
                        if let refcon = refcon {
                            let gptSpotApp = Unmanaged<GPTAppDelegate>.fromOpaque(refcon).takeUnretainedValue()
                            gptSpotApp.toggleWindowVisibility()
                        }
                    }
                    return nil
                }
                return Unmanaged.passUnretained(event)
            },
            userInfo: Unmanaged.passUnretained(lightning).toOpaque()
        )
        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
    }
}
