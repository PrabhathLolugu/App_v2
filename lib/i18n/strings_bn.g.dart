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
class TranslationsBn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsBn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.bn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <bn>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsBn _root = this; // ignore: unused_field

	@override 
	TranslationsBn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsBn(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppBn app = _TranslationsAppBn._(_root);
	@override late final _TranslationsCommonBn common = _TranslationsCommonBn._(_root);
	@override late final _TranslationsNavigationBn navigation = _TranslationsNavigationBn._(_root);
	@override late final _TranslationsHomeBn home = _TranslationsHomeBn._(_root);
	@override late final _TranslationsHomeScreenBn homeScreen = _TranslationsHomeScreenBn._(_root);
	@override late final _TranslationsStoriesBn stories = _TranslationsStoriesBn._(_root);
	@override late final _TranslationsStoryGeneratorBn storyGenerator = _TranslationsStoryGeneratorBn._(_root);
	@override late final _TranslationsChatBn chat = _TranslationsChatBn._(_root);
	@override late final _TranslationsMapBn map = _TranslationsMapBn._(_root);
	@override late final _TranslationsCommunityBn community = _TranslationsCommunityBn._(_root);
	@override late final _TranslationsDiscoverBn discover = _TranslationsDiscoverBn._(_root);
	@override late final _TranslationsPlanBn plan = _TranslationsPlanBn._(_root);
	@override late final _TranslationsSettingsBn settings = _TranslationsSettingsBn._(_root);
	@override late final _TranslationsAuthBn auth = _TranslationsAuthBn._(_root);
	@override late final _TranslationsErrorBn error = _TranslationsErrorBn._(_root);
	@override late final _TranslationsSubscriptionBn subscription = _TranslationsSubscriptionBn._(_root);
	@override late final _TranslationsNotificationBn notification = _TranslationsNotificationBn._(_root);
	@override late final _TranslationsProfileBn profile = _TranslationsProfileBn._(_root);
	@override late final _TranslationsFeedBn feed = _TranslationsFeedBn._(_root);
	@override late final _TranslationsSocialBn social = _TranslationsSocialBn._(_root);
	@override late final _TranslationsVoiceBn voice = _TranslationsVoiceBn._(_root);
	@override late final _TranslationsFestivalsBn festivals = _TranslationsFestivalsBn._(_root);
}

// Path: app
class _TranslationsAppBn extends TranslationsAppEn {
	_TranslationsAppBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'ভারতীয় শাস্ত্র আবিষ্কার করুন';
}

// Path: common
class _TranslationsCommonBn extends TranslationsCommonEn {
	_TranslationsCommonBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ঠিক আছে';
	@override String get cancel => 'বাতিল';
	@override String get confirm => 'নিশ্চিত করুন';
	@override String get delete => 'মুছে ফেলুন';
	@override String get edit => 'সম্পাদনা করুন';
	@override String get save => 'সংরক্ষণ করুন';
	@override String get share => 'শেয়ার করুন';
	@override String get search => 'খুঁজুন';
	@override String get loading => 'লোড হচ্ছে...';
	@override String get error => 'ত্রুটি';
	@override String get retry => 'আবার চেষ্টা করুন';
	@override String get back => 'পেছনে';
	@override String get next => 'পরবর্তী';
	@override String get finish => 'শেষ';
	@override String get skip => 'এড়িয়ে যান';
	@override String get yes => 'হ্যাঁ';
	@override String get no => 'না';
	@override String get readFullStory => 'পুরো গল্পটি পড়ুন';
	@override String get dismiss => 'বন্ধ করুন';
	@override String get offlineBannerMessage => 'আপনি অফলাইনে আছেন – সংরক্ষিত কনটেন্ট দেখছেন';
	@override String get backOnline => 'আবার অনলাইনে';
}

// Path: navigation
class _TranslationsNavigationBn extends TranslationsNavigationEn {
	_TranslationsNavigationBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get home => 'অন্বেষণ';
	@override String get stories => 'গল্প';
	@override String get chat => 'চ্যাট';
	@override String get map => 'মানচিত্র';
	@override String get community => 'সামাজিক';
	@override String get settings => 'সেটিংস';
	@override String get profile => 'প্রোফাইল';
}

// Path: home
class _TranslationsHomeBn extends TranslationsHomeEn {
	_TranslationsHomeBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'গল্প প্রস্তুতকারী';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'কমিউনিটি গল্প';
	@override String get maps => 'মানচিত্রসমূহ';
	@override String get greetingMorning => 'শুভ সকাল';
	@override String get continueReading => 'পড়া চালিয়ে যান';
	@override String get greetingAfternoon => 'শুভ দুপুর';
	@override String get greetingEvening => 'শুভ সন্ধ্যা';
	@override String get greetingNight => 'শুভ রাত্রি';
	@override String get exploreStories => 'গল্প আবিষ্কার করুন';
	@override String get generateStory => 'গল্প তৈরি করুন';
	@override String get content => 'হোম কনটেন্ট';
}

// Path: homeScreen
class _TranslationsHomeScreenBn extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'হ্যালো';
	@override String get quoteOfTheDay => 'আজকের উক্তি';
	@override String get shareQuote => 'উক্তি শেয়ার করুন';
	@override String get copyQuote => 'উক্তি কপি করুন';
	@override String get quoteCopied => 'উক্তি ক্লিপবোর্ডে কপি হয়েছে';
	@override String get featuredStories => 'বাছাইকৃত গল্প';
	@override String get quickActions => 'দ্রুত কাজ';
	@override String get generateStory => 'গল্প তৈরি করুন';
	@override String get chatWithKrishna => 'কৃষ্ণের সাথে কথা বলুন';
	@override String get myActivity => 'আমার কার্যকলাপ';
	@override String get continueReading => 'পড়া চালিয়ে যান';
	@override String get savedStories => 'সংরক্ষিত গল্প';
	@override String get exploreMyitihas => 'মাইইতিহাস অন্বেষণ করুন';
	@override String get storiesInYourLanguage => 'আপনার ভাষায় গল্প';
	@override String get seeAll => 'সব দেখুন';
	@override String get startReading => 'পড়া শুরু করুন';
	@override String get exploreStories => 'আপনার যাত্রা শুরু করতে গল্প আবিষ্কার করুন';
	@override String get saveForLater => 'যে গল্পগুলো ভালো লাগে সেগুলো বুকমার্ক করুন';
	@override String get noActivityYet => 'এখনও কোনো কার্যকলাপ নেই';
	@override String minLeft({required Object count}) => '${count} মিনিট বাকি';
	@override String get activityHistory => 'কার্যকলাপের ইতিহাস';
	@override String get storyGenerated => 'একটি গল্প তৈরি হয়েছে';
	@override String get storyRead => 'একটি গল্প পড়া হয়েছে';
	@override String get storyBookmarked => 'গল্প বুকমার্ক করা হয়েছে';
	@override String get storyShared => 'গল্প শেয়ার করা হয়েছে';
	@override String get storyCompleted => 'গল্প সম্পূর্ণ হয়েছে';
	@override String get today => 'আজ';
	@override String get yesterday => 'গতকাল';
	@override String get thisWeek => 'এই সপ্তাহ';
	@override String get earlier => 'এর আগের';
	@override String get noContinueReading => 'এখনো পড়ার মত কিছু নেই';
	@override String get noSavedStories => 'এখনো কোনো সংরক্ষিত গল্প নেই';
	@override String get bookmarkStoriesToSave => 'গল্প সংরক্ষণ করতে বুকমার্ক করুন';
	@override String get myGeneratedStories => 'আমার গল্প';
	@override String get noGeneratedStoriesYet => 'এখনো কোনো গল্প তৈরি করা হয়নি';
	@override String get createYourFirstStory => 'AI দিয়ে আপনার প্রথম গল্প তৈরি করুন';
	@override String get shareToFeed => 'ফিডে শেয়ার করুন';
	@override String get sharedToFeed => 'গল্প ফিডে শেয়ার করা হয়েছে';
	@override String get shareStoryTitle => 'গল্প শেয়ার করুন';
	@override String get shareStoryMessage => 'আপনার গল্পের জন্য ক্যাপশন লিখুন (ঐচ্ছিক)';
	@override String get shareStoryCaption => 'ক্যাপশন';
	@override String get shareStoryHint => 'এই গল্পটি সম্পর্কে আপনি কী বলতে চান?';
	@override String get exploreHeritageTitle => 'ঐতিহ্য আবিষ্কার করুন';
	@override String get exploreHeritageDesc => 'মানচিত্রে সংস্কৃতির ঐতিহ্যবাহী স্থানগুলি খুঁজে বের করুন';
	@override String get whereToVisit => 'পরবর্তী ভ্রমণ';
	@override String get scriptures => 'শাস্ত্র';
	@override String get exploreSacredSites => 'পবিত্র স্থান আবিষ্কার করুন';
	@override String get readStories => 'গল্প পড়ুন';
	@override String get yesRemindMe => 'হ্যাঁ, আমাকে মনে করিয়ে দিন';
	@override String get noDontShowAgain => 'না, আর দেখাবেন না';
	@override String get discoverDismissTitle => 'Discover MyItihas লুকিয়ে রাখবেন?';
	@override String get discoverDismissMessage => 'আপনি কি পরেরবার অ্যাপ খুললে বা লগইন করলে এটি আবার দেখতে চান?';
	@override String get discoverCardTitle => 'MyItihas আবিষ্কার করুন';
	@override String get discoverCardSubtitle => 'প্রাচীন শাস্ত্রের গল্প, ঘুরে দেখার পবিত্র স্থান এবং হাতের মুঠোয় জ্ঞান।';
	@override String get swipeToDismiss => 'বন্ধ করতে উপরের দিকে সোয়াইপ করুন';
	@override String get searchScriptures => 'শাস্ত্র খুঁজুন...';
	@override String get searchLanguages => 'ভাষা খুঁজুন...';
	@override String get exploreStoriesLabel => 'গল্প আবিষ্কার করুন';
	@override String get exploreMore => 'আরও দেখুন';
	@override String get failedToLoadActivity => 'কার্যকলাপ লোড করতে ব্যর্থ';
	@override String get startReadingOrGenerating => 'এখানে আপনার কার্যকলাপ দেখতে পড়া বা গল্প তৈরি করা শুরু করুন';
	@override late final _TranslationsHomeScreenHeroBn hero = _TranslationsHomeScreenHeroBn._(_root);
}

// Path: stories
class _TranslationsStoriesBn extends TranslationsStoriesEn {
	_TranslationsStoriesBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'গল্প';
	@override String get searchHint => 'শিরোনাম বা লেখক দিয়ে খুঁজুন...';
	@override String get sortBy => 'সাজান';
	@override String get sortNewest => 'নতুন প্রথমে';
	@override String get sortOldest => 'পুরোনো প্রথমে';
	@override String get sortPopular => 'সবচেয়ে জনপ্রিয়';
	@override String get noStories => 'কোনো গল্প পাওয়া যায়নি';
	@override String get loadingStories => 'গল্প লোড হচ্ছে...';
	@override String get errorLoadingStories => 'গল্প লোড করতে ব্যর্থ';
	@override String get storyDetails => 'গল্পের বিস্তারিত';
	@override String get continueReading => 'পড়া চালিয়ে যান';
	@override String get readMore => 'আরও পড়ুন';
	@override String get readLess => 'কম দেখান';
	@override String get author => 'লেখক';
	@override String get publishedOn => 'প্রকাশের তারিখ';
	@override String get category => 'বিভাগ';
	@override String get tags => 'ট্যাগ';
	@override String get failedToLoad => 'গল্প লোড করতে ব্যর্থ';
	@override String get subtitle => 'শাস্ত্রের গল্প আবিষ্কার করুন';
	@override String get noStoriesHint => 'ভিন্ন সার্চ বা ফিল্টার চেষ্টা করে গল্প খুঁজুন।';
	@override String get featured => 'বাছাইকৃত';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorBn extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'গল্প প্রস্তুতকারী';
	@override String get subtitle => 'নিজের শাস্ত্রীয় গল্প তৈরি করুন';
	@override String get quickStart => 'দ্রুত শুরু';
	@override String get interactive => 'ইন্টারঅ্যাকটিভ';
	@override String get rawPrompt => 'কাঁচা প্রম্পট';
	@override String get yourStoryPrompt => 'আপনার গল্পের প্রম্পট';
	@override String get writeYourPrompt => 'আপনার প্রম্পট লিখুন';
	@override String get selectScripture => 'শাস্ত্র নির্বাচন করুন';
	@override String get selectStoryType => 'গল্পের ধরন নির্বাচন করুন';
	@override String get selectCharacter => 'চরিত্র নির্বাচন করুন';
	@override String get selectTheme => 'থিম নির্বাচন করুন';
	@override String get selectSetting => 'পরিবেশ নির্বাচন করুন';
	@override String get selectLanguage => 'ভাষা নির্বাচন করুন';
	@override String get selectLength => 'গল্পের দৈর্ঘ্য';
	@override String get moreOptions => 'আরও বিকল্প';
	@override String get random => 'এলোমেলো';
	@override String get generate => 'গল্প তৈরি করুন';
	@override String get generating => 'আপনার গল্প তৈরি হচ্ছে...';
	@override String get creatingYourStory => 'আপনার গল্প তৈরি করা হচ্ছে';
	@override String get consultingScriptures => 'প্রাচীন শাস্ত্র থেকে পরামর্শ নেওয়া হচ্ছে...';
	@override String get weavingTale => 'আপনার কাহিনী বোনা হচ্ছে...';
	@override String get addingWisdom => 'দিব্য জ্ঞান যোগ করা হচ্ছে...';
	@override String get polishingNarrative => 'কাহিনী শান দেওয়া হচ্ছে...';
	@override String get almostThere => 'প্রায় হয়ে গেছে...';
	@override String get generatedStory => 'আপনার তৈরি করা গল্প';
	@override String get aiGenerated => 'AI দ্বারা তৈরি';
	@override String get regenerate => 'আবার তৈরি করুন';
	@override String get saveStory => 'গল্প সংরক্ষণ করুন';
	@override String get shareStory => 'গল্প শেয়ার করুন';
	@override String get newStory => 'নতুন গল্প';
	@override String get saved => 'সংরক্ষিত';
	@override String get storySaved => 'গল্পটি আপনার লাইব্রেরিতে সংরক্ষিত হয়েছে';
	@override String get story => 'গল্প';
	@override String get lesson => 'শিক্ষা';
	@override String get didYouKnow => 'জানেন কি?';
	@override String get activity => 'কার্যকলাপ';
	@override String get optionalRefine => 'ঐচ্ছিক: বিকল্প দিয়ে আরো নির্দিষ্ট করুন';
	@override String get applyOptions => 'বিকল্প প্রয়োগ করুন';
	@override String get language => 'ভাষা';
	@override String get storyFormat => 'গল্পের ফরম্যাট';
	@override String get requiresInternet => 'গল্প তৈরি করতে ইন্টারনেট প্রয়োজন';
	@override String get notAvailableOffline => 'গল্প অফলাইনে পাওয়া যাবে না। দেখার জন্য ইন্টারনেটে যুক্ত হোন।';
	@override String get aiDisclaimer => 'AI ভুল করতে পারে। আমরা ক্রমাগত উন্নতি করছি; আপনার মতামত গুরুত্বপূর্ণ।';
	@override late final _TranslationsStoryGeneratorStoryLengthBn storyLength = _TranslationsStoryGeneratorStoryLengthBn._(_root);
	@override late final _TranslationsStoryGeneratorFormatBn format = _TranslationsStoryGeneratorFormatBn._(_root);
	@override late final _TranslationsStoryGeneratorHintsBn hints = _TranslationsStoryGeneratorHintsBn._(_root);
	@override late final _TranslationsStoryGeneratorErrorsBn errors = _TranslationsStoryGeneratorErrorsBn._(_root);
}

// Path: chat
class _TranslationsChatBn extends TranslationsChatEn {
	_TranslationsChatBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'শাস্ত্র নিয়ে AI-এর সঙ্গে চ্যাট করুন';
	@override String get friendMode => 'বন্ধু মোড';
	@override String get philosophicalMode => 'দার্শনিক মোড';
	@override String get typeMessage => 'আপনার বার্তা লিখুন...';
	@override String get send => 'পাঠান';
	@override String get newChat => 'নতুন চ্যাট';
	@override String get chatsTab => 'চ্যাট';
	@override String get groupsTab => 'গ্রুপ';
	@override String get chatHistory => 'চ্যাটের ইতিহাস';
	@override String get clearChat => 'চ্যাট মুছে ফেলুন';
	@override String get noMessages => 'এখনও কোনো বার্তা নেই। একটি কথোপকথন শুরু করুন!';
	@override String get listPage => 'চ্যাট তালিকা পৃষ্ঠা';
	@override String get forwardMessageTo => 'বার্তা ফরওয়ার্ড করুন...';
	@override String get forwardMessage => 'বার্তা ফরওয়ার্ড করুন';
	@override String get messageForwarded => 'বার্তা ফরওয়ার্ড করা হয়েছে';
	@override String failedToForward({required Object error}) => 'বার্তা ফরওয়ার্ড করতে ব্যর্থ: ${error}';
	@override String get searchChats => 'চ্যাট খুঁজুন';
	@override String get noChatsFound => 'কোনো চ্যাট পাওয়া যায়নি';
	@override String get requests => 'রিকোয়েস্ট';
	@override String get messageRequests => 'বার্তা রিকোয়েস্ট';
	@override String get groupRequests => 'গ্রুপ রিকোয়েস্ট';
	@override String get requestSent => 'রিকোয়েস্ট পাঠানো হয়েছে। তারা "রিকোয়েস্ট" অংশে দেখবে।';
	@override String get wantsToChat => 'চ্যাট করতে চায়';
	@override String addedYouTo({required Object name}) => '${name} আপনাকে যোগ করেছে';
	@override String get accept => 'গ্রহণ করুন';
	@override String get noMessageRequests => 'কোনো বার্তা রিকোয়েস্ট নেই';
	@override String get noGroupRequests => 'কোনো গ্রুপ রিকোয়েস্ট নেই';
	@override String get invitesSent => 'আমন্ত্রণ পাঠানো হয়েছে। তারা "রিকোয়েস্ট" অংশে দেখবে।';
	@override String get cantMessageUser => 'এই ব্যবহারকারীকে বার্তা পাঠানো যাচ্ছে না';
	@override String get deleteChat => 'চ্যাট মুছে ফেলুন';
	@override String get deleteChats => 'চ্যাটগুলো মুছে ফেলুন';
	@override String get blockUser => 'ব্যবহারকারীকে ব্লক করুন';
	@override String get reportUser => 'ব্যবহারকারীকে রিপোর্ট করুন';
	@override String get markAsRead => 'পড়া হয়েছে হিসেবে চিহ্নিত করুন';
	@override String get markedAsRead => 'পড়া হয়েছে হিসেবে চিহ্নিত করা হয়েছে';
	@override String get deleteClearChat => 'চ্যাট মুছে ফেলুন / পরিষ্কার করুন';
	@override String get deleteConversation => 'কথোপকথন মুছে ফেলুন';
	@override String get reasonRequired => 'কারণ (প্রয়োজনীয়)';
	@override String get submit => 'সাবমিট করুন';
	@override String get userReportedBlocked => 'ব্যবহারকারী রিপোর্ট করা হয়েছে এবং ব্লক করা হয়েছে।';
	@override String reportFailed({required Object error}) => 'রিপোর্ট করতে ব্যর্থ: ${error}';
	@override String get newGroup => 'নতুন গ্রুপ';
	@override String get messageSomeoneDirectly => 'কাউকে সরাসরি বার্তা পাঠান';
	@override String get createGroupConversation => 'গ্রুপ কথোপকথন তৈরি করুন';
	@override String get noGroupsYet => 'এখনও কোনো গ্রুপ নেই';
	@override String get noChatsYet => 'এখনও কোনো চ্যাট নেই';
	@override String get tapToCreateGroup => 'গ্রুপ তৈরি বা যোগ দিতে + চাপুন';
	@override String get tapToStartConversation => 'নতুন কথোপকথন শুরু করতে + চাপুন';
	@override String get conversationDeleted => 'কথোপকথন মুছে ফেলা হয়েছে';
	@override String conversationsDeleted({required Object count}) => '${count}টি কথোপকথন মুছে ফেলা হয়েছে';
	@override String get searchConversations => 'কথোপকথন খুঁজুন...';
	@override String get connectToInternet => 'দয়া করে ইন্টারনেটে যুক্ত হয়ে আবার চেষ্টা করুন।';
	@override String get littleKrishnaName => 'ছোট কৃষ্ণ';
	@override String get newConversation => 'নতুন কথোপকথন';
	@override String get noConversationsYet => 'এখনও কোনো কথোপকথন নেই';
	@override String get confirmDeletion => 'মুছে ফেলার নিশ্চয়তা দিন';
	@override String deleteConversationConfirm({required Object title}) => 'আপনি কি সত্যিই ${title} কথোপকথন মুছে ফেলতে চান?';
	@override String get deleteFailed => 'কথোপকথন মুছে ফেলতে ব্যর্থ';
	@override String get fullChatCopied => 'সম্পূর্ণ চ্যাট ক্লিপবোর্ডে কপি হয়েছে!';
	@override String get connectionErrorFallback => 'এখন সংযোগ করতে সমস্যা হচ্ছে। একটু পরে আবার চেষ্টা করুন।';
	@override String krishnaWelcomeWithName({required Object name}) => 'হে ${name}। আমি আপনার বন্ধু কৃষ্ণ। আজ আপনি কেমন আছেন?';
	@override String get krishnaWelcomeFriend => 'হে প্রিয় বন্ধু, আমি কৃষ্ণ, আপনার বন্ধু। আজ আপনি কেমন আছেন?';
	@override String get copyYouLabel => 'আপনি';
	@override String get copyKrishnaLabel => 'কৃষ্ণ';
	@override late final _TranslationsChatSuggestionsBn suggestions = _TranslationsChatSuggestionsBn._(_root);
	@override String get about => 'সম্পর্কে';
	@override String get yourFriendlyCompanion => 'আপনার বন্ধুসুলভ সঙ্গী';
	@override String get mentalHealthSupport => 'মানসিক স্বাস্থ্যের সহায়তা';
	@override String get mentalHealthSupportSubtitle => 'ভাবনা ভাগ করে নেওয়ার এবং শোনা বোধ করার জন্য নিরাপদ জায়গা।';
	@override String get friendlyCompanion => 'বন্ধুসুলভ সঙ্গী';
	@override String get friendlyCompanionSubtitle => 'সবসময় কথা বলতে, সাহস জোগাতে এবং জ্ঞান ভাগ করতে পাশে থাকে।';
	@override String get storiesAndWisdom => 'গল্প ও প্রজ্ঞা';
	@override String get storiesAndWisdomSubtitle => 'চিরন্তন কাহিনী ও প্র্যাকটিক্যাল জ্ঞান থেকে শিখুন।';
	@override String get askAnything => 'যেকোনো কিছু জিজ্ঞাসা করুন';
	@override String get askAnythingSubtitle => 'আপনার প্রশ্নের নরম, ভাবনাশীল উত্তর পান।';
	@override String get startChatting => 'চ্যাট শুরু করুন';
	@override String get maybeLater => 'হয়তো পরে';
	@override late final _TranslationsChatComposerAttachmentsBn composerAttachments = _TranslationsChatComposerAttachmentsBn._(_root);
}

// Path: map
class _TranslationsMapBn extends TranslationsMapEn {
	_TranslationsMapBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'অখণ্ড ভারত';
	@override String get subtitle => 'ঐতিহাসিক স্থান আবিষ্কার করুন';
	@override String get searchLocation => 'স্থান খুঁজুন...';
	@override String get viewDetails => 'বিস্তারিত দেখুন';
	@override String get viewSites => 'সাইট দেখুন';
	@override String get showRoute => 'রুট দেখান';
	@override String get historicalInfo => 'ঐতিহাসিক তথ্য';
	@override String get nearbyPlaces => 'পার্শ্ববর্তী স্থান';
	@override String get pickLocationOnMap => 'মানচিত্রে স্থান নির্বাচন করুন';
	@override String get sitesVisited => 'দর্শন করা স্থান';
	@override String get badgesEarned => 'অর্জিত ব্যাজ';
	@override String get completionRate => 'সম্পূর্ণতার হার';
	@override String get addToJourney => 'যাত্রায় যোগ করুন';
	@override String get addedToJourney => 'যাত্রায় যোগ করা হয়েছে';
	@override String get getDirections => 'পথনির্দেশ নিন';
	@override String get viewInMap => 'মানচিত্রে দেখুন';
	@override String get directions => 'দিকনির্দেশ';
	@override String get photoGallery => 'ছবির গ্যালারি';
	@override String get viewAll => 'সব দেখুন';
	@override String get photoSavedToGallery => 'ছবি গ্যালারিতে সংরক্ষিত হয়েছে';
	@override String get sacredSoundscape => 'পবিত্র শব্দমালা';
	@override String get allDiscussions => 'সব আলোচনা';
	@override String get journeyTab => 'যাত্রা';
	@override String get discussionTab => 'আলোচনা';
	@override String get myActivity => 'আমার কার্যকলাপ';
	@override String get anonymousPilgrim => 'নামহীন তীর্থযাত্রী';
	@override String get viewProfile => 'প্রোফাইল দেখুন';
	@override String get discussionTitleHint => 'আলোচনার শিরোনাম...';
	@override String get shareYourThoughtsHint => 'আপনার ভাবনা শেয়ার করুন...';
	@override String get pleaseEnterDiscussionTitle => 'অনুগ্রহ করে আলোচনার শিরোনাম লিখুন';
	@override String get addReflection => 'অনুভূতি যোগ করুন';
	@override String get reflectionTitle => 'শিরোনাম';
	@override String get enterReflectionTitle => 'অনুভূতির শিরোনাম লিখুন';
	@override String get pleaseEnterTitle => 'অনুগ্রহ করে একটি শিরোনাম লিখুন';
	@override String get siteName => 'স্থানের নাম';
	@override String get enterSacredSiteName => 'পবিত্র স্থানের নাম লিখুন';
	@override String get pleaseEnterSiteName => 'অনুগ্রহ করে স্থানের নাম লিখুন';
	@override String get reflection => 'অনুভূতি';
	@override String get reflectionHint => 'আপনার অভিজ্ঞতা ও ভাবনা শেয়ার করুন...';
	@override String get pleaseEnterReflection => 'অনুগ্রহ করে আপনার অনুভূতি লিখুন';
	@override String get saveReflection => 'অনুভূতি সংরক্ষণ করুন';
	@override String get journeyProgress => 'যাত্রার অগ্রগতি';
	@override late final _TranslationsMapDiscussionsBn discussions = _TranslationsMapDiscussionsBn._(_root);
	@override late final _TranslationsMapFabricMapBn fabricMap = _TranslationsMapFabricMapBn._(_root);
	@override late final _TranslationsMapClassicalArtMapBn classicalArtMap = _TranslationsMapClassicalArtMapBn._(_root);
	@override late final _TranslationsMapClassicalDanceMapBn classicalDanceMap = _TranslationsMapClassicalDanceMapBn._(_root);
	@override late final _TranslationsMapFoodMapBn foodMap = _TranslationsMapFoodMapBn._(_root);
}

// Path: community
class _TranslationsCommunityBn extends TranslationsCommunityEn {
	_TranslationsCommunityBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'কমিউনিটি';
	@override String get trending => 'ট্রেন্ডিং';
	@override String get following => 'ফলো করছেন';
	@override String get followers => 'ফলোয়ার';
	@override String get posts => 'পোস্ট';
	@override String get follow => 'ফলো করুন';
	@override String get unfollow => 'আনফলো করুন';
	@override String get shareYourStory => 'আপনার গল্প শেয়ার করুন...';
	@override String get post => 'পোস্ট করুন';
	@override String get like => 'লাইক';
	@override String get comment => 'কমেন্ট';
	@override String get comments => 'কমেন্টসমূহ';
	@override String get noPostsYet => 'এখনও কোনো পোস্ট নেই';
}

// Path: discover
class _TranslationsDiscoverBn extends TranslationsDiscoverEn {
	_TranslationsDiscoverBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'আবিষ্কার';
	@override String get searchHint => 'গল্প, ব্যবহারকারী বা বিষয় খুঁজুন...';
	@override String get tryAgain => 'আবার চেষ্টা করুন';
	@override String get somethingWentWrong => 'কিছু ভুল হয়েছে';
	@override String get unableToLoadProfiles => 'প্রোফাইল লোড করা যাচ্ছে না। আবার চেষ্টা করুন।';
	@override String get noProfilesFound => 'কোনো প্রোফাইল পাওয়া যায়নি';
	@override String get searchToFindPeople => 'ফলো করার জন্য মানুষ খুঁজুন';
	@override String get noResultsFound => 'কোনো ফলাফল পাওয়া যায়নি';
	@override String get noProfilesYet => 'এখনও কোনো প্রোফাইল নেই';
	@override String get tryDifferentKeywords => 'অন্য কীওয়ার্ড দিয়ে চেষ্টা করুন';
	@override String get beFirstToDiscover => 'নতুন মানুষ আবিষ্কার করার প্রথম ব্যক্তি হন!';
}

// Path: plan
class _TranslationsPlanBn extends TranslationsPlanEn {
	_TranslationsPlanBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'আপনার পরিকল্পনা সংরক্ষণ করতে সাইন ইন করুন';
	@override String get planSaved => 'পরিকল্পনা সংরক্ষিত হয়েছে';
	@override String get from => 'থেকে';
	@override String get dates => 'তারিখ';
	@override String get destination => 'গন্তব্য';
	@override String get nearby => 'আশেপাশে';
	@override String get generatedPlan => 'তৈরি করা পরিকল্পনা';
	@override String get whereTravellingFrom => 'আপনি কোথা থেকে ভ্রমণ করছেন?';
	@override String get enterCityOrRegion => 'আপনার শহর বা অঞ্চল লিখুন';
	@override String get travelDates => 'ভ্রমণের তারিখ';
	@override String get destinationSacredSite => 'গন্তব্য (পবিত্র স্থান)';
	@override String get searchOrSelectDestination => 'গন্তব্য খুঁজুন বা নির্বাচন করুন...';
	@override String get shareYourExperience => 'আপনার অভিজ্ঞতা শেয়ার করুন';
	@override String get planShared => 'পরিকল্পনা শেয়ার করা হয়েছে';
	@override String failedToSharePlan({required Object error}) => 'পরিকল্পনা শেয়ার করতে ব্যর্থ: ${error}';
	@override String get planUpdated => 'পরিকল্পনা আপডেট হয়েছে';
	@override String failedToUpdatePlan({required Object error}) => 'পরিকল্পনা আপডেট করতে ব্যর্থ: ${error}';
	@override String get deletePlanConfirm => 'পরিকল্পনা মুছে ফেলবেন?';
	@override String get thisPlanPermanentlyDeleted => 'এই পরিকল্পনাটি স্থায়ীভাবে মুছে ফেলা হবে।';
	@override String get planDeleted => 'পরিকল্পনা মুছে ফেলা হয়েছে';
	@override String failedToDeletePlan({required Object error}) => 'পরিকল্পনা মুছে ফেলতে ব্যর্থ: ${error}';
	@override String get sharePlan => 'পরিকল্পনা শেয়ার করুন';
	@override String get deletePlan => 'পরিকল্পনা মুছে ফেলুন';
	@override String get savedPlanDetails => 'সংরক্ষিত পরিকল্পনার বিস্তারিত';
	@override String get pilgrimagePlan => 'তীর্থযাত্রার পরিকল্পনা';
	@override String get planTab => 'পরিকল্পনা';
}

// Path: settings
class _TranslationsSettingsBn extends TranslationsSettingsEn {
	_TranslationsSettingsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'সেটিংস';
	@override String get language => 'ভাষা';
	@override String get theme => 'থিম';
	@override String get themeLight => 'লাইট';
	@override String get themeDark => 'ডার্ক';
	@override String get themeSystem => 'সিস্টেম থিম ব্যবহার করুন';
	@override String get darkMode => 'ডার্ক মোড';
	@override String get selectLanguage => 'ভাষা নির্বাচন করুন';
	@override String get notifications => 'নোটিফিকেশন';
	@override String get cacheSettings => 'ক্যাশে ও স্টোরেজ';
	@override String get general => 'সাধারণ';
	@override String get account => 'অ্যাকাউন্ট';
	@override String get blockedUsers => 'ব্লক করা ব্যবহারকারী';
	@override String get helpSupport => 'সহায়তা ও সাপোর্ট';
	@override String get contactUs => 'আমাদের সাথে যোগাযোগ করুন';
	@override String get legal => 'আইনি';
	@override String get privacyPolicy => 'গোপনীয়তা নীতি';
	@override String get termsConditions => 'শর্তাবলী';
	@override String get privacy => 'গোপনীয়তা';
	@override String get about => 'অ্যাপ সম্পর্কে';
	@override String get version => 'ভার্সন';
	@override String get logout => 'লগআউট';
	@override String get deleteAccount => 'অ্যাকাউন্ট মুছে ফেলুন';
	@override String get deleteAccountTitle => 'অ্যাকাউন্ট মুছে ফেলুন';
	@override String get deleteAccountWarning => 'এই কাজটি আর ফেরত নেওয়া যাবে না!';
	@override String get deleteAccountDescription => 'আপনার অ্যাকাউন্ট মুছে ফেললে আপনার সব পোস্ট, কমেন্ট, প্রোফাইল, ফলোয়ার, সংরক্ষিত গল্প, বুকমার্ক, চ্যাট বার্তা এবং তৈরি করা গল্প স্থায়ীভাবে মুছে যাবে।';
	@override String get confirmPassword => 'আপনার পাসওয়ার্ড নিশ্চিত করুন';
	@override String get confirmPasswordDesc => 'অ্যাকাউন্ট মুছে ফেলার জন্য আপনার পাসওয়ার্ড লিখুন।';
	@override String get googleReauth => 'আপনার পরিচয় যাচাই করতে আপনাকে Google-এ পাঠানো হবে।';
	@override String get finalConfirmationTitle => 'চূড়ান্ত নিশ্চিতকরণ';
	@override String get finalConfirmation => 'আপনি কি একদম নিশ্চিত? এটি স্থায়ী এবং পরিবর্তন করা যাবে না।';
	@override String get deleteMyAccount => 'আমার অ্যাকাউন্ট মুছে ফেলুন';
	@override String get deletingAccount => 'অ্যাকাউন্ট মুছে ফেলা হচ্ছে...';
	@override String get accountDeleted => 'আপনার অ্যাকাউন্ট স্থায়ীভাবে মুছে ফেলা হয়েছে।';
	@override String get deleteAccountFailed => 'অ্যাকাউন্ট মুছে ফেলতে ব্যর্থ। আবার চেষ্টা করুন।';
	@override String get downloadedStories => 'ডাউনলোড করা গল্প';
	@override String get couldNotOpenEmail => 'ইমেল অ্যাপ খোলা যায়নি। দয়া করে আমাদেরকে myitihas@gmail.com এ ইমেল করুন।';
	@override String couldNotOpenLabel({required Object label}) => '${label} এখন খোলা যাচ্ছে না।';
	@override String get logoutTitle => 'লগআউট';
	@override String get logoutConfirm => 'আপনি কি সত্যি লগআউট করতে চান?';
	@override String get verifyYourIdentity => 'আপনার পরিচয় যাচাই করুন';
	@override String get verifyYourIdentityDesc => 'আপনার পরিচয় যাচাই করতে আপনাকে Google দিয়ে সাইন ইন করতে বলা হবে।';
	@override String get continueWithGoogle => 'Google দিয়ে চালিয়ে যান';
	@override String reauthFailed({required Object error}) => 'পুনঃ-প্রমাণীকরণ ব্যর্থ: ${error}';
	@override String get passwordRequired => 'পাসওয়ার্ড প্রয়োজন';
	@override String get invalidPassword => 'ভুল পাসওয়ার্ড। আবার চেষ্টা করুন।';
	@override String get verify => 'যাচাই করুন';
	@override String get continueLabel => 'চালিয়ে যান';
	@override String get unableToVerifyIdentity => 'পরিচয় যাচাই করা যাচ্ছে না। আবার চেষ্টা করুন।';
}

// Path: auth
class _TranslationsAuthBn extends TranslationsAuthEn {
	_TranslationsAuthBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get login => 'লগইন';
	@override String get signup => 'সাইন আপ';
	@override String get email => 'ইমেল';
	@override String get password => 'পাসওয়ার্ড';
	@override String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';
	@override String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';
	@override String get resetPassword => 'পাসওয়ার্ড রিসেট করুন';
	@override String get dontHaveAccount => 'অ্যাকাউন্ট নেই?';
	@override String get alreadyHaveAccount => 'আগেই অ্যাকাউন্ট আছে?';
	@override String get loginSuccess => 'লগইন সফল হয়েছে';
	@override String get signupSuccess => 'সাইন আপ সফল হয়েছে';
	@override String get loginError => 'লগইন ব্যর্থ হয়েছে';
	@override String get signupError => 'সাইন আপ ব্যর্থ হয়েছে';
}

// Path: error
class _TranslationsErrorBn extends TranslationsErrorEn {
	_TranslationsErrorBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get network => 'ইন্টারনেট সংযোগ নেই';
	@override String get server => 'সার্ভার ত্রুটি হয়েছে';
	@override String get cache => 'সংরক্ষিত ডাটা লোড করা যায়নি';
	@override String get timeout => 'অনুরোধের সময়সীমা শেষ';
	@override String get notFound => 'রিসোর্স পাওয়া যায়নি';
	@override String get validation => 'যাচাই ব্যর্থ হয়েছে';
	@override String get unexpected => 'একটি অপ্রত্যাশিত ত্রুটি ঘটেছে';
	@override String get tryAgain => 'দয়া করে আবার চেষ্টা করুন';
	@override String couldNotOpenLink({required Object url}) => 'লিংক খোলা যায়নি: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionBn extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get free => 'ফ্রি';
	@override String get plus => 'প্লাস';
	@override String get pro => 'প্রো';
	@override String get upgradeToPro => 'প্রো-তে আপগ্রেড করুন';
	@override String get features => 'বৈশিষ্ট্য';
	@override String get subscribe => 'সাবস্ক্রাইব করুন';
	@override String get currentPlan => 'বর্তমান প্ল্যান';
	@override String get managePlan => 'প্ল্যান ম্যানেজ করুন';
}

// Path: notification
class _TranslationsNotificationBn extends TranslationsNotificationEn {
	_TranslationsNotificationBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'নোটিফিকেশন';
	@override String get peopleToConnect => 'যোগাযোগের মানুষ';
	@override String get peopleToConnectSubtitle => 'ফলো করার জন্য মানুষ আবিষ্কার করুন';
	@override String followAgainInMinutes({required Object minutes}) => '${minutes} মিনিট পরে আবার ফলো করতে পারবেন';
	@override String get noSuggestions => 'এখন কোনো সাজেশন নেই';
	@override String get markAllRead => 'সব পড়া হয়েছে বলে চিহ্নিত করুন';
	@override String get noNotifications => 'এখনও কোনো নোটিফিকেশন নেই';
	@override String get noNotificationsSubtitle => 'কেউ আপনার গল্পে প্রতিক্রিয়া দিলেই এখানে দেখতে পাবেন';
	@override String get errorPrefix => 'ত্রুটি:';
	@override String get retry => 'আবার চেষ্টা করুন';
	@override String likedYourStory({required Object actorName}) => '${actorName} আপনার গল্পটি পছন্দ করেছেন';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} আপনার গল্পে মন্তব্য করেছেন';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} আপনার মন্তব্যের জবাব দিয়েছেন';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} আপনাকে ফলো করা শুরু করেছেন';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} আপনাকে একটি বার্তা পাঠিয়েছেন';
	@override String sharedYourStory({required Object actorName}) => '${actorName} আপনার গল্প শেয়ার করেছেন';
	@override String repostedYourStory({required Object actorName}) => '${actorName} আপনার গল্প আবার পোস্ট করেছেন';
	@override String mentionedYou({required Object actorName}) => '${actorName} আপনাকে উল্লেখ করেছেন';
	@override String newPostFrom({required Object actorName}) => '${actorName}-এর নতুন পোস্ট';
	@override String get today => 'আজ';
	@override String get thisWeek => 'এই সপ্তাহ';
	@override String get earlier => 'এর আগের';
	@override String get delete => 'মুছে ফেলুন';
}

// Path: profile
class _TranslationsProfileBn extends TranslationsProfileEn {
	_TranslationsProfileBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get followers => 'ফলোয়ার';
	@override String get following => 'ফলো করছেন';
	@override String get unfollow => 'আনফলো করুন';
	@override String get follow => 'ফলো করুন';
	@override String get about => 'সম্পর্কে';
	@override String get stories => 'গল্প';
	@override String get unableToShareImage => 'ছবি শেয়ার করা যাচ্ছে না';
	@override String get imageSavedToPhotos => 'ছবি গ্যালারিতে সংরক্ষণ করা হয়েছে';
	@override String get view => 'দেখুন';
	@override String get saveToPhotos => 'ফটোতে সংরক্ষণ করুন';
	@override String get failedToLoadImage => 'ছবি লোড করতে ব্যর্থ';
}

// Path: feed
class _TranslationsFeedBn extends TranslationsFeedEn {
	_TranslationsFeedBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'গল্প লোড হচ্ছে...';
	@override String get loadingPosts => 'পোস্ট লোড হচ্ছে...';
	@override String get loadingVideos => 'ভিডিও লোড হচ্ছে...';
	@override String get loadingStories => 'গল্প লোড হচ্ছে...';
	@override String get errorTitle => 'উফ! কিছু একটা ভুল হয়েছে';
	@override String get tryAgain => 'আবার চেষ্টা করুন';
	@override String get noStoriesAvailable => 'কোনো গল্প পাওয়া যাচ্ছে না';
	@override String get noImagesAvailable => 'কোনো ইমেজ পোস্ট নেই';
	@override String get noTextPostsAvailable => 'কোনো টেক্সট পোস্ট নেই';
	@override String get noContentAvailable => 'কোনো কনটেন্ট নেই';
	@override String get refresh => 'রিফ্রেশ করুন';
	@override String get comments => 'কমেন্টসমূহ';
	@override String get commentsComingSoon => 'কমেন্ট শিগগিরই আসছে';
	@override String get addCommentHint => 'কমেন্ট যোগ করুন...';
	@override String get shareStory => 'গল্প শেয়ার করুন';
	@override String get sharePost => 'পোস্ট শেয়ার করুন';
	@override String get shareThought => 'চিন্তা শেয়ার করুন';
	@override String get shareAsImage => 'ছবি হিসেবে শেয়ার করুন';
	@override String get shareAsImageSubtitle => 'একটি সুন্দর প্রিভিউ কার্ড তৈরি করুন';
	@override String get shareLink => 'লিংক শেয়ার করুন';
	@override String get shareLinkSubtitle => 'গল্পের লিংক কপি বা শেয়ার করুন';
	@override String get shareImageLinkSubtitle => 'পোস্টের লিংক কপি বা শেয়ার করুন';
	@override String get shareTextLinkSubtitle => 'চিন্তার লিংক কপি বা শেয়ার করুন';
	@override String get shareAsText => 'টেক্সট হিসেবে শেয়ার করুন';
	@override String get shareAsTextSubtitle => 'গল্পের একটি অংশ শেয়ার করুন';
	@override String get shareQuote => 'উক্তি শেয়ার করুন';
	@override String get shareQuoteSubtitle => 'উক্তি হিসেবে শেয়ার করুন';
	@override String get shareWithImage => 'ছবিসহ শেয়ার করুন';
	@override String get shareWithImageSubtitle => 'ছবি ও ক্যাপশন একসাথে শেয়ার করুন';
	@override String get copyLink => 'লিংক কপি করুন';
	@override String get copyLinkSubtitle => 'লিংক ক্লিপবোর্ডে কপি করুন';
	@override String get copyText => 'টেক্সট কপি করুন';
	@override String get copyTextSubtitle => 'উক্তি ক্লিপবোর্ডে কপি করুন';
	@override String get linkCopied => 'লিংক ক্লিপবোর্ডে কপি হয়েছে';
	@override String get textCopied => 'টেক্সট ক্লিপবোর্ডে কপি হয়েছে';
	@override String get sendToUser => 'ব্যবহারকারীকে পাঠান';
	@override String get sendToUserSubtitle => 'বন্ধুর সাথে সরাসরি শেয়ার করুন';
	@override String get chooseFormat => 'ফরম্যাট নির্বাচন করুন';
	@override String get linkPreview => 'লিংক প্রিভিউ';
	@override String get linkPreviewSize => '১২০০ × ৬৩০';
	@override String get storyFormat => 'স্টোরি ফরম্যাট';
	@override String get storyFormatSize => '১০৮০ × ১৯২০ (Instagram/Stories)';
	@override String get generatingPreview => 'প্রিভিউ তৈরি করা হচ্ছে...';
	@override String get bookmarked => 'বুকমার্ক করা হয়েছে';
	@override String get removedFromBookmarks => 'বুকমার্ক থেকে সরানো হয়েছে';
	@override String unlike({required Object count}) => 'আনলাইক, ${count}টি লাইক';
	@override String like({required Object count}) => 'লাইক, ${count}টি লাইক';
	@override String commentCount({required Object count}) => '${count}টি কমেন্ট';
	@override String shareCount({required Object count}) => 'শেয়ার, ${count}টি শেয়ার';
	@override String get removeBookmark => 'বুকমার্ক সরিয়ে ফেলুন';
	@override String get addBookmark => 'বুকমার্ক করুন';
	@override String get quote => 'উক্তি';
	@override String get quoteCopied => 'উক্তি ক্লিপবোর্ডে কপি হয়েছে';
	@override String get copy => 'কপি করুন';
	@override String get tapToViewFullQuote => 'পুরো উক্তি দেখতে ট্যাপ করুন';
	@override String get quoteFromMyitihas => 'MyItihas থেকে উক্তি';
	@override late final _TranslationsFeedTabsBn tabs = _TranslationsFeedTabsBn._(_root);
	@override String get tapToShowCaption => 'ক্যাপশন দেখতে ট্যাপ করুন';
	@override String get noVideosAvailable => 'কোনো ভিডিও নেই';
	@override String get selectUser => 'কাকে পাঠাবেন';
	@override String get searchUsers => 'ব্যবহারকারী খুঁজুন...';
	@override String get noFollowingYet => 'আপনি এখনও কাউকে ফলো করছেন না';
	@override String get noUsersFound => 'কোনো ব্যবহারকারী পাওয়া যায়নি';
	@override String get tryDifferentSearch => 'অন্য সার্চ টার্ম দিয়ে চেষ্টা করুন';
	@override String sentTo({required Object username}) => '${username}-কে পাঠানো হয়েছে';
}

// Path: social
class _TranslationsSocialBn extends TranslationsSocialEn {
	_TranslationsSocialBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileBn editProfile = _TranslationsSocialEditProfileBn._(_root);
	@override late final _TranslationsSocialCreatePostBn createPost = _TranslationsSocialCreatePostBn._(_root);
	@override late final _TranslationsSocialCommentsBn comments = _TranslationsSocialCommentsBn._(_root);
	@override late final _TranslationsSocialEngagementBn engagement = _TranslationsSocialEngagementBn._(_root);
	@override String get editCaption => 'ক্যাপশন সম্পাদনা করুন';
	@override String get reportPost => 'পোস্ট রিপোর্ট করুন';
	@override String get reportReasonHint => 'এই পোস্টে কী সমস্যা আছে আমাদের জানান';
	@override String get deletePost => 'পোস্ট মুছে ফেলুন';
	@override String get deletePostConfirm => 'এই কাজটি আর ফেরত নেওয়া যাবে না।';
	@override String get postDeleted => 'পোস্ট মুছে ফেলা হয়েছে';
	@override String failedToDeletePost({required Object error}) => 'পোস্ট মুছে ফেলতে ব্যর্থ: ${error}';
	@override String failedToReportPost({required Object error}) => 'পোস্ট রিপোর্ট করতে ব্যর্থ: ${error}';
	@override String get reportSubmitted => 'রিপোর্ট জমা হয়েছে। ধন্যবাদ।';
	@override String get acceptRequestFirst => 'প্রথমে রিকোয়েস্ট পেজে তাদের রিকোয়েস্ট গ্রহণ করুন।';
	@override String get requestSentWait => 'রিকোয়েস্ট পাঠানো হয়েছে। তারা গ্রহণ করা পর্যন্ত অপেক্ষা করুন।';
	@override String get requestSentTheyWillSee => 'রিকোয়েস্ট পাঠানো হয়েছে। তারা "রিকোয়েস্ট"-এ দেখবে।';
	@override String failedToShare({required Object error}) => 'শেয়ার করতে ব্যর্থ: ${error}';
	@override String get updateCaptionHint => 'আপনার পোস্টের ক্যাপশন আপডেট করুন';
}

// Path: voice
class _TranslationsVoiceBn extends TranslationsVoiceEn {
	_TranslationsVoiceBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'মাইক্রোফোন পারমিশন প্রয়োজন';
	@override String get speechRecognitionNotAvailable => 'স্পিচ রিকগনিশন পাওয়া যাচ্ছে না';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsBn extends TranslationsFestivalsEn {
	_TranslationsFestivalsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'উৎসবের গল্প';
	@override String get tellStory => 'গল্প বলুন';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroBn extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'অন্বেষণ করতে ট্যাপ করুন';
	@override late final _TranslationsHomeScreenHeroStoryBn story = _TranslationsHomeScreenHeroStoryBn._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionBn companion = _TranslationsHomeScreenHeroCompanionBn._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageBn heritage = _TranslationsHomeScreenHeroHeritageBn._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityBn community = _TranslationsHomeScreenHeroCommunityBn._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesBn messages = _TranslationsHomeScreenHeroMessagesBn._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthBn extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get short => 'ছোট';
	@override String get medium => 'মাঝারি';
	@override String get long => 'লম্বা';
	@override String get epic => 'মহাকাব্যিক';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatBn extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'বর্ণনামূলক';
	@override String get dialogue => 'সংলাপ ভিত্তিক';
	@override String get poetic => 'কাব্যিক';
	@override String get scriptural => 'শাস্ত্রীয়';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsBn extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'কৃষ্ণ কীভাবে অর্জুনকে শিক্ষা দিচ্ছেন সেই গল্পটি বলুন...';
	@override String get warriorRedemption => 'প্রায়শ্চিত্ত খুঁজে ফেরা এক যোদ্ধার মহাকাব্যিক কাহিনী লিখুন...';
	@override String get sageWisdom => 'ঋষিদের জ্ঞানের উপর একটি গল্প তৈরি করুন...';
	@override String get devotedSeeker => 'একনিষ্ঠ অন্বেষকের যাত্রা বর্ণনা করুন...';
	@override String get divineIntervention => 'দিব্য হস্তক্ষেপের কিংবদন্তি শেয়ার করুন...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsBn extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'দয়া করে সব প্রয়োজনীয় অপশন পূরণ করুন';
	@override String get generationFailed => 'গল্প তৈরি ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsBn extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  নমস্কার!';
	@override String get dharma => '📖  ধর্ম কী?';
	@override String get stress => '🧘  মানসিক চাপ কীভাবে সামলাব';
	@override String get karma => '⚡  কর্ম সহজভাবে বোঝাও';
	@override String get story => '💬  আমাকে একটি গল্প বলো';
	@override String get wisdom => '🌟  আজকের জ্ঞান';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsBn extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

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
class _TranslationsMapDiscussionsBn extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'আলোচনা পোস্ট করুন';
	@override String get intentCardCta => 'একটি আলোচনা পোস্ট করুন';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapBn extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapBn extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapBn extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

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
class _TranslationsMapFoodMapBn extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

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
class _TranslationsFeedTabsBn extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get all => 'সব';
	@override String get stories => 'গল্প';
	@override String get posts => 'পোস্ট';
	@override String get videos => 'ভিডিও';
	@override String get images => 'ছবি';
	@override String get text => 'চিন্তা';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileBn extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'প্রোফাইল সম্পাদনা করুন';
	@override String get displayName => 'প্রদর্শিত নাম';
	@override String get displayNameHint => 'আপনার প্রদর্শিত নাম লিখুন';
	@override String get displayNameEmpty => 'প্রদর্শিত নাম ফাঁকা থাকতে পারে না';
	@override String get bio => 'বায়ো';
	@override String get bioHint => 'নিজের সম্পর্কে লিখুন...';
	@override String get changePhoto => 'প্রোফাইল ছবি পরিবর্তন করুন';
	@override String get saveChanges => 'পরিবর্তনগুলো সংরক্ষণ করুন';
	@override String get profileUpdated => 'প্রোফাইল সফলভাবে আপডেট হয়েছে';
	@override String get profileAndPhotoUpdated => 'প্রোফাইল ও ছবি সফলভাবে আপডেট হয়েছে';
	@override String failedPickImage({required Object error}) => 'ছবি বাছাই করতে ব্যর্থ: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'ছবি আপলোড করতে ব্যর্থ: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'প্রোফাইল আপডেট করতে ব্যর্থ: ${error}';
	@override String unexpectedError({required Object error}) => 'অপ্রত্যাশিত ত্রুটি ঘটেছে: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostBn extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get title => 'পোস্ট তৈরি করুন';
	@override String get post => 'পোস্ট করুন';
	@override String get text => 'টেক্সট';
	@override String get image => 'ছবি';
	@override String get video => 'ভিডিও';
	@override String get textHint => 'আপনার মনে কী আছে?';
	@override String get imageCaptionHint => 'আপনার ছবির জন্য একটি ক্যাপশন লিখুন...';
	@override String get videoCaptionHint => 'আপনার ভিডিও বর্ণনা করুন...';
	@override String get shareCaptionHint => 'আপনার চিন্তা যোগ করুন...';
	@override String get titleHint => 'একটি শিরোনাম যোগ করুন (ঐচ্ছিক)';
	@override String get selectVideo => 'ভিডিও নির্বাচন করুন';
	@override String get gallery => 'গ্যালারি';
	@override String get camera => 'ক্যামেরা';
	@override String get visibility => 'কে এটি দেখতে পারবে?';
	@override String get public => 'পাবলিক';
	@override String get followers => 'ফলোয়াররা';
	@override String get private => 'প্রাইভেট';
	@override String get postCreated => 'পোস্ট তৈরি হয়েছে!';
	@override String get failedPickImages => 'ছবি নির্বাচন করতে ব্যর্থ';
	@override String get failedPickVideo => 'ভিডিও নির্বাচন করতে ব্যর্থ';
	@override String get failedCapturePhoto => 'ছবি তুলতে ব্যর্থ';
	@override String get cannotCreateOffline => 'অফলাইনে থেকে পোস্ট তৈরি করা যাবে না';
	@override String get discardTitle => 'পোস্ট বাতিল করবেন?';
	@override String get discardMessage => 'সংরক্ষণ না করা পরিবর্তন আছে। আপনি কি সত্যিই এই পোস্ট বাতিল করতে চান?';
	@override String get keepEditing => 'সম্পাদনা চালিয়ে যান';
	@override String get discard => 'বাতিল করুন';
	@override String get cropPhoto => 'ছবি ক্রপ করুন';
	@override String get trimVideo => 'ভিডিও ট্রিম করুন';
	@override String get editPhoto => 'ছবি সম্পাদনা করুন';
	@override String get editVideo => 'ভিডিও সম্পাদনা করুন';
	@override String get maxDuration => 'সর্বোচ্চ ৩০ সেকেন্ড';
	@override String get aspectSquare => 'বর্গাকার';
	@override String get aspectPortrait => 'পোর্ট্রেট';
	@override String get aspectLandscape => 'ল্যান্ডস্কেপ';
	@override String get aspectFree => 'ফ্রি';
	@override String get failedCrop => 'ছবি ক্রপ করতে ব্যর্থ';
	@override String get failedTrim => 'ভিডিও ট্রিম করতে ব্যর্থ';
	@override String get trimmingVideo => 'ভিডিও ট্রিম করা হচ্ছে...';
	@override String trimVideoSubtitle({required Object max}) => 'সর্বোচ্চ ${max}সে · আপনার সেরা অংশ বেছে নিন';
	@override String get trimVideoInstructionsTitle => 'আপনার ক্লিপ ট্রিম করুন';
	@override String get trimVideoInstructionsBody => 'শুরু ও শেষ হ্যান্ডেল টেনে 30 সেকেন্ড পর্যন্ত অংশ বেছে নিন।';
	@override String get trimStart => 'শুরু';
	@override String get trimEnd => 'শেষ';
	@override String get trimSelectionEmpty => 'চালিয়ে যেতে একটি বৈধ রেঞ্জ বেছে নিন';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}সে নির্বাচিত (${start}–${end}) · সর্বোচ্চ ${max}সে';
	@override String get coverFrame => 'কভার ফ্রেম';
	@override String get coverFrameUnavailable => 'প্রিভিউ নেই';
	@override String coverFramePosition({required Object time}) => '${time} এ কভার';
	@override String get overlayLabel => 'ভিডিওতে টেক্সট (ঐচ্ছিক)';
	@override String get overlayHint => 'ছোট একটি হুক বা শিরোনাম যোগ করুন';
	@override String get imageSectionHint => 'গ্যালারি বা ক্যামেরা থেকে সর্বোচ্চ ১০টি ছবি যোগ করুন';
	@override String get videoSectionHint => 'একটি ভিডিও, সর্বোচ্চ ৩০ সেকেন্ড';
	@override String get removePhoto => 'ছবি সরিয়ে ফেলুন';
	@override String get removeVideo => 'ভিডিও সরিয়ে ফেলুন';
	@override String get photoEditHint => 'ক্রপ বা সরাতে ছবিতে ট্যাপ করুন';
	@override String get videoEditOptions => 'এডিট অপশন';
	@override String get addPhoto => 'ছবি যোগ করুন';
	@override String get done => 'সম্পন্ন';
	@override String get rotate => 'ঘুরিয়ে নিন';
	@override String get editPhotoSubtitle => 'ফিডে ভালো দেখানোর জন্য বর্গাকার করে কাটুন';
	@override String get videoEditorCaptionLabel => 'ক্যাপশন / লেখা (ঐচ্ছিক)';
	@override String get videoEditorCaptionHint => 'যেমন: আপনার রিলের শিরোনাম বা হুক';
	@override String get videoEditorAspectLabel => 'অনুপাত';
	@override String get videoEditorAspectOriginal => 'মূল';
	@override String get videoEditorAspectSquare => '১:১';
	@override String get videoEditorAspectPortrait => '৯:১৬';
	@override String get videoEditorAspectLandscape => '১৬:৯';
	@override String get videoEditorQuickTrim => 'দ্রুত ট্রিম';
	@override String get videoEditorSpeed => 'গতি';
}

// Path: social.comments
class _TranslationsSocialCommentsBn extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name}-কে রিপ্লাই দিচ্ছেন';
	@override String replyHint({required Object name}) => '${name}-কে রিপ্লাই লিখুন...';
	@override String failedToPost({required Object error}) => 'পোস্ট করতে ব্যর্থ: ${error}';
	@override String get cannotPostOffline => 'অফলাইনে থেকে কমেন্ট করা যাবে না';
	@override String get noComments => 'এখনও কোনো কমেন্ট নেই';
	@override String get beFirst => 'প্রথম কমেন্টটি আপনিই করুন!';
}

// Path: social.engagement
class _TranslationsSocialEngagementBn extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'অফলাইন মোড';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryBn extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'এআই গল্প তৈরি';
	@override String get headline => 'ডুবে যাওয়ার মতো\nগল্প\nতৈরি করুন';
	@override String get subHeadline => 'প্রাচীন জ্ঞানের শক্তিতে';
	@override String get line1 => '✦  একটি পবিত্র শাস্ত্র বেছে নিন...';
	@override String get line2 => '✦  একটি প্রাণবন্ত প্রেক্ষাপট নিন...';
	@override String get line3 => '✦  এআইকে মুগ্ধকর গল্প বুনতে দিন...';
	@override String get cta => 'গল্প তৈরি করুন';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionBn extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'আধ্যাত্মিক সঙ্গী';
	@override String get headline => 'আপনার দিব্য\nপথপ্রদর্শক,\nসবসময় কাছে';
	@override String get subHeadline => 'কৃষ্ণের জ্ঞান থেকে অনুপ্রাণিত';
	@override String get line1 => '✦  এক বন্ধু, যে সত্যিই শোনে...';
	@override String get line2 => '✦  জীবনের লড়াইয়ে প্রজ্ঞা...';
	@override String get line3 => '✦  উজ্জীবিত করে এমন কথা...';
	@override String get cta => 'চ্যাট শুরু করুন';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageBn extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ঐতিহ্যের মানচিত্র';
	@override String get headline => 'চিরন্তন\nঐতিহ্য\nআবিষ্কার করুন';
	@override String get subHeadline => '5000+ পবিত্র স্থান মানচিত্রে';
	@override String get line1 => '✦  পবিত্র স্থানগুলো ঘুরে দেখুন...';
	@override String get line2 => '✦  ইতিহাস ও লোককথা পড়ুন...';
	@override String get line3 => '✦  অর্থপূর্ণ যাত্রার পরিকল্পনা করুন...';
	@override String get cta => 'মানচিত্র দেখুন';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityBn extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'কমিউনিটি স্পেস';
	@override String get headline => 'সংস্কৃতি\nবিশ্বের সঙ্গে\nভাগ করুন';
	@override String get subHeadline => 'একটি প্রাণবন্ত বৈশ্বিক কমিউনিটি';
	@override String get line1 => '✦  পোস্ট ও গভীর আলোচনা...';
	@override String get line2 => '✦  ছোট সাংস্কৃতিক ভিডিও...';
	@override String get line3 => '✦  বিশ্বের নানা প্রান্তের গল্প...';
	@override String get cta => 'কমিউনিটিতে যোগ দিন';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesBn extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesBn._(TranslationsBn root) : this._root = root, super.internal(root);

	final TranslationsBn _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ব্যক্তিগত বার্তা';
	@override String get headline => 'অর্থবহ\nআলাপ\nএখানেই শুরু';
	@override String get subHeadline => 'ব্যক্তিগত ও ভাবনাসমৃদ্ধ পরিসর';
	@override String get line1 => '✦  সমমনা মানুষদের সাথে যুক্ত হোন...';
	@override String get line2 => '✦  ভাবনা ও গল্প নিয়ে কথা বলুন...';
	@override String get line3 => '✦  চিন্তাশীল কমিউনিটি গড়ুন...';
	@override String get cta => 'বার্তা খুলুন';
}
