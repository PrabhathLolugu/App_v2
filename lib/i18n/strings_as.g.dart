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
class TranslationsAs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.as,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <as>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsAs _root = this; // ignore: unused_field

	@override 
	TranslationsAs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAs(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppAs app = _TranslationsAppAs._(_root);
	@override late final _TranslationsCommonAs common = _TranslationsCommonAs._(_root);
	@override late final _TranslationsNavigationAs navigation = _TranslationsNavigationAs._(_root);
	@override late final _TranslationsHomeAs home = _TranslationsHomeAs._(_root);
	@override late final _TranslationsHomeScreenAs homeScreen = _TranslationsHomeScreenAs._(_root);
	@override late final _TranslationsStoriesAs stories = _TranslationsStoriesAs._(_root);
	@override late final _TranslationsStoryGeneratorAs storyGenerator = _TranslationsStoryGeneratorAs._(_root);
	@override late final _TranslationsChatAs chat = _TranslationsChatAs._(_root);
	@override late final _TranslationsMapAs map = _TranslationsMapAs._(_root);
	@override late final _TranslationsCommunityAs community = _TranslationsCommunityAs._(_root);
	@override late final _TranslationsDiscoverAs discover = _TranslationsDiscoverAs._(_root);
	@override late final _TranslationsPlanAs plan = _TranslationsPlanAs._(_root);
	@override late final _TranslationsSettingsAs settings = _TranslationsSettingsAs._(_root);
	@override late final _TranslationsAuthAs auth = _TranslationsAuthAs._(_root);
	@override late final _TranslationsErrorAs error = _TranslationsErrorAs._(_root);
	@override late final _TranslationsSubscriptionAs subscription = _TranslationsSubscriptionAs._(_root);
	@override late final _TranslationsNotificationAs notification = _TranslationsNotificationAs._(_root);
	@override late final _TranslationsProfileAs profile = _TranslationsProfileAs._(_root);
	@override late final _TranslationsFeedAs feed = _TranslationsFeedAs._(_root);
	@override late final _TranslationsVoiceAs voice = _TranslationsVoiceAs._(_root);
	@override late final _TranslationsFestivalsAs festivals = _TranslationsFestivalsAs._(_root);
	@override late final _TranslationsSocialAs social = _TranslationsSocialAs._(_root);
}

// Path: app
class _TranslationsAppAs extends TranslationsAppEn {
	_TranslationsAppAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'ভাৰতীয় শাস্ত্ৰ আবিষ্কাৰ কৰক';
}

// Path: common
class _TranslationsCommonAs extends TranslationsCommonEn {
	_TranslationsCommonAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ঠিক আছে';
	@override String get cancel => 'বাতিল কৰক';
	@override String get confirm => 'নিশ্চিত কৰক';
	@override String get delete => 'মচি পেলাওক';
	@override String get edit => 'সম্পাদনা কৰক';
	@override String get save => 'ছেভ কৰক';
	@override String get share => 'শ্বেয়াৰ কৰক';
	@override String get search => 'সন্ধান কৰক';
	@override String get loading => 'ল\'ড হৈছে...';
	@override String get error => 'ভুল';
	@override String get retry => 'পুনৰ চেষ্টা কৰক';
	@override String get back => 'পিছলৈ';
	@override String get next => 'পিছত';
	@override String get finish => 'সমাপ্ত কৰক';
	@override String get skip => 'এৰি যাওক';
	@override String get yes => 'হঁ';
	@override String get no => 'নহয়';
	@override String get readFullStory => 'সম্পূৰ্ণ কাহিনী পঢ়ক';
	@override String get dismiss => 'বন্ধ কৰক';
	@override String get offlineBannerMessage => 'আপুনি অফলাইন অৱস্থাত আছে – কেশ কৰা বিষয়বস্তু দেখুৱাই আছে';
	@override String get backOnline => 'পুনৰ অনলাইনৰ বাবে সংযোগ হ\'ল';
}

// Path: navigation
class _TranslationsNavigationAs extends TranslationsNavigationEn {
	_TranslationsNavigationAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get home => 'ঘৰ';
	@override String get stories => 'কাহিনী';
	@override String get chat => 'চেট';
	@override String get map => 'মেপ';
	@override String get community => 'সমাজ';
	@override String get settings => 'ছেটিংছ';
	@override String get profile => 'প্ৰফাইল';
}

// Path: home
class _TranslationsHomeAs extends TranslationsHomeEn {
	_TranslationsHomeAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'কাহিনী সৃষ্টি কৰা সঁজুলি';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'সমাজৰ কাহিনী';
	@override String get maps => 'মেপসমূহ';
	@override String get greetingMorning => 'শুভ প্ৰভাত';
	@override String get continueReading => 'পঢ়া অব্যাহত ৰাখক';
	@override String get greetingAfternoon => 'শুভ দুপৰ';
	@override String get greetingEvening => 'শুভ সন্ধিয়া';
	@override String get greetingNight => 'শুভ ৰাতি';
	@override String get exploreStories => 'কাহিনীবোৰ অনুসন্ধান কৰক';
	@override String get generateStory => 'কাহিনী সৃষ্টি কৰক';
	@override String get content => 'ঘৰৰ বিষয়বস্তু';
}

// Path: homeScreen
class _TranslationsHomeScreenAs extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'নমস্কাৰ';
	@override String get quoteOfTheDay => 'আজিৰ চিন্তা';
	@override String get shareQuote => 'চিন্তা শ্বেয়াৰ কৰক';
	@override String get copyQuote => 'চিন্তা কপি কৰক';
	@override String get quoteCopied => 'চিন্তা ক্লিপবর্ডলৈ কপি হ\'ল';
	@override String get featuredStories => 'বাছনি কৰা কাহিনী';
	@override String get quickActions => 'দ্ৰুত কাৰ্য্যসমূহ';
	@override String get generateStory => 'কাহিনী সৃষ্টি কৰক';
	@override String get chatWithKrishna => 'কৃষ্ণৰ সৈতে কথা-বাৰ্তা কৰক';
	@override String get myActivity => 'মোৰ কাৰ্য্যকলাপ';
	@override String get continueReading => 'পঢ়া অব্যাহত ৰাখক';
	@override String get savedStories => 'সংৰক্ষিত কাহিনী';
	@override String get storiesInYourLanguage => 'আপোনাৰ ভাষাত কাহিনী';
	@override String get seeAll => 'সকলো দেখুৱাওক';
	@override String get startReading => 'পঢ়া আৰম্ভ কৰক';
	@override String get exploreStories => 'আপোনাৰ যাত্ৰা আৰম্ভ কৰিবলৈ কাহিনীবোৰ অনুসন্ধান কৰক';
	@override String get saveForLater => 'পছন্দৰ কাহিনীবোৰ বুকমাৰ্ক কৰি থওক';
	@override String get noActivityYet => 'এতিয়ালৈকে কোনো কাৰ্য্যকলাপ নাই';
	@override String minLeft({required Object count}) => '${count} মিনিট বাকী';
	@override String get activityHistory => 'কাৰ্য্যকলাপৰ ইতিহাস';
	@override String get storyGenerated => 'এটা কাহিনী সৃষ্টি হ\'ল';
	@override String get storyRead => 'এটা কাহিনী পঢ়া হ\'ল';
	@override String get storyBookmarked => 'কাহিনী বুকমাৰ্ক কৰা হ\'ল';
	@override String get storyShared => 'কাহিনী শ্বেয়াৰ কৰা হ\'ল';
	@override String get storyCompleted => 'কাহিনী সম্পূৰ্ণ হ\'ল';
	@override String get today => 'আজি';
	@override String get yesterday => 'যোৱাকালি';
	@override String get thisWeek => 'এই সপ্তাহ';
	@override String get earlier => 'আগতে';
	@override String get noContinueReading => 'এতিয়া পঢ়াৰ দৰে একো নাই';
	@override String get noSavedStories => 'এতিয়ালৈকে কোনো সংৰক্ষিত কাহিনী নাই';
	@override String get bookmarkStoriesToSave => 'কাহিনী সংৰক্ষণ কৰিবলৈ বুকমাৰ্ক কৰক';
	@override String get myGeneratedStories => 'মোৰ কাহিনী';
	@override String get noGeneratedStoriesYet => 'এতিয়ালৈকে কোনো কাহিনী সৃষ্টি হোৱা নাই';
	@override String get createYourFirstStory => 'AI ৰ সহায়ত আপোনাৰ প্ৰথম কাহিনী সৃষ্টি কৰক';
	@override String get shareToFeed => 'ফিডলৈ শ্বেয়াৰ কৰক';
	@override String get sharedToFeed => 'কাহিনী ফিডলৈ শ্বেয়াৰ কৰা হ\'ল';
	@override String get shareStoryTitle => 'কাহিনী শ্বেয়াৰ কৰক';
	@override String get shareStoryMessage => 'আপোনাৰ কাহিনীৰ বাবে এখন কেপশ্যন লিখক (ঐচ্ছিক)';
	@override String get shareStoryCaption => 'কেপশ্যন';
	@override String get shareStoryHint => 'এই কাহিনীৰ বিষয়ে আপুনি কি ক\'ব খোজে?';
	@override String get exploreHeritageTitle => 'ঐতিহ্য অন্বেষণ কৰক';
	@override String get exploreHeritageDesc => 'মেপত সাংস্কৃতিক পৰম্পৰা থকা স্থানসমূহ বিচাৰি উলিয়াওক';
	@override String get whereToVisit => 'পৰৱৰ্তী ভ্ৰমণ';
	@override String get scriptures => 'শাস্ত্ৰসমূহ';
	@override String get exploreSacredSites => 'পবিত্ৰ স্থানসমূহ অন্বেষণ কৰক';
	@override String get readStories => 'কাহিনী পঢ়ক';
	@override String get yesRemindMe => 'হয়, মোক মনত পেলাই দিয়ক';
	@override String get noDontShowAgain => 'নহয়, পুনৰ দেখুৱাব নালাগে';
	@override String get discoverDismissTitle => 'Discover MyItihas লুকুৱাব নেকি?';
	@override String get discoverDismissMessage => 'আপুনি আগন্তুকবাৰ এপ খোলাৰ বা লগইন কৰোতে এইটো পুনৰ চাব বিচাৰে নেকি?';
	@override String get discoverCardTitle => 'MyItihas চিনাক্ত কৰক';
	@override String get discoverCardSubtitle => 'প্ৰাচীন শাস্ত্ৰৰ পৰা কাহিনী, অন্বেষণযোগ্য পবিত্ৰ স্থানসমূহ আৰু আপোনাৰ ওঁঠৰ আগতেই জ্ঞান।';
	@override String get swipeToDismiss => 'বন্ধ কৰিবলৈ ওপৰেৰে ছুইপ কৰক';
	@override String get searchScriptures => 'শাস্ত্ৰ বিচাৰক...';
	@override String get searchLanguages => 'ভাষা বিচাৰক...';
	@override String get exploreStoriesLabel => 'কাহিনী অন্বেষণ কৰক';
	@override String get exploreMore => 'আরো দেখুৱাওক';
	@override String get failedToLoadActivity => 'কাৰ্য্যকলাপ লোড কৰিব নোৱাৰি';
	@override String get startReadingOrGenerating => 'ইয়াত আপোনাৰ কাৰ্য্যকলাপ দেখিবলৈ কাহিনী পঢ়া বা সৃষ্টি কৰা আৰম্ভ কৰক';
	@override late final _TranslationsHomeScreenHeroAs hero = _TranslationsHomeScreenHeroAs._(_root);
}

// Path: stories
class _TranslationsStoriesAs extends TranslationsStoriesEn {
	_TranslationsStoriesAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'কাহিনী';
	@override String get searchHint => 'শীৰ্ষক বা লেখকৰ নামৰ দ্বাৰা সন্ধান কৰক...';
	@override String get sortBy => 'এই অনুসৰি তালি কৰক';
	@override String get sortNewest => 'সৰ্বনৱীন প্ৰথমে';
	@override String get sortOldest => 'সৰ্বপুৰণি প্ৰথমে';
	@override String get sortPopular => 'সৰ্বাধিক জনপ্ৰিয়';
	@override String get noStories => 'কোনো কাহিনী পোৱা হোৱা নাই';
	@override String get loadingStories => 'কাহিনী লোড হৈ আছে...';
	@override String get errorLoadingStories => 'কাহিনী লোড কৰোঁতে সমস্যাৰ সৃষ্টি হ\'ল';
	@override String get storyDetails => 'কাহিনীৰ বিৱৰণ';
	@override String get continueReading => 'পঢ়া অব্যাহত ৰাখক';
	@override String get readMore => 'অধিক পঢ়ক';
	@override String get readLess => 'কম দেখুৱাওক';
	@override String get author => 'লেখক';
	@override String get publishedOn => 'প্ৰকাশৰ তাৰিখ';
	@override String get category => 'বৰ্গ';
	@override String get tags => 'টেগ';
	@override String get failedToLoad => 'কাহিনী লোড কৰিব নোৱাৰি';
	@override String get subtitle => 'শাস্ত্ৰৰ কাহিনী আৱিষ্কাৰ কৰক';
	@override String get noStoriesHint => 'ভিন্ন সন্ধান বা ফিল্টাৰ চেষ্টা কৰি কাহিনী আৱিষ্কাৰ কৰক।';
	@override String get featured => 'বিশেষ';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorAs extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'স্টোরি জেনেৰেটৰ';
	@override String get subtitle => 'নিজৰ শাস্ত্ৰীয় কাহিনী সৃষ্টি কৰক';
	@override String get quickStart => 'দ্ৰুত আৰম্ভণি';
	@override String get interactive => 'ইণ্টাৰেক্টিভ';
	@override String get rawPrompt => 'কাঁচা প্ৰম্প্ট';
	@override String get yourStoryPrompt => 'আপোনাৰ কাহিনীৰ প্রম্প্ট';
	@override String get writeYourPrompt => 'আপোনাৰ প্রম্প্ট লিখক';
	@override String get selectScripture => 'শাস্ত্ৰ বাছনি কৰক';
	@override String get selectStoryType => 'কাহিনীৰ ধৰণ বাছনি কৰক';
	@override String get selectCharacter => 'চৰিত্ৰ বাছনি কৰক';
	@override String get selectTheme => 'থীম বাছনি কৰক';
	@override String get selectSetting => 'পটভূমি/স্থান বাছনি কৰক';
	@override String get selectLanguage => 'ভাষা বাছনি কৰক';
	@override String get selectLength => 'কাহিনীৰ দৈৰ্ঘ্য';
	@override String get moreOptions => 'অধিক বিকল্প';
	@override String get random => 'এৰা-ফেৰাৰ';
	@override String get generate => 'কাহিনী সৃষ্টি কৰক';
	@override String get generating => 'আপোনাৰ কাহিনী সৃষ্টি হৈ আছে...';
	@override String get creatingYourStory => 'আপোনাৰ কাহিনী গঢ়ি তোলা হৈ আছে';
	@override String get consultingScriptures => 'প্ৰাচীন শাস্ত্ৰৰ সৈতে পৰামৰ্শ কৰা হৈ আছে...';
	@override String get weavingTale => 'আপোনাৰ কাহিনী বেনোৱা হৈ আছে...';
	@override String get addingWisdom => 'দেৱীয় জ্ঞান যোগ কৰা হৈ আছে...';
	@override String get polishingNarrative => 'কাহিনীৰ বৰ্ণনা অধিক সুন্দৰ কৰা হৈ আছে...';
	@override String get almostThere => 'প্রায় সম্পূৰ্ণ...';
	@override String get generatedStory => 'আপোনাৰ সৃষ্টি কৰা কাহিনী';
	@override String get aiGenerated => 'AI দ্বাৰা সৃষ্টি কৰা';
	@override String get regenerate => 'পুনৰ সৃষ্টি কৰক';
	@override String get saveStory => 'কাহিনী সংৰক্ষণ কৰক';
	@override String get shareStory => 'কাহিনী শ্বেয়াৰ কৰক';
	@override String get newStory => 'নতুন কাহিনী';
	@override String get saved => 'সংৰক্ষিত';
	@override String get storySaved => 'কাহিনী আপোনাৰ লাইব্ৰেৰীত সংৰক্ষণ কৰা হ\'ল';
	@override String get story => 'কাহিনী';
	@override String get lesson => 'পাঠ';
	@override String get didYouKnow => 'আপুনি জানেনে?';
	@override String get activity => 'কাৰ্য্যকলাপ';
	@override String get optionalRefine => 'ঐচ্ছিক: বিকল্পৰ সাহায্যে অধিক সূক্ষ্ম কৰক';
	@override String get applyOptions => 'বিকল্প প্ৰয়োগ কৰক';
	@override String get language => 'ভাষা';
	@override String get storyFormat => 'কাহিনীৰ ফৰ্মেট';
	@override String get requiresInternet => 'কাহিনী সৃষ্টি কৰিবলৈ ইন্টাৰনেটৰ প্ৰয়োজন';
	@override String get notAvailableOffline => 'কাহিনী অফলাইনৰ বাবে উপলব্ধ নহয়। চাবলৈ ইন্টাৰনেটত জড়িত হওক।';
	@override String get aiDisclaimer => 'AI এ কেতিয়াবা ভুল কৰিবও পাৰে। আমি সদায় উন্নতি কৰি আছো; আপোনাৰ মতামত গুৰুত্বপূর্ণ।';
	@override late final _TranslationsStoryGeneratorStoryLengthAs storyLength = _TranslationsStoryGeneratorStoryLengthAs._(_root);
	@override late final _TranslationsStoryGeneratorFormatAs format = _TranslationsStoryGeneratorFormatAs._(_root);
	@override late final _TranslationsStoryGeneratorHintsAs hints = _TranslationsStoryGeneratorHintsAs._(_root);
	@override late final _TranslationsStoryGeneratorErrorsAs errors = _TranslationsStoryGeneratorErrorsAs._(_root);
}

// Path: chat
class _TranslationsChatAs extends TranslationsChatEn {
	_TranslationsChatAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'শাস্ত্ৰসমূহ সম্পৰ্কে AI ৰ সৈতে কথোপকথন কৰক';
	@override String get friendMode => 'বন্ধু মোড';
	@override String get philosophicalMode => 'তাত্ত্বিক মোড';
	@override String get typeMessage => 'আপোনাৰ বাৰ্তা লিখক...';
	@override String get send => 'পঠিয়াওক';
	@override String get newChat => 'নতুন চেট';
	@override String get chatsTab => 'চেট';
	@override String get groupsTab => 'দল';
	@override String get chatHistory => 'চেটৰ ইতিহাস';
	@override String get clearChat => 'চেট মচি পেলাওক';
	@override String get noMessages => 'এতিয়ালৈকে কোনো বাৰ্তা নাই। এটা কথোপকথন আৰম্ভ কৰক!';
	@override String get listPage => 'চেট তালিকা পৃষ্ঠা';
	@override String get forwardMessageTo => 'বার্তা আগবঢ়াওক...';
	@override String get forwardMessage => 'বাৰ্তা আগবঢ়াওক';
	@override String get messageForwarded => 'বাৰ্তা আগবঢ়োৱা হ\'ল';
	@override String failedToForward({required Object error}) => 'বাৰ্তা আগবঢ়াবলৈ ব্যৰ্থ হ\'ল: ${error}';
	@override String get searchChats => 'চেটসমূহ বিচাৰক';
	@override String get noChatsFound => 'কোনো চেট পোৱা নগ\'ল';
	@override String get requests => 'অনুৰোধ';
	@override String get messageRequests => 'বাৰ্তা অনুৰোধ';
	@override String get groupRequests => 'দলগত অনুৰোধ';
	@override String get requestSent => 'অনুৰোধ পঠিওৱা হ\'ল। সিহঁতে তাক "Requests" ত চাব।';
	@override String get wantsToChat => 'চেট কৰিব খোজে';
	@override String addedYouTo({required Object name}) => '${name} এ আপোনাক যোগ কৰিছে';
	@override String get accept => 'স্বীকাৰ কৰক';
	@override String get noMessageRequests => 'কোনো বাৰ্তা অনুৰোধ নাই';
	@override String get noGroupRequests => 'কোনো দলগত অনুৰোধ নাই';
	@override String get invitesSent => 'নিমন্ত্ৰণ পঠিওৱা হ\'ল। সিহঁতে তাক "Requests" ত চাব।';
	@override String get cantMessageUser => 'আপুনি এই ব্যৱহাৰকাৰীক বাৰ্তা পঠিয়াব নোৱাৰে';
	@override String get deleteChat => 'চেট মচি পেলাওক';
	@override String get deleteChats => 'চেটসমূহ মচি পেলাওক';
	@override String get blockUser => 'ব্যৱহাৰকাৰীক ব্লক কৰক';
	@override String get reportUser => 'ব্যৱহাৰকাৰীৰ বিৰুদ্ধে রিপোর্ট কৰক';
	@override String get markAsRead => 'পঢ়া হিচাপে চিহ্নিত কৰক';
	@override String get markedAsRead => 'পঢ়া হিচাপে চিহ্নিত কৰা হ\'ল';
	@override String get deleteClearChat => 'চেট মচি পেলাওক / সাফ কৰক';
	@override String get deleteConversation => 'কথোপকথন মচি পেলাওক';
	@override String get reasonRequired => 'কাৰণ (আৱশ্যক)';
	@override String get submit => 'জন্মান';
	@override String get userReportedBlocked => 'ব্যৱহাৰকাৰীক রিপোর্ট আৰু ব্লক কৰা হৈছে।';
	@override String reportFailed({required Object error}) => 'রিপোর্ট কৰাত ব্যৰ্থ: ${error}';
	@override String get newGroup => 'নতুন গৰাকী';
	@override String get messageSomeoneDirectly => 'কোনোক মৃত্যুক সিধাই বাৰ্তা পঠিয়াওক';
	@override String get createGroupConversation => 'গোটীয়া কথোপকথন সৃষ্টি কৰক';
	@override String get noGroupsYet => 'এতিয়ালৈকে কোনো গোট নাই';
	@override String get noChatsYet => 'এতিয়ালৈকে কোনো চেট নাই';
	@override String get tapToCreateGroup => 'গোট সৃষ্টি বা অংশ লৈবলৈ + টিপক';
	@override String get tapToStartConversation => 'নতুন কথোপকথন আৰম্ভ কৰিবলৈ + টিপক';
	@override String get conversationDeleted => 'কথোপকথন মচি পেলোৱা হ\'ল';
	@override String conversationsDeleted({required Object count}) => '${count} কথোপকথন(সমূহ) মচি পেলোৱা হ\'ল';
	@override String get searchConversations => 'কথোপকথনসমূহ বিচাৰক...';
	@override String get connectToInternet => 'অনুগ্ৰহ কৰি ইন্টাৰনেটত সংযোগ হৈ পুনৰ চেষ্টা কৰক।';
	@override String get littleKrishnaName => 'সৰু কৃষ্ণ';
	@override String get newConversation => 'নতুন কথোপকথন';
	@override String get noConversationsYet => 'এতিয়ালৈকে কোনো কথোপকথন নাই';
	@override String get confirmDeletion => 'মচি পেলোৱা নিশ্চিত কৰক';
	@override String deleteConversationConfirm({required Object title}) => 'আপুনি কি নিশ্চিত যে ${title} কথোপকথন মচি পেলাব খোজে?';
	@override String get deleteFailed => 'কথোপকথন মচি পেলাবলৈ ব্যৰ্থ';
	@override String get fullChatCopied => 'সম্পূৰ্ণ চেট ক্লিপবর্ডলৈ কপি হ\'ল!';
	@override String get connectionErrorFallback => 'এই মুহূৰ্তত সংযোগ কৰাত অসুবিধা হৈছে। অলপ পাছত পুনৰ চেষ্টা কৰক।';
	@override String krishnaWelcomeWithName({required Object name}) => 'হে ${name}। মই তোমাৰ বন্ধু কৃষ্ণ। আজিকালি কিদৰে আছা?';
	@override String get krishnaWelcomeFriend => 'হে প্ৰিয় বন্ধু। মই তোমাৰ বন্ধু কৃষ্ণ। আজিকালি কিদৰে আছা?';
	@override String get copyYouLabel => 'আপুনি';
	@override String get copyKrishnaLabel => 'কৃষ্ণ';
	@override late final _TranslationsChatSuggestionsAs suggestions = _TranslationsChatSuggestionsAs._(_root);
	@override String get about => 'বিষয়ে';
	@override String get yourFriendlyCompanion => 'আপোনাৰ বন্ধুসুলভ সঙ্গী';
	@override String get mentalHealthSupport => 'মানসিক স্বাস্থ্য সহায়তা';
	@override String get mentalHealthSupportSubtitle => 'চিন্তা ভাগ-বতৰা কৰিবলৈ আৰু শুনা হোৱাৰ অনুভৱ পাবলৈ এটা সুৰক্ষিত ঠাই।';
	@override String get friendlyCompanion => 'বন্ধুসুলভ সহযাত্রী';
	@override String get friendlyCompanionSubtitle => 'সদায় কথা-বাৰ্তা কৰিবলৈ, উৎসাহিত কৰিবলৈ আৰু জ্ঞান বিলাবলৈ সাজু।';
	@override String get storiesAndWisdom => 'কাহিনী আৰু জ্ঞান';
	@override String get storiesAndWisdomSubtitle => 'কালজয়ী কাহিনী আৰু দৈনন্দিন জীৱনৰ অভিজ্ঞতা পৰা শিক্ষা লোৱা।';
	@override String get askAnything => 'যি খুশি সোধক';
	@override String get askAnythingSubtitle => 'আপোনাৰ প্ৰশ্নসমূহৰ কোমল, গভীৰ চিন্তাশীল উত্তৰ লাভ কৰক।';
	@override String get startChatting => 'চেটিং আৰম্ভ কৰক';
	@override String get maybeLater => 'পাছত চাম';
}

// Path: map
class _TranslationsMapAs extends TranslationsMapEn {
	_TranslationsMapAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'অখণ্ড ভাৰত';
	@override String get subtitle => 'ইতিহাসিক স্থানসমূহ অন্বেষণ কৰক';
	@override String get searchLocation => 'স্থান অনুসন্ধান কৰক...';
	@override String get viewDetails => 'বিৱৰণ দেখুৱাওক';
	@override String get viewSites => 'স্থানবোৰ চাওক';
	@override String get showRoute => 'পথ দেখুৱাওক';
	@override String get historicalInfo => 'ইতিহাসিক তথ্য';
	@override String get nearbyPlaces => 'কাছেৰীয়া স্থানসমূহ';
	@override String get pickLocationOnMap => 'মেপত স্থান বাছনি কৰক';
	@override String get sitesVisited => 'ভ্ৰমণ কৰা স্থানসমূহ';
	@override String get badgesEarned => 'অর্জন কৰা বেজসমূহ';
	@override String get completionRate => 'সম্পূৰ্ণ হোৱাৰ হাৰ';
	@override String get addToJourney => 'ভ্ৰমণত যোগ কৰক';
	@override String get addedToJourney => 'ভ্ৰমণত যোগ কৰা হৈছে';
	@override String get getDirections => 'দিশা লাভ কৰক';
	@override String get viewInMap => 'মেপত দেখুৱাওক';
	@override String get directions => 'দিশাবোৰ';
	@override String get photoGallery => 'ফটো গ্যালাৰী';
	@override String get viewAll => 'সকলো দেখুৱাওক';
	@override String get photoSavedToGallery => 'ফটো গ্যালাৰীত সংৰক্ষণ কৰা হ\'ল';
	@override String get sacredSoundscape => 'পবিত্ৰ ধ্বনি-প্ৰকৃতি';
	@override String get allDiscussions => 'সকলো আলোচনা';
	@override String get journeyTab => 'ভ্ৰমণ';
	@override String get discussionTab => 'আলোচনা';
	@override String get myActivity => 'মোৰ কাৰ্য্যকলাপ';
	@override String get anonymousPilgrim => 'অজ্ঞাত তীৰ্থযাত্রী';
	@override String get viewProfile => 'প্ৰফাইল দেখুৱাওক';
	@override String get discussionTitleHint => 'আলোচনাৰ শীৰ্ষক...';
	@override String get shareYourThoughtsHint => 'আপোনাৰ চিন্তাবোৰ ভাগ-বতৰা কৰক...';
	@override String get pleaseEnterDiscussionTitle => 'অনুগ্ৰহ কৰি আলোচনাৰ শীৰ্ষক লিখক';
	@override String get addReflection => 'অভিজ্ঞতা যোগ কৰক';
	@override String get reflectionTitle => 'শীৰ্ষক';
	@override String get enterReflectionTitle => 'অভিজ্ঞতাৰ শীৰ্ষক লিখক';
	@override String get pleaseEnterTitle => 'অনুগ্ৰহ কৰি শীৰ্ষক লিখক';
	@override String get siteName => 'স্থানৰ নাম';
	@override String get enterSacredSiteName => 'পবিত্ৰ স্থানৰ নাম লিখক';
	@override String get pleaseEnterSiteName => 'অনুগ্ৰহ কৰি স্থানৰ নাম লিখক';
	@override String get reflection => 'অভিজ্ঞতা';
	@override String get reflectionHint => 'আপোনাৰ অভিজ্ঞতা আৰু চিন্তাবোৰ ভাগ-বতৰা কৰক...';
	@override String get pleaseEnterReflection => 'অনুগ্ৰহ কৰি আপুনি কি অনুভৱ কৰিলে লিখক';
	@override String get saveReflection => 'অভিজ্ঞতা সংৰক্ষণ কৰক';
	@override String get journeyProgress => 'যাত্ৰাৰ আগবঢ়া';
	@override late final _TranslationsMapDiscussionsAs discussions = _TranslationsMapDiscussionsAs._(_root);
}

// Path: community
class _TranslationsCommunityAs extends TranslationsCommunityEn {
	_TranslationsCommunityAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'সমাজ';
	@override String get trending => 'ট্ৰেণ্ডিং';
	@override String get following => 'অনুসৰণ কৰা';
	@override String get followers => 'অনুসৰণকাৰী';
	@override String get posts => 'পোস্টসমূহ';
	@override String get follow => 'অনুসৰণ কৰক';
	@override String get unfollow => 'অনুসৰণ বন্ধ কৰক';
	@override String get shareYourStory => 'আপোনাৰ কাহিনী ভাগ-বতৰা কৰক...';
	@override String get post => 'পোস্ট কৰক';
	@override String get like => 'লাইক';
	@override String get comment => 'মন্তব্য';
	@override String get comments => 'মন্তব্যসমূহ';
	@override String get noPostsYet => 'এতিয়ালৈকে কোনো পোস্ট নাই';
}

// Path: discover
class _TranslationsDiscoverAs extends TranslationsDiscoverEn {
	_TranslationsDiscoverAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'আবিষ্কাৰ কৰক';
	@override String get searchHint => 'কাহিনী, ব্যক্তি, বা বিষয় বিচাৰক...';
	@override String get tryAgain => 'পুনৰ চেষ্টা কৰক';
	@override String get somethingWentWrong => 'কিবা ভুল হ\'ল';
	@override String get unableToLoadProfiles => 'প্ৰফাইল লোড কৰিব নোৱাৰি। অনুগ্ৰহ কৰি পুনৰ চেষ্টা কৰক।';
	@override String get noProfilesFound => 'কোনো প্ৰফাইল পোৱা নগ\'ল';
	@override String get searchToFindPeople => 'অনুসৰণ কৰিব লগা মানুহ বিচাৰিবলৈ সন্ধান কৰক';
	@override String get noResultsFound => 'কোনো ফলাফল পোৱা নগ\'ল';
	@override String get noProfilesYet => 'এতিয়ালৈকে কোনো প্ৰফাইল নাই';
	@override String get tryDifferentKeywords => 'ভিন্ন শব্দ ব্যৱহাৰ কৰি সন্ধান করুন';
	@override String get beFirstToDiscover => 'নতুন মানুহ বিচাৰি উলিয়াবলৈ প্ৰথম হওক!';
}

// Path: plan
class _TranslationsPlanAs extends TranslationsPlanEn {
	_TranslationsPlanAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'আপোনাৰ পৰিকল্পনা সংৰক্ষণ কৰিবলৈ চাইন ইন কৰক';
	@override String get planSaved => 'পৰিকল্পনা সংৰক্ষণ কৰা হ\'ল';
	@override String get from => 'কোথাৰ পৰা';
	@override String get dates => 'তাৰিখসমূহ';
	@override String get destination => 'গন্তব্য';
	@override String get nearby => 'ওচৰৰ';
	@override String get generatedPlan => 'সৃষ্টি কৰা পৰিকল্পনা';
	@override String get whereTravellingFrom => 'আপুনি ক\'তকৈ ভ্ৰমণ কৰি আছে?';
	@override String get enterCityOrRegion => 'আপোনাৰ চহৰ বা অঞ্চল লিখক';
	@override String get travelDates => 'ভ্ৰমণৰ তাৰিখসমূহ';
	@override String get destinationSacredSite => 'গন্তব্য (পবিত্ৰ স্থান)';
	@override String get searchOrSelectDestination => 'গন্তব্য বিচাৰক বা বাছনি কৰক...';
	@override String get shareYourExperience => 'আপোনাৰ অভিজ্ঞতা ভাগ-বতৰা কৰক';
	@override String get planShared => 'পৰিকল্পনা শ্বেয়াৰ কৰা হ\'ল';
	@override String failedToSharePlan({required Object error}) => 'পৰিকল্পনা শ্বেয়াৰ কৰাত ব্যৰ্থ: ${error}';
	@override String get planUpdated => 'পৰিকল্পনা আপডেট কৰা হ\'ল';
	@override String failedToUpdatePlan({required Object error}) => 'পৰিকল্পনা আপডেট কৰাত ব্যৰ্থ: ${error}';
	@override String get deletePlanConfirm => 'এই পৰিকল্পনা মচি পেলাব নে?';
	@override String get thisPlanPermanentlyDeleted => 'এই পৰিকল্পনা স্থায়ীভাৱে মচি পেলোৱা হ\'ব।';
	@override String get planDeleted => 'পৰিকল্পনা মচি পেলোৱা হ\'ল';
	@override String failedToDeletePlan({required Object error}) => 'পৰিকল্পনা মচি পেলাবলৈ ব্যৰ্থ: ${error}';
	@override String get sharePlan => 'পৰিকল্পনা শ্বেয়াৰ কৰক';
	@override String get deletePlan => 'পৰিকল্পনা মচি পেলাওক';
	@override String get savedPlanDetails => 'সংৰক্ষিত পৰিকল্পনাৰ বিৱৰণ';
	@override String get pilgrimagePlan => 'তীৰ্থ-যাত্ৰা পৰিকল্পনা';
	@override String get planTab => 'পরিকল্পনা';
}

// Path: settings
class _TranslationsSettingsAs extends TranslationsSettingsEn {
	_TranslationsSettingsAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'ছেটিংছ';
	@override String get language => 'ভাষা';
	@override String get theme => 'থীম';
	@override String get themeLight => 'লাইট';
	@override String get themeDark => 'ডাৰ্ক';
	@override String get themeSystem => 'চিষ্টেম থীম ব্যৱহাৰ কৰক';
	@override String get darkMode => 'ডাৰ્ક মোড';
	@override String get selectLanguage => 'ভাষা বাছনি কৰক';
	@override String get notifications => 'বিজ্ঞপ্তিসমূহ';
	@override String get cacheSettings => 'কেশ আৰু ষ্ট\'ৰেজ';
	@override String get general => 'সাধাৰণ';
	@override String get account => 'অ্যাকাউণ্ট';
	@override String get blockedUsers => 'ব্লক কৰা ব্যৱহাৰকাৰী';
	@override String get helpSupport => 'সহায় আৰু সমর্থন';
	@override String get contactUs => 'আমাক সংযোগ কৰক';
	@override String get legal => 'বৈধ';
	@override String get privacyPolicy => 'গোপনীয়তা নীতি';
	@override String get termsConditions => 'সর্তসমূহ আৰু চৰ্তাবলী';
	@override String get privacy => 'গোপনীয়তা';
	@override String get about => 'এপ সম্পৰ্কে';
	@override String get version => 'সংস্কৰণ';
	@override String get logout => 'লগ আউট';
	@override String get deleteAccount => 'অ্যাকাউণ্ট মচি পেলাওক';
	@override String get deleteAccountTitle => 'অ্যাকাউণ্ট মচি পেলাওক';
	@override String get deleteAccountWarning => 'এই কাৰ্য্যটি উলোটা কৰিব নোৱাৰি!';
	@override String get deleteAccountDescription => 'আপোনাৰ একাউণ্ট মচি পেলালে আপোনাৰ সকলো পোস্ট, মন্তব্য, প্রফাইল, ফলোৱাৰ, সংৰক্ষিত কাহিনী, বুকমাৰ্ক, চেট বাৰ্তা আৰু সৃষ্টি কৰা কাহিনীবোৰ স্থায়ীভাৱে মচি পেলোৱা হ\'ব।';
	@override String get confirmPassword => 'আপোনাৰ পাছৱৰ্ড নিশ্চিত কৰক';
	@override String get confirmPasswordDesc => 'অ্যাকাউণ্ট মচি পেলাবলৈ নিশ্চিত কৰিবলৈ পাছৱৰ্ড লিখক।';
	@override String get googleReauth => 'আপোনাৰ পৰিচয় নিশ্চিত কৰিবলৈ আপোনাক Google ত লৈ যোৱা হ\'ব।';
	@override String get finalConfirmationTitle => 'চূড়ান্ত নিশ্চিতকৰণ';
	@override String get finalConfirmation => 'আপুনি একেবাৰে নিশ্চিতনে? এইটো স্থায়ী আৰু উলোটা কৰিবলৈ নোৱাৰি।';
	@override String get deleteMyAccount => 'মোৰ একাউণ্ট মচি পেলাওক';
	@override String get deletingAccount => 'অ্যাকাউণ্ট মচি পেলোৱা হৈ আছে...';
	@override String get accountDeleted => 'আপোনাৰ একাউণ্ট স্থায়ীভাৱে মচি পেলোৱা হ\'ল।';
	@override String get deleteAccountFailed => 'অ্যাকাউণ্ট মচি পেলাবলৈ ব্যৰ্থ। অনুগ্ৰহ কৰি পুনৰ চেষ্টা কৰক।';
	@override String get downloadedStories => 'ডাউনলোড কৰা কাহিনীসমূহ';
	@override String get couldNotOpenEmail => 'ইমেল এপ খোলিব নোৱাৰি। অনুগ্ৰহ কৰি আমাদেরক myitihas@gmail.com ত ইমেল কৰক।';
	@override String couldNotOpenLabel({required Object label}) => '${label} এতিয়া খোলিব পৰা নগ\'ল।';
	@override String get logoutTitle => 'লগ আউট';
	@override String get logoutConfirm => 'আপুনি সত্যিই লগ আউট কৰিব খোজে নেকি?';
	@override String get verifyYourIdentity => 'আপোনাৰ পৰিচয় নিশ্চিত কৰক';
	@override String get verifyYourIdentityDesc => 'আপোনাৰ পৰিচয় নিশ্চিত কৰিবলৈ আপুনি Google ৰেৰে চাইন ইন কৰিবলৈ অনুৰোধ কৰা হ\'ব।';
	@override String get continueWithGoogle => 'Google সৈতে আগবাঢ়ক';
	@override String reauthFailed({required Object error}) => 'পুনৰ প্ৰমাণীকৰণ ব্যৰ্থ: ${error}';
	@override String get passwordRequired => 'পাছৱৰ্ড আৱশ্যক';
	@override String get invalidPassword => 'অবৈধ পাছৱৰ্ড। অনুগ্ৰহ কৰি পুনৰ চেষ্টা কৰক।';
	@override String get verify => 'নিশ্চিত কৰক';
	@override String get continueLabel => 'আগবাঢ়ক';
	@override String get unableToVerifyIdentity => 'পৰিচয় নিশ্চিত কৰিব পৰা নগ\'ল। অনুগ্ৰহ কৰি পুনৰ চেষ্টা কৰক।';
}

// Path: auth
class _TranslationsAuthAs extends TranslationsAuthEn {
	_TranslationsAuthAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get login => 'লগ ইন';
	@override String get signup => 'চাইন আপ';
	@override String get email => 'ইমেল';
	@override String get password => 'পাছৱৰ্ড';
	@override String get confirmPassword => 'পাছৱৰ্ড পুনৰ নিশ্চিত কৰক';
	@override String get forgotPassword => 'পাছৱৰ্ড পাহৰিলে নেকি?';
	@override String get resetPassword => 'পাছৱৰ্ড ৰিসেট কৰক';
	@override String get dontHaveAccount => 'অ্যাকাউণ্ট নাই নেকি?';
	@override String get alreadyHaveAccount => 'আগতেৰে একাউণ্ট আছে নেকি?';
	@override String get loginSuccess => 'লগ ইন সফল হ\'ল';
	@override String get signupSuccess => 'চাইন আপ সফল হ\'ল';
	@override String get loginError => 'লগ ইন ব্যৰ্থ হ\'ল';
	@override String get signupError => 'চাইন আপ ব্যৰ্থ হ\'ল';
}

// Path: error
class _TranslationsErrorAs extends TranslationsErrorEn {
	_TranslationsErrorAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get network => 'ইন্টাৰনেট সংযোগ নাই';
	@override String get server => 'ছাৰ্ভাৰত ভুল হ\'ল';
	@override String get cache => 'কেশ কৰা ডেটা লোড কৰাত ব্যৰ্থ হ\'ল';
	@override String get timeout => 'অনুৰোধৰ সময় শেষ';
	@override String get notFound => 'কোনো সম্পদ পোৱা নগ\'ল';
	@override String get validation => 'চেকিং ব্যৰ্থ হ\'ল';
	@override String get unexpected => 'অপেক্ষাতীত ভুল সংঘটিত হ\'ল';
	@override String get tryAgain => 'অনুগ্ৰহ কৰি পুনৰ চেষ্টা কৰক';
	@override String couldNotOpenLink({required Object url}) => 'লিঙ্ক খোলিব পৰা নগ\'ল: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionAs extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get free => 'বিনামূলীয়া';
	@override String get plus => 'প্লাছ';
	@override String get pro => 'প্ৰো';
	@override String get upgradeToPro => 'প্ৰোলৈ আপগ্ৰেড কৰক';
	@override String get features => 'বৈশিষ্ট্যসমূহ';
	@override String get subscribe => 'ছাবস্ক্ৰাইব কৰক';
	@override String get currentPlan => 'বৰ্তমান পরিকল্পনা';
	@override String get managePlan => 'পরিকল্পনা পৰিচালনা কৰক';
}

// Path: notification
class _TranslationsNotificationAs extends TranslationsNotificationEn {
	_TranslationsNotificationAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'বিজ্ঞাপ্তিসমূহ';
	@override String get peopleToConnect => 'সংযোগ কৰিব লগা মানুহ';
	@override String get peopleToConnectSubtitle => 'ফলো কৰিবলৈ মানুহ বিচাৰক';
	@override String followAgainInMinutes({required Object minutes}) => 'আপুনি ${minutes} মিনিট পিছত পুনৰ ফলো কৰিব পাৰিব';
	@override String get noSuggestions => 'এই মুহূৰ্তত কোনো পৰামৰ্শ নাই';
	@override String get markAllRead => 'সকলোকে পঢ়া হিচাপে চিহ্নিত কৰক';
	@override String get noNotifications => 'এতিয়ালৈকে কোনো বিজ্ঞপ্তি নাই';
	@override String get noNotificationsSubtitle => 'কোনোব্যক্তিয়ে আপোনাৰ কাহিনীৰ সৈতে ইণ্টাৰেক্ট কৰিলে, আপুনি ইয়াত দেখিব';
	@override String get errorPrefix => 'ভুল:';
	@override String get retry => 'পুনৰ চেষ্টা কৰক';
	@override String likedYourStory({required Object actorName}) => '${actorName} এ আপোনাৰ কাহিনী পছন্দ কৰিছে';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} এ আপোনাৰ কাহিনীত মন্তব্য কৰিছে';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} এ আপোনাৰ মন্তব্যৰ উত্তৰ দি কৰিছে';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} এ আপোনাক ফলো কৰা আৰম্ভ কৰিছে';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} এ আপোনালৈ এটা বাৰ্তা পঠিয়াইছে';
	@override String sharedYourStory({required Object actorName}) => '${actorName} এ আপোনাৰ কাহিনী শ্বেয়াৰ কৰিছে';
	@override String repostedYourStory({required Object actorName}) => '${actorName} এ আপোনাৰ কাহিনী পুনৰ পোস্ট কৰিছে';
	@override String mentionedYou({required Object actorName}) => '${actorName} এ আপোনাক উল্লেখ কৰিছে';
	@override String newPostFrom({required Object actorName}) => '${actorName} ৰ পৰা নতুন পোস্ট';
	@override String get today => 'আজি';
	@override String get thisWeek => 'এই সপ্তাহ';
	@override String get earlier => 'আগতে';
	@override String get delete => 'মচি পেলাওক';
}

// Path: profile
class _TranslationsProfileAs extends TranslationsProfileEn {
	_TranslationsProfileAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get followers => 'অনুসৰণকাৰী';
	@override String get following => 'যাক আপুনি অনুসৰণ কৰিছে';
	@override String get unfollow => 'অনুসৰণ বন্ধ কৰক';
	@override String get follow => 'অনুসৰণ কৰক';
	@override String get about => 'বিষয়ে';
	@override String get stories => 'কাহিনী';
	@override String get unableToShareImage => 'ছবি শ্বেয়াৰ কৰিব পৰা নগ\'ল';
	@override String get imageSavedToPhotos => 'ছবি ফ\'টোচত সংৰক্ষণ কৰা হ\'ল';
	@override String get view => 'দেখুৱাওক';
	@override String get saveToPhotos => 'ফ\'টোচত সংৰক্ষণ কৰক';
	@override String get failedToLoadImage => 'ছবি লোড কৰাত ব্যৰ্থ হ\'ল';
}

// Path: feed
class _TranslationsFeedAs extends TranslationsFeedEn {
	_TranslationsFeedAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get loading => 'কাহিনীসমূহ লোড হৈ আছে...';
	@override String get loadingPosts => 'পোস্টসমূহ লোড হৈ আছে...';
	@override String get loadingVideos => 'ভিডিঅ\' লোড হৈ আছে...';
	@override String get loadingStories => 'কাহিনীসমূহ লোড হৈ আছে...';
	@override String get errorTitle => 'অ’ফ্! কিবা ভুল হ\'ল';
	@override String get tryAgain => 'পুনৰ চেষ্টা কৰক';
	@override String get noStoriesAvailable => 'কোনো কাহিনী উপলব্ধ নাই';
	@override String get noImagesAvailable => 'কোনো ইমেজ পোস্ট উপলব্ধ নাই';
	@override String get noTextPostsAvailable => 'কোনো টেক্স্ট পোস্ট উপলব্ধ নাই';
	@override String get noContentAvailable => 'কোনো বিষয়বস্তু উপলব্ধ নাই';
	@override String get refresh => 'ৰিফ্ৰেশ কৰক';
	@override String get comments => 'মন্তব্যসমূহ';
	@override String get commentsComingSoon => 'মন্তব্য বৈশিষ্ট্য খুবেই চিগগিৰে আহিছে';
	@override String get addCommentHint => 'মন্তব্য যোগ কৰক...';
	@override String get shareStory => 'কাহিনী শ্বেয়াৰ কৰক';
	@override String get sharePost => 'পোস্ট শ্বেয়াৰ কৰক';
	@override String get shareThought => 'চিন্তা শ্বেয়াৰ কৰক';
	@override String get shareAsImage => 'ইমেজ হিচাবে শ্বেয়াৰ কৰক';
	@override String get shareAsImageSubtitle => 'একটা সুন্দৰ প্ৰিভিউ কাৰ্ড সৃষ্টি কৰক';
	@override String get shareLink => 'লিঙ্ক শ্বেয়াৰ কৰক';
	@override String get shareLinkSubtitle => 'কাহিনীৰ লিঙ্ক কপি বা শ্বেয়াৰ কৰক';
	@override String get shareImageLinkSubtitle => 'পোস্টৰ লিঙ্ক কপি বা শ্বেয়াৰ কৰক';
	@override String get shareTextLinkSubtitle => 'চিন্তাৰ লিঙ্ক কপি বা শ্বেয়াৰ কৰক';
	@override String get shareAsText => 'টেক্স্ট হিচাবে শ্বেয়াৰ কৰক';
	@override String get shareAsTextSubtitle => 'কাহিনীৰ এখন অংশ শ্বেয়াৰ কৰক';
	@override String get shareQuote => 'উক্তি শ্বেয়াৰ কৰক';
	@override String get shareQuoteSubtitle => 'উক্তি হিচাপে শ্বেয়াৰ কৰক';
	@override String get shareWithImage => 'ইমেজসহ শ্বেয়াৰ কৰক';
	@override String get shareWithImageSubtitle => 'ইমেজ আৰু কেপশ্যন একেলগে শ্বেয়াৰ কৰক';
	@override String get copyLink => 'লিঙ্ক কপি কৰক';
	@override String get copyLinkSubtitle => 'লিঙ্ক ক্লিপবর্ডলৈ কপি কৰক';
	@override String get copyText => 'টেক্স্ট কপি কৰক';
	@override String get copyTextSubtitle => 'উক্তি ক্লિપবর্ডলৈ কপি কৰক';
	@override String get linkCopied => 'লিঙ্ক ক্লિપবর্ডলৈ কপি হ\'ল';
	@override String get textCopied => 'টেক্স્ટ ক্লিপবর্ডলৈ কপি হ\'ল';
	@override String get sendToUser => 'ব্যৱহাৰকাৰীক পঠিয়াওক';
	@override String get sendToUserSubtitle => 'এজন বন্ধুক সোজাকৈ শ্বেয়াৰ কৰক';
	@override String get chooseFormat => 'ফৰ্মেট বাছনি কৰক';
	@override String get linkPreview => 'লিঙ্ক প্ৰিভিউ';
	@override String get linkPreviewSize => '১২০০ × ৬৩০';
	@override String get storyFormat => 'স্ট’ৰী ফৰ্মেট';
	@override String get storyFormatSize => '১০৮০ × ১৯২০ (Instagram/Stories)';
	@override String get generatingPreview => 'প্ৰিভিউ তৈয়াৰ কৰি আছে...';
	@override String get bookmarked => 'বুকমাৰ্ক কৰা হ\'ল';
	@override String get removedFromBookmarks => 'বুকমাৰ্কৰ পৰা আঁতৰোৱা হ\'ল';
	@override String unlike({required Object count}) => 'আনলাইক, ${count} লাইক';
	@override String like({required Object count}) => 'লাইক, ${count} লাইক';
	@override String commentCount({required Object count}) => '${count} মন্তব্য';
	@override String shareCount({required Object count}) => 'শেয়াৰ, ${count} শেয়াৰ';
	@override String get removeBookmark => 'বুকমাৰ্ক আঁতৰাওক';
	@override String get addBookmark => 'বুকমাৰ્ક কৰক';
	@override String get quote => 'উক্তি';
	@override String get quoteCopied => 'উক্তি ক্লিপবর্ডলৈ কপি হ\'ল';
	@override String get copy => 'কপি কৰক';
	@override String get tapToViewFullQuote => 'সম্পূৰ্ণ উক্তি দেখিবলৈ টেপ কৰক';
	@override String get quoteFromMyitihas => 'MyItihas ৰ পৰা উক্তি';
	@override late final _TranslationsFeedTabsAs tabs = _TranslationsFeedTabsAs._(_root);
	@override String get tapToShowCaption => 'কেপশ্যন দেখুৱাবলৈ টেপ কৰক';
	@override String get noVideosAvailable => 'ভিডিঅ\' উপলব্ধ নাই';
	@override String get selectUser => 'কাক পঠিয়াব';
	@override String get searchUsers => 'ব্যৱহাৰকাৰীক বিচাৰক...';
	@override String get noFollowingYet => 'আপুনি এতিয়ালৈকে কাকো অনুসৰণ কৰা নাই';
	@override String get noUsersFound => 'কোনো ব্যৱহাৰকাৰী পোৱা নগ\'ল';
	@override String get tryDifferentSearch => 'অন্য অনুসন্ধান শব্দেৰে চেষ্টা কৰক';
	@override String sentTo({required Object username}) => '${username}লৈ পঠিয়োৱা হ\'ল';
}

// Path: voice
class _TranslationsVoiceAs extends TranslationsVoiceEn {
	_TranslationsVoiceAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'মাইক্ৰফোনৰ অনুমতীৰ প্ৰয়োজন';
	@override String get speechRecognitionNotAvailable => 'শব্দ চিনাক্তকৰণ সুবিধা উপলব্ধ নহয়';
}

// Path: festivals
class _TranslationsFestivalsAs extends TranslationsFestivalsEn {
	_TranslationsFestivalsAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'ভাৰতীয় উৎসৱ';
}

// Path: social
class _TranslationsSocialAs extends TranslationsSocialEn {
	_TranslationsSocialAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileAs editProfile = _TranslationsSocialEditProfileAs._(_root);
	@override late final _TranslationsSocialCreatePostAs createPost = _TranslationsSocialCreatePostAs._(_root);
	@override late final _TranslationsSocialCommentsAs comments = _TranslationsSocialCommentsAs._(_root);
	@override late final _TranslationsSocialEngagementAs engagement = _TranslationsSocialEngagementAs._(_root);
	@override String get editCaption => 'কেপশ্যন সম্পাদনা কৰক';
	@override String get reportPost => 'প\'‌ষ্টৰ বিৰুদ্ধে রিপোর্ট কৰক';
	@override String get reportReasonHint => 'এই প\'‌ষ্টত কি ভুল আছে সেয়া আমাক কওক';
	@override String get deletePost => 'প\'‌ষ্ট মচি পেলাওক';
	@override String get deletePostConfirm => 'এই কাৰ্য্যটো উলোটা কৰিব নোৱাৰি।';
	@override String get postDeleted => 'প\'‌ষ্ট মচি পেলোৱা হ\'ল';
	@override String failedToDeletePost({required Object error}) => 'প\'‌ষ্ট মচি পেলাবলৈ ব্যৰ্থ: ${error}';
	@override String failedToReportPost({required Object error}) => 'প\'‌ষ্টৰ বিৰুদ্ধে রিপোর্ট কৰিবলৈ ব্যৰ্থ: ${error}';
	@override String get reportSubmitted => 'রিপোর্ট জমা পৰিল। ধন্যবাদ।';
	@override String get acceptRequestFirst => 'প্ৰথমে Requests পৃষ্ঠাত তেওঁলোকৰ অনুৰোধ গ্ৰহণ কৰক।';
	@override String get requestSentWait => 'অনুৰোধ পঠিওৱা হ\'ল। তেওঁলোকে গ্ৰহণ কৰা পৰ্যন্ত অপেক্ষা কৰক।';
	@override String get requestSentTheyWillSee => 'অনুৰোধ পঠিওৱা হ\'ল। তেওঁলোকে তাক "Requests" ত দেখিব।';
	@override String failedToShare({required Object error}) => 'শ্বেয়াৰ কৰাত ব্যৰ্থ: ${error}';
	@override String get updateCaptionHint => 'আপোনাৰ প\'‌ষ্টৰ কেপশ্যন আপডেট কৰক';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroAs extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'অন্বেষণ কৰিবলৈ টেপ কৰক';
	@override late final _TranslationsHomeScreenHeroStoryAs story = _TranslationsHomeScreenHeroStoryAs._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionAs companion = _TranslationsHomeScreenHeroCompanionAs._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageAs heritage = _TranslationsHomeScreenHeroHeritageAs._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityAs community = _TranslationsHomeScreenHeroCommunityAs._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesAs messages = _TranslationsHomeScreenHeroMessagesAs._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthAs extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get short => 'চুটি';
	@override String get medium => 'মধ্যম';
	@override String get long => 'দীঘল';
	@override String get epic => 'বিশাল';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatAs extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'বৰ্ণনামূলক';
	@override String get dialogue => 'সংলাপ ভিত্তিক';
	@override String get poetic => 'কাব্যময়';
	@override String get scriptural => 'শাস্ত্ৰীয়';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsAs extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'কৃষ্ণে অৰ্গুনক শিক্ষা দিয়া গল্পটো কওক...';
	@override String get warriorRedemption => 'উদ্ধাৰ বিচৰা এটা যোদ্ধাৰ বিষয়ে এটা মহাকাব্যিক কাহিনী লিখক...';
	@override String get sageWisdom => 'ঋষিসকলৰ জ্ঞানৰ ওপৰত এটা কাহিনী সৃষ্টি কৰক...';
	@override String get devotedSeeker => 'ভক্তিপ্ৰবণ সন্ধানীৰ যাত্ৰা বৰ্ণনা কৰক...';
	@override String get divineIntervention => 'দেৱীয় হস্তক্ষেপ সম্পৰ্কে এটা দন্তকথা শ্বেয়াৰ কৰক...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsAs extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'অনুগ্ৰহ কৰি সকলো আৱশ্যক বিকল্প সম্পূৰ্ণ কৰক';
	@override String get generationFailed => 'কাহিনী সৃষ্টি কৰাত ব্যৰ্থ। অনুগ্ৰহ কৰি পুনৰ চেষ্টা কৰক।';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsAs extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  নমস্কাৰ!';
	@override String get dharma => '📖  ধৰ্ম কি?';
	@override String get stress => '🧘  চাপ কেনেকৈ সামলাব';
	@override String get karma => '⚡  কৰ্ম সহজকৈ বুজাওক';
	@override String get story => '💬  মোক এটা কাহিনী কওক';
	@override String get wisdom => '🌟  আজিৰ জ্ঞান';
}

// Path: map.discussions
class _TranslationsMapDiscussionsAs extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'আলোচনা পোষ্ট কৰক';
	@override String get intentCardCta => 'এটা আলোচনা পোষ্ট কৰক';
}

// Path: feed.tabs
class _TranslationsFeedTabsAs extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get all => 'সকলো';
	@override String get stories => 'কাহিনী';
	@override String get posts => 'পোস্ট';
	@override String get videos => 'ভিডিঅ\'';
	@override String get images => 'ফটো';
	@override String get text => 'চিন্তা';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileAs extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'প্ৰ\'ফাইল সম্পাদনা কৰক';
	@override String get displayName => 'দেখা নাম';
	@override String get displayNameHint => 'আপোনাৰ দেখা নাম লিখক';
	@override String get displayNameEmpty => 'দেখা নাম খালী থাকিব নোৱাৰ';
	@override String get bio => 'জীৱনৰ বিৱৰণ';
	@override String get bioHint => 'নিজক সম্পৰ্কে কিছুমান কথা কওক...';
	@override String get changePhoto => 'প্ৰ\'ফাইল ফটো সলনি কৰক';
	@override String get saveChanges => 'সলনি সংৰক্ষণ কৰক';
	@override String get profileUpdated => 'প্ৰ\'ফাইল সফলতাৰে আপডেট কৰা হ\'ল';
	@override String get profileAndPhotoUpdated => 'প্ৰ\'ফাইল আৰু ফটো সফলতাৰে আপডেট কৰা হ\'ল';
	@override String failedPickImage({required Object error}) => 'ইমেজ বাছনি কৰাত ব্যৰ্থ: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'ফটো আপলোড কৰাত ব্যৰ্থ: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'প্ৰ\'ফাইল আপডেট কৰাত ব্যৰ্থ: ${error}';
	@override String unexpectedError({required Object error}) => 'অপেক্ষাতীত ভুল: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostAs extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get title => 'প\'‌ষ্ট সৃষ্টি কৰক';
	@override String get post => 'প\'‌ষ্ট';
	@override String get text => 'লিখিত';
	@override String get image => 'ইমেজ';
	@override String get video => 'ভিডিঅ\'';
	@override String get textHint => 'আপোনাৰ মনত কি আছে?';
	@override String get imageCaptionHint => 'আপোনাৰ ফটোৰ বাবে এটা কেপশ্যন লিখক...';
	@override String get videoCaptionHint => 'আপোনাৰ ভিডিঅ\'ৰ বিৱৰণ দিয়ক...';
	@override String get shareCaptionHint => 'আপোনাৰ চিন্তাবোৰ যোগ কৰক...';
	@override String get titleHint => 'এটা শীৰ্ষক যোগ কৰক (ঐচ্ছিক)';
	@override String get selectVideo => 'ভিডিঅ\' বাছনি কৰক';
	@override String get gallery => 'গ্যালাৰী';
	@override String get camera => 'কেমেৰা';
	@override String get visibility => 'কোনে দেখিব পাৰিব?';
	@override String get public => 'সাৰ্বজনীন';
	@override String get followers => 'অনুসৰণকাৰী';
	@override String get private => 'ব্যক্তিগত';
	@override String get postCreated => 'প\'‌ষ্ট সৃষ্টি কৰা হ\'ল!';
	@override String get failedPickImages => 'ইমেজ বাছনি কৰাত ব্যৰ্থ';
	@override String get failedPickVideo => 'ভিডিঅ\' বাছনি কৰাত ব্যৰ্থ';
	@override String get failedCapturePhoto => 'ফটো তোলাত ব্যৰ্থ';
	@override String get cannotCreateOffline => 'অফলাইনে থাকোঁতে প\'‌ষ্ট সৃষ্টি কৰিব নোৱাৰি';
	@override String get discardTitle => 'প\'‌ষ্ট আঁতৰাব নে?';
	@override String get discardMessage => 'কিছুমান সলনি সংৰক্ষণ কৰা হোৱা নাই। আপুনি নিশ্চিত নে এই প\'‌ষ্ট আঁতৰাব খোজে?';
	@override String get keepEditing => 'সম্পাদনা অব্যাহত ৰাখক';
	@override String get discard => 'আঁতৰাওক';
	@override String get cropPhoto => 'ফটো ক্ৰপ কৰক';
	@override String get trimVideo => 'ভিডিঅ\' ট্ৰিম কৰক';
	@override String get editPhoto => 'ফটো সম্পাদনা কৰক';
	@override String get editVideo => 'ভিডিঅ\' সম্পাদনা কৰক';
	@override String get maxDuration => 'সৰ্বাধিক ৩০ ছেকেণ্ড';
	@override String get aspectSquare => 'বৰ্গাকার';
	@override String get aspectPortrait => 'উলম্ব';
	@override String get aspectLandscape => 'আনুভূমিক';
	@override String get aspectFree => 'মুক্ত';
	@override String get failedCrop => 'ফটো ক্ৰপ কৰাত ব্যৰ্থ';
	@override String get failedTrim => 'ভিডিঅ\' ট্ৰিম কৰাত ব্যৰ্থ';
	@override String get trimmingVideo => 'ভিডিঅ\' ট্ৰিম কৰা হৈছে...';
	@override String trimVideoSubtitle({required Object max}) => 'সৰ্বাধিক ${max}সে · আপোনাৰ শ্ৰেষ্ঠ অংশ বাছক';
	@override String get trimVideoInstructionsTitle => 'আপোনাৰ ভিডিঅ\' ট্রিম কৰক';
	@override String get trimVideoInstructionsBody => 'আৰম্ভ আৰু শেষ হেণ্ডেল টানি 30 ছেকেণ্ডলৈকে অংশ বাছক।';
	@override String get trimStart => 'আৰম্ভ';
	@override String get trimEnd => 'শেষ';
	@override String get trimSelectionEmpty => 'আগবাঢ়িবলৈ বৈধ পৰিসৰ বাছক';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}সে নিৰ্বাচিত (${start}–${end}) · সৰ্বাধিক ${max}সে';
	@override String get coverFrame => 'কাভাৰ ফ্ৰেম';
	@override String get coverFrameUnavailable => 'কোনো পূৰ্বদৰ্শন নাই';
	@override String coverFramePosition({required Object time}) => '${time} ত কাভাৰ';
	@override String get overlayLabel => 'ভিডিঅ\'ত লিখনী (ঐচ্ছিক)';
	@override String get overlayHint => 'এটা সৰু হুক বা শিৰোনাম যোগ কৰক';
	@override String get imageSectionHint => 'গ্যালাৰী বা কেমেৰাৰ পৰা সৰ্বাধিক ১০টা ফটো যোগ কৰক';
	@override String get videoSectionHint => 'এটা ভিডিঅ\', সৰ্বাধিক ৩০ ছেকেণ্ড';
	@override String get removePhoto => 'ফটো আঁতৰাওক';
	@override String get removeVideo => 'ভিডিঅ\' আঁতৰাওক';
	@override String get photoEditHint => 'ফটো ক্ৰপ বা আঁতৰাবলৈ টেপ কৰক';
	@override String get videoEditOptions => 'সম্পাদনা বিকল্পসমূহ';
	@override String get addPhoto => 'ফটো যোগ কৰক';
	@override String get done => 'হৈ গ\'ল';
	@override String get rotate => 'ঘুৰাওক';
	@override String get editPhotoSubtitle => 'ফিডত ভাল দেখিবলৈ বৰ্গাকাৰত ক্ৰপ কৰক';
	@override String get videoEditorCaptionLabel => 'কেপশন / লিখনী (ঐচ্ছিক)';
	@override String get videoEditorCaptionHint => 'উদাহৰণ: আপোনাৰ ৰীলৰ শিৰোনাম বা হুক';
	@override String get videoEditorAspectLabel => 'অনুপাত';
	@override String get videoEditorAspectOriginal => 'মূল';
	@override String get videoEditorAspectSquare => '১:১';
	@override String get videoEditorAspectPortrait => '৯:১৬';
	@override String get videoEditorAspectLandscape => '১৬:৯';
	@override String get videoEditorQuickTrim => 'দ্ৰুত ট্রিম';
	@override String get videoEditorSpeed => 'গতি';
}

// Path: social.comments
class _TranslationsSocialCommentsAs extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} ক উত্তৰ দিয়া হৈছে';
	@override String replyHint({required Object name}) => '${name} ক উত্তৰ লিখক...';
	@override String failedToPost({required Object error}) => 'মন্তব্য পোষ্ট কৰাত ব্যৰ্থ: ${error}';
	@override String get cannotPostOffline => 'অফলাইন অৱস্থাত মন্তব্য পোষ্ট কৰিব নোৱাৰি';
	@override String get noComments => 'এতিয়ালৈকে কোনো মন্তব্য নাই';
	@override String get beFirst => 'প্ৰথম মন্তব্য আপুনিয়ে কৰক!';
}

// Path: social.engagement
class _TranslationsSocialEngagementAs extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'অফলাইন মোড';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryAs extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'এআই গল্প সৃষ্টি';
	@override String get headline => 'মুগ্ধকৰ\nগল্প\nসৃষ্টি কৰক';
	@override String get subHeadline => 'প্ৰাচীন জ্ঞানৰ শক্তিত';
	@override String get line1 => '✦  এটা পবিত্ৰ শাস্ত্ৰ বাছনি কৰক...';
	@override String get line2 => '✦  এটা জীৱন্ত পৰিৱেশ বাছনি কৰক...';
	@override String get line3 => '✦  এআইক মোহনীয় কাহিনী গাঁথিবলৈ দিয়ক...';
	@override String get cta => 'গল্প সৃষ্টি কৰক';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionAs extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'আধ্যাত্মিক সঙ্গী';
	@override String get headline => 'আপোনাৰ দেৱীয়\nপথপ্ৰদৰ্শক,\nসদায় কাষত';
	@override String get subHeadline => 'কৃষ্ণৰ জ্ঞানৰ প্ৰেৰণা';
	@override String get line1 => '✦  এজন বন্ধু যিয়ে সঁচাকৈ শুনে...';
	@override String get line2 => '✦  জীৱনৰ সংকটত জ্ঞান...';
	@override String get line3 => '✦  আপোনাক উন্নত কৰা আলাপ...';
	@override String get cta => 'চেট আৰম্ভ কৰক';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageAs extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ঐতিহ্যৰ মানচিত্ৰ';
	@override String get headline => 'চিৰন্তন\nঐতিহ্য\nআৱিষ্কাৰ কৰক';
	@override String get subHeadline => '5000+ পবিত্ৰ স্থান মানচিত্ৰত';
	@override String get line1 => '✦  পবিত্ৰ স্থানসমূহ অন্বেষণ কৰক...';
	@override String get line2 => '✦  ইতিহাস আৰু লোককথা পঢ়ক...';
	@override String get line3 => '✦  অৰ্থপূর্ণ যাত্ৰাৰ পৰিকল্পনা কৰক...';
	@override String get cta => 'মানচিত্ৰ অন্বেষণ কৰক';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityAs extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'সম্প্ৰদায় ক্ষেত্ৰ';
	@override String get headline => 'সংস্কৃতি\nবিশ্বৰ সৈতে\nভাগ কৰক';
	@override String get subHeadline => 'এটা সজীৱ বিশ্বব্যাপী সম্প্ৰদায়';
	@override String get line1 => '✦  পোষ্ট আৰু গভীৰ আলোচনা...';
	@override String get line2 => '✦  সৰু সাংস্কৃতিক ভিডিঅ\'...';
	@override String get line3 => '✦  বিশ্বজুৰি গল্পসমূহ...';
	@override String get cta => 'সম্প্ৰদায়ত যোগ দিয়ক';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesAs extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesAs._(TranslationsAs root) : this._root = root, super.internal(root);

	final TranslationsAs _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ব্যক্তিগত বাৰ্তা';
	@override String get headline => 'অৰ্থপূর্ণ\nআলাপ\nইয়াৰ পৰাই আৰম্ভ';
	@override String get subHeadline => 'ব্যক্তিগত আৰু চিন্তাশীল স্থান';
	@override String get line1 => '✦  সমমনা আত্মাৰ সৈতে সংযোগ কৰক...';
	@override String get line2 => '✦  ধাৰণা আৰু গল্প আলোচনা কৰক...';
	@override String get line3 => '✦  চিন্তাশীল সম্প্ৰদায় গঢ়ক...';
	@override String get cta => 'বাৰ্তা খোলক';
}
