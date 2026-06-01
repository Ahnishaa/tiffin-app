import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { CooksController } from './cooks.controller';
import { CooksService } from './cooks.service';

@Module({
  imports: [PrismaModule],
  controllers: [CooksController],
  providers: [CooksService],
})
export class CooksModule {}
