import { IsEnum, IsNotEmpty } from 'class-validator';
import { SubscriptionStatus } from '@prisma/client';

export class UpdateSubscriptionStatusDto {
  @IsEnum(SubscriptionStatus)
  @IsNotEmpty()
  status: SubscriptionStatus;
}
