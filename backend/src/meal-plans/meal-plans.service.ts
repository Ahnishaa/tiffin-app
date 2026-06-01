import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateMealPlanDto } from './dto/create-meal-plan.dto';
import { UpdateMealPlanDto } from './dto/update-meal-plan.dto';

@Injectable()
export class MealPlansService {
  constructor(private prisma: PrismaService) {}

  async create(createMealPlanDto: CreateMealPlanDto, userId: string) {
    const cookProfile = await this.prisma.cookProfile.findUnique({
      where: { userId },
    });

    if (!cookProfile) {
      throw new ForbiddenException('Only verified cooks can create meal plans');
    }

    if (cookProfile.verificationStatus !== 'APPROVED') {
      throw new ForbiddenException(
        'Cook profile must be approved to create meal plans',
      );
    }

    return this.prisma.mealPlan.create({
      data: {
        ...createMealPlanDto,
        cookId: cookProfile.id,
      },
    });
  }

  findAll() {
    return this.prisma.mealPlan.findMany({
      include: {
        cook: true,
        meal: true,
      },
    });
  }

  async findOne(id: string) {
    const mealPlan = await this.prisma.mealPlan.findUnique({
      where: { id },
      include: {
        cook: true,
        meal: true,
      },
    });

    if (!mealPlan) {
      throw new NotFoundException(`Meal plan with ID ${id} not found`);
    }

    return mealPlan;
  }

  async update(
    id: string,
    updateMealPlanDto: UpdateMealPlanDto,
    userId: string,
  ) {
    const mealPlan = await this.findOne(id);

    const cookProfile = await this.prisma.cookProfile.findUnique({
      where: { userId },
    });

    if (mealPlan.cookId !== cookProfile?.id) {
      throw new ForbiddenException('You can only update your own meal plans');
    }

    return this.prisma.mealPlan.update({
      where: { id },
      data: updateMealPlanDto,
    });
  }

  async remove(id: string, userId: string, role: string) {
    const mealPlan = await this.findOne(id);

    const cookProfile = await this.prisma.cookProfile.findUnique({
      where: { userId },
    });

    if (role !== 'ADMIN' && mealPlan.cookId !== cookProfile?.id) {
      throw new ForbiddenException('You can only delete your own meal plans');
    }

    return this.prisma.mealPlan.update({
      where: { id },
      data: { isActive: false },
    });
  }
}
