import { IsEnum, IsNotEmpty } from 'class-validator';
import { VerificationStatus } from '@prisma/client';

export class VerifyCookDto {
  @IsEnum(VerificationStatus)
  @IsNotEmpty()
  status: VerificationStatus;
}
