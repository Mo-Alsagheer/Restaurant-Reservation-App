# Restaurant Reservation App

A Flutter + Firebase restaurant reservation system with two apps: **Vendor App** (for restaurant owners) and **Customer App** (for diners).

## 🎯 Project Overview

This project implements a complete restaurant table booking system where:
- **Vendors** can register restaurants, manage tables (max 6 seats each), and view bookings in real-time
- **Customers** can browse restaurants by category, search by name, and book available tables

## 🏗️ Architecture

The project follows a **feature-first, layered architecture**:

```
lib/
├── main_vendor.dart              # Vendor app entry point
├── main_customer.dart            # Customer app entry point (TODO)
├── bootstrap/                    # App initialization
│   ├── bootstrap_vendor.dart
│   └── bootstrap_customer.dart   # (TODO)
├── core/                         # Shared code across both apps
│   ├── config/                   # Environment & flavor config
│   ├── firebase/                 # Firebase initialization
│   ├── domain/models/            # Freezed domain entities
│   │   ├── restaurant.dart
│   │   ├── table_model.dart
│   │   ├── reservation.dart
│   │   ├── food_category.dart
│   │   ├── location.dart
│   │   └── time_slot.dart
│   ├── data/
│   │   ├── firestore/            # Firestore data sources
│   │   └── repositories/         # Repository layer
│   └── services/                 # Cross-cutting services
├── features/                     # Feature modules
│   ├── restaurants/
│   ├── tables/
│   ├── bookings/
│   └── auth/                     # (TODO - Customer only)
├── vendor_app/                   # Vendor-specific root
│   ├── vendor_app.dart
│   └── vendor_router.dart
└── customer_app/                 # (TODO)
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart 3.10.0 or higher
- Firebase project (to be configured)

### Installation

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run code generation (for Freezed models):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Configure Firebase:**
   ```bash
   # Install FlutterFire CLI globally
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Update Firebase Initializer:**
   After running `flutterfire configure`, uncomment the Firebase options import in `lib/core/firebase/firebase_initializer.dart`

### Running the Apps

**Vendor App:**
```bash
flutter run -d windows --target lib/main_vendor.dart
```

**Customer App (TODO):**
```bash
flutter run --target lib/main_customer.dart
```

## 📋 Requirements

### ✅ Vendor App (Scaffolded)

- [x] Project structure with feature-first architecture
- [x] Firebase integration setup
- [x] Domain models with Freezed
- [x] Firestore data sources & repositories
- [x] Basic UI pages (dashboard, restaurant form, tables, bookings)
- [x] Navigation with go_router
- [x] Notification service stub

### ⏳ TODO - Full Implementation

**Vendor App:**
- [ ] Restaurant registration with image upload, categories, GPS, time slots
- [ ] Table management CRUD
- [ ] Real-time bookings view
- [ ] Push notifications

**Customer App:**
- [ ] Authentication (login/register)
- [ ] Browse & search restaurants
- [ ] Booking flow with real-time availability
- [ ] Booking history

## 🔥 Firebase Collections

```
restaurants/
  - name, description, imageUrl, foodCategoryId
  - location: {latitude, longitude, address}
  - numberOfTables, maxSeatsPerTable (6)
  - timeSlots: [{id, time, isAvailable}]
  - tables/ (subcollection)

reservations/
  - restaurantId, tableId, customerId
  - reservationDate, timeSlot, partySize
  - status (pending/confirmed/cancelled)

foodCategories/
  - name, description, iconUrl
```

## 🛠️ Tech Stack

- Flutter & Dart
- Firebase (Firestore, Auth, Storage, Messaging)
- Riverpod (state management)
- go_router (navigation)
- Freezed (immutable models)
- image_picker, geolocator

## 📝 Development Notes

### Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Double Booking Prevention
Uses Firestore transactions in `ReservationRepository.createReservation()` to prevent conflicts.

---

**Created:** November 29, 2025  
**Status:** Vendor App - Scaffold Complete ✅
