# Tawakkalna Verification Flow

## 1. Identity & Consent assumptions

- The user signs in through Nafath/Absher SSO, which returns a signed payload that includes the National ID (`nid`), session identifier, and consent scopes granted during login.
- Immediately after the SSO callback, the backend exchanges the session token for a short-lived Tawakkalna access token scoped to `medical_exam:read` and `documents:read`. This exchange also records the consent reference ID from the SSO provider so it can be surfaced in the UI.
- The consent event (timestamp, scopes, and SSO transaction ID) is persisted in our audit log so that the user can later review why their data was fetched automatically. Refreshes reuse the stored consent window (e.g., 30 days) and re-prompt the user once it expires.
- The mobile app never requests Tawakkalna directly; it only receives normalized data from our backend, along with a signed proof bundle that contains the source (`Tawakkalna`), retrieval timestamp, and reference code.

The remaining sections of this document describe the mocked adapter and client wiring that rely on these assumptions.

## 2. Backend aggregation service

- `Services/TawakkalnaVerificationService.swift` defines `LicenseVerificationProviding` plus `TawakkalnaMockVerificationService`, which mirrors the contract of the real adapter. It simulates latency, assigns deterministic reference codes, and normalizes the upstream payload into `LicenseVerificationSnapshot`.
- The real adapter would live behind the same protocol, handle OAuth client credentials + Tawakkalna signing, and return the same snapshot format so that the mobile app does not change when production credentials become available.
- Snapshots include a `fetchedAt` timestamp and per-item `lastSynced` value. The app treats data as fresh for 15 minutes. The backend should respect the same cache window (e.g., store the Tawakkalna payload in Redis keyed by National ID + scope hash).

## 3. Client data flow & UI hooks

- `AppViewModel` now owns `verificationSnapshot` and `verificationState`. When the user logs in, it automatically calls `fetchVerification(force: false)` using the injected provider and stores the result for 15 minutes.
- `ReviewView` renders `VerificationStatusCard` for each requirement (المتطلبات + الفحص الطبي). Each card shows the proof headline, source (“تمت مزامنتها آلياً من توكلنا”), last-sync timestamp, and reference code. If the adapter fails, the card shows a localized error with a retry button wired to `viewModel.refreshVerification()`.
- Because the view model exposes `refreshVerification()` and `ensureVerificationFreshness()`, other screens (e.g., Home) can surface the same proof data or trigger a manual sync if the user requests it.

## 4. Proof & audit trail exposure

- Every `VerificationProof` includes `sourceSystem`, `referenceCode`, and `lastSynced`. The UI displays them inline so the user can “prove” how the app filled the requirements automatically.
- For a production adapter, persist the signed Tawakkalna payload alongside our own `referenceCode` so tapping a “كيفية التحقق؟” link could open a modal with the raw payload hash, consent transaction ID, and backend log ID for support to trace.
- When the cache expires or the user taps “إعادة المحاولة”, a fresh snapshot is fetched and a new reference code is shown, making the verification trail easy to audit.

