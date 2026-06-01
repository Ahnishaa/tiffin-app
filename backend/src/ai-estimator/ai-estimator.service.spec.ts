import { Test, TestingModule } from '@nestjs/testing';
import { AiEstimatorService } from './ai-estimator.service';

describe('AiEstimatorService', () => {
  let service: AiEstimatorService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [AiEstimatorService],
    }).compile();

    service = module.get<AiEstimatorService>(AiEstimatorService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
