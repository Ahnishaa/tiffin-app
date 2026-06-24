# TIFFIN.CO Codex Project Instructions

TIFFIN.CO is a sustainable food-tech app connecting customers with verified home cooks for affordable home-cooked meal subscriptions.

The project is split into:

- `/frontend` = Flutter app

Current priority:
Pure Firebase Architecture.
The NestJS backend has been removed and replaced entirely by Firebase (Firestore for data, Firebase Auth for authentication).

Do not modify Flutter UI unless explicitly requested.

Backend stack (Firebase):
- Firebase Auth
- Cloud Firestore

Frontend modules expected:
- Auth
- Users
- Customers
- Cooks
- Meals
- Subscriptions
- Orders

Other member scope, do not implement unless only adding placeholders:
- Fiuu payment (Mocked)
- Gemini AI
- Lalamove
- Tiffin QR tracking
- Sustainability calculations

Current goal:
Ensure the frontend is perfectly wired to Firestore, with CRUD operations for orders, dynamic UI updates without breaking designs, and error handling properly added.
