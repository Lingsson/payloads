# Contributing Guidelines

Feel free to add or improve payloads.

<br>

## ⚠️ Rules

By contributing, you agree that:

- You understand payloads may have destructive or irreversible effects.
- You clearly document any risky behavior.

<br>

## 📦 Payload Format

Every payload submitted to this repository must follow the format below.  
This ensures consistency, readability, and safe understanding of what each payload does.

Each payload must include a README.md with:

- **Name** – A clear and descriptive name for the payload
- **Description** – Short explanation of what the payload is intended to do
- **Target OS** – The operating system(s) the payload is designed for (Windows / Linux / macOS)
- **Behavior** – Detailed explanation of what the payload actually does when executed
- **Dependencies** – Any required tools, libraries, or external services (e.g. PowerShell, Python modules, webhooks)


### 📌 Example

```text
Name: Calculator Spam Launcher  
Description: Repeatedly opens the system calculator application  
Target OS: Windows  
Behavior: Continuously launches calc.exe in a loop until stopped by the user  
Dependencies: None
```

<br>

## 📥 How to Contribute a Payload


### 1. Pull Request

1. Fork this repository
2. Create a new branch:
   - `feature/your-payload-name`
3. Add your payload file to the correct folder
4. Follow the required payload format
5. Commit your changes with a clear message
6. Open a Pull Request
