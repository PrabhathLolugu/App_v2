///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsKn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.kn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <kn>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsKn _root = this; // ignore: unused_field

	@override 
	TranslationsKn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKn(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppKn app = _TranslationsAppKn._(_root);
	@override late final _TranslationsCommonKn common = _TranslationsCommonKn._(_root);
	@override late final _TranslationsNavigationKn navigation = _TranslationsNavigationKn._(_root);
	@override late final _TranslationsHomeKn home = _TranslationsHomeKn._(_root);
	@override late final _TranslationsHomeScreenKn homeScreen = _TranslationsHomeScreenKn._(_root);
	@override late final _TranslationsStoriesKn stories = _TranslationsStoriesKn._(_root);
	@override late final _TranslationsStoryGeneratorKn storyGenerator = _TranslationsStoryGeneratorKn._(_root);
	@override late final _TranslationsChatKn chat = _TranslationsChatKn._(_root);
	@override late final _TranslationsMapKn map = _TranslationsMapKn._(_root);
	@override late final _TranslationsCommunityKn community = _TranslationsCommunityKn._(_root);
	@override late final _TranslationsDiscoverKn discover = _TranslationsDiscoverKn._(_root);
	@override late final _TranslationsPlanKn plan = _TranslationsPlanKn._(_root);
	@override late final _TranslationsSettingsKn settings = _TranslationsSettingsKn._(_root);
	@override late final _TranslationsAuthKn auth = _TranslationsAuthKn._(_root);
	@override late final _TranslationsErrorKn error = _TranslationsErrorKn._(_root);
	@override late final _TranslationsSubscriptionKn subscription = _TranslationsSubscriptionKn._(_root);
	@override late final _TranslationsNotificationKn notification = _TranslationsNotificationKn._(_root);
	@override late final _TranslationsProfileKn profile = _TranslationsProfileKn._(_root);
	@override late final _TranslationsFeedKn feed = _TranslationsFeedKn._(_root);
	@override late final _TranslationsVoiceKn voice = _TranslationsVoiceKn._(_root);
	@override late final _TranslationsFestivalsKn festivals = _TranslationsFestivalsKn._(_root);
	@override late final _TranslationsSocialKn social = _TranslationsSocialKn._(_root);
}

// Path: app
class _TranslationsAppKn extends TranslationsAppEn {
	_TranslationsAppKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'ಭಾರತೀಯ ಶಾಸ್ತ್ರಗಳನ್ನು ಅನ್ವೇಷಿಸಿ';
}

// Path: common
class _TranslationsCommonKn extends TranslationsCommonEn {
	_TranslationsCommonKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ಸರಿ';
	@override String get cancel => 'ರದ್ದುಮಾಡಿ';
	@override String get confirm => 'ದೃಢೀಕರಿಸಿ';
	@override String get delete => 'ಅಳಿಸಿ';
	@override String get edit => 'ತಿದ್ದು';
	@override String get save => 'ಉಳಿಸಿ';
	@override String get share => 'ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get search => 'ಹುಡುಕಿ';
	@override String get loading => 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...';
	@override String get error => 'ದೋಷ';
	@override String get retry => 'ಮತ್ತೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ';
	@override String get back => 'ಹಿಂದೆ';
	@override String get next => 'ಮುಂದೆ';
	@override String get finish => 'ಮುಗಿಸು';
	@override String get skip => 'ಬಿಟ್ಟುಬಿಡಿ';
	@override String get yes => 'ಹೌದು';
	@override String get no => 'ಇಲ್ಲ';
	@override String get readFullStory => 'ಪೂರ್ತಿ ಕಥೆಯನ್ನು ಓದಿ';
	@override String get dismiss => 'ಮುಚ್ಚಿ';
	@override String get offlineBannerMessage => 'ನೀವು ಆಫ್‌ಲೈನ್ ಸ್ಥಿತಿಯಲ್ಲಿದ್ದೀರಿ – ಸಂಗ್ರಹಿತ ವಿಷಯವನ್ನು ನೋಡುತ್ತಿರುವಿರಿ';
	@override String get backOnline => 'ಮತ್ತೆ ಆನ್‌ಲೈನ್ ಆಗಿದೆ';
}

// Path: navigation
class _TranslationsNavigationKn extends TranslationsNavigationEn {
	_TranslationsNavigationKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get home => 'ಅನ್ವೇಷಣೆ';
	@override String get stories => 'ಕಥೆಗಳು';
	@override String get chat => 'ಚಾಟ್';
	@override String get map => 'ನಕ್ಷೆ';
	@override String get community => 'ಸಾಮಾಜಿಕ';
	@override String get settings => 'ಸೆಟ್ಟಿಂಗುಗಳು';
	@override String get profile => 'ಪ್ರೊಫೈಲ್';
}

// Path: home
class _TranslationsHomeKn extends TranslationsHomeEn {
	_TranslationsHomeKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'ಕಥೆ ಹೊರತುಗಾರ';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'ಸಮುದಾಯ ಕಥೆಗಳು';
	@override String get maps => 'ನಕ್ಷೆಗಳು';
	@override String get greetingMorning => 'ಶುಭೋದಯ';
	@override String get continueReading => 'ಓದು ಮುಂದುವರಿಸಿ';
	@override String get greetingAfternoon => 'ಶುಭ ಮಧ್ಯಾಹ್ನ';
	@override String get greetingEvening => 'ಶುಭ ಸಂಜೆ';
	@override String get greetingNight => 'ಶುಭ ರಾತ್ರಿ';
	@override String get exploreStories => 'ಕಥೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ';
	@override String get generateStory => 'ಕಥೆಯನ್ನು ರಚಿಸಿ';
	@override String get content => 'ಹೋಮ್ ವಿಷಯ';
}

// Path: homeScreen
class _TranslationsHomeScreenKn extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'ನಮಸ್ಕಾರ';
	@override String get quoteOfTheDay => 'ಇಂದಿನ ಚಿಂತನೆ';
	@override String get shareQuote => 'ಚಿಂತನೆ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get copyQuote => 'ಚಿಂತನೆ ನಕಲಿಸಿ';
	@override String get quoteCopied => 'ಚಿಂತನೆ ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ನಕಲಿಸಲಾಗಿದೆ';
	@override String get featuredStories => 'ವಿಶೇಷ ಕಥೆಗಳು';
	@override String get quickActions => 'ದ್ರುತ ಕ್ರಿಯೆಗಳು';
	@override String get generateStory => 'ಕಥೆಯನ್ನು ರಚಿಸಿ';
	@override String get chatWithKrishna => 'ಕೃಷ್ಣರೊಂದಿಗೆ ಚಾಟ್ ಮಾಡಿ';
	@override String get myActivity => 'ನನ್ನ ಚಟುವಟಿಕೆ';
	@override String get continueReading => 'ಓದು ಮುಂದುವರಿಸಿ';
	@override String get savedStories => 'ಉಳಿಸಿದ ಕಥೆಗಳು';
	@override String get exploreMyitihas => 'ಮೈಇತಿಹಾಸ್ ಅನ್ವೇಷಿಸಿ';
	@override String get storiesInYourLanguage => 'ನಿಮ್ಮ ಭಾಷೆಯಲ್ಲಿರುವ ಕಥೆಗಳು';
	@override String get seeAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';
	@override String get startReading => 'ಓದಲು ಆರಂಭಿಸಿ';
	@override String get exploreStories => 'ನಿಮ್ಮ ಪ್ರಯಾಣವನ್ನು ಆರಂಭಿಸಲು ಕಥೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ';
	@override String get saveForLater => 'ನಿಮಗೆ ಇಷ್ಟವಾದ ಕಥೆಗಳನ್ನು ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡಿ';
	@override String get noActivityYet => 'ಇದಲ್ಲಿಯವರೆಗೆ ಯಾವುದೇ ಚಟುವಟಿಕೆ ಇಲ್ಲ';
	@override String minLeft({required Object count}) => '${count} ನಿಮಿಷಗಳು ಬಾಕಿ';
	@override String get activityHistory => 'ಚಟುವಟಿಕೆಯ ಇತಿಹಾಸ';
	@override String get storyGenerated => 'ಒಂದು ಕಥೆ ರಚಿಸಲಾಗಿದೆ';
	@override String get storyRead => 'ಒಂದು ಕಥೆ ಓದಲಾಗಿದೆ';
	@override String get storyBookmarked => 'ಕಥೆಯನ್ನು ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡಲಾಗಿದೆ';
	@override String get storyShared => 'ಕಥೆಯನ್ನು ಹಂಚಲಾಗಿದೆ';
	@override String get storyCompleted => 'ಕಥೆ ಪೂರ್ಣಗೊಂಡಿದೆ';
	@override String get today => 'ಇಂದು';
	@override String get yesterday => 'ನಿನ್ನೆ';
	@override String get thisWeek => 'ಈ ವಾರ';
	@override String get earlier => 'ಹಿಂದೆ';
	@override String get noContinueReading => 'ಇನ್ನೂ ಓದಲು ಏನೂ ಇಲ್ಲ';
	@override String get noSavedStories => 'ಇನ್ನೂ ಯಾವುದೇ ಉಳಿಸಿದ ಕಥೆಗಳಿಲ್ಲ';
	@override String get bookmarkStoriesToSave => 'ಕಥೆಗಳನ್ನು ಉಳಿಸಲು ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡಿ';
	@override String get myGeneratedStories => 'ನನ್ನ ಕಥೆಗಳು';
	@override String get noGeneratedStoriesYet => 'ಇನ್ನೂ ಯಾವುದೇ ಕಥೆಗಳನ್ನು ರಚಿಸಲಾಗಿಲ್ಲ';
	@override String get createYourFirstStory => 'AI ಬಳಸಿ ನಿಮ್ಮ ಮೊದಲ ಕಥೆಯನ್ನು ರಚಿಸಿ';
	@override String get shareToFeed => 'ಫೀಡ್‌ನಲ್ಲಿ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get sharedToFeed => 'ಕಥೆಯನ್ನು ಫೀಡ್‌ನಲ್ಲಿ ಹಂಚಲಾಗಿದೆ';
	@override String get shareStoryTitle => 'ಕಥೆಯನ್ನು ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareStoryMessage => 'ನಿಮ್ಮ ಕಥೆಗೆ ಶೀರ್ಷಿಕೆ/ಕ್ಯಾಪ್ಷನ್ ಸೇರಿಸಿ (ಐಚ್ಛಿಕ)';
	@override String get shareStoryCaption => 'ಕ್ಯಾಪ್ಷನ್';
	@override String get shareStoryHint => 'ಈ ಕಥೆ ಬಗ್ಗೆ ನೀವು ಏನು ಹೇಳಲು ಬಯಸುತ್ತೀರಾ?';
	@override String get exploreHeritageTitle => 'ಪಾರಂಪರ್ಯ ಅನ್ವೇಷಣೆ';
	@override String get exploreHeritageDesc => 'ನಕ್ಷೆಯಲ್ಲಿ ಸಾಂಸ್ಕೃತಿಕ ಪರಂಪರೆ ಸ್ಥಳಗಳನ್ನು ಹುಡುಕಿ';
	@override String get whereToVisit => 'ಮುಂದಿನ ಭೇಟಿ';
	@override String get scriptures => 'ಶಾಸ್ತ್ರಗಳು';
	@override String get exploreSacredSites => 'ಪವಿತ್ರ ಸ್ಥಳಗಳನ್ನು ಅನ್ವೇಷಿಸಿ';
	@override String get readStories => 'ಕಥೆಗಳನ್ನು ಓದಿ';
	@override String get yesRemindMe => 'ಹೌದು, ನನಗೆ ನೆನಪಿಸಿ';
	@override String get noDontShowAgain => 'ಇಲ್ಲ, ಮತ್ತೆ ತೋರಿಸಬೇಡ';
	@override String get discoverDismissTitle => 'Discover MyItihas ಮರೆಮಾಡಬೇಕೆ?';
	@override String get discoverDismissMessage => 'ಮುಂದಿನ ಬಾರಿ ಆಪ್ ತೆರೆಯುವಾಗ ಅಥವಾ ಲಾಗಿನ್ ಮಾಡುವಾಗ ಇದನ್ನು ಮತ್ತೆ ನೋಡಲು ಬಯಸುವಿರಾ?';
	@override String get discoverCardTitle => 'MyItihas ಅನ್ನು ಅನ್ವೇಷಿಸಿ';
	@override String get discoverCardSubtitle => 'ಪ್ರಾಚೀನ ಶಾಸ್ತ್ರಗಳಲ್ಲಿ നിന്ന ಕಥೆಗಳು, ಅನ್ವೇಷಿಸಲು ಪವಿತ್ರ ಸ್ಥಳಗಳು, ನಿಮ್ಮ ಬೆರಳ ತುದಿಯಲ್ಲಿ ಜ್ಞಾನ.';
	@override String get swipeToDismiss => 'ಮುಚ್ಚಲು ಮೇಲಕ್ಕೆ ಸ್ವೈಪ್ ಮಾಡಿ';
	@override String get searchScriptures => 'ಶಾಸ್ತ್ರಗಳನ್ನು ಹುಡುಕಿ...';
	@override String get searchLanguages => 'ಭಾಷೆಗಳನ್ನು ಹುಡುಕಿ...';
	@override String get exploreStoriesLabel => 'ಕಥೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ';
	@override String get exploreMore => 'ಇನ್ನಷ್ಟು ಅನ್ವೇಷಿಸಿ';
	@override String get failedToLoadActivity => 'ಚಟುವಟಿಕೆ ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';
	@override String get startReadingOrGenerating => 'ಇಲ್ಲಿ ನಿಮ್ಮ ಚಟುವಟಿಕೆಯನ್ನು ನೋಡಲು ಕಥೆಗಳನ್ನು ಓದಲು ಅಥವಾ ರಚಿಸಲು ಪ್ರಾರಂಭಿಸಿ';
	@override late final _TranslationsHomeScreenHeroKn hero = _TranslationsHomeScreenHeroKn._(_root);
}

// Path: stories
class _TranslationsStoriesKn extends TranslationsStoriesEn {
	_TranslationsStoriesKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ಕಥೆಗಳು';
	@override String get searchHint => 'ಶೀರ್ಷಿಕೆ ಅಥವಾ ಲೇಖಕನ ಮೂಲಕ ಹುಡುಕಿ...';
	@override String get sortBy => 'ವಿಂಗಡಿಸಿ';
	@override String get sortNewest => 'ಹೊಸದನ್ನು ಮೊದಲು';
	@override String get sortOldest => 'ಹಳೆಯದನ್ನು ಮೊದಲು';
	@override String get sortPopular => 'ಅತ್ಯಂತ ಜನಪ್ರಿಯ';
	@override String get noStories => 'ಯಾವುದೇ ಕಥೆಗಳು ಕಂಡುಬರಲಿಲ್ಲ';
	@override String get loadingStories => 'ಕಥೆಗಳು ಲೋಡ್ ಆಗುತ್ತಿವೆ...';
	@override String get errorLoadingStories => 'ಕಥೆಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';
	@override String get storyDetails => 'ಕಥೆಯ ವಿವರಗಳು';
	@override String get continueReading => 'ಓದು ಮುಂದುವರಿಸಿ';
	@override String get readMore => 'ಮುಂದೆ ಓದಿ';
	@override String get readLess => 'ಕಡಿಮೆ ತೋರಿಸಿ';
	@override String get author => 'ಲೇಖಕ';
	@override String get publishedOn => 'ಪ್ರಕಟಿತ ದಿನಾಂಕ';
	@override String get category => 'ವರ್ಗ';
	@override String get tags => 'ಟ್ಯಾಗ್‌ಗಳು';
	@override String get failedToLoad => 'ಕಥೆಯನ್ನು ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';
	@override String get subtitle => 'ಶಾಸ್ತ್ರಗಳ ಕಥೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ';
	@override String get noStoriesHint => 'ಬೇರೆ ಹುಡುಕಾಟ ಅಥವಾ ಫಿಲ್ಟರ್ ಪ್ರಯತ್ನಿಸಿ ಕಥೆಗಳನ್ನು ಕಂಡುಹಿಡಿಯಿರಿ.';
	@override String get featured => 'ವಿಶೇಷ';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorKn extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ಕಥೆ ಹೊರತುಗಾರ';
	@override String get subtitle => 'ನಿಮ್ಮದೇ ಶಾಸ್ತ್ರೀಯ ಕಥೆಯನ್ನು ರಚಿಸಿ';
	@override String get quickStart => 'ಶೀಘ್ರ ಆರಂಭ';
	@override String get interactive => 'ಸಂವಾದಾತ್ಮಕ';
	@override String get rawPrompt => 'ಮೂಲ ಪ್ರಾಂಪ್ಟ್';
	@override String get yourStoryPrompt => 'ನಿಮ್ಮ ಕಥೆಯ ಪ್ರಾಂಪ್ಟ್';
	@override String get writeYourPrompt => 'ನಿಮ್ಮ ಪ್ರಾಂಪ್ಟ್ ಬರೆಯಿರಿ';
	@override String get selectScripture => 'ಶಾಸ್ತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ';
	@override String get selectStoryType => 'ಕಥೆಯ ಪ್ರಕಾರವನ್ನು ಆರಿಸಿ';
	@override String get selectCharacter => 'ಪಾತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ';
	@override String get selectTheme => 'ಥೀಮ್ ಆಯ್ಕೆಮಾಡಿ';
	@override String get selectSetting => 'ಸ್ಥಳ / ವಾತಾವರಣ ಆಯ್ಕೆಮಾಡಿ';
	@override String get selectLanguage => 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';
	@override String get selectLength => 'ಕಥೆಯ ಉದ್ದ';
	@override String get moreOptions => 'ಹೆಚ್ಚು ಆಯ್ಕೆಗಳು';
	@override String get random => 'ಯಾದೃಚ್ಛಿಕ';
	@override String get generate => 'ಕಥೆ ರಚಿಸಿ';
	@override String get generating => 'ನಿಮ್ಮ ಕಥೆ ರಚಿಸಲಾಗುತ್ತಿದೆ...';
	@override String get creatingYourStory => 'ನಿಮ್ಮ ಕಥೆ ರಚಿಸಲಾಗುತ್ತಿದೆ';
	@override String get consultingScriptures => 'ಪ್ರಾಚೀನ ಶಾಸ್ತ್ರಗಳೊಂದಿಗೆ ಪರಾಮರ್ಶಿಸಲಾಗುತ್ತಿದೆ...';
	@override String get weavingTale => 'ನಿಮ್ಮ ಕಥೆಯನ್ನು ನೇಯಲಾಗುತ್ತಿದೆ...';
	@override String get addingWisdom => 'ದೈವಿಕ ಜ್ಞಾನವನ್ನು ಸೇರಿಸಲಾಗುತ್ತಿದೆ...';
	@override String get polishingNarrative => 'ಕಥಾನಕವನ್ನು ಮತ್ತಷ್ಟು ಸುಂದರಗೊಳಿಸುತ್ತಿದೆ...';
	@override String get almostThere => 'ಬಹುತೇಕ ಮುಕ್ತಾಯಕ್ಕೆ ಬಂದಿದ್ದೇವೆ...';
	@override String get generatedStory => 'ನಿಮ್ಮ ರಚಿಸಲಾದ ಕಥೆ';
	@override String get aiGenerated => 'AI ಮೂಲಕ ರಚಿಸಲಾಗಿದೆ';
	@override String get regenerate => 'ಮತ್ತೆ ರಚಿಸಿ';
	@override String get saveStory => 'ಕಥೆಯನ್ನು ಉಳಿಸಿ';
	@override String get shareStory => 'ಕಥೆಯನ್ನು ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get newStory => 'ಹೊಸ ಕಥೆ';
	@override String get saved => 'ಉಳಿಸಲಾಗಿದೆ';
	@override String get storySaved => 'ಕಥೆಯನ್ನು ನಿಮ್ಮ ಲೈಬ್ರರಿಯಲ್ಲಿ ಉಳಿಸಲಾಗಿದೆ';
	@override String get story => 'ಕಥೆ';
	@override String get lesson => 'ಪಾಠ';
	@override String get didYouKnow => 'ನಿಮಗೆ ಗೊತ್ತೇ?';
	@override String get activity => 'ಚಟುವಟಿಕೆ';
	@override String get optionalRefine => 'ಐಚ್ಛಿಕ: ಆಯ್ಕೆಗಳಿಂದ ಇನ್ನಷ್ಟು ಸ್ಪಷ್ಟಪಡಿಸಿ';
	@override String get applyOptions => 'ಆಯ್ಕೆಗಳು ಅನ್ವಯಿಸಿ';
	@override String get language => 'ಭಾಷೆ';
	@override String get storyFormat => 'ಕಥೆಯ ಫಾರ್ಮಾಟ್';
	@override String get requiresInternet => 'ಕಥೆ ರಚಿಸಲು ಇಂಟರ್‌ನೆಟ್ ಅಗತ್ಯವಿದೆ';
	@override String get notAvailableOffline => 'ಕಥೆ ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿ ಲಭ್ಯವಿಲ್ಲ. ನೋಡಲು ಇಂಟರ್‌ನೆಟ್‌ಗೆ ಸಂಪರ್ಕಿಸಿ.';
	@override String get aiDisclaimer => 'AI ಕೆಲವೊಮ್ಮೆ ತಪ್ಪು ಮಾಡಬಹುದು. ನಾವು ನಿರಂತರವಾಗಿ ಸುಧಾರಿಸುತ್ತಿದ್ದೇವೆ; ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆ ನಮ್ಮಿಗೆ ಬಹಳ ಮುಖ್ಯ.';
	@override late final _TranslationsStoryGeneratorStoryLengthKn storyLength = _TranslationsStoryGeneratorStoryLengthKn._(_root);
	@override late final _TranslationsStoryGeneratorFormatKn format = _TranslationsStoryGeneratorFormatKn._(_root);
	@override late final _TranslationsStoryGeneratorHintsKn hints = _TranslationsStoryGeneratorHintsKn._(_root);
	@override late final _TranslationsStoryGeneratorErrorsKn errors = _TranslationsStoryGeneratorErrorsKn._(_root);
}

// Path: chat
class _TranslationsChatKn extends TranslationsChatEn {
	_TranslationsChatKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'ಶಾಸ್ತ್ರಗಳ ಬಗ್ಗೆ AI ಜೊತೆಗೆ ಚಾಟ್ ಮಾಡಿ';
	@override String get friendMode => 'ಸ್ನೇಹಿತ ಮೋಡ್';
	@override String get philosophicalMode => 'ತಾತ್ವಿಕ ಮೋಡ್';
	@override String get typeMessage => 'ನಿಮ್ಮ ಸಂದೇಶವನ್ನು ಟೈಪ್ ಮಾಡಿ...';
	@override String get send => 'ಕಳುಹಿಸಿ';
	@override String get newChat => 'ಹೊಸ ಚಾಟ್';
	@override String get chatsTab => 'ಚಾಟ್';
	@override String get groupsTab => 'ಗುಂಪುಗಳು';
	@override String get chatHistory => 'ಚಾಟ್ ಇತಿಹಾಸ';
	@override String get clearChat => 'ಚಾಟ್ ಕ್ಲೀರ್ ಮಾಡಿ';
	@override String get noMessages => 'ಇನ್ನೂ ಯಾವುದೇ ಸಂದೇಶಗಳಿಲ್ಲ. ಒಂದು ಸಂಭಾಷಣೆಯನ್ನು ಆರಂಭಿಸಿ!';
	@override String get listPage => 'ಚಾಟ್ ಪಟ್ಟಿ ಪುಟ';
	@override String get forwardMessageTo => 'ಸಂದೇಶವನ್ನು ಮುಂದೆ ಕಳುಹಿಸಿ...';
	@override String get forwardMessage => 'ಸಂದೇಶ ಫಾರ್ವರ್ಡ್ ಮಾಡಿ';
	@override String get messageForwarded => 'ಸಂದೇಶ ಫಾರ್ವರ್ಡ್ ಮಾಡಲಾಗಿದೆ';
	@override String failedToForward({required Object error}) => 'ಸಂದೇಶ ಫಾರ್ವರ್ಡ್ ಮಾಡಲು ವಿಫಲ: ${error}';
	@override String get searchChats => 'ಚಾಟ್‌ಗಳನ್ನು ಹುಡುಕಿ';
	@override String get noChatsFound => 'ಯಾವ ಚಾಟ್ ಕಂಡುಬಂದಿಲ್ಲ';
	@override String get requests => 'ವಿನಂತಿಗಳು';
	@override String get messageRequests => 'ಸಂದೇಶ ವಿನಂತಿಗಳು';
	@override String get groupRequests => 'ಗುಂಪು ವಿನಂತಿಗಳು';
	@override String get requestSent => 'ವಿನಂತಿಯನ್ನು ಕಳುಹಿಸಲಾಗಿದೆ. ಅವರು ಅದನ್ನು "Requests" ನಲ್ಲಿ ನೋಡಿ.';
	@override String get wantsToChat => 'ಚಾಟ್ ಮಾಡಲು ಬಯಸುತ್ತಾರೆ';
	@override String addedYouTo({required Object name}) => '${name} ನಿಮಗೆ ಗುಂಪಿನಲ್ಲಿ ಸೇರಿಸಿದ್ದಾರೆ';
	@override String get accept => 'ಸ್ವೀಕರಿಸಿ';
	@override String get noMessageRequests => 'ಯಾವುದೇ ಸಂದೇಶ ವಿನಂತಿಗಳಿಲ್ಲ';
	@override String get noGroupRequests => 'ಯಾವುದೇ ಗುಂಪು ವಿನಂತಿಗಳಿಲ್ಲ';
	@override String get invitesSent => 'ಆಹ್ವಾನಗಳನ್ನು ಕಳುಹಿಸಲಾಗಿದೆ. ಅವರು ಅದನ್ನು "Requests" ನಲ್ಲಿ ನೋಡಿ.';
	@override String get cantMessageUser => 'ಈ ಬಳಕೆದಾರರಿಗೆ ನೀವು ಸಂದೇಶ ಕಳುಹಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ';
	@override String get deleteChat => 'ಚಾಟ್ ಅಳಿಸಿ';
	@override String get deleteChats => 'ಚಾಟ್‌ಗಳನ್ನು ಅಳಿಸಿ';
	@override String get blockUser => 'ಬಳಕೆದಾರರನ್ನು ಬ್ಲಾಕ್ ಮಾಡಿ';
	@override String get reportUser => 'ಬಳಕೆದಾರರನ್ನು ವರದಿ ಮಾಡಿ';
	@override String get markAsRead => 'ಓದಲಾಗಿದೆ ಎಂದು ಗುರುತಿಸಿ';
	@override String get markedAsRead => 'ಓದಲಾಗಿದೆ ಎಂದು ಗುರುತಿಸಲಾಗಿದೆ';
	@override String get deleteClearChat => 'ಚಾಟ್ ಅಳಿಸಿ / ಕ್ಲೀರ್ ಮಾಡಿ';
	@override String get deleteConversation => 'ಸಂಭಾಷಣೆಯನ್ನು ಅಳಿಸಿ';
	@override String get reasonRequired => 'ಕಾರಣ (ಅಗತ್ಯ)';
	@override String get submit => 'ಸಲ್ಲಿಸಿ';
	@override String get userReportedBlocked => 'ಬಳಕೆದಾರರನ್ನು ವರದಿ ಮಾಡಲಾಗಿದೆ ಮತ್ತು ಬ್ಲಾಕ್ ಮಾಡಲಾಗಿದೆ.';
	@override String reportFailed({required Object error}) => 'ವರದಿ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ: ${error}';
	@override String get newGroup => 'ಹೊಸ ಗುಂಪು';
	@override String get messageSomeoneDirectly => 'ಯಾರಿಗಾದರೂ ನೇರವಾಗಿ ಸಂದೇಶ ಕಳುಹಿಸಿ';
	@override String get createGroupConversation => 'ಗುಂಪು ಸಂಭಾಷಣೆ ರಚಿಸಿ';
	@override String get noGroupsYet => 'ಇನ್ನೂ ಯಾವ ಗುಂಪುಗಳೂ ಇಲ್ಲ';
	@override String get noChatsYet => 'ಇನ್ನೂ ಯಾವುದೇ ಚಾಟ್ ಇಲ್ಲ';
	@override String get tapToCreateGroup => 'ಗುಂಪನ್ನು ರಚಿಸಲು ಅಥವಾ ಸೇರಲು + ಒತ್ತಿರಿ';
	@override String get tapToStartConversation => 'ಹೊಸ ಸಂಭಾಷಣೆಯನ್ನು ಪ್ರಾರಂಭಿಸಲು + ಒತ್ತಿರಿ';
	@override String get conversationDeleted => 'ಸಂಭಾಷಣೆ ಅಳಿಸಲಾಗಿದೆ';
	@override String conversationsDeleted({required Object count}) => '${count} ಸಂಭಾಷಣೆ(ಗಳು) ಅಳಿಸಲಾಗಿದೆ';
	@override String get searchConversations => 'ಸಂಭಾಷಣೆಗಳನ್ನು ಹುಡುಕಿ...';
	@override String get connectToInternet => 'ದಯವಿಟ್ಟು ಇಂಟರ್ನೆಟ್‌ಗೆ ಸಂಪರ್ಕಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
	@override String get littleKrishnaName => 'ಚಿಕ್ಕ ಕೃಷ್ಣ';
	@override String get newConversation => 'ಹೊಸ ಸಂಭಾಷಣೆ';
	@override String get noConversationsYet => 'ಇನ್ನೂ ಯಾವುದೇ ಸಂಭಾಷಣೆಗಳಿಲ್ಲ';
	@override String get confirmDeletion => 'ಅಳಿಸುವುದನ್ನು ದೃಢೀಕರಿಸಿ';
	@override String deleteConversationConfirm({required Object title}) => 'ನೀವು ಖಚಿತವಾಗಿ ${title} ಸಂಭಾಷಣೆಯನ್ನು ಅಳಿಸಲು ಬಯಸುವಿರಾ?';
	@override String get deleteFailed => 'ಸಂಭಾಷಣೆ ಅಳಿಸಲು ವಿಫಲವಾಗಿದೆ';
	@override String get fullChatCopied => 'ಪೂರ್ಣ ಚಾಟ್ ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ನಕಲಿಸಲಾಗಿದೆ!';
	@override String get connectionErrorFallback => 'ಈಗ ಸಂಪರ್ಕ ಸಾಧಿಸಲು ಸಮಸ್ಯೆ ಕಾಣಿಸುತ್ತಿದೆ. ದಯವಿಟ್ಟು ಕೆಲವು ಹೊತ್ತಿನ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
	@override String krishnaWelcomeWithName({required Object name}) => 'ಹೇ ${name}. ನಾನು ನಿಮ್ಮ ಸ್ನೇಹಿತ ಕೃಷ್ಣ. ಇಂದು ಹೇಗಿದ್ದೀರಿ?';
	@override String get krishnaWelcomeFriend => 'ಹೇ ಪ್ರಿಯ ಸ್ನೇಹಿತನೇ. ನಾನು ನಿಮ್ಮ ಸ್ನೇಹಿತ ಕೃಷ್ಣ. ಇಂದು ಹೇಗಿದ್ದೀರಿ?';
	@override String get copyYouLabel => 'ನೀವು';
	@override String get copyKrishnaLabel => 'ಕೃಷ್ಣ';
	@override late final _TranslationsChatSuggestionsKn suggestions = _TranslationsChatSuggestionsKn._(_root);
	@override String get about => 'ಬಗ್ಗೆ';
	@override String get yourFriendlyCompanion => 'ನಿಮ್ಮ ಸ್ನೇಹಸಮ್ಮಿತ ಸಂಗಾತಿ';
	@override String get mentalHealthSupport => 'ಮಾನಸಿಕ ಆರೋಗ್ಯ ಬೆಂಬಲ';
	@override String get mentalHealthSupportSubtitle => 'ನಿಮ್ಮ ಚിന്തನೆಗಳನ್ನು പങ്കುಹಾಕാനും ಕೇಳಿಸಿಕೊಂಡതായി ಅನುಭವിക്കാനും സുരക്ഷിതವಾದ ಸ್ಥಳ.';
	@override String get friendlyCompanion => 'ಸ್ನೇಹಸಮ್ಮಿತ ಸಂಗಾತಿ';
	@override String get friendlyCompanionSubtitle => 'ಮಾತನಾಡಲು, ಉತ್ತೇಜಿಸಲು, ಜ್ಞಾನವನ್ನು ಹಂಚಿಕೊಳ್ಳಲು ಯಾವಾಗಲೂ ಸಿದ್ಧನಾಗಿರುವನು.';
	@override String get storiesAndWisdom => 'ಕಥೆಗಳು ಮತ್ತು ಜ್ಞಾನ';
	@override String get storiesAndWisdomSubtitle => 'ಶಾಶ್ವತ ಕಥೆಗಳಿಂದ ಮತ್ತು ಪ್ರಾಯೋಗಿಕ ಜ್ಞಾನದಿಂದ ಕಲಿಯಿರಿ.';
	@override String get askAnything => 'ಏನನ್ನಾದರೂ ಕೇಳಿ';
	@override String get askAnythingSubtitle => 'ನಿಮ್ಮ ಪ್ರಶ್ನೆಗಳಿಗೆ ಮೃದು, ಚಿಂತನಶೀಲ ಉತ್ತರಗಳನ್ನು ಪಡೆಯಿರಿ.';
	@override String get startChatting => 'ಚಾಟ್ ಮಾಡಲು ಪ್ರಾರಂಭಿಸಿ';
	@override String get maybeLater => 'ಬಹುಷಃ ನಂತರ';
	@override late final _TranslationsChatComposerAttachmentsKn composerAttachments = _TranslationsChatComposerAttachmentsKn._(_root);
}

// Path: map
class _TranslationsMapKn extends TranslationsMapEn {
	_TranslationsMapKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ಅಖಂಡ ಭಾರತ';
	@override String get subtitle => 'ಐತಿಹಾಸಿಕ ಸ್ಥಳಗಳನ್ನು ಅನ್ವেষಿಸಿ';
	@override String get searchLocation => 'ಸ್ಥಳವನ್ನು ಹುಡುಕಿ...';
	@override String get viewDetails => 'ವಿವರಗಳನ್ನು ನೋಡಿ';
	@override String get viewSites => 'ಸ್ಥಳಗಳನ್ನು ನೋಡಿ';
	@override String get showRoute => 'ಮಾರ್ಗವನ್ನು ತೋರಿಸಿ';
	@override String get historicalInfo => 'ಐತಿಹಾಸಿಕ ಮಾಹಿತಿ';
	@override String get nearbyPlaces => 'ಸಮೀಪದ ಸ್ಥಳಗಳು';
	@override String get pickLocationOnMap => 'ನಕ್ಷೆಯಲ್ಲಿ ಸ್ಥಳ ಆಯ್ಕೆಮಾಡಿ';
	@override String get sitesVisited => 'ಭೇಟಿ ನೀಡಿದ ಸ್ಥಳಗಳು';
	@override String get badgesEarned => 'ಪಡೆಯಲಾದ ಬ್ಯಾಡ್ಜ್‌ಗಳು';
	@override String get completionRate => 'ಪೂರ್ಣಗೊಳ್ಳುವ ಪ್ರಮಾಣ';
	@override String get addToJourney => 'ಪ್ರಯಾಣಕ್ಕೆ ಸೇರಿಸಿ';
	@override String get addedToJourney => 'ಪ್ರಯಾಣಕ್ಕೆ ಸೇರಿಸಲಾಗಿದೆ';
	@override String get getDirections => 'ದಿಕ್ಕುಗಳನ್ನು ಪಡೆಯಿರಿ';
	@override String get viewInMap => 'ನಕ್ಷೆಯಲ್ಲಿ ನೋಡಿ';
	@override String get directions => 'ದಾರಿಗಳು';
	@override String get photoGallery => 'ಫೋಟೋ ಗ್ಯಾಲರಿ';
	@override String get viewAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';
	@override String get photoSavedToGallery => 'ಫೋಟೋ ಗ್ಯಾಲರಿಯಲ್ಲಿ ಉಳಿಸಲಾಗಿದೆ';
	@override String get sacredSoundscape => 'ಪವಿತ್ರ ಧ್ವನಿವಿಶ್ವ';
	@override String get allDiscussions => 'ಎಲ್ಲಾ ಚರ್ಚೆಗಳು';
	@override String get journeyTab => 'ಪ್ರಯಾಣ';
	@override String get discussionTab => 'ಚರ್ಚೆ';
	@override String get myActivity => 'ನನ್ನ ಚಟುವಟಿಕೆ';
	@override String get anonymousPilgrim => 'ಅಪರಿಚಿತ ಯಾತ್ರಿಕ';
	@override String get viewProfile => 'ಪ್ರೊಫೈಲ್ ನೋಡಿ';
	@override String get discussionTitleHint => 'ಚರ್ಚೆಯ ಶೀರ್ಷಿಕೆ...';
	@override String get shareYourThoughtsHint => 'ನಿಮ್ಮ ಚಿಂತೆಗಳು ಹಂಚಿಕೊಳ್ಳಿ...';
	@override String get pleaseEnterDiscussionTitle => 'ದಯವಿಟ್ಟು ಚರ್ಚೆಯ ಶೀರ್ಷಿಕೆಯನ್ನು ನಮೂದಿಸಿ';
	@override String get addReflection => 'ಅನ್ವೇಷಣೆ/ಅನുഭവ ಸೇರಿಸಿ';
	@override String get reflectionTitle => 'ಶೀರ್ಷಿಕೆ';
	@override String get enterReflectionTitle => 'ಅನ್ವೇಷಣೆ/ಅನുഭവದ ಶೀರ್ಷಿಕೆ ನೀಡಿ';
	@override String get pleaseEnterTitle => 'ദಯവಿಟ್ಟು ಶೀರ್ಷಿಕೆ ನಮೂದಿಸಿ';
	@override String get siteName => 'ಸ್ಥಳದ ಹೆಸರು';
	@override String get enterSacredSiteName => 'ಪವಿತ್ರ ಸ್ಥಳದ ಹೆಸರು ನಮೂದಿಸಿ';
	@override String get pleaseEnterSiteName => 'ದಯವಿಟ್ಟು ಸ್ಥಳದ ಹೆಸರನ್ನೂ ನಮೂದಿಸಿ';
	@override String get reflection => 'ಅನ್ವೇಷಣೆ/ಅനുഭവ';
	@override String get reflectionHint => 'ನಿಮ್ಮ ಅನುಭವങ്ങളും ചിന്തೆಗಳನ್ನೂ ಹಂಚಿಕೊಳ್ಳಿ...';
	@override String get pleaseEnterReflection => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಅನುಭವವನ್ನು ನಮೂದಿಸಿ';
	@override String get saveReflection => 'അനുഭവം ಉಳಿಸಿ';
	@override String get journeyProgress => 'ಯಾತ್ರೆಯ ಪ್ರಗತಿ';
	@override late final _TranslationsMapDiscussionsKn discussions = _TranslationsMapDiscussionsKn._(_root);
	@override late final _TranslationsMapFabricMapKn fabricMap = _TranslationsMapFabricMapKn._(_root);
	@override late final _TranslationsMapClassicalArtMapKn classicalArtMap = _TranslationsMapClassicalArtMapKn._(_root);
	@override late final _TranslationsMapClassicalDanceMapKn classicalDanceMap = _TranslationsMapClassicalDanceMapKn._(_root);
	@override late final _TranslationsMapFoodMapKn foodMap = _TranslationsMapFoodMapKn._(_root);
}

// Path: community
class _TranslationsCommunityKn extends TranslationsCommunityEn {
	_TranslationsCommunityKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ಸಮುದಾಯ';
	@override String get trending => 'ಟ್ರೆಂಡಿಂಗ್';
	@override String get following => 'ಅನುಸರಿಸುತ್ತಿರುವವರು';
	@override String get followers => 'ಅನುಯಾಯಿಗಳು';
	@override String get posts => 'ಪೊಸ್ಟ್‌ಗಳು';
	@override String get follow => 'ಅನುಸರಿಸಿ';
	@override String get unfollow => 'ಅನುಸರಿಸುವುದನ್ನು ನಿಲ್ಲಿಸಿ';
	@override String get shareYourStory => 'ನಿಮ್ಮ ಕಥೆಯನ್ನು ಹಂಚಿಕೊಳ್ಳಿ...';
	@override String get post => 'ಪೋಸ್ಟ್ ಮಾಡಿ';
	@override String get like => 'ಇಷ್ಟವಾಯಿತು';
	@override String get comment => 'ಕಾಮೆಂಟ್';
	@override String get comments => 'ಕಾಮೆಂಟ್‌ಗಳು';
	@override String get noPostsYet => 'ಇನ್ನೂ ಯಾವುದೇ ಪೋಸ್ಟ್‌ಗಳಿಲ್ಲ';
}

// Path: discover
class _TranslationsDiscoverKn extends TranslationsDiscoverEn {
	_TranslationsDiscoverKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ಹುಡುಕಿ';
	@override String get searchHint => 'ಕಥೆಗಳು, ಬಳಕೆದಾರರು, ವಿಷಯಗಳು ಮುಂತಾದವುಗಳನ್ನು ಹುಡುಕಿ...';
	@override String get tryAgain => 'ಮತ್ತೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ';
	@override String get somethingWentWrong => 'ಏನೋ ತಪ್ಪಾಗಿದೆ';
	@override String get unableToLoadProfiles => 'ಪ್ರೊಫೈಲ್‌ಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
	@override String get noProfilesFound => 'ಯಾವುದೇ ಪ್ರೊಫೈಲ್‌ಗಳು ಕಂಡುಬರಲಿಲ್ಲ';
	@override String get searchToFindPeople => 'ಅನುಸರಿಸಲು ಜನರನ್ನು ಹುಡುಕಿ';
	@override String get noResultsFound => 'ಯಾವುದೇ ಫಲಿತಾಂಶಗಳು ಕಂಡುಬರಲಿಲ್ಲ';
	@override String get noProfilesYet => 'ಇನ್ನೂ ಯಾವುದೇ ಪ್ರೊಫೈಲ್‌ಗಳಿಲ್ಲ';
	@override String get tryDifferentKeywords => 'ಬೇರೆ ಕೀವರ್ಡ್‌ಗಳನ್ನು ಬಳಸಿ ಹುಡುಕಿ';
	@override String get beFirstToDiscover => 'ಹೊಸ ಜನರನ್ನು ಕಂಡು ಹಿಡಿಯುವ ಮೊದಲ ವ್ಯಕ್ತಿಯಾಗಿರಿ!';
}

// Path: plan
class _TranslationsPlanKn extends TranslationsPlanEn {
	_TranslationsPlanKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'ನಿಮ್ಮ ಯೋಜನೆಯನ್ನು ಉಳಿಸಲು ಸೈನ್ ಇನ್ ಮಾಡಿ';
	@override String get planSaved => 'ಯೋಜನೆ ಉಳಿಸಲಾಗಿದೆ';
	@override String get from => 'ಎಲ್ಲಿಂದ';
	@override String get dates => 'ದಿನಾಂಕಗಳು';
	@override String get destination => 'ಗಮ್ಯಸ್ಥಾನ';
	@override String get nearby => 'ಸಮೀಪದ';
	@override String get generatedPlan => 'ರಚಿಸಲಾದ ಯೋಜನೆ';
	@override String get whereTravellingFrom => 'ನೀವು ಎಲ್ಲಿಂದ ಪ್ರಯಾಣಿಸುತ್ತಿದ್ದೀರಿ?';
	@override String get enterCityOrRegion => 'ನಿಮ್ಮ ನಗರ ಅಥವಾ ಪ್ರದೇಶವನ್ನು ನಮೂದಿಸಿ';
	@override String get travelDates => 'ಪ್ರಯಾಣ ದಿನಾಂಕಗಳು';
	@override String get destinationSacredSite => 'ಗಮ್ಯಸ್ಥಾನ (ಪವಿತ್ರ ಸ್ಥಳ)';
	@override String get searchOrSelectDestination => 'ಗಮ್ಯಸ್ಥಾನವನ್ನು ಹುಡುಕಿ ಅಥವಾ ಆಯ್ಕೆಮಾಡಿ...';
	@override String get shareYourExperience => 'ನಿಮ್ಮ ಅನುಭವವನ್ನು ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get planShared => 'ಯೋಜನೆ ಹಂಚಲಾಗಿದೆ';
	@override String failedToSharePlan({required Object error}) => 'ಯೋಜನೆ ಹಂಚಲು ವಿಫಲವಾಗಿದೆ: ${error}';
	@override String get planUpdated => 'ಯೋಜನೆ ನವೀಕರಿಸಲಾಗಿದೆ';
	@override String failedToUpdatePlan({required Object error}) => 'ಯೋಜನೆಯನ್ನು ನವೀಕರಿಸಲು ವಿಫಲವಾಗಿದೆ: ${error}';
	@override String get deletePlanConfirm => 'ಯೋಜನೆಯನ್ನು ಅಳಿಸಬೇಕೇ?';
	@override String get thisPlanPermanentlyDeleted => 'ಈ ಯೋಜನೆಯನ್ನು ಶಾಶ್ವತವಾಗಿ ಅಳಿಸಲಾಗುತ್ತದೆ.';
	@override String get planDeleted => 'ಯೋಜನೆ ಅಳಿಸಲಾಗಿದೆ';
	@override String failedToDeletePlan({required Object error}) => 'ಯೋಜನೆಯನ್ನು ಅಳಿಸಲು ವಿಫಲವಾಗಿದೆ: ${error}';
	@override String get sharePlan => 'ಯೋಜನೆ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get deletePlan => 'ಯೋಜನೆಯನ್ನು ಅಳಿಸಿ';
	@override String get savedPlanDetails => 'ಉಳಿಸಿದ ಯೋಜನೆಯ ವಿವರಗಳು';
	@override String get pilgrimagePlan => 'ತೀರ್ಥಯಾತ್ರೆ ಯೋಜನೆ';
	@override String get planTab => 'ಯೋಜನೆ';
}

// Path: settings
class _TranslationsSettingsKn extends TranslationsSettingsEn {
	_TranslationsSettingsKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ಸೆಟ್ಟಿಂಗುಗಳು';
	@override String get language => 'ಭಾಷೆ';
	@override String get theme => 'ಥೀಮ್';
	@override String get themeLight => 'ಲೈಟ್';
	@override String get themeDark => 'ಡಾರ್ಕ್';
	@override String get themeSystem => 'ಸಿಸ್ಟಮ್ ಥೀಮ್ ಬಳಸಿ';
	@override String get darkMode => 'ಡಾರ್ಕ್ ಮೋಡ್';
	@override String get selectLanguage => 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';
	@override String get notifications => 'ಅಧಿಸೂಚನೆಗಳು';
	@override String get cacheSettings => 'ಕ್ಯಾಶೆ ಮತ್ತು ಸಂಗ್ರಹಣೆ';
	@override String get general => 'ಸಾಮಾನ್ಯ';
	@override String get account => 'ಖಾತೆ';
	@override String get blockedUsers => 'ನಿರ್ಬಂಧಿತ ಬಳಕೆದಾರರು';
	@override String get helpSupport => 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ';
	@override String get contactUs => 'ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಿ';
	@override String get legal => 'ಕಾನೂನಾತ್ಮಕ';
	@override String get privacyPolicy => 'ಗೌಪ್ಯತಾ ನೀತಿ';
	@override String get termsConditions => 'ನಿಯಮಗಳು ಮತ್ತು ಷರತ್ತುಗಳು';
	@override String get privacy => 'ಗೌಪ್ಯತೆ';
	@override String get about => 'ಆಪ್ ಕುರಿತು';
	@override String get version => 'ಆವೃತ್ತಿ';
	@override String get logout => 'ಲಾಗ್‌ಔಟ್';
	@override String get deleteAccount => 'ಖಾತೆಯನ್ನು ಅಳಿಸಿ';
	@override String get deleteAccountTitle => 'ಖಾತೆಯನ್ನು ಅಳಿಸಿ';
	@override String get deleteAccountWarning => 'ಈ ಕ್ರಿಯೆಯನ್ನು ಹಿಂತಿರುಗಿಸಲಾಗುವುದಿಲ್ಲ!';
	@override String get deleteAccountDescription => 'ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಅಳಿಸಿದರೆ ನಿಮ್ಮ ಎಲ್ಲಾ ಪೋಸ್ಟ್‌ಗಳು, ಕಾಮೆಂಟ್‌ಗಳು, ಪ್ರೊಫೈಲ್, ಫಾಲೋವರ್ಸ್, ಉಳಿಸಿದ ಕಥೆಗಳು, ಬುಕ್‌ಮಾರ್ಕ್‌ಗಳು, ಚಾಟ್ ಸಂದೇಶಗಳು ಮತ್ತು ಸೃಷ್ಟಿಸಲಾದ ಕಥೆಗಳು ಶಾಶ್ವತವಾಗಿ ಅಳಿಸಲ್ಪಡುತ್ತವೆ.';
	@override String get confirmPassword => 'ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ಅನ್ನು ದೃಢೀಕರಿಸಿ';
	@override String get confirmPasswordDesc => 'ಖಾತೆ ಅಳಿಸುವುದನ್ನು ದೃಢೀಕರಿಸಲು ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ.';
	@override String get googleReauth => 'ನಿಮ್ಮ ಗುರುತನ್ನು ಪರಿಶೀಲಿಸಲು ನಿಮಗೆ Google ಗೆ ದಾರಿ ಮಾಡಿಕೊಡಲಾಗುತ್ತದೆ.';
	@override String get finalConfirmationTitle => 'ಅಂತಿಮ ದೃಢೀಕರಣ';
	@override String get finalConfirmation => 'ನೀವು ಸಂಪೂರ್ಣವಾಗಿ ಖಚಿತವೇ? ಇದು ಶಾಶ್ವತವಾಗಿದೆ ಮತ್ತು ಹಿಂದಕ್ಕೆ ತರುವಂತಿಲ್ಲ.';
	@override String get deleteMyAccount => 'ನನ್ನ ಖಾತೆಯನ್ನು ಅಳಿಸಿ';
	@override String get deletingAccount => 'ಖಾತೆ ಅಳಿಸಲಾಗುತ್ತಿದೆ...';
	@override String get accountDeleted => 'ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಶಾಶ್ವತವಾಗಿ ಅಳಿಸಲಾಗಿದೆ.';
	@override String get deleteAccountFailed => 'ಖಾತೆ ಅಳಿಸಲು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
	@override String get downloadedStories => 'ಡೌನ್‌ಲೋಡ್ ಮಾಡಿದ ಕಥೆಗಳು';
	@override String get couldNotOpenEmail => 'ಇಮೇಲ್ ಆಪ್ ತೆರೆಯാൻ ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ನಮಗೆ myitihas@gmail.com ಗೆ ಇಮೇಲ್ ಮಾಡಿ.';
	@override String couldNotOpenLabel({required Object label}) => 'ಈ ಕ್ಷಣದಲ್ಲಿ ${label} ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';
	@override String get logoutTitle => 'ಲಾಗ್‌ಔಟ್';
	@override String get logoutConfirm => 'ನೀವು ಖಚಿತವಾಗಿ ಲಾಗ್ ಔಟ್ ಮಾಡಲು ಬಯಸುವಿರಾ?';
	@override String get verifyYourIdentity => 'ನಿಮ್ಮ ಗುರುತನ್ನು ದೃಢೀಕರಿಸಿ';
	@override String get verifyYourIdentityDesc => 'ನಿಮ್ಮ ಗುರುತನ್ನು ದೃಢೀಕರಿಸಲು Google ಮೂಲಕ ಸೈನ್ ಇನ್ ಮಾಡಲು ನಿಮ್ಮನ್ನು ಕೇಳಲಾಗುತ್ತದೆ.';
	@override String get continueWithGoogle => 'Google ಮೂಲಕ ಮುಂದುವರಿಸಿ';
	@override String reauthFailed({required Object error}) => 'ಮತ್ತೆ ದೃಢೀಕರಣ ವಿಫಲವಾಗಿದೆ: ${error}';
	@override String get passwordRequired => 'ಪಾಸ್‌ವರ್ಡ್ ಅಗತ್ಯವಿದೆ';
	@override String get invalidPassword => 'ಅಮಾನ್ಯವಾದ ಪಾಸ್‌ವರ್ಡ್. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
	@override String get verify => 'ದೃಢೀಕರಿಸಿ';
	@override String get continueLabel => 'ಮುಂದುವರಿಸಿ';
	@override String get unableToVerifyIdentity => 'ಗುರುತನ್ನು ದೃಢೀಕರಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
}

// Path: auth
class _TranslationsAuthKn extends TranslationsAuthEn {
	_TranslationsAuthKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get login => 'ಲಾಗಿನ್';
	@override String get signup => 'ಸೈನ್ ಅಪ್';
	@override String get email => 'ಇಮೇಲ್';
	@override String get password => 'ಪಾಸ್‌ವರ್ಡ್';
	@override String get confirmPassword => 'ಪಾಸ್‌ವರ್ಡ್ ದೃಢೀಕರಿಸಿ';
	@override String get forgotPassword => 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರಾ?';
	@override String get resetPassword => 'ಪಾಸ್‌ವರ್ಡ್ ಮರುಹೊಂದಿಸಿ';
	@override String get dontHaveAccount => 'ಖಾತೆ ಇಲ್ಲವೇ?';
	@override String get alreadyHaveAccount => 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ?';
	@override String get loginSuccess => 'ಲಾಗಿನ್ ಯಶಸ್ವಿಯಾಯಿತು';
	@override String get signupSuccess => 'ಸೈನ್ ಅಪ್ ಯಶಸ್ವಿಯಾಯಿತು';
	@override String get loginError => 'ಲಾಗಿನ್ ವಿಫಲವಾಗಿದೆ';
	@override String get signupError => 'ಸೈನ್ ಅಪ್ ವಿಫಲವಾಗಿದೆ';
}

// Path: error
class _TranslationsErrorKn extends TranslationsErrorEn {
	_TranslationsErrorKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get network => 'ಇಂಟರ್‌ನೆಟ್ ಸಂಪರ್ಕ ಇಲ್ಲ';
	@override String get server => 'ಸರ್ವರ್ ದೋಷ ಉಂಟಾಗಿದೆ';
	@override String get cache => 'ಕ್ಯಾಶೆ ಡೇಟಾವನ್ನು ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';
	@override String get timeout => 'ವಿನಂತಿಯ ಸಮಯ ಮೀರಿದೆ';
	@override String get notFound => 'ಸಂಪನ್ಮೂಲ ಕಂಡುಬಂದಿಲ್ಲ';
	@override String get validation => 'ಚೆಕ್ಸ್ ವಿಫಲವಾಗಿದೆ';
	@override String get unexpected => 'ಅಪೇಕ್ಷಿಸದ ದೋಷ ಸಂಭವಿಸಿದೆ';
	@override String get tryAgain => 'ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';
	@override String couldNotOpenLink({required Object url}) => 'ಲಿಂಕ್ ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionKn extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get free => 'ಉಚಿತ';
	@override String get plus => 'ಪ್ಲಸ್';
	@override String get pro => 'ಪ್ರೋ';
	@override String get upgradeToPro => 'ಪ್ರೋಗೆ ಅಪ್‌ಗ್ರೇಡ್ ಮಾಡಿ';
	@override String get features => 'ವೈಶಿಷ್ಟ್ಯಗಳು';
	@override String get subscribe => 'ಚಂದಾದಾರರಾಗಿ';
	@override String get currentPlan => 'ಪ್ರಸ್ತುತ ಯೋಜನೆ';
	@override String get managePlan => 'ಯೋಜನೆಯನ್ನು ನಿರ್ವಹಿಸಿ';
}

// Path: notification
class _TranslationsNotificationKn extends TranslationsNotificationEn {
	_TranslationsNotificationKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ಅಧಿಸೂಚನೆಗಳು';
	@override String get peopleToConnect => 'ಸಂಪರ್ಕಿಸಲು ಜನರು';
	@override String get peopleToConnectSubtitle => 'ಅನುಸರಿಸಲು ಜನರನ್ನು ಕಂಡುಹಿಡಿಯಿರಿ';
	@override String followAgainInMinutes({required Object minutes}) => 'ನೀವು ${minutes} ನಿಮಿಷಗಳಲ್ಲಿ ಮತ್ತೆ ಫಾಲೋ ಮಾಡಬಹುದು';
	@override String get noSuggestions => 'ಈ ಕ್ಷಣದಲ್ಲಿ ಯಾವುದೇ ಸಲಹೆಗಳಿಲ್ಲ';
	@override String get markAllRead => 'ಎಲ್ಲವನ್ನೂ ಓದಲಾಗಿದೆ ಎಂದು ಗುರುತಿಸಿ';
	@override String get noNotifications => 'ಇನ್ನೂ ಯಾವುದೇ ಅಧಿಸೂಚನೆಗಳಿಲ್ಲ';
	@override String get noNotificationsSubtitle => 'ಯಾರಾದರೂ ನಿಮ್ಮ ಕಥೆಗಳೊಂದಿಗೆ ಸಂಪರ್ಕಿಸಿದಾಗ, ನೀವು ಅದನ್ನು ಇಲ್ಲಿ ನೋಡಬಹುದು';
	@override String get errorPrefix => 'ದೋಷ:';
	@override String get retry => 'ಮತ್ತೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ';
	@override String likedYourStory({required Object actorName}) => '${actorName} ಅವರು ನಿಮ್ಮ ಕಥೆಯನ್ನು ಇಷ್ಟಪಟ್ಟಿದ್ದಾರೆ';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} ಅವರು ನಿಮ್ಮ ಕಥೆಯ ಮೇಲೆ ಕಾಮೆಂಟ್ ಮಾಡಿದ್ದಾರೆ';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} ಅವರು ನಿಮ್ಮ ಕಾಮೆಂಟ್‌ಗೆ ಉತ್ತರಿಸಿದ್ದಾರೆ';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} ಅವರು ನಿಮ್ಮನ್ನು ಫಾಲೋ ಮಾಡಲು ಪ್ರಾರಂಭಿಸಿದ್ದಾರೆ';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} ಅವರು ನಿಮಗೆ ಒಂದು ಸಂದೇಶ ಕಳುಹಿಸಿದ್ದಾರೆ';
	@override String sharedYourStory({required Object actorName}) => '${actorName} ಅವರು ನಿಮ್ಮ ಕಥೆಯನ್ನು ಹಂಚಿದ್ದಾರೆ';
	@override String repostedYourStory({required Object actorName}) => '${actorName} ಅವರು ನಿಮ್ಮ ಕಥೆಯನ್ನು ಮರುಪೋಸ್ಟ್ ಮಾಡಿದ್ದಾರೆ';
	@override String mentionedYou({required Object actorName}) => '${actorName} ಅವರು ನಿಮಗೆ ಉಲ್ಲೇಖ ಮಾಡಿದ್ದಾರೆ';
	@override String newPostFrom({required Object actorName}) => '${actorName} ಅವರಿಂದ ಹೊಸ ಪೋಸ್ಟ್';
	@override String get today => 'ಇಂದು';
	@override String get thisWeek => 'ಈ ವಾರ';
	@override String get earlier => 'ಹಿಂದೆ';
	@override String get delete => 'ಅಳಿಸಿ';
}

// Path: profile
class _TranslationsProfileKn extends TranslationsProfileEn {
	_TranslationsProfileKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get followers => 'ಅನುಯಾಯಿಗಳು';
	@override String get following => 'ಅನುಸರಿಸುತ್ತಿರುವವರು';
	@override String get unfollow => 'ಅನುಸರಿಸುವುದನ್ನು ನಿಲ್ಲಿಸಿ';
	@override String get follow => 'ಅನುಸರಿಸಿ';
	@override String get about => 'ಬಗ್ಗೆ';
	@override String get stories => 'ಕಥೆಗಳು';
	@override String get unableToShareImage => 'ಚಿತ್ರವನ್ನು ಹಂಚಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';
	@override String get imageSavedToPhotos => 'ಚಿತ್ರವನ್ನು ಫೋಟೋಗಳಿಗೆ ಉಳಿಸಲಾಗಿದೆ';
	@override String get view => 'ನೋಡಿ';
	@override String get saveToPhotos => 'ಫೋಟೋಗಳಿಗೆ ಉಳಿಸಿ';
	@override String get failedToLoadImage => 'ಚಿತ್ರವನ್ನು ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';
}

// Path: feed
class _TranslationsFeedKn extends TranslationsFeedEn {
	_TranslationsFeedKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'ಕಥೆಗಳು ಲೋಡ್ ಆಗುತ್ತಿವೆ...';
	@override String get loadingPosts => 'ಪೋಸ್ಟ್‌ಗಳು ಲೋಡ್ ಆಗುತ್ತಿವೆ...';
	@override String get loadingVideos => 'ವೀಡಿಯೋಗಳು ಲೋಡ್ ಆಗುತ್ತಿವೆ...';
	@override String get loadingStories => 'ಕಥೆಗಳು ಲೋಡ್ ಆಗುತ್ತಿವೆ...';
	@override String get errorTitle => 'ಅಯ್ಯೋ! ಏನೋ ತಪ್ಪಾಗಿದೆ';
	@override String get tryAgain => 'ಮತ್ತೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ';
	@override String get noStoriesAvailable => 'ಯಾವುದೇ ಕಥೆಗಳು ಲಭ್ಯವಿಲ್ಲ';
	@override String get noImagesAvailable => 'ಯಾವುದೇ ಚಿತ್ರ ಪೋಸ್ಟ್‌ಗಳು ಲಭ್ಯವಿಲ್ಲ';
	@override String get noTextPostsAvailable => 'ಯಾವುದೇ ಪಠ್ಯ ಪೋಸ್ಟ್‌ಗಳು ಲಭ್ಯವಿಲ್ಲ';
	@override String get noContentAvailable => 'ಯಾವುದೇ ವಿಷಯ ಲಭ್ಯವಿಲ್ಲ';
	@override String get refresh => 'ರಿಫ್ರೆಶ್ ಮಾಡಿ';
	@override String get comments => 'ಕಾಮೆಂಟ್‌ಗಳು';
	@override String get commentsComingSoon => 'ಕಾಮೆಂಟ್‌ಗಳು ಶೀಘ್ರದಲ್ಲೇ ಲಭ್ಯವಾಗಲಿವೆ';
	@override String get addCommentHint => 'ಕಾಮೆಂಟ್ ಸೇರಿಸಿ...';
	@override String get shareStory => 'ಕಥೆಯನ್ನು ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get sharePost => 'ಪೋಸ್ಟ್ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareThought => 'ಚಿಂತನೆ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareAsImage => 'ಚಿತ್ರವಾಗಿ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareAsImageSubtitle => 'ಒಂದು ಸುಂದರ ಪೂರ್ವದೃಶ್ಯ ಕಾರ್ಡ್ ರಚಿಸಿ';
	@override String get shareLink => 'ಲಿಂಕ್ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareLinkSubtitle => 'ಕಥೆಯ ಲಿಂಕ್ ಅನ್ನು ನಕಲಿಸಿ ಅಥವಾ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareImageLinkSubtitle => 'ಪೋಸ್ಟ್‌ನ ಲಿಂಕ್ ಅನ್ನು ನಕಲಿಸಿ ಅಥವಾ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareTextLinkSubtitle => 'ಚಿಂತನೆಯ ಲಿಂಕ್ ಅನ್ನು ನಕಲಿಸಿ ಅಥವಾ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareAsText => 'ಪಠ್ಯವಾಗಿ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareAsTextSubtitle => 'ಕಥೆಯ ಒಂದು ಭಾಗವನ್ನು ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareQuote => 'ಉಲ್ಲೇಖವನ್ನು ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareQuoteSubtitle => 'ಉಲ್ಲೇಖ ರೂಪದಲ್ಲಿ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareWithImage => 'ಚಿತ್ರ ಸಮೇತ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get shareWithImageSubtitle => 'ಚಿತ್ರವನ್ನು ಶೀರ್ಷಿಕೆಯೊಂದಿಗೆ ಸೇರಿಸಿ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get copyLink => 'ಲಿಂಕ್ ನಕಲಿಸಿ';
	@override String get copyLinkSubtitle => 'ಲಿಂಕ್ ಅನ್ನು ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ಕಾಪಿ ಮಾಡಿ';
	@override String get copyText => 'ಪಠ್ಯವನ್ನು ನಕಲಿಸಿ';
	@override String get copyTextSubtitle => 'ಉಲ್ಲೇಖವನ್ನು ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ಕಾಪಿ ಮಾಡಿ';
	@override String get linkCopied => 'ಲಿಂಕ್ ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ಕಾಪಿ ಮಾಡಲಾಗಿದೆ';
	@override String get textCopied => 'ಪಠ್ಯ ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ಕಾಪಿ ಮಾಡಲಾಗಿದೆ';
	@override String get sendToUser => 'ಬಳಕೆದಾರರಿಗೆ ಕಳುಹಿಸಿ';
	@override String get sendToUserSubtitle => 'ಒಬ್ಬ ಸ್ನೇಹಿತನಿಗೆ ನೇರವಾಗಿ ಹಂಚಿಕೊಳ್ಳಿ';
	@override String get chooseFormat => 'ಫಾರ್ಮಾಟ್ ಆಯ್ಕೆಮಾಡಿ';
	@override String get linkPreview => 'ಲಿಂಕ್ ಪೂರ್ವದೃಶ್ಯ';
	@override String get linkPreviewSize => '1200 × 630';
	@override String get storyFormat => 'ಸ್ಟೋರಿ ಫಾರ್ಮಾಟ್';
	@override String get storyFormatSize => '1080 × 1920 (Instagram/Stories)';
	@override String get generatingPreview => 'ಪೂರ್ವದೃಶ್ಯ ರಚಿಸಲಾಗುತ್ತಿದೆ...';
	@override String get bookmarked => 'ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡಲಾಗಿದೆ';
	@override String get removedFromBookmarks => 'ಬುಕ್‌ಮಾರ್ಕ್‌ಗಳಿಂದ ತೆಗೆದುಹಾಕಲಾಗಿದೆ';
	@override String unlike({required Object count}) => 'ಇಷ್ಟವಿಲ್ಲ, ${count} ಲೈಕ್‌ಗಳು';
	@override String like({required Object count}) => 'ಇಷ್ಟವಾಯಿತು, ${count} ಲೈಕ್‌ಗಳು';
	@override String commentCount({required Object count}) => '${count} ಕಾಮೆಂಟ್‌ಗಳು';
	@override String shareCount({required Object count}) => 'ಹಂಚಿಕೊಳ್ಳಿ, ${count} ಬಾರಿ ಹಂಚಲಾಗಿದೆ';
	@override String get removeBookmark => 'ಬುಕ್‌ಮಾರ್ಕ್ ತೆಗೆದುಹಾಕಿ';
	@override String get addBookmark => 'ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡಿ';
	@override String get quote => 'ಉಲ್ಲೇಖ';
	@override String get quoteCopied => 'ಉಲ್ಲೇಖವನ್ನು ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ಕಾಪಿ ಮಾಡಲಾಗಿದೆ';
	@override String get copy => 'ನಕಲಿಸಿ';
	@override String get tapToViewFullQuote => 'ಪೂರ್ಣ ಉಲ್ಲೇಖವನ್ನು ನೋಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';
	@override String get quoteFromMyitihas => 'MyItihas ನಿಂದ ಉಲ್ಲೇಖ';
	@override late final _TranslationsFeedTabsKn tabs = _TranslationsFeedTabsKn._(_root);
	@override String get tapToShowCaption => 'ಕ್ಯಾಪ್ಷನ್ ತೋರಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ';
	@override String get noVideosAvailable => 'ಯಾವುದೇ ವೀಡಿಯೊಗಳು ಲಭ್ಯವಿಲ್ಲ';
	@override String get selectUser => 'ಯಾರಿಗೆ ಕಳುಹಿಸಬೇಕು';
	@override String get searchUsers => 'ಬಳಕೆದಾರರನ್ನು ಹುಡುಕಿ...';
	@override String get noFollowingYet => 'ನೀವು ಇನ್ನೂ ಯಾರನ್ನೂ ಅನುಸರಿಸುತ್ತಿಲ್ಲ';
	@override String get noUsersFound => 'ಯಾವುದೇ ಬಳಕೆದಾರರು ಕಂಡುಬರಲಿಲ್ಲ';
	@override String get tryDifferentSearch => 'ಬೇರೆ ಹುಡುಕಾಟ ಪದ ಬಳಸಿ ಪ್ರಯತ್ನಿಸಿ';
	@override String sentTo({required Object username}) => '${username} ಗೆ ಕಳುಹಿಸಲಾಗಿದೆ';
}

// Path: voice
class _TranslationsVoiceKn extends TranslationsVoiceEn {
	_TranslationsVoiceKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'ಮೈಕ್ರೊಫೋನ್ ಅನುಮತಿ ಅಗತ್ಯವಿದೆ';
	@override String get speechRecognitionNotAvailable => 'ಭಾಷಣ ಗುರುತಿಸುವಿಕೆ ಲಭ್ಯವಿಲ್ಲ';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsKn extends TranslationsFestivalsEn {
	_TranslationsFestivalsKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ಹಬ್ಬದ ಕಥೆಗಳು';
	@override String get tellStory => 'ಕಥೆ ಹೇಳಿ';
}

// Path: social
class _TranslationsSocialKn extends TranslationsSocialEn {
	_TranslationsSocialKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialCreatePostKn createPost = _TranslationsSocialCreatePostKn._(_root);
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroKn extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'ಅನ್ವೇಷಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ';
	@override late final _TranslationsHomeScreenHeroStoryKn story = _TranslationsHomeScreenHeroStoryKn._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionKn companion = _TranslationsHomeScreenHeroCompanionKn._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageKn heritage = _TranslationsHomeScreenHeroHeritageKn._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityKn community = _TranslationsHomeScreenHeroCommunityKn._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesKn messages = _TranslationsHomeScreenHeroMessagesKn._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthKn extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get short => 'ಸಣ್ಣದು';
	@override String get medium => 'ಮಧ್ಯಮ';
	@override String get long => 'ದೊಡ್ಡದು';
	@override String get epic => 'ವಿಶಾಲ';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatKn extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'ಕಥನಾತ್ಮಕ';
	@override String get dialogue => 'ಸಂಭಾಷಣಾಧಾರಿತ';
	@override String get poetic => 'ಕಾವ್ಯಾತ್ಮಕ';
	@override String get scriptural => 'ಶಾಸ್ತ್ರೀಯ';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsKn extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'ಕೃಷ್ಣನು ಅರ್ಜುನನನ್ನು ಉಪದೇಶಿಸುವ ಕಥೆಯನ್ನು ಹೇಳಿ...';
	@override String get warriorRedemption => 'ಪ್ರಾಯಶ್ಚಿತ್ತ ಹುಡುಕುತ್ತಿರುವ ಯೋಧನ ಮಹತ್ವಾಕಾಂಕ್ಷಿ ಕಥೆ ಬರೆಯಿರಿ...';
	@override String get sageWisdom => 'ಋಷಿಗಳ ಜ್ಞಾನವನ್ನು ಕುರಿತ ಕಥೆಯನ್ನು ರಚಿಸಿ...';
	@override String get devotedSeeker => 'ಭಕ್ತಿಯನ್ನು ಹುಡುಕುವ ವ್ಯಕ್ತಿಯ ಆತ್ಮೀಯ ಪ್ರಯಾಣವನ್ನು ವಿವರಿಸಿ...';
	@override String get divineIntervention => 'ದೈವೀಯ ಹಸ್ತಕ್ಷೇಪದ ಮೇಲೆ ಒಂದು ಪುರಾಣಕಥೆ ಹಂಚಿಕೊಳ್ಳಿ...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsKn extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'ದಯವಿಟ್ಟು ಅಗತ್ಯವಿರುವ ಎಲ್ಲಾ ಆಯ್ಕೆಗಳನ್ನು ಪೂರೈಸಿ';
	@override String get generationFailed => 'ಕಥೆ ರಚಿಸಲು ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsKn extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  ನಮಸ್ಕಾರ!';
	@override String get dharma => '📖  ಧರ್ಮ ಎಂದರೇನು?';
	@override String get stress => '🧘  ಒತ್ತಡವನ್ನು ಹೇಗೆ ನಿಭಾಯಿಸಬೇಕು';
	@override String get karma => '⚡  ಕರ್ಮವನ್ನು ಸರಳವಾಗಿ ವಿವರಿಸಿ';
	@override String get story => '💬  ನನಗೆ ಒಂದು ಕಥೆ ಹೇಳಿ';
	@override String get wisdom => '🌟  ಇಂದಿನ ಜ್ಞಾನ';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsKn extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get poll => 'Poll';
	@override String get camera => 'Camera';
	@override String get photos => 'Photos';
	@override String get location => 'Location';
	@override String get pollTitle => 'Create poll';
	@override String get pollQuestionHint => 'Ask a question';
	@override String pollOptionHint({required Object n}) => 'Option ${n}';
	@override String get addOption => 'Add option';
	@override String get removeOption => 'Remove';
	@override String get sendPoll => 'Send poll';
	@override String get pollNeedTwoOptions => 'Add at least 2 options (maximum 4).';
	@override String get pollMaxOptions => 'You can add up to 4 options.';
	@override String get sharedLocationTitle => 'Shared location';
	@override String get sendLocation => 'Send location';
	@override String get locationPreviewTitle => 'Send your current location?';
	@override String get locationFetching => 'Getting location…';
	@override String get openInMaps => 'Open in Maps';
	@override String voteCount({required Object count}) => '${count} votes';
	@override String get voteCountOne => '1 vote';
	@override String get tapToVote => 'Tap an option to vote';
	@override String get mapsUnavailable => 'Could not open maps.';
}

// Path: map.discussions
class _TranslationsMapDiscussionsKn extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'ಚರ್ಚೆಯನ್ನು ಪೋಸ್ಟ್ ಮಾಡಿ';
	@override String get intentCardCta => 'ಒಂದು ಚರ್ಚೆಯನ್ನು ಪೋಸ್ಟ್ ಮಾಡಿ';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapKn extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Indian traditional fabrics';
	@override String get sectionSubtitle => 'Open a dedicated map of handloom and GI-linked textile hubs.';
	@override String get screenTitle => 'Indian fabrics';
	@override String get fabricLabel => 'Fabric';
	@override String get aboutTitle => 'About this place';
	@override String get shopCta => 'Shop';
	@override String get shopTitle => 'Sellers';
	@override String get govSellers => 'Official & government-linked outlets';
	@override String get addSeller => 'Suggest a seller';
	@override String get submitSeller => 'Send by email';
	@override String get sellerNameHint => 'Seller or organization name';
	@override String get contactHint => 'Phone or email';
	@override String get cityHint => 'City / town';
	@override String get noteHint => 'Short note';
	@override String get linkHint => 'Website (optional)';
	@override String get emailSubject => 'Fabric seller suggestion — MyItihas';
	@override String get copyBody => 'Details copied to clipboard';
	@override String get openMailFailed => 'Could not open email. Copy details manually.';
}

// Path: map.classicalArtMap
class _TranslationsMapClassicalArtMapKn extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Indian classical artforms';
	@override String get sectionSubtitle => 'Explore state-level visual and performance art traditions.';
	@override String get screenTitle => 'Classical artforms by state';
	@override String get stateLabel => 'State';
	@override String get detailsCta => 'View details';
	@override String get discussionCta => 'Discussion forum';
	@override String get postCta => 'Post to community';
}

// Path: map.classicalDanceMap
class _TranslationsMapClassicalDanceMapKn extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Indian classical dances';
	@override String get sectionSubtitle => 'Explore state-level dance traditions and lineages.';
	@override String get screenTitle => 'Classical dances by state';
	@override String get stateLabel => 'State';
	@override String get detailsCta => 'View details';
	@override String get discussionCta => 'Discussion forum';
	@override String get postCta => 'Post to community';
}

// Path: map.foodMap
class _TranslationsMapFoodMapKn extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Indian foods by state';
	@override String get sectionSubtitle => 'Explore native cultural Hindu foods rooted in regional traditions.';
	@override String get screenTitle => 'Indian foods by state';
	@override String get stateLabel => 'State';
	@override String get detailsCta => 'View details';
	@override String get discussionCta => 'Discussion forum';
	@override String get postCta => 'Post to community';
}

// Path: feed.tabs
class _TranslationsFeedTabsKn extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get all => 'ಎಲ್ಲ';
	@override String get stories => 'ಕಥೆಗಳು';
	@override String get posts => 'ಪೋಸ್ಟ್‌ಗಳು';
	@override String get videos => 'ವೀಡಿಯೊಗಳು';
	@override String get images => 'ಚಿತ್ರಗಳು';
	@override String get text => 'ಚಿಂತನೆಗಳು';
}

// Path: social.createPost
class _TranslationsSocialCreatePostKn extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String trimVideoSubtitle({required Object max}) => 'ಗರಿಷ್ಠ ${max}ಸೆ · ನಿಮ್ಮ ಅತ್ಯುತ್ತಮ ಭಾಗವನ್ನು ಆಯ್ಕೆಮಾಡಿ';
	@override String get trimVideoInstructionsTitle => 'ನಿಮ್ಮ ಕ್ಲಿಪ್ ಟ್ರಿಮ್ ಮಾಡಿ';
	@override String get trimVideoInstructionsBody => 'ಆರಂಭ ಮತ್ತು ಅಂತ್ಯ ಹ್ಯಾಂಡಲ್‌ಗಳನ್ನು ಎಳೆದು 30 ಸೆಕೆಂಡ್‌ಗಳವರೆಗೆ ಭಾಗ ಆಯ್ಕೆಮಾಡಿ.';
	@override String get trimStart => 'ಆರಂಭ';
	@override String get trimEnd => 'ಅಂತ್ಯ';
	@override String get trimSelectionEmpty => 'ಮುಂದುವರಿಸಲು ಮಾನ್ಯ ಶ್ರೇಣಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}ಸೆ ಆಯ್ಕೆ ಮಾಡಲಾಗಿದೆ (${start}–${end}) · ಗರಿಷ್ಠ ${max}ಸೆ';
	@override String get coverFrame => 'ಕವರ್ ಫ್ರೇಮ್';
	@override String get coverFrameUnavailable => 'ಪೂರ್ವದೃಶ್ಯ ಲಭ್ಯವಿಲ್ಲ';
	@override String coverFramePosition({required Object time}) => '${time} ನಲ್ಲಿ ಕವರ್';
	@override String get overlayLabel => 'ವೀಡಿಯೊ ಮೇಲೆ ಪಠ್ಯ (ಐಚ್ಛಿಕ)';
	@override String get overlayHint => 'ಸಣ್ಣ ಹೂಕ್ ಅಥವಾ ಶೀರ್ಷಿಕೆ ಸೇರಿಸಿ';
	@override String get videoEditorCaptionLabel => 'ಶೀರ್ಷಿಕೆ / ಪಠ್ಯ (ಐಚ್ಛಿಕ)';
	@override String get videoEditorCaptionHint => 'ಉದಾ: ನಿಮ್ಮ ರೀಲ್‌ಗಾಗಿ ಶೀರ್ಷಿಕೆ ಅಥವಾ ಹೂಕ್';
	@override String get videoEditorAspectLabel => 'ಅನುಪಾತ';
	@override String get videoEditorAspectOriginal => 'ಮೂಲ';
	@override String get videoEditorAspectSquare => '೧:೧';
	@override String get videoEditorAspectPortrait => '೯:೧೬';
	@override String get videoEditorAspectLandscape => '೧೬:೯';
	@override String get videoEditorQuickTrim => 'ತ್ವರಿತ ಟ್ರಿಮ್';
	@override String get videoEditorSpeed => 'ವೇಗ';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryKn extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ಎಐ ಕಥೆ ರಚನೆ';
	@override String get headline => 'ಮನಸೆಳೆಯುವ\nಕಥೆಗಳನ್ನು\nರಚಿಸಿ';
	@override String get subHeadline => 'ಪ್ರಾಚೀನ ಜ್ಞಾನದಿಂದ ಚಾಲಿತ';
	@override String get line1 => '✦  ಒಂದು ಪವಿತ್ರ ಶಾಸ್ತ್ರವನ್ನು ಆರಿಸಿ...';
	@override String get line2 => '✦  ಜೀವಂತ ಹಿನ್ನೆಲೆಯನ್ನು ಆರಿಸಿ...';
	@override String get line3 => '✦  ಎಐಗೆ ಮಂತ್ರಮುಗ್ಧಗೊಳಿಸುವ ಕಥೆ ನೆಯಲು ಬಿಡಿ...';
	@override String get cta => 'ಕಥೆ ರಚಿಸಿ';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionKn extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ಆಧ್ಯಾತ್ಮಿಕ ಸಂಗಾತಿ';
	@override String get headline => 'ನಿಮ್ಮ ದಿವ್ಯ\nಮಾರ್ಗದರ್ಶಿ,\nಯಾವಾಗಲೂ ಹತ್ತಿರ';
	@override String get subHeadline => 'ಕೃಷ್ಣನ ಜ್ಞಾನದಿಂದ ಪ್ರೇರಿತ';
	@override String get line1 => '✦  ನಿಜವಾಗಿ ಕೇಳುವ ಸ್ನೇಹಿತ...';
	@override String get line2 => '✦  ಜೀವನದ ಹೋರಾಟಗಳಿಗೆ ಜ್ಞಾನ...';
	@override String get line3 => '✦  ನಿಮ್ಮನ್ನು ಉತ್ತೇಜಿಸುವ ಸಂಭಾಷಣೆಗಳು...';
	@override String get cta => 'ಚಾಟ್ ಆರಂಭಿಸಿ';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageKn extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ಪಾರಂಪರ್ಯ ನಕ್ಷೆ';
	@override String get headline => 'ಶಾಶ್ವತ\nಪಾರಂಪರ್ಯವನ್ನು\nಅನ್ವೇಷಿಸಿ';
	@override String get subHeadline => '5000+ ಪವಿತ್ರ ಸ್ಥಳಗಳು ನಕ್ಷೆಗೊಳಿಸಲಾಗಿದೆ';
	@override String get line1 => '✦  ಪವಿತ್ರ ಸ್ಥಳಗಳನ್ನು ಅನ್ವೇಷಿಸಿ...';
	@override String get line2 => '✦  ಇತಿಹಾಸ ಮತ್ತು ಪುರಾಣ ಓದಿ...';
	@override String get line3 => '✦  ಅರ್ಥಪೂರ್ಣ ಯಾತ್ರೆಗಳನ್ನು ಯೋಜಿಸಿ...';
	@override String get cta => 'ನಕ್ಷೆ ಅನ್ವೇಷಿಸಿ';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityKn extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ಸಮುದಾಯ ಸ್ಥಳ';
	@override String get headline => 'ಸಂಸ್ಕೃತಿಯನ್ನು\nಲೋಕದೊಂದಿಗೆ\nಹಂಚಿಕೊಳ್ಳಿ';
	@override String get subHeadline => 'ಚೈತನ್ಯಮಯ ಜಾಗತಿಕ ಸಮುದಾಯ';
	@override String get line1 => '✦  ಪೋಸ್ಟ್‌ಗಳು ಮತ್ತು ಆಳವಾದ ಚರ್ಚೆಗಳು...';
	@override String get line2 => '✦  ಚಿಕ್ಕ ಸಾಂಸ್ಕೃತಿಕ ವೀಡಿಯೊಗಳು...';
	@override String get line3 => '✦  ವಿಶ್ವದ ವಿವಿಧ ಕಥೆಗಳು...';
	@override String get cta => 'ಸಮುದಾಯ ಸೇರಿ';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesKn extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesKn._(TranslationsKn root) : this._root = root, super.internal(root);

	final TranslationsKn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ಖಾಸಗಿ ಸಂದೇಶಗಳು';
	@override String get headline => 'ಅರ್ಥಪೂರ್ಣ\nಸಂಭಾಷಣೆಗಳು\nಇಲ್ಲಿಂದ ಆರಂಭ';
	@override String get subHeadline => 'ಖಾಸಗಿ ಮತ್ತು ಚಿಂತಾಜನಕ ಸ್ಥಳಗಳು';
	@override String get line1 => '✦  ಸಮಮನಸ್ಕರೊಂದಿಗೆ ಸಂಪರ್ಕಿಸಿ...';
	@override String get line2 => '✦  ಆಲೋಚನೆಗಳು ಮತ್ತು ಕಥೆಗಳ ಬಗ್ಗೆ ಚರ್ಚಿಸಿ...';
	@override String get line3 => '✦  ಚಿಂತಾಜನಕ ಸಮುದಾಯಗಳನ್ನು ನಿರ್ಮಿಸಿ...';
	@override String get cta => 'ಸಂದೇಶ ತೆರೆಯಿರಿ';
}
