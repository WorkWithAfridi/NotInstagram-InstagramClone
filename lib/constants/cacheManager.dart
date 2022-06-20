import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final cacheManager = CacheManager(Config(
  'customCacheKey',
  stalePeriod: const Duration(days: 7),
  maxNrOfCacheObjects: 100,
));
