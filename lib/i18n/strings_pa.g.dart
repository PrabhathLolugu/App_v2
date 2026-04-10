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
class TranslationsPa extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.pa,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <pa>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsPa _root = this; // ignore: unused_field

	@override 
	TranslationsPa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppPa app = _TranslationsAppPa._(_root);
	@override late final _TranslationsCommonPa common = _TranslationsCommonPa._(_root);
	@override late final _TranslationsNavigationPa navigation = _TranslationsNavigationPa._(_root);
	@override late final _TranslationsHomePa home = _TranslationsHomePa._(_root);
	@override late final _TranslationsHomeScreenPa homeScreen = _TranslationsHomeScreenPa._(_root);
	@override late final _TranslationsStoriesPa stories = _TranslationsStoriesPa._(_root);
	@override late final _TranslationsStoryGeneratorPa storyGenerator = _TranslationsStoryGeneratorPa._(_root);
	@override late final _TranslationsChatPa chat = _TranslationsChatPa._(_root);
	@override late final _TranslationsMapPa map = _TranslationsMapPa._(_root);
	@override late final _TranslationsCommunityPa community = _TranslationsCommunityPa._(_root);
	@override late final _TranslationsDiscoverPa discover = _TranslationsDiscoverPa._(_root);
	@override late final _TranslationsPlanPa plan = _TranslationsPlanPa._(_root);
	@override late final _TranslationsSettingsPa settings = _TranslationsSettingsPa._(_root);
	@override late final _TranslationsAuthPa auth = _TranslationsAuthPa._(_root);
	@override late final _TranslationsErrorPa error = _TranslationsErrorPa._(_root);
	@override late final _TranslationsSubscriptionPa subscription = _TranslationsSubscriptionPa._(_root);
	@override late final _TranslationsNotificationPa notification = _TranslationsNotificationPa._(_root);
	@override late final _TranslationsProfilePa profile = _TranslationsProfilePa._(_root);
	@override late final _TranslationsFeedPa feed = _TranslationsFeedPa._(_root);
	@override late final _TranslationsVoicePa voice = _TranslationsVoicePa._(_root);
	@override late final _TranslationsFestivalsPa festivals = _TranslationsFestivalsPa._(_root);
	@override late final _TranslationsSocialPa social = _TranslationsSocialPa._(_root);
}

// Path: app
class _TranslationsAppPa extends TranslationsAppEn {
	_TranslationsAppPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'ਭਾਰਤੀ ਸ਼ਾਸਤਰਾਂ ਦੀ ਖੋਜ ਕਰੋ';
}

// Path: common
class _TranslationsCommonPa extends TranslationsCommonEn {
	_TranslationsCommonPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ਠੀਕ ਹੈ';
	@override String get cancel => 'ਰੱਦ ਕਰੋ';
	@override String get confirm => 'ਪੁਸ਼ਟੀ ਕਰੋ';
	@override String get delete => 'ਮਿਟਾਓ';
	@override String get edit => 'ਸੋਧੋ';
	@override String get save => 'ਸੰਭਾਲੋ';
	@override String get share => 'ਸਾਂਝਾ ਕਰੋ';
	@override String get search => 'ਖੋਜੋ';
	@override String get loading => 'ਲੋਡ ਹੋ ਰਿਹਾ ਹੈ...';
	@override String get error => 'ਗਲਤੀ';
	@override String get retry => 'ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ';
	@override String get back => 'ਵਾਪਸ';
	@override String get next => 'ਅਗਲਾ';
	@override String get finish => 'ਖਤਮ';
	@override String get skip => 'ਛੱਡੋ';
	@override String get yes => 'ਹਾਂ';
	@override String get no => 'ਨਹੀਂ';
	@override String get readFullStory => 'ਪੂਰੀ ਕਹਾਣੀ ਪੜ੍ਹੋ';
	@override String get dismiss => 'ਬੰਦ ਕਰੋ';
	@override String get offlineBannerMessage => 'ਤੁਸੀਂ ਆਫਲਾਈਨ ਹੋ – ਸੇਵ ਕੀਤੀ ਸਮੱਗਰੀ ਵੇਖ ਰਹੇ ਹੋ';
	@override String get backOnline => 'ਮੁੜ ਆਨਲਾਈਨ';
}

// Path: navigation
class _TranslationsNavigationPa extends TranslationsNavigationEn {
	_TranslationsNavigationPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get home => 'ਖੋਜੋ';
	@override String get stories => 'ਕਹਾਣੀਆਂ';
	@override String get chat => 'ਚੈਟ';
	@override String get map => 'ਮੈਪ';
	@override String get community => 'ਸਮਾਜਿਕ';
	@override String get settings => 'ਸੈਟਿੰਗਜ਼';
	@override String get profile => 'ਪ੍ਰੋਫ਼ਾਈਲ';
}

// Path: home
class _TranslationsHomePa extends TranslationsHomeEn {
	_TranslationsHomePa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'ਕਹਾਣੀ ਜਨਰੇਟਰ';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'ਕਮਿਊਨਟੀ ਕਹਾਣੀਆਂ';
	@override String get maps => 'ਮੈਪਸ';
	@override String get greetingMorning => 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ';
	@override String get continueReading => 'ਪੜ੍ਹਨਾ ਜਾਰੀ ਰੱਖੋ';
	@override String get greetingAfternoon => 'ਨਮਸਤੇ';
	@override String get greetingEvening => 'ਸ਼ਾਮ ਦੀ ਸਮੇਂ ਦੀ ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ';
	@override String get greetingNight => 'ਸ਼ੁਭ ਰਾਤਰੀ';
	@override String get exploreStories => 'ਕਹਾਣੀਆਂ ਖੋਜੋ';
	@override String get generateStory => 'ਕਹਾਣੀ ਬਣਾਓ';
	@override String get content => 'ਹੋਮ ਸਮੱਗਰੀ';
}

// Path: homeScreen
class _TranslationsHomeScreenPa extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ';
	@override String get quoteOfTheDay => 'ਅੱਜ ਦੀ ਸੋਚ';
	@override String get shareQuote => 'ਕੋਟ ਸਾਂਝੀ ਕਰੋ';
	@override String get copyQuote => 'ਕੋਟ ਕਾਪੀ ਕਰੋ';
	@override String get quoteCopied => 'ਕੋਟ ਕਲਿਪਬੋਰਡ ਤੇ ਕਾਪੀ ਹੋ ਗਈ';
	@override String get featuredStories => 'ਖ਼ਾਸ ਕਹਾਣੀਆਂ';
	@override String get quickActions => 'ਤੁਰੰਤ ਕਾਰਵਾਈਆਂ';
	@override String get generateStory => 'ਕਹਾਣੀ ਬਣਾਓ';
	@override String get chatWithKrishna => 'ਕ੍ਰਿਸ਼ਨ ਨਾਲ ਗੱਲਬਾਤ ਕਰੋ';
	@override String get myActivity => 'ਮੇਰੀ ਸਰਗਰਮੀ';
	@override String get continueReading => 'ਪੜ੍ਹਨਾ ਜਾਰੀ ਰੱਖੋ';
	@override String get savedStories => 'ਸੰਭਾਲੀਆਂ ਕਹਾਣੀਆਂ';
	@override String get exploreMyitihas => 'ਮਾਇਇਤਿਹਾਸ ਖੋਜੋ';
	@override String get storiesInYourLanguage => 'ਤੁਹਾਡੀ ਭਾਸ਼ਾ ਵਿੱਚ ਕਹਾਣੀਆਂ';
	@override String get seeAll => 'ਸਾਰੀਆਂ ਵੇਖੋ';
	@override String get startReading => 'ਪੜ੍ਹਨਾ ਸ਼ੁਰੂ ਕਰੋ';
	@override String get exploreStories => 'ਆਪਣੀ ਯਾਤਰਾ ਸ਼ੁਰੂ ਕਰਨ ਲਈ ਕਹਾਣੀਆਂ ਖੋਜੋ';
	@override String get saveForLater => 'ਜਿਹੜੀਆਂ ਕਹਾਣੀਆਂ ਚੰਗੀਆਂ ਲੱਗਣ, ਉਹਨਾਂ ਨੂੰ ਬੁੱਕਮਾਰਕ ਕਰੋ';
	@override String get noActivityYet => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਸਰਗਰਮੀ ਨਹੀਂ';
	@override String minLeft({required Object count}) => '${count} ਮਿੰਟ ਬਾਕੀ';
	@override String get activityHistory => 'ਸਰਗਰਮੀ ਇਤਿਹਾਸ';
	@override String get storyGenerated => 'ਇੱਕ ਕਹਾਣੀ ਬਣਾਈ ਗਈ';
	@override String get storyRead => 'ਇੱਕ ਕਹਾਣੀ ਪੜ੍ਹੀ ਗਈ';
	@override String get storyBookmarked => 'ਕਹਾਣੀ ਬੁੱਕਮਾਰਕ ਕੀਤੀ ਗਈ';
	@override String get storyShared => 'ਕਹਾਣੀ ਸਾਂਝੀ ਕੀਤੀ ਗਈ';
	@override String get storyCompleted => 'ਕਹਾਣੀ ਪੂਰੀ ਕੀਤੀ ਗਈ';
	@override String get today => 'ਅੱਜ';
	@override String get yesterday => 'ਕੱਲ੍ਹ';
	@override String get thisWeek => 'ਇਸ ਹਫ਼ਤੇ';
	@override String get earlier => 'ਪਹਿਲਾਂ';
	@override String get noContinueReading => 'ਹਾਲੇ ਪੜ੍ਹਨ ਲਈ ਕੁਝ ਨਹੀਂ';
	@override String get noSavedStories => 'ਹਾਲੇ ਕੋਈ ਸੰਭਾਲੀ ਕਹਾਣੀ ਨਹੀਂ';
	@override String get bookmarkStoriesToSave => 'ਕਹਾਣੀਆਂ ਸੰਭਾਲਣ ਲਈ ਬੁੱਕਮਾਰਕ ਕਰੋ';
	@override String get myGeneratedStories => 'ਮੇਰੀਆਂ ਕਹਾਣੀਆਂ';
	@override String get noGeneratedStoriesYet => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਕਹਾਣੀ ਨਹੀਂ ਬਣਾਈ ਗਈ';
	@override String get createYourFirstStory => 'AI ਦੀ ਮਦਦ ਨਾਲ ਆਪਣੀ ਪਹਿਲੀ ਕਹਾਣੀ ਬਣਾਓ';
	@override String get shareToFeed => 'ਫੀਡ ’ਤੇ ਸਾਂਝੀ ਕਰੋ';
	@override String get sharedToFeed => 'ਕਹਾਣੀ ਫੀਡ ’ਤੇ ਸਾਂਝੀ ਕੀਤੀ ਗਈ';
	@override String get shareStoryTitle => 'ਕਹਾਣੀ ਸਾਂਝੀ ਕਰੋ';
	@override String get shareStoryMessage => 'ਆਪਣੀ ਕਹਾਣੀ ਲਈ ਕੈਪਸ਼ਨ ਲਿਖੋ (ਵਿਕਲਪਿਕ)';
	@override String get shareStoryCaption => 'ਕੈਪਸ਼ਨ';
	@override String get shareStoryHint => 'ਤੁਸੀਂ ਇਸ ਕਹਾਣੀ ਬਾਰੇ ਕੀ ਕਹਿਣਾ ਚਾਹੁੰਦੇ ਹੋ?';
	@override String get exploreHeritageTitle => 'ਵਿਰਾਸਤ ਖੋਜੋ';
	@override String get exploreHeritageDesc => 'ਮੈਪ ’ਤੇ ਸੱਭਿਆਚਾਰਕ ਵਿਰਾਸਤੀ ਸਥਾਨ ਲੱਭੋ';
	@override String get whereToVisit => 'ਅਗਲਾ ਦੌਰਾ';
	@override String get scriptures => 'ਸ਼ਾਸਤਰ';
	@override String get exploreSacredSites => 'ਪਵਿੱਤਰ ਸਥਾਨ ਖੋਜੋ';
	@override String get readStories => 'ਕਹਾਣੀਆਂ ਪੜ੍ਹੋ';
	@override String get yesRemindMe => 'ਹਾਂ, ਮੈਨੂੰ ਯਾਦ ਦਿਵਾਓ';
	@override String get noDontShowAgain => 'ਨਹੀਂ, ਫਿਰ ਨਾ ਦਿਖਾਓ';
	@override String get discoverDismissTitle => 'Discover MyItihas ਲੁਕਾਉਣਾ ਹੈ?';
	@override String get discoverDismissMessage => 'ਕੀ ਤੁਸੀਂ ਅਗਲੀ ਵਾਰ ਐਪ ਖੋਲ੍ਹਣ ਜਾਂ ਲਾਗਇਨ ਕਰਨ \'ਤੇ ਇਹ ਮੁੜ ਵੇਖਣਾ ਚਾਹੋਗੇ?';
	@override String get discoverCardTitle => 'MyItihas ਦੀ ਖੋਜ ਕਰੋ';
	@override String get discoverCardSubtitle => 'ਪ੍ਰਾਚੀਨ ਸ਼ਾਸਤਰਾਂ ਦੀਆਂ ਕਹਾਣੀਆਂ, ਘੁੰਮਣ ਲਈ ਪਵਿੱਤਰ ਸਥਾਨ ਅਤੇ ਗਿਆਨ ਤੁਹਾਡੇ ਹੱਥਾਂ ਵਿੱਚ।';
	@override String get swipeToDismiss => 'ਬੰਦ ਕਰਨ ਲਈ ਉੱਪਰ ਵੱਲ ਸੁਆਇਪ ਕਰੋ';
	@override String get searchScriptures => 'ਸ਼ਾਸਤਰ ਖੋਜੋ...';
	@override String get searchLanguages => 'ਭਾਸ਼ਾਵਾਂ ਖੋਜੋ...';
	@override String get exploreStoriesLabel => 'ਕਹਾਣੀਆਂ ਖੋਜੋ';
	@override String get exploreMore => 'ਹੋਰ ਵੇਖੋ';
	@override String get failedToLoadActivity => 'ਸਰਗਰਮੀ ਲੋਡ ਕਰਨ ਵਿੱਚ ਅਸਫਲ';
	@override String get startReadingOrGenerating => 'ਇੱਥੇ ਆਪਣੀ ਸਰਗਰਮੀ ਦੇਖਣ ਲਈ ਪੜ੍ਹਨਾ ਜਾਂ ਕਹਾਣੀਆਂ ਬਣਾਉਣਾ ਸ਼ੁਰੂ ਕਰੋ';
	@override late final _TranslationsHomeScreenHeroPa hero = _TranslationsHomeScreenHeroPa._(_root);
}

// Path: stories
class _TranslationsStoriesPa extends TranslationsStoriesEn {
	_TranslationsStoriesPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ਕਹਾਣੀਆਂ';
	@override String get searchHint => 'ਸਿਰਲੇਖ ਜਾਂ ਲੇਖਕ ਰਾਹੀਂ ਖੋਜੋ...';
	@override String get sortBy => 'ਇਸ ਮੁਤਾਬਕ ਸੱਜਾਓ';
	@override String get sortNewest => 'ਸਭ ਤੋਂ ਨਵੀਆਂ ਪਹਿਲਾਂ';
	@override String get sortOldest => 'ਸਭ ਤੋਂ ਪੁਰਾਣੀਆਂ ਪਹਿਲਾਂ';
	@override String get sortPopular => 'ਸਭ ਤੋਂ ਲੋਕਪ੍ਰਿਯ';
	@override String get noStories => 'ਕੋਈ ਕਹਾਣੀ ਨਹੀਂ ਮਿਲੀ';
	@override String get loadingStories => 'ਕਹਾਣੀਆਂ ਲੋਡ ਹੋ ਰਹੀਆਂ ਹਨ...';
	@override String get errorLoadingStories => 'ਕਹਾਣੀਆਂ ਲੋਡ ਕਰਨ ਵਿੱਚ ਅਸਫਲ';
	@override String get storyDetails => 'ਕਹਾਣੀ ਦੇ ਵੇਰਵੇ';
	@override String get continueReading => 'ਪੜ੍ਹਨਾ ਜਾਰੀ ਰੱਖੋ';
	@override String get readMore => 'ਹੋਰ ਪੜ੍ਹੋ';
	@override String get readLess => 'ਘੱਟ ਵੇਖਾਓ';
	@override String get author => 'ਲੇਖਕ';
	@override String get publishedOn => 'ਪ੍ਰਕਾਸ਼ਿਤ ਮਿਤੀ';
	@override String get category => 'ਸ਼੍ਰੇਣੀ';
	@override String get tags => 'ਟੈਗ';
	@override String get failedToLoad => 'ਕਹਾਣੀ ਲੋਡ ਕਰਨ ਵਿੱਚ ਅਸਫਲ';
	@override String get subtitle => 'ਸ਼ਾਸਤ੍ਰਾਂ ਦੀਆਂ ਕਹਾਣੀਆਂ ਖੋਜੋ';
	@override String get noStoriesHint => 'ਕਹਾਣੀਆਂ ਲੱਭਣ ਲਈ ਵੱਖਰੀ ਖੋਜ ਜਾਂ ਫਿਲਟਰ ਅਜ਼ਮਾਓ।';
	@override String get featured => 'ਖਾਸ';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorPa extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ਕਹਾਣੀ ਜਨਰੇਟਰ';
	@override String get subtitle => 'ਆਪਣੀ ਆਪਣੀ ਸ਼ਾਸਤਰੀ ਕਹਾਣੀ ਬਣਾਓ';
	@override String get quickStart => 'ਤੁਰੰਤ ਸ਼ੁਰੂਆਤ';
	@override String get interactive => 'ਇੰਟਰੈਕਟਿਵ';
	@override String get rawPrompt => 'ਰਾਅ ਪ੍ਰਾਮਪਟ';
	@override String get yourStoryPrompt => 'ਤੁਹਾਡੀ ਕਹਾਣੀ ਦਾ ਪ੍ਰਾਮਪਟ';
	@override String get writeYourPrompt => 'ਆਪਣਾ ਪ੍ਰਾਮਪਟ ਲਿਖੋ';
	@override String get selectScripture => 'ਸ਼ਾਸਤਰ ਚੁਣੋ';
	@override String get selectStoryType => 'ਕਹਾਣੀ ਦਾ ਕਿਸਮ ਚੁਣੋ';
	@override String get selectCharacter => 'ਪਾਤਰ ਚੁਣੋ';
	@override String get selectTheme => 'ਥੀਮ ਚੁਣੋ';
	@override String get selectSetting => 'ਪਸੰਧ ਦਾ ਮਾਹੌਲ ਚੁਣੋ';
	@override String get selectLanguage => 'ਭਾਸ਼ਾ ਚੁਣੋ';
	@override String get selectLength => 'ਕਹਾਣੀ ਦੀ ਲੰਬਾਈ';
	@override String get moreOptions => 'ਹੋਰ ਵਿਕਲਪ';
	@override String get random => 'ਯਾਦਗਾਰੀ';
	@override String get generate => 'ਕਹਾਣੀ ਬਣਾਓ';
	@override String get generating => 'ਤੁਹਾਡੀ ਕਹਾਣੀ ਬਣਾਈ ਜਾ ਰਹੀ ਹੈ...';
	@override String get creatingYourStory => 'ਤੁਹਾਡੀ ਕਹਾਣੀ ਤਿਆਰ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ';
	@override String get consultingScriptures => 'ਪ੍ਰਾਚੀਨ ਸ਼ਾਸਤਰਾਂ ਨਾਲ ਸਲਾਹ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ...';
	@override String get weavingTale => 'ਤੁਹਾਡੀ ਕਹਾਣੀ ਨੂੰ ਬੁਣਿਆ ਜਾ ਰਿਹਾ ਹੈ...';
	@override String get addingWisdom => 'ਦਿਵਿਆ ਗਿਆਨ ਜੋੜਿਆ ਜਾ ਰਿਹਾ ਹੈ...';
	@override String get polishingNarrative => 'ਕਹਾਣੀ ਨੂੰ ਨਿਖਾਰਿਆ ਜਾ ਰਿਹਾ ਹੈ...';
	@override String get almostThere => 'ਲਗਭਗ ਹੋ ਗਿਆ...';
	@override String get generatedStory => 'ਤੁਹਾਡੀ ਬਣਾਈ ਹੋਈ ਕਹਾਣੀ';
	@override String get aiGenerated => 'AI ਦੁਆਰਾ ਬਣਾਇਆ ਗਿਆ';
	@override String get regenerate => 'ਮੁੜ ਬਣਾਓ';
	@override String get saveStory => 'ਕਹਾਣੀ ਸੇਵ ਕਰੋ';
	@override String get shareStory => 'ਕਹਾਣੀ ਸਾਂਝੀ ਕਰੋ';
	@override String get newStory => 'ਨਵੀਂ ਕਹਾਣੀ';
	@override String get saved => 'ਸੰਭਾਲੀ ਗਈ';
	@override String get storySaved => 'ਕਹਾਣੀ ਤੁਹਾਡੀ ਲਾਇਬ੍ਰੇਰੀ ਵਿੱਚ ਸੇਵ ਹੋ ਗਈ ਹੈ';
	@override String get story => 'ਕਹਾਣੀ';
	@override String get lesson => 'ਸਿੱਖ';
	@override String get didYouKnow => 'ਕੀ ਤੁਸੀਂ ਜਾਣਦੇ ਹੋ?';
	@override String get activity => 'ਸਰਗਰਮੀ';
	@override String get optionalRefine => 'ਵਿਕਲਪਿਕ: ਵਿਕਲਪਾਂ ਨਾਲ ਹੋਰ ਨਿਰਧਾਰਿਤ ਕਰੋ';
	@override String get applyOptions => 'ਵਿਕਲਪ ਲਾਗੂ ਕਰੋ';
	@override String get language => 'ਭਾਸ਼ਾ';
	@override String get storyFormat => 'ਕਹਾਣੀ ਦਾ ਫਾਰਮੈਟ';
	@override String get requiresInternet => 'ਕਹਾਣੀ ਬਣਾਉਣ ਲਈ ਇੰਟਰਨੈਟ ਦੀ ਲੋੜ ਹੈ';
	@override String get notAvailableOffline => 'ਕਹਾਣੀ ਆਫਲਾਈਨ ਉਪਲਬਧ ਨਹੀਂ। ਵੇਖਣ ਲਈ ਇੰਟਰਨੈਟ ਨਾਲ ਜੁੜੋ।';
	@override String get aiDisclaimer => 'AI ਗਲਤੀਆਂ ਕਰ ਸਕਦਾ ਹੈ। ਅਸੀਂ ਲਗਾਤਾਰ ਸੁਧਾਰ ਰਹੇ ਹਾਂ; ਤੁਹਾਡਾ ਫ਼ੀਡਬੈਕ ਮਹੱਤਵਪੂਰਨ ਹੈ।';
	@override late final _TranslationsStoryGeneratorStoryLengthPa storyLength = _TranslationsStoryGeneratorStoryLengthPa._(_root);
	@override late final _TranslationsStoryGeneratorFormatPa format = _TranslationsStoryGeneratorFormatPa._(_root);
	@override late final _TranslationsStoryGeneratorHintsPa hints = _TranslationsStoryGeneratorHintsPa._(_root);
	@override late final _TranslationsStoryGeneratorErrorsPa errors = _TranslationsStoryGeneratorErrorsPa._(_root);
}

// Path: chat
class _TranslationsChatPa extends TranslationsChatEn {
	_TranslationsChatPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'ਸ਼ਾਸਤਰਾਂ ਬਾਰੇ AI ਨਾਲ ਗੱਲਬਾਤ ਕਰੋ';
	@override String get friendMode => 'ਦੋਸਤ ਮੋਡ';
	@override String get philosophicalMode => 'ਦਾਰਸ਼ਨਿਕ ਮੋਡ';
	@override String get typeMessage => 'ਆਪਣਾ ਸੁਨੇਹਾ ਲਿਖੋ...';
	@override String get send => 'ਭੇਜੋ';
	@override String get newChat => 'ਨਵੀਂ ਚੈਟ';
	@override String get chatsTab => 'ਚੈਟਾਂ';
	@override String get groupsTab => 'ਗਰੁੱਪ';
	@override String get chatHistory => 'ਚੈਟ ਇਤਿਹਾਸ';
	@override String get clearChat => 'ਚੈਟ ਮਿਟਾਓ';
	@override String get noMessages => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਸੁਨੇਹੇ ਨਹੀਂ। ਗੱਲਬਾਤ ਸ਼ੁਰੂ ਕਰੋ!';
	@override String get listPage => 'ਚੈਟ ਸੂਚੀ ਪੰਨਾ';
	@override String get forwardMessageTo => 'ਸੁਨੇਹਾ ਅੱਗੇ ਭੇਜੋ...';
	@override String get forwardMessage => 'ਸੁਨੇਹਾ ਫੋਰਵਰਡ ਕਰੋ';
	@override String get messageForwarded => 'ਸੁਨੇਹਾ ਫੋਰਵਰਡ ਹੋ ਗਿਆ';
	@override String failedToForward({required Object error}) => 'ਸੁਨੇਹਾ ਫੋਰਵਰਡ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: ${error}';
	@override String get searchChats => 'ਚੈਟਾਂ ਖੋਜੋ';
	@override String get noChatsFound => 'ਕੋਈ ਚੈਟ ਨਹੀਂ ਮਿਲੀ';
	@override String get requests => 'ਬੇਨਤੀਆਂ';
	@override String get messageRequests => 'ਸੁਨੇਹਾ ਬੇਨਤੀਆਂ';
	@override String get groupRequests => 'ਗਰੁੱਪ ਬੇਨਤੀਆਂ';
	@override String get requestSent => 'ਬੇਨਤੀ ਭੇਜੀ ਗਈ। ਉਹਨਾਂ ਨੂੰ "ਬੇਨਤੀਆਂ" ਵਿੱਚ ਨਜ਼ਰ ਆਵੇਗੀ।';
	@override String get wantsToChat => 'ਚੈਟ ਕਰਨਾ ਚਾਹੁੰਦਾ ਹੈ';
	@override String addedYouTo({required Object name}) => '${name} ਨੇ ਤੁਹਾਨੂੰ ਜੋੜਿਆ ਹੈ';
	@override String get accept => 'ਸਵੀਕਾਰੋ';
	@override String get noMessageRequests => 'ਕੋਈ ਸੁਨੇਹਾ ਬੇਨਤੀ ਨਹੀਂ';
	@override String get noGroupRequests => 'ਕੋਈ ਗਰੁੱਪ ਬੇਨਤੀ ਨਹੀਂ';
	@override String get invitesSent => 'ਨਾਂਤੇ ਭੇਜੇ ਗਏ ਹਨ। ਉਹਨਾਂ ਨੂੰ "ਬੇਨਤੀਆਂ" ਵਿੱਚ ਨਜ਼ਰ ਆਉਣਗੇ।';
	@override String get cantMessageUser => 'ਤੁਸੀਂ ਇਸ ਵਰਤੋਂਕਾਰ ਨੂੰ ਸੁਨੇਹਾ ਨਹੀਂ ਭੇਜ ਸਕਦੇ';
	@override String get deleteChat => 'ਚੈਟ ਮਿਟਾਓ';
	@override String get deleteChats => 'ਚੈਟਾਂ ਮਿਟਾਓ';
	@override String get blockUser => 'ਵਰਤੋਂਕਾਰ ਨੂੰ ਬਲੌਕ ਕਰੋ';
	@override String get reportUser => 'ਵਰਤੋਂਕਾਰ ਦੀ ਸ਼ਿਕਾਇਤ ਕਰੋ';
	@override String get markAsRead => 'ਪੜ੍ਹਿਆ ਹੋਇਆ ਚਿੰਨ੍ਹ ਲਗਾਓ';
	@override String get markedAsRead => 'ਪੜ੍ਹਿਆ ਹੋਇਆ ਚਿੰਨ੍ਹ ਲਗਾਇਆ ਗਿਆ';
	@override String get deleteClearChat => 'ਚੈਟ ਮਿਟਾਓ / ਸਾਫ ਕਰੋ';
	@override String get deleteConversation => 'ਗੱਲਬਾਤ ਮਿਟਾਓ';
	@override String get reasonRequired => 'ਕਾਰਨ (ਲਾਜ਼ਮੀ)';
	@override String get submit => 'ਜਮ੍ਹਾਂ ਕਰੋ';
	@override String get userReportedBlocked => 'ਵਰਤੋਂਕਾਰ ਦੀ ਸ਼ਿਕਾਇਤ ਹੋ ਗਈ ਅਤੇ ਉਸਨੂੰ ਬਲੌਕ ਕਰ ਦਿੱਤਾ ਗਿਆ ਹੈ।';
	@override String reportFailed({required Object error}) => 'ਸ਼ਿਕਾਇਤ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: ${error}';
	@override String get newGroup => 'ਨਵਾਂ ਗਰੁੱਪ';
	@override String get messageSomeoneDirectly => 'ਕਿਸੇ ਨੂੰ ਸਿੱਧਾ ਸੁਨੇਹਾ ਭੇਜੋ';
	@override String get createGroupConversation => 'ਗਰੁੱਪ ਗੱਲਬਾਤ ਬਣਾਓ';
	@override String get noGroupsYet => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਗਰੁੱਪ ਨਹੀਂ';
	@override String get noChatsYet => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਚੈਟ ਨਹੀਂ';
	@override String get tapToCreateGroup => 'ਗਰੁੱਪ ਬਣਾਉਣ ਜਾਂ ਸ਼ਾਮਲ ਹੋਣ ਲਈ + ਦਬਾਓ';
	@override String get tapToStartConversation => 'ਨਵੀਂ ਗੱਲਬਾਤ ਸ਼ੁਰੂ ਕਰਨ ਲਈ + ਦਬਾਓ';
	@override String get conversationDeleted => 'ਗੱਲਬਾਤ ਮਿਟਾ ਦਿੱਤੀ ਗਈ';
	@override String conversationsDeleted({required Object count}) => '${count} ਗੱਲਬਾਤ(ਾਂ) ਮਿਟਾ ਦਿੱਤੀਆਂ ਗਈਆਂ';
	@override String get searchConversations => 'ਗੱਲਬਾਤਾਂ ਖੋਜੋ...';
	@override String get connectToInternet => 'ਕਿਰਪਾ ਕਰਕੇ ਇੰਟਰਨੈਟ ਨਾਲ ਜੁੜ ਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
	@override String get littleKrishnaName => 'ਛੋਟਾ ਕ੍ਰਿਸ਼ਨ';
	@override String get newConversation => 'ਨਵੀਂ ਗੱਲਬਾਤ';
	@override String get noConversationsYet => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਗੱਲਬਾਤ ਨਹੀਂ';
	@override String get confirmDeletion => 'ਮਿਟਾਉਣ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ';
	@override String deleteConversationConfirm({required Object title}) => 'ਕੀ ਤੁਸੀਂ ਯਕੀਨਨ ${title} ਗੱਲਬਾਤ ਮਿਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ?';
	@override String get deleteFailed => 'ਗੱਲਬਾਤ ਮਿਟਾਉਣ ਵਿੱਚ ਅਸਫਲ';
	@override String get fullChatCopied => 'ਪੂਰੀ ਚੈਟ ਕਲਿਪਬੋਰਡ ਤੇ ਕਾਪੀ ਹੋ ਗਈ!';
	@override String get connectionErrorFallback => 'ਇਸ ਵੇਲੇ ਕਨੈਕਟ ਕਰਨ ਵਿੱਚ ਸਮੱਸਿਆ ਆ ਰਹੀ ਹੈ। ਕੁਝ ਸਮੇਂ ਬਾਅਦ ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
	@override String krishnaWelcomeWithName({required Object name}) => 'ਹੇ ${name}। ਮੈਂ ਤੁਹਾਡਾ ਦੋਸਤ ਕ੍ਰਿਸ਼ਨ ਹਾਂ। ਤੁਸੀਂ ਅੱਜ ਕਿਵੇਂ ਹੋ?';
	@override String get krishnaWelcomeFriend => 'ਹੇ ਪਿਆਰੇ ਦੋਸਤ, ਮੈਂ ਕ੍ਰਿਸ਼ਨ ਹਾਂ, ਤੁਹਾਡਾ ਦੋਸਤ। ਤੁਸੀਂ ਅੱਜ ਕਿਵੇਂ ਹੋ?';
	@override String get copyYouLabel => 'ਤੁਸੀਂ';
	@override String get copyKrishnaLabel => 'ਕ੍ਰਿਸ਼ਨ';
	@override late final _TranslationsChatSuggestionsPa suggestions = _TranslationsChatSuggestionsPa._(_root);
	@override String get about => 'ਬਾਰੇ';
	@override String get yourFriendlyCompanion => 'ਤੁਹਾਡਾ ਮਿੱਤਰ ਸਾਥੀ';
	@override String get mentalHealthSupport => 'ਮਾਨਸਿਕ ਸਿਹਤ ਲਈ ਸਹਾਇਤਾ';
	@override String get mentalHealthSupportSubtitle => 'ਸੋਚਾਂ ਸਾਂਝੀਆਂ ਕਰਨ ਅਤੇ ਸੁਣਿਆ ਜਾਣ ਦਾ ਅਹਿਸਾਸ ਕਰਨ ਲਈ ਸੁਰੱਖਿਅਤ ਥਾਂ।';
	@override String get friendlyCompanion => 'ਦੋਸਤਾਨਾ ਸਾਥੀ';
	@override String get friendlyCompanionSubtitle => 'ਹਮੇਸ਼ਾਂ ਗੱਲਬਾਤ ਕਰਨ, ਹੌਸਲਾ ਦੇਣ ਅਤੇ ਗਿਆਨ ਸਾਂਝਾ ਕਰਨ ਲਈ ਤਿਆਰ।';
	@override String get storiesAndWisdom => 'ਕਹਾਣੀਆਂ ਅਤੇ ਗਿਆਨ';
	@override String get storiesAndWisdomSubtitle => 'ਅਨੰਤ ਕਹਾਣੀਆਂ ਅਤੇ ਪ੍ਰਯੋਗਤਮਕ ਗਿਆਨ ਤੋਂ ਸਿੱਖੋ।';
	@override String get askAnything => 'ਜੋ ਮਰਜ਼ੀ ਪੁੱਛੋ';
	@override String get askAnythingSubtitle => 'ਆਪਣੇ ਸਵਾਲਾਂ ਦੇ ਨਰਮ, ਵਿਚਾਰਸ਼ੀਲ ਜਵਾਬ ਪ੍ਰਾਪਤ ਕਰੋ।';
	@override String get startChatting => 'ਚੈਟਿੰਗ ਸ਼ੁਰੂ ਕਰੋ';
	@override String get maybeLater => 'ਸ਼ਾਇਦ ਬਾਅਦ ਵਿੱਚ';
	@override late final _TranslationsChatComposerAttachmentsPa composerAttachments = _TranslationsChatComposerAttachmentsPa._(_root);
}

// Path: map
class _TranslationsMapPa extends TranslationsMapEn {
	_TranslationsMapPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ਅਖੰਡ ਭਾਰਤ';
	@override String get subtitle => 'ਇਤਿਹਾਸਕ ਸਥਾਨਾਂ ਦੀ ਖੋਜ ਕਰੋ';
	@override String get searchLocation => 'ਸਥਾਨ ਖੋਜੋ...';
	@override String get viewDetails => 'ਵੇਰਵੇ ਦੇਖੋ';
	@override String get viewSites => 'ਸਥਾਨ ਵੇਖੋ';
	@override String get showRoute => 'ਰੂਟ ਦਿਖਾਓ';
	@override String get historicalInfo => 'ਇਤਿਹਾਸਕ ਜਾਣਕਾਰੀ';
	@override String get nearbyPlaces => 'ਨੇੜਲੇ ਸਥਾਨ';
	@override String get pickLocationOnMap => 'ਮੈਪ ’ਤੇ ਸਥਾਨ ਚੁਣੋ';
	@override String get sitesVisited => 'ਵਿਜ਼ਟ ਕੀਤੇ ਸਥਾਨ';
	@override String get badgesEarned => 'ਹਾਸਲ ਕੀਤੇ ਬੈਜ';
	@override String get completionRate => 'ਪੂਰਨਤਾ ਦਰ';
	@override String get addToJourney => 'ਯਾਤਰਾ ਵਿੱਚ ਸ਼ਾਮਲ ਕਰੋ';
	@override String get addedToJourney => 'ਯਾਤਰਾ ਵਿੱਚ ਸ਼ਾਮਲ ਕੀਤਾ ਗਿਆ';
	@override String get getDirections => 'ਦਿਸ਼ਾ-ਨਿਰਦੇਸ਼ ਲਵੋ';
	@override String get viewInMap => 'ਮੈਪ ’ਤੇ ਦੇਖੋ';
	@override String get directions => 'ਦਿਸ਼ਾਵਾਂ';
	@override String get photoGallery => 'ਫੋਟੋ ਗੈਲਰੀ';
	@override String get viewAll => 'ਸਭ ਵੇਖੋ';
	@override String get photoSavedToGallery => 'ਫੋਟੋ ਗੈਲਰੀ ਵਿੱਚ ਸੇਵ ਕੀਤੀ ਗਈ';
	@override String get sacredSoundscape => 'ਪਵਿੱਤਰ ਸਾਊਂਡਸਕੇਪ';
	@override String get allDiscussions => 'ਸਾਰੀਆਂ ਚਰਚਾਵਾਂ';
	@override String get journeyTab => 'ਯਾਤਰਾ';
	@override String get discussionTab => 'ਚਰਚਾ';
	@override String get myActivity => 'ਮੇਰੀ ਸਰਗਰਮੀ';
	@override String get anonymousPilgrim => 'ਅਣਨਾਂ ਤੀਰਥਯਾਤਰੀ';
	@override String get viewProfile => 'ਪ੍ਰੋਫ਼ਾਈਲ ਵੇਖੋ';
	@override String get discussionTitleHint => 'ਚਰਚਾ ਦਾ ਸਿਰਲੇਖ...';
	@override String get shareYourThoughtsHint => 'ਆਪਣੀਆਂ ਸੋਚਾਂ ਸਾਂਝੀਆਂ ਕਰੋ...';
	@override String get pleaseEnterDiscussionTitle => 'ਕਿਰਪਾ ਕਰਕੇ ਚਰਚਾ ਦਾ ਸਿਰਲੇਖ ਲਿਖੋ';
	@override String get addReflection => 'ਅਨੁਭਵ ਜੋੜੋ';
	@override String get reflectionTitle => 'ਸਿਰਲੇਖ';
	@override String get enterReflectionTitle => 'ਅਨੁਭਵ ਦਾ ਸਿਰਲੇਖ ਲਿਖੋ';
	@override String get pleaseEnterTitle => 'ਕਿਰਪਾ ਕਰਕੇ ਸਿਰਲੇਖ ਲਿਖੋ';
	@override String get siteName => 'ਸਥਾਨ ਦਾ ਨਾਮ';
	@override String get enterSacredSiteName => 'ਪਵਿੱਤਰ ਸਥਾਨ ਦਾ ਨਾਮ ਲਿਖੋ';
	@override String get pleaseEnterSiteName => 'ਕਿਰਪਾ ਕਰਕੇ ਸਥਾਨ ਦਾ ਨਾਮ ਲਿਖੋ';
	@override String get reflection => 'ਅਨੁਭਵ';
	@override String get reflectionHint => 'ਆਪਣੇ ਅਨੁਭਵ ਅਤੇ ਵਿਚਾਰ ਸਾਂਝੇ ਕਰੋ...';
	@override String get pleaseEnterReflection => 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਅਨੁਭਵ ਲਿਖੋ';
	@override String get saveReflection => 'ਅਨੁਭਵ ਸੇਵ ਕਰੋ';
	@override String get journeyProgress => 'ਯਾਤਰਾ ਦੀ ਪ੍ਰਗਤੀ';
	@override late final _TranslationsMapDiscussionsPa discussions = _TranslationsMapDiscussionsPa._(_root);
	@override late final _TranslationsMapFabricMapPa fabricMap = _TranslationsMapFabricMapPa._(_root);
	@override late final _TranslationsMapClassicalArtMapPa classicalArtMap = _TranslationsMapClassicalArtMapPa._(_root);
	@override late final _TranslationsMapClassicalDanceMapPa classicalDanceMap = _TranslationsMapClassicalDanceMapPa._(_root);
	@override late final _TranslationsMapFoodMapPa foodMap = _TranslationsMapFoodMapPa._(_root);
}

// Path: community
class _TranslationsCommunityPa extends TranslationsCommunityEn {
	_TranslationsCommunityPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ਕਮਿਊਨਟੀ';
	@override String get trending => 'ਟ੍ਰੈਂਡਿੰਗ';
	@override String get following => 'ਫਾਲੋ ਕਰ ਰਹੇ ਹੋ';
	@override String get followers => 'ਫਾਲੋਅਰ';
	@override String get posts => 'ਪੋਸਟਾਂ';
	@override String get follow => 'ਫਾਲੋ ਕਰੋ';
	@override String get unfollow => 'ਅਨਫਾਲੋ ਕਰੋ';
	@override String get shareYourStory => 'ਆਪਣੀ ਕਹਾਣੀ ਸਾਂਝੀ ਕਰੋ...';
	@override String get post => 'ਪੋਸਟ ਕਰੋ';
	@override String get like => 'ਪਸੰਦ';
	@override String get comment => 'ਕਮੈਂਟ';
	@override String get comments => 'ਕਮੈਂਟਾਂ';
	@override String get noPostsYet => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਪੋਸਟ ਨਹੀਂ';
}

// Path: discover
class _TranslationsDiscoverPa extends TranslationsDiscoverEn {
	_TranslationsDiscoverPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ਖੋਜੋ';
	@override String get searchHint => 'ਕਹਾਣੀਆਂ, ਵਰਤੋਂਕਾਰ ਜਾਂ ਵਿਸ਼ੇ ਖੋਜੋ...';
	@override String get tryAgain => 'ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ';
	@override String get somethingWentWrong => 'ਕੁਝ ਗਲਤ ਹੋ ਗਿਆ';
	@override String get unableToLoadProfiles => 'ਪ੍ਰੋਫ਼ਾਈਲ ਲੋਡ ਨਹੀਂ ਹੋ ਸਕੇ। ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
	@override String get noProfilesFound => 'ਕੋਈ ਪ੍ਰੋਫ਼ਾਈਲ ਨਹੀਂ ਮਿਲੀ';
	@override String get searchToFindPeople => 'ਫਾਲੋ ਕਰਨ ਲਈ ਲੋਕ ਖੋਜੋ';
	@override String get noResultsFound => 'ਕੋਈ ਨਤੀਜੇ ਨਹੀਂ ਮਿਲੇ';
	@override String get noProfilesYet => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਪ੍ਰੋਫ਼ਾਈਲ ਨਹੀਂ';
	@override String get tryDifferentKeywords => 'ਵੱਖਰੇ ਕੀਵਰਡ ਨਾਲ ਕੋਸ਼ਿਸ਼ ਕਰੋ';
	@override String get beFirstToDiscover => 'ਨਵੇਂ ਲੋਕ ਖੋਜਣ ਵਾਲੇ ਪਹਿਲੇ ਬਣੋ!';
}

// Path: plan
class _TranslationsPlanPa extends TranslationsPlanEn {
	_TranslationsPlanPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'ਆਪਣਾ ਪਲਾਨ ਸੇਵ ਕਰਨ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ';
	@override String get planSaved => 'ਪਲਾਨ ਸੇਵ ਹੋ ਗਿਆ';
	@override String get from => 'ਕਿੱਥੋਂ';
	@override String get dates => 'ਤਾਰੀਖਾਂ';
	@override String get destination => 'ਗੰਤੀ ਸਥਾਨ';
	@override String get nearby => 'ਨੇੜੇ';
	@override String get generatedPlan => 'ਤਿਆਰ ਕੀਤਾ ਪਲਾਨ';
	@override String get whereTravellingFrom => 'ਤੁਸੀਂ ਕਿੱਥੋਂ ਯਾਤਰਾ ਕਰ ਰਹੇ ਹੋ?';
	@override String get enterCityOrRegion => 'ਆਪਣਾ ਸ਼ਹਿਰ ਜਾਂ ਖੇਤਰ ਲਿਖੋ';
	@override String get travelDates => 'ਯਾਤਰਾ ਦੀਆਂ ਤਾਰੀਖਾਂ';
	@override String get destinationSacredSite => 'ਗੰਤੀ ਸਥਾਨ (ਪਵਿੱਤਰ ਸਥਾਨ)';
	@override String get searchOrSelectDestination => 'ਗੰਤੀ ਸਥਾਨ ਖੋਜੋ ਜਾਂ ਚੁਣੋ...';
	@override String get shareYourExperience => 'ਆਪਣਾ ਅਨੁਭਵ ਸਾਂਝਾ ਕਰੋ';
	@override String get planShared => 'ਪਲਾਨ ਸਾਂਝਾ ਕਰ ਦਿੱਤਾ ਗਿਆ';
	@override String failedToSharePlan({required Object error}) => 'ਪਲਾਨ ਸਾਂਝਾ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: ${error}';
	@override String get planUpdated => 'ਪਲਾਨ ਅੱਪਡੇਟ ਹੋ ਗਿਆ';
	@override String failedToUpdatePlan({required Object error}) => 'ਪਲਾਨ ਅੱਪਡੇਟ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: ${error}';
	@override String get deletePlanConfirm => 'ਕੀ ਪਲਾਨ ਮਿਟਾਉਣਾ ਹੈ?';
	@override String get thisPlanPermanentlyDeleted => 'ਇਹ ਪਲਾਨ ਸਥਾਈ ਤੌਰ ’ਤੇ ਮਿਟਾ ਦਿੱਤਾ ਜਾਵੇਗਾ।';
	@override String get planDeleted => 'ਪਲਾਨ ਮਿਟਾ ਦਿੱਤਾ ਗਿਆ';
	@override String failedToDeletePlan({required Object error}) => 'ਪਲਾਨ ਮਿਟਾਉਣ ਵਿੱਚ ਅਸਫਲ: ${error}';
	@override String get sharePlan => 'ਪਲਾਨ ਸਾਂਝਾ ਕਰੋ';
	@override String get deletePlan => 'ਪਲਾਨ ਮਿਟਾਓ';
	@override String get savedPlanDetails => 'ਸੰਭਾਲੇ ਹੋਏ ਪਲਾਨ ਦੇ ਵੇਰਵੇ';
	@override String get pilgrimagePlan => 'ਤੀਰਥ ਯਾਤਰਾ ਯੋਜਨਾ';
	@override String get planTab => 'ਯੋਜਨਾ';
}

// Path: settings
class _TranslationsSettingsPa extends TranslationsSettingsEn {
	_TranslationsSettingsPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ਸੈਟਿੰਗਜ਼';
	@override String get language => 'ਭਾਸ਼ਾ';
	@override String get theme => 'ਥੀਮ';
	@override String get themeLight => 'ਲਾਈਟ';
	@override String get themeDark => 'ਡਾਰਕ';
	@override String get themeSystem => 'ਸਿਸਟਮ ਥੀਮ ਵਰਤੋ';
	@override String get darkMode => 'ਡਾਰਕ ਮੋਡ';
	@override String get selectLanguage => 'ਭਾਸ਼ਾ ਚੁਣੋ';
	@override String get notifications => 'ਨੋਟਿਫਿਕੇਸ਼ਨ';
	@override String get cacheSettings => 'ਕੈਸ਼ ਅਤੇ ਸਟੋਰੇਜ';
	@override String get general => 'ਜਨਰਲ';
	@override String get account => 'ਖਾਤਾ';
	@override String get blockedUsers => 'ਬਲੌਕ ਕੀਤੇ ਵਰਤੋਂਕਾਰ';
	@override String get helpSupport => 'ਮਦਦ ਅਤੇ ਸਹਾਇਤਾ';
	@override String get contactUs => 'ਸਾਡੇ ਨਾਲ ਸੰਪਰਕ ਕਰੋ';
	@override String get legal => 'ਕਾਨੂੰਨੀ';
	@override String get privacyPolicy => 'ਪਰਦੇਦਾਰੀ ਨੀਤੀ';
	@override String get termsConditions => 'ਨਿਯਮ ਅਤੇ ਸ਼ਰਤਾਂ';
	@override String get privacy => 'ਪਰਦੇਦਾਰੀ';
	@override String get about => 'ਐਪ ਬਾਰੇ';
	@override String get version => 'ਵਰਜਨ';
	@override String get logout => 'ਲਾਗਆਊਟ';
	@override String get deleteAccount => 'ਖਾਤਾ ਮਿਟਾਓ';
	@override String get deleteAccountTitle => 'ਖਾਤਾ ਮਿਟਾਓ';
	@override String get deleteAccountWarning => 'ਇਸ ਕਾਰਵਾਈ ਨੂੰ ਵਾਪਸ ਨਹੀਂ ਕੀਤਾ ਜਾ ਸਕਦਾ!';
	@override String get deleteAccountDescription => 'ਖਾਤਾ ਮਿਟਾਉਣ ਨਾਲ ਤੁਹਾਡੀਆਂ ਸਾਰੀਆਂ ਪੋਸਟਾਂ, ਕਮੈਂਟ, ਪ੍ਰੋਫ਼ਾਈਲ, ਫਾਲੋਅਰ, ਸੰਭਾਲੀਆਂ ਕਹਾਣੀਆਂ, ਬੁੱਕਮਾਰਕ, ਚੈਟ ਸੁਨੇਹੇ ਅਤੇ ਬਣਾਈਆਂ ਕਹਾਣੀਆਂ ਸਥਾਈ ਤੌਰ ’ਤੇ ਮਿਟ ਜਾ ਕੇਂਗੀਆਂ।';
	@override String get confirmPassword => 'ਆਪਣਾ ਪਾਸਵਰਡ ਪੁਸ਼ਟੀ ਕਰੋ';
	@override String get confirmPasswordDesc => 'ਖਾਤਾ ਮਿਟਾਉਣ ਦੀ ਪੁਸ਼ਟੀ ਕਰਨ ਲਈ ਆਪਣਾ ਪਾਸਵਰਡ ਲਿਖੋ।';
	@override String get googleReauth => 'ਤੁਹਾਡੀ ਪਹਿਚਾਣ ਦੀ ਪੁਸ਼ਟੀ ਕਰਨ ਲਈ ਤੁਹਾਨੂੰ Google ’ਤੇ ਲਿਜਾਇਆ ਜਾਵੇਗਾ।';
	@override String get finalConfirmationTitle => 'ਅੰਤਿਮ ਪੁਸ਼ਟੀ';
	@override String get finalConfirmation => 'ਕੀ ਤੁਸੀਂ ਪੂਰੀ ਤਰ੍ਹਾਂ ਯਕੀਨੀ ਹੋ? ਇਹ ਸਥਾਈ ਹੈ ਅਤੇ ਇਸਨੂੰ ਵਾਪਸ ਨਹੀਂ ਕੀਤਾ ਜਾ ਸਕਦਾ।';
	@override String get deleteMyAccount => 'ਮੇਰਾ ਖਾਤਾ ਮਿਟਾਓ';
	@override String get deletingAccount => 'ਖਾਤਾ ਮਿਟਾਇਆ ਜਾ ਰਿਹਾ ਹੈ...';
	@override String get accountDeleted => 'ਤੁਹਾਡਾ ਖਾਤਾ ਸਥਾਈ ਤੌਰ ’ਤੇ ਮਿਟਾ ਦਿੱਤਾ ਗਿਆ ਹੈ।';
	@override String get deleteAccountFailed => 'ਖਾਤਾ ਮਿਟਾਉਣ ਵਿੱਚ ਅਸਫਲ। ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
	@override String get downloadedStories => 'ਡਾਊਨਲੋਡ ਕੀਤੀਆਂ ਕਹਾਣੀਆਂ';
	@override String get couldNotOpenEmail => 'ਈਮੇਲ ਐਪ ਨਹੀਂ ਖੁੱਲ ਸਕੀ। ਕਿਰਪਾ ਕਰਕੇ ਸਾਨੂੰ myitihas@gmail.com ’ਤੇ ਈਮੇਲ ਕਰੋ।';
	@override String couldNotOpenLabel({required Object label}) => '${label} ਇਸ ਵੇਲੇ ਨਹੀਂ ਖੁੱਲ ਸਕਦੀ।';
	@override String get logoutTitle => 'ਲਾਗਆਊਟ';
	@override String get logoutConfirm => 'ਕੀ ਤੁਸੀਂ ਯਕੀਨਨ ਲਾਗਆਊਟ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?';
	@override String get verifyYourIdentity => 'ਆਪਣੀ ਪਹਿਚਾਣ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ';
	@override String get verifyYourIdentityDesc => 'ਤੁਹਾਡੀ ਪਹਿਚਾਣ ਦੀ ਪੁਸ਼ਟੀ ਕਰਨ ਲਈ ਤੁਹਾਨੂੰ Google ਨਾਲ ਸਾਈਨ ਇਨ ਕਰਨ ਲਈ ਕਿਹਾ ਜਾਵੇਗਾ।';
	@override String get continueWithGoogle => 'Google ਨਾਲ ਜਾਰੀ ਰੱਖੋ';
	@override String reauthFailed({required Object error}) => 'ਮੁੜ-ਪ੍ਰਮਾਣਕਰਨ ਅਸਫਲ: ${error}';
	@override String get passwordRequired => 'ਪਾਸਵਰਡ ਲਾਜ਼ਮੀ ਹੈ';
	@override String get invalidPassword => 'ਗਲਤ ਪਾਸਵਰਡ। ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
	@override String get verify => 'ਪੁਸ਼ਟੀ ਕਰੋ';
	@override String get continueLabel => 'ਜਾਰੀ ਰੱਖੋ';
	@override String get unableToVerifyIdentity => 'ਪਹਿਚਾਣ ਦੀ ਪੁਸ਼ਟੀ ਨਹੀਂ ਕੀਤੀ ਜਾ ਸਕੀ। ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
}

// Path: auth
class _TranslationsAuthPa extends TranslationsAuthEn {
	_TranslationsAuthPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get login => 'ਲਾਗਇਨ';
	@override String get signup => 'ਸਾਈਨ ਅਪ';
	@override String get email => 'ਈਮੇਲ';
	@override String get password => 'ਪਾਸਵਰਡ';
	@override String get confirmPassword => 'ਪਾਸਵਰਡ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ';
	@override String get forgotPassword => 'ਪਾਸਵਰਡ ਭੁੱਲ ਗਏ?';
	@override String get resetPassword => 'ਪਾਸਵਰਡ ਰੀਸੈੱਟ ਕਰੋ';
	@override String get dontHaveAccount => 'ਕੀ ਤੁਹਾਡਾ ਖਾਤਾ ਨਹੀਂ?';
	@override String get alreadyHaveAccount => 'ਕੀ ਪਹਿਲਾਂ ਹੀ ਖਾਤਾ ਹੈ?';
	@override String get loginSuccess => 'ਲਾਗਇਨ ਸਫਲ';
	@override String get signupSuccess => 'ਸਾਈਨ ਅਪ ਸਫਲ';
	@override String get loginError => 'ਲਾਗਇਨ ਅਸਫਲ';
	@override String get signupError => 'ਸਾਈਨ ਅਪ ਅਸਫਲ';
}

// Path: error
class _TranslationsErrorPa extends TranslationsErrorEn {
	_TranslationsErrorPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get network => 'ਇੰਟਰਨੈਟ ਕਨੈਕਸ਼ਨ ਨਹੀਂ ਹੈ';
	@override String get server => 'ਸਰਵਰ ਤੇ ਗਲਤੀ ਆਈ ਹੈ';
	@override String get cache => 'ਸੰਭਾਲਿਆ ਡਾਟਾ ਲੋਡ ਕਰਨ ਵਿੱਚ ਅਸਫਲ';
	@override String get timeout => 'ਅਨੁਰੋਧ ਦਾ ਸਮਾਂ ਖਤਮ';
	@override String get notFound => 'ਸਰੋਤ ਨਹੀਂ ਮਿਲਿਆ';
	@override String get validation => 'ਤਸਦੀਕ ਅਸਫਲ';
	@override String get unexpected => 'ਅਣਉਮੀਦ ਗਲਤੀ ਆਈ ਹੈ';
	@override String get tryAgain => 'ਕਿਰਪਾ ਕਰਕੇ ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ';
	@override String couldNotOpenLink({required Object url}) => 'ਲਿੰਕ ਨਹੀਂ ਖੋਲ੍ਹ ਸਕੇ: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionPa extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get free => 'ਮੁਫ਼ਤ';
	@override String get plus => 'ਪਲੱਸ';
	@override String get pro => 'ਪ੍ਰੋ';
	@override String get upgradeToPro => 'ਪ੍ਰੋ ’ਤੇ ਅਪਗ੍ਰੇਡ ਕਰੋ';
	@override String get features => 'ਫੀਚਰ';
	@override String get subscribe => 'ਸਬਸਕ੍ਰਾਈਬ ਕਰੋ';
	@override String get currentPlan => 'ਮੌਜੂਦਾ ਯੋਜਨਾ';
	@override String get managePlan => 'ਯੋਜਨਾ ਮੈਨੇਜ ਕਰੋ';
}

// Path: notification
class _TranslationsNotificationPa extends TranslationsNotificationEn {
	_TranslationsNotificationPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ਨੋਟਿਫਿਕੇਸ਼ਨ';
	@override String get peopleToConnect => 'ਜਿਨ੍ਹਾਂ ਨਾਲ ਜੁੜਨਾ ਹੈ';
	@override String get peopleToConnectSubtitle => 'ਫਾਲੋ ਕਰਨ ਲਈ ਲੋਕ ਲੱਭੋ';
	@override String followAgainInMinutes({required Object minutes}) => 'ਤੁਸੀਂ ${minutes} ਮਿੰਟ ਵਿੱਚ ਮੁੜ ਫਾਲੋ ਕਰ ਸਕਦੇ ਹੋ';
	@override String get noSuggestions => 'ਇਸ ਵੇਲੇ ਕੋਈ ਸੁਝਾਅ ਨਹੀਂ';
	@override String get markAllRead => 'ਸਭ ਨੂੰ ਪੜ੍ਹਿਆ ਹੋਇਆ ਚਿੰਨ੍ਹਿਤ ਕਰੋ';
	@override String get noNotifications => 'ਹਾਲੇ ਤੱਕ ਕੋਈ ਨੋਟਿਫਿਕੇਸ਼ਨ ਨਹੀਂ';
	@override String get noNotificationsSubtitle => 'ਜਦੋਂ ਕੋਈ ਤੁਹਾਡੀਆਂ ਕਹਾਣੀਆਂ ਨਾਲ ਗੱਲਬਾਤ ਕਰੇਗਾ, ਤੁਸੀਂ ਇੱਥੇ ਵੇਖੋਗੇ';
	@override String get errorPrefix => 'ਗਲਤੀ:';
	@override String get retry => 'ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ';
	@override String likedYourStory({required Object actorName}) => '${actorName} ਨੇ ਤੁਹਾਡੀ ਕਹਾਣੀ ਨੂੰ ਪਸੰਦ ਕੀਤਾ';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} ਨੇ ਤੁਹਾਡੀ ਕਹਾਣੀ ’ਤੇ ਕਮੈਂਟ ਕੀਤਾ';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} ਨੇ ਤੁਹਾਡੇ ਕਮੈਂਟ ਦਾ ਜਵਾਬ ਦਿੱਤਾ';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} ਨੇ ਤੁਹਾਨੂੰ ਫਾਲੋ ਕਰਨਾ ਸ਼ੁਰੂ ਕੀਤਾ';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} ਨੇ ਤੁਹਾਨੂੰ ਸੁਨੇਹਾ ਭੇਜਿਆ';
	@override String sharedYourStory({required Object actorName}) => '${actorName} ਨੇ ਤੁਹਾਡੀ ਕਹਾਣੀ ਸਾਂਝੀ ਕੀਤੀ';
	@override String repostedYourStory({required Object actorName}) => '${actorName} ਨੇ ਤੁਹਾਡੀ ਕਹਾਣੀ ਮੁੜ ਪੋਸਟ ਕੀਤੀ';
	@override String mentionedYou({required Object actorName}) => '${actorName} ਨੇ ਤੁਹਾਨੂੰ ਜ਼ਿਕਰ ਕੀਤਾ';
	@override String newPostFrom({required Object actorName}) => '${actorName} ਦੀ ਨਵੀਂ ਪੋਸਟ';
	@override String get today => 'ਅੱਜ';
	@override String get thisWeek => 'ਇਸ ਹਫ਼ਤੇ';
	@override String get earlier => 'ਪਹਿਲਾਂ';
	@override String get delete => 'ਮਿਟਾਓ';
}

// Path: profile
class _TranslationsProfilePa extends TranslationsProfileEn {
	_TranslationsProfilePa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get followers => 'ਫਾਲੋਅਰ';
	@override String get following => 'ਫਾਲੋ ਕਰ ਰਹੇ ਹੋ';
	@override String get unfollow => 'ਅਨਫਾਲੋ ਕਰੋ';
	@override String get follow => 'ਫਾਲੋ ਕਰੋ';
	@override String get about => 'ਬਾਰੇ';
	@override String get stories => 'ਕਹਾਣੀਆਂ';
	@override String get unableToShareImage => 'ਚਿੱਤਰ ਸਾਂਝਾ ਨਹੀਂ ਕੀਤਾ ਜਾ ਸਕਿਆ';
	@override String get imageSavedToPhotos => 'ਚਿੱਤਰ ਫੋਟੋਜ਼ ਵਿੱਚ ਸੇਵ ਹੋ ਗਿਆ';
	@override String get view => 'ਦੇਖੋ';
	@override String get saveToPhotos => 'ਫੋਟੋਜ਼ ਵਿੱਚ ਸੇਵ ਕਰੋ';
	@override String get failedToLoadImage => 'ਚਿੱਤਰ ਲੋਡ ਕਰਨ ਵਿੱਚ ਅਸਫਲ';
}

// Path: feed
class _TranslationsFeedPa extends TranslationsFeedEn {
	_TranslationsFeedPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get loading => 'ਕਹਾਣੀਆਂ ਲੋਡ ਹੋ ਰਹੀਆਂ ਹਨ...';
	@override String get loadingPosts => 'ਪੋਸਟਾਂ ਲੋਡ ਹੋ ਰਹੀਆਂ ਹਨ...';
	@override String get loadingVideos => 'ਵੀਡੀਓਜ਼ ਲੋਡ ਹੋ ਰਹੀਆਂ ਹਨ...';
	@override String get loadingStories => 'ਕਹਾਣੀਆਂ ਲੋਡ ਹੋ ਰਹੀਆਂ ਹਨ...';
	@override String get errorTitle => 'ਅਰੇ! ਕੁਝ ਗਲਤ ਹੋ ਗਿਆ';
	@override String get tryAgain => 'ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ';
	@override String get noStoriesAvailable => 'ਕੋਈ ਕਹਾਣੀ ਉਪਲਬਧ ਨਹੀਂ';
	@override String get noImagesAvailable => 'ਕੋਈ ਚਿੱਤਰ ਪੋਸਟ ਉਪਲਬਧ ਨਹੀਂ';
	@override String get noTextPostsAvailable => 'ਕੋਈ ਟੈਕਸਟ ਪੋਸਟ ਉਪਲਬਧ ਨਹੀਂ';
	@override String get noContentAvailable => 'ਕੋਈ ਸਮੱਗਰੀ ਉਪਲਬਧ ਨਹੀਂ';
	@override String get refresh => 'ਰਿਫਰੈਸ਼ ਕਰੋ';
	@override String get comments => 'ਕਮੈਂਟਾਂ';
	@override String get commentsComingSoon => 'ਕਮੈਂਟ ਜਲਦੀ ਆ ਰਹੇ ਹਨ';
	@override String get addCommentHint => 'ਕਮੈਂਟ ਜੋੜੋ...';
	@override String get shareStory => 'ਕਹਾਣੀ ਸਾਂਝੀ ਕਰੋ';
	@override String get sharePost => 'ਪੋਸਟ ਸਾਂਝੀ ਕਰੋ';
	@override String get shareThought => 'ਵਿਚਾਰ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareAsImage => 'ਚਿੱਤਰ ਵਜੋਂ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareAsImageSubtitle => 'ਇੱਕ ਸੁੰਦਰ ਪ੍ਰਿਵਿਊ ਕਾਰਡ ਬਣਾਓ';
	@override String get shareLink => 'ਲਿੰਕ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareLinkSubtitle => 'ਕਹਾਣੀ ਦਾ ਲਿੰਕ ਕਾਪੀ ਜਾਂ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareImageLinkSubtitle => 'ਪੋਸਟ ਦਾ ਲਿੰਕ ਕਾਪੀ ਜਾਂ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareTextLinkSubtitle => 'ਵਿਚਾਰ ਦਾ ਲਿੰਕ ਕਾਪੀ ਜਾਂ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareAsText => 'ਟੈਕਸਟ ਵਜੋਂ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareAsTextSubtitle => 'ਕਹਾਣੀ ਦਾ ਹਿੱਸਾ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareQuote => 'ਕੋਟ ਸਾਂਝੀ ਕਰੋ';
	@override String get shareQuoteSubtitle => 'ਕੋਟ ਵਜੋਂ ਸਾਂਝੀ ਕਰੋ';
	@override String get shareWithImage => 'ਚਿੱਤਰ ਦੇ ਨਾਲ ਸਾਂਝਾ ਕਰੋ';
	@override String get shareWithImageSubtitle => 'ਚਿੱਤਰ ਅਤੇ ਕੈਪਸ਼ਨ ਇਕੱਠੇ ਸਾਂਝੇ ਕਰੋ';
	@override String get copyLink => 'ਲਿੰਕ ਕਾਪੀ ਕਰੋ';
	@override String get copyLinkSubtitle => 'ਲਿੰਕ ਕਲਿਪਬੋਰਡ ’ਤੇ ਕਾਪੀ ਕਰੋ';
	@override String get copyText => 'ਟੈਕਸਟ ਕਾਪੀ ਕਰੋ';
	@override String get copyTextSubtitle => 'ਕੋਟ ਕਲਿਪਬੋਰਡ ’ਤੇ ਕਾਪੀ ਕਰੋ';
	@override String get linkCopied => 'ਲਿੰਕ ਕਲਿਪਬੋਰਡ ’ਤੇ ਕਾਪੀ ਹੋ ਗਿਆ';
	@override String get textCopied => 'ਟੈਕਸਟ ਕਲਿਪਬੋਰਡ ’ਤੇ ਕਾਪੀ ਹੋ ਗਿਆ';
	@override String get sendToUser => 'ਵਰਤੋਂਕਾਰ ਨੂੰ ਭੇਜੋ';
	@override String get sendToUserSubtitle => 'ਦੋਸਤ ਨਾਲ ਸਿੱਧਾ ਸਾਂਝਾ ਕਰੋ';
	@override String get chooseFormat => 'ਫਾਰਮੈਟ ਚੁਣੋ';
	@override String get linkPreview => 'ਲਿੰਕ ਪ੍ਰਿਵਿਊ';
	@override String get linkPreviewSize => '1200 × 630';
	@override String get storyFormat => 'ਸਟੋਰੀ ਫਾਰਮੈਟ';
	@override String get storyFormatSize => '1080 × 1920 (Instagram/Stories)';
	@override String get generatingPreview => 'ਪ੍ਰਿਵਿਊ ਤਿਆਰ ਕੀਤਾ ਜਾ ਰਿਹਾ ਹੈ...';
	@override String get bookmarked => 'ਬੁੱਕਮਾਰਕ ਕੀਤਾ ਗਿਆ';
	@override String get removedFromBookmarks => 'ਬੁੱਕਮਾਰਕ ਤੋਂ ਹਟਾਇਆ ਗਿਆ';
	@override String unlike({required Object count}) => 'ਅਨਲਾਈਕ, ${count} ਪਸੰਦਾਂ';
	@override String like({required Object count}) => 'ਲਾਈਕ, ${count} ਪਸੰਦਾਂ';
	@override String commentCount({required Object count}) => '${count} ਕਮੈਂਟਾਂ';
	@override String shareCount({required Object count}) => 'ਸਾਂਝਾ ਕਰੋ, ${count} ਵਾਰੀ ਸਾਂਝਾ';
	@override String get removeBookmark => 'ਬੁੱਕਮਾਰਕ ਹਟਾਓ';
	@override String get addBookmark => 'ਬੁੱਕਮਾਰਕ ਕਰੋ';
	@override String get quote => 'ਕੋਟ';
	@override String get quoteCopied => 'ਕੋਟ ਕਲਿਪਬੋਰਡ ’ਤੇ ਕਾਪੀ ਹੋ ਗਿਆ';
	@override String get copy => 'ਕਾਪੀ ਕਰੋ';
	@override String get tapToViewFullQuote => 'ਪੂਰਾ ਕੋਟ ਵੇਖਣ ਲਈ ਟੈਪ ਕਰੋ';
	@override String get quoteFromMyitihas => 'MyItihas ਤੋਂ ਕੋਟ';
	@override late final _TranslationsFeedTabsPa tabs = _TranslationsFeedTabsPa._(_root);
	@override String get tapToShowCaption => 'ਕੈਪਸ਼ਨ ਵੇਖਣ ਲਈ ਟੈਪ ਕਰੋ';
	@override String get noVideosAvailable => 'ਕੋਈ ਵੀਡੀਓ ਉਪਲਬਧ ਨਹੀਂ';
	@override String get selectUser => 'ਕਿਸਨੂੰ ਭੇਜਣਾ ਹੈ';
	@override String get searchUsers => 'ਵਰਤੋਂਕਾਰ ਖੋਜੋ...';
	@override String get noFollowingYet => 'ਤੁਸੀਂ ਹਾਲੇ ਤੱਕ ਕਿਸੇ ਨੂੰ ਫਾਲੋ ਨਹੀਂ ਕਰ ਰਹੇ';
	@override String get noUsersFound => 'ਕੋਈ ਵਰਤੋਂਕਾਰ ਨਹੀਂ ਮਿਲਿਆ';
	@override String get tryDifferentSearch => 'ਵੱਖਰਾ ਖੋਜ ਸ਼ਬਦ ਕੋਸ਼ਿਸ਼ ਕਰੋ';
	@override String sentTo({required Object username}) => '${username} ਨੂੰ ਭੇਜਿਆ ਗਿਆ';
}

// Path: voice
class _TranslationsVoicePa extends TranslationsVoiceEn {
	_TranslationsVoicePa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'ਮਾਈਕਰੋਫ਼ੋਨ ਦੀ ਇਜਾਜ਼ਤ ਲਾਜ਼ਮੀ ਹੈ';
	@override String get speechRecognitionNotAvailable => 'ਸਪੀਚ ਰਿਕਗਨਿਸ਼ਨ ਉਪਲਬਧ ਨਹੀਂ';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsPa extends TranslationsFestivalsEn {
	_TranslationsFestivalsPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ਤਿਉਹਾਰ ਦੀਆਂ ਕਹਾਣੀਆਂ';
	@override String get tellStory => 'ਕਹਾਣੀ ਸੁਣਾਓ';
}

// Path: social
class _TranslationsSocialPa extends TranslationsSocialEn {
	_TranslationsSocialPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialCreatePostPa createPost = _TranslationsSocialCreatePostPa._(_root);
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroPa extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'ਖੋਜ ਲਈ ਟੈਪ ਕਰੋ';
	@override late final _TranslationsHomeScreenHeroStoryPa story = _TranslationsHomeScreenHeroStoryPa._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionPa companion = _TranslationsHomeScreenHeroCompanionPa._(_root);
	@override late final _TranslationsHomeScreenHeroHeritagePa heritage = _TranslationsHomeScreenHeroHeritagePa._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityPa community = _TranslationsHomeScreenHeroCommunityPa._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesPa messages = _TranslationsHomeScreenHeroMessagesPa._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthPa extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get short => 'ਛੋਟੀ';
	@override String get medium => 'ਦਰਮਿਆਨੀ';
	@override String get long => 'ਲੰਮੀ';
	@override String get epic => 'ਮਹਾਕਾਵਿਕ';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatPa extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'ਬਰਨਣਾਤਮਕ';
	@override String get dialogue => 'ਸੰਵਾਦ-ਆਧਾਰਤ';
	@override String get poetic => 'ਕਾਵਿ ਰੂਪ';
	@override String get scriptural => 'ਸ਼ਾਸਤਰੀ';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsPa extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'ਕ੍ਰਿਸ਼ਨ ਦੇ ਅਰਜੁਨ ਨੂੰ ਸਿੱਖਿਆ ਦੇਣ ਦੀ ਕਹਾਣੀ ਦੱਸੋ...';
	@override String get warriorRedemption => 'ਇੱਕ ਯੋਧੇ ਦੀ ਪ੍ਰਾਇਸ਼ਚਿੱਤ ਦੀ ਯਾਤਰਾ ਬਾਰੇ ਮਹਾਕਾਵਿਕ ਕਹਾਣੀ ਲਿਖੋ...';
	@override String get sageWisdom => 'ਰਿਸ਼ੀਆਂ ਦੀ ਸਿਆਣਪ ਬਾਰੇ ਕਹਾਣੀ ਬਣਾਓ...';
	@override String get devotedSeeker => 'ਇੱਕ ਭਗਤ ਖੋਜੀ ਦੀ ਯਾਤਰਾ ਬਿਆਨ ਕਰੋ...';
	@override String get divineIntervention => 'ਦਿਵਿਆ ਹਸਤਖੇਪ ਬਾਰੇ ਦੰਤੀਕਥਾ ਸਾਂਝੀ ਕਰੋ...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsPa extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'ਕਿਰਪਾ ਕਰਕੇ ਸਾਰੇ ਲਾਜ਼ਮੀ ਵਿਕਲਪ ਪੂਰੇ ਕਰੋ';
	@override String get generationFailed => 'ਕਹਾਣੀ ਬਣਾਉਣ ਵਿੱਚ ਅਸਫਲ। ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsPa extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  ਸਤ ਸ੍ਰੀ ਅਕਾਲ!';
	@override String get dharma => '📖  ਧਰਮ ਕੀ ਹੈ?';
	@override String get stress => '🧘  ਤਣਾਅ ਨੂੰ ਕਿਵੇਂ ਸੰਭਾਲੀਏ';
	@override String get karma => '⚡  ਕਰਮ ਨੂੰ ਸੌਖੇ ਤਰੀਕੇ ਨਾਲ ਸਮਝਾਓ';
	@override String get story => '💬  ਮੈਨੂੰ ਇੱਕ ਕਹਾਣੀ ਸੁਣਾਓ';
	@override String get wisdom => '🌟  ਅੱਜ ਦੀ ਸਿਆਣਪ';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsPa extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

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
class _TranslationsMapDiscussionsPa extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'ਚਰਚਾ ਪੋਸਟ ਕਰੋ';
	@override String get intentCardCta => 'ਇੱਕ ਚਰਚਾ ਪੋਸਟ ਕਰੋ';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapPa extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapPa extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapPa extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

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
class _TranslationsMapFoodMapPa extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

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
class _TranslationsFeedTabsPa extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get all => 'ਸਾਰੀਆਂ';
	@override String get stories => 'ਕਹਾਣੀਆਂ';
	@override String get posts => 'ਪੋਸਟਾਂ';
	@override String get videos => 'ਵੀਡੀਓਜ਼';
	@override String get images => 'ਫੋਟੋ';
	@override String get text => 'ਵਿਚਾਰ';
}

// Path: social.createPost
class _TranslationsSocialCreatePostPa extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String trimVideoSubtitle({required Object max}) => 'ਵੱਧ ਤੋਂ ਵੱਧ ${max}ਸੇ · ਆਪਣਾ ਸਭ ਤੋਂ ਵਧੀਆ ਹਿੱਸਾ ਚੁਣੋ';
	@override String get trimVideoInstructionsTitle => 'ਆਪਣੀ ਕਲਿੱਪ ਟ੍ਰਿਮ ਕਰੋ';
	@override String get trimVideoInstructionsBody => 'ਸ਼ੁਰੂ ਅਤੇ ਅੰਤ ਵਾਲੇ ਹੈਂਡਲ ਖਿੱਚ ਕੇ 30 ਸਕਿੰਟ ਤੱਕ ਦਾ ਹਿੱਸਾ ਚੁਣੋ।';
	@override String get trimStart => 'ਸ਼ੁਰੂ';
	@override String get trimEnd => 'ਅੰਤ';
	@override String get trimSelectionEmpty => 'ਜਾਰੀ ਰੱਖਣ ਲਈ ਵੈਧ ਰੇਂਜ ਚੁਣੋ';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}ਸੇ ਚੁਣਿਆ (${start}–${end}) · ਵੱਧ ਤੋਂ ਵੱਧ ${max}ਸੇ';
	@override String get coverFrame => 'ਕਵਰ ਫਰੇਮ';
	@override String get coverFrameUnavailable => 'ਪ੍ਰੀਵਿਊ ਉਪਲਬਧ ਨਹੀਂ';
	@override String coverFramePosition({required Object time}) => '${time} \'ਤੇ ਕਵਰ';
	@override String get overlayLabel => 'ਵੀਡੀਓ \'ਤੇ ਲਿਖਤ (ਵਿਕਲਪਿਕ)';
	@override String get overlayHint => 'ਛੋਟਾ ਹੂਕ ਜਾਂ ਸਿਰਲੇਖ ਸ਼ਾਮਲ ਕਰੋ';
	@override String get videoEditorCaptionLabel => 'ਕੈਪਸ਼ਨ / ਲਿਖਤ (ਵਿਕਲਪਿਕ)';
	@override String get videoEditorCaptionHint => 'ਜਿਵੇਂ: ਤੁਹਾਡੀ ਰੀਲ ਲਈ ਸਿਰਲੇਖ ਜਾਂ ਹੁੱਕ';
	@override String get videoEditorAspectLabel => 'ਅਨੁਪਾਤ';
	@override String get videoEditorAspectOriginal => 'ਮੂਲ';
	@override String get videoEditorAspectSquare => '੧:੧';
	@override String get videoEditorAspectPortrait => '੯:੧੬';
	@override String get videoEditorAspectLandscape => '੧੬:੯';
	@override String get videoEditorQuickTrim => 'ਤੇਜ਼ ਟ੍ਰਿਮ';
	@override String get videoEditorSpeed => 'ਗਤੀ';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryPa extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ਏਆਈ ਕਹਾਣੀ ਰਚਨਾ';
	@override String get headline => 'ਡੁੱਬ ਜਾਣ ਵਾਲੀਆਂ\nਕਹਾਣੀਆਂ\nਬਣਾਓ';
	@override String get subHeadline => 'ਪ੍ਰਾਚੀਨ ਗਿਆਨ ਨਾਲ ਸੰਚਾਲਿਤ';
	@override String get line1 => '✦  ਕੋਈ ਪਵਿੱਤਰ ਸ਼ਾਸਤਰ ਚੁਣੋ...';
	@override String get line2 => '✦  ਜੀਵੰਤ ਸੈਟਿੰਗ ਚੁਣੋ...';
	@override String get line3 => '✦  ਏਆਈ ਨੂੰ ਮੋਹਕ ਕਹਾਣੀ ਬੁਣਨ ਦਿਓ...';
	@override String get cta => 'ਕਹਾਣੀ ਬਣਾਓ';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionPa extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ਆਧਿਆਤਮਿਕ ਸਾਥੀ';
	@override String get headline => 'ਤੁਹਾਡਾ ਦਿਵਿਆ\nਮਾਰਗਦਰਸ਼ਕ,\nਹਮੇਸ਼ਾ ਨੇੜੇ';
	@override String get subHeadline => 'ਕ੍ਰਿਸ਼ਨ ਦੇ ਗਿਆਨ ਤੋਂ ਪ੍ਰੇਰਿਤ';
	@override String get line1 => '✦  ਇਕ ਦੋਸਤ ਜੋ ਸੱਚਮੁੱਚ ਸੁਣਦਾ ਹੈ...';
	@override String get line2 => '✦  ਜੀਵਨ ਦੇ ਸੰਘਰਸ਼ਾਂ ਲਈ ਗਿਆਨ...';
	@override String get line3 => '✦  ਤੁਹਾਨੂੰ ਉੱਚਾ ਚੁੱਕਣ ਵਾਲੀਆਂ ਗੱਲਾਂ...';
	@override String get cta => 'ਚੈਟ ਸ਼ੁਰੂ ਕਰੋ';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritagePa extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritagePa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ਵਿਰਾਸਤ ਨਕਸ਼ਾ';
	@override String get headline => 'ਸਦੀਵੀ\nਵਿਰਾਸਤ\nਖੋਜੋ';
	@override String get subHeadline => '5000+ ਪਵਿੱਤਰ ਥਾਵਾਂ ਨਕਸ਼ੇ ਵਿੱਚ';
	@override String get line1 => '✦  ਪਵਿੱਤਰ ਥਾਵਾਂ ਦੀ ਖੋਜ ਕਰੋ...';
	@override String get line2 => '✦  ਇਤਿਹਾਸ ਅਤੇ ਲੋਕ ਕਥਾਵਾਂ ਪੜ੍ਹੋ...';
	@override String get line3 => '✦  ਮਾਇਨੇਦਾਰ ਯਾਤਰਾਵਾਂ ਦੀ ਯੋਜਨਾ ਬਣਾਓ...';
	@override String get cta => 'ਨਕਸ਼ਾ ਖੋਜੋ';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityPa extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ਕਮਿਊਨਟੀ ਸਪੇਸ';
	@override String get headline => 'ਸੱਭਿਆਚਾਰ\nਦੁਨੀਆ ਨਾਲ\nਸਾਂਝਾ ਕਰੋ';
	@override String get subHeadline => 'ਜੀਵੰਤ ਵਿਸ਼ਵ ਪੱਧਰੀ ਕਮਿਊਨਟੀ';
	@override String get line1 => '✦  ਪੋਸਟਾਂ ਅਤੇ ਗਹਿਰੀਆਂ ਚਰਚਾਵਾਂ...';
	@override String get line2 => '✦  ਛੋਟੇ ਸੱਭਿਆਚਾਰਕ ਵੀਡੀਓ...';
	@override String get line3 => '✦  ਦੁਨੀਆ ਭਰ ਦੀਆਂ ਕਹਾਣੀਆਂ...';
	@override String get cta => 'ਕਮਿਊਨਟੀ ਨਾਲ ਜੁੜੋ';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesPa extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesPa._(TranslationsPa root) : this._root = root, super.internal(root);

	final TranslationsPa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ਨਿੱਜੀ ਸੁਨੇਹੇ';
	@override String get headline => 'ਮਾਇਨੇਦਾਰ\nਗੱਲਬਾਤ\nਇੱਥੇ ਤੋਂ ਸ਼ੁਰੂ';
	@override String get subHeadline => 'ਨਿੱਜੀ ਅਤੇ ਵਿਚਾਰਸ਼ੀਲ ਥਾਵਾਂ';
	@override String get line1 => '✦  ਸਮਾਨ ਸੋਚ ਵਾਲਿਆਂ ਨਾਲ ਜੁੜੋ...';
	@override String get line2 => '✦  ਵਿਚਾਰਾਂ ਅਤੇ ਕਹਾਣੀਆਂ ਬਾਰੇ ਗੱਲ ਕਰੋ...';
	@override String get line3 => '✦  ਵਿਚਾਰਸ਼ੀਲ ਕਮਿਊਨਟੀ ਬਣਾਓ...';
	@override String get cta => 'ਸੁਨੇਹੇ ਖੋਲ੍ਹੋ';
}
