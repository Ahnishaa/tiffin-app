import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateMealDto } from './dto/create-meal.dto';
import { UpdateMealDto } from './dto/update-meal.dto';

@Injectable()
export class MealsService {
  constructor(private prisma: PrismaService) {}

  async create(createMealDto: CreateMealDto, userId: string) {
    const cookProfile = await this.prisma.cookProfile.findUnique({
      where: { userId },
    });

    if (!cookProfile) {
      throw new ForbiddenException('Only verified cooks can create meals');
    }

    if (cookProfile.verificationStatus !== 'APPROVED') {
      throw new ForbiddenException(
        'Cook profile must be approved to create meals',
      );
    }

    return this.prisma.meal.create({
      data: {
        ...createMealDto,
        cookId: cookProfile.id,
      },
    });
  }

  findAll() {
    return this.prisma.meal.findMany({
      include: {
        cook: true,
      },
    });
  }

  async findOne(id: string) {
    const meal = await this.prisma.meal.findUnique({
      where: { id },
      include: {
        cook: true,
      },
    });

    if (!meal) {
      throw new NotFoundException(`Meal with ID ${id} not found`);
    }

    return meal;
  }

  async update(id: string, updateMealDto: UpdateMealDto, userId: string) {
    const meal = await this.findOne(id);

    const cookProfile = await this.prisma.cookProfile.findUnique({
      where: { userId },
    });

    if (meal.cookId !== cookProfile?.id) {
      throw new ForbiddenException('You can only update your own meals');
    }

    return this.prisma.meal.update({
      where: { id },
      data: updateMealDto,
    });
  }

  async remove(id: string, userId: string, role: string) {
    const meal = await this.findOne(id);

    const cookProfile = await this.prisma.cookProfile.findUnique({
      where: { userId },
    });

    if (role !== 'ADMIN' && meal.cookId !== cookProfile?.id) {
      throw new ForbiddenException('You can only delete your own meals');
    }

    return this.prisma.meal.update({
      where: { id },
      data: { isAvailable: false },
    });
  }
}
