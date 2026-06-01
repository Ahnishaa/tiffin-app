import { Test, TestingModule } from '@nestjs/testing';
import { AiEstimatorController } from './ai-estimator.controller';

describe('AiEstimatorController', () => {
  let controller: AiEstimatorController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AiEstimatorController],
    }).compile();

    controller = module.get<AiEstimatorController>(AiEstimatorController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
