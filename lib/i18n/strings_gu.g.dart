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
class TranslationsGu extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsGu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.gu,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <gu>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsGu _root = this; // ignore: unused_field

	@override 
	TranslationsGu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsGu(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppGu app = _TranslationsAppGu._(_root);
	@override late final _TranslationsCommonGu common = _TranslationsCommonGu._(_root);
	@override late final _TranslationsNavigationGu navigation = _TranslationsNavigationGu._(_root);
	@override late final _TranslationsHomeGu home = _TranslationsHomeGu._(_root);
	@override late final _TranslationsHomeScreenGu homeScreen = _TranslationsHomeScreenGu._(_root);
	@override late final _TranslationsStoriesGu stories = _TranslationsStoriesGu._(_root);
	@override late final _TranslationsStoryGeneratorGu storyGenerator = _TranslationsStoryGeneratorGu._(_root);
	@override late final _TranslationsChatGu chat = _TranslationsChatGu._(_root);
	@override late final _TranslationsMapGu map = _TranslationsMapGu._(_root);
	@override late final _TranslationsCommunityGu community = _TranslationsCommunityGu._(_root);
	@override late final _TranslationsDiscoverGu discover = _TranslationsDiscoverGu._(_root);
	@override late final _TranslationsPlanGu plan = _TranslationsPlanGu._(_root);
	@override late final _TranslationsSettingsGu settings = _TranslationsSettingsGu._(_root);
	@override late final _TranslationsAuthGu auth = _TranslationsAuthGu._(_root);
	@override late final _TranslationsErrorGu error = _TranslationsErrorGu._(_root);
	@override late final _TranslationsSubscriptionGu subscription = _TranslationsSubscriptionGu._(_root);
	@override late final _TranslationsNotificationGu notification = _TranslationsNotificationGu._(_root);
	@override late final _TranslationsProfileGu profile = _TranslationsProfileGu._(_root);
	@override late final _TranslationsFeedGu feed = _TranslationsFeedGu._(_root);
	@override late final _TranslationsVoiceGu voice = _TranslationsVoiceGu._(_root);
	@override late final _TranslationsFestivalsGu festivals = _TranslationsFestivalsGu._(_root);
	@override late final _TranslationsSocialGu social = _TranslationsSocialGu._(_root);
}

// Path: app
class _TranslationsAppGu extends TranslationsAppEn {
	_TranslationsAppGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'ભારતીય શાસ્ત્રોની શોધ કરો';
}

// Path: common
class _TranslationsCommonGu extends TranslationsCommonEn {
	_TranslationsCommonGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get ok => 'બરાબર';
	@override String get cancel => 'રદ કરો';
	@override String get confirm => 'ખાતરી કરો';
	@override String get delete => 'કાઢી નાંખો';
	@override String get edit => 'સંપાદિત કરો';
	@override String get save => 'સાચવો';
	@override String get share => 'શેર કરો';
	@override String get search => 'શોધો';
	@override String get loading => 'લોડ થઈ રહ્યું છે...';
	@override String get error => 'ભૂલ';
	@override String get retry => 'ફરી પ્રયાસ કરો';
	@override String get back => 'પાછળ';
	@override String get next => 'આગળ';
	@override String get finish => 'પૂરુ કરો';
	@override String get skip => 'છોડો';
	@override String get yes => 'હા';
	@override String get no => 'ના';
	@override String get readFullStory => 'સંપૂર્ણ વાર્તા વાંચો';
	@override String get dismiss => 'બંધ કરો';
	@override String get offlineBannerMessage => 'તમે ઑફલાઇન છો – કેશ થયેલ સામગ્રી જોઈ રહ્યા છો';
	@override String get backOnline => 'ફરીથી ઑનલાઇન';
}

// Path: navigation
class _TranslationsNavigationGu extends TranslationsNavigationEn {
	_TranslationsNavigationGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get home => 'શોધો';
	@override String get stories => 'વાર્તાઓ';
	@override String get chat => 'ચેટ';
	@override String get map => 'નકશો';
	@override String get community => 'સામાજિક';
	@override String get settings => 'સેટિંગ્સ';
	@override String get profile => 'પ્રોફાઇલ';
}

// Path: home
class _TranslationsHomeGu extends TranslationsHomeEn {
	_TranslationsHomeGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'સ્ટોરી જનરેટર';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'સમુદાયની વાર્તાઓ';
	@override String get maps => 'નકશા';
	@override String get greetingMorning => 'શુભ સવાર';
	@override String get continueReading => 'વાંચવું ચાલુ રાખો';
	@override String get greetingAfternoon => 'શુભ બપોર';
	@override String get greetingEvening => 'શુભ સાંજ';
	@override String get greetingNight => 'શુભ રાત્રી';
	@override String get exploreStories => 'વાર્તાઓ શોધો';
	@override String get generateStory => 'વાર્તા બનાવો';
	@override String get content => 'હોમ કન્ટેન્ટ';
}

// Path: homeScreen
class _TranslationsHomeScreenGu extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'નમસ્તે';
	@override String get quoteOfTheDay => 'આજનો વિચાર';
	@override String get shareQuote => 'વિચાર શેર કરો';
	@override String get copyQuote => 'વિચાર કૉપિ કરો';
	@override String get quoteCopied => 'વિચાર ક્લિપબોર્ડમાં કૉપિ થયો';
	@override String get featuredStories => 'પસંદ કરેલી વાર્તાઓ';
	@override String get quickActions => 'ઝડપી ક્રિયાઓ';
	@override String get generateStory => 'વાર્તા બનાવો';
	@override String get chatWithKrishna => 'કૃષ્ણ સાથે વાત કરો';
	@override String get myActivity => 'મારી પ્રવૃત્તિ';
	@override String get continueReading => 'વાંચવું ચાલુ રાખો';
	@override String get savedStories => 'સાચવેલી વાર્તાઓ';
	@override String get exploreMyitihas => 'માયઇતિહાસ શોધો';
	@override String get storiesInYourLanguage => 'તમારી ભાષામાં વાર્તાઓ';
	@override String get seeAll => 'બધી જુઓ';
	@override String get startReading => 'વાંચવાનું શરૂ કરો';
	@override String get exploreStories => 'તમારી યાત્રા શરૂ કરવા વાર્તાઓ શોધો';
	@override String get saveForLater => 'તમને ગમતી વાર્તાઓને બુકમાર્ક કરો';
	@override String get noActivityYet => 'હજુ સુધી કોઈ પ્રવૃત્તિ નથી';
	@override String minLeft({required Object count}) => '${count} મિનિટ બાકી';
	@override String get activityHistory => 'પ્રવૃત્તિ ઇતિહાસ';
	@override String get storyGenerated => 'વાર્તા બનાવાઈ';
	@override String get storyRead => 'વાર્તા વાંચાઈ';
	@override String get storyBookmarked => 'વાર્તાને બુકમાર્ક કરવામાં આવી';
	@override String get storyShared => 'વાર્તા શેર થઈ';
	@override String get storyCompleted => 'વાર્તા પૂર્ણ થઈ';
	@override String get today => 'આજે';
	@override String get yesterday => 'ગઈકાલે';
	@override String get thisWeek => 'આ અઠવાડિયું';
	@override String get earlier => 'પહેલાં';
	@override String get noContinueReading => 'હજુ સુધી વાંચવા માટે કંઈ નથી';
	@override String get noSavedStories => 'હજુ સુધી કોઈ સાચવેલી વાર્તા નથી';
	@override String get bookmarkStoriesToSave => 'વાર્તાઓને સાચવવા માટે બુકમાર્ક કરો';
	@override String get myGeneratedStories => 'મારી વાર્તાઓ';
	@override String get noGeneratedStoriesYet => 'હજુ સુધી કોઈ વાર્તા બનાવાઈ નથી';
	@override String get createYourFirstStory => 'AIની મદદથી તમારી પહેલી વાર્તા બનાવો';
	@override String get shareToFeed => 'ફીડમાં શેર કરો';
	@override String get sharedToFeed => 'વાર્તા ફીડમાં શેર કરવામાં આવી';
	@override String get shareStoryTitle => 'વાર્તા શેર કરો';
	@override String get shareStoryMessage => 'તમારી વાર્તા માટે કૅપ્શન ઉમેરો (વૈકલ્પિક)';
	@override String get shareStoryCaption => 'કૅપ્શન';
	@override String get shareStoryHint => 'આ વાર્તા વિશે તમે શું કહેવા માંગો છો?';
	@override String get exploreHeritageTitle => ' વારસો શોધો';
	@override String get exploreHeritageDesc => 'નકશા પર સાંસ્કૃતિક વારસા ધરાવતા સ્થળો શોધો';
	@override String get whereToVisit => 'આગામી મુલાકાત';
	@override String get scriptures => 'શાસ્ત્રો';
	@override String get exploreSacredSites => 'પવિત્ર સ્થળો શોધો';
	@override String get readStories => 'વાર્તાઓ વાંચો';
	@override String get yesRemindMe => 'હા, મને યાદ કરાવજો';
	@override String get noDontShowAgain => 'ના, ફરીથી ન બતાવો';
	@override String get discoverDismissTitle => 'Discover MyItihas છુપાવવું છે?';
	@override String get discoverDismissMessage => 'શું તમે આગળની વખત એપ ખોલો અથવા લોગિન કરો ત્યારે આ ફરીથી જોવા માંગો છો?';
	@override String get discoverCardTitle => 'MyItihas શોધો';
	@override String get discoverCardSubtitle => 'પ્રાચીન શાસ્ત્રોમાંથી વાર્તાઓ, શોધવા માટેના પવિત્ર સ્થળો અને તમારી બાજુએ જ્ઞાન.';
	@override String get swipeToDismiss => 'બંધ કરવા માટે ઉપર સ્વાઇપ કરો';
	@override String get searchScriptures => 'શાસ્ત્રો શોધો...';
	@override String get searchLanguages => 'ભાષાઓ શોધો...';
	@override String get exploreStoriesLabel => 'વાર્તાઓ શોધો';
	@override String get exploreMore => 'વધુ જુઓ';
	@override String get failedToLoadActivity => 'પ્રવૃત્તિ લોડ કરવામાં નિષ્ફળ';
	@override String get startReadingOrGenerating => 'અહીં તમારી પ્રવૃત્તિ જોવા માટે વાર્તાઓ વાંચવાનું અથવા બનાવવાનું શરૂ કરો';
	@override late final _TranslationsHomeScreenHeroGu hero = _TranslationsHomeScreenHeroGu._(_root);
}

// Path: stories
class _TranslationsStoriesGu extends TranslationsStoriesEn {
	_TranslationsStoriesGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'વાર્તાઓ';
	@override String get searchHint => 'શીર્ષક અથવા લેખક દ્વારા શોધો...';
	@override String get sortBy => 'ક્રમાંકિત કરો';
	@override String get sortNewest => 'નવી પહેલા';
	@override String get sortOldest => 'જૂની પહેલા';
	@override String get sortPopular => 'સૌથી લોકપ્રિય';
	@override String get noStories => 'કોઈ વાર્તાઓ મળી નથી';
	@override String get loadingStories => 'વાર્તાઓ લોડ થઈ રહી છે...';
	@override String get errorLoadingStories => 'વાર્તાઓ લોડ કરવામાં નિષ્ફળ';
	@override String get storyDetails => 'વાર્તાની વિગતો';
	@override String get continueReading => 'વાંચવું ચાલુ રાખો';
	@override String get readMore => 'વધુ વાંચો';
	@override String get readLess => 'ઓછું બતાવો';
	@override String get author => 'લેખક';
	@override String get publishedOn => 'પ્રકાશિત';
	@override String get category => 'વર્ગ';
	@override String get tags => 'ટૅગ્સ';
	@override String get failedToLoad => 'વાર્તા લોડ કરવામાં નિષ્ફળ';
	@override String get subtitle => 'શાસ્ત્રોમાંથી કથાઓ શોધો';
	@override String get noStoriesHint => 'અલગ શોધ અથવા ફિલ્ટર અજમાવો અને કથાઓ શોધો.';
	@override String get featured => 'વિશેષ';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorGu extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'સ્ટોરી જનરેટર';
	@override String get subtitle => 'તમારી પોતાની શાસ્ત્રીય વાર્તા બનાવો';
	@override String get quickStart => 'ઝડપી શરૂઆત';
	@override String get interactive => 'સંવાદાત્મક';
	@override String get rawPrompt => 'રૉ પ્રોમ્પ્ટ';
	@override String get yourStoryPrompt => 'તમારી વાર્તા માટેનો પ્રોમ્પ્ટ';
	@override String get writeYourPrompt => 'તમારો પ્રોમ્પ્ટ લખો';
	@override String get selectScripture => 'શાસ્ત્ર પસંદ કરો';
	@override String get selectStoryType => 'વાર્તાનો પ્રકાર પસંદ કરો';
	@override String get selectCharacter => 'પાત્ર પસંદ કરો';
	@override String get selectTheme => 'થીમ પસંદ કરો';
	@override String get selectSetting => 'પરિસ્થિતિ / સ્થળ પસંદ કરો';
	@override String get selectLanguage => 'ભાષા પસંદ કરો';
	@override String get selectLength => 'વાર્તાની લંબાઈ';
	@override String get moreOptions => 'વધુ વિકલ્પો';
	@override String get random => 'રેન્ડમ';
	@override String get generate => 'વાર્તા બનાવો';
	@override String get generating => 'તમારી વાર્તા બનાવાઈ રહી છે...';
	@override String get creatingYourStory => 'તમારી વાર્તા તૈયાર થઈ રહી છે';
	@override String get consultingScriptures => 'પ્રાચીન શાસ્ત્રો સાથે પરામર્શ કરવામાં આવી રહ્યું છે...';
	@override String get weavingTale => 'તમારી વાર્તા નાથવામાં આવી રહી છે...';
	@override String get addingWisdom => 'દિવ્ય જ્ઞાન ઉમેરવામાં આવી રહ્યું છે...';
	@override String get polishingNarrative => 'વાર્તાને વધુ સુંદર બનાવવામાં આવી રહી છે...';
	@override String get almostThere => 'લગભગ થઈ ગયું...';
	@override String get generatedStory => 'તમારી બનાવેલી વાર્તા';
	@override String get aiGenerated => 'AI દ્વારા બનાવેલી';
	@override String get regenerate => 'ફરીથી બનાવો';
	@override String get saveStory => 'વાર્તા સાચવો';
	@override String get shareStory => 'વાર્તા શેર કરો';
	@override String get newStory => 'નવી વાર્તા';
	@override String get saved => 'સાચવ્યું';
	@override String get storySaved => 'વાર્તા તમારી લાઇબ્રેરીમાં સાચવી દેવામાં આવી છે';
	@override String get story => 'વાર્તા';
	@override String get lesson => 'પાઠ';
	@override String get didYouKnow => 'શું તમને ખબર છે?';
	@override String get activity => 'પ્રવૃત્તિ';
	@override String get optionalRefine => 'વૈકલ્પિક: વિકલ્પો સાથે વધુ સ્પષ્ટ કરો';
	@override String get applyOptions => 'વિકલ્પો લાગુ કરો';
	@override String get language => 'ભાષા';
	@override String get storyFormat => 'વાર્તાનો ફોર્મેટ';
	@override String get requiresInternet => 'વાર્તા બનાવા માટે ઇન્ટરનેટ જરૂરી છે';
	@override String get notAvailableOffline => 'વાર્તા ઓફલાઇન ઉપલબ્ધ નથી. જોવા માટે ઇન્ટરનેટ સાથે જોડાઓ.';
	@override String get aiDisclaimer => 'AI ક્યારેક ભૂલો કરી શકે છે. અમે સતત સુધારણા કરી રહ્યા છીએ; તમારો પ્રતિસાદ અમારે માટે મહત્વનો છે.';
	@override late final _TranslationsStoryGeneratorStoryLengthGu storyLength = _TranslationsStoryGeneratorStoryLengthGu._(_root);
	@override late final _TranslationsStoryGeneratorFormatGu format = _TranslationsStoryGeneratorFormatGu._(_root);
	@override late final _TranslationsStoryGeneratorHintsGu hints = _TranslationsStoryGeneratorHintsGu._(_root);
	@override late final _TranslationsStoryGeneratorErrorsGu errors = _TranslationsStoryGeneratorErrorsGu._(_root);
}

// Path: chat
class _TranslationsChatGu extends TranslationsChatEn {
	_TranslationsChatGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'શાસ્ત્રો વિશે AI સાથે વાત કરો';
	@override String get friendMode => 'મિત્ર મોડ';
	@override String get philosophicalMode => 'તત્ત્વચિંતન મોડ';
	@override String get typeMessage => 'તમારો સંદેશ લખો...';
	@override String get send => 'મોકલો';
	@override String get newChat => 'નવી ચેટ';
	@override String get chatsTab => 'ચેટ';
	@override String get groupsTab => 'ગ્રુપ્સ';
	@override String get chatHistory => 'ચેટ ઇતિહાસ';
	@override String get clearChat => 'ચેટ સાફ કરો';
	@override String get noMessages => 'હજુ સુધી કોઈ સંદેશાઓ નથી. એક ચર્ચા શરૂ કરો!';
	@override String get listPage => 'ચેટ સૂચિ પાનું';
	@override String get forwardMessageTo => 'સંદેશ આગળ મોકલો...';
	@override String get forwardMessage => 'ફોરવર્ડ કરો';
	@override String get messageForwarded => 'સંદેશ ફોરવર્ડ કરી દીધો';
	@override String failedToForward({required Object error}) => 'સંદેશ ફોરવર્ડ કરવામાં નિષ્ફળ: ${error}';
	@override String get searchChats => 'ચેટ્સ શોધો';
	@override String get noChatsFound => 'કોઈ ચેટ મળી નથી';
	@override String get requests => 'વિનંતીઓ';
	@override String get messageRequests => 'સંદેશ વિનંતીઓ';
	@override String get groupRequests => 'ગ્રુપ વિનંતીઓ';
	@override String get requestSent => 'વિનંતી મોકલી દેવામાં આવી છે. તેઓ તેને "Requests" માં જોશે.';
	@override String get wantsToChat => 'ચેટ કરવી ઇચ્છે છે';
	@override String addedYouTo({required Object name}) => '${name} એ તમને ઉમેર્યા છે';
	@override String get accept => 'સ્વીકારો';
	@override String get noMessageRequests => 'કોઈ સંદેશ વિનંતીઓ નથી';
	@override String get noGroupRequests => 'કોઈ ગ્રુપ વિનંતીઓ નથી';
	@override String get invitesSent => 'આમંત્રણો મોકલ્યા. તેઓ તેને "Requests" માં જોશે.';
	@override String get cantMessageUser => 'તમે આ વપરાશકર્તાને સંદેશ મોકલી શકતા નથી';
	@override String get deleteChat => 'ચેટ ડિલીટ કરો';
	@override String get deleteChats => 'ચેટ્સ ડિલીટ કરો';
	@override String get blockUser => 'વપરાશકર્તાને બ્લોક કરો';
	@override String get reportUser => 'વપરાશકર્તાની ફરીયાદ કરો';
	@override String get markAsRead => 'વાંચેલ તરીકે ચિહ્નિત કરો';
	@override String get markedAsRead => 'વાંચેલ તરીકે ચિહ્નિત કર્યું';
	@override String get deleteClearChat => 'ચેટ ડિલીટ / સાફ કરો';
	@override String get deleteConversation => 'ચર્ચા ડિલીટ કરો';
	@override String get reasonRequired => 'કારણ (જરૂરી)';
	@override String get submit => 'સબમિટ કરો';
	@override String get userReportedBlocked => 'વપરાશકર્તાની ફરીયાદ કરવામાં આવી અને તેને બ્લોક કરવામાં આવ્યો.';
	@override String reportFailed({required Object error}) => 'ફરીયાદ કરવામાં નિષ્ફળ: ${error}';
	@override String get newGroup => 'નવો ગ્રુપ';
	@override String get messageSomeoneDirectly => 'કોઈને સીધો સંદેશ મોકલો';
	@override String get createGroupConversation => 'ગ્રુપ ચર્ચા બનાવો';
	@override String get noGroupsYet => 'હજુ સુધી કોઈ ગ્રુપ નથી';
	@override String get noChatsYet => 'હજુ સુધી કોઈ ચેટ નથી';
	@override String get tapToCreateGroup => 'ગ્રુપ બનાવવા અથવા જોડાવા માટે + દબાવો';
	@override String get tapToStartConversation => 'નવી ચર્ચા શરૂ કરવા માટે + દબાવો';
	@override String get conversationDeleted => 'ચર્ચા ડિલીટ કરી દેવામાં આવી';
	@override String conversationsDeleted({required Object count}) => '${count} ચર્ચા(ઓ) ડિલીટ કરી';
	@override String get searchConversations => 'ચર્ચાઓ શોધો...';
	@override String get connectToInternet => 'કૃપા કરીને ઇન્ટરનેટ સાથે કનેક્ટ કરો અને ફરી પ્રયત્ન કરો.';
	@override String get littleKrishnaName => 'નાનો કૃષ્ણ';
	@override String get newConversation => 'નવી ચર્ચા';
	@override String get noConversationsYet => 'હજુ સુધી કોઈ ચર્ચા નથી';
	@override String get confirmDeletion => 'ડિલીટ કરવાની ખાતરી કરો';
	@override String deleteConversationConfirm({required Object title}) => 'શું તમે ખરેખર ${title} ચર્ચા ડિલીટ કરવા માંગો છો?';
	@override String get deleteFailed => 'ચર્ચા ડિલીટ કરવામાં નિષ્ફળ';
	@override String get fullChatCopied => 'સમગ્ર ચેટ ક્લિપબોર્ડમાં કૉપિ થઈ ગઈ!';
	@override String get connectionErrorFallback => 'હાલમાં કનેક્ટ કરવામાં મુશ્કેલી આવી રહી છે. કૃપા કરીને થોડા સમય પછી ફરી પ્રયત્ન કરો.';
	@override String krishnaWelcomeWithName({required Object name}) => 'હે ${name}. હું તમારો મિત્ર કૃષ્ણ છું. આજે તમે કેવી રીતે છો?';
	@override String get krishnaWelcomeFriend => 'હે પ્રિય મિત્ર. હું તમારો મિત્ર કૃષ્ણ છું. આજે તમે કેવી રીતે છો?';
	@override String get copyYouLabel => 'તમે';
	@override String get copyKrishnaLabel => 'કૃષ્ણ';
	@override late final _TranslationsChatSuggestionsGu suggestions = _TranslationsChatSuggestionsGu._(_root);
	@override String get about => 'વિશે';
	@override String get yourFriendlyCompanion => 'તમારો મિત્રભાવસભર સાથી';
	@override String get mentalHealthSupport => 'માનસિક સ્વાસ્થ્ય માટે મદદ';
	@override String get mentalHealthSupportSubtitle => 'વિચાર શેર કરવા અને સાંભળવામાં આવે તેવી ભાવના માટે એક સુરક્ષિત જગ્યા.';
	@override String get friendlyCompanion => 'મિત્રસભર સાથી';
	@override String get friendlyCompanionSubtitle => 'હંમેશા વાત કરવા, પ્રોત્સાહન આપવા અને જ્ઞાન વહેંચવા માટે હાજર.';
	@override String get storiesAndWisdom => 'વાર્તાઓ અને જ્ઞાન';
	@override String get storiesAndWisdomSubtitle => 'શાશ્વત વાર્તાઓ અને પ્રાયોગિક જ્ઞાનમાંથી શીખો.';
	@override String get askAnything => 'કંઈ પણ પૂછો';
	@override String get askAnythingSubtitle => 'તમારા પ્રશ્નોના નમ્ર, વિચારપૂર્વકના જવાબો મેળવો.';
	@override String get startChatting => 'ચેટિંગ શરૂ કરો';
	@override String get maybeLater => 'પછીશુ';
	@override late final _TranslationsChatComposerAttachmentsGu composerAttachments = _TranslationsChatComposerAttachmentsGu._(_root);
}

// Path: map
class _TranslationsMapGu extends TranslationsMapEn {
	_TranslationsMapGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'અખંડ ભારત';
	@override String get subtitle => 'ઈતિહાસિક સ્થળો શોધો';
	@override String get searchLocation => 'સ્થાન શોધો...';
	@override String get viewDetails => 'વિગતો જુઓ';
	@override String get viewSites => 'સ્થળો જુઓ';
	@override String get showRoute => 'માર્ગ બતાવો';
	@override String get historicalInfo => 'ઈતિહાસિક માહિતી';
	@override String get nearbyPlaces => 'આસપાસના સ્થળો';
	@override String get pickLocationOnMap => 'નકશામાં સ્થાન પસંદ કરો';
	@override String get sitesVisited => 'પહોંચેલા સ્થળો';
	@override String get badgesEarned => 'મેળવેલા બૅજેસ';
	@override String get completionRate => 'પૂર્ણતાનો દર';
	@override String get addToJourney => 'યાત્રામાં ઉમેરો';
	@override String get addedToJourney => 'યાત્રામાં ઉમેરવામાં આવ્યું';
	@override String get getDirections => 'માર્ગ મેળવો';
	@override String get viewInMap => 'નકશામાં જુઓ';
	@override String get directions => 'દિશાઓ';
	@override String get photoGallery => 'ફોટો ગેલેરી';
	@override String get viewAll => 'બધા જુઓ';
	@override String get photoSavedToGallery => 'ફોટો ગેલેરીમાં સાચવવામાં આવ્યો';
	@override String get sacredSoundscape => 'પવિત્ર સાઉન્ડસ્કેપ';
	@override String get allDiscussions => 'બધી ચર્ચાઓ';
	@override String get journeyTab => 'યાત્રા';
	@override String get discussionTab => 'ચર્ચા';
	@override String get myActivity => 'મારી પ્રવૃત્તિ';
	@override String get anonymousPilgrim => 'અજાણ્યા યાત્રિક';
	@override String get viewProfile => 'પ્રોફાઇલ જુઓ';
	@override String get discussionTitleHint => 'ચર્ચાનું શીર્ષક...';
	@override String get shareYourThoughtsHint => 'તમારા વિચાર શેર કરો...';
	@override String get pleaseEnterDiscussionTitle => 'કૃપા કરીને ચર્ચાનું શીર્ષક દાખલ કરો';
	@override String get addReflection => 'અનુભવ ઉમેરો';
	@override String get reflectionTitle => 'શીર્ષક';
	@override String get enterReflectionTitle => 'અનુભવનું શીર્ષક દાખલ કરો';
	@override String get pleaseEnterTitle => 'કૃપા કરીને શીર્ષક દાખલ કરો';
	@override String get siteName => 'સ્થળનું નામ';
	@override String get enterSacredSiteName => 'પવિત્ર સ્થળનું નામ દાખલ કરો';
	@override String get pleaseEnterSiteName => 'કૃપા કરીને સ્થળનું નામ દાખલ કરો';
	@override String get reflection => 'અનુભવ';
	@override String get reflectionHint => 'તમારો અનુભવ અને વિચારો શેર કરો...';
	@override String get pleaseEnterReflection => 'કૃપા કરીને તમારો અનુભવ દાખલ કરો';
	@override String get saveReflection => 'અનુભવ સાચવો';
	@override String get journeyProgress => 'યાત્રાની પ્રગતિ';
	@override late final _TranslationsMapDiscussionsGu discussions = _TranslationsMapDiscussionsGu._(_root);
	@override late final _TranslationsMapFabricMapGu fabricMap = _TranslationsMapFabricMapGu._(_root);
	@override late final _TranslationsMapClassicalArtMapGu classicalArtMap = _TranslationsMapClassicalArtMapGu._(_root);
	@override late final _TranslationsMapClassicalDanceMapGu classicalDanceMap = _TranslationsMapClassicalDanceMapGu._(_root);
	@override late final _TranslationsMapFoodMapGu foodMap = _TranslationsMapFoodMapGu._(_root);
}

// Path: community
class _TranslationsCommunityGu extends TranslationsCommunityEn {
	_TranslationsCommunityGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'સમુદાય';
	@override String get trending => 'ટ્રેન્ડિંગ';
	@override String get following => 'ફોલોઇંગ';
	@override String get followers => 'ફોલોઅર્સ';
	@override String get posts => 'પોસ્ટ્સ';
	@override String get follow => 'ફોલો કરો';
	@override String get unfollow => 'ફોલો છોડો';
	@override String get shareYourStory => 'તમારી વાર્તા શેર કરો...';
	@override String get post => 'પોસ્ટ કરો';
	@override String get like => 'પસંદ';
	@override String get comment => 'ટિપ્પણી';
	@override String get comments => 'ટિપ્પણીઓ';
	@override String get noPostsYet => 'હજુ સુધી કોઈ પોસ્ટ નથી';
}

// Path: discover
class _TranslationsDiscoverGu extends TranslationsDiscoverEn {
	_TranslationsDiscoverGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'શોધો';
	@override String get searchHint => 'વાર્તાઓ, વપરાશકર્તાઓ અથવા વિષયો શોધો...';
	@override String get tryAgain => 'ફરી પ્રયાસ કરો';
	@override String get somethingWentWrong => 'કૈંક ખોટું થયું';
	@override String get unableToLoadProfiles => 'પ્રોફાઇલ્સ લોડ કરવામાં નિષ્ફળ. કૃપા કરીને ફરી પ્રયાસ કરો.';
	@override String get noProfilesFound => 'કોઇ પ્રોફાઇલ્સ મળી નથી';
	@override String get searchToFindPeople => 'લોકોને ફોલો કરવા માટે શોધો';
	@override String get noResultsFound => 'કોઈ પરિણામ મળ્યાં નથી';
	@override String get noProfilesYet => 'હજુ સુધી કોઈ પ્રોફાઇલ નથી';
	@override String get tryDifferentKeywords => 'વિનંતી છે કે બીજા કીવર્ડથી શોધો';
	@override String get beFirstToDiscover => 'નવા લોકોને શોધતા પહેલા બનો!';
}

// Path: plan
class _TranslationsPlanGu extends TranslationsPlanEn {
	_TranslationsPlanGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'તમારી યોજના સાચવવા માટે સાઇન ઇન કરો';
	@override String get planSaved => 'યોજનાને સાચવવામાં આવી';
	@override String get from => 'કયાંથી';
	@override String get dates => 'તારીખો';
	@override String get destination => 'ગંતવ્ય';
	@override String get nearby => 'નજીકમાં';
	@override String get generatedPlan => 'તૈયાર કરેલ યોજના';
	@override String get whereTravellingFrom => 'તમે ક્યાંથી મુસાફરી કરી રહ્યા છો?';
	@override String get enterCityOrRegion => 'તમારા શહેર અથવા પ્રદેશ દાખલ કરો';
	@override String get travelDates => 'મુસાફરીની તારીખો';
	@override String get destinationSacredSite => 'ગંતવ્ય (પવિત્ર સ્થાન)';
	@override String get searchOrSelectDestination => 'ગંતવ્ય શોધો અથવા પસંદ કરો...';
	@override String get shareYourExperience => 'તમારો અનુભવ શેર કરો';
	@override String get planShared => 'યોજનાને શેર કરવામાં આવી';
	@override String failedToSharePlan({required Object error}) => 'યોજનાને શેર કરવામાં નિષ્ફળ: ${error}';
	@override String get planUpdated => 'યોજનાને અપડેટ કરવામાં આવી';
	@override String failedToUpdatePlan({required Object error}) => 'યોજનાને અપડેટ કરવામાં નિષ્ફળ: ${error}';
	@override String get deletePlanConfirm => 'શું તમે યોજના કાઢી નાંખવા માંગો છો?';
	@override String get thisPlanPermanentlyDeleted => 'આ યોજના કાયમ માટે કાઢી નાંખવામાં આવશે.';
	@override String get planDeleted => 'યોજનાને કાઢી નાંખવામાં આવી';
	@override String failedToDeletePlan({required Object error}) => 'યોજનાને કાઢી નાંખવામાં નિષ્ફળ: ${error}';
	@override String get sharePlan => 'યોજનાને શેર કરો';
	@override String get deletePlan => 'યોજનાને કાઢી નાંખો';
	@override String get savedPlanDetails => 'સાચવેલી યોજનાની વિગતો';
	@override String get pilgrimagePlan => 'તિર્થયાત્રા યોજના';
	@override String get planTab => 'યોજના';
}

// Path: settings
class _TranslationsSettingsGu extends TranslationsSettingsEn {
	_TranslationsSettingsGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'સેટિંગ્સ';
	@override String get language => 'ભાષા';
	@override String get theme => 'થીમ';
	@override String get themeLight => 'લાઈટ';
	@override String get themeDark => 'ડાર્ક';
	@override String get themeSystem => 'સિસ્ટમ થીમનો ઉપયોગ કરો';
	@override String get darkMode => 'ડાર્ક મોડ';
	@override String get selectLanguage => 'ભાષા પસંદ કરો';
	@override String get notifications => 'સૂચનાઓ';
	@override String get cacheSettings => 'કૅશ અને સ્ટોરેજ';
	@override String get general => 'સામાન્ય';
	@override String get account => 'ખાતું';
	@override String get blockedUsers => 'બ્લોક કરેલા વપરાશકર્તાઓ';
	@override String get helpSupport => 'મદદ અને સપોર્ટ';
	@override String get contactUs => 'અમારો સંપર્ક કરો';
	@override String get legal => 'કાનૂની';
	@override String get privacyPolicy => 'ગોપનીયતા નીતિ';
	@override String get termsConditions => 'શરતો અને નિયમો';
	@override String get privacy => 'ગોપનીયતા';
	@override String get about => 'ઍપ વિશે';
	@override String get version => 'આવૃત્તિ';
	@override String get logout => 'લૉગ આઉટ';
	@override String get deleteAccount => 'ખાતું કાઢી નાંખો';
	@override String get deleteAccountTitle => 'ખાતું કાઢી નાંખો';
	@override String get deleteAccountWarning => 'આ ક્રિયાને પાછી લઈ શકાતી નથી!';
	@override String get deleteAccountDescription => 'તમારું ખાતું કાઢી નાંખવાથી તમારી બધી પોસ્ટ્સ, ટિપ્પણીઓ, પ્રોફાઇલ, ફોલોઅર્સ, સાચવેલી વાર્તાઓ, બુકમાર્ક્સ, ચેટ સંદેશાઓ અને બનાવેલી વાર્તાઓ કાયમ માટે દૂર થઈ જશે.';
	@override String get confirmPassword => 'તમારો પાસવર્ડ ખાતરી કરો';
	@override String get confirmPasswordDesc => 'ખાતું કાઢી નાંખવાની ખાતરી કરવા માટે તમારો પાસવર્ડ દાખલ કરો.';
	@override String get googleReauth => 'તમારી ઓળખ ચકાસવા માટે તમને Google પર રીડાયરેક્ટ કરવામાં આવશે.';
	@override String get finalConfirmationTitle => 'અંતિમ પુષ્ટિ';
	@override String get finalConfirmation => 'શું તમને સંપૂર્ણ ખાતરી છે? આ કાયમી છે અને તેને પાછું કરી શકાતું નથી.';
	@override String get deleteMyAccount => 'મારું ખાતું કાઢી નાંખો';
	@override String get deletingAccount => 'ખાતું કાઢી નાંખવામાં આવી રહ્યું છે...';
	@override String get accountDeleted => 'તમારું ખાતું કાયમ માટે કાઢી નાંખવામાં આવ્યું છે.';
	@override String get deleteAccountFailed => 'ખાતું કાઢી નાંખવામાં નિષ્ફળ. કૃપા કરીને ફરી પ્રયત્ન કરો.';
	@override String get downloadedStories => 'ડાઉનલોડ કરેલી વાર્તાઓ';
	@override String get couldNotOpenEmail => 'ઈમેલ ઍપ ખોલી શકાયું નથી. કૃપા કરીને અમને myitihas@gmail.com પર ઈમેલ કરો.';
	@override String couldNotOpenLabel({required Object label}) => 'હાલમાં ${label} ખોલી શકાયું નથી.';
	@override String get logoutTitle => 'લૉગ આઉટ';
	@override String get logoutConfirm => 'શું તમે ખરેખર લૉગ આઉટ કરવા માંગો છો?';
	@override String get verifyYourIdentity => 'તમારી ઓળખ ચકાસો';
	@override String get verifyYourIdentityDesc => 'તમારી ઓળખ ચકાસવા માટે તમને Google દ્વારા સાઇન ઇન કરવા માટે કહેવામાં આવશે.';
	@override String get continueWithGoogle => 'Google સાથે આગળ વધો';
	@override String reauthFailed({required Object error}) => 'રી-ઑથેન્ટીકેશન નિષ્ફળ: ${error}';
	@override String get passwordRequired => 'પાસવર્ડ જરૂરી છે';
	@override String get invalidPassword => 'અમાન્ય પાસવર્ડ. કૃપા કરીને ફરી પ્રયત્ન કરો.';
	@override String get verify => 'ચકાસો';
	@override String get continueLabel => 'આગળ વધો';
	@override String get unableToVerifyIdentity => 'ઓળખ ચકાસવામાં નિષ્ફળ. કૃપા કરીને ફરી પ્રયત્ન કરો.';
}

// Path: auth
class _TranslationsAuthGu extends TranslationsAuthEn {
	_TranslationsAuthGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get login => 'લૉગઇન';
	@override String get signup => 'સાઇન અપ';
	@override String get email => 'ઈમેલ';
	@override String get password => 'પાસવર્ડ';
	@override String get confirmPassword => 'પાસવર્ડની પુષ્ટિ કરો';
	@override String get forgotPassword => 'પાસવર્ડ ભૂલી ગયા?';
	@override String get resetPassword => 'પાસવર્ડ રીસેટ કરો';
	@override String get dontHaveAccount => 'ખાતું નથી?';
	@override String get alreadyHaveAccount => 'પહેલેથી જ ખાતું છે?';
	@override String get loginSuccess => 'લૉગઇન સફળ';
	@override String get signupSuccess => 'સાઇન અપ સફળ';
	@override String get loginError => 'લૉગઇન નિષ્ફળ';
	@override String get signupError => 'સાઇન અપ નિષ્ફળ';
}

// Path: error
class _TranslationsErrorGu extends TranslationsErrorEn {
	_TranslationsErrorGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get network => 'ઇન્ટરનેટ કનેક્શન નથી';
	@override String get server => 'સર્વર ભૂલ થઈ';
	@override String get cache => 'કૅશ ડેટા લોડ કરવામાં નિષ્ફળ';
	@override String get timeout => 'વિનંતીનો સમય સમાપ્ત';
	@override String get notFound => 'સંસાધન મળ્યું નથી';
	@override String get validation => 'ચકાસણી નિષ્ફળ';
	@override String get unexpected => 'અણધારી ભૂલ થઈ';
	@override String get tryAgain => 'કૃપા કરીને ફરી પ્રયત્ન કરો';
	@override String couldNotOpenLink({required Object url}) => 'લિંક ખોલી શકાયું નથી: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionGu extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get free => 'મફત';
	@override String get plus => 'પ્લસ';
	@override String get pro => 'પ્રો';
	@override String get upgradeToPro => 'પ્રો પર અપગ્રેડ કરો';
	@override String get features => 'ફીચર્સ';
	@override String get subscribe => 'સબ્સ્ક્રાઇબ કરો';
	@override String get currentPlan => 'વર્તમાન યોજના';
	@override String get managePlan => 'યોજનાનું સંચાલન કરો';
}

// Path: notification
class _TranslationsNotificationGu extends TranslationsNotificationEn {
	_TranslationsNotificationGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'સૂચનાઓ';
	@override String get peopleToConnect => 'જેઓ સાથે જોડાવું છે તે લોકો';
	@override String get peopleToConnectSubtitle => 'ફોલો કરવા માટે લોકો શોધો';
	@override String followAgainInMinutes({required Object minutes}) => 'તમે ${minutes} મિનિટમાં ફરી ફોલો કરી શકો છો';
	@override String get noSuggestions => 'હાલમાં કોઈ સૂચનો નથી';
	@override String get markAllRead => 'બધું વાંચેલ તરીકે ચિહ્નિત કરો';
	@override String get noNotifications => 'હજુ સુધી કોઈ સૂચનાઓ નથી';
	@override String get noNotificationsSubtitle => 'કોઈ તમારા વાર્તાઓ સાથે ઇન્ટરેક્ટ કરે ત્યારે, તમે તેને અહીં જુઓ છો';
	@override String get errorPrefix => 'ભૂલ:';
	@override String get retry => 'ફરી પ્રયત્ન કરો';
	@override String likedYourStory({required Object actorName}) => '${actorName}ને તમારી વાર્તા ગમી';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName}એ તમારી વાર્તા પર ટિપ્પણી કરી';
	@override String repliedToYourComment({required Object actorName}) => '${actorName}એ તમારા ટિપ્પણીનો જવાબ આપ્યો';
	@override String startedFollowingYou({required Object actorName}) => '${actorName}એ તમને ફોલો કરવા શરૂ કર્યું';
	@override String sentYouAMessage({required Object actorName}) => '${actorName}એ તમને સંદેશ મોકલ્યો';
	@override String sharedYourStory({required Object actorName}) => '${actorName}એ તમારી વાર્તા શેર કરી';
	@override String repostedYourStory({required Object actorName}) => '${actorName}એ તમારી વાર્તા ફરી પોસ્ટ કરી';
	@override String mentionedYou({required Object actorName}) => '${actorName}એ તમારો ઉલ્લેખ કર્યો';
	@override String newPostFrom({required Object actorName}) => '${actorName}ની નવી પોસ્ટ';
	@override String get today => 'આજે';
	@override String get thisWeek => 'આ અઠવાડિયું';
	@override String get earlier => 'પહેલાં';
	@override String get delete => 'કાઢી નાંખો';
}

// Path: profile
class _TranslationsProfileGu extends TranslationsProfileEn {
	_TranslationsProfileGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get followers => 'ફોલોઅર્સ';
	@override String get following => 'ફોલોઇંગ';
	@override String get unfollow => 'ફોલો છોડો';
	@override String get follow => 'ફોલો કરો';
	@override String get about => 'વિશે';
	@override String get stories => 'વાર્તાઓ';
	@override String get unableToShareImage => 'ઇમેજ શેર કરી શકાઈ નથી';
	@override String get imageSavedToPhotos => 'ઇમેજ ફોટામાં સાચવાઈ ગઈ';
	@override String get view => 'જોવું';
	@override String get saveToPhotos => 'ફોટામાં સાચવો';
	@override String get failedToLoadImage => 'ઇમેજ લોડ કરવામાં નિષ્ફળ';
}

// Path: feed
class _TranslationsFeedGu extends TranslationsFeedEn {
	_TranslationsFeedGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get loading => 'વાર્તાઓ લોડ થઈ રહી છે...';
	@override String get loadingPosts => 'પોસ્ટ્સ લોડ થઈ રહી છે...';
	@override String get loadingVideos => 'વિડિઓ લોડ થઈ રહી છે...';
	@override String get loadingStories => 'વાર્તાઓ લોડ થઈ રહી છે...';
	@override String get errorTitle => 'અરે! કૈંક ખોટું થયું';
	@override String get tryAgain => 'ફરી પ્રયત્ન કરો';
	@override String get noStoriesAvailable => 'કોઈ વાર્તાઓ ઉપલબ્ધ નથી';
	@override String get noImagesAvailable => 'કોઈ ઇમેજ પોસ્ટ્સ ઉપલબ્ધ નથી';
	@override String get noTextPostsAvailable => 'કોઈ ટેક્સ્ટ પોસ્ટ્સ ઉપલબ્ધ નથી';
	@override String get noContentAvailable => 'કોઈ કન્ટેન્ટ ઉપલબ્ધ નથી';
	@override String get refresh => 'રિફ્રેશ કરો';
	@override String get comments => 'ટિપ્પણીઓ';
	@override String get commentsComingSoon => 'ટિપ્પણીઓ જલ્દી જ આવી રહી છે';
	@override String get addCommentHint => 'ટિપ્પણી ઉમેરો...';
	@override String get shareStory => 'વાર્તા શેર કરો';
	@override String get sharePost => 'પોસ્ટ શેર કરો';
	@override String get shareThought => 'વિચાર શેર કરો';
	@override String get shareAsImage => 'ઇમેજ તરીકે શેર કરો';
	@override String get shareAsImageSubtitle => 'સુંદર પૂર્વાવલોકન કાર્ડ બનાવો';
	@override String get shareLink => 'લિંક શેર કરો';
	@override String get shareLinkSubtitle => 'વાર્તાનો લિંક કૉપિ કરો અથવા શેર કરો';
	@override String get shareImageLinkSubtitle => 'પોસ્ટનો લિંક કૉપિ કરો અથવા શેર કરો';
	@override String get shareTextLinkSubtitle => 'વિચારનો લિંક કૉપિ કરો અથવા શેર કરો';
	@override String get shareAsText => 'ટેક્સ્ટ તરીકે શેર કરો';
	@override String get shareAsTextSubtitle => 'વાર્તાનો એક ભાગ શેર કરો';
	@override String get shareQuote => 'ઉક્તિ શેર કરો';
	@override String get shareQuoteSubtitle => 'ઉક્તિ રૂપે શેર કરો';
	@override String get shareWithImage => 'ઇમેજ સાથે શેર કરો';
	@override String get shareWithImageSubtitle => 'ઇમેજ અને કેપ્શન સાથે શેર કરો';
	@override String get copyLink => 'લિંક કૉપિ કરો';
	@override String get copyLinkSubtitle => 'લિંક ક્લિપબોર્ડ પર કૉપિ કરો';
	@override String get copyText => 'ટેક્સ્ટ કૉપિ કરો';
	@override String get copyTextSubtitle => 'ઉક્તિ ક્લિપબોર્ડ પર કૉપિ કરો';
	@override String get linkCopied => 'લિંક ક્લિપબોર્ડ પર કૉપિ થઈ ગઈ';
	@override String get textCopied => 'ટેક્સ્ટ ક્લિપબોર્ડ પર કૉપિ થઈ ગયો';
	@override String get sendToUser => 'વપરાશકર્તાને મોકલો';
	@override String get sendToUserSubtitle => 'મિત્રને સીધું શેર કરો';
	@override String get chooseFormat => 'ફોર્મેટ પસંદ કરો';
	@override String get linkPreview => 'લિંક પૂર્વાવલોકન';
	@override String get linkPreviewSize => '૧૨૦૦ × ૬૩૦';
	@override String get storyFormat => 'સ્ટોરી ફોર્મેટ';
	@override String get storyFormatSize => '૧૦૮૦ × ૧૯૨૦ (Instagram/Stories)';
	@override String get generatingPreview => 'પૂર્વાવલોકન તૈયાર થઈ રહ્યું છે...';
	@override String get bookmarked => 'બુકમાર્ક કર્યું';
	@override String get removedFromBookmarks => 'બુકમાર્કમાંથી કાઢી નાખ્યું';
	@override String unlike({required Object count}) => 'અનલાઈક, ${count} પસંદગીઓ';
	@override String like({required Object count}) => 'લાઈક, ${count} પસંદગીઓ';
	@override String commentCount({required Object count}) => '${count} ટિપ્પણીઓ';
	@override String shareCount({required Object count}) => 'શેર કરો, ${count} વખત શેર થયું';
	@override String get removeBookmark => 'બુકમાર્ક કાઢી નાંખો';
	@override String get addBookmark => 'બુકમાર્ક કરો';
	@override String get quote => 'ઉક્તિ';
	@override String get quoteCopied => 'ઉક્તિ ક્લિપબોર્ડ પર કૉપિ થઈ ગઈ';
	@override String get copy => 'કૉપિ કરો';
	@override String get tapToViewFullQuote => 'સંપૂર્ણ ઉક્તિ જોવા માટે ટૅપ કરો';
	@override String get quoteFromMyitihas => 'MyItihasમાંથી ઉક્તિ';
	@override late final _TranslationsFeedTabsGu tabs = _TranslationsFeedTabsGu._(_root);
	@override String get tapToShowCaption => 'કૅપ્શન જોવા માટે ટૅપ કરો';
	@override String get noVideosAvailable => 'કોઈ વિડિઓ ઉપલબ્ધ નથી';
	@override String get selectUser => 'કઈ વ્યક્તિને મોકલશો';
	@override String get searchUsers => 'વપરાશકર્તાઓ શોધો...';
	@override String get noFollowingYet => 'તમે હજુ સુધી કોઈને ફોલો કરતા નથી';
	@override String get noUsersFound => 'કોઈ વપરાશકર્તાઓ મળ્યા નથી';
	@override String get tryDifferentSearch => 'અલગ શોધ શબ્દ અજમાવો';
	@override String sentTo({required Object username}) => '${username} ને મોકલવામાં આવ્યું';
}

// Path: voice
class _TranslationsVoiceGu extends TranslationsVoiceEn {
	_TranslationsVoiceGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'માઇક્રોફોન પરવાનગી જરૂરી છે';
	@override String get speechRecognitionNotAvailable => 'સ્પીચ રેકગ્નિશન ઉપલબ્ધ નથી';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsGu extends TranslationsFestivalsEn {
	_TranslationsFestivalsGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get title => 'તહેવારની વાર્તાઓ';
	@override String get tellStory => 'વાર્તા કહો';
}

// Path: social
class _TranslationsSocialGu extends TranslationsSocialEn {
	_TranslationsSocialGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialCreatePostGu createPost = _TranslationsSocialCreatePostGu._(_root);
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroGu extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'અન્વેષણ કરવા ટૅપ કરો';
	@override late final _TranslationsHomeScreenHeroStoryGu story = _TranslationsHomeScreenHeroStoryGu._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionGu companion = _TranslationsHomeScreenHeroCompanionGu._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageGu heritage = _TranslationsHomeScreenHeroHeritageGu._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityGu community = _TranslationsHomeScreenHeroCommunityGu._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesGu messages = _TranslationsHomeScreenHeroMessagesGu._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthGu extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get short => 'ટૂંકી';
	@override String get medium => 'મધ્યમ';
	@override String get long => 'લાંબી';
	@override String get epic => 'વિસ્તૃત';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatGu extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'વર્ણનાત્મક';
	@override String get dialogue => 'સંવાદ આધારિત';
	@override String get poetic => 'કાવ્યાત્મક';
	@override String get scriptural => 'શાસ્ત્રીય';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsGu extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'કૃષ્ણ અર્જુનને શીખવે છે તેવી વાર્તા કહો...';
	@override String get warriorRedemption => 'પ્રાયશ્ચિત્ત શોધતા યોદ્ધાની એક મહાકાવ્ય વાર્તા લખો...';
	@override String get sageWisdom => 'ઋષિઓના જ્ઞાન વિશે એક વાર્તા બનાવો...';
	@override String get devotedSeeker => 'એક ભક્તિભાવથી ભરેલા સાધકની યાત્રાનું વર્ણન કરો...';
	@override String get divineIntervention => 'દૈવી હસ્તક્ષેપ વિશેની દંતકથા શેર કરો...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsGu extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'કૃપા કરીને તમામ જરૂરી વિકલ્પો પૂરા કરો';
	@override String get generationFailed => 'વાર્તા બનાવવામાં નિષ્ફળ. કૃપા કરીને ફરી પ્રયાસ કરો.';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsGu extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  નમસ્તે!';
	@override String get dharma => '📖  ધર્મ શું છે?';
	@override String get stress => '🧘  તાણ કેવી રીતે હેન્ડલ કરવું';
	@override String get karma => '⚡  કર્મ સરળ રીતે સમજાવો';
	@override String get story => '💬  મને એક વાર્તા કહો';
	@override String get wisdom => '🌟  આજનું જ્ઞાન';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsGu extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

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
class _TranslationsMapDiscussionsGu extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'ચર્ચા પોસ્ટ કરો';
	@override String get intentCardCta => 'એક ચર્ચા પોસ્ટ કરો';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapGu extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapGu extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapGu extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

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
class _TranslationsMapFoodMapGu extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

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
class _TranslationsFeedTabsGu extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get all => 'બધી';
	@override String get stories => 'વાર્તાઓ';
	@override String get posts => 'પોસ્ટ્સ';
	@override String get videos => 'વિડિઓ';
	@override String get images => 'ફોટા';
	@override String get text => 'વિચાર';
}

// Path: social.createPost
class _TranslationsSocialCreatePostGu extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String trimVideoSubtitle({required Object max}) => 'મહત્તમ ${max}સે · તમારો શ્રેષ્ઠ ભાગ પસંદ કરો';
	@override String get trimVideoInstructionsTitle => 'તમારી ક્લિપ ટ્રિમ કરો';
	@override String get trimVideoInstructionsBody => 'શરૂ અને અંત હેન્ડલ ખેંચી 30 સેકન્ડ સુધીનો ભાગ પસંદ કરો.';
	@override String get trimStart => 'શરૂઆત';
	@override String get trimEnd => 'અંત';
	@override String get trimSelectionEmpty => 'આગળ વધવા માટે માન્ય રેન્જ પસંદ કરો';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}સે પસંદ કર્યું (${start}–${end}) · મહત્તમ ${max}સે';
	@override String get coverFrame => 'કવર ફ્રેમ';
	@override String get coverFrameUnavailable => 'પૂર્વદર્શન ઉપલબ્ધ નથી';
	@override String coverFramePosition({required Object time}) => '${time} પર કવર';
	@override String get overlayLabel => 'વિડિયો પર લખાણ (વૈકલ્પિક)';
	@override String get overlayHint => 'નાનું હુક અથવા શીર્ષક ઉમેરો';
	@override String get videoEditorCaptionLabel => 'કૅપ્શન / લખાણ (વૈકલ્પિક)';
	@override String get videoEditorCaptionHint => 'દા.ત. તમારી રીલ માટે શીર્ષક અથવા હૂક';
	@override String get videoEditorAspectLabel => 'અનુપાત';
	@override String get videoEditorAspectOriginal => 'મૂળ';
	@override String get videoEditorAspectSquare => '૧:૧';
	@override String get videoEditorAspectPortrait => '૯:૧૬';
	@override String get videoEditorAspectLandscape => '૧૬:૯';
	@override String get videoEditorQuickTrim => 'ઝડપી ટ્રિમ';
	@override String get videoEditorSpeed => 'ગતિ';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryGu extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'એઆઈ વાર્તા સર્જન';
	@override String get headline => 'રોચક\nવાર્તાઓ\nબનાવો';
	@override String get subHeadline => 'પ્રાચીન જ્ઞાનથી સંચાલિત';
	@override String get line1 => '✦  પવિત્ર શાસ્ત્ર પસંદ કરો...';
	@override String get line2 => '✦  જીવંત પરિસ્થિતિ પસંદ કરો...';
	@override String get line3 => '✦  એઆઈને મોહક વાર્તા ગૂંથવા દો...';
	@override String get cta => 'વાર્તા બનાવો';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionGu extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'આધ્યાત્મિક સાથી';
	@override String get headline => 'તમારો દિવ્ય\nમાર્ગદર્શક,\nહંમેશા નજીક';
	@override String get subHeadline => 'કૃષ્ણના જ્ઞાનથી પ્રેરિત';
	@override String get line1 => '✦  એક મિત્ર જે સાચે સાંભળે...';
	@override String get line2 => '✦  જીવનના સંઘર્ષ માટે જ્ઞાન...';
	@override String get line3 => '✦  તમને ઊંચું ઉઠાવતી વાતચીત...';
	@override String get cta => 'ચેટ શરૂ કરો';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageGu extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'વારસા નકશો';
	@override String get headline => 'શાશ્વત\nવારસો\nશોધો';
	@override String get subHeadline => '5000+ પવિત્ર સ્થળો નકશામાં';
	@override String get line1 => '✦  પવિત્ર સ્થળો શોધો...';
	@override String get line2 => '✦  ઈતિહાસ અને લોકગાથા વાંચો...';
	@override String get line3 => '✦  અર્થપૂર્ણ યાત્રાની યોજના બનાવો...';
	@override String get cta => 'નકશો શોધો';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityGu extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'સમુદાય સ્થળ';
	@override String get headline => 'સંસ્કૃતિને\nવિશ્વ સાથે\nશેર કરો';
	@override String get subHeadline => 'જીવંત વૈશ્વિક સમુદાય';
	@override String get line1 => '✦  પોસ્ટ્સ અને ઊંડી ચર્ચાઓ...';
	@override String get line2 => '✦  ટૂંકા સાંસ્કૃતિક વીડિયો...';
	@override String get line3 => '✦  વિશ્વભરની વાર્તાઓ...';
	@override String get cta => 'સમુદાયમાં જોડાઓ';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesGu extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesGu._(TranslationsGu root) : this._root = root, super.internal(root);

	final TranslationsGu _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ખાનગી સંદેશાઓ';
	@override String get headline => 'અર્થસભર\nવાતચીત\nઅહીંથી શરૂ થાય';
	@override String get subHeadline => 'ખાનગી અને વિચારશીલ જગ્યા';
	@override String get line1 => '✦  સમમનાના લોકો સાથે જોડાઓ...';
	@override String get line2 => '✦  વિચારો અને વાર્તાઓ પર ચર્ચા કરો...';
	@override String get line3 => '✦  વિચારશીલ સમુદાયો બનાવો...';
	@override String get cta => 'સંદેશાઓ ખોલો';
}
