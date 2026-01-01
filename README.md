# Task Manager – Flutter App (BLoC + Offline Support)

A Flutter mobile application that manages a simple task (todo) list using the JSONPlaceholder API.  
The project demonstrates Flutter development skills, BLoC state management, REST API integration, and an offline-first architecture.

---

## 📱 Features

- View list of tasks (todos)
- Add new tasks
- Mark tasks as completed
- Delete tasks (with confirmation)
- Search tasks
- Pull-to-refresh
- Offline support with local persistence
- Optimistic UI updates
- Mock user authentication (login/logout)
- Clean and modern UI

---
## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.x or later)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or physical device

### Steps to Run the App

1. **Clone the repository**
   ```bash
   git clone https://github.com/rohankasar25/task_manager_bloc.git
   cd task_manager_bloc
2. **Run the following command in the project root directory:**
   ```bash
   flutter pub get
3. **Run the Application**
   Start the Flutter app using:
   ```bash
   flutter run
4. **Login (Mock Authentication)**
   Use the following credentials to log in to the application:
   ```
   Email: admin@test.com
   Password: Admin@123
  **Note: Authentication is mocked for demonstration purposes. No real backend authentication is used.**

  ## 🧱 Assumptions & Design Decisions

- **JSONPlaceholder is a mock API** and does not persist data.  
  Hence, local storage is treated as the source of truth for the application.

- **Offline-first approach** was chosen to ensure the app works seamlessly without an internet connection.

- **BLoC pattern** was selected for state management to maintain a clear separation between UI and business logic and to support scalability.

- **Optimistic UI updates** are implemented so that user actions (add, complete, delete) are reflected immediately without waiting for API responses.

- **Local caching using Hive** is used to persist tasks across app restarts and enable offline access.

- **Mock authentication** with hardcoded credentials is used to demonstrate login flow without integrating a real authentication backend.

- **UI-level validation** is implemented to prevent invalid input and improve user experience.

- **Confirmation dialogs** are added for destructive actions (delete task, logout) to prevent accidental data loss.

- **Presentation-layer formatting** (e.g., text capitalization) is handled in the UI to avoid mutating stored data.

- **Error handling** is implemented gracefully with fallback UI states instead of crashing the app.

## 🔁 BLoC Pattern Implementation

The application uses the **BLoC (Business Logic Component)** pattern to separate business logic from the UI layer, making the app easier to maintain, test, and scale.

### Core Components

- **Events**  
  Represent user actions or system triggers such as loading tasks, adding a task, marking a task as completed, deleting a task, or searching tasks.

- **States**  
  Represent the UI state of the application, such as loading, loaded with data, or error states.

- **Bloc**  
  Acts as an intermediary between the UI and data layer.  
  It listens to incoming events, performs the required business logic, and emits new states that the UI reacts to.

### Data Flow
UI → Event → Bloc → State → UI

- The UI dispatches events based on user interactions.
- The Bloc processes these events and updates the application state.
- The UI rebuilds automatically when a new state is emitted.

This approach ensures predictable state management, improves code organization.

### ⚠️ Challenges Faced & How They Were Overcome

- **Mock API data persistence**  
  While developing the app, it was observed that tasks added using the JSONPlaceholder API were not saved after restarting the application. This happened because JSONPlaceholder is a mock API and does not persist data.  
  To overcome this, local storage was implemented using Hive, and the local database was treated as the source of truth.

- **Offline usability**  
  Ensuring the application remained functional without an internet connection was a challenge.  
  This was addressed by adopting an offline-first approach where tasks are loaded from local storage on app startup and updated locally on every user action.

- **Optimistic UI updates**  
  Providing instant feedback to the user without waiting for API responses required careful state handling.  
  This was solved by implementing optimistic updates, allowing the UI to update immediately while API calls run in the background.

- **Preventing accidental actions**  
  Users could accidentally delete tasks or log out without confirmation.  
  Confirmation dialogs were added to protect against unintended destructive actions and improve user experience.

- **Development environment and Git setup issues**  
  Multiple GitHub accounts caused authentication and permission issues during development.  
  This was resolved by configuring SSH-based authentication, ensuring a stable and conflict-free Git workflow.

## 📦 Offline Support Strategy

The application follows an **offline-first approach** to ensure usability even when the device has no internet connection.

- All tasks are stored locally using **Hive**, which allows data to persist across app restarts.
- On app startup, tasks are loaded from local storage instead of relying solely on the network.
- User actions such as adding, completing, or deleting tasks update the local database immediately.
- This ensures that the application remains fully functional in offline mode.

### Optimistic Updates
- The UI is updated immediately in response to user actions without waiting for API responses.
- This improves perceived performance and provides a smooth user experience.

### API Synchronization
- The JSONPlaceholder API is used as a simulated backend.
- Since the API does not persist data, local storage is treated as the source of truth.
- API calls are made only to demonstrate RESTful interactions, not for actual data persistence.

This strategy guarantees data availability, responsiveness, and a consistent user experience regardless of network connectivity.

## 🎥 Video Demonstration

A short demo video showing the working application:

👉 [Click here to watch the demo video](https://github.com/user-attachments/assets/32b25af9-97f2-4c51-8fce-8c45de752a6d)

