# TrueTrack Bootstrap

This repository contains the **bootstrap installer and landing page** for **TrueTrack**.

It exists solely to provide a **small, auditable, high-trust entry point** for installing the TrueTrack application.

---

## What this repository IS

- A **static landing page** explaining what TrueTrack does
- Two **minimal bootstrap installers**:
  - `install.sh` (Linux / macOS)
  - `install.ps1` (Windows)
- A safe handoff to the **real installer** inside the main TrueTrack repository

---

## What this repository is NOT

- ❌ The TrueTrack application itself  
- ❌ A dependency installer  
- ❌ A runtime manager  
- ❌ A background service  
- ❌ A GUI or native desktop app  

All application logic lives in the **main TrueTrack repository**.

---

## How installation works (high level)

1. User runs a single command from the landing page
2. The bootstrap script:
   - checks the OS
   - verifies `git` is installed
   - clones the main TrueTrack repository
3. Control is handed to the **real installer** in the app repo
4. This bootstrap script exits

The bootstrap does **not**:
- install system packages
- write configuration files
- modify PATH
- create desktop shortcuts
- run the application

---

## Install commands

### Linux / macOS

```bash
curl -fsSL https://truetrack.app/install.sh | bash
````

### Windows (PowerShell 7+)

```powershell
irm https://truetrack.app/install.ps1 | iex
```

You are encouraged to inspect the scripts before running them.

---

## Where is the actual application?

The real application lives here:

👉 **[https://github.com/your-org/truetrack](https://github.com/your-org/truetrack)**

That repository contains:

* the backend
* the frontend
* the real installer
* all runtime logic

---

## Security & Trust Model

This repository is intentionally:

* small
* boring
* easy to audit

Design principles:

* No telemetry
* No background services
* No auto-start on boot
* No privilege escalation
* No hidden behavior

If something looks surprising here, it’s probably a bug.

See [`SECURITY.md`](./SECURITY.md) for reporting security issues.

---

## Uninstalling

If installation was completed successfully:

* Stop the app (Ctrl+C)
* Delete the install directory:

  * Linux/macOS: `~/.truetrack`
  * Windows: `%LOCALAPPDATA%\TrueTrack`

No other system changes are required.

---

## Why a separate bootstrap repo?

Separating the bootstrap installer from the main application:

* reduces the trust surface
* makes auditing trivial
* avoids accidental system modifications
* keeps the entry point stable even as the app evolves

This is a deliberate design choice.

---

## License

This repository follows the same license as the main TrueTrack project.
