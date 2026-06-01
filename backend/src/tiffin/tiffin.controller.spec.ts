import { Test, TestingModule } from '@nestjs/testing';
import { TiffinController } from './tiffin.controller';

describe('TiffinController', () => {
  let controller: TiffinController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TiffinController],
    }).compile();

    controller = module.get<TiffinController>(TiffinController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
