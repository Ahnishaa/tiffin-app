import { Module } from '@nestjs/common';
import { AiEstimatorService } from './ai-estimator.service';
import { AiEstimatorController } from './ai-estimator.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [AiEstimatorController],
  providers: [AiEstimatorService],
})
export class AiEstimatorModule {}