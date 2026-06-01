import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateOrderStatusDto } from './dto/update-order-status.dto';

@Injectable()
export class OrdersService {
  constructor(private prisma: PrismaService) {}

  findAll(userId: string, role: string) {
    if (role === 'CUSTOMER') {
      return this.prisma.order.findMany({
        where: { customerId: userId },
        include: { cook: true, meal: true },
      });
    } else if (role === 'COOK') {
      return this.prisma.order.findMany({
        where: {
          cook: {
            userId: userId,
          },
        },
        include: { customer: { select: safeUserSelect }, meal: true },
      });
    }

    // Admin
    return this.prisma.order.findMany({
      include: { customer: { select: safeUserSelect }, cook: true, meal: true },
    });
  }

  async findOne(id: string, userId: string, role: string) {
    const order = await this.prisma.order.findUnique({
      where: { id },
      include: { customer: { select: safeUserSelect }, cook: true, meal: true },
    });

    if (!order) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }

    if (role === 'CUSTOMER' && order.customerId !== userId) {
      throw new ForbiddenException('You can only view your own orders');
    }

    if (role === 'COOK' && order.cook.userId !== userId) {
      throw new ForbiddenException('You can only view orders for your kitchen');
    }

    return order;
  }

  async updateStatus(
    id: string,
    updateDto: UpdateOrderStatusDto,
    userId: string,
    role: string,
  ) {
    const order = await this.findOne(id, userId, role);

    if (role === 'CUSTOMER' && updateDto.status !== 'CANCELLED') {
      throw new ForbiddenException('Customers can only cancel orders');
    }

    const allowedTransitions: Record<string, string[]> = {
      PENDING: ['CONFIRMED', 'CANCELLED'],
      CONFIRMED: ['PREPARING', 'CANCELLED'],
      PREPARING: ['READY_FOR_PICKUP', 'CANCELLED'],
      READY_FOR_PICKUP: ['PICKED_UP', 'CANCELLED'],
      PICKED_UP: ['DELIVERED'],
      DELIVERED: ['COMPLETED'],
      CANCELLED: [],
      COMPLETED: [],
    };

    if (!allowedTransitions[order.status]?.includes(updateDto.status)) {
      throw new BadRequestException(
        `Invalid order status transition from ${order.status} to ${updateDto.status}`,
      );
    }

    return this.prisma.order.update({
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
