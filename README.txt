🦖 KaijuISO
The Ultimate ISO Creator Tool for IT Professionals Developed by: Kitichote Amornrattanabongkot

KaijuISO is a high-performance, portable GUI utility designed to streamline the ISO creation process. It eliminates the need for complex oscdimg command-line strings by providing a simple drag-and-drop interface for folders and multiple files.

Shutterstock
สำรวจ

🚀 Key Features
Modern Folder Picker: Supports address bar navigation and Path pasting (v1.9).

Drag & Drop Interface: Easily add multiple files or folders to the build list.

Portable EXE: Self-contained executable with embedded oscdimg and icon.

Bulletproof Logging: Comprehensive error tracking and crash recovery logs (v1.8).

Environment Standardized: Fully optimized for PowerShell 7.4+ environments.

📅 Version History (Changelog)
v1.9 - The "Modern UI" Update
Improved Dialogs: Replaced the legacy tree-view folder browser with a Modern Folder Picker.

Enabled the Address Bar for direct path pasting and manual typing.

Standard Windows Explorer behavior for a better user experience.

v1.8 - The "Bulletproof" Update
Global Crash Handlers: Added "Black Box" logging to capture fatal system and thread exceptions.

Enhanced Reliability: Integrated a Try-Catch wrapper around the main GUI loop to prevent silent application freezes.

v1.7 - The "Best Practice" Update
Log Relocation: Moved log storage to %LocalAppData%\KaijuISO\Logs.

Benefit: Allows the EXE to run from read-only locations (like Network Shares or ISOs) without permission issues.

Precision Timing: Added timestamps to every log entry for accurate debugging.

v1.6 - The "Brackets Fix" Update
Filename Sanitization: Fixed a critical bug where files containing brackets [ ] caused build failures.

Implemented -LiteralPath across all file operations to prevent PowerShell wildcard misinterpretation.

UI Stabilization: Locked the window size (FixedSingle) to maintain GUI integrity.

v1.5 - The "Progress Logic" Update
Real-time Progress: Implemented an accurate progress bar calculation logic based on file count.

GUI Feedback: Added a "Done" status indicator and auto-reset logic for the "Clear" button.

v1.0 - v1.4 - The "Core Architecture" Era
PowerShell 7 Migration: Optimized for pwsh as the primary runtime.

Smart Build System: Developed build.ps1 to automate binary encoding (Base64) and EXE compilation.

Permission Fixes: Resolved conflicts between Local Documents and OneDrive sync paths.

🛠️ Tech Stack
Language: PowerShell 7.4+

UI: Windows Forms via .NET

Compiler: PS2EXE (v1.0.17+)

Core Engine: Microsoft oscdimg.exe (Embedded)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

🦖 KaijuISO
The Ultimate ISO Creator Tool Developed by: Senior System Engineer (IFM/O - EP)

เครื่องมือสร้างไฟล์ ISO แบบพกพา (Portable) รองรับการลากวาง (Drag & Drop) ใช้งานง่าย ไม่ต้องจำ Command Line ของ oscdimg อีกต่อไป

🚀 Version History (Changelog)
v1.9 (Current Version) - The "Modern UI" Update
✨ New Feature: เปลี่ยนหน้าต่างเลือกโฟลเดอร์ (Folder Browser) จากแบบเก่า (Tree View) เป็น Modern Style (OpenFileDialog Hack)

มี Address Bar ด้านบน สามารถ Copy-Paste Path ยาวๆ ลงไปได้ทันที

ใช้งานสะดวกเหมือน Windows Explorer ปกติ

Optimization: ปรับปรุง Code ให้สะอาดขึ้น รองรับ PowerShell 7 เต็มรูปแบบ

v1.8 - The "Bulletproof" Update
🛡️ Reliability: เพิ่มระบบ Global Crash Handler (Black Box)

ดักจับ Error ระดับ System/Thread ที่ปกติจะทำให้โปรแกรมดับไปเฉยๆ

บันทึก Log ก่อนตาย (Last Breath Log) เพื่อให้รู้สาเหตุที่แท้จริง

Safety: เพิ่ม Try-Catch ครอบส่วน GUI Main Loop ป้องกันโปรแกรมค้าง

v1.7 - The "Best Practice" Update
📂 Logging: ย้ายที่เก็บ Log จากโฟลเดอร์โปรแกรม ไปไว้ที่ %LocalAppData%\KaijuISO\Logs

Benefit: สามารถวางไฟล์ EXE บน Network Share หรือ CD/DVD (Read-only) แล้วรันได้โดยไม่ติด Permission Error

Timestamp: เพิ่มเวลา (Timestamp) หน้า Log ทุกบรรทัดเพื่อการ Debug ที่แม่นยำ

v1.6 - The "Fix Brackets" Update
🐛 Bug Fix: แก้ปัญหาร้ายแรงกรณีชื่อไฟล์/โฟลเดอร์มีวงเล็บเหลี่ยม [ ] (เช่น [Mu soft])

เปลี่ยนวิธีการเรียก Path เป็น -LiteralPath เพื่อป้องกัน PowerShell ตีความว่าเป็น Wildcard

UI Fix: ล็อคขนาดหน้าต่างโปรแกรม (FixedSingle) ไม่ให้ยืดหดจน GUI เละ

Log Cleanup: กรอง Error ขยะที่เกิดจากการ Verify ของ oscdimg ออก ให้เหลือแต่ Error จริงๆ

v1.5 - The "Progress Bar" Update
📊 UX: เพิ่ม Logic คำนวณ Progress Bar ตามความเป็นจริง

สูตร: (จำนวนไฟล์ที่เสร็จ / ทั้งหมด) * 100

หลอดสีเขียวจะขยับทุกครั้งที่ทำเสร็จ 1 ไฟล์

Reset Logic: ปุ่ม Clear จะรีเซ็ต Progress Bar กลับเป็น 0% อัตโนมัติ

v1.0 - v1.4 - The "Architecture" Era
System Core: ปรับจูน build.ps1 ให้เป็นมาตรฐาน (Standardization)

Environment:

บังคับใช้ PowerShell 7 (pwsh) เป็น Runtime หลัก

แก้ปัญหา Path ภาษาไทย และ OneDrive (Documents vs OneDrive)

ย้าย Module PS2EXE ไปลงที่ Program Files (AllUsers) เพื่อความเสถียร

Core Function: รองรับการแปลงทั้ง "ไฟล์เดี่ยว" และ "โฟลเดอร์" เป็น ISO

🛠️ Tech Stack & Build Info
Language: PowerShell 7.4+

GUI Framework: Windows Forms (WinForms) via .NET

Core Engine: Microsoft oscdimg.exe (Embedded inside EXE)

Compiler: PS2EXE (v1.0.17+)