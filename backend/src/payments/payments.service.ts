import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { InitiatePaymentDto } from './payments.controller';

@Injectable()
export class PaymentsService {
  constructor(private readonly prisma: PrismaService) {}

  async createPayment(dto: InitiatePaymentDto) {
    if (!dto.orderId && !dto.subscriptionId) {
      throw new BadRequestException('Either orderId or subscriptionId must be provided');
    }

    const fiuuTxnId = `FIUU-${Math.random().toString(36).substring(2, 11).toUpperCase()}`;

    return this.prisma.payment.create({
      data: {
        amount: dto.amount,
        orderId: dto.orderId || null,
        subscriptionId: dto.subscriptionId || null,
        fiuuTxnId,
        status: 'PENDING',
      },
    });
  }

  async processMockWebhook(id: string, status: 'SUCCESS' | 'FAILED') {
    const payment = await this.prisma.payment.findUnique({
      where: { id },
    });

    if (!payment) {
      throw new NotFoundException(`Payment with ID ${id} not found`);
    }

    const updatedPayment = await this.prisma.payment.update({
      where: { id },
      data: { status },
    });

    if (status === 'SUCCESS') {
      if (payment.subscriptionId) {
        await this.prisma.subscription.update({
          where: { id: payment.subscriptionId },
          data: { status: 'ACTIVE' },
        });
      }
      if (payment.orderId) {
        await this.prisma.order.update({
          where: { id: payment.orderId },
          data: { status: 'CONFIRMED' },
        });
      }
    }

    return updatedPayment;
  }
}
