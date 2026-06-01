# TIFFIN.CO Codex Project Instructions

TIFFIN.CO is a sustainable food-tech app connecting customers with verified home cooks for affordable home-cooked meal subscriptions.

The project is split into:

- `/frontend` = Flutter app
- `/backend` = NestJS + Prisma + PostgreSQL API

Current priority:
Debug and validate the backend only.

Do not integrate frontend and backend yet.
Do not modify Flutter UI unless explicitly requested.
Do not overwrite `.env`.
Do not print secrets or database passwords.
Do not commit `.env`.

Backend stack:
- NestJS
- Prisma
- PostgreSQL
- JWT authentication
- bcrypt
- class-validator

Backend modules expected:
- Auth
- Users
- Customers
- Cooks
- Meals
- Meal Plans
- Subscriptions
- Orders

Other member scope, do not implement unless only adding placeholders:
- Fiuu payment
- Gemini AI
- Lalamove
- Tiffin QR tracking
- Sustainability calculations

Current backend goal:
Make sure the backend installs, builds, connects to local PostgreSQL, syncs Prisma schema, seeds data, starts successfully, and all core API
