import { Controller, Post, Body, Param } from '@nestjs/common';
import { PaymentsService } from './payments.service';

class InitiatePaymentDto {
  amount!: number;
  orderId?: string;
  subscriptionId?: string;
}

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  // POST http://localhost:3000/api/payments/initiate
  @Post('initiate')
  initiatePayment(@Body() dto: InitiatePaymentDto) {
    return this.paymentsService.createPayment(dto);
  }

  // POST http://localhost:3000/api/payments/:id/webhook-mock
  @Post(':id/webhook-mock')
  simulateWebhook(@Param('id') id: string, @Body('status') status: 'SUCCESS' | 'FAILED') {
    return this.paymentsService.processMockWebhook(id, status);
  }
}