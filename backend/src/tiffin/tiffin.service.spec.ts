import { Test, TestingModule } from '@nestjs/testing';
import { TiffinService } from './tiffin.service';

describe('TiffinService', () => {
  let service: TiffinService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [TiffinService],
    }).compile();

    service = module.get<TiffinService>(TiffinService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
