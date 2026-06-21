//
//  TranslateOneApp.swift
//  TranslateOne
//
//  Created by jack on 2026/6/21.
//

import SwiftUI

@main
struct TranslateOneApp: App {
    // 将现有的 AppDelegate 接入 SwiftUI App 生命周期
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate

    var body: some Scene {
        // TranslateOne 是菜单栏工具，不创建普通主窗口
        Settings {
            EmptyView()
        }
    }
}
