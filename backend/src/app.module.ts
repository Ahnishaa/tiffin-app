import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { CustomersModule } from './customers/customers.module';
import { CooksModule } from './cooks/cooks.module';
import { MealsModule } from './meals/meals.module';
import { MealPlansModule } from './meal-plans/meal-plans.module';
import { SubscriptionsModule } from './subscriptions/subscriptions.module';
import { OrdersModule } from './orders/orders.module';

import { ConfigModule } from '@nestjs/config';
import { PaymentsModule } from './payments/payments.module';
import { DeliveriesModule } from './deliveries/deliveries.module';
import { TiffinModule } from './tiffin/tiffin.module';
import { AiEstimatorModule } from './ai-estimator/ai-estimator.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    AuthModule,
    UsersModule,
    CustomersModule,
    CooksModule,
    MealsModule,
    MealPlansModule,
    SubscriptionsModule,
    OrdersModule,
    PaymentsModule,
    DeliveriesModule,
    TiffinModule,
    AiEstimatorModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
