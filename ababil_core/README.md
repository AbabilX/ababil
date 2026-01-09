# Ababil Core

**High-performance HTTP client library written in Rust, providing FFI bindings for cross-platform integration.**

## 🎯 Core Purpose

`ababil_core` is the heart of the Ababil application - a native Rust library that handles all HTTP request execution. It provides a Foreign Function Interface (FFI) that allows high-level languages like Dart (Flutter), JavaScript (Electron), or any C-compatible language to leverage Rust's performance and safety for HTTP operations.

### Why Rust?

- **⚡ Performance**: Native speed with zero-cost abstractions
- **🔒 Safety**: Memory safety without garbage collection overhead
- **🌐 Async**: Built on Tokio for efficient concurrent request handling
- **📦 Small Binary**: Minimal runtime overhead compared to interpreted languages
- **🔗 FFI-Friendly**: Seamless C-compatible interface for cross-language integration

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Client Application (Flutter/Electron)       │
│                    JSON Request String                   │
└───────────────────────────┬─────────────────────────────┘
                            │ FFI Call
                            │ make_http_request(json_str)
┌───────────────────────────▼─────────────────────────────┐
│              ababil_core (Rust Library)                  │
│  ┌─────────────────────────────────────────────────┐   │
│  │  1. Parse JSON → Request struct                 │   │
│  │  2. Build URL from components                   │   │
│  │  3. Process headers & authentication           │   │
│  │  4. Build request body (raw/urlencoded/etc)    │   │
│  │  5. Execute HTTP request via reqwest            │   │
│  │  6. Collect response (status, headers, body)    │   │
│  │  7. Measure duration                            │   │
│  │  8. Serialize to JSON                           │   │
│  └─────────────────────────────────────────────────┘   │
└───────────────────────────┬─────────────────────────────┘
                            │ JSON Response String
┌───────────────────────────▼─────────────────────────────┐
│              Client Application                           │
│              Parses JSON → Updates UI                     │
└─────────────────────────────────────────────────────────┘
```

---

## 🔧 How It Works

### 1. FFI Interface

The library exposes two main C-compatible functions:

#### `make_http_request(request_json: *const c_char) -> *mut c_char`

The primary entry point for making HTTP requests.

**Input**: A JSON-encoded string containing the request specification
**Output**: A JSON-encoded string containing the response (must be freed with `free_string`)

**Request JSON Structure**:
```json
{
  "method": "POST",
  "url": {
    "raw": "https://api.example.com/users",
    "protocol": "https",
    "host": ["api", "example", "com"],
    "path": ["users"],
    "query": [
      {
        "key": "page",
        "value": "1",
        "disabled": false
      }
    ]
  },
  "header": [
    {
      "key": "Content-Type",
      "value": "application/json",
      "disabled": false
    }
  ],
  "body": {
    "mode": "raw",
    "raw": "{\"name\": \"John\"}"
  },
  "auth": {
    "type": "bearer",
    "bearer": [
      {
        "key": "token",
        "value": "your-token-here"
      }
    ]
  }
}
```

**Response JSON Structure**:
```json
{
  "status_code": 200,
  "headers": [
    ["Content-Type", "application/json"],
    ["Content-Length", "1234"]
  ],
  "body": "{\"id\": 1, \"name\": \"John\"}",
  "duration_ms": 245
}
```

#### `free_string(ptr: *mut c_char)`

Frees memory allocated by `make_http_request`. **Must be called** after using the response to prevent memory leaks.

### 2. Request Processing Flow

#### Step 1: JSON Parsing
```rust
let request: Request = serde_json::from_str(json_str)?;
```
The incoming JSON string is deserialized into a strongly-typed `Request` struct using Serde.

#### Step 2: URL Construction
The library supports two URL formats:
- **Raw URL**: If `url.raw` is provided, it's used directly
- **Component-based**: Builds URL from protocol, host, path, and query parameters

```rust
// Example: https://api.example.com/users?page=1
protocol: "https"
host: ["api", "example", "com"]  → "api.example.com"
path: ["users"]                 → "/users"
query: [{"key": "page", "value": "1"}]  → "?page=1"
```

#### Step 3: Header Processing
- Extracts headers from the request
- Filters out disabled headers
- Applies authentication headers (Bearer, Basic, etc.)

#### Step 4: Authentication
Supports multiple authentication types:

**Bearer Token**:
```rust
Authorization: Bearer <token>
```

**Basic Auth**:
```rust
// Encodes username:password as base64
Authorization: Basic <base64_encoded_credentials>
```

**Other types** (OAuth, Digest, etc.) are structured for future implementation.

#### Step 5: Body Construction
Handles multiple body types:

- **Raw**: Direct string content (JSON, XML, plain text, etc.)
- **URL-encoded**: `key1=value1&key2=value2` format
- **Form-data**: Multipart form data (currently converted to URL-encoded)
- **GraphQL**: Converts GraphQL query and variables to JSON format

#### Step 6: HTTP Execution
Uses `reqwest` with Tokio async runtime:

```rust
let rt = tokio::runtime::Runtime::new()?;
rt.block_on(async {
    let client = reqwest::Client::new();
    let response = request_builder.send().await?;
    // Process response...
})
```

**Supported HTTP Methods**:
- GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS

#### Step 7: Response Collection
- Extracts status code
- Collects all response headers
- Reads response body as text
- Measures request duration

#### Step 8: JSON Serialization
The response is serialized back to JSON and returned as a C string pointer.

### 3. Error Handling

The library handles errors gracefully:

- **Invalid JSON**: Returns error response with status_code 0
- **Network errors**: Captured and returned in response body
- **Invalid URLs**: Returns error message in response body
- **All errors include duration**: Even failed requests track execution time

### 4. Memory Management

- **Input strings**: Borrowed from caller (no allocation needed)
- **Output strings**: Allocated on heap, caller must free with `free_string`
- **No memory leaks**: Proper cleanup in `free_string` function

---

## 📦 Dependencies

### Core Dependencies

- **`reqwest`** (0.11): High-level HTTP client library
  - Features: `json`, `blocking` (for async runtime)
  - Handles all HTTP protocol details

- **`tokio`** (1.0): Async runtime
  - Features: `full` (all Tokio features enabled)
  - Powers async request execution

- **`serde`** (1.0): Serialization framework
  - Features: `derive` (for automatic trait generation)
  - Converts between JSON and Rust structs

- **`serde_json`** (1.0): JSON implementation for Serde
  - Handles JSON parsing and serialization

- **`base64`** (0.21): Base64 encoding/decoding
  - Used for Basic authentication credentials

### Build Dependencies

- **`cbindgen`** (0.24): C header generation
  - Generates `target/ababil_core.h` for C/C++ integration
  - Used in `build.rs` script

---

## 🔨 Building

### Prerequisites

- **Rust** (latest stable version)
- **Cargo** (comes with Rust)

### Build Commands

```bash
# Debug build
cargo build

# Release build (optimized)
cargo build --release
```

### Output Files

After building, you'll find the native library:

- **macOS**: `target/release/libababil_core.dylib`
- **Linux**: `target/release/libababil_core.so`
- **Windows**: `target/release/ababil_core.dll`

### C Header Generation

The build script automatically generates a C header file:

```
target/ababil_core.h
```

This header can be used for C/C++ integration.

---

## 📝 Usage Examples

### From Flutter (Dart)

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Load the library
final DynamicLibrary lib = DynamicLibrary.open('libababil_core.dylib');

// Define function signatures
typedef MakeHttpRequestNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef FreeStringNative = Void Function(Pointer<Utf8>);

final makeHttpRequest = lib.lookupFunction<MakeHttpRequestNative, MakeHttpRequestNative>('make_http_request');
final freeString = lib.lookupFunction<FreeStringNative, FreeStringNative>('free_string');

// Make a request
final requestJson = '{"method": "GET", "url": {"raw": "https://api.github.com"}}';
final requestPtr = requestJson.toNativeUtf8();
final responsePtr = makeHttpRequest(requestPtr);
final responseJson = responsePtr.toDartString();
freeString(responsePtr);
```

### From C

```c
#include "target/ababil_core.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
    const char* request = "{\"method\":\"GET\",\"url\":{\"raw\":\"https://api.github.com\"}}";
    
    char* response = make_http_request(request);
    
    if (response != NULL) {
        printf("Response: %s\n", response);
        free_string(response);
    }
    
    return 0;
}
```

### Request Examples

#### Simple GET Request
```json
{
  "method": "GET",
  "url": {
    "raw": "https://api.github.com/users/octocat"
  }
}
```

#### POST with JSON Body
```json
{
  "method": "POST",
  "url": {
    "raw": "https://api.example.com/users"
  },
  "header": [
    {
      "key": "Content-Type",
      "value": "application/json"
    }
  ],
  "body": {
    "mode": "raw",
    "raw": "{\"name\": \"John Doe\", \"email\": \"john@example.com\"}"
  }
}
```

#### POST with Bearer Token
```json
{
  "method": "POST",
  "url": {
    "raw": "https://api.example.com/protected"
  },
  "auth": {
    "type": "bearer",
    "bearer": [
      {
        "key": "token",
        "value": "your-secret-token"
      }
    ]
  },
  "body": {
    "mode": "raw",
    "raw": "{\"data\": \"value\"}"
  }
}
```

#### POST with URL-encoded Body
```json
{
  "method": "POST",
  "url": {
    "raw": "https://api.example.com/login"
  },
  "header": [
    {
      "key": "Content-Type",
      "value": "application/x-www-form-urlencoded"
    }
  ],
  "body": {
    "mode": "urlencoded",
    "urlencoded": [
      {
        "key": "username",
        "value": "user123"
      },
      {
        "key": "password",
        "value": "secret"
      }
    ]
  }
}
```

#### GraphQL Request
```json
{
  "method": "POST",
  "url": {
    "raw": "https://api.example.com/graphql"
  },
  "header": [
    {
      "key": "Content-Type",
      "value": "application/json"
    }
  ],
  "body": {
    "mode": "graphql",
    "graphql": {
      "query": "query { user(id: 1) { name email } }",
      "variables": "{\"id\": 1}"
    }
  }
}
```

---

## 🧪 Testing

### Manual Testing

You can test the library using a simple HTTP request:

```bash
# Build the library
cargo build --release

# Test with curl (if you have a test harness)
# Or integrate with Flutter app for end-to-end testing
```

### Integration Testing

The library is tested through the Flutter application, which provides:
- Real-world usage scenarios
- Cross-platform validation
- Performance benchmarking

---

## 🔍 Code Structure

```
ababil_core/
├── Cargo.toml          # Dependencies and build configuration
├── build.rs            # Build script (generates C headers)
├── README.md           # This file
└── src/
    ├── lib.rs          # Main library entry point, FFI functions
    ├── models/         # Data structures
    │   ├── mod.rs
    │   ├── request.rs  # Request, URL, Header, Body, Auth structs
    │   ├── collection.rs
    │   ├── environment.rs
    │   └── variable.rs
    └── postman.rs      # Postman collection parsing utilities
```

### Key Modules

- **`lib.rs`**: FFI functions, request execution logic
- **`models/request.rs`**: Request data structures matching Postman format
- **`models/collection.rs`**: Collection and item structures
- **`models/environment.rs`**: Environment variable structures
- **`postman.rs`**: Postman collection/environment parsing

---

## 🚀 Performance Characteristics

- **Low Latency**: Direct native execution, no VM overhead
- **Memory Efficient**: Zero-copy where possible, explicit memory management
- **Concurrent**: Built on Tokio for handling multiple requests efficiently
- **Small Binary**: Optimized release builds are typically < 1MB

---

## 🔐 Security Considerations

- **Input Validation**: All inputs are validated before processing
- **Memory Safety**: Rust's type system prevents common memory vulnerabilities
- **No Unsafe Network Code**: Uses battle-tested `reqwest` library
- **Error Handling**: Graceful error handling prevents crashes

---

## 🛠️ Development

### Adding New Features

1. **Update Models**: Add new fields to `models/request.rs` if needed
2. **Implement Logic**: Add processing logic in `lib.rs`
3. **Update FFI**: Ensure FFI interface remains backward compatible
4. **Test**: Verify with Flutter application

### Debugging

```bash
# Build with debug symbols
cargo build

# Run with logging (if added)
RUST_LOG=debug cargo run
```

---

## 📄 License

This project is part of Ababil and follows the same license as the main project.

---

## 🤝 Contributing

See the main [Ababil README](../README.md) for contribution guidelines.

---

## 📚 Additional Resources

- [Rust FFI Guide](https://doc.rust-lang.org/nomicon/ffi.html)
- [reqwest Documentation](https://docs.rs/reqwest/)
- [Tokio Documentation](https://tokio.rs/)
- [Serde Documentation](https://serde.rs/)
