import { IsString, IsOptional, IsArray } from 'class-validator';

export class UpdateCustomerDto {
  @IsString()
  @IsOptional()
  defaultAddress?: string;

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  dietaryPreferences?: string[];

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  allergies?: string[];

  @IsString()
  @IsOptional()
  budgetRange?: string;
}
