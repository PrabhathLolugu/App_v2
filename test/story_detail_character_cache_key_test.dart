import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_detail_bloc.dart';

void main() {
  test('buildCharacterDetailsCacheKey includes language scope', () {
    final englishKey = StoryDetailBloc.buildCharacterDetailsCacheKey(
      characterName: 'Rama',
      languageCode: 'en',
    );
    final bengaliKey = StoryDetailBloc.buildCharacterDetailsCacheKey(
      characterName: 'Rama',
      languageCode: 'bn',
    );

    expect(englishKey, equals('rama::en'));
    expect(bengaliKey, equals('rama::bn'));
    expect(englishKey, isNot(equals(bengaliKey)));
  });

  test('buildCharacterDetailsCacheKey normalizes casing and spaces', () {
    final key = StoryDetailBloc.buildCharacterDetailsCacheKey(
      characterName: '  RaMa  ',
      languageCode: ' EN ',
    );

    expect(key, equals('rama::en'));
  });

  test('StoryDetailState.copyWith clears selected character details', () {
    final state = StoryDetailState.initial().copyWith(
      selectedCharacterName: 'Rama',
      selectedCharacterDetails: const {'appearance': 'Prince'},
    );

    final clearedState = state.copyWith(clearSelectedCharacterDetails: true);

    expect(clearedState.selectedCharacterName, isNull);
    expect(clearedState.selectedCharacterDetails, isNull);
  });
}
