# Vendor App - Restaurant Form Implementation Guide

## ✅ What Has Been Completed

### 1. Full Restaurant Registration Form
The vendor app now has a complete restaurant registration form with all requested features:

#### Features Implemented:
- ✅ Restaurant image upload to Cloudinary
- ✅ Food category selection (with category management)
- ✅ Sales point location (GPS coordinates)
- ✅ Time slots configuration (5 slots per day)
- ✅ Table configuration (multiple tables, max 6 seats each)
- ✅ Complete form validation
- ✅ Cloudinary integration for image uploads
- ✅ Location services integration

### 2. Services Created

#### CloudinaryService ([lib/core/services/cloudinary_service.dart](lib/core/services/cloudinary_service.dart))
- Upload images to Cloudinary
- Image compression before upload
- Delete images from Cloudinary
- Extract public ID from URLs

#### LocationService ([lib/core/services/location_service.dart](lib/core/services/location_service.dart))
- Get current GPS location
- Convert address to coordinates
- Convert coordinates to address
- Calculate distance between locations
- Permission handling

### 3. Widgets Created

#### FoodCategoryPicker ([lib/features/restaurants/presentation/widgets/food_category_picker.dart](lib/features/restaurants/presentation/widgets/food_category_picker.dart))
- Dropdown to select food category
- Link to category management page
- Handles empty state

#### TimeSlotPicker ([lib/features/restaurants/presentation/widgets/time_slot_picker.dart](lib/features/restaurants/presentation/widgets/time_slot_picker.dart))
- Add/remove time slots
- Default 5 slots (10:00, 12:00, 14:00, 16:00, 18:00)
- Custom time picker
- Maximum 5 slots validation
- Duplicate prevention

#### TableConfiguration ([lib/features/restaurants/presentation/widgets/table_configuration.dart](lib/features/restaurants/presentation/widgets/table_configuration.dart))
- Quick setup (generate multiple tables at once)
- Add/edit/delete individual tables
- Table number, capacity (max 6), and area
- Validation for duplicate table numbers
- Maximum seats validation

### 4. Pages Created

#### FoodCategoryManagementPage ([lib/features/restaurants/presentation/pages/food_category_management_page.dart](lib/features/restaurants/presentation/pages/food_category_management_page.dart))
- Add new food categories
- Delete categories
- Real-time category list
- Categories stored in Firestore

#### VendorRestaurantFormPage ([lib/features/restaurants/presentation/pages/vendor_restaurant_form_page_new.dart](lib/features/restaurants/presentation/pages/vendor_restaurant_form_page_new.dart))
- Complete restaurant registration form
- Image picker with preview
- All form fields integrated
- Loading states
- Error handling

### 5. State Management

#### RestaurantFormController ([lib/features/restaurants/presentation/controllers/restaurant_form_controller.dart](lib/features/restaurants/presentation/controllers/restaurant_form_controller.dart))
- Create restaurant with all data
- Update restaurant
- Image upload handling
- Table creation in subcollection
- Loading and error states

## 🚀 How to Run

### 1. Install Dependencies
```bash
cd "e:/code projects/e-commerce project/restaurant_reservation_app/client"
flutter pub get
```

### 2. Configure Cloudinary

**Important:** You need to set up a Cloudinary account and update the credentials.

1. Go to [Cloudinary](https://cloudinary.com/) and create a free account
2. Get your Cloud Name and create an Upload Preset:
   - Go to Settings → Upload → Add upload preset
   - Mode: **Unsigned**
   - Copy the preset name
3. Update [lib/core/services/cloudinary_service.dart](lib/core/services/cloudinary_service.dart):

```dart
// Replace these with your actual credentials
static const String _cloudName = 'your_cloud_name';  // Your Cloudinary cloud name
static const String _uploadPreset = 'your_upload_preset';  // Your unsigned upload preset
```

### 3. Configure Firebase (If not already done)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

This will generate `firebase_options.dart`.

### 4. Run the App

```bash
# Windows
flutter run -d windows --target lib/main_vendor.dart

# Android Emulator
flutter run -d emulator-5554 --target lib/main_vendor.dart

# Check available devices
flutter devices
```

## 📋 Complete User Flow

### 1. **Dashboard** (`/dashboard`)
- Shows welcome screen
- "Register Restaurant" button

### 2. **Register Restaurant** (`/restaurant/add`)

#### Step-by-Step Form:

**a. Restaurant Image**
- Tap the image area to select from gallery
- Image is compressed and uploaded to Cloudinary
- Preview shown immediately

**b. Basic Information**
- Restaurant Name (required)
- Description (required)

**c. Food Category**
- Select from dropdown (required)
- Click "Manage Categories" to add/remove categories

**d. Sales Point Location**
- Click "Use Current" to get GPS coordinates
- Shows address and coordinates
- Required field

**e. Time Slots** (5 slots per day)
- Default slots: 10:00 AM, 12:00 PM, 2:00 PM, 4:00 PM, 6:00 PM
- Click "+ Add Slot" for custom times
- Remove slots by clicking X on chips
- Maximum 5 slots

**f. Table Configuration**
- **Quick Setup:** Enter number of tables and seats per table (max 6)
- **Manual:** Add tables individually with:
  - Table number
  - Capacity (1-6 seats)
  - Area (e.g., "Main Hall", "Outdoor", "VIP")
- Edit or delete any table

**g. Submit**
- Click "Create Restaurant"
- All data saved to Firestore
- Tables saved as subcollection
- Returns to dashboard on success

### 3. **Manage Food Categories** (`/categories`)
- Add new category with name and description
- View all categories
- Delete categories (with confirmation)

## 📁 File Structure

```
lib/
├── core/
│   ├── services/
│   │   ├── cloudinary_service.dart      ✅ Image upload
│   │   └── location_service.dart        ✅ GPS location
│   └── domain/models/
│       ├── restaurant.dart
│       ├── table_model.dart
│       ├── time_slot.dart
│       ├── food_category.dart
│       └── location.dart
├── features/
│   └── restaurants/
│       └── presentation/
│           ├── controllers/
│           │   └── restaurant_form_controller.dart  ✅ State management
│           ├── pages/
│           │   ├── vendor_restaurant_form_page_new.dart  ✅ Main form
│           │   └── food_category_management_page.dart    ✅ Categories
│           └── widgets/
│               ├── food_category_picker.dart    ✅ Category dropdown
│               ├── time_slot_picker.dart        ✅ Time slots
│               └── table_configuration.dart     ✅ Tables
├── vendor_app/
│   └── vendor_router.dart               ✅ Updated routes
└── main_vendor.dart
```

## 🔧 Key Features Details

### Image Upload to Cloudinary
- Automatically compresses images (70% quality, max 1024x1024)
- Uploads to `restaurants` folder
- Returns secure URL
- Handles errors gracefully

### Location Services
- Requests permission at runtime
- Gets current GPS coordinates
- Converts to human-readable address
- Stores both coordinates and address

### Time Slots
- Exactly 5 slots per day (configurable)
- 24-hour format stored (e.g., "14:00")
- 12-hour format displayed (e.g., "2:00 PM")
- Prevents duplicates

### Tables
- Each table has:
  - Unique table number
  - Capacity (1-6 seats)
  - Area/section name
- Stored as subcollection: `restaurants/{id}/tables`
- Can generate multiple tables at once

### Food Categories
- Vendors can create custom categories
- Examples: "Fish Restaurant", "Desserts", "Italian", "Fast Food"
- Stored in Firestore `food_categories` collection
- Categories shared across all restaurants

## 🎨 UI/UX Features

- Material 3 design
- Deep Orange primary color (vendor theme)
- Form validation with error messages
- Loading states during operations
- Success/error snackbar messages
- Image preview before upload
- Responsive layout

## 🔐 Permissions Required

### Android ([android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml))
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS ([ios/Runner/Info.plist](ios/Runner/Info.plist))
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to set restaurant address</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to select restaurant photos</string>
```

## 📊 Firestore Data Structure

```
firestore/
├── restaurants/
│   └── {restaurant_id}/
│       ├── name: "Pizza Palace"
│       ├── description: "Best pizza in town"
│       ├── imageUrl: "https://res.cloudinary.com/..."
│       ├── foodCategoryId: "cat123"
│       ├── foodCategoryName: "Italian"
│       ├── numberOfTables: 5
│       ├── maxSeatsPerTable: 6
│       ├── location:
│       │   ├── latitude: 40.7128
│       │   ├── longitude: -74.0060
│       │   └── address: "123 Main St, New York"
│       ├── timeSlots: [
│       │   {id: "slot1", time: "10:00", isAvailable: true},
│       │   {id: "slot2", time: "12:00", isAvailable: true},
│       │   ...
│       │ ]
│       └── tables/ (subcollection)
│           ├── {table_id_1}:
│           │   ├── tableNumber: 1
│           │   ├── capacity: 4
│           │   └── area: "Main Hall"
│           ├── {table_id_2}:
│           │   ├── tableNumber: 2
│           │   ├── capacity: 6
│           │   └── area: "Outdoor"
│
└── food_categories/
    └── {category_id}/
        ├── name: "Italian"
        └── description: "Italian cuisine"
```

## 🐛 Troubleshooting

### Issue: "Out of memory" error
**Solution:** Reduce Gradle memory in [android/gradle.properties](android/gradle.properties):
```properties
org.gradle.jvmargs=-Xmx4G
```

### Issue: Cloudinary upload fails
**Solution:** 
1. Check your cloud name and upload preset
2. Ensure upload preset is "Unsigned"
3. Check internet connection

### Issue: Location permission denied
**Solution:**
1. Check permissions in AndroidManifest.xml / Info.plist
2. Manually enable location in device settings
3. Restart the app

### Issue: Image picker not working
**Solution:**
1. Check storage permissions
2. On emulator, ensure virtual SD card is set up

## 🎯 Next Steps

1. **Configure Cloudinary credentials** (most important!)
2. Test the complete flow
3. Add authentication for vendors
4. Implement edit restaurant functionality
5. Add restaurant listing page
6. Set up Firebase Cloud Functions for notifications

## 📝 Notes

- All images are compressed before upload to save bandwidth
- Location requires user permission at runtime
- Tables are stored as subcollection for better querying
- Time slots use 24-hour format internally
- Maximum 6 seats per table (as requested)
- Maximum 5 time slots per day (as requested)

---

**Status:** ✅ All requested features implemented and ready for testing!
