import { Controller, Get, Body, Patch, Param, UseGuards } from '@nestjs/common';
import { CooksService } from './cooks.service';
import { UpdateCookDto } from './dto/update-cook.dto';
import { VerifyCookDto } from './dto/verify-cook.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { Role } from '../common/enums/role.enum';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@Controller('cooks')
export class CooksController {
  constructor(private readonly cooksService: CooksService) {}

  @Get()
  findAll() {
    return this.cooksService.findAll();
  }

  @Get('me')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.COOK)
  findMyProfile(@CurrentUser() user: any) {
    return this.cooksService.findOne(user.id);
  }

  @Patch('me')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.COOK)
  updateMyProfile(
    @Body() updateCookDto: UpdateCookDto,
    @CurrentUser() user: any,
  ) {
    return this.cooksService.update(user.id, updateCookDto);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.cooksService.findPublicById(id);
  }

  @Patch(':id/verification')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  verify(@Param('id') id: string, @Body() verifyCookDto: VerifyCookDto) {
    return this.cooksService.verify(id, verifyCookDto);
  }
}
