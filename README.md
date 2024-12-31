# PowerShell Script for Browser Detection and Password Manager Settings

## 🛠️ Features
This script helps you:
1. Detect installed browsers on your Windows system.
2. Disable password saving functionality in selected browsers.

---

## 🚀 Overview
### **Step 1**: Detect Installed Browsers
- Searches for installed applications in standard registry paths.
- Includes Microsoft Store apps using `Get-AppxPackage`.

### **Step 2**: Filter Popular Browsers
- Detects browsers like:
  - Google Chrome
  - Mozilla Firefox
  - Brave
  - Opera
  - Safari

### **Step 3**: Disable Password Saving
- Allows users to disable password saving in the following browsers:
  - **Chrome**: `HKLM:\SOFTWARE\Policies\Google\Chrome`
  - **Brave**: `HKLM:\SOFTWARE\Policies\Chromium`
  - **Firefox**: `HKLM:\SOFTWARE\Policies\Mozilla\Firefox`
  - **Edge**: `HKLM:\SOFTWARE\Policies\Microsoft\Edge`
  - **Opera**: `HKLM:\SOFTWARE\Policies\Opera Software`

---

## 📜 Script Usage

### 1. **Run the Script**
- Detects installed browsers and excludes irrelevant components like Edge WebView2.

### 2. **Select Browsers**
- Interactive prompt lets you select browsers where you want to disable password saving.

### 3. **Apply Changes**
- Modifies the Windows Registry to disable password manager settings in the selected browsers.

---

## 🔒 Security Notes
- Requires **administrative privileges** to modify the Windows Registry.
- It is recommended to **back up your Registry** before making changes.

---

## 📂 Script

- Attached in the file disablebrowserpassword.cmd
                                                                                                                   
