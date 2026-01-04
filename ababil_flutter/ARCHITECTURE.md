# Architecture Overview

This Flutter application follows the **MVVM (Model-View-ViewModel)** architecture pattern.

## Folder Structure

```
lib/
├── data/                    # Data layer
│   ├── services/           # Services that interact with external systems (FFI, APIs, etc.)
│   │   └── http_client_service.dart
│   └── repositories/       # Repositories that use services and expose clean APIs
│       └── http_repository.dart
│
├── domain/                  # Domain layer (business logic and models)
│   └── models/             # Domain models
│       ├── http_request.dart
│       └── http_response.dart
│
└── ui/                      # UI layer
    ├── screens/            # Screen widgets
    │   └── home_screen.dart
    └── viewmodels/         # ViewModels (business logic for UI)
        └── home_view_model.dart
```

## Architecture Layers

### 1. Domain Layer (`domain/`)
Contains the business logic and domain models. These are pure Dart classes with no dependencies on Flutter or external services.

- **Models**: Data structures representing domain entities (HttpRequest, HttpResponse)

### 2. Data Layer (`data/`)
Handles all data operations and external integrations.

- **Services**: Direct integration with external systems
  - `HttpClientService`: Handles FFI communication with Rust core
- **Repositories**: Abstract data sources and provide clean APIs
  - `HttpRepository`: Uses `HttpClientService` and exposes methods for making HTTP requests

### 3. UI Layer (`ui/`)
Contains all user interface components.

- **Screens**: Full-screen widgets (pages)
- **ViewModels**: Manage UI state and business logic
  - Extend `ChangeNotifier` for reactive updates
  - Use repositories to fetch data
  - Notify listeners when state changes

## Data Flow

```
UI (Screen) 
  ↓
ViewModel (HomeViewModel)
  ↓
Repository (HttpRepository)
  ↓
Service (HttpClientService)
  ↓
FFI → Rust Core
```

## Example: Making an HTTP Request

1. **User Action**: User clicks "Send" button in `HomeScreen`
2. **ViewModel**: `HomeViewModel.sendRequest()` is called
3. **Repository**: ViewModel calls `HttpRepository.sendRequest()`
4. **Service**: Repository calls `HttpClientService.makeRequest()`
5. **FFI**: Service communicates with Rust core via FFI
6. **Response**: Response flows back through the layers
7. **UI Update**: ViewModel notifies listeners, UI rebuilds

## Benefits of This Architecture

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Testability**: Easy to mock repositories and services for testing
3. **Maintainability**: Changes in one layer don't affect others
4. **Reusability**: Services and repositories can be reused across different ViewModels
5. **Scalability**: Easy to add new features following the same pattern

## Adding New Features

To add a new feature:

1. **Domain**: Create models in `domain/models/`
2. **Data**: 
   - Add service methods in `data/services/` if needed
   - Create repository in `data/repositories/`
3. **UI**: 
   - Create ViewModel in `ui/viewmodels/`
   - Create Screen in `ui/screens/`
   - Connect ViewModel to Screen

