import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateCustomerDto } from './dto/update-customer.dto';

@Injectable()
export class CustomersService {
  constructor(private prisma: PrismaService) {}

  async findOne(userId: string) {
    const profile = await this.prisma.customerProfile.findUnique({
      where: { userId },
      include: {
        user: {
          select: { fullName: true, email: true, phone: true },
        },
      },
    });

    if (!profile) {
      throw new NotFoundException(`Customer profile not found`);
    }

    return profile;
  }

  async findById(id: string) {
    const profile = await this.prisma.customerProfile.findUnique({
      where: { id },
      include: {
        user: {
          select: { fullName: true, email: true, phone: true },
        },
      },
    });

    if (!profile) {
      throw new NotFoundException(`Customer profile not found`);
    }

    return profile;
  }

  async update(userId: string, updateCustomerDto: UpdateCustomerDto) {
    const profile = await this.prisma.customerProfile.findUnique({
      where: { userId },
    });

    if (!profile) {
      throw new NotFoundException(`Customer profile not found`);
    }

    return this.prisma.customerProfile.update({
      where: { userId },
      data: updateCustomerDto,
    });
  }
}
