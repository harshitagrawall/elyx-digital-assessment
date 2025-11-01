# 🧭 Elyx Digital Assessment

## 📱 Overview
This Flutter application was developed as part of the **Elyx Digital Flutter Developer Assessment**.  
It demonstrates **state management (Bloc)**, **API integration**, **dependency injection**, and **clean architecture** principles.  

The app fetches user data from the public API **[https://reqres.in/api/users](https://reqres.in/api/users)** and displays them in a user-friendly interface with search, pagination, secure storage, and proper error handling.

---

## 🚀 Features

### 👤 User List Screen
- Displays a list of users with **name** and **profile picture**.  
- Initially loads **6 users** and automatically loads more when scrolled to the bottom (pagination).  
- Includes **pull-to-refresh** to reload users.  

### 📄 User Detail Screen
- Shows complete details of the selected user:
  - Profile picture  
  - Name  
  - Email  
  - Phone (mocked for demo)  

### 🔍 Search Functionality
- Allows filtering users by name in real-time.  
- Handles **special characters**, **spaces**, and **no result** cases smoothly.  

### 🔐 Secure Storage
- Uses **Flutter Secure Storage** to store the **API key/token** safely.

### ⚙️ Error & State Handling
- Handles all major edge cases:
  - **No Internet Connection** → Shows proper message with retry button  
  - **Slow API Response** → Displays loading indicator with timeout  
  - **Empty API Response** → Shows friendly “No users found” message  
- Manages loading, success, and error states through **Bloc**.

### 🎨 UI/UX
- Clean and responsive design that works on all screen sizes and orientations.  
- Proper spacing, typography, and layout alignment following Flutter best practices.

---

## 🧩 Architecture

The app follows **Clean Architecture** with proper separation of concerns — Presentation, Domain, and Data layers — and uses **GetIt** for dependency injection.

