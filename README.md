<div align="center">
  <h1>🚀 Ababil</h1>
  
  <p>
    <a href="https://github.com/AbabilX/ababil/stargazers"><img src="https://img.shields.io/github/stars/AbabilX/ababil?style=social" alt="GitHub stars"></a>
    <a href="https://github.com/AbabilX/ababil/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
    <a href="https://github.com/AbabilX/ababil/releases"><img src="https://img.shields.io/badge/version-1.0.0-brightgreen.svg" alt="Version"></a>
    <a href="https://github.com/AbabilX/ababil/issues"><img src="https://img.shields.io/github/issues/AbabilX/ababil" alt="GitHub issues"></a>
  </p>

  <p>
    <strong>A modern, lightning-fast alternative to Postman</strong><br>
    Built with Rust core + Flutter UI using FFI for seamless communication
  </p>
</div>

---

## 🌟 Overview

**Ababil** is an open-source API development and testing platform designed to be faster, lighter, and more efficient than traditional tools like Postman. Leveraging Rust's performance capabilities, Ababil provides near-instantaneous request execution while maintaining a beautiful, intuitive user interface built with Flutter.

### Why Ababil?

- **⚡ Incredibly Fast**: Rust-powered core ensures the fastest HTTP request processing
- **🪶 Extremely Lightweight**: Minimal resource usage compared to Electron-heavy alternatives
- **🎨 Modern UI**: Beautiful, responsive interface built with Flutter and Material Design 3
- **🔓 Open Source**: Fully transparent, community-driven development
- **🔐 Privacy First**: Your data stays on your machine
- **🛠️ Developer-Friendly**: Designed by developers, for developers
- **📱 Cross-Platform**: Runs natively on macOS, Linux, Windows, iOS, and Android

---

## ✨ Features

### Core Capabilities

- **HTTP Method Support**: GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS
- **Request Builder**: Intuitive interface for creating API requests
- **Collection Management**: Organize and save your API endpoints
- **Environment Variables**: Seamlessly manage multiple environments
- **Postman Compatibility**: Import and export Postman collections and environments
- **Response Viewer**: Beautiful syntax highlighting for JSON, XML, HTML, and more
- **Request History**: Track all your API calls (coming soon)
- **Authentication**: Bearer, Basic, OAuth, and API Key authentication support
- **Request Body Types**: Raw, URL-encoded, Form-data, and GraphQL support
- **Custom Headers**: Full control over request headers
- **Query Parameters**: Easy management of URL parameters

### Performance Features

- **Rust-Powered Engine**: Native performance for request execution
- **Async Processing**: Efficient async request handling with Tokio
- **Minimal Latency**: Optimized request pipeline
- **Low Memory Usage**: Efficient resource management

### Developer Experience

- **MVVM Architecture**: Clean, maintainable code structure
- **Import/Export**: Share collections with your team
- **Dark Mode**: Easy on the eyes during long coding sessions
- **Code Editor**: Syntax-highlighted code editor for request/response bodies
- **Variable Substitution**: Use `{{variable_name}}` syntax for dynamic values

---

## 🚀 Getting Started

### Prerequisites

- **Rust** (latest stable version)
- **Flutter SDK** (3.10.4 or higher)
- **Cargo** (comes with Rust)

### Installation

#### Option 1: Build from Source

1. **Clone the repository**

   ```bash
   git clone https://github.com/AbabilX/ababil.git
   cd ababil
   ```

2. **Build the Rust Core**

   ```bash
   cd ababil_core
   cargo build --release
   cd ..
   ```

   This will generate the native library:

   - **macOS**: `target/release/libababil_core.dylib`
   - **Linux**: `target/release/libababil_core.so`
   - **Windows**: `target/release/ababil_core.dll`

3. **Copy the Native Library**

   For macOS:

   ```bash
   mkdir -p ababil_flutter/macos/Runner/Frameworks
   cp ababil_core/target/release/libababil_core.dylib ababil_flutter/macos/Runner/Frameworks/
   ```

   Or use the build script:

   ```bash
   ./build.sh
   ```

4. **Set Up Flutter Dependencies**

   ```bash
   cd ababil_flutter
   flutter pub get
   ```

5. **Run the Application**

   ```bash
   flutter run -d macos  # or -d ios, -d android, -d linux, -d windows
   ```

#### Option 2: Using the Build Script

```bash
# Build everything and copy libraries
./build.sh

# Then run Flutter
cd ababil_flutter
flutter run
```

---

## 🏗️ Architecture

Ababil uses a hybrid architecture where a Rust native library handles HTTP request execution via FFI:

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter UI Layer                      │
│  ┌─────────────────────────────────────────────────┐   │
│  │  HomeScreen (UI)                                 │   │
│  │    └── HomeViewModel (Business Logic)            │   │
│  │          └── HttpRepository                       │   │
│  │                └── HttpClientService              │   │
│  │                      └── FFI Binding              │   │
│  └─────────────────────────────────────────────────┘   │
└───────────────────────────┬─────────────────────────────┘
                            │ FFI (dart:ffi)
┌───────────────────────────▼─────────────────────────────┐
│              libababil_core.dylib/.so/.dll (Rust)        │
│    - make_http_request(json) → executes HTTP via reqwest│
│    - free_string(ptr) → memory cleanup                   │
└─────────────────────────────────────────────────────────┘
```

### Data Flow

1. **UI → ViewModel**: User action triggers ViewModel method
2. **ViewModel → Repository**: ViewModel calls Repository method
3. **Repository → Service**: Repository uses Service for data operations
4. **Service → FFI**: Service communicates with Rust core via FFI
5. **Rust Execution**: Rust `reqwest` executes HTTP request using Tokio async runtime
6. **Response**: JSON response flows back through the layers
7. **UI Update**: ViewModel notifies listeners, UI rebuilds

### Architecture Layers

#### Domain Layer (`domain/`)

Contains business logic and domain models. Pure Dart classes with no dependencies on Flutter or external services.

- **Models**: Data structures representing domain entities (HttpRequest, HttpResponse, Collection, Environment)

#### Data Layer (`data/`)

Handles all data operations and external integrations.

- **Services**: Direct integration with external systems
  - `HttpClientService`: Handles FFI communication with Rust core
  - `PostmanService`: Handles Postman collection/environment parsing
- **Repositories**: Abstract data sources and provide clean APIs
  - `HttpRepository`: Uses `HttpClientService` and exposes methods for making HTTP requests

#### UI Layer (`ui/`)

Contains all user interface components.

- **Screens**: Full-screen widgets (pages)
- **ViewModels**: Manage UI state and business logic
  - Extend `ChangeNotifier` for reactive updates
  - Use repositories to fetch data
  - Notify listeners when state changes
- **Widgets**: Reusable UI components

---

## 🛠️ Technology Stack

### Core Technologies

- **Rust**: High-performance HTTP client and request processing
- **Flutter**: Cross-platform UI framework
- **Dart**: Type-safe development language
- **FFI (Foreign Function Interface)**: Seamless communication between Dart and Rust

### Rust Core Dependencies

- **reqwest**: HTTP client library
- **tokio**: Async runtime
- **serde**: JSON serialization/deserialization
- **base64**: Encoding/decoding for authentication

### Flutter UI Dependencies

- **ffi**: FFI bindings for native library communication
- **path_provider**: File system access
- **file_picker**: File selection dialogs
- **syntax_highlight**: Code syntax highlighting
- **flutter_code_editor**: Code editing capabilities

---

## 📖 Usage

### Making Your First Request

1. **Launch Ababil**
2. **Select HTTP Method** (GET, POST, etc.)
3. **Enter your API endpoint URL**
4. **Add headers, parameters, or body as needed**
5. **Click Send** and view the response instantly

### Creating Collections

1. **Click "New Collection"** in the sidebar
2. **Add name and description**
3. **Save your requests** for future use
4. **Share with your team** via export

### Using Environment Variables

1. **Go to Settings** → **Environments** in the sidebar
2. **Create a new environment** (Dev, Staging, Production)
3. **Add key-value pairs** for your variables
4. **Reference them** using `{{variable_name}}` syntax

### Importing Postman Collections

1. **Click the Import button** in the Collections view
2. **Select a Postman collection JSON file**
3. **Your collection will be imported** with all requests, folders, and settings

### Authentication

1. **Go to the Authorization tab** in the request builder
2. **Select authentication type** (Bearer, Basic, OAuth, etc.)
3. **Enter credentials**
4. **Authentication headers** will be automatically added to your request

---

## 🤝 Contributing

We welcome contributions from the community! Whether it's bug fixes, new features, documentation improvements, or translations, your help makes Ababil better for everyone.

### How to Contribute

1. **Fork the repository**

   ```bash
   gh repo fork AbabilX/ababil
   ```

2. **Create a feature branch**

   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make your changes** and commit

   ```bash
   git commit -m 'Add some amazing feature'
   ```

4. **Push to your branch**

   ```bash
   git push origin feature/amazing-feature
   ```

5. **Open a Pull Request**

### Development Guidelines

- Follow existing code style and conventions
- Write clear, descriptive commit messages
- Add tests for new features when applicable
- Update documentation as needed
- Ensure all tests pass before submitting PR

### Development Workflow

1. Make changes to Rust code in `ababil_core/src/`
2. Rebuild: `cd ababil_core && cargo build --release`
3. Copy the library again (if on macOS): `./build.sh`
4. Hot reload in Flutter (or restart if needed)

---

## 🐛 Bug Reports & Feature Requests

Found a bug or have an idea for a new feature? We'd love to hear from you!

- **Bug Report**: [Open an issue](https://github.com/AbabilX/ababil/issues/new?template=bug_report.md)
- **Feature Request**: [Open an issue](https://github.com/AbabilX/ababil/issues/new?template=feature_request.md)
- **Security Issue**: Please email maintainers directly

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by Postman's excellent API testing experience
- Built with amazing open-source technologies
- Special thanks to all contributors and supporters

---

## 📞 Contact & Community

- **GitHub**: [AbabilX/ababil](https://github.com/AbabilX/ababil)
- **Releases**: [Download latest version](https://github.com/AbabilX/ababil/releases)
- **Issues**: [Report bugs or request features](https://github.com/AbabilX/ababil/issues)
- **Discussions**: [Join the conversation](https://github.com/AbabilX/ababil/discussions)

---

## 🗺️ Roadmap

- [ ] Request history with search and filtering
- [ ] GraphQL query builder
- [ ] WebSocket testing
- [ ] gRPC support
- [ ] API mocking capabilities
- [ ] Automated testing workflows
- [ ] Team collaboration features
- [ ] Cloud sync (optional)
- [ ] Plugin system
- [ ] CLI version
- [ ] Code snippet generation
- [ ] Request/response validation
- [ ] Performance testing tools

---

<div align="center">
  <p>Made with ❤️ by the Ababil Team</p>
  <p>
    <a href="https://github.com/AbabilX/ababil">⭐ Star us on GitHub</a> •
    <a href="https://github.com/AbabilX/ababil/releases">📦 Download</a> •
    <a href="https://github.com/AbabilX/ababil/issues">🐛 Report a bug</a> •
    <a href="https://github.com/AbabilX/ababil/discussions">💬 Join discussions</a>
  </p>
</div>
