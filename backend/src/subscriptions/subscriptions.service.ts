import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { MealType, SubscriptionStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSubscriptionDto } from './dto/create-subscription.dto';
import { UpdateSubscriptionStatusDto } from './dto/update-subscription-status.dto';

@Injectable()
export class SubscriptionsService {
  constructor(private prisma: PrismaService) {}

  async create(
    createSubscriptionDto: CreateSubscriptionDto,
    customerId: string,
  ) {
    const mealPlan = await this.prisma.mealPlan.findUnique({
      where: { id: createSubscriptionDto.mealPlanId },
      include: { meal: true },
    });

    if (!mealPlan || !mealPlan.isActive) {
      throw new NotFoundException(`Meal plan not found`);
    }

    const startDate = new Date(createSubscriptionDto.startDate);
    const endDate = new Date(createSubscriptionDto.endDate);

    if (endDate < startDate) {
      throw new BadRequestException('endDate must be after startDate');
    }

    return this.prisma.subscription.create({
      data: {
        customerId,
        cookId: mealPlan.cookId,
        mealPlanId: mealPlan.id,
        startDate,
        endDate,
        status: SubscriptionStatus.PENDING_PAYMENT,
        totalPrice: mealPlan.price,
        orders: {
          create: Array.from({ length: mealPlan.totalMeals }, (_, index) => {
            const scheduledDate = new Date(startDate);
            scheduledDate.setDate(startDate.getDate() + index);

            return {
              customerId,
              cookId: mealPlan.cookId,
              mealId: mealPlan.mealId,
              scheduledDate,
              mealType: mealPlan.meal?.mealType ?? MealType.LUNCH,
            };
          }),
        },
      },
      include: { cook: true, mealPlan: true, orders: true },
    });
  }

  findAll(userId: string, role: string) {
    if (role === 'CUSTOMER') {
      return this.prisma.subscription.findMany({
        where: { customerId: userId },
        include: { cook: true, mealPlan: true },
      });
    } else if (role === 'COOK') {
      return this.prisma.subscription.findMany({
        where: {
          cook: {
            userId: userId,
          },
        },
        include: { customer: { select: safeUserSelect }, mealPlan: true },
      });
    }

    // Admin
    return this.prisma.subscription.findMany({
      include: {
        customer: { select: safeUserSelect },
        cook: true,
        mealPlan: true,
      },
    });
  }

  async findOne(id: string, userId: string, role: string) {
    const subscription = await this.prisma.subscription.findUnique({
      where: { id },
      include: {
        customer: { select: safeUserSelect },
        cook: true,
        mealPlan: true,
        orders: true,
      },
    });

    if (!subscription) {
      throw new NotFoundException(`Subscription with ID ${id} not found`);
    }

    if (role === 'CUSTOMER' && subscription.customerId !== userId) {
      throw new ForbiddenException('You can only view your own subscriptions');
    }

    if (role === 'COOK' && subscription.cook.userId !== userId) {
      throw new ForbiddenException(
        'You can only view subscriptions for your meals',
      );
    }

    return subscription;
  }

  async updateStatus(
    id: string,
    updateDto: UpdateSubscriptionStatusDto,
    userId: string,
    role: string,
  ) {
    const subscription = await this.findOne(id, userId, role);
    const allowedTransitions: Record<string, string[]> = {
      PENDING_PAYMENT: ['ACTIVE', 'CANCELLED'],
      ACTIVE: ['PAUSED', 'CANCELLED', 'COMPLETED'],
      PAUSED: ['ACTIVE', 'CANCELLED'],
      CANCELLED: [],
      COMPLETED: [],
    };

    if (!allowedTransitions[subscription.status]?.includes(updateDto.status)) {
      throw new BadRequestException(
        `Invalid subscription status transition from ${subscription.status} to ${updateDto.status}`,
      );
    }

    return this.prisma.subscription.update({
      where: { id },
      data: { status: updateDto.status },
    });
  }
}

const safeUserSelect = {
  id: true,
  fullName: true,
  email: true,
  phone: true,
  role: true,
  isActive: true,
};
