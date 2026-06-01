# TIFFIN.CO Backend

This is the NestJS backend for the TIFFIN.CO application.

## Prerequisites

- Node.js (v18+)
- PostgreSQL

## Getting Started

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure environment:
   ```bash
   cp .env.example .env
   ```
   Update `.env` with your PostgreSQL `DATABASE_URL`.

3. Generate Prisma client and migrate database:
   ```bash
   npx prisma generate
   npx prisma migrate dev
   ```

4. Run the development server:
   ```bash
   npm run start:dev
   ```

## Project Structure

- `src/auth`: Authentication using JWT and Passport
- `src/users`: User management
- `src/customers`: Customer profiles
- `src/cooks`: Cook profiles and verification
- `src/meals`: Meal listings
- `src/meal-plans`: Meal plans and bundles
- `src/subscriptions`: User subscriptions
- `src/orders`: Order tracking
- `src/prisma`: Database service
- `src/common`: Shared guards, decorators, and enums
