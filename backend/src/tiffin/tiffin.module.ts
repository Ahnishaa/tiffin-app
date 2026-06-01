import { Module } from '@nestjs/common';
import { TiffinService } from './tiffin.service';
import { TiffinController } from './tiffin.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule], // <-- Gives us access to the database
  controllers: [TiffinController],
  providers: [TiffinService],
})
export class TiffinModule {}