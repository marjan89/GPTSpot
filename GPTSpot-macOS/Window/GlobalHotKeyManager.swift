//
//  GlobalHotKeyManager.swift
//  GPTSpot
//
//  Created by Sinisa Marjanovic on 3/25/24.
//

import Cocoa
import Carbon
import GPTSpot_Common

class GlobalHotKeyManager {

    var hotKeyRef: EventHotKeyRef?
    var appDelegate: GPTAppDelegate?

    init(appDelegate: GPTAppDelegate) {
        self.appDelegate = appDelegate
        if !UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.windowed) {
            registerGlobalHotKey()
        }
    }

    deinit {
        if !UserDefaults.standard.bool(forKey: GeneralSettingsDefaultsKeys.windowed) {
            unregisterGlobalHotKey()
        }
    }

    private func registerGlobalHotKey() {
        guard let signature = FourCharCode("6723") else {
            print("Failed to unwrap signature")
            return
        }
        let gMyHotKeyID = EventHotKeyID(signature: signature, id: 1)
        let hotKeyKeycode = UInt32(kVK_Space)
        let hotKeyModifiers = UInt32(optionKey | shiftKey)

        let status = RegisterEventHotKey(
            hotKeyKeycode,
            hotKeyModifiers,
            gMyHotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        if status != noErr {
            print("Failed to register hotkey")
        } else {
            print("Hotkey registered successfully")
        }

        // Setup event handler
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { (_, _, userData) -> OSStatus in
            let mySelf = Unmanaged<GlobalHotKeyManager>.fromOpaque(userData!).takeUnretainedValue()
            mySelf.handleHotKeyEvent()
            return noErr
        }, 1, &eventType, Unmanaged.passUnretained(self).toOpaque(), nil)
    }

    private func unregisterGlobalHotKey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
    }

    private func handleHotKeyEvent() {
        DispatchQueue.main.async {
            self.appDelegate?.toggleWindowVisibility()
        }
    }
}
