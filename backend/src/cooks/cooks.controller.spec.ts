import { Test, TestingModule } from '@nestjs/testing';
import { CooksController } from './cooks.controller';

describe('CooksController', () => {
  let controller: CooksController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [CooksController],
    }).compile();

    controller = module.get<CooksController>(CooksController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
