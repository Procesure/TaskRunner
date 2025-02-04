# Windows Interactive Task Runner

A simple wrapper project that allows you to run Windows tasks **interactively** using Task Scheduler—even when **no user** is logged into the machine. This solves a common Windows challenge: launching interactive tasks in the background, without storing credentials externally or relying on an active user session.

---

## Motivation

Running interactive tasks on Windows via Task Scheduler can be cumbersome, especially if **no user is logged on**. This project tackles that problem by providing a lightweight way to **simulate an interactive session** under the hood—leveraging native Windows tools—so you can confidently schedule scripts or applications that require desktop interaction.

---

## Features

- **Windows-Native Tools Only**  
  No need for extra frameworks or third-party service managers. Everything is done using standard Windows utilities like PsExec.
  
- **No External Credential Storage**  
  You supply credentials in Task Scheduler itself (username, password, and “host” alias, typically `127.0.0.2`).

- **Interactive or Non-Interactive Execution**  
  - **Interactive**: Spin up a service-like session that allows UI-based or interactive processes (e.g., Python scripts that open GUIs, Notepad, etc.).  
  - **Non-Interactive**: Run tasks silently in the background without any visible desktop interaction.

- **Multiple Session Hosts**  
  Easily configure different “host aliases” to run various tasks with different user contexts.

- **Runs Even When No User Is Logged On**  
  You can schedule tasks that depend on interactive sessions without waiting for a specific user to be physically logged in.

- **PsExec Dependency**  
  Leverages **PsExec** under the hood to create and manage interactive sessions.  

---

## Requirements

1. **PsExec** (from [Sysinternals](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec)) must be installed or available in your `PATH`.
2. **Windows Credentials** for the user who will run the task:
   - Username
   - Password
   - “Host” (usually `127.0.0.2` or the local machine name)
3. **Task Scheduler** to set up the scheduled job.  
4. **Windows OS** (tested on modern versions like Windows Server 2016/2019/2022, Windows 10/11, etc.).

---

## Usage

1. **Add to PATH (Optional)**  
   Place `RunTask.exe` in a folder that’s part of your system `PATH` or reference it by its absolute path.

2. **Set Up Your Scheduled Task**  
   - Create a new task in Task Scheduler.
   - Under **“Actions”**, call `RunTask.exe` with the desired parameters.
   - Configure the task to **Run whether user is logged on or not** (to allow interactive or background mode).

3. **Command Parameters**  
   - **`-Interactive`**: Enables an interactive session for GUI-based or desktop-dependent processes.  
   - **`-SessionHost "127.0.0.2"`**: Host alias (commonly `127.0.0.2`) to initiate the session.  
   - **`-ExecutableCMD "somecommand.exe"`**: The actual executable or script to run (include path if needed).  
   - **`-CMDWorkingDir "C:\Your\WorkingDirectory"`** *(Optional)*: Set a working directory before running the command.

---

## Example

Suppose you have a Python virtual environment and script located at  
`C:\Users\Administrator\Desktop\rdp-test\main.py`. You want to run it interactively so it can display windows or access desktop components. The command might look like this:

```powershell
RunTask.exe `
  -Interactive `
  -SessionHost "127.0.0.2" `
  -CMDWorkingDir "C:\Users\Administrator\Desktop\rdp-test" `
  -ExecutableCMD "venv\Scripts\python.exe main.py"
```

When scheduled in Task Scheduler, this will **start an interactive session** in the background and **run your Python script**, even if nobody is logged in.

---

## How It Works

1. **Starts RDP Session** (if `-Interactive` is used)  
   Leverages PsExec and other native tools to create an interactive-like session under the specified user context.
2. **Executes the Provided Command**  
   Launches your script or executable within that session.
3. **Optionally Disconnects** the Session  
   If configured, the session terminates after the process completes, freeing resources.

---

## License and Contributing

- If you find improvements or fixes, feel free to open a pull request or contribute your own scripts.  

---

## Closing Notes

**Windows Interactive Task Runner** removes the complexity of launching interactive processes on Windows servers. It’s particularly handy for automation, UI testing, or any script requiring a desktop. With minimal setup and no external credential storage, you can **securely** run tasks in a user context—even when the user isn’t physically logged on.

Happy automating!

--- 

> **Disclaimer**: Always be cautious with credentials and interactive sessions on production environments. Ensure your tasks and user permissions align with your organization’s security policies.