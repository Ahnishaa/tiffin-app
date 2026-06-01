import { Injectable, NotFoundException } from '@nestjs/common';
import { VerificationStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateCookDto } from './dto/update-cook.dto';
import { VerifyCookDto } from './dto/verify-cook.dto';

@Injectable()
export class CooksService {
  constructor(private prisma: PrismaService) {}

  findAll() {
    return this.prisma.cookProfile.findMany({
      where: { verificationStatus: VerificationStatus.APPROVED },
      include: {
        user: {
          select: { fullName: true, email: true, phone: true },
        },
      },
    });
  }

  async findPublicById(id: string) {
    const profile = await this.prisma.cookProfile.findFirst({
      where: {
        id,
        verificationStatus: VerificationStatus.APPROVED,
      },
      include: {
        user: {
          select: { fullName: true, email: true, phone: true },
        },
      },
    });

    if (!profile) {
      throw new NotFoundException(`Cook profile not found`);
    }

    return profile;
  }

  async findOne(userId: string) {
    const profile = await this.prisma.cookProfile.findUnique({
      where: { userId },
      include: {
        user: {
          select: { fullName: true, email: true, phone: true },
        },
      },
    });

    if (!profile) {
      throw new NotFoundException(`Cook profile not found`);
    }

    return profile;
  }

  async update(userId: string, updateCookDto: UpdateCookDto) {
    const profile = await this.prisma.cookProfile.findUnique({
      where: { userId },
    });

    if (!profile) {
      throw new NotFoundException(`Cook profile not found`);
    }

    return this.prisma.cookProfile.update({
      where: { userId },
      data: updateCookDto,
    });
  }

  async verify(id: string, verifyCookDto: VerifyCookDto) {
    const profile = await this.prisma.cookProfile.findUnique({
      where: { id },
    });

    if (!profile) {
      throw new NotFoundException(`Cook profile with ID ${id} not found`);
    }

    return this.prisma.cookProfile.update({
      where: { id },
      data: {
        verificationStatus: verifyCookDto.status,
      },
    });
  }
}
