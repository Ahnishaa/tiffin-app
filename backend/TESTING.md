# Backend Testing Guide

This guide covers the verified backend core API scope only:

- Auth
- Users
- Customers
- Cooks
- Meals
- Meal Plans
- Subscriptions
- Orders

Do not use this guide for frontend integration, payments, AI, delivery, QR tracking, or sustainability features.

## Setup

Run commands from `/backend`.

```powershell
npm install
npx prisma generate
npx prisma db push
npx prisma db seed
npm run build
npm run start:dev
```

The API should start at:

```text
http://localhost:3000/api
```

## Demo Accounts

All seeded demo accounts use the intentionally configured test password:

```text
password123
```

| Role | Email | Notes |
| --- | --- | --- |
| Admin | admin@tiffin.co | Admin user |
| Customer | alice@example.com | Seeded customer |
| Customer | bob@example.com | Seeded customer |
| Cook | maria@tiffin.co | Approved cook |
| Cook | ken@tiffin.co | Approved cook |
| Cook | new@tiffin.co | Pending cook |

## Token Helpers

```powershell
$AdminLogin = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"email":"admin@tiffin.co","password":"password123"}'
$AdminToken = $AdminLogin.access_token

$CustomerLogin = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"email":"alice@example.com","password":"password123"}'
$CustomerToken = $CustomerLogin.access_token

$CookLogin = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" `
  -Method POST `
  -ContentType "application/json" `
  -Body '{"email":"maria@tiffin.co","password":"password123"}'
$CookToken = $CookLogin.access_token
```

Use tokens like this:

```powershell
$Headers = @{ Authorization = "Bearer $AdminToken" }
```

## Recommended Test Order

1. Auth login and `/auth/me`
2. Public browse routes: `/meals`, `/meal-plans`, `/cooks`
3. Admin users and verification routes
4. Customer profile routes
5. Cook profile, meal, and meal-plan management routes
6. Customer subscription creation
7. Subscription access control and status transitions
8. Generated orders and order status flow

## Verified Examples

Public browse:

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/meals" -Method GET
Invoke-RestMethod -Uri "http://localhost:3000/api/meal-plans" -Method GET
Invoke-RestMethod -Uri "http://localhost:3000/api/cooks" -Method GET
```

Current user:

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/auth/me" `
  -Method GET `
  -Headers @{ Authorization = "Bearer $CustomerToken" }
```

Admin users:

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/users" `
  -Method GET `
  -Headers @{ Authorization = "Bearer $AdminToken" }
```

Customer profile:

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/customers/me" `
  -Method GET `
  -Headers @{ Authorization = "Bearer $CustomerToken" }
```

Cook profile:

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/cooks/me" `
  -Method GET `
  -Headers @{ Authorization = "Bearer $CookToken" }
```

Create a meal as an approved cook:

```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/meals" `
  -Method POST `
  -Headers @{ Authorization = "Bearer $CookToken" } `
  -ContentType "application/json" `
  -Body '{"name":"API Test Meal","cuisineType":"Malaysian","mealType":"LUNCH","price":11.5,"availableDays":["MONDAY","TUESDAY"]}'
```

Create a subscription from a meal plan:

```powershell
$MealPlans = Invoke-RestMethod -Uri "http://localhost:3000/api/meal-plans" -Method GET
$MealPlanId = $MealPlans[0].id

Invoke-RestMethod -Uri "http://localhost:3000/api/subscriptions" `
  -Method POST `
  -Headers @{ Authorization = "Bearer $CustomerToken" } `
  -ContentType "application/json" `
  -Body (@{
    mealPlanId = $MealPlanId
    startDate = "2026-06-02"
    endDate = "2026-06-06"
  } | ConvertTo-Json)
```

Update order status:

```powershell
$Orders = Invoke-RestMethod -Uri "http://localhost:3000/api/orders" `
  -Method GET `
  -Headers @{ Authorization = "Bearer $CookToken" }
$OrderId = $Orders[0].id

Invoke-RestMethod -Uri "http://localhost:3000/api/orders/$OrderId/status" `
  -Method PATCH `
  -Headers @{ Authorization = "Bearer $CookToken" } `
  -ContentType "application/json" `
  -Body '{"status":"CONFIRMED"}'
```

## Expected Access Rules

- Public routes: `GET /meals`, `GET /meals/:id`, `GET /meal-plans`, `GET /meal-plans/:id`, `GET /cooks`, `GET /cooks/:id`
- Customer routes require a customer Bearer token.
- Cook management routes require a cook Bearer token.
- Admin routes require an admin Bearer token.
- Wrong roles should return `403`.
- Missing Bearer tokens on protected routes should return `401`.
- Invalid DTO bodies should return `400`.
- Non-existent IDs should return `404`.
- Responses must not include `passwordHash`.

## Notes For Frontend Integration

- The backend base URL is `http://localhost:3000/api`.
- Store and send JWT access tokens as `Authorization: Bearer <token>`.
- Public browse screens can call meals, meal plans, and cooks without a token.
- Use `/customers/me` for customer profile screens.
- Use `/cooks/me` for cook profile screens.
- Subscription creation only needs `mealPlanId`, `startDate`, and `endDate`; the backend calculates total price from the meal plan.
- Subscription creation generates the related orders.
- Keep frontend integration separate from backend validation work.
