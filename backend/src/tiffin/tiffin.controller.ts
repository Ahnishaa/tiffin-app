import { Controller, Get, Post, Body, Patch, Param } from '@nestjs/common';
import { TiffinService } from './tiffin.service';
import { TiffinStatus } from '@prisma/client';

@Controller('tiffin')
export class TiffinController {
  constructor(private readonly tiffinService: TiffinService) {}

  // POST http://localhost:3000/api/tiffin
  @Post()
  create(@Body('qrCode') qrCode: string) {
    return this.tiffinService.createContainer(qrCode);
  }

  // GET http://localhost:3000/api/tiffin
  @Get()
  findAll() {
    return this.tiffinService.findAllContainers();
  }

  // PATCH http://localhost:3000/api/tiffin/:id/status
  @Patch(':id/status')
  updateStatus(
    @Param('id') id: string,
    @Body('status') status: TiffinStatus,
    @Body('customerId') customerId?: string | null,
  ) {
    return this.tiffinService.updateStatus(id, status, customerId);
  }
}