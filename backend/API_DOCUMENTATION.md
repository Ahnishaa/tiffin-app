# TIFFIN.CO API Documentation

All endpoints are prefixed with `/api`.

## Auth

### Register
`POST /auth/register`
- **Body**: `{ "fullName": "John Doe", "email": "john@example.com", "password": "password", "role": "CUSTOMER" }`
- **Response**: User object (no password)

### Login
`POST /auth/login`
- **Body**: `{ "email": "john@example.com", "password": "password" }`
- **Response**: `{ "access_token": "...", "user": { ... } }`

### Get Current User
`GET /auth/me`
- **Headers**: `Authorization: Bearer <token>`
- **Response**: Current logged in user object

## Other Modules

*To be fully documented as controllers are implemented...*

- **Users**: `/users`
- **Customers**: `/customers`
- **Cooks**: `/cooks`
- **Meals**: `/meals`
- **Meal Plans**: `/meal-plans`
- **Subscriptions**: `/subscriptions`
- **Orders**: `/orders`
