# PriceWise – Smart Local Price Comparator

## 📌 Project Overview

**PriceWise** is a Flutter-based Android application that helps users compare product prices across different local shops.

Users can view product prices, compare shop prices, identify the cheapest option, add new shop prices, maintain favourites, and view price history.

The application uses SQLite for local data storage, allowing user-added prices and favourite products to remain saved on the device.

## 🎯 Objectives

- Help users compare prices of daily-use products.
- Identify shops offering the lowest prices.
- Allow users to add shop and product price details.
- Save favourite products.
- Maintain a history of submitted prices.
- Provide a simple and user-friendly interface.

## ✨ Features

- **Home Screen:** Displays available products.
- **Search Products:** Search for products by name.
- **Category Filter:** Filter products by category.
- **Product Comparison:** Compare prices across shops.
- **Cheapest Shop:** Highlight the lowest available price.
- **Add Shop Price:** Add shop name, area, and product price.
- **Favourites:** Save and manage favourite products.
- **Price History:** View previously submitted prices.
- **Local Database:** Store prices and favourites using SQLite.
- **Material 3 UI:** Modern Flutter user interface.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Programming language |
| Provider | State management |
| SQLite | Local database |
| sqflite | SQLite integration |
| path | Database path management |
| Android Studio | Android development |
| VS Code | Code editor |
| Git & GitHub | Version control |

## 📱 Application Screenshots

Add your application screenshots inside the `screenshots` folder.

### Home Screen
![Home Screen](screenshots/home.png)

### Product Comparison
![Comparison Screen](screenshots/comparison.png)

### Add Shop Price
![Add Price Screen](screenshots/add_price.png)

### Favourites
![Favourites Screen](screenshots/favourites.png)

### Price History
![Price History Screen](screenshots/history.png)

## 📂 Project Structure

```text
pricewise/
│
├── android/
├── assets/
├── lib/
│   ├── models/
│   │   ├── product.dart
│   │   └── shop_price.dart
│   │
│   ├── providers/
│   │   └── price_provider.dart
│   │
│   ├── services/
│   │   └── database_helper.dart
│   │
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── comparison_screen.dart
│   │   ├── add_price_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── price_history_screen.dart
│   │   └── shop_details_screen.dart
│   │
│   └── main.dart
│
├── test/
│   └── widget_test.dart
│
├── screenshots/
│   ├── home.png
│   ├── comparison.png
│   ├── add_price.png
│   ├── favourites.png
│   └── history.png
│
├── pubspec.yaml
└── README.md
```

## ⚙️ Installation and Setup

### Prerequisites

Install the following software:

- Flutter SDK (3.35 or above)
- Dart SDK
- Android Studio
- Visual Studio Code
- Android Emulator or Android Device
- Git

### Step 1: Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

### Step 2: Open the Project

```bash
cd pricewise
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Check Flutter Setup

```bash
flutter doctor
```

### Step 5: Run the Application

```bash
flutter run
```

## 📦 Build APK

To generate the release APK, execute:

```bash
flutter build apk --release
```

The generated APK will be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 💾 Database and Data Storage

PriceWise uses SQLite for local data storage.

The database stores:

- Shop price details
- Product information submitted through the application
- Favourite product IDs

User-added prices and favourites are stored locally on the device.

**Note:** The comparison screen includes sample demonstration prices. These are not verified live prices from actual local shops. Users can add their own shop prices through the application.

## 🧪 Testing

Run the Flutter widget tests using:

```bash
flutter test
```

Testing helps verify the application's user interface and basic functionality.

## 🚀 Future Enhancements

- Google Maps integration to locate nearby shops.
- Live price updates from participating shops.
- User login and registration.
- Cloud database integration.
- Price drop notifications.
- Advanced product search and filtering.
- Shop ratings and reviews.

## 👨‍💻 Contributors

**Project Name:** PriceWise – Smart Local Price Comparator

**College:** KALLAM HARANADHAREDDY INSTITUTE OF TECHNOLOGY

**Department:** Computer Science and Engineering

**Technology:** Flutter and Dart

**Academic Year:** 2026–2027

## 📄 License

This project is developed for academic and educational purposes.

---

**PriceWise – Compare Smart. Save More.**