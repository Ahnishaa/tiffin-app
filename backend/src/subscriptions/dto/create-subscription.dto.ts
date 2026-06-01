import { IsString, IsNotEmpty, IsDateString, IsNumber, IsOptional } from 'class-validator';

export class CreateSubscriptionDto {
  @IsString()
  @IsOptional()
  cookId?: string;

  @IsString()
  @IsNotEmpty()
  mealPlanId: string;

  @IsDateString()
  @IsNotEmpty()
  startDate: string;

  @IsDateString()
  @IsNotEmpty()
  endDate: string;

  @IsNumber()
  @IsOptional()
  totalPrice?: number;
}
