---
paths:
  - "lib/**/data/**"
  - "lib/core/database/**"
  - "lib/core/network/**"
  - "lib/core/security/**"
  - "lib/**/auth/**"
  - "test/**/data/**"
  - "android/**"
  - "ios/**"
  - "pubspec.yaml"
---

# Security and Privacy Standards

MyOS handles personal and financial data. Apply privacy by design, data minimization, secure defaults, least privilege and defense in depth, proportionate to real risk rather than to checklists. References: OWASP MASVS, MASTG, Mobile Top 10 (ASVS for the future backend). The always-on minimum lives in `CLAUDE.md`; financial integrity lives in `finance.md`.

## Sensitive data

Sensitive data includes:

- Transactions, income and expenses.
- Personal identifiers, credentials and tokens.
- Private notes and schedules.
- Preferences that reveal private information.

Collect and store only what approved features need, and never expose it unnecessarily.

## Local storage

- SQLite is not encrypted by default; never claim encryption without verifying it.
- Separate sensitive from non-sensitive data and evaluate encryption needs.
- When encryption is needed, use a reviewed, supported implementation, never custom cryptography.
- Avoid insecure temporary storage.
- Define backup, recovery and failure behavior.

## Credentials and secrets

- Never put credentials, tokens, API secrets, private keys, database passwords or signing credentials in any of these:
  - Source code or plain config.
  - `SharedPreferences`.
  - Logs or Git.
- Persist credentials only in platform secure storage (iOS Keychain, Android Keystore-backed solutions). Secure credential storage is not the same as database encryption.
- Everything shipped in the app is extractable, so the app must never contain server-side secrets.

## Authentication and authorization (when introduced; requires approved architecture)

- Use established standards (OAuth 2.0 / OpenID Connect, Authorization Code + PKCE).
- Validate responses, handle token expiry and support secure logout.
- Never build custom authentication or cryptographic protocols.
- Authorization is enforced server-side with ownership checks and least privilege. Never trust client-provided user IDs or hidden UI as access control.

## Network (when introduced)

- HTTPS only; never disable certificate verification.
- Use reasonable timeouts and safe failure handling.
- Never put tokens in URLs or log request bodies.
- Certificate pinning only after a threat assessment with a rotation plan.

## Input validation

- Validate type, range, length and state for all untrusted input: amounts, text, dates, IDs, imported files and API responses.
- Client-side validation improves UX but never replaces backend validation.

## Logging and errors

- Never log passwords, tokens, private keys, auth headers, full financial records or personal notes.
- Use structured logging where useful.
- User-facing errors never reveal internals or sensitive resources.
- Never silently ignore security failures, and preserve recoverable user data.

## Permissions and privacy

- Request device permissions only when needed: near the action, with an explanation, and with graceful handling of denial.
- No background access or permissions requested for future features.
- No analytics, tracking or third-party data transfer without approval; evaluate privacy before integrating any external service.
- Users can understand and control their data.

## Export, deletion, backup, offline

- **Export**: understandable formats, warnings about sensitive contents, no insecure temp locations, verified integrity, never another user's data.
- **Deletion**: explicit, confirmed and predictable. No accidental cascades. Never claim permanent erasure unless every copy is addressed (including replicas and backups once sync exists).
- **Backup**: important data has a documented recovery strategy, and recovery from interrupted operations is handled.
- **Offline**: offline data is not automatically protected. Protect local data, avoid insecure credential caching, handle interrupted writes.

## Secure development and testing

- Use synthetic data only. Review dependency changes for advisories and license (checklist in `architecture.md`).
- No insecure debug shortcuts, and never disable security checks to make tests pass.
- Test invalid input, unauthorized operations, data exposure, persistence failures, integrity and unsafe error handling (plus authentication and authorization once a backend exists). Never run destructive security tests against production.

## Security-sensitive changes

These are LARGE tasks:

1. Identify the assets and threats.
2. Review the attack surface, storage, network, authorization and failure modes.
3. Document residual risks.
4. Obtain approval.

A change is complete only when threats were considered, inputs validated, sensitive data handled, access controls in place, tests passing, no known critical vulnerability remains and limitations are documented.
