# Quick Start Guide - Restaurant Reservation App

## 🚀 Run the Vendor App

```bash
# Navigate to project
cd "E:/code projects/e-commerce project/restaurant_reservation_app"

# Install dependencies (if not done)
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run on Windows
flutter run -d windows --target lib/main_vendor.dart

# Run on Android
flutter run -d android --target lib/main_vendor.dart
```

## 📂 Project Structure Overview

```
restaurant_reservation_app/
│
├── lib/
│   ├── main_vendor.dart                    ← Vendor app entry
│   ├── bootstrap/
│   │   └── bootstrap_vendor.dart           ← Firebase init
│   │
│   ├── core/                               ← Shared code
│   │   ├── config/                         ← Environment config
│   │   ├── firebase/                       ← Firebase setup
│   │   ├── domain/models/                  ← Freezed models
│   │   ├── data/
│   │   │   ├── firestore/                  ← Firestore operations
│   │   │   └── repositories/               ← Business logic
│   │   └── services/                       ← Notifications, etc.
│   │
│   ├── features/                           ← Feature modules
│   │   ├── restaurants/
│   │   │   └── presentation/               ← Restaurant UI
│   │   ├── tables/
│   │   │   └── presentation/               ← Table management UI
│   │   └── bookings/
│   │       └── presentation/               ← Bookings UI
│   │
│   └── vendor_app/                         ← Vendor app root
│       ├── vendor_app.dart                 ← App widget
│       └── vendor_router.dart              ← Routes
│
├── pubspec.yaml                            ← Dependencies
├── README.md                               ← Full documentation
├── VENDOR_APP_SUMMARY.md                   ← Implementation details
└── QUICK_START.md                          ← This file
```

## 🔥 Firebase Setup (Required Before Full Use)

### 1. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase
```bash
# Run from project root
flutterfire configure
```
- Select or create Firebase project
- Choose platforms (Android, iOS, Windows, Web)
- This generates `lib/firebase_options.dart`

### 3. Enable Firebase Services

In [Firebase Console](https://console.firebase.google.com/):
- ✅ Enable **Firestore Database**
- ✅ Enable **Storage** (for restaurant images)
- ✅ Enable **Cloud Messaging** (for notifications)
- ⏳ Enable **Authentication** (for customer app later)

### 4. Update Code

In `lib/core/firebase/firebase_initializer.dart`:
```dart
// Uncomment these lines after running flutterfire configure:
import 'firebase_options.dart';

// And in initialize():
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## 📱 Current Vendor App Features

### ✅ Working Now
- Dashboard page
- Restaurant registration form (UI only)
- Table management page (placeholder)
- Bookings page (placeholder)
- Navigation between pages

### ⏳ Coming Next (Needs Implementation)
- Save restaurant to Firestore
- Upload restaurant images
- Add/remove tables
- View real-time bookings
- Receive push notifications

## 🎯 Next Development Steps

### Step 1: Wire Up Restaurant Form
Create controller in `lib/features/restaurants/presentation/controllers/`:
```dart
// vendor_restaurant_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/repositories/restaurant_repository.dart';
import '../../../../core/domain/models/restaurant.dart';

// Provider for repository
final restaurantRepositoryProvider = Provider((ref) => RestaurantRepository());

// Controller for restaurant form
class VendorRestaurantController extends StateNotifier<AsyncValue<void>> {
  final RestaurantRepository _repository;
  
  VendorRestaurantController(this._repository) : super(const AsyncValue.data(null));
  
  Future<void> createRestaurant(Restaurant restaurant) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createRestaurant(restaurant);
    });
  }
}

final vendorRestaurantControllerProvider = 
    StateNotifierProvider<VendorRestaurantController, AsyncValue<void>>((ref) {
  return VendorRestaurantController(ref.watch(restaurantRepositoryProvider));
});
```

### Step 2: Update Form Page
In `vendor_restaurant_form_page.dart`, use the controller:
```dart
// In _VendorRestaurantFormPageState:
Future<void> _saveRestaurant() async {
  if (_formKey.currentState!.validate()) {
    final restaurant = Restaurant(
      id: '', // Firestore will generate
      name: _nameController.text,
      description: _descriptionController.text,
      numberOfTables: int.parse(_numberOfTablesController.text),
      foodCategoryId: 'default', // TODO: from dropdown
      location: Location(latitude: 0, longitude: 0), // TODO: from GPS
      timeSlots: [], // TODO: configure
    );
    
    await ref.read(vendorRestaurantControllerProvider.notifier)
        .createRestaurant(restaurant);
        
    if (context.mounted) {
      context.go('/dashboard');
    }
  }
}
```

## 🧪 Testing Checklist

Before shipping:
- [ ] Firebase configured and connected
- [ ] Can create restaurant in Firestore
- [ ] Images upload to Firebase Storage
- [ ] Tables save to subcollection
- [ ] Bookings stream updates in real-time
- [ ] Notifications arrive when booking created

## 📚 Important Files to Know

| File | What It Does |
|------|--------------|
| `pubspec.yaml` | Dependencies and project config |
| `lib/main_vendor.dart` | Vendor app starts here |
| `lib/core/domain/models/restaurant.dart` | Restaurant data structure |
| `lib/core/data/repositories/restaurant_repository.dart` | Restaurant CRUD operations |
| `lib/vendor_app/vendor_router.dart` | All vendor routes defined here |
| `lib/features/restaurants/presentation/vendor_restaurant_form_page.dart` | Restaurant form UI |

## 🆘 Common Issues & Solutions

### Issue: "Target of URI doesn't exist: firebase_options.dart"
**Solution:** Run `flutterfire configure` first

### Issue: "No Firebase App has been created"
**Solution:** 
1. Check `firebase_initializer.dart` has correct import
2. Ensure `bootstrap_vendor.dart` calls `FirebaseInitializer.initialize()`

### Issue: Freezed models show errors
**Solution:** Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: "Missing Firestore index"
**Solution:** 
- Click the link in the error message
- Or manually create in Firebase Console

## 🎓 Learn More

- **Full Documentation:** See `README.md`
- **Implementation Details:** See `VENDOR_APP_SUMMARY.md`
- **Riverpod Guide:** https://riverpod.dev/
- **FlutterFire Docs:** https://firebase.flutter.dev/

---

**Ready to code?** Start with implementing the restaurant controller! 🚀
