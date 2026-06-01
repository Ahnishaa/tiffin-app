import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TiffinStatus } from '@prisma/client';

@Injectable()
export class TiffinService {
  constructor(private readonly prisma: PrismaService) {}

  // 1. Register a brand new container
  async createContainer(qrCode: string) {
    return this.prisma.tiffinContainer.create({
      data: { qrCode },
    });
  }

  // 2. See all containers and who currently holds them
  async findAllContainers() {
    return this.prisma.tiffinContainer.findMany({
      include: {
        customer: {
          select: { id: true, fullName: true, email: true },
        },
      },
    });
  }

  // 3. Update a container's status (e.g., scanning the QR code when returned)
  async updateStatus(id: string, status: TiffinStatus, currentCustId?: string | null) {
    const container = await this.prisma.tiffinContainer.findUnique({ where: { id } });
    if (!container) {
      throw new NotFoundException(`Tiffin container with ID ${id} not found`);
    }

    return this.prisma.tiffinContainer.update({
      where: { id },
      data: { 
        status, 
        currentCustId: currentCustId !== undefined ? currentCustId : container.currentCustId 
      },
    });
  }
}