# Windows Task Runner

Easily run **interactive (GUI)** tasks via the Windows Task Scheduler—even when no one is logged on. This uses **only** native Windows RDP—no extra tools or external credential storage.

---

## Motivation

By default, Windows Task Scheduler does **not** allow GUI tasks when nobody is logged in. This project creates a **local** RDP session on `127.0.0.2` or any other loopback address, allowing graphical applications to run unattended. It also works for non-interactive jobs, providing a **single solution** for all scheduled tasks.

---

## Features

- **Run GUI Tasks**  
  Start GUI-based apps (e.g., desktop automation or UI tests) without a manually logged-on user.  
  - Technically, an “active” RDP session is created, but you don't need to **manually** log on—this is handled automatically by the script.

- **No External Software**  
  Only requires built-in Windows RDP—no additional tools like FreeRDP, port forwarding, or third-party vaults.

- **Session Persistence**  
  - You can connect locally (e.g., `127.0.0.2`) to **observe** the GUI.  
  - Disconnect without terminating the session or the task.

- **Automated Session Switching**  
  If a user session is currently active, it is disconnected to free up the GUI context. The new session then runs your interactive task.

- **No Plain-Text Credentials**  
  Credentials live in the standard Windows Credential Manager.

---

## Requirements

1. **Enable Concurrent RDP Sessions**  
   - **Best practice**: allow multiple (or at least two) RDP sessions in Local/Group Policy.  
   - If only a single session is allowed, once someone manually logs in via RDP, it might disconnect the session hosting your interactive task.

2. **Windows Credential for Loopback**  
   - Create a generic credential mapping a loopback address (e.g., `127.0.0.2`) to the user running the tasks.

3. **RDP Config File (Mandatory for Interactive Tasks)**  
   - Provide a `.rdp` file (pointing to your chosen loopback IP) to the script via `-RDPConfig`.  
   - You can also use this file to manually RDP in to see what’s running.

---

## How It Works

1. **Disconnect Existing Session**  
   The script logs off any currently active session of the same user.

2. **Establish Loopback RDP**  
   It then launches `mstsc.exe` pointing to the loopback address (e.g., `127.0.0.2`), using stored Windows credentials. The GUI process starts in this new session.

3. **Optional Monitoring**  
   Connect to the same `.rdp` file to watch the task. Disconnect at any time—your task keeps running.

4. **Non-Interactive**  
   For headless jobs, you can omit the `-RDPConfig` parameter and run them in the background.

---

## Usage Example (Task Scheduler)

1. **Create a Scheduled Task**  
   - **Action**: “Start a program”  
   - **Program/Script**:  
     ```
     C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
     ```
   - **Arguments**:  
     ```
     .\RunTask.ps1 -TaskName "BlocoDeNotasMain" -RDPConfig "C:\Users\YourUserName\Desktop\Default.rdp"
     ```
   - **Start in**:  
     ```
     C:\Users\YourUserName\Documents\dev\WindowsInteractiveTask\scripts
     ```
   - **Run whether user is logged on or not**: checked

2. **Optional**: Convert to `.exe`  
   - Install ps2exe and convert the script:  
     ```
     Install-Module -Name ps2exe -Force
     ps2exe .\scripts\RunTask.ps1 .\scripts\RunTask.exe
     ```
   - Reference that `.exe` in your Task Scheduler configuration if you prefer.

---

## License

Provided as-is, with no specific license. Use it freely within your environment—no warranties or guarantees.

---

## Contributing

All suggestions are welcome! Open an issue or pull request to enhance or fix interactive session management.

---

### Disclaimer

Review your organization’s security requirements before using. This script changes how RDP sessions are handled—make sure it aligns with your policies.