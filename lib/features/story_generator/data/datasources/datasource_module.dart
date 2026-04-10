import 'package:injectable/injectable.dart';
import 'mock_story_generator_datasource.dart';

@module
abstract class StoryGeneratorDataSourceModule {
  @lazySingleton
  MockStoryGeneratorDataSource get mockDataSource =>
      MockStoryGeneratorDataSource();
}
