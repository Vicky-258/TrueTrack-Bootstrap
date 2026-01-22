# Security Policy — TrueTrack Bootstrap

This document describes the security model, guarantees, and reporting process
for the **TrueTrack Bootstrap** repository.

This repository exists solely to provide a **minimal, auditable entry point**
for installing the TrueTrack application.

---

## Scope

This security policy applies **only** to:

- `install.sh` (Linux / macOS bootstrap installer)
- `install.ps1` (Windows bootstrap installer)
- The static landing page (`public/index.html`)
- Documentation within this repository

It does **not** cover the full TrueTrack application.
The main application has its own repository and security considerations.

---

## Security Design Principles

The TrueTrack Bootstrap repository follows these principles:

- **Minimal attack surface**
- **Explicit behavior**
- **No hidden side effects**
- **Easy to audit**
- **Fail fast, fail loud**

The bootstrap installer is intentionally small and boring.

---

## What the Bootstrap Installer Does

The bootstrap installer performs **only** the following actions:

1. Detects the operating system
2. Verifies that `git` is installed
3. Clones the main TrueTrack repository into a user-local directory
4. Hands control to the real installer inside the main repository

After this handoff, the bootstrap script exits.

---

## What the Bootstrap Installer Does NOT Do

The bootstrap installer explicitly does **not**:

- Install system packages
- Modify system PATH
- Create desktop shortcuts
- Write configuration files
- Start background services
- Auto-start on boot or login
- Send telemetry or network data
- Require administrator privileges

All system-modifying behavior is handled by the **real installer**
inside the main TrueTrack repository.

---

## Transparency & Auditing

- All bootstrap scripts are plain text
- No obfuscation or minification is used
- Scripts are designed to be readable in under one minute
- Users are encouraged to inspect scripts before running them

If the bootstrap installer appears to do more than described here,
that is considered a security issue.

---

## Trust Boundary

This repository is a **trust boundary**.

It is intentionally separated from the main application repository to ensure:

- users can audit the installer easily
- changes to the application do not silently affect the bootstrap
- the entry point remains stable and predictable

Any increase in scope is treated as a potential security risk.

---

## Response Policy

- Valid security reports will be acknowledged promptly
- Critical issues will be fixed with priority
- Fixes will be documented transparently
- Credit will be given for responsible disclosure (if desired)

---

## User Responsibility Notice

As with any `curl | bash` or `irm | iex` workflow:

- Users should inspect scripts before running them
- Users are responsible for understanding what they execute

This repository is designed to make that inspection easy.

---

## Final Note

If you are uncomfortable running the bootstrap installer:

- Clone the main TrueTrack repository manually
- Review the installer scripts
- Run them directly

TrueTrack is designed to support informed, cautious users.
