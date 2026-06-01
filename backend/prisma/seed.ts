import { PrismaClient, Role, VerificationStatus, MealType, PlanType } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import * as bcrypt from 'bcrypt';

const adapter = new PrismaPg({
  connectionString: process.env.DATABASE_URL,
});

const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('Seeding database...');
  
  // Clear existing data
  await prisma.order.deleteMany();
  await prisma.subscription.deleteMany();
  await prisma.mealPlan.deleteMany();
  await prisma.meal.deleteMany();
  await prisma.cookProfile.deleteMany();
  await prisma.customerProfile.deleteMany();
  await prisma.user.deleteMany();

  const passwordHash = await bcrypt.hash('password123', 10);

  // 1. Create Admin
  const admin = await prisma.user.create({
    data: {
      fullName: 'Admin User',
      email: 'admin@tiffin.co',
      passwordHash,
      role: Role.ADMIN,
    },
  });
  console.log(`Created admin: ${admin.email}`);

  // 2. Create Customers
  const customer1 = await prisma.user.create({
    data: {
      fullName: 'Alice Smith',
      email: 'alice@example.com',
      passwordHash,
      role: Role.CUSTOMER,
      customerProfile: {
        create: {
          defaultAddress: '123 Main St, Cityville',
          dietaryPreferences: ['Vegetarian'],
          allergies: ['Peanuts'],
        }
      }
    },
  });
  
  const customer2 = await prisma.user.create({
    data: {
      fullName: 'Bob Johnson',
      email: 'bob@example.com',
      passwordHash,
      role: Role.CUSTOMER,
      customerProfile: {
        create: {
          defaultAddress: '456 Oak St, Townsville',
        }
      }
    },
  });
  console.log(`Created customers: ${customer1.email}, ${customer2.email}`);

  // 3. Create Cooks
  const cook1 = await prisma.user.create({
    data: {
      fullName: 'Chef Maria',
      email: 'maria@tiffin.co',
      passwordHash,
      role: Role.COOK,
      cookProfile: {
        create: {
          businessName: "Maria's Authentic Mexican",
          kitchenAddress: '789 Pine St, Food District',
          cuisineSpecialties: ['Mexican', 'Spicy'],
          verificationStatus: VerificationStatus.APPROVED,
        }
      }
    },
    include: { cookProfile: true }
  });

  const cook2 = await prisma.user.create({
    data: {
      fullName: 'Chef Ken',
      email: 'ken@tiffin.co',
      passwordHash,
      role: Role.COOK,
      cookProfile: {
        create: {
          businessName: "Ken's Sushi & Bento",
          kitchenAddress: '321 Maple Ave, Food District',
          cuisineSpecialties: ['Japanese', 'Seafood'],
          verificationStatus: VerificationStatus.APPROVED,
        }
      }
    },
    include: { cookProfile: true }
  });

  const cookPending = await prisma.user.create({
    data: {
      fullName: 'New Chef',
      email: 'new@tiffin.co',
      passwordHash,
      role: Role.COOK,
      cookProfile: {
        create: {
          businessName: "Startup Kitchen",
          verificationStatus: VerificationStatus.PENDING,
        }
      }
    },
  });
  console.log(`Created cooks: ${cook1.email}, ${cook2.email}, ${cookPending.email}`);

  // 4. Create Meals
  const meal1 = await prisma.meal.create({
    data: {
      cookId: cook1.cookProfile!.id,
      name: 'Spicy Chicken Enchiladas',
      cuisineType: 'Mexican',
      mealType: MealType.DINNER,
      price: 12.99,
      availableDays: ['MONDAY', 'WEDNESDAY', 'FRIDAY'],
    }
  });

  const meal2 = await prisma.meal.create({
    data: {
      cookId: cook2.cookProfile!.id,
      name: 'Salmon Bento Box',
      cuisineType: 'Japanese',
      mealType: MealType.LUNCH,
      price: 15.50,
      availableDays: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
    }
  });
  console.log('Created meals');

  // 5. Create Meal Plans
  const plan1 = await prisma.mealPlan.create({
    data: {
      cookId: cook1.cookProfile!.id,
      name: 'Mexican Fiesta 5-Day Plan',
      durationDays: 5,
      totalMeals: 5,
      price: 60.00,
      planType: PlanType.FIVE_DAY,
    }
  });

  const plan2 = await prisma.mealPlan.create({
    data: {
      cookId: cook2.cookProfile!.id,
      name: 'Monthly Sushi Lover',
      durationDays: 20,
      totalMeals: 20,
      price: 280.00,
      planType: PlanType.TWENTY_DAY,
    }
  });
  console.log('Created meal plans');

  console.log('Database seeded successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
