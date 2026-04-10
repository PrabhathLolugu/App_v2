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
class TranslationsTa extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ta,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <ta>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsTa _root = this; // ignore: unused_field

	@override 
	TranslationsTa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppTa app = _TranslationsAppTa._(_root);
	@override late final _TranslationsCommonTa common = _TranslationsCommonTa._(_root);
	@override late final _TranslationsNavigationTa navigation = _TranslationsNavigationTa._(_root);
	@override late final _TranslationsHomeTa home = _TranslationsHomeTa._(_root);
	@override late final _TranslationsHomeScreenTa homeScreen = _TranslationsHomeScreenTa._(_root);
	@override late final _TranslationsStoriesTa stories = _TranslationsStoriesTa._(_root);
	@override late final _TranslationsStoryGeneratorTa storyGenerator = _TranslationsStoryGeneratorTa._(_root);
	@override late final _TranslationsChatTa chat = _TranslationsChatTa._(_root);
	@override late final _TranslationsMapTa map = _TranslationsMapTa._(_root);
	@override late final _TranslationsCommunityTa community = _TranslationsCommunityTa._(_root);
	@override late final _TranslationsDiscoverTa discover = _TranslationsDiscoverTa._(_root);
	@override late final _TranslationsPlanTa plan = _TranslationsPlanTa._(_root);
	@override late final _TranslationsSettingsTa settings = _TranslationsSettingsTa._(_root);
	@override late final _TranslationsAuthTa auth = _TranslationsAuthTa._(_root);
	@override late final _TranslationsErrorTa error = _TranslationsErrorTa._(_root);
	@override late final _TranslationsSubscriptionTa subscription = _TranslationsSubscriptionTa._(_root);
	@override late final _TranslationsNotificationTa notification = _TranslationsNotificationTa._(_root);
	@override late final _TranslationsProfileTa profile = _TranslationsProfileTa._(_root);
	@override late final _TranslationsFeedTa feed = _TranslationsFeedTa._(_root);
	@override late final _TranslationsSocialTa social = _TranslationsSocialTa._(_root);
	@override late final _TranslationsVoiceTa voice = _TranslationsVoiceTa._(_root);
	@override late final _TranslationsFestivalsTa festivals = _TranslationsFestivalsTa._(_root);
}

// Path: app
class _TranslationsAppTa extends TranslationsAppEn {
	_TranslationsAppTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'இந்திய சாஸ்திரங்களை அறிந்து கொள்ளுங்கள்';
}

// Path: common
class _TranslationsCommonTa extends TranslationsCommonEn {
	_TranslationsCommonTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get ok => 'சரி';
	@override String get cancel => 'ரத்துசெய்';
	@override String get confirm => 'உறுதி செய்';
	@override String get delete => 'அழி';
	@override String get edit => 'திருத்து';
	@override String get save => 'சேமி';
	@override String get share => 'பகிர்';
	@override String get search => 'தேடு';
	@override String get loading => 'ஏற்றுகிறது...';
	@override String get error => 'பிழை';
	@override String get retry => 'மீண்டும் முயற்சி செய்';
	@override String get back => 'பின்';
	@override String get next => 'அடுத்து';
	@override String get finish => 'முடி';
	@override String get skip => 'தவிர்';
	@override String get yes => 'ஆம்';
	@override String get no => 'இல்லை';
	@override String get readFullStory => 'முழு கதையையும் படிக்க';
	@override String get dismiss => 'மூடு';
	@override String get offlineBannerMessage => 'நீங்கள் ஆஃப்லைனில் இருக்கிறீர்கள் – சேமிக்கப்பட்ட உள்ளடக்கத்தைப் பார்க்கிறீர்கள்';
	@override String get backOnline => 'மீண்டும் ஆன்லைனில்';
}

// Path: navigation
class _TranslationsNavigationTa extends TranslationsNavigationEn {
	_TranslationsNavigationTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get home => 'ஆராய்';
	@override String get stories => 'கதைகள்';
	@override String get chat => 'அரட்டை';
	@override String get map => 'வரைபடம்';
	@override String get community => 'சோஷல்';
	@override String get settings => 'அமைப்புகள்';
	@override String get profile => 'சுயவிவரம்';
}

// Path: home
class _TranslationsHomeTa extends TranslationsHomeEn {
	_TranslationsHomeTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'கதை உருவாக்கி';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'சமூகக் கதைகள்';
	@override String get maps => 'வரைபடங்கள்';
	@override String get greetingMorning => 'காலை வணக்கம்';
	@override String get continueReading => 'தொடர்ந்து படிக்க';
	@override String get greetingAfternoon => 'மதிய வணக்கம்';
	@override String get greetingEvening => 'மாலை வணக்கம்';
	@override String get greetingNight => 'இரவு வணக்கம்';
	@override String get exploreStories => 'கதைகளை ஆராயுங்கள்';
	@override String get generateStory => 'கதை உருவாக்கு';
	@override String get content => 'முகப்பு உள்ளடக்கம்';
}

// Path: homeScreen
class _TranslationsHomeScreenTa extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'வணக்கம்';
	@override String get quoteOfTheDay => 'இன்றைய மேற்கோள்';
	@override String get shareQuote => 'மேற்கோளை பகிர்';
	@override String get copyQuote => 'மேற்கோளை நகலெடு';
	@override String get quoteCopied => 'மேற்கோள் கிளிப்போர்டுக்கு நகலெடுக்கப்பட்டது';
	@override String get featuredStories => 'சிறப்பு கதைகள்';
	@override String get quickActions => 'விரைவு செயல்கள்';
	@override String get generateStory => 'கதை உருவாக்கு';
	@override String get chatWithKrishna => 'கிருஷ்ணருடன் அரட்டை';
	@override String get myActivity => 'என் செயல்பாடுகள்';
	@override String get continueReading => 'தொடர்ந்து படிக்க';
	@override String get savedStories => 'சேமிக்கப்பட்ட கதைகள்';
	@override String get exploreMyitihas => 'மைஇதிஹாஸ் ஆராய்ச்சி';
	@override String get storiesInYourLanguage => 'உங்கள் மொழியில் கதைகள்';
	@override String get seeAll => 'அனைத்தையும் காண்க';
	@override String get startReading => 'படிக்கத் தொடங்குங்கள்';
	@override String get exploreStories => 'உங்கள் பயணத்தைத் தொடங்க கதைகளை ஆராயுங்கள்';
	@override String get saveForLater => 'நீங்கள் விரும்பும் கதைகளை பூக்க்மார்க் செய்யுங்கள்';
	@override String get noActivityYet => 'இன்னும் செயல்பாடு இல்லை';
	@override String minLeft({required Object count}) => '${count} நிமிடங்கள் மீதம்';
	@override String get activityHistory => 'செயல்பாட்டு வரலாறு';
	@override String get storyGenerated => 'ஒரு கதை உருவாக்கப்பட்டது';
	@override String get storyRead => 'ஒரு கதை படிக்கப்பட்டது';
	@override String get storyBookmarked => 'கதை பூக்க்மார்க் செய்யப்பட்டது';
	@override String get storyShared => 'கதை பகிரப்பட்டது';
	@override String get storyCompleted => 'கதை முடிக்கப்பட்டது';
	@override String get today => 'இன்று';
	@override String get yesterday => 'நேற்று';
	@override String get thisWeek => 'இந்த வாரம்';
	@override String get earlier => 'முன்பிருந்தவை';
	@override String get noContinueReading => 'இன்னும் படிக்க எதுவும் இல்லை';
	@override String get noSavedStories => 'இன்னும் சேமிக்கப்பட்ட கதைகள் இல்லை';
	@override String get bookmarkStoriesToSave => 'கதைகளை சேமிக்க பூக்க்மார்க் செய்யுங்கள்';
	@override String get myGeneratedStories => 'என் கதைகள்';
	@override String get noGeneratedStoriesYet => 'இன்னும் எந்தக் கதையும் உருவாக்கப்படவில்லை';
	@override String get createYourFirstStory => 'AI மூலம் உங்கள் முதல் கதையை உருவாக்குங்கள்';
	@override String get shareToFeed => 'ஃபீடில் பகிர்';
	@override String get sharedToFeed => 'கதை ஃபீடில் பகிரப்பட்டது';
	@override String get shareStoryTitle => 'கதையை பகிர்';
	@override String get shareStoryMessage => 'உங்கள் கதை குறித்து ஒரு தலைப்பு/குறிப்பு (விருப்பம்)';
	@override String get shareStoryCaption => 'குறிப்பு';
	@override String get shareStoryHint => 'இந்தக் கதையைப் பற்றி நீங்கள் என்னச் சொல்ல விரும்புகிறீர்கள்?';
	@override String get exploreHeritageTitle => 'பாரம்பரியத்தை ஆராயுங்கள்';
	@override String get exploreHeritageDesc => 'வரைபடத்தில் கலாச்சார பாரம்பரிய தலங்களை கண்டறியுங்கள்';
	@override String get whereToVisit => 'அடுத்த பயணம்';
	@override String get scriptures => 'சாஸ்திரங்கள்';
	@override String get exploreSacredSites => 'புனித தலங்களை ஆராயுங்கள்';
	@override String get readStories => 'கதைகளை படிக்க';
	@override String get yesRemindMe => 'ஆம், எனக்கு நினைவூட்டு';
	@override String get noDontShowAgain => 'இல்லை, மீண்டும் காட்ட வேண்டாம்';
	@override String get discoverDismissTitle => 'Discover MyItihas-ஐ மறைக்கவா?';
	@override String get discoverDismissMessage => 'அடுத்த முறை பயன்பாட்டை திறக்கும்போது அல்லது உள்நுழையும்போது இதை மீண்டும் பார்க்க விரும்புகிறீர்களா?';
	@override String get discoverCardTitle => 'MyItihas-ஐ அறியுங்கள்';
	@override String get discoverCardSubtitle => 'பழமையான சாஸ்திரக் கதைகள், ஆராய வேண்டிய புனித தலங்கள், உங்கள் விரல்களின் நுனியில் ஞானம்.';
	@override String get swipeToDismiss => 'மூடுவதற்கு மேலே ஸ்வைப் செய்யுங்கள்';
	@override String get searchScriptures => 'சாஸ்திரங்களைத் தேடுங்கள்...';
	@override String get searchLanguages => 'மொழிகளைத் தேடுங்கள்...';
	@override String get exploreStoriesLabel => 'கதைகளை ஆராயுங்கள்';
	@override String get exploreMore => 'மேலும் ஆராயுங்கள்';
	@override String get failedToLoadActivity => 'செயல்பாட்டை ஏற்றுவதில் தோல்வி';
	@override String get startReadingOrGenerating => 'உங்கள் செயல்பாட்டை இங்கு காண கதைகளைப் படிக்க அல்லது உருவாக்கத் தொடங்குங்கள்';
	@override late final _TranslationsHomeScreenHeroTa hero = _TranslationsHomeScreenHeroTa._(_root);
}

// Path: stories
class _TranslationsStoriesTa extends TranslationsStoriesEn {
	_TranslationsStoriesTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'கதைகள்';
	@override String get searchHint => 'தலைப்பு அல்லது ஆசிரியர் மூலம் தேடு...';
	@override String get sortBy => 'வரிசைப்படுத்து';
	@override String get sortNewest => 'புதியவை முதலில்';
	@override String get sortOldest => 'பழையவை முதலில்';
	@override String get sortPopular => 'அதிகப் பிரபலமானவை';
	@override String get noStories => 'கதைகள் எதுவும் கிடைக்கவில்லை';
	@override String get loadingStories => 'கதைகள் ஏற்றப்படுகின்றன...';
	@override String get errorLoadingStories => 'கதைகளை ஏற்றுவதில் தோல்வி';
	@override String get storyDetails => 'கதை விவரங்கள்';
	@override String get continueReading => 'தொடர்ந்து படிக்க';
	@override String get readMore => 'மேலும் படிக்க';
	@override String get readLess => 'குறைவாகக் காண்க';
	@override String get author => 'ஆசிரியர்';
	@override String get publishedOn => 'வெளியிடப்பட்ட தேதி';
	@override String get category => 'வகை';
	@override String get tags => 'குறிச்சொற்கள்';
	@override String get failedToLoad => 'கதையை ஏற்ற முடியவில்லை';
	@override String get subtitle => 'சாஸ்திரங்களிலிருந்து கதைகளை கண்டறியுங்கள்';
	@override String get noStoriesHint => 'கதைகளை காண வேறு தேடல் அல்லது வடிகட்டலை முயற்சிக்கவும்.';
	@override String get featured => 'சிறப்பு';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorTa extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'கதை உருவாக்கி';
	@override String get subtitle => 'உங்கள் சொந்த சாஸ்திரக் கதையை உருவாக்குங்கள்';
	@override String get quickStart => 'விரைவு தொடக்கம்';
	@override String get interactive => 'இணையெழுத்து';
	@override String get rawPrompt => 'அசல் ப்ராம்ப்ட்';
	@override String get yourStoryPrompt => 'உங்கள் கதை ப்ராம்ப்ட்';
	@override String get writeYourPrompt => 'உங்கள் ப்ராம்ப்டை எழுதுங்கள்';
	@override String get selectScripture => 'சாஸ்திரத்தைத் தேர்ந்தெடுக்கவும்';
	@override String get selectStoryType => 'கதை வகையைத் தேர்ந்தெடுக்கவும்';
	@override String get selectCharacter => 'பாத்திரத்தைத் தேர்ந்தெடுக்கவும்';
	@override String get selectTheme => 'கருத்தைத் தேர்ந்தெடுக்கவும்';
	@override String get selectSetting => 'இடத்தைத் தேர்ந்தெடுக்கவும்';
	@override String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';
	@override String get selectLength => 'கதையின் நீளம்';
	@override String get moreOptions => 'மேலும் விருப்பங்கள்';
	@override String get random => 'சீரற்ற';
	@override String get generate => 'கதை உருவாக்கு';
	@override String get generating => 'உங்கள் கதை உருவாக்கப்படுகின்றது...';
	@override String get creatingYourStory => 'உங்கள் கதை உருவாக்கப்படுகிறது';
	@override String get consultingScriptures => 'பழமையான சாஸ்திரங்களைப் பார்க்கிறது...';
	@override String get weavingTale => 'உங்கள் கதையை நெய்கிறது...';
	@override String get addingWisdom => 'தெய்வீக ஞானத்தைச் சேர்க்கிறது...';
	@override String get polishingNarrative => 'கதையை மேம்படுத்துகிறது...';
	@override String get almostThere => 'கிட்டத்தட்ட முடிந்துவிட்டது...';
	@override String get generatedStory => 'உங்கள் உருவாக்கப்பட்ட கதை';
	@override String get aiGenerated => 'AI உருவாக்கியது';
	@override String get regenerate => 'மீண்டும் உருவாக்கு';
	@override String get saveStory => 'கதையை சேமி';
	@override String get shareStory => 'கதையை பகிர்';
	@override String get newStory => 'புதிய கதை';
	@override String get saved => 'சேமிக்கப்பட்டது';
	@override String get storySaved => 'கதை உங்கள் தொகுப்பில் சேமிக்கப்பட்டது';
	@override String get story => 'கதை';
	@override String get lesson => 'பாடம்';
	@override String get didYouKnow => 'உங்களுக்குத் தெரியுமா?';
	@override String get activity => 'செயல்பாடு';
	@override String get optionalRefine => 'விருப்பம்: விருப்பங்களால் நயமாக்கவும்';
	@override String get applyOptions => 'விருப்பங்களைப் பயன்படுத்துங்கள்';
	@override String get language => 'மொழி';
	@override String get storyFormat => 'கதை வடிவம்';
	@override String get requiresInternet => 'கதை உருவாக்க இணைய இணைப்பு அவசியம்';
	@override String get notAvailableOffline => 'கதை ஆஃப்லைனில் கிடைக்காது. காண இணையத்தை இணைக்கவும்.';
	@override String get aiDisclaimer => 'AI தவறுகள் செய்யக்கூடும். நாங்கள் தொடர்ந்து மேம்படுத்திக் கொண்டு இருக்கிறோம்; உங்கள் கருத்துக்கள் எங்களுக்கு முக்கியமானவை.';
	@override late final _TranslationsStoryGeneratorStoryLengthTa storyLength = _TranslationsStoryGeneratorStoryLengthTa._(_root);
	@override late final _TranslationsStoryGeneratorFormatTa format = _TranslationsStoryGeneratorFormatTa._(_root);
	@override late final _TranslationsStoryGeneratorHintsTa hints = _TranslationsStoryGeneratorHintsTa._(_root);
	@override late final _TranslationsStoryGeneratorErrorsTa errors = _TranslationsStoryGeneratorErrorsTa._(_root);
}

// Path: chat
class _TranslationsChatTa extends TranslationsChatEn {
	_TranslationsChatTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'சாஸ்திரங்களைப் பற்றி AI உடன் பேசுங்கள்';
	@override String get friendMode => 'நண்பர் நிலை';
	@override String get philosophicalMode => 'தத்துவ நிலை';
	@override String get typeMessage => 'உங்கள் செய்தியை எழுதுங்கள்...';
	@override String get send => 'அனுப்பு';
	@override String get newChat => 'புதிய அரட்டை';
	@override String get chatsTab => 'அரட்டைகள்';
	@override String get groupsTab => 'குழுக்கள்';
	@override String get chatHistory => 'அரட்டை வரலாறு';
	@override String get clearChat => 'அரட்டையை அழி';
	@override String get noMessages => 'இன்னும் எந்தச் செய்திகளும் இல்லை. ஒரு உரையாடலைத் தொடங்குங்கள்!';
	@override String get listPage => 'அரட்டை பட்டியல் பக்கம்';
	@override String get forwardMessageTo => 'செய்தியை இங்கே அனுப்பு...';
	@override String get forwardMessage => 'செய்தியை அனுப்பு';
	@override String get messageForwarded => 'செய்தி அனுப்பப்பட்டது';
	@override String failedToForward({required Object error}) => 'செய்தியை அனுப்பத் தவறிவிட்டது: ${error}';
	@override String get searchChats => 'அரட்டைகளைத் தேடு';
	@override String get noChatsFound => 'அரட்டைகள் எதுவும் கிடைக்கவில்லை';
	@override String get requests => 'கோரிக்கைகள்';
	@override String get messageRequests => 'செய்தி கோரிக்கைகள்';
	@override String get groupRequests => 'குழு கோரிக்கைகள்';
	@override String get requestSent => 'கோரிக்கை அனுப்பப்பட்டது. அவர்கள் "Requests" இல் காண்பார்கள்.';
	@override String get wantsToChat => 'அரட்டை செய்ய விரும்புகிறார்';
	@override String addedYouTo({required Object name}) => '${name} உங்களைச் சேர்த்துள்ளார்';
	@override String get accept => 'ஏற்றுக்கொள்';
	@override String get noMessageRequests => 'செய்தி கோரிக்கைகள் இல்லை';
	@override String get noGroupRequests => 'குழு கோரிக்கைகள் இல்லை';
	@override String get invitesSent => 'அழைப்புகள் அனுப்பப்பட்டன. அவர்கள் "Requests" இல் காண்பார்கள்.';
	@override String get cantMessageUser => 'இந்த பயனருக்கு நீங்கள் செய்தி அனுப்ப முடியாது';
	@override String get deleteChat => 'அரட்டையை அழி';
	@override String get deleteChats => 'அரட்டைகளை அழி';
	@override String get blockUser => 'பயனரை தடு';
	@override String get reportUser => 'பயனரை புகார் செய்';
	@override String get markAsRead => 'வாசிக்கப்பட்டது என்று குறி';
	@override String get markedAsRead => 'வாசிக்கப்பட்டது என்று குறிப்பிட்டது';
	@override String get deleteClearChat => 'அரட்டையை அழி / அழுத்தமாக அழி';
	@override String get deleteConversation => 'உரையாடலை அழி';
	@override String get reasonRequired => 'காரணம் (தேவை)';
	@override String get submit => 'சமர்ப்பி';
	@override String get userReportedBlocked => 'பயனர் புகார் செய்யப் பட்டார். அவரைத் தடுத்துவிட்டோம்.';
	@override String reportFailed({required Object error}) => 'புகார் செய்யத் தோல்வி: ${error}';
	@override String get newGroup => 'புதிய குழு';
	@override String get messageSomeoneDirectly => 'யாரொருவருக்கு நேரடியாக செய்தி அனுப்பு';
	@override String get createGroupConversation => 'குழு உரையாடல் உருவாக்கு';
	@override String get noGroupsYet => 'இன்னும் குழுக்கள் இல்லை';
	@override String get noChatsYet => 'இன்னும் அரட்டைகள் இல்லை';
	@override String get tapToCreateGroup => 'குழுவை உருவாக்க அல்லது சேர + ஐத் தொட்டு';
	@override String get tapToStartConversation => 'புதிய உரையாடலைத் தொடங்க + ஐத் தொட்டு';
	@override String get conversationDeleted => 'உரையாடல் அழிக்கப்பட்டது';
	@override String conversationsDeleted({required Object count}) => '${count} உரையாடல்கள் அழிக்கப்பட்டன';
	@override String get searchConversations => 'உரையாடல்களைத் தேடு...';
	@override String get connectToInternet => 'தயவுசெய்து இணையத்தை இணைத்து மீண்டும் முயற்சி செய்யுங்கள்.';
	@override String get littleKrishnaName => 'சிறு கிருஷ்ணர்';
	@override String get newConversation => 'புதிய உரையாடல்';
	@override String get noConversationsYet => 'இன்னும் உரையாடல் இல்லை';
	@override String get confirmDeletion => 'அழிப்பதை உறுதிசெய்';
	@override String deleteConversationConfirm({required Object title}) => '${title} உரையாடலை அழிக்க விரும்புகிறீர்களா?';
	@override String get deleteFailed => 'உரையாடலை அழிக்கத் தோல்வி';
	@override String get fullChatCopied => 'முழு அரட்டையும் கிளிப்போர்டுக்கு நகலெடுக்கப்பட்டது!';
	@override String get connectionErrorFallback => 'இப்போது இணைக்க சிரமம் உள்ளது. தயவுசெய்து சிறிது நேரம் கழித்து மீண்டும் முயற்சி செய்யுங்கள்.';
	@override String krishnaWelcomeWithName({required Object name}) => 'வணக்கம், ${name}. நான் கிருஷ்ணர், உங்கள் நண்பன். இன்று எப்படி இருக்கிறீர்கள்?';
	@override String get krishnaWelcomeFriend => 'வணக்கம், என் அன்புத் தோழா. நான் கிருஷ்ணர், உங்கள் நண்பன். இன்று எப்படி இருக்கிறீர்கள்?';
	@override String get copyYouLabel => 'நீங்கள்';
	@override String get copyKrishnaLabel => 'கிருஷ்ணர்';
	@override late final _TranslationsChatSuggestionsTa suggestions = _TranslationsChatSuggestionsTa._(_root);
	@override String get about => 'பற்றி';
	@override String get yourFriendlyCompanion => 'உங்கள் நட்பான துணைவர்';
	@override String get mentalHealthSupport => 'மனநலம் ஆதரவு';
	@override String get mentalHealthSupportSubtitle => 'சிந்தனையை பகிர்ந்து கேட்கப்பட்டதாக உணர ஒரு பாதுகாப்பான இடம்.';
	@override String get friendlyCompanion => 'நட்பான தோழன்';
	@override String get friendlyCompanionSubtitle => 'எப்போதும் பேச, ஊக்குவிக்க, ஞானம் பகிர இருக்கிறார்.';
	@override String get storiesAndWisdom => 'கதைகள் & ஞானம்';
	@override String get storiesAndWisdomSubtitle => 'நித்தியமான கதைகள் மற்றும் பயனுள்ள கருத்துக்களில் இருந்து கற்றுக்கொள்ளுங்கள்.';
	@override String get askAnything => 'எதையும் கேளுங்கள்';
	@override String get askAnythingSubtitle => 'உங்கள் கேள்விகளுக்கு நெகிழ்ச்சியான, ஆழ்ந்த பதில்களைப் பெறுங்கள்.';
	@override String get startChatting => 'அரட்டையை தொடங்கு';
	@override String get maybeLater => 'பிறகு பார்க்கலாம்';
	@override late final _TranslationsChatComposerAttachmentsTa composerAttachments = _TranslationsChatComposerAttachmentsTa._(_root);
}

// Path: map
class _TranslationsMapTa extends TranslationsMapEn {
	_TranslationsMapTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'அகண்ட பாரதம்';
	@override String get subtitle => 'வரலாற்று இடங்களை ஆராயுங்கள்';
	@override String get searchLocation => 'இடத்தைத் தேடுங்கள்...';
	@override String get viewDetails => 'விவரங்களைப் பார்க்க';
	@override String get viewSites => 'இடங்களைப் பார்க்க';
	@override String get showRoute => 'வழியை காட்டுங்கள்';
	@override String get historicalInfo => 'வரலாற்று தகவல்';
	@override String get nearbyPlaces => 'அருகிலுள்ள இடங்கள்';
	@override String get pickLocationOnMap => 'வரைபடத்தில் இடத்தைத் தேர்ந்தெடுக்கவும்';
	@override String get sitesVisited => 'சென்று வந்த தலங்கள்';
	@override String get badgesEarned => 'பெற்ற பதக்கங்கள்';
	@override String get completionRate => 'நிறைவு விகிதம்';
	@override String get addToJourney => 'பயணத்தில் சேர்க்கவும்';
	@override String get addedToJourney => 'பயணத்தில் சேர்க்கப்பட்டது';
	@override String get getDirections => 'வழிமுறைகளைப் பெறுங்கள்';
	@override String get viewInMap => 'வரைபடத்தில் காண்க';
	@override String get directions => 'வழிமுறைகள்';
	@override String get photoGallery => 'புகைப்படத் தொகுப்பு';
	@override String get viewAll => 'அனைத்தையும் பார்க்க';
	@override String get photoSavedToGallery => 'புகைப்படம் தொகுப்பில் சேமிக்கப்பட்டது';
	@override String get sacredSoundscape => 'புனித ஒலிப்பரப்பு';
	@override String get allDiscussions => 'அனைத்து விவாதங்களும்';
	@override String get journeyTab => 'பயணம்';
	@override String get discussionTab => 'விவாதம்';
	@override String get myActivity => 'என் செயல்பாடு';
	@override String get anonymousPilgrim => 'பெயரில்லா யாத்திரிகன்';
	@override String get viewProfile => 'சுயவிவரத்தைப் பார்க்க';
	@override String get discussionTitleHint => 'விவாத தலைப்பு...';
	@override String get shareYourThoughtsHint => 'உங்கள் எண்ணங்களைப் பகிரவும்...';
	@override String get pleaseEnterDiscussionTitle => 'தயவுசெய்து விவாத தலைப்பை உள்ளிடவும்';
	@override String get addReflection => 'அனுபவத்தைச் சேர்';
	@override String get reflectionTitle => 'தலைப்பு';
	@override String get enterReflectionTitle => 'அனுபவத் தலைப்பை உள்ளிடுங்கள்';
	@override String get pleaseEnterTitle => 'தயவுசெய்து தலைப்பை உள்ளிடவும்';
	@override String get siteName => 'இடத்தின் பெயர்';
	@override String get enterSacredSiteName => 'புனித தலத்தின் பெயரை உள்ளிடவும்';
	@override String get pleaseEnterSiteName => 'தயவுசெய்து இடத்தின் பெயரை உள்ளிடவும்';
	@override String get reflection => 'அனுபவம்';
	@override String get reflectionHint => 'உங்கள் அனுபவங்கள் மற்றும் எண்ணங்களைப் பகிருங்கள்...';
	@override String get pleaseEnterReflection => 'தயவுசெய்து உங்கள் அனுபவத்தை உள்ளிடவும்';
	@override String get saveReflection => 'அனுபவத்தை சேமிக்கவும்';
	@override String get journeyProgress => 'பயண முன்னேற்றம்';
	@override late final _TranslationsMapDiscussionsTa discussions = _TranslationsMapDiscussionsTa._(_root);
	@override late final _TranslationsMapFabricMapTa fabricMap = _TranslationsMapFabricMapTa._(_root);
	@override late final _TranslationsMapClassicalArtMapTa classicalArtMap = _TranslationsMapClassicalArtMapTa._(_root);
	@override late final _TranslationsMapClassicalDanceMapTa classicalDanceMap = _TranslationsMapClassicalDanceMapTa._(_root);
	@override late final _TranslationsMapFoodMapTa foodMap = _TranslationsMapFoodMapTa._(_root);
}

// Path: community
class _TranslationsCommunityTa extends TranslationsCommunityEn {
	_TranslationsCommunityTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'சமூகம்';
	@override String get trending => 'பிரபலமானவை';
	@override String get following => 'பின்தொடர்கிறேன்';
	@override String get followers => 'பின்தொடர்பவர்கள்';
	@override String get posts => 'பதிவுகள்';
	@override String get follow => 'பின்தொடர்';
	@override String get unfollow => 'பின்தொடர்வதை நிறுத்து';
	@override String get shareYourStory => 'உங்கள் கதையைப் பகிருங்கள்...';
	@override String get post => 'பதிவு';
	@override String get like => 'விருப்பு';
	@override String get comment => 'கருத்து';
	@override String get comments => 'கருத்துகள்';
	@override String get noPostsYet => 'இன்னும் பதிவுகள் இல்லை';
}

// Path: discover
class _TranslationsDiscoverTa extends TranslationsDiscoverEn {
	_TranslationsDiscoverTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'கண்டறி';
	@override String get searchHint => 'கதைகள், பயனர்கள் அல்லது தலைப்புகளைத் தேடுங்கள்...';
	@override String get tryAgain => 'மீண்டும் முயற்சி செய்';
	@override String get somethingWentWrong => 'ஏதோ தவறு ஏற்பட்டுள்ளது';
	@override String get unableToLoadProfiles => 'சுயவிவரங்களை ஏற்ற முடியவில்லை. தயவுசெய்து மீண்டும் முயற்சி செய்யுங்கள்.';
	@override String get noProfilesFound => 'சுயவிவரங்கள் எதுவும் கிடைக்கவில்லை';
	@override String get searchToFindPeople => 'பின்தொடர வேண்டியவர்களைத் தேடுங்கள்';
	@override String get noResultsFound => 'முடிவுகள் எதுவும் கிடைக்கவில்லை';
	@override String get noProfilesYet => 'இன்னும் சுயவிவரங்கள் இல்லை';
	@override String get tryDifferentKeywords => 'வேறு முக்கிய சொற்களைப் பயன்படுத்தி தேடுங்கள்';
	@override String get beFirstToDiscover => 'புதியவர்களை முதலில் கண்டுபிடிப்பவர் நீங்கள் ஆகுங்கள்!';
}

// Path: plan
class _TranslationsPlanTa extends TranslationsPlanEn {
	_TranslationsPlanTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'உங்கள் திட்டத்தைச் சேமிக்க உள்நுழைக';
	@override String get planSaved => 'திட்டம் சேமிக்கப்பட்டது';
	@override String get from => 'இருந்து';
	@override String get dates => 'தேதிகள்';
	@override String get destination => 'இலக்கு இடம்';
	@override String get nearby => 'அருகிலுள்ளவை';
	@override String get generatedPlan => 'உருவாக்கப்பட்ட திட்டம்';
	@override String get whereTravellingFrom => 'நீங்கள் எங்கு இருந்து பயணம் செய்கிறீர்கள்?';
	@override String get enterCityOrRegion => 'உங்கள் நகரம் அல்லது பகுதியை உள்ளிடவும்';
	@override String get travelDates => 'பயண தேதிகள்';
	@override String get destinationSacredSite => 'இலக்கு (புனித தளம்)';
	@override String get searchOrSelectDestination => 'இலக்கைத் தேடவோ அல்லது தேர்ந்தெடுக்கவோ செய்யுங்கள்...';
	@override String get shareYourExperience => 'உங்கள் அனுபவத்தைப் பகிருங்கள்';
	@override String get planShared => 'திட்டம் பகிரப்பட்டது';
	@override String failedToSharePlan({required Object error}) => 'திட்டத்தைப் பகிரத் தோல்வி: ${error}';
	@override String get planUpdated => 'திட்டம் புதுப்பிக்கப்பட்டது';
	@override String failedToUpdatePlan({required Object error}) => 'திட்டத்தைப் புதுப்பிக்கத் தோல்வி: ${error}';
	@override String get deletePlanConfirm => 'திட்டத்தை அழிக்கவா?';
	@override String get thisPlanPermanentlyDeleted => 'இந்த திட்டம் நிரந்தரமாக அழிக்கப்படும்.';
	@override String get planDeleted => 'திட்டம் அழிக்கப்பட்டது';
	@override String failedToDeletePlan({required Object error}) => 'திட்டத்தை அழிக்கத் தோல்வி: ${error}';
	@override String get sharePlan => 'திட்டத்தைப் பகிருங்கள்';
	@override String get deletePlan => 'திட்டத்தை அழிக்கவும்';
	@override String get savedPlanDetails => 'சேமிக்கப்பட்ட திட்ட விவரங்கள்';
	@override String get quickBookings => 'விரைவு முன்பதிவுகள்';
	@override String get replanWithAi => 'AI மூலம் மீண்டும் திட்டமிடவும்';
	@override String get fullRegenerate => 'முழுவதும் புதிதாக உருவாக்கு';
	@override String get surgicalModify => 'தேர்ந்தெடுத்த பகுதிகளை மாற்று';
	@override String get travelModeTrain => 'ரயில்';
	@override String get travelModeFlight => 'விமானம்';
	@override String get travelModeBus => 'பஸ்';
	@override String get travelModeHotel => 'ஹோட்டல்';
	@override String get travelModeCar => 'கார்';
	@override String get pilgrimagePlan => 'யாத்திரைத் திட்டம்';
	@override String get planTab => 'திட்டம்';
}

// Path: settings
class _TranslationsSettingsTa extends TranslationsSettingsEn {
	_TranslationsSettingsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'அமைப்புகள்';
	@override String get language => 'மொழி';
	@override String get theme => 'தீம்';
	@override String get themeLight => 'ஒளி';
	@override String get themeDark => 'இருள்';
	@override String get themeSystem => 'சிஸ்டம் தீமை பயன்படுத்தவும்';
	@override String get darkMode => 'இருண்ட நிலை';
	@override String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';
	@override String get notifications => 'அறிவிப்புகள்';
	@override String get cacheSettings => 'கேச் & சேமிப்பு';
	@override String get general => 'பொது';
	@override String get account => 'கணக்கு';
	@override String get blockedUsers => 'தடுக்கப்பட்ட பயனர்கள்';
	@override String get helpSupport => 'உதவி & ஆதரவு';
	@override String get contactUs => 'எங்களைத் தொடர்பு கொள்ளுங்கள்';
	@override String get legal => 'சட்டம்';
	@override String get privacyPolicy => 'தனியுரிமைக் கொள்கை';
	@override String get termsConditions => 'விதிமுறைகள் & நிபந்தனைகள்';
	@override String get privacy => 'தனியுரிமை';
	@override String get about => 'பற்றி';
	@override String get version => 'பதிப்பு';
	@override String get logout => 'வெளியேறு';
	@override String get deleteAccount => 'கணக்கை நீக்கு';
	@override String get deleteAccountTitle => 'கணக்கை நீக்கு';
	@override String get deleteAccountWarning => 'இந்த செயலை மீண்டும் செய்ய முடியாது!';
	@override String get deleteAccountDescription => 'உங்கள் கணக்கை நீக்கினால், உங்கள் அனைத்து பதிவுகள், கருத்துகள், சுயவிவரம், பின்தொடர்பவர்கள், சேமிக்கப்பட்ட கதைகள், பூக்க்மார்க்குகள், அரட்டைச் செய்திகள் மற்றும் உருவாக்கப்பட்ட கதைகள் நிரந்தரமாக அழிக்கப்படும்.';
	@override String get confirmPassword => 'உங்கள் கடவுச்சொல்லை உறுதிசெய்க';
	@override String get confirmPasswordDesc => 'கணக்கை நீக்குவதைக் உறுதிசெய்ய உங்கள் கடவுச்சொல்லை உள்ளிடுங்கள்.';
	@override String get googleReauth => 'உங்கள் அடையாளத்தை சரிபார்க்க Google-க்கு மாற்றப்படுவீர்கள்.';
	@override String get finalConfirmationTitle => 'இறுதி உறுதிப்படுத்தல்';
	@override String get finalConfirmation => 'நீங்கள் நிச்சயமாக உறுதியாக உள்ளீர்களா? இது நிரந்தரமானது மற்றும் மாற்ற முடியாது.';
	@override String get deleteMyAccount => 'என் கணக்கை நீக்கு';
	@override String get deletingAccount => 'கணக்கு நீக்கப்படுகிறது...';
	@override String get accountDeleted => 'உங்கள் கணக்கு நிரந்தரமாக நீக்கப்பட்டது.';
	@override String get deleteAccountFailed => 'கணக்கை நீக்கத் தோல்வி. தயவுசெய்து மீண்டும் முயற்சி செய்யுங்கள்.';
	@override String get downloadedStories => 'பதிவிறக்கப்பட்ட கதைகள்';
	@override String get couldNotOpenEmail => 'மின்னஞ்சல் செயலியைத் திறக்க முடியவில்லை. தயவுசெய்து எங்களை myitihas@gmail.com என்ற முகவரிக்கு மின்னஞ்சல் செய்யுங்கள்';
	@override String couldNotOpenLabel({required Object label}) => '${label} ஐ இப்போது திறக்க முடியவில்லை.';
	@override String get logoutTitle => 'வெளியேறு';
	@override String get logoutConfirm => 'நீங்கள் நிச்சயமாக வெளியேற விரும்புகிறீர்களா?';
	@override String get verifyYourIdentity => 'உங்கள் அடையாளத்தை உறுதிசெய்யுங்கள்';
	@override String get verifyYourIdentityDesc => 'உங்கள் அடையாளத்தை உறுதிசெய்ய உங்களை Google மூலம் உள்நுழையக் கோரப்படும்.';
	@override String get continueWithGoogle => 'Google மூலம் தொடருங்கள்';
	@override String reauthFailed({required Object error}) => 'மீண்டும் அங்கீகரிக்கத் தோல்வி: ${error}';
	@override String get passwordRequired => 'கடவுச்சொல் தேவை';
	@override String get invalidPassword => 'தவறான கடவுச்சொல். தயவுசெய்து மீண்டும் முயற்சி செய்யுங்கள்.';
	@override String get verify => 'உறுதிசெய்';
	@override String get continueLabel => 'தொடரவும்';
	@override String get unableToVerifyIdentity => 'அடையாளத்தை உறுதிசெய்ய முடியவில்லை. தயவுசெய்து மீண்டும் முயற்சி செய்யுங்கள்.';
}

// Path: auth
class _TranslationsAuthTa extends TranslationsAuthEn {
	_TranslationsAuthTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get login => 'உள்நுழை';
	@override String get signup => 'பதிவு செய்';
	@override String get email => 'மின்னஞ்சல்';
	@override String get password => 'கடவுச்சொல்';
	@override String get confirmPassword => 'கடவுச்சொல்லை உறுதிசெய்க';
	@override String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';
	@override String get resetPassword => 'கடவுச்சொல்லை மாற்று';
	@override String get dontHaveAccount => 'கணக்கு இல்லையா?';
	@override String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு இருக்கிறதா?';
	@override String get loginSuccess => 'உள்நுழைவு வெற்றிகரமாக முடிந்தது';
	@override String get signupSuccess => 'பதிவு வெற்றிகரமாக முடிந்தது';
	@override String get loginError => 'உள்நுழைவு தோல்வியடைந்தது';
	@override String get signupError => 'பதிவு தோல்வியடைந்தது';
}

// Path: error
class _TranslationsErrorTa extends TranslationsErrorEn {
	_TranslationsErrorTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get network => 'இணைய இணைப்பு இல்லை';
	@override String get server => 'சேவையகத்தில் பிழை ஏற்பட்டது';
	@override String get cache => 'சேமிக்கப்பட்ட தரவை ஏற்ற முடியவில்லை';
	@override String get timeout => 'கோரிக்கை நேரம் முடிந்துவிட்டது';
	@override String get notFound => 'வளம் காணப்படவில்லை';
	@override String get validation => 'சரிபார்ப்பு தோல்வி';
	@override String get unexpected => 'எதிர்பாராத பிழை ஒன்று ஏற்பட்டுள்ளது';
	@override String get tryAgain => 'தயவுசெய்து மீண்டும் முயற்சி செய்யுங்கள்';
	@override String couldNotOpenLink({required Object url}) => 'இணைப்பைத் திறக்க முடியவில்லை: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionTa extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get free => 'இலவசம்';
	@override String get plus => 'பிளஸ்';
	@override String get pro => 'ப்ரோ';
	@override String get upgradeToPro => 'ப்ரோவுக்கு மேம்படுத்துங்கள்';
	@override String get features => 'அம்சங்கள்';
	@override String get subscribe => 'சந்தா எடுக்கவும்';
	@override String get currentPlan => 'தற்போதைய திட்டம்';
	@override String get managePlan => 'திட்டத்தை நிர்வகிக்கவும்';
}

// Path: notification
class _TranslationsNotificationTa extends TranslationsNotificationEn {
	_TranslationsNotificationTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'அறிவிப்புகள்';
	@override String get peopleToConnect => 'இணைய வேண்டியவர்கள்';
	@override String get peopleToConnectSubtitle => 'பின்தொடர வேண்டியவர்களை கண்டறியுங்கள்';
	@override String followAgainInMinutes({required Object minutes}) => '${minutes} நிமிடங்களில் மீண்டும் பின்தொடரலாம்';
	@override String get noSuggestions => 'இப்போது பரிந்துரைகள் இல்லை';
	@override String get markAllRead => 'அனைத்தையும் வாசித்ததாகக் குறி';
	@override String get noNotifications => 'இன்னும் அறிவிப்புகள் இல்லை';
	@override String get noNotificationsSubtitle => 'யாராவது உங்கள் கதைகளுடன் தொடர்பு கொண்டால், அதை இங்கே காண்பீர்கள்';
	@override String get errorPrefix => 'பிழை:';
	@override String get retry => 'மீண்டும் முயற்சி செய்';
	@override String likedYourStory({required Object actorName}) => '${actorName} உங்கள் கதையை விரும்பினார்';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} உங்கள் கதையில் கருத்து தெரிவித்தார்';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} உங்கள் கருத்துக்கு பதிலளித்தார்';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} உங்களைப் பின்தொடரத் தொடங்கினார்';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} உங்களுக்கு ஒரு செய்தி அனுப்பினார்';
	@override String sharedYourStory({required Object actorName}) => '${actorName} உங்கள் கதையைப் பகிர்ந்தார்';
	@override String repostedYourStory({required Object actorName}) => '${actorName} உங்கள் கதையை மீண்டும் பகிர்ந்தார்';
	@override String mentionedYou({required Object actorName}) => '${actorName} உங்களை குறிப்பிட்டார்';
	@override String newPostFrom({required Object actorName}) => '${actorName} - அவரிடமிருந்து புதிய பதிவு';
	@override String get today => 'இன்று';
	@override String get thisWeek => 'இந்த வாரம்';
	@override String get earlier => 'முந்தையவை';
	@override String get delete => 'அழி';
}

// Path: profile
class _TranslationsProfileTa extends TranslationsProfileEn {
	_TranslationsProfileTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get followers => 'பின்தொடர்பவர்கள்';
	@override String get following => 'பின்தொடர்கிறேன்';
	@override String get unfollow => 'பின்தொடர்வதை நிறுத்து';
	@override String get follow => 'பின்தொடர்';
	@override String get about => 'பற்றி';
	@override String get stories => 'கதைகள்';
	@override String get unableToShareImage => 'படத்தைப் பகிர முடியவில்லை';
	@override String get imageSavedToPhotos => 'படம் கேலரியில் சேமிக்கப்பட்டது';
	@override String get view => 'பார்';
	@override String get saveToPhotos => 'கேலரிக்குச் சேமி';
	@override String get failedToLoadImage => 'படத்தை ஏற்ற முடியவில்லை';
}

// Path: feed
class _TranslationsFeedTa extends TranslationsFeedEn {
	_TranslationsFeedTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get loading => 'கதைகள் ஏற்றப்படுகின்றன...';
	@override String get loadingPosts => 'பதிவுகள் ஏற்றப்படுகின்றன...';
	@override String get loadingVideos => 'வீடியோக்கள் ஏற்றப்படுகின்றன...';
	@override String get loadingStories => 'கதைகள் ஏற்றப்படுகின்றன...';
	@override String get errorTitle => 'அப்பா! ஏதோ தவறு நடந்துவிட்டது';
	@override String get tryAgain => 'மீண்டும் முயற்சி செய்';
	@override String get noStoriesAvailable => 'கதைகள் எதுவும் கிடைக்கவில்லை';
	@override String get noImagesAvailable => 'பட பதிவுகள் எதுவும் இல்லை';
	@override String get noTextPostsAvailable => 'எழுத்து பதிவுகள் எதுவும் இல்லை';
	@override String get noContentAvailable => 'உள்ளடக்கம் எதுவும் இல்லை';
	@override String get refresh => 'புதுப்பிப்பு';
	@override String get comments => 'கருத்துகள்';
	@override String get commentsComingSoon => 'கருத்துகள் விரைவில் வரவிருக்கின்றன';
	@override String get addCommentHint => 'கருத்து சேர்க்க...';
	@override String get shareStory => 'கதையை பகிர்';
	@override String get sharePost => 'பதிவைப் பகிர்';
	@override String get shareThought => 'சிந்தனையைப் பகிர்';
	@override String get shareAsImage => 'படமாக பகிர்';
	@override String get shareAsImageSubtitle => 'ஒரு அழகான முன்னோட்ட அட்டையை உருவாக்கு';
	@override String get shareLink => 'இணைப்பைப் பகிர்';
	@override String get shareLinkSubtitle => 'கதையின் இணைப்பை நகலெடுக்கவோ பகிரவோ செய்யுங்கள்';
	@override String get shareImageLinkSubtitle => 'பதிவின் இணைப்பை நகலெடுக்கவோ பகிரவோ செய்யுங்கள்';
	@override String get shareTextLinkSubtitle => 'சிந்தனை இணைப்பை நகலெடுக்கவோ பகிரவோ செய்யுங்கள்';
	@override String get shareAsText => 'உரைப்பகுதியாக பகிர்';
	@override String get shareAsTextSubtitle => 'கதையின் ஒரு பகுதியைப் பகிர்';
	@override String get shareQuote => 'மேற்கோளை பகிர்';
	@override String get shareQuoteSubtitle => 'மேற்கோளை உரை வடிவில் பகிர்';
	@override String get shareWithImage => 'படத்துடன் பகிர்';
	@override String get shareWithImageSubtitle => 'படத்தையும் தலைப்பையும் சேர்த்து பகிர்';
	@override String get copyLink => 'இணைப்பை நகலெடு';
	@override String get copyLinkSubtitle => 'இணைப்பை கிளிப்போர்டுக்கு நகலெடு';
	@override String get copyText => 'உரையை நகலெடு';
	@override String get copyTextSubtitle => 'மேற்கோளை கிளிப்போர்டுக்கு நகலெடு';
	@override String get linkCopied => 'இணைப்பு கிளிப்போர்டுக்கு நகலெடுக்கப்பட்டது';
	@override String get textCopied => 'உரை கிளிப்போர்டுக்கு நகலெடுக்கப்பட்டது';
	@override String get sendToUser => 'பயனருக்கு அனுப்பு';
	@override String get sendToUserSubtitle => 'நண்பருக்கு நேரடியாக பகிர்';
	@override String get chooseFormat => 'வடிவத்தைத் தேர்ந்தெடுக்கவும்';
	@override String get linkPreview => 'இணைப்பு முன்னோட்டம்';
	@override String get linkPreviewSize => '1200 × 630';
	@override String get storyFormat => 'ஸ்டோரி வடிவம்';
	@override String get storyFormatSize => '1080 × 1920 (Instagram/Stories)';
	@override String get generatingPreview => 'முன்னோட்டம் உருவாக்கப்படுகிறது...';
	@override String get bookmarked => 'பூக்க்மார்க் செய்யப்பட்டது';
	@override String get removedFromBookmarks => 'பூக்க்மார்க்கிலிருந்து அகற்றப்பட்டது';
	@override String unlike({required Object count}) => 'விருப்பத்தை நீக்கு, ${count} விருப்பங்கள்';
	@override String like({required Object count}) => 'விருப்பு, ${count} விருப்பங்கள்';
	@override String commentCount({required Object count}) => '${count} கருத்துகள்';
	@override String shareCount({required Object count}) => 'பகிர், ${count} பகிர்வு';
	@override String get removeBookmark => 'பூக்க்மார்க்கை நீக்கு';
	@override String get addBookmark => 'பூக்க்மார்க் செய்';
	@override String get quote => 'மேற்கோள்';
	@override String get quoteCopied => 'மேற்கோள் கிளிப்போர்டுக்கு நகலெடுக்கப்பட்டது';
	@override String get copy => 'நகலெடு';
	@override String get tapToViewFullQuote => 'முழு மேற்கோளைப் பார்க்கத் தட்டவும்';
	@override String get quoteFromMyitihas => 'MyItihas இலிருந்து மேற்கோள்';
	@override late final _TranslationsFeedTabsTa tabs = _TranslationsFeedTabsTa._(_root);
	@override String get tapToShowCaption => 'குறிப்பைப் பார்க்கத் தட்டவும்';
	@override String get noVideosAvailable => 'வீடியோக்கள் எதுவும் இல்லை';
	@override String get selectUser => 'அனுப்ப வேண்டியவர்';
	@override String get searchUsers => 'பயனர்களைத் தேடுங்கள்...';
	@override String get noFollowingYet => 'நீங்கள் இன்னும் யாரையும் பின்தொடரவில்லை';
	@override String get noUsersFound => 'பயனர்கள் எதுவும் கிடைக்கவில்லை';
	@override String get tryDifferentSearch => 'வேறு தேடல் சொல்லைப் பயன்படுத்தி முயற்சிக்கவும்';
	@override String sentTo({required Object username}) => '${username} என்பவருக்கு அனுப்பப்பட்டது';
}

// Path: social
class _TranslationsSocialTa extends TranslationsSocialEn {
	_TranslationsSocialTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileTa editProfile = _TranslationsSocialEditProfileTa._(_root);
	@override late final _TranslationsSocialCreatePostTa createPost = _TranslationsSocialCreatePostTa._(_root);
	@override late final _TranslationsSocialCommentsTa comments = _TranslationsSocialCommentsTa._(_root);
	@override late final _TranslationsSocialEngagementTa engagement = _TranslationsSocialEngagementTa._(_root);
	@override String get editCaption => 'தலைப்பைத் திருத்து';
	@override String get reportPost => 'பதிவை புகார் செய்';
	@override String get reportReasonHint => 'இந்தப் பதிவில் என்ன தவறு என்பதைச் சொல்லுங்கள்';
	@override String get deletePost => 'பதிவை நீக்கு';
	@override String get deletePostConfirm => 'இந்த செயலை மீண்டும் செய்ய முடியாது.';
	@override String get postDeleted => 'பதிவு நீக்கப்பட்டது';
	@override String failedToDeletePost({required Object error}) => 'பதிவை நீக்கத் தோல்வி: ${error}';
	@override String failedToReportPost({required Object error}) => 'பதிவை புகாரளிக்கத் தோல்வி: ${error}';
	@override String get reportSubmitted => 'புகார் சமர்ப்பிக்கப்பட்டது. நன்றி.';
	@override String get acceptRequestFirst => 'முதலில் கோரிக்கைகள் பகுதியில் அவர்களின் கோரிக்கையை ஏற்றுக்கொள்ளுங்கள்.';
	@override String get requestSentWait => 'கோரிக்கை அனுப்பப்பட்டுள்ளது. அவர்கள் ஏற்றுக்கொள்ள காத்திருக்கவும்.';
	@override String get requestSentTheyWillSee => 'கோரிக்கை அனுப்பப்பட்டுள்ளது. அவர்கள் "Requests" இல் காண்பார்கள்.';
	@override String failedToShare({required Object error}) => 'பகிர்வதில் தோல்வி: ${error}';
	@override String get updateCaptionHint => 'உங்கள் பதிவிற்கான தலைப்பை புதுப்பிக்கவும்';
}

// Path: voice
class _TranslationsVoiceTa extends TranslationsVoiceEn {
	_TranslationsVoiceTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'மைக்ரோஃபோன் அனுமதி தேவை';
	@override String get speechRecognitionNotAvailable => 'குரல் அங்கீகாரம் கிடைக்கவில்லை';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsTa extends TranslationsFestivalsEn {
	_TranslationsFestivalsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'விழாக் கதைகள்';
	@override String get tellStory => 'கதை சொல்லுங்கள்';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroTa extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'ஆராய தட்டவும்';
	@override late final _TranslationsHomeScreenHeroStoryTa story = _TranslationsHomeScreenHeroStoryTa._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionTa companion = _TranslationsHomeScreenHeroCompanionTa._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageTa heritage = _TranslationsHomeScreenHeroHeritageTa._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityTa community = _TranslationsHomeScreenHeroCommunityTa._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesTa messages = _TranslationsHomeScreenHeroMessagesTa._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthTa extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get short => 'குறுகிய';
	@override String get medium => 'இடைக்கால';
	@override String get long => 'நீண்ட';
	@override String get epic => 'மகத்தான';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatTa extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'கதை வடிவம்';
	@override String get dialogue => 'உரையாடல் ஆதாரமான';
	@override String get poetic => 'கவிதைபாணி';
	@override String get scriptural => 'சாஸ்திர பாணி';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsTa extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'கிருஷ்ணர் அர்ஜுனனுக்கு உபதேசம் செய்கிற கதையைச் சொல்லுங்கள்...';
	@override String get warriorRedemption => 'மீட்சியைத் தேடும் ஒரு வீரனின் மகத்தான காவியத்தை எழுதுங்கள்...';
	@override String get sageWisdom => 'முனிவர்களின் ஞானத்தைப் பற்றிய கதையை உருவாக்குங்கள்...';
	@override String get devotedSeeker => 'ஒரு பக்தன் தேடுபயணத்தை விவரிக்கவும்...';
	@override String get divineIntervention => 'தெய்வீக தலையீட்டின் புராணக் கதையைப் பகிருங்கள்...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsTa extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'தயவுசெய்து தேவையான அனைத்து விருப்பங்களையும் நிரப்புங்கள்';
	@override String get generationFailed => 'கதை உருவாக்கத் தோல்வி. தயவுசெய்து மீண்டும் முயற்சி செய்யுங்கள்.';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsTa extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  வணக்கம்!';
	@override String get dharma => '📖  தர்மம் என்றால் என்ன?';
	@override String get stress => '🧘  மனஅழுத்தத்தை எப்படி சமாளிப்பது';
	@override String get karma => '⚡  கர்மாவை எளிமையாக விளக்குங்கள்';
	@override String get story => '💬  எனக்கு ஒரு கதை சொல்லுங்கள்';
	@override String get wisdom => '🌟  இன்றைய ஞானம்';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsTa extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get poll => 'கருத்துக்கணிப்பு';
	@override String get camera => 'கேமரா';
	@override String get photos => 'படங்கள்';
	@override String get location => 'இருப்பிடம்';
	@override String get pollTitle => 'வாக்கெடுப்பை உருவாக்கு';
	@override String get pollQuestionHint => 'ஒரு கேள்வியைக் கேள்';
	@override String pollOptionHint({required Object n}) => 'விருப்பம் ${n}';
	@override String get addOption => 'விருப்பத்தைச் சேர்';
	@override String get removeOption => 'நீக்கு';
	@override String get sendPoll => 'வாக்கெடுப்பை அனுப்பு';
	@override String get pollNeedTwoOptions => 'குறைந்தது 2 விருப்பங்கள் (அதிகபட்சம் 4).';
	@override String get pollMaxOptions => '4 வரை விருப்பங்கள் சேர்க்கலாம்.';
	@override String get sharedLocationTitle => 'பகிரப்பட்ட இருப்பிடம்';
	@override String get sendLocation => 'இருப்பிடத்தை அனுப்பு';
	@override String get locationPreviewTitle => 'உங்கள் தற்போதைய இருப்பிடத்தை அனுப்பவா?';
	@override String get locationFetching => 'இருப்பிடம் பெறுகிறது…';
	@override String get openInMaps => 'வரைபடத்தில் திற';
	@override String voteCount({required Object count}) => '${count} வாக்குகள்';
	@override String get voteCountOne => '1 வாக்கு';
	@override String get tapToVote => 'வாக்களிக்க விருப்பத்தைத் தட்டவும்';
	@override String get mapsUnavailable => 'வரைபடத்தைத் திறக்க முடியவில்லை.';
}

// Path: map.discussions
class _TranslationsMapDiscussionsTa extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'விவாதத்தைப் பதிவு செய்';
	@override String get intentCardCta => 'ஒரு விவாதத்தைப் பதிவு செய்';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapTa extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapTa extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapTa extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

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
class _TranslationsMapFoodMapTa extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

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
class _TranslationsFeedTabsTa extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get all => 'அனைத்து';
	@override String get stories => 'கதைகள்';
	@override String get posts => 'பதிவுகள்';
	@override String get videos => 'வீடியோக்கள்';
	@override String get images => 'படங்கள்';
	@override String get text => 'சிந்தனைகள்';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileTa extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'சுயவிவரத்தைத் திருத்து';
	@override String get displayName => 'காணப்படும் பெயர்';
	@override String get displayNameHint => 'உங்கள் காணப்படும் பெயரை உள்ளிடுங்கள்';
	@override String get displayNameEmpty => 'காணப்படும் பெயர் காலியாக இருக்க முடியாது';
	@override String get bio => 'சுருக்கமான விவரம்';
	@override String get bioHint => 'உங்களைப் பற்றி கூறுங்கள்...';
	@override String get changePhoto => 'சுயவிவரப் புகைப்படத்தை மாற்று';
	@override String get saveChanges => 'மாற்றங்களைச் சேமி';
	@override String get profileUpdated => 'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';
	@override String get profileAndPhotoUpdated => 'சுயவிவரமும் புகைப்படமும் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';
	@override String failedPickImage({required Object error}) => 'புகைப்படத்தைத் தேர்ந்தெடுக்க முடியவில்லை: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'புகைப்படத்தைப் பதிவேற்ற முடியவில்லை: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'சுயவிவரத்தைப் புதுப்பிக்க முடியவில்லை: ${error}';
	@override String unexpectedError({required Object error}) => 'எதிர்பாராத பிழை: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostTa extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get title => 'பதிவு உருவாக்கு';
	@override String get post => 'பதிவு செய்';
	@override String get text => 'உரை';
	@override String get image => 'படம்';
	@override String get video => 'வீடியோ';
	@override String get textHint => 'உங்கள் மனதில் என்ன இருக்கிறது?';
	@override String get imageCaptionHint => 'உங்கள் படத்திற்கான தலைப்பை எழுதுங்கள்...';
	@override String get videoCaptionHint => 'உங்கள் வீடியோவை விவரியுங்கள்...';
	@override String get shareCaptionHint => 'உங்கள் எண்ணங்களைச் சேர்க்கவும்...';
	@override String get titleHint => 'ஒரு தலைப்பைச் சேர்க்கவும் (விருப்பம்)';
	@override String get selectVideo => 'வீடியோ தேர்வு செய்';
	@override String get gallery => 'கேலரி';
	@override String get camera => 'கேமரா';
	@override String get visibility => 'இதை யார் பார்க்கலாம்?';
	@override String get public => 'பொது';
	@override String get followers => 'பின்தொடர்பவர்கள்';
	@override String get private => 'தனிப்பட்டது';
	@override String get postCreated => 'பதிவு உருவாக்கப்பட்டது!';
	@override String get failedPickImages => 'புகைப்படங்களைத் தேர்ந்தெடுக்கத் தோல்வி';
	@override String get failedPickVideo => 'வீடியோவைத் தேர்ந்தெடுக்கத் தோல்வி';
	@override String get failedCapturePhoto => 'புகைப்படம் எடுக்கத் தோல்வி';
	@override String get cannotCreateOffline => 'ஆஃப்லைனில் பதிவை உருவாக்க முடியாது';
	@override String get discardTitle => 'பதிவை நீக்கவா?';
	@override String get discardMessage => 'சேமிக்கப்படாத மாற்றங்கள் உள்ளன. இந்தப் பதிவை நிச்சயம் நீக்கவா?';
	@override String get keepEditing => 'திருத்துவதைத் தொடரவும்';
	@override String get discard => 'நீக்கு';
	@override String get cropPhoto => 'புகைப்படத்தை வெட்டு';
	@override String get trimVideo => 'வீடியோவை வெட்டு';
	@override String get editPhoto => 'புகைப்படத்தைத் திருத்து';
	@override String get editVideo => 'வீடியோவைத் திருத்து';
	@override String get maxDuration => 'அதிகபட்சம் 30 விநாடிகள்';
	@override String get aspectSquare => 'சதுரம்';
	@override String get aspectPortrait => 'நீளவகை';
	@override String get aspectLandscape => 'அகலவகை';
	@override String get aspectFree => 'இச்சைக்கேற்ப';
	@override String get failedCrop => 'புகைப்படத்தை வெட்டத் தோல்வி';
	@override String get failedTrim => 'வீடியோவை வெட்டத் தோல்வி';
	@override String get trimmingVideo => 'வீடியோ வெட்டப்படுகிறது...';
	@override String trimVideoSubtitle({required Object max}) => 'அதிகபட்சம் ${max}வி · சிறந்த பகுதியைத் தேர்வு செய்க';
	@override String get trimVideoInstructionsTitle => 'உங்கள் கிளிப்பை வெட்டுங்கள்';
	@override String get trimVideoInstructionsBody => 'தொடக்கம் மற்றும் முடிவு கைப்பிடிகளை இழுத்து 30 விநாடி வரை பகுதியைத் தேர்வுசெய்க.';
	@override String get trimStart => 'தொடக்கம்';
	@override String get trimEnd => 'முடிவு';
	@override String get trimSelectionEmpty => 'தொடர செல்ல செல்லுபடியாகும் வரம்பைத் தேர்வு செய்யவும்';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}வி தேர்வு செய்யப்பட்டது (${start}–${end}) · அதிகபட்சம் ${max}வி';
	@override String get coverFrame => 'கவர் ஃப்ரேம்';
	@override String get coverFrameUnavailable => 'முன்னோட்டம் இல்லை';
	@override String coverFramePosition({required Object time}) => '${time} இல் கவர்';
	@override String get overlayLabel => 'வீடியோவில் உரை (விருப்பம்)';
	@override String get overlayHint => 'சிறிய ஹுக் அல்லது தலைப்பைச் சேர்க்கவும்';
	@override String get imageSectionHint => 'கேலரி அல்லது கேமராவில் இருந்து அதிகபட்சம் 10 படங்களைச் சேர்க்கவும்';
	@override String get videoSectionHint => 'ஒரு வீடியோ, அதிகபட்சம் 30 விநாடிகள்';
	@override String get removePhoto => 'புகைப்படத்தை நீக்கு';
	@override String get removeVideo => 'வீடியோவை நீக்கு';
	@override String get photoEditHint => 'வெட்ட அல்லது நீக்க புகைப்படத்தைத் தொடுங்கள்';
	@override String get videoEditOptions => 'திருத்து விருப்பங்கள்';
	@override String get addPhoto => 'புகைப்படத்தைச் சேர்க்கவும்';
	@override String get done => 'முடிந்தது';
	@override String get rotate => 'சுழற்று';
	@override String get editPhotoSubtitle => 'ஃபீடில் சிறந்த தோற்றத்திற்காக சதுரமாக வெட்டவும்';
	@override String get videoEditorCaptionLabel => 'விளக்கம் / உரை (விருப்பம்)';
	@override String get videoEditorCaptionHint => 'எ.கா. உங்கள் ரீலுக்கு தலைப்பு அல்லது ஹுக்';
	@override String get videoEditorAspectLabel => 'விகிதம்';
	@override String get videoEditorAspectOriginal => 'அசல்';
	@override String get videoEditorAspectSquare => '1:1';
	@override String get videoEditorAspectPortrait => '9:16';
	@override String get videoEditorAspectLandscape => '16:9';
	@override String get videoEditorQuickTrim => 'விரைவு ட்ரிம்';
	@override String get videoEditorSpeed => 'வேகம்';
}

// Path: social.comments
class _TranslationsSocialCommentsTa extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} அவர்களுக்கு பதிலளிக்கிறது';
	@override String replyHint({required Object name}) => '${name} அவர்களுக்கு பதில் எழுதுங்கள்...';
	@override String failedToPost({required Object error}) => 'பதிவிடத் தோல்வி: ${error}';
	@override String get cannotPostOffline => 'ஆஃப்லைனில் கருத்துகளை இட முடியாது';
	@override String get noComments => 'இன்னும் கருத்துகள் இல்லை';
	@override String get beFirst => 'முதல் கருத்து நீங்கள் இடுங்கள்!';
}

// Path: social.engagement
class _TranslationsSocialEngagementTa extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'ஆஃப்லைன் நிலை';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryTa extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ஏஐ கதை உருவாக்கம்';
	@override String get headline => 'மூழ்கடிக்கும்\nகதைகளை\nஉருவாக்குங்கள்';
	@override String get subHeadline => 'பழமையான ஞானத்தின் சக்தியால்';
	@override String get line1 => '✦  ஒரு புனித சாஸ்திரத்தை தேர்வு செய்யுங்கள்...';
	@override String get line2 => '✦  தெளிவான சூழலை தேர்வு செய்யுங்கள்...';
	@override String get line3 => '✦  ஏஐயால் மயக்கும் கதையை நெய்ய விடுங்கள்...';
	@override String get cta => 'கதை உருவாக்கு';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionTa extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ஆன்மீக துணைவர்';
	@override String get headline => 'உங்கள் தெய்வீக\nவழிகாட்டி,\nஎப்போதும் அருகில்';
	@override String get subHeadline => 'கிருஷ்ணரின் ஞானம் ஊக்கமாக';
	@override String get line1 => '✦  உண்மையில் கேட்கும் ஒரு நண்பன்...';
	@override String get line2 => '✦  வாழ்க்கைச் சவால்களுக்கு ஞானம்...';
	@override String get line3 => '✦  உங்களை உயர்த்தும் உரையாடல்கள்...';
	@override String get cta => 'அரட்டை தொடங்கு';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageTa extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'பாரம்பரிய வரைபடம்';
	@override String get headline => 'நித்திய\nபாரம்பரியத்தை\nகண்டறியுங்கள்';
	@override String get subHeadline => '5000+ புனித தளங்கள் வரைபடத்தில்';
	@override String get line1 => '✦  புனித இடங்களை ஆராயுங்கள்...';
	@override String get line2 => '✦  வரலாறும் கதைகளும் படியுங்கள்...';
	@override String get line3 => '✦  அர்த்தமுள்ள பயணங்களை திட்டமிடுங்கள்...';
	@override String get cta => 'வரைபடம் ஆராய்';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityTa extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'சமூக வெளி';
	@override String get headline => 'கலாசாரத்தை\nஉலகத்துடன்\nபகிருங்கள்';
	@override String get subHeadline => 'உற்சாகமான உலகளாவிய சமூகத்தளம்';
	@override String get line1 => '✦  பதிவுகள் மற்றும் ஆழமான விவாதங்கள்...';
	@override String get line2 => '✦  குறும்பட கலாசார வீடியோக்கள்...';
	@override String get line3 => '✦  உலகம் முழுதிலுமுள்ள கதைகள்...';
	@override String get cta => 'சமூகத்தில் சேருங்கள்';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesTa extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesTa._(TranslationsTa root) : this._root = root, super.internal(root);

	final TranslationsTa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'தனிப்பட்ட செய்திகள்';
	@override String get headline => 'அர்த்தமுள்ள\nஉரையாடல்கள்\nஇங்கிருந்து தொடங்கும்';
	@override String get subHeadline => 'தனிப்பட்ட மற்றும் சிந்தனையுள்ள இடங்கள்';
	@override String get line1 => '✦  ஒரே மனப்பான்மை உடையவர்களுடன் இணையுங்கள்...';
	@override String get line2 => '✦  கருத்துகளும் கதைகளும் விவாதியுங்கள்...';
	@override String get line3 => '✦  சிந்தனையுள்ள சமூகங்களை உருவாக்குங்கள்...';
	@override String get cta => 'செய்திகளை திறக்கவும்';
}
