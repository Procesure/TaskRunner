Below is an example of a README file in Markdown format that explains the purpose and features of your project:

---

# Windows Task Session Executor

This project is intended to help facilitate the execution of Windows Task Scheduler tasks in specific local sessions. It enables you to run both interactive and non-interactive tasks in designated sessions, allowing for more granular control over how and where your tasks are executed. In particular, it allows:

- **Running Interactive Tasks in the Background:**  
  Initiate RDP sessions with a GUI even when no user is actively logged in, enabling automated interactive tasks.
  
- **Launching RDP Sessions Programmatically:**  
  Easily start an RDP session (with configurable resolution and other settings) via command-line or scripts, using tools like PsExec to ensure the process runs in the correct session.
  
- **Running Non-Interactive Tasks:**  
  Execute tasks normally or target specific sessions, based on your requirements, without needing an active RDP connection.

## Features

- **Session-Specific Execution:**  
  Run tasks in a specific session (or the most recent active session) determined dynamically, which is especially useful when tasks must interact with the GUI.

- **Parameter-Driven Workflow:**  
  Configure and pass command-line parameters to dictate how tasks are executed (e.g., interactive vs. non-interactive mode, custom RDP settings, host alias, etc.).

- **Integration with PsExec:**  
  Leverage PsExec to run processes under different system accounts or in interactive sessions without having to hardcode credentials.

- **Flexible Task Scheduling:**  
  Designed to be integrated with Windows Task Scheduler, ensuring that tasks run correctly regardless of whether a user is logged in.

## Use Cases

- **Automated Maintenance:**  
  Run interactive GUI applications in the background for automated maintenance or administrative tasks.
  
- **Remote Desktop Automation:**  
  Initiate RDP sessions programmatically and attach interactive applications to those sessions, even when running in a headless or scheduled context.
  
- **Modular Task Execution:**  
  Dynamically select and execute different scripts or functions based on parameters, making it easier to manage complex task flows.

## Requirements

- **Windows Server or Desktop Environment** with Task Scheduler.
- **PsExec** from the Sysinternals Suite (ensure its directory is in your PATH or use the full path).
- **PowerShell 5.1** (or later) for script execution.
- **(Optional) Python** if you are running Python scripts as part of your tasks.
- Proper user credentials configured in Windows Credential Manager if running interactive sessions.

## Installation

1. **Clone or Download the Repository.**
2. **Ensure all required tools are installed:**
   - [PsExec](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec)
   - PowerShell
3. **Configure Environment Variables:**  
   Optionally add the PsExec folder to your PATH for ease of use.
4. **Set Up Task Scheduler:**  
   Create tasks that point to the provided scripts. Use the wrapper script to combine multiple actions if necessary.

## Usage

### Running an Interactive Task
To run an interactive task, use the provided wrapper script with parameters such as:
```powershell
.\Wrapper.ps1 -ExecutableCommand "C:\Path\To\YourExecutable.exe" -Interactive $true -RDPSessionHost "127.0.0.2" -RDPSessionSettings "w=1366,h=768"
```

### Running a Non-Interactive Task
For non-interactive tasks, simply call:
```powershell
.\Wrapper.ps1 -ExecutableCommand "C:\Path\To\YourExecutable.exe" -Interactive $false
```

## Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to check [issues page](#) if you want to contribute.

## License

This project is licensed under the MIT License.

---

This README provides a high-level overview of what the project does, how it works, its use cases, and how to set it up. You can adjust and expand this README to match the specifics of your project and its implementation details.