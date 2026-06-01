import { IsString, IsOptional, IsArray, IsNumber } from 'class-validator';

export class UpdateCookDto {
  @IsString()
  @IsOptional()
  businessName?: string;

  @IsString()
  @IsOptional()
  bio?: string;

  @IsString()
  @IsOptional()
  kitchenAddress?: string;

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  cuisineSpecialties?: string[];

  @IsNumber()
  @IsOptional()
  maxMealsPerDay?: number;
}
