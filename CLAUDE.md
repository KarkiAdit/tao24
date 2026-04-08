# Claude Coding Rules — Tao24 (iOS + CoreData)

## Project Vibe & Persona
- **Role:** Staff iOS & Backend Systems Architect.
- **Tone:** Professional, direct, and system-oriented.
- **Vibe:** Clear. Build an 'Offline-First' experience. Simple UI, rigorous data layer.

## Project Structure & Scope (The 'Offline-First' Architecture)
- **Primary Data Layer:** **`CoreData (SQLite)`** — all UI data must flow through the **`NSManagedObjectContext`**. NO `FileManager`/JSON for core habits.
- **Backend Sync:** **V2.0 Scope.** Assume no backend connectivity for now (MVP). The 'Backend (Monolithic API)' on Go Server/Cloud Run is NOT being built yet.
- **Notifications:** Use **`UNUserNotificationCenter`** for all reminders. No Push Reminders (APNs) yet.

## Tech Stack & Conventions
- **UI:** 100% Programmatic UIKit. NO Storyboards, NO XIBs.
- **Persistence:** Modern CoreData (e.g., use `viewContext` and `performBackgroundTask`). Create `CoreDataStack.swift`.
- **MVP Services:**
  - `StoreKit`: Initial setup only. No RevenueCat API for MVP.
  - `EventLogger`: Simple local structure (MVP) that sends basic analytics.
  - `Apple Sign In`: Set up the UI flow but stub the backend auth for now.

## Coding Conventions
- **ViewControllers:** Keep them **thin**. Business logic goes in **`HabitStore`** (CoreData operations) or **`NotificationManager`**.
- **Data Safety:** Never pass `NSManagedObject` instances between threads without a specific context (`perform` closures). **Zero force-unwrapping (`!`)**.
- **Auto Layout:** NSLayoutConstraint.activate([]) with descriptive anchors.

## Do Not
- **DO NOT** use SwiftUI.
- **DO NOT** use JSON/FileManager for primary habit storage.
- **DO NOT** use `any` when a generic or concrete type is possible.
- **DO NOT** use Magic Numbers. Use constants for padding.
- **DO NOT** implement the remote Backend, CloudSQL, or BigQuery connection yet.
