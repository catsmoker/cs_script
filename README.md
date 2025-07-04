# 🖥️ Windows AetherKit

![Version](https://img.shields.io/badge/version-v4-green)
![Platform](https://img.shields.io/badge/platform-Windows-blue)
![License: MIT](https://img.shields.io/badge/license-MIT-blue)

![aetherkit_icon](https://github.com/user-attachments/assets/f3aa4aee-8065-4fc3-b3ae-d75b89677f69)

A powerful all-in-one Windows maintenance and automation script.  
Built for power users, sysadmins, and curious tinkerers – **smarter, safer, and fully native**.

---

> ⚠️ Some outputs may appear in your system language (e.g., English, Danish). This is expected behavior.

> 🛑 Only for **Windows 10 & 11**

---

## 🚀 Quick Start

### 🔹 PowerShell (Offline)

Run the `main.ps1` file from the [main](https://github.com/catsmoker/AetherKit/archive/refs/heads/main.zip) page and run with powershell.

### 🔹 PowerShell (Online)

Run this in **PowerShell (as Administrator)**:

powershell:
```
irm https://catsmoker.github.io/w | iex
```

### 🔹 Executable (Online)

Download the `.exe` installer from the [Releases](https://github.com/catsmoker/cs_script/releases) page and install it.

---

## 🛠️ Features

### 🧹 System Maintenance

* Clean temp files, Recycle Bin, event logs, and DNS cache
* Scan & fix with `chkdsk`, `sfc`, and `DISM`
* Run full malware scan with **MRT**

### 📦 Software Management

* Install/update 30+ apps using **winget**
* Activate **IDM**, **Windows**, and **Office**

### 🌐 Network Tools

* Configure DNS (Google, Cloudflare, or custom)
* Reset adapters, view IP config, flush DNS, etc.
* View routing tables and perform Winsock reset

### 🧠 Registry Tools

* Safe cleaner: history, recent docs, open/save dialogs
* Backup & restore full registry
* Optimize performance with smart tweaks

### ⚙️ System Utilities

* Full Windows Update via `PSWindowsUpdate`
* Generate detailed system report
* Launch Chris Titus Tech's optimization tool
* Create desktop shortcuts for easy access

---

## 📁 Output Files

Saved to `Desktop\SystemReports` by default:

* `System_Info_YYYY-MM-DD.txt`
* `Network_Info_YYYY-MM-DD.txt`
* `Driver_List_YYYY-MM-DD.txt`
* `Routing_Table_YYYY-MM-DD.txt`

---

## 📋 System Requirements

* Windows 10 or 11
* PowerShell 5.1+
* Admin privileges
* Internet connection (for updates/tools)

---

## ❓ FAQ

**Q: Script didn’t restart as Admin?**
A: Make sure UAC is enabled. Or right-click the script → **Run as Administrator**.

**Q: Winget install/upgrade fails?**
A: Ensure `winget` is up to date. Script validates most input and handles common errors.

---

## 🤝 Contributing

Contributions, bug reports, and suggestions are welcome!
Check out [`CONTRIBUTING.md`](CONTRIBUTING.md) before submitting a PR.

---

## 📜 License

Licensed under the [MIT License](LICENSE).
Free for personal and professional use.

---

## 🧑‍💻 Credits

Developed by [catsmoker](https://catsmoker.github.io)
Inspired by:

* Microsoft PowerShell Team
* Open-source community contributors

---
