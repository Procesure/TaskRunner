# Windows Task Session Executor

**Goal**  
Enable automated **interactive tasks** (i.e., tasks requiring a GUI) to run through **Task Scheduler**—even in scenarios where no user is actively logged on—by leveraging **PowerShell** and **PsExec**.

## Motivation

Traditionally, **Task Scheduler** tasks are non-interactive and cannot easily launch GUI applications when no user is logged in. This project overcomes that limitation by programmatically opening an **RDP session**, injecting commands into the chosen session, and then optionally disconnecting the session once tasks are complete. Whether you’re automating maintenance tasks that rely on a GUI, running an installer interactively, or performing visual tests, this project aims to provide a seamless way to handle “headless” GUI automation in Windows.

## Key Features

1. **Interactive Execution**  
   - Dynamically open and configure RDP sessions to host GUI-based applications.  
   - Execute your scripts or executables in an interactive environment as though a user were present.

2. **Non-Interactive Options**  
   - Falls back to session 0 (standard background tasks) if you only need a command to run without showing any interface.

3. **Configurable RDP Settings**  
   - Pass custom resolution or display parameters (e.g., `w=1920,h=1080`) to tailor the RDP session’s environment.

4. **Automated Cleanup**  
   - Optionally disconnect the RDP session after execution, preventing idle sessions from lingering.

5. **Seamless Integration with Task Scheduler**  
   - Each script can be triggered by scheduled tasks, so you can run interactive or non-interactive jobs on a schedule or upon system events.

## Usage Overview

1. **Provide the Executable or Script to Run**  
   - Use **RunTask.ps1** (or the compiled equivalent) and pass the `-ExecutableCommand` parameter.

2. **Optionally Supply RDP Details**  
   - If you require an **interactive session** (GUI), specify `-Interactive`, plus the host or IP (`-SessionHost`), and any custom resolution (`-InteractiveSessionSettings "w=1366,h=768"`).

3. **Task Scheduler Configuration**  
   - Create a scheduled task pointing to **RunTask.ps1**.  
   - For truly interactive tasks that show a GUI even without a logged user, you might set **“Run whether user is logged on or not.”** (Be aware of potential black-screen quirks in Windows session isolation—see “Limitations” below.)

## Example Command

```powershell
.\RunTask.ps1 `
  -ExecutableCommand "C:\MyTools\MyGUIApp.exe" `
  -SessionHost "127.0.0.2" `
  -Interactive `
  -InteractiveSessionSettings "w=1920,h=1080"
```

1. **Starts** an RDP session with a 1920×1080 display to `127.0.0.2`.  
2. **Runs** `MyGUIApp.exe` inside that session.  
3. **Disconnects** the session if configured to do so.

## Requirements

- **Windows** (Server or Desktop)  
- **PowerShell 5.1+**  
- **PsExec** (from the [Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/psexec) suite)  
- **Administrative Privileges** may be needed for PsExec to inject processes.  

## Limitations / Caveats

- **Session 0 Isolation**: Windows might show a black screen if you attempt to run MSTSC in a session with no real desktop. In many cases, a user must at least be auto-logged for the GUI to function normally.  
- **Security**: Storing credentials or running as SYSTEM in a scheduled task can pose security risks. Ensure your environment and policies allow it.  
- **Hardcoded Session IDs**: By default, some scripts may use a specific session ID (like `-i 3` in PsExec). Adjust if needed or adapt the logic to automatically find an active session.

## Contributing

1. **Fork** this repo.  
2. **Create a feature branch** for your changes (`feature/improvement`).  
3. **Open a Pull Request** describing your updates.

## License

Licensed under the **[MIT License](LICENSE)**. Feel free to use and modify the code for your own projects, subject to the license terms.

## Contact

If you encounter issues or want to propose enhancements, open an **Issue** in this repository. Feedback and pull requests are welcome.

---

**Enjoy scheduling GUI tasks without an active user logged on!**