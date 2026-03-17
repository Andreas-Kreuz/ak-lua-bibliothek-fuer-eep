export interface CacheService {
  writeCache(cachedData: unknown): void;
  readCache(): unknown;
}
