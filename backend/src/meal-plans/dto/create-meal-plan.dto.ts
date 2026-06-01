import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsNumber,
  IsEnum,
  IsBoolean,
} from 'class-validator';
import { PlanType } from '@prisma/client';

export class CreateMealPlanDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsNumber()
  @IsNotEmpty()
  durationDays: number;

  @IsNumber()
  @IsNotEmpty()
  totalMeals: number;

  @IsNumber()
  @IsNotEmpty()
  price: number;

  @IsEnum(PlanType)
  @IsOptional()
  planType?: PlanType;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;

  @IsString()
  @IsOptional()
  mealId?: string;
}
