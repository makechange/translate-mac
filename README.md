# TranslateOne

[中文](#中文) | [English](#english)

## 中文

TranslateOne 是一款原生 macOS 菜单栏翻译工具，使用 Apple Translation Framework 和系统语音合成能力，支持选中文本翻译、剪贴板翻译、系统 Services 与双语朗读。

### 功能

- **选中文本翻译**：在任意 App 中选中文本，按 `Option + T` 弹出翻译面板。
- **剪贴板翻译**：通过菜单栏命令或 `Option + Shift + C` 翻译剪贴板内容。
- **系统 Services**：可通过右键菜单中的“服务 → Translate with TranslateOne”翻译文本，无需辅助功能权限。
- **多语言翻译**：支持自动检测源语言，并可选择目标语言。
- **双语朗读**：分别朗读原文和译文，语音引擎在后台预热和运行。
- **原生菜单栏体验**：不显示 Dock 图标，使用可拖动、可缩放的悬浮 HUD。
- **隐私优先**：使用 macOS 系统 Translation Framework，不接入第三方翻译 API。

> 首次使用某些语言时，macOS 可能需要下载对应的系统语言资源。

### 系统要求

- macOS 15.0（Sequoia）或更高版本
- Apple Silicon 或 Intel Mac
- 从源码构建需要 Xcode 16 或更高版本

### 快捷键与权限

| 功能 | 默认操作 | 是否需要辅助功能权限 |
| --- | --- | --- |
| 翻译当前选中文本 | `Option + T` | 是 |
| 翻译剪贴板 | `Option + Shift + C` 或菜单栏命令 | 否 |
| 系统 Services 翻译 | 右键 → 服务 → Translate with TranslateOne | 否 |

选中文本翻译会模拟一次 `Command + C` 来读取当前选择，并在完成后恢复原剪贴板内容，因此需要在以下位置授权：

```text
系统设置 → 隐私与安全性 → 辅助功能 → TranslateOne
```

开发阶段请在 Xcode 的 `Signing & Capabilities` 中选择稳定的 Personal Team。使用 Ad-Hoc 签名反复编译时，macOS 可能把新构建识别为不同 App，导致重复请求辅助功能权限。

### 从源码运行

```bash
git clone https://github.com/makechange/translate-one.git
cd translate-one
open TranslateOne/TranslateOne.xcodeproj
```

在 Xcode 中：

1. 选择 `TARGETS → TranslateOne → Signing & Capabilities`。
2. 勾选 `Automatically manage signing`。
3. 选择自己的 Personal Team。
4. 运行目标选择 `My Mac`。
5. 按 `Command + R` 构建并运行。

### 命令行构建

Debug：

```bash
xcodebuild \
  -project TranslateOne/TranslateOne.xcodeproj \
  -scheme TranslateOne \
  -configuration Debug \
  -destination 'platform=macOS' \
  build
```

Universal Release（Apple Silicon + Intel）：

```bash
xcodebuild \
  -project TranslateOne/TranslateOne.xcodeproj \
  -scheme TranslateOne \
  -configuration Release \
  -destination 'generic/platform=macOS' \
  build
```

### 项目结构

```text
.
├── TranslateOne/
│   ├── TranslateOne.xcodeproj/
│   └── TranslateOne/
│       ├── App/
│       │   └── AppDelegate.swift
│       ├── Features/
│       │   └── TranslationHUD/
│       │       ├── TranslationHUDController.swift
│       │       └── TranslationHUDView.swift
│       ├── Models/
│       │   └── Language.swift
│       ├── Services/
│       │   ├── HotkeyManager.swift
│       │   └── ServiceProvider.swift
│       ├── SupportingFiles/
│       │   └── Info.plist
│       ├── Assets.xcassets/
│       └── TranslateOneApp.swift
├── AppIcon.icns
└── README.md
```

Xcode 工程是当前唯一的源码与构建入口。根目录 `AppIcon.icns` 是原始图标设计资源，实际构建使用 `Assets.xcassets/AppIcon.appiconset`。

### Bundle 与构建配置

```text
Bundle Identifier: com.makechange.translateone
Version: 1.0.0
Minimum macOS: 15.0
App Sandbox: Disabled
Hardened Runtime: Enabled
```

App Sandbox 关闭是因为全局选词翻译需要 Accessibility API 和模拟复制操作。公开分发仍会使用 Hardened Runtime、Developer ID 签名和 Apple Notarization。

### 公开发布

要向其他用户提供可正常安装的 DMG，推荐流程为：

```text
Xcode Archive
→ Developer ID Application 签名
→ Apple Notarization
→ Staple 公证票据
→ 生成 DMG
→ GitHub Release
```

Developer ID 与 Notarization 需要有效的 Apple Developer Program 会员。未签名或仅使用 Ad-Hoc 签名的构建可以用于本机测试，但会被其他用户的 Gatekeeper 警告或拦截。

### 当前发布前待办

- 配置 Developer ID Application 证书
- 生成并验证 Xcode Archive
- 完成 Apple Notarization 与 Staple
- 制作 DMG 并在全新用户环境测试
- 创建 GitHub Release 和版本更新说明

---

## English

TranslateOne is a native macOS menu-bar translation utility powered by Apple's Translation Framework and system speech synthesis.

### Highlights

- Translate selected text globally with `Option + T`
- Translate clipboard content with `Option + Shift + C`
- Use macOS Services without Accessibility permission
- Automatic source-language detection and configurable target language
- Speech synthesis for both source and translated text
- Native draggable and resizable HUD
- Universal Release builds for Apple Silicon and Intel Macs

### Requirements

- macOS 15.0 or later
- Xcode 16 or later when building from source

### Build from source

```bash
git clone https://github.com/makechange/translate-one.git
cd translate-one
open TranslateOne/TranslateOne.xcodeproj
```

Select your Personal Team in `Signing & Capabilities`, choose `My Mac`, and press `Command + R`.

The global selected-text shortcut simulates `Command + C` and therefore requires permission in:

```text
System Settings → Privacy & Security → Accessibility → TranslateOne
```

Direct public distribution requires Developer ID signing and Apple Notarization. The project is configured with Hardened Runtime enabled and App Sandbox disabled because selected-text capture uses Accessibility APIs.
