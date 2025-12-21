# Stockito

> ⚠️ **Not your language?**
>
> This README is in English. If you prefer another language, switch to the corresponding branch:
> - Spanish: `main`
> - Portuguese: `docs/portuguese-readme`

**Current status:** v1.0.0

Stockito is an inventory and sales application developed in Flutter, designed for small businesses and entrepreneurs. It allows you to manage products, register sales, and view daily reports in a simple and efficient way. Additionally, it is highly customizable to fit the specific needs of your business. You can add a specific feature in the your_feature view according to your requirements.

---

## 📱 Main Features

### 1. Product Management
- Add, edit, and delete products
- Quick search by name
- View stock and prices

<p>
  <img src="screenshots/light_mode_english/main_page.jpg" alt="Product Management" width="150"/>
  <img src="screenshots/light_mode_english/search_bar.jpg" alt="Search Bar" width="150"/>
</p>

### 2. Sales Reports
- Dedicated daily reports page ("Reports" tab)
- View sales by day and date selector
- Daily summary: total products sold and total amount
- Detailed list of sold products
- Handles empty and error states

<p>
  <img src="screenshots/light_mode_english/sales_page.jpg" alt="Sales Reports" width="150"/>
</p>

### 3. Settings and User Experience
- Local SQLite database
- Persistent navigation and state between sessions
- Modern and responsive interface
- Multilanguage support (Spanish, English, Portuguese)
- Dark mode available in all features

<p>
  <img src="screenshots/light_mode_english/settings_page.jpg" alt="Settings Page" width="150"/>
</p>

### 4. Customization and Extensibility
- The app is designed to be easily customizable.
- You can add any additional functionality in the "Your Feature" view (`your_feature`).
- Ideal for developers who want to adapt the app to specific needs or experiment with new features.

<p>
  <img src="screenshots/light_mode_english/your_feature_page.jpg" alt="Your Feature Light" width="150"/>
</p>

---

## 🛠️ Technologies and Architecture

- **Framework:** Flutter
- **State management:** BLoC (flutter_bloc)
- **Dependency injection:** GetIt
- **Local database:** SQLite (sqflite)
- **Internationalization:** flutter_localizations, JSON files
- **Architecture:** Clean Architecture

---

## 🚀 Installation and Running

1. Download the latest APK from [Releases](https://github.com/LesterCornielt/stockito-inventory-app/releases/download/v1.0.0/Stockito.v1.0.0.apk).
2. Install it on your Android device.
3. Or, follow these steps to build from source:
   ```sh
   git clone https://github.com/LesterCornielt/stockito-inventory-app.git
   cd stockito-inventory-app
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

---

## 📂 Project Structure

- `lib/core/` - Base services, utilities, and dependency configuration
- `lib/features/` - Main features (products, sales, reports, settings)
- `lib/l10n/` - Localization files
- `assets/` - Graphic resources
- `screenshots/` - Screenshots

Architecture based on Clean Architecture, separating data, domain, and presentation to facilitate maintenance and scalability.

---

## 🧪 Testing

Stockito includes a complete suite of automated tests following Flutter and Clean Architecture best practices.

### Types of Tests

#### 1. **Unit Tests**
- **Coverage**: Use cases, entities, models, repositories, data sources
- **Location**: `test/unit/`
- **Status**: ✅ Implemented
  - Domain Layer: Use cases and entities (56 tests)
  - Data Layer: Models and repositories (36 tests)

#### 2. **Widget Tests**
- **Coverage**: Pages, custom widgets, BLoC interaction
- **Location**: `test/widget/`
- **Status**: ✅ Implemented

#### 3. **Integration Tests**
- **Coverage**: Complete end-to-end flows
- **Location**: `integration_test/`
- **Status**: 📋 Planned

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run tests for a specific feature
flutter test test/unit/features/products/

# Run a specific test
flutter test test/unit/features/products/domain/entities/product_test.dart
```

### Viewing Code Coverage

```bash
# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
xdg-open coverage/html/index.html  # Linux
open coverage/html/index.html      # macOS
```

### Test Structure

```
test/
├── unit/                          # Unit tests
│   ├── features/
│   │   ├── products/
│   │   │   ├── domain/           # Use cases and entities
│   │   │   └── data/             # Models and repositories
│   │   └── sales/
│   │       ├── domain/
│   │       └── data/
│   └── core/                      # Base service tests
├── widget/                        # Widget tests
│   └── features/
│       ├── products/
│       ├── sales/
│       ├── navigation/
│       └── settings/
├── helpers/                       # Helpers and utilities
│   ├── mock_data.dart            # Reusable test data
│   ├── test_helpers.dart         # Auxiliary functions
│   ├── bloc_test_helpers.dart   # BLoC helpers
│   └── widget_test_helpers.dart # Widget test helpers
└── integration_test/              # Integration tests
```

### Tools and Dependencies

The following tools are used for testing:

- **flutter_test**: Flutter testing framework (included in SDK)
- **bloc_test**: BLoC and state management testing
- **mockito**: Creating mocks for dependencies
- **sqflite_common_ffi**: In-memory database for desktop tests
- **fake_async**: Time control in asynchronous tests

### Available Helpers

The project includes reusable helpers to facilitate test writing:

- **MockData**: Predefined test data (products, sales)
- **TestHelpers**: Functions to configure test database
- **BlocTestHelpers**: Utilities specific to BLoC testing
- **WidgetTestHelpers**: Helpers for widget testing setup

### Additional Documentation

For more information about testing, see:
- [`test/README.md`](test/README.md) - Complete testing guide
- [`plan.md`](plan.md) - Test implementation plan
- [`test/EJECUTAR_TESTS.md`](test/EJECUTAR_TESTS.md) - Detailed execution guide

---

## 🤝 How to Contribute?

Contributions are welcome! To collaborate:

1. Fork the repository and clone it locally.
2. Create a branch for your feature or fix:
   ```sh
   git checkout -b my-feature
   ```
3. Make your changes and write descriptive commits.
4. Make sure the app compiles and follows the current best practices of the project.
5. Push to your fork and open a Pull Request to `main`.
6. Clearly describe your contribution in the PR.

**Recommendations:**
- Follow the existing architecture and patterns (Clean Architecture, BLoC, etc).

---

## 📝 License

MIT License. See the LICENSE file for more details.

