# 🦖 KaijuISO: The Ultimate ISO Creator Tool

KaijuISO (โปรแกรมแปลงไฟล์/โฟลเดอร์เป็น ISO) is a high-performance, portable GUI utility designed to streamline the ISO creation process. It eliminates the need for complex `oscdimg` command-line strings by providing a simple drag-and-drop interface for folders and multiple files.

---

## 🚀 Key Features

* **Modern Folder Picker:** Supports address bar navigation and Path pasting (v1.9).
* **Drag & Drop Interface:** Easily add multiple files or folders to the build list.
* **Portable EXE:** Self-contained executable with embedded `oscdimg` and icon. No installation required.
* **Bulletproof Logging:** Comprehensive error tracking and crash recovery logs (v1.8).
* **Environment Standardized:** Fully optimized for PowerShell 7.4+ environments.

---

## 🗓️ Version History (Changelog)

### v1.9 - The "Modern UI" Update
* **Improved Dialogs:** Replaced the legacy tree-view folder browser with a Modern Folder Picker.
* **Direct Pathing:** Enabled the Address Bar for direct path pasting and manual typing. Standard Windows Explorer behavior for a better user experience.

### v1.8 - The "Bulletproof" Update
* **Global Crash Handlers:** Added "Black Box" logging to capture fatal system and thread exceptions.
* **Enhanced Reliability:** Integrated a Try-Catch wrapper around the main GUI loop to prevent silent application freezes.

### v1.7 - The "Best Practice" Update
* **Log Relocation:** Moved log storage to `%LocalAppData%\KaijuISO\Logs`.
    * *Benefit:* Allows the EXE to run from read-only locations (like Network Shares or ISOs) without permission issues.
* **Precision Timing:** Added timestamps to every log entry for accurate debugging.

### v1.6 - The "Brackets Fix" Update
* **Filename Sanitization:** Fixed a critical bug where files containing brackets `[ ]` caused build failures.
* **LiteralPath Implementation:** Applied across all file operations to prevent PowerShell wildcard misinterpretation.
* **UI Stabilization:** Locked the window size (FixedSingle) to maintain GUI integrity.

### v1.5 - The "Progress Logic" Update
* **Real-time Progress:** Implemented an accurate progress bar calculation logic based on file count.
* **GUI Feedback:** Added a "Done" status indicator and auto-reset logic for the "Clear" button.

### v1.0 - v1.4 - The "Core Architecture" Era
* **PowerShell 7 Migration:** Optimized for `pwsh` as the primary runtime.
* **Smart Build System:** Developed `build.ps1` to automate binary encoding (Base64) and EXE compilation.
* **Permission Fixes:** Resolved conflicts between Local Documents and OneDrive sync paths.

### 🛠️ Tech Stack
* **Language:** PowerShell 7.4+
* **UI:** Windows Forms via .NET
* **Compiler: PS2EXE** (v1.0.17+)
* **Core Engine:** Microsoft oscdimg.exe (Embedded)

---
## 👨‍💻 Author & Maintainer

* **Developed by:** Kitichote Amornrattanabongkot  
* **Role:** Senior System Engineer  
* **Company:** Chromatix Computing Solutions (CCS)

> 🌟 **Project Status:** Active / Community Supported  
> 🐛 **Found a bug?** Please open an issue in this repository.  
> 💬 **Connect:** [GitHub Profile](https://github.com/funkyboyz)

---
## ☕ Support the Developer

If you find **KaijuISO** useful for your daily work or it saved you some time, you can show your support by buying me a coffee! It helps keep the project alive and fuels future updates.

<div align="center">

<a href="https://www.buymeacoffee.com/poets4life" target="_blank">
  <img src="https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee" />
</a>

&nbsp;&nbsp;

<a href="https://ko-fi.com/poets4life" target="_blank">
  <img src="https://img.shields.io/badge/Ko--fi-F16063?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Ko-fi" />
</a>

</div>

> 💡 **Note:** This project is free and open-source. Donations are optional but highly appreciated! ❤️
