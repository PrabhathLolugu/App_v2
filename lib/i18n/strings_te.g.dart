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
class TranslationsTe extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsTe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.te,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <te>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsTe _root = this; // ignore: unused_field

	@override 
	TranslationsTe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTe(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppTe app = _TranslationsAppTe._(_root);
	@override late final _TranslationsCommonTe common = _TranslationsCommonTe._(_root);
	@override late final _TranslationsNavigationTe navigation = _TranslationsNavigationTe._(_root);
	@override late final _TranslationsHomeTe home = _TranslationsHomeTe._(_root);
	@override late final _TranslationsHomeScreenTe homeScreen = _TranslationsHomeScreenTe._(_root);
	@override late final _TranslationsStoriesTe stories = _TranslationsStoriesTe._(_root);
	@override late final _TranslationsStoryGeneratorTe storyGenerator = _TranslationsStoryGeneratorTe._(_root);
	@override late final _TranslationsChatTe chat = _TranslationsChatTe._(_root);
	@override late final _TranslationsMapTe map = _TranslationsMapTe._(_root);
	@override late final _TranslationsCommunityTe community = _TranslationsCommunityTe._(_root);
	@override late final _TranslationsDiscoverTe discover = _TranslationsDiscoverTe._(_root);
	@override late final _TranslationsPlanTe plan = _TranslationsPlanTe._(_root);
	@override late final _TranslationsSettingsTe settings = _TranslationsSettingsTe._(_root);
	@override late final _TranslationsAuthTe auth = _TranslationsAuthTe._(_root);
	@override late final _TranslationsErrorTe error = _TranslationsErrorTe._(_root);
	@override late final _TranslationsSubscriptionTe subscription = _TranslationsSubscriptionTe._(_root);
	@override late final _TranslationsNotificationTe notification = _TranslationsNotificationTe._(_root);
	@override late final _TranslationsProfileTe profile = _TranslationsProfileTe._(_root);
	@override late final _TranslationsFeedTe feed = _TranslationsFeedTe._(_root);
	@override late final _TranslationsSocialTe social = _TranslationsSocialTe._(_root);
	@override late final _TranslationsVoiceTe voice = _TranslationsVoiceTe._(_root);
	@override late final _TranslationsFestivalsTe festivals = _TranslationsFestivalsTe._(_root);
}

// Path: app
class _TranslationsAppTe extends TranslationsAppEn {
	_TranslationsAppTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'భారతీయ శాస్త్రాలను అన్వేషించండి';
}

// Path: common
class _TranslationsCommonTe extends TranslationsCommonEn {
	_TranslationsCommonTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get ok => 'సరే';
	@override String get cancel => 'రద్దు';
	@override String get confirm => 'నిర్ధారించు';
	@override String get delete => 'తొలగించు';
	@override String get edit => 'సవరించు';
	@override String get save => 'సేవ్ చేయి';
	@override String get share => 'పంచుకో';
	@override String get search => 'శోధించు';
	@override String get loading => 'లోడ్ అవుతోంది...';
	@override String get error => 'లోపం';
	@override String get retry => 'మళ్లీ ప్రయత్నించు';
	@override String get back => 'వెనక్కి';
	@override String get next => 'తదుపరి';
	@override String get finish => 'ముగించు';
	@override String get skip => 'దాటవేయి';
	@override String get yes => 'అవును';
	@override String get no => 'కాదు';
	@override String get readFullStory => 'పూర్తి కథను చదవండి';
	@override String get dismiss => 'మూసివేయి';
	@override String get offlineBannerMessage => 'మీరు ఆఫ్‌లైన్‌లో ఉన్నారు – సేవ్ చేసిన కంటెంట్‌ని చూస్తున్నారు';
	@override String get backOnline => 'మళ్లీ ఆన్‌లైన్‌లో';
}

// Path: navigation
class _TranslationsNavigationTe extends TranslationsNavigationEn {
	_TranslationsNavigationTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get home => 'అన్వేషణ';
	@override String get stories => 'కథలు';
	@override String get chat => 'చాట్';
	@override String get map => 'మ్యాప్';
	@override String get community => 'సామాజిక';
	@override String get settings => 'సెట్టింగ్స్';
	@override String get profile => 'ప్రొఫైల్';
}

// Path: home
class _TranslationsHomeTe extends TranslationsHomeEn {
	_TranslationsHomeTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'కథ జనరేటర్';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'సమాజ కథలు';
	@override String get maps => 'మ్యాప్లు';
	@override String get greetingMorning => 'శుభోదయం';
	@override String get continueReading => 'చదవడం కొనసాగించు';
	@override String get greetingAfternoon => 'శుభ మద్యాహ్నం';
	@override String get greetingEvening => 'శుభ సాయంత్రం';
	@override String get greetingNight => 'శుభ రాత్రి';
	@override String get exploreStories => 'కథలను అన్వేషించండి';
	@override String get generateStory => 'కథను రూపొందించు';
	@override String get content => 'హోమ్ కంటెంట్';
}

// Path: homeScreen
class _TranslationsHomeScreenTe extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'నమస్తే';
	@override String get quoteOfTheDay => 'ఈరోజు సూక్తి';
	@override String get shareQuote => 'సూక్తిని పంచుకోండి';
	@override String get copyQuote => 'సూక్తిని కాపీ చేయి';
	@override String get quoteCopied => 'సూక్తి క్లిప్‌బోర్డుకు కాపీ చేయబడింది';
	@override String get featuredStories => 'ఫీచర్ కథలు';
	@override String get quickActions => 'త్వరిత చర్యలు';
	@override String get generateStory => 'కథను రూపొందించు';
	@override String get chatWithKrishna => 'కృష్ణుడితో మాట్లాడండి';
	@override String get myActivity => 'నా చర్యలు';
	@override String get continueReading => 'చదవడం కొనసాగించు';
	@override String get savedStories => 'సేవ్ చేసిన కథలు';
	@override String get exploreMyitihas => 'మైఇతిహాస్‌ను అన్వేషించండి';
	@override String get storiesInYourLanguage => 'మీ భాషలో కథలు';
	@override String get seeAll => 'అన్నీ చూడండి';
	@override String get startReading => 'చదవడం మొదలు పెట్టు';
	@override String get exploreStories => 'మీ ప్రయాణాన్ని ప్రారంభించుటకు కథలను అన్వేషించండి';
	@override String get saveForLater => 'మీకు నచ్చిన కథలను బుక్‌మార్క్ చేయండి';
	@override String get noActivityYet => 'ఇప్పటి వరకు చర్యలు లేవు';
	@override String minLeft({required Object count}) => '${count} నిమిషాలు మిగిలి ఉన్నాయి';
	@override String get activityHistory => 'చర్యల చరిత్ర';
	@override String get storyGenerated => 'ఒక కథ రూపొందించబడింది';
	@override String get storyRead => 'ఒక కథ చదవబడింది';
	@override String get storyBookmarked => 'కథ బుక్‌మార్క్ చేయబడింది';
	@override String get storyShared => 'కథ పంచుకోబడింది';
	@override String get storyCompleted => 'కథ పూర్తి చేయబడింది';
	@override String get today => 'ఈ రోజు';
	@override String get yesterday => 'నిన్న';
	@override String get thisWeek => 'ఈ వారం';
	@override String get earlier => 'ఇంతకుముందు';
	@override String get noContinueReading => 'ఇంకా చదవడానికి ఏమీ లేదు';
	@override String get noSavedStories => 'ఇంకా సేవ్ చేసిన కథలు లేవు';
	@override String get bookmarkStoriesToSave => 'కథలను సేవ్ చేయడానికి బుక్‌మార్క్ చేయండి';
	@override String get myGeneratedStories => 'నా కథలు';
	@override String get noGeneratedStoriesYet => 'ఇంకా కథలు రూపొందించబడలేదు';
	@override String get createYourFirstStory => 'AI సహాయంతో మీ మొదటి కథను రూపొందించండి';
	@override String get shareToFeed => 'ఫీడ్‌లో పంచుకోండి';
	@override String get sharedToFeed => 'కథ ఫీడ్‌లో పంచుకోబడింది';
	@override String get shareStoryTitle => 'కథను పంచుకోండి';
	@override String get shareStoryMessage => 'మీ కథకు శీర్షిక/క్యాప్షన్ జోడించండి (ఐచ్ఛికం)';
	@override String get shareStoryCaption => 'క్యాప్షన్';
	@override String get shareStoryHint => 'ఈ కథ గురించి మీరు ఏమి చెప్పాలనుకుంటున్నారు?';
	@override String get exploreHeritageTitle => 'పారంపర్యాన్ని అన్వేషించండి';
	@override String get exploreHeritageDesc => 'మ్యాప్‌పై సాంస్కృతిక వారసత్వ స్థలాలను కనుగొనండి';
	@override String get whereToVisit => 'తదుపరి సందర్శనం';
	@override String get scriptures => 'శాస్త్రాలు';
	@override String get exploreSacredSites => 'పవిత్ర స్థలాలను అన్వేషించండి';
	@override String get readStories => 'కథలను చదవండి';
	@override String get yesRemindMe => 'అవును, నాకు గుర్తు చేయండి';
	@override String get noDontShowAgain => 'కాదు, మళ్లీ చూపించకండి';
	@override String get discoverDismissTitle => 'Discover MyItihas ను దాచాలా?';
	@override String get discoverDismissMessage => 'తదుపరి సారి యాప్ ఓపెన్ చేసినప్పుడు లేదా లాగిన్ అయినప్పుడు దీన్ని మళ్లీ చూడాలనుకుంటున్నారా?';
	@override String get discoverCardTitle => 'MyItihas ను కనుగొనండి';
	@override String get discoverCardSubtitle => 'ప్రాచీన శాస్త్రాల నుండి కథలు, అన్వేషించడానికి పవిత్ర స్థలాలు, మీ వేళ్ల వద్ద జ్ఞానం.';
	@override String get swipeToDismiss => 'మూసివేయడానికి పైకి స్వైప్ చేయండి';
	@override String get searchScriptures => 'శాస్త్రాలను శోధించండి...';
	@override String get searchLanguages => 'భాషలను శోధించండి...';
	@override String get exploreStoriesLabel => 'కథలను అన్వేషించండి';
	@override String get exploreMore => 'ఇంకా అన్వేషించండి';
	@override String get failedToLoadActivity => 'చర్యలను లోడ్ చేయడం విఫలమైంది';
	@override String get startReadingOrGenerating => 'ఇక్కడ మీ చర్యలను చూడటానికి కథలను చదవడం లేదా రూపొందించడం ప్రారంభించండి';
	@override late final _TranslationsHomeScreenHeroTe hero = _TranslationsHomeScreenHeroTe._(_root);
}

// Path: stories
class _TranslationsStoriesTe extends TranslationsStoriesEn {
	_TranslationsStoriesTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'కథలు';
	@override String get searchHint => 'శీర్షిక లేదా రచయిత ద్వారా శోధించండి...';
	@override String get sortBy => 'క్రమపరచు';
	@override String get sortNewest => 'కొత్తవి ముందుగా';
	@override String get sortOldest => 'పాతవి ముందుగా';
	@override String get sortPopular => 'అత్యంత ప్రజాదరణ పొందినవి';
	@override String get noStories => 'ఏ కథలు కనబడలేదు';
	@override String get loadingStories => 'కథలు లోడ్ అవుతున్నాయి...';
	@override String get errorLoadingStories => 'కథలను లోడ్ చేయడంలో విఫలమైంది';
	@override String get storyDetails => 'కథ వివరాలు';
	@override String get continueReading => 'చదవడం కొనసాగించు';
	@override String get readMore => 'మరింత చదవండి';
	@override String get readLess => 'తక్కువ చూపించు';
	@override String get author => 'రచయిత';
	@override String get publishedOn => 'ప్రచురించిన తేదీ';
	@override String get category => 'వర్గం';
	@override String get tags => 'ట్యాగ్‌లు';
	@override String get failedToLoad => 'కథను లోడ్ చేయడం విఫలమైంది';
	@override String get subtitle => 'శాస్త్రాల్లోని కథలను కనుగొనండి';
	@override String get noStoriesHint => 'కథలను కనుగొనడానికి వేరే శోధన లేదా ఫిల్టర్ ప్రయత్నించండి.';
	@override String get featured => 'ప్రత్యేకం';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorTe extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'కథ జనరేటర్';
	@override String get subtitle => 'మీ స్వంత శాస్త్రకథను రూపొందించండి';
	@override String get quickStart => 'త్వరిత ఆరంభం';
	@override String get interactive => 'ఇంటరాక్టివ్';
	@override String get rawPrompt => 'మూల ప్రాంప్ట్';
	@override String get yourStoryPrompt => 'మీ కథ ప్రాంప్ట్';
	@override String get writeYourPrompt => 'మీ ప్రాంప్ట్‌ను రాయండి';
	@override String get selectScripture => 'శాస్త్రాన్ని ఎంచుకోండి';
	@override String get selectStoryType => 'కథ రకాన్ని ఎంచుకోండి';
	@override String get selectCharacter => 'పాత్రను ఎంచుకోండి';
	@override String get selectTheme => 'విషయాన్ని ఎంచుకోండి';
	@override String get selectSetting => 'సన్నివేశాన్ని ఎంచుకోండి';
	@override String get selectLanguage => 'భాషను ఎంచుకోండి';
	@override String get selectLength => 'కథ పొడవు';
	@override String get moreOptions => 'మరిన్ని ఎంపికలు';
	@override String get random => 'యాదృచ్ఛికం';
	@override String get generate => 'కథను రూపొందించు';
	@override String get generating => 'మీ కథ రూపొందించబడుతోంది...';
	@override String get creatingYourStory => 'మీ కథ రూపొందించబడుతోంది';
	@override String get consultingScriptures => 'ప్రాచీన శాస్త్రాలను పరిశీలిస్తోంది...';
	@override String get weavingTale => 'మీ కథను నేయుతోంది...';
	@override String get addingWisdom => 'దివ్య జ్ఞానాన్ని జోడిస్తోంది...';
	@override String get polishingNarrative => 'కథనాన్ని మెరుగుపరుస్తోంది...';
	@override String get almostThere => 'దాదాపు పూర్తైంది...';
	@override String get generatedStory => 'మీ రూపొందించిన కథ';
	@override String get aiGenerated => 'AI రూపొందించింది';
	@override String get regenerate => 'మళ్లీ రూపొందించు';
	@override String get saveStory => 'కథను సేవ్ చేయి';
	@override String get shareStory => 'కథను పంచుకో';
	@override String get newStory => 'కొత్త కథ';
	@override String get saved => 'సేవ్ చేయబడింది';
	@override String get storySaved => 'కథ మీ లైబ్రరీలో సేవ్ చేయబడింది';
	@override String get story => 'కథ';
	@override String get lesson => 'పాఠం';
	@override String get didYouKnow => 'మీకు తెలుసా?';
	@override String get activity => 'చర్య';
	@override String get optionalRefine => 'ఐచ్ఛికం: ఎంపికలతో మెరుగుపరచండి';
	@override String get applyOptions => 'ఎంపికలను వర్తింపజేయి';
	@override String get language => 'భాష';
	@override String get storyFormat => 'కథ ఆకృతి';
	@override String get requiresInternet => 'కథ రూపొందించడానికి ఇంటర్నెట్ కనెక్షన్ అవసరం';
	@override String get notAvailableOffline => 'కథ ఆఫ్‌లైన్‌లో అందుబాటులో లేదు. చూడటానికి ఇంటర్నెట్‌కు కనెక్ట్ చేయండి.';
	@override String get aiDisclaimer => 'AI తప్పులు చేయవచ్చు. మేము మెరుగుపరుస్తున్నాము; మీ అభిప్రాయం మాకు ముఖ్యమైనది.';
	@override late final _TranslationsStoryGeneratorStoryLengthTe storyLength = _TranslationsStoryGeneratorStoryLengthTe._(_root);
	@override late final _TranslationsStoryGeneratorFormatTe format = _TranslationsStoryGeneratorFormatTe._(_root);
	@override late final _TranslationsStoryGeneratorHintsTe hints = _TranslationsStoryGeneratorHintsTe._(_root);
	@override late final _TranslationsStoryGeneratorErrorsTe errors = _TranslationsStoryGeneratorErrorsTe._(_root);
}

// Path: chat
class _TranslationsChatTe extends TranslationsChatEn {
	_TranslationsChatTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'శాస్త్రాల గురించి AI తో చాట్ చేయండి';
	@override String get friendMode => 'స్నేహిత మోడ్';
	@override String get philosophicalMode => 'తత్వశాస్త్ర మోడ్';
	@override String get typeMessage => 'మీ సందేశాన్ని టైప్ చేయండి...';
	@override String get send => 'పంపు';
	@override String get newChat => 'కొత్త చాట్';
	@override String get chatsTab => 'చాట్';
	@override String get groupsTab => 'గ్రూపులు';
	@override String get chatHistory => 'చాట్ చరిత్ర';
	@override String get clearChat => 'చాట్‌ను క్లియర్ చేయి';
	@override String get noMessages => 'ఇంకా సందేశాలు లేవు. ఒక సంభాషణను ప్రారంభించండి!';
	@override String get listPage => 'చాట్ జాబితా పేజీ';
	@override String get forwardMessageTo => 'సందేశాన్ని ఇక్కడికి పంపండి...';
	@override String get forwardMessage => 'సందేశాన్ని ఫార్వర్డ్ చేయి';
	@override String get messageForwarded => 'సందేశం ఫార్వర్డ్ చేయబడింది';
	@override String failedToForward({required Object error}) => 'సందేశాన్ని ఫార్వర్డ్ చేయడం విఫలమైంది: ${error}';
	@override String get searchChats => 'చాట్‌లను శోధించండి';
	@override String get noChatsFound => 'చాట్‌లు ఏవీ కనబడలేదు';
	@override String get requests => 'అభ్యర్థనలు';
	@override String get messageRequests => 'సందేశ అభ్యర్థనలు';
	@override String get groupRequests => 'గ్రూప్ అభ్యర్థనలు';
	@override String get requestSent => 'అభ్యర్థన పంపబడింది. వారు "Requests" లో చూస్తారు.';
	@override String get wantsToChat => 'చాట్ చేయాలనుకుంటున్నారు';
	@override String addedYouTo({required Object name}) => '${name} మిమ్మల్ని జోడించారు';
	@override String get accept => 'అంగీకరించు';
	@override String get noMessageRequests => 'సందేశ అభ్యర్థనలు లేవు';
	@override String get noGroupRequests => 'గ్రూప్ అభ్యర్థనలు లేవు';
	@override String get invitesSent => 'ఆహ్వానాలు పంపబడ్డాయి. వారు "Requests" లో చూస్తారు.';
	@override String get cantMessageUser => 'ఈ వినియోగదారునికి మీరు సందేశం పంపలేరు';
	@override String get deleteChat => 'చాట్ తొలగించు';
	@override String get deleteChats => 'చాట్‌లను తొలగించు';
	@override String get blockUser => 'వినియోగదారుని బ్లాక్ చేయి';
	@override String get reportUser => 'వినియోగదారుని నివేదించు';
	@override String get markAsRead => 'చదివినట్లుగా గుర్తించు';
	@override String get markedAsRead => 'చదివినట్లుగా గుర్తించబడింది';
	@override String get deleteClearChat => 'చాట్ తొలగించు / క్లియర్ చేయి';
	@override String get deleteConversation => 'సంభాషణను తొలగించు';
	@override String get reasonRequired => 'కారణం (తప్పనిసరి)';
	@override String get submit => 'సమర్పించు';
	@override String get userReportedBlocked => 'వినియోగదారుని గురించి నివేదిక ఇవ్వబడింది. అతను బ్లాక్ చేయబడ్డాడు.';
	@override String reportFailed({required Object error}) => 'నివేదించడంలో విఫలమైంది: ${error}';
	@override String get newGroup => 'కొత్త గ్రూప్';
	@override String get messageSomeoneDirectly => 'ఎవరినైనా నేరుగా సందేశం పంపండి';
	@override String get createGroupConversation => 'గ్రూప్ సంభాషణను సృష్టించండి';
	@override String get noGroupsYet => 'ఇంకా గ్రూప్‌లు లేవు';
	@override String get noChatsYet => 'ఇంకా చాట్‌లు లేవు';
	@override String get tapToCreateGroup => 'గ్రూప్‌ని సృష్టించడానికి లేదా చేరడానికి + ను నొక్కండి';
	@override String get tapToStartConversation => 'కొత్త సంభాషణను ప్రారంభించడానికి + ను నొక్కండి';
	@override String get conversationDeleted => 'సంభాషణ తొలగించబడింది';
	@override String conversationsDeleted({required Object count}) => '${count} సంభాషణ(లు) తొలగించబడింది';
	@override String get searchConversations => 'సంభాషణలను శోధించండి...';
	@override String get connectToInternet => 'దయచేసి ఇంటర్నెట్‌కి కనెక్ట్ అయ్యి మళ్లీ ప్రయత్నించండి.';
	@override String get littleKrishnaName => 'చిన్న క్రిష్ణుడు';
	@override String get newConversation => 'కొత్త సంభాషణ';
	@override String get noConversationsYet => 'ఇంకా సంభాషణలు లేవు';
	@override String get confirmDeletion => 'తొలగింపును నిర్ధారించు';
	@override String deleteConversationConfirm({required Object title}) => '${title} సంభాషణను నిజంగా తొలగించాలనుకుంటున్నారా?';
	@override String get deleteFailed => 'సంభాషణను తొలగించడం విఫలమైంది';
	@override String get fullChatCopied => 'పూర్తి చాట్ క్లిప్‌బోర్డుకు కాపీ చేయబడింది!';
	@override String get connectionErrorFallback => 'ఇప్పుడు కనెక్ట్ అవ్వడంలో సమస్యలు ఉన్నాయి. దయచేసి కొద్దిసేపటి తర్వాత మళ్లీ ప్రయత్నించండి.';
	@override String krishnaWelcomeWithName({required Object name}) => 'హలో, ${name}. నేను మీ స్నేహితుడు క్రిష్ణుడు. మీరు ఈరోజు ఎలా ఉన్నారు?';
	@override String get krishnaWelcomeFriend => 'హలో, నా ప్రియమైన మిత్రమా. నేను మీ స్నేహితుడు క్రిష్ణుడు. మీరు ఈరోజు ఎలా ఉన్నారు?';
	@override String get copyYouLabel => 'మీరు';
	@override String get copyKrishnaLabel => 'క్రిష్ణుడు';
	@override late final _TranslationsChatSuggestionsTe suggestions = _TranslationsChatSuggestionsTe._(_root);
	@override String get about => 'గురించి';
	@override String get yourFriendlyCompanion => 'మీ స్నేహపూర్వక తోడుడు';
	@override String get mentalHealthSupport => 'మానసిక ఆరోగ్య సహాయం';
	@override String get mentalHealthSupportSubtitle => 'ఆలోచనలను పంచుకోవడానికి మరియు వినిపించినట్లు భావించడానికి సురక్షిత ప్రదేశం.';
	@override String get friendlyCompanion => 'స్నేహపూర్వక మిత్రుడు';
	@override String get friendlyCompanionSubtitle => 'ఎప్పుడూ మాట్లాడటానికి, ప్రోత్సహించడానికి, జ్ఞానం పంచుకోవడానికి సిద్ధంగా ఉంటాడు.';
	@override String get storiesAndWisdom => 'కథలు & జ్ఞానం';
	@override String get storiesAndWisdomSubtitle => 'శాశ్వత కథలు మరియు ప్రాయోగిక పరిజ్ఞానం నుండి నేర్చుకోండి.';
	@override String get askAnything => 'ఏదైనా అడగండి';
	@override String get askAnythingSubtitle => 'మీ ప్రశ్నలకు మృదువైన, ఆలోచనాత్మక సమాధానాలు పొందండి.';
	@override String get startChatting => 'చాట్ ప్రారంభించండి';
	@override String get maybeLater => 'తరువాత చూసుకుంటాను';
	@override late final _TranslationsChatComposerAttachmentsTe composerAttachments = _TranslationsChatComposerAttachmentsTe._(_root);
}

// Path: map
class _TranslationsMapTe extends TranslationsMapEn {
	_TranslationsMapTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'అఖండ భారతం';
	@override String get subtitle => 'చారిత్రక స్థలాలను అన్వేషించండి';
	@override String get searchLocation => 'స్థలాన్ని శోధించండి...';
	@override String get viewDetails => 'వివరాలను చూడండి';
	@override String get viewSites => 'స్థలాలు చూడండి';
	@override String get showRoute => 'మార్గాన్ని చూపించు';
	@override String get historicalInfo => 'చారిత్రక సమాచారం';
	@override String get nearbyPlaces => 'సమీపంలోని స్థలాలు';
	@override String get pickLocationOnMap => 'మ్యాప్‌పై స్థలాన్ని ఎంచుకోండి';
	@override String get sitesVisited => 'సందర్శించిన స్థలాలు';
	@override String get badgesEarned => 'పొందిన బ్యాడ్జ్‌లు';
	@override String get completionRate => 'పూర్తి శాతం';
	@override String get addToJourney => 'ప్రయాణంలో జోడించండి';
	@override String get addedToJourney => 'ప్రయాణంలో జోడించబడింది';
	@override String get getDirections => 'మార్గదర్శకాలను పొందండి';
	@override String get viewInMap => 'మ్యాప్‌లో చూడండి';
	@override String get directions => 'దారులు';
	@override String get photoGallery => 'ఫోటో గ్యాలరీ';
	@override String get viewAll => 'అన్నీ చూడండి';
	@override String get photoSavedToGallery => 'ఫోటో గ్యాలరీలో సేవ్ చేయబడింది';
	@override String get sacredSoundscape => 'పవిత్ర శబ్ద ప్రపంచం';
	@override String get allDiscussions => 'అన్ని చర్చలు';
	@override String get journeyTab => 'యాత్ర';
	@override String get discussionTab => 'చర్చ';
	@override String get myActivity => 'నా చర్యలు';
	@override String get anonymousPilgrim => 'అజ్ఞాత యాత్రికుడు';
	@override String get viewProfile => 'ప్రొఫైల్ చూడండి';
	@override String get discussionTitleHint => 'చర్చ శీర్షిక...';
	@override String get shareYourThoughtsHint => 'మీ ఆలోచనలను పంచుకోండి...';
	@override String get pleaseEnterDiscussionTitle => 'దయచేసి చర్చ శీర్షికను నమోదు చేయండి';
	@override String get addReflection => 'అనుభవాన్ని జోడించండి';
	@override String get reflectionTitle => 'శీర్షిక';
	@override String get enterReflectionTitle => 'అనుభవ శీರ್ಷికను నమోదు చేయండి';
	@override String get pleaseEnterTitle => 'దయచేసి శీర్షికను నమోదు చేయండి';
	@override String get siteName => 'స్థల పేరు';
	@override String get enterSacredSiteName => 'పవిత్ర స్థల పేరును నమోదు చేయండి';
	@override String get pleaseEnterSiteName => 'దయచేసి స్థల పేరును నమోదు చేయండి';
	@override String get reflection => 'అనుభవం';
	@override String get reflectionHint => 'మీ ఆలోచనలు, అనుభవాలను పంచుకోండి...';
	@override String get pleaseEnterReflection => 'దయచేసి మీ అనుభవాన్ని నమోదు చేయండి';
	@override String get saveReflection => 'అనుభవాన్ని సేవ్ చేయండి';
	@override String get journeyProgress => 'ప్రయాణ పురోగతి';
	@override late final _TranslationsMapDiscussionsTe discussions = _TranslationsMapDiscussionsTe._(_root);
	@override late final _TranslationsMapFabricMapTe fabricMap = _TranslationsMapFabricMapTe._(_root);
	@override late final _TranslationsMapClassicalArtMapTe classicalArtMap = _TranslationsMapClassicalArtMapTe._(_root);
	@override late final _TranslationsMapClassicalDanceMapTe classicalDanceMap = _TranslationsMapClassicalDanceMapTe._(_root);
	@override late final _TranslationsMapFoodMapTe foodMap = _TranslationsMapFoodMapTe._(_root);
}

// Path: community
class _TranslationsCommunityTe extends TranslationsCommunityEn {
	_TranslationsCommunityTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'సమాజం';
	@override String get trending => 'ట్రెండింగ్';
	@override String get following => 'ఫాలో అవుతున్నవారు';
	@override String get followers => 'ఫాలోవర్స్';
	@override String get posts => 'పోస్టులు';
	@override String get follow => 'ఫాలో చేయి';
	@override String get unfollow => 'ఫాలో నిలిపివేయి';
	@override String get shareYourStory => 'మీ కథను పంచుకోండి...';
	@override String get post => 'పోస్ట్ చేయి';
	@override String get like => 'నచ్చింది';
	@override String get comment => 'కామెంట్';
	@override String get comments => 'కామెంట్‌లు';
	@override String get noPostsYet => 'ఇంకా పోస్టులు లేవు';
}

// Path: discover
class _TranslationsDiscoverTe extends TranslationsDiscoverEn {
	_TranslationsDiscoverTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'కనుగొను';
	@override String get searchHint => 'కథలు, వినియోగదారులు లేదా అంశాలను శోధించండి...';
	@override String get tryAgain => 'మళ్లీ ప్రయత్నించు';
	@override String get somethingWentWrong => 'ఏదో పొరపాటు జరిగింది';
	@override String get unableToLoadProfiles => 'ప్రొఫైల్‌లను లోడ్ చేయడంలో విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';
	@override String get noProfilesFound => 'ప్రొఫైల్‌లు ఏవీ కనబడలేదు';
	@override String get searchToFindPeople => 'ఫాలో చేయడానికి వ్యక్తులను శోధించండి';
	@override String get noResultsFound => 'ఫలితాలు ఏవీ కనబడలేదు';
	@override String get noProfilesYet => 'ఇంకా ప్రొఫైల్‌లు లేవు';
	@override String get tryDifferentKeywords => 'వేరే శోధన పదాలతో ప్రయత్నించండి';
	@override String get beFirstToDiscover => 'కొత్త వారిని ముందుగా కనుగొనేది మీరు అవ్వండి!';
}

// Path: plan
class _TranslationsPlanTe extends TranslationsPlanEn {
	_TranslationsPlanTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'మీ ప్రణాళికను సేవ్ చేయడానికి సైన్ ఇన్ చేయండి';
	@override String get planSaved => 'ప్రణాళిక సేవ్ చేయబడింది';
	@override String get from => 'ఎక్కడి నుండి';
	@override String get dates => 'తేదీలు';
	@override String get destination => 'గమ్యం';
	@override String get nearby => 'సమీపంలో';
	@override String get generatedPlan => 'రూపొందించిన ప్రణాళిక';
	@override String get whereTravellingFrom => 'మీరు ఎక్కడి నుండి ప్రయాణిస్తున్నారు?';
	@override String get enterCityOrRegion => 'మీ నగరం లేదా ప్రాంతాన్ని నమోదు చేయండి';
	@override String get travelDates => 'ప్రయాణ తేదీలు';
	@override String get destinationSacredSite => 'గమ్యం (పవిత్ర స్థలం)';
	@override String get searchOrSelectDestination => 'గమ్యాన్ని శోధించండి లేదా ఎంచుకోండి...';
	@override String get shareYourExperience => 'మీ అనుభవాన్ని పంచుకోండి';
	@override String get planShared => 'ప్రణాళిక పంచుకోబడింది';
	@override String failedToSharePlan({required Object error}) => 'ప్రణాళికను పంచుకోవడంలో విఫలమైంది: ${error}';
	@override String get planUpdated => 'ప్రణాళిక నవీకరించబడింది';
	@override String failedToUpdatePlan({required Object error}) => 'ప్రణాళికను నవీకరించడం విఫలమైంది: ${error}';
	@override String get deletePlanConfirm => 'ప్రణాళికను తొలగించాలా?';
	@override String get thisPlanPermanentlyDeleted => 'ఈ ప్రణాళిక శాశ్వతంగా తొలగించబడుతుంది.';
	@override String get planDeleted => 'ప్రణాళిక తొలగించబడింది';
	@override String failedToDeletePlan({required Object error}) => 'ప్రణాళికను తొలగించడం విఫలమైంది: ${error}';
	@override String get sharePlan => 'ప్రణాళికను పంచుకోండి';
	@override String get deletePlan => 'ప్రణాళికను తొలగించండి';
	@override String get savedPlanDetails => 'సేవ్ చేసిన ప్రణాళిక వివరాలు';
	@override String get quickBookings => 'త్వరిత బుకింగ్స్';
	@override String get replanWithAi => 'AIతో మళ్లీ ప్లాన్ చేయి';
	@override String get fullRegenerate => 'పూర్తిగా కొత్తగా రూపొందించు';
	@override String get surgicalModify => 'ఎంచుకున్న భాగాలను మార్చు';
	@override String get travelModeTrain => 'రైలు';
	@override String get travelModeFlight => 'ఫ్లైట్';
	@override String get travelModeBus => 'బస్';
	@override String get travelModeHotel => 'హోటల్';
	@override String get travelModeCar => 'కారు';
	@override String get pilgrimagePlan => 'యాత్ర ప్రణాళిక';
	@override String get planTab => 'యోజన';
}

// Path: settings
class _TranslationsSettingsTe extends TranslationsSettingsEn {
	_TranslationsSettingsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'సెట్టింగ్స్';
	@override String get language => 'భాష';
	@override String get theme => 'థీమ్';
	@override String get themeLight => 'లైట్';
	@override String get themeDark => 'డార్క్';
	@override String get themeSystem => 'సిస్టమ్ థీమ్‌ను ఉపయోగించండి';
	@override String get darkMode => 'డార్క్ మోడ్';
	@override String get selectLanguage => 'భాషను ఎంచుకోండి';
	@override String get notifications => 'నోటిఫికేషన్లు';
	@override String get cacheSettings => 'క్యాష్ & స్టోరేజ్';
	@override String get general => 'సాధారణ';
	@override String get account => 'ఖాతా';
	@override String get blockedUsers => 'బ్లాక్ చేయబడిన వినియోగదారులు';
	@override String get helpSupport => 'సహాయం & మద్దతు';
	@override String get contactUs => 'మమ్మల్ని సంప్రదించండి';
	@override String get legal => 'చట్టపరమైనవి';
	@override String get privacyPolicy => 'గోప్యతా విధానం';
	@override String get termsConditions => 'నిబంధనలు & షరతులు';
	@override String get privacy => 'గోప్యత';
	@override String get about => 'యాప్ గురించి';
	@override String get version => 'వెర్షన్';
	@override String get logout => 'లాగ్ అవుట్';
	@override String get deleteAccount => 'ఖాతాను తొలగించండి';
	@override String get deleteAccountTitle => 'ఖాతాను తొలగించండి';
	@override String get deleteAccountWarning => 'ఈ చర్యను తిరిగి చేయలేరు!';
	@override String get deleteAccountDescription => 'మీ ఖాతాను తొలగించడం వలన మీ అన్ని పోస్టులు, కామెంట్లు, ప్రొఫైల్, ఫాలోవర్లు, సేవ్ చేసిన కథలు, బుక్‌మార్క్‌లు, చాట్ సందేశాలు మరియు రూపొందించిన కథలు శాశ్వతంగా తొలగించబడతాయి.';
	@override String get confirmPassword => 'మీ పాస్‌వర్డ్‌ను నిర్ధారించండి';
	@override String get confirmPasswordDesc => 'ఖాతా తొలగింపును నిర్ధారించడానికి మీ పాస్‌వర్డ్‌ను నమోదు చేయండి.';
	@override String get googleReauth => 'మీ గుర్తింపును ధృవీకరించడానికి మిమ్మల్ని Google కి తిప్పి పంపిస్తాం.';
	@override String get finalConfirmationTitle => 'చివరి నిర్ధారణ';
	@override String get finalConfirmation => 'మీకు పూర్తిగా నమ్మకమా? ఇది శాశ్వతం మరియు తిరిగి మార్చడం సాధ్యం కాదు.';
	@override String get deleteMyAccount => 'నా ఖాతాను తొలగించు';
	@override String get deletingAccount => 'ఖాతాను తొలగిస్తోంది...';
	@override String get accountDeleted => 'మీ ఖాతా శాశ్వతంగా తొలగించబడింది.';
	@override String get deleteAccountFailed => 'ఖాతాను తొలగించడం విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';
	@override String get downloadedStories => 'డౌన్‌లోడ్ చేసిన కథలు';
	@override String get couldNotOpenEmail => 'ఈమెయిల్ యాప్‌ను తెరవలేకపోయాం. దయచేసి మాకు myitihas@gmail.com కు ఈమెయిల్ పంపండి';
	@override String couldNotOpenLabel({required Object label}) => 'ప్రస్తుతం ${label} ను తెరవలేకపోతున్నాం.';
	@override String get logoutTitle => 'లాగ్ అవుట్';
	@override String get logoutConfirm => 'మీరు నిజంగా లాగ్ అవుట్ కావాలనుకుంటున్నారా?';
	@override String get verifyYourIdentity => 'మీ గుర్తింపును నిర్ధారించండి';
	@override String get verifyYourIdentityDesc => 'మీ గుర్తింపును నిర్ధారించడానికి మిమ్మల్ని Google ద్వారా సైన్ ఇన్ చేయమని అడుగుతాం.';
	@override String get continueWithGoogle => 'Google తో కొనసాగించు';
	@override String reauthFailed({required Object error}) => 'మళ్లీ ధృవీకరణ విఫలమైంది: ${error}';
	@override String get passwordRequired => 'పాస్‌వర్డ్ అవసరం';
	@override String get invalidPassword => 'చెల్లని పాస్‌వర్డ్. దయచేసి మళ్లీ ప్రయత్నించండి.';
	@override String get verify => 'నిర్ధారించు';
	@override String get continueLabel => 'కొనసాగించు';
	@override String get unableToVerifyIdentity => 'గుర్తింపును నిర్ధారించలేకపోయాం. దయచేసి మళ్లీ ప్రయత్నించండి.';
}

// Path: auth
class _TranslationsAuthTe extends TranslationsAuthEn {
	_TranslationsAuthTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get login => 'లాగిన్';
	@override String get signup => 'సైన్ అప్';
	@override String get email => 'ఈమెయిల్';
	@override String get password => 'పాస్‌వర్డ్';
	@override String get confirmPassword => 'పాస్‌వర్డ్‌ను నిర్ధారించండి';
	@override String get forgotPassword => 'పాస్‌వర్డ్ మర్చిపోయారా?';
	@override String get resetPassword => 'పాస్‌వర్డ్ రీసెట్ చేయి';
	@override String get dontHaveAccount => 'మీకు ఖాతా లేదా?';
	@override String get alreadyHaveAccount => 'మీకు ఇప్పటికే ఖాతా ఉందా?';
	@override String get loginSuccess => 'లాగిన్ విజయవంతం';
	@override String get signupSuccess => 'సైన్ అప్ విజయవంతం';
	@override String get loginError => 'లాగిన్ విఫలమైంది';
	@override String get signupError => 'సైన్ అప్ విఫలమైంది';
}

// Path: error
class _TranslationsErrorTe extends TranslationsErrorEn {
	_TranslationsErrorTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get network => 'ఇంటర్నెట్ కనెక్షన్ లేదు';
	@override String get server => 'సర్వర్ లోపం జరిగింది';
	@override String get cache => 'సేవ్ చేసిన డేటాను లోడ్ చేయడంలో విఫలమైంది';
	@override String get timeout => 'వినతి సమయం ముగిసింది';
	@override String get notFound => 'వనరు కనబడలేదు';
	@override String get validation => 'ధృవీకరణ విఫలమైంది';
	@override String get unexpected => 'అనుకోని లోపం ఏర్పడింది';
	@override String get tryAgain => 'దయచేసి మళ్లీ ప్రయత్నించండి';
	@override String couldNotOpenLink({required Object url}) => 'లింక్‌ని తెరవలేకపోయాం: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionTe extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get free => 'ఉచితం';
	@override String get plus => 'ప్లస్';
	@override String get pro => 'ప్రో';
	@override String get upgradeToPro => 'ప్రో కి అప్‌గ్రేడ్ చేయండి';
	@override String get features => 'లక్షణాలు';
	@override String get subscribe => 'సబ్‌స్క్రైబ్ చేయి';
	@override String get currentPlan => 'ప్రస్తుత ప్రణాళిక';
	@override String get managePlan => 'ప్రణాళికను నిర్వహించండి';
}

// Path: notification
class _TranslationsNotificationTe extends TranslationsNotificationEn {
	_TranslationsNotificationTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'నోటిఫికేషన్లు';
	@override String get peopleToConnect => 'సంబంధాలు పెంచుకోవాల్సిన వ్యక్తులు';
	@override String get peopleToConnectSubtitle => 'ఫాలో చేయడానికి వ్యక్తులను కనుగొనండి';
	@override String followAgainInMinutes({required Object minutes}) => '${minutes} నిమిషాల తర్వాత మళ్లీ ఫాలో చేయవచ్చు';
	@override String get noSuggestions => 'ప్రస్తుతం సూచనలు లేవు';
	@override String get markAllRead => 'అన్నీ చదివినట్లుగా గుర్తించు';
	@override String get noNotifications => 'ఇప్పటివరకు నోటిఫికేషన్లు లేవు';
	@override String get noNotificationsSubtitle => 'ఎవరైనా మీ కథలతో ఇన్‌టరాక్ట్ చేస్తే, మీరు ఇక్కడ చూస్తారు';
	@override String get errorPrefix => 'లోపం:';
	@override String get retry => 'మళ్లీ ప్రయత్నించు';
	@override String likedYourStory({required Object actorName}) => '${actorName} మీ కథను నచ్చిందని చెప్పారు';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} మీ కథపై కామెంట్ చేశారు';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} మీ కామెంట్‌కి ప్రత్యుత్తరం ఇచ్చారు';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} మిమ్మల్ని ఫాలో చేయడం ప్రారంభించారు';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} మీకు సందేశం పంపారు';
	@override String sharedYourStory({required Object actorName}) => '${actorName} మీ కథను పంచుకున్నారు';
	@override String repostedYourStory({required Object actorName}) => '${actorName} మీ కథను మళ్లీ పోస్ట్ చేశారు';
	@override String mentionedYou({required Object actorName}) => '${actorName} మిమ్మల్ని ప్రస్తావించారు';
	@override String newPostFrom({required Object actorName}) => '${actorName} నుండి కొత్త పోస్ట్';
	@override String get today => 'ఈ రోజు';
	@override String get thisWeek => 'ఈ వారం';
	@override String get earlier => 'ఇంతకుముందు';
	@override String get delete => 'తొలగించు';
}

// Path: profile
class _TranslationsProfileTe extends TranslationsProfileEn {
	_TranslationsProfileTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get followers => 'ఫాలోవర్స్';
	@override String get following => 'ఫాలో అవుతున్నవారు';
	@override String get unfollow => 'ఫాలో నిలిపివేయి';
	@override String get follow => 'ఫాలో చేయి';
	@override String get about => 'గురించి';
	@override String get stories => 'కథలు';
	@override String get unableToShareImage => 'చిత్రాన్ని పంచుకోలేకపోయాం';
	@override String get imageSavedToPhotos => 'చిత్రం ఫోటోలలో సేవ్ చేయబడింది';
	@override String get view => 'చూడండి';
	@override String get saveToPhotos => 'ఫోటోలలో సేవ్ చేయి';
	@override String get failedToLoadImage => 'చిత్రాన్ని లోడ్ చేయడంలో విఫలమైంది';
}

// Path: feed
class _TranslationsFeedTe extends TranslationsFeedEn {
	_TranslationsFeedTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get loading => 'కథలు లోడ్ అవుతున్నాయి...';
	@override String get loadingPosts => 'పోస్టులు లోడ్ అవుతున్నాయి...';
	@override String get loadingVideos => 'వీడియోలు లోడ్ అవుతున్నాయి...';
	@override String get loadingStories => 'కథలు లోడ్ అవుతున్నాయి...';
	@override String get errorTitle => 'అయ్యో! ఏదో తప్పు జరిగింది';
	@override String get tryAgain => 'మళ్లీ ప్రయత్నించు';
	@override String get noStoriesAvailable => 'కథలు అందుబాటులో లేవు';
	@override String get noImagesAvailable => 'చిత్ర పోస్టులు అందుబాటులో లేవు';
	@override String get noTextPostsAvailable => 'వచన పోస్టులు అందుబాటులో లేవు';
	@override String get noContentAvailable => 'కంటెంట్ అందుబాటులో లేదు';
	@override String get refresh => 'రిఫ్రెష్ చేయి';
	@override String get comments => 'కామెంట్‌లు';
	@override String get commentsComingSoon => 'కామెంట్‌లు త్వరలో వస్తున్నాయి';
	@override String get addCommentHint => 'కామెంట్ జోడించండి...';
	@override String get shareStory => 'కథను పంచుకోండి';
	@override String get sharePost => 'పోస్ట్‌ను పంచుకోండి';
	@override String get shareThought => 'ఆలోచనను పంచుకోండి';
	@override String get shareAsImage => 'చిత్రంగా పంచుకోండి';
	@override String get shareAsImageSubtitle => 'అందమైన ప్రివ్యూ కార్డ్‌ని సృష్టించండి';
	@override String get shareLink => 'లింక్‌ని పంచుకోండి';
	@override String get shareLinkSubtitle => 'కథ లింక్‌ను కాపీ చేయండి లేదా పంచుకోండి';
	@override String get shareImageLinkSubtitle => 'పోస్ట్ లింక్‌ను కాపీ చేయండి లేదా పంచుకోండి';
	@override String get shareTextLinkSubtitle => 'ఆలోచన లింక్‌ను కాపీ చేయండి లేదా పంచుకోండి';
	@override String get shareAsText => 'పాఠ్యంగా పంచుకోండి';
	@override String get shareAsTextSubtitle => 'కథ యొక్క భాగాన్ని పంచుకోండి';
	@override String get shareQuote => 'సూక్తిని పంచుకోండి';
	@override String get shareQuoteSubtitle => 'సూక్తిని పాఠ్య రూపంలో పంచుకోండి';
	@override String get shareWithImage => 'చిత్రంతో పంచుకోండి';
	@override String get shareWithImageSubtitle => 'చిత్రాన్ని క్యాప్షన్‌తో కలిసి పంచుకోండి';
	@override String get copyLink => 'లింక్‌ను కాపీ చేయి';
	@override String get copyLinkSubtitle => 'లింక్‌ను క్లిప్‌బోర్డుకు కాపీ చేయి';
	@override String get copyText => 'పాఠ్యాన్ని కాపీ చేయి';
	@override String get copyTextSubtitle => 'సూక్తిని క్లిప్‌బోర్డుకు కాపీ చేయి';
	@override String get linkCopied => 'లింక్ క్లిప్‌బోర్డుకు కాపీ చేయబడింది';
	@override String get textCopied => 'పాఠ్యం క్లిప్‌బోర్డుకు కాపీ చేయబడింది';
	@override String get sendToUser => 'వినియోగదారునికి పంపు';
	@override String get sendToUserSubtitle => 'మిత్రునితో నేరుగా పంచుకోండి';
	@override String get chooseFormat => 'ఫార్మాట్‌ను ఎంచుకోండి';
	@override String get linkPreview => 'లింక్ ప్రివ్యూ';
	@override String get linkPreviewSize => '1200 × 630';
	@override String get storyFormat => 'స్టోరీ ఫార్మాట్';
	@override String get storyFormatSize => '1080 × 1920 (Instagram/Stories)';
	@override String get generatingPreview => 'ప్రివ్యూ రూపొందించబడుతోంది...';
	@override String get bookmarked => 'బుక్‌మార్క్ చేయబడింది';
	@override String get removedFromBookmarks => 'బుక్‌మార్క్‌ల నుండి తీసివేయబడింది';
	@override String unlike({required Object count}) => 'లైక్ తీసివేయి, ${count} లైక్‌లు';
	@override String like({required Object count}) => 'లైక్, ${count} లైక్‌లు';
	@override String commentCount({required Object count}) => '${count} కామెంట్‌లు';
	@override String shareCount({required Object count}) => 'పంచుకో, ${count} షేర్‌లు';
	@override String get removeBookmark => 'బుక్‌మార్క్‌ను తొలగించండి';
	@override String get addBookmark => 'బుక్‌మార్క్ చేయండి';
	@override String get quote => 'సూక్తి';
	@override String get quoteCopied => 'సూక్తి క్లిప్‌బోర్డుకు కాపీ చేయబడింది';
	@override String get copy => 'కాపీ చేయి';
	@override String get tapToViewFullQuote => 'పూర్తి సూక్తిని చూడటానికి తాకండి';
	@override String get quoteFromMyitihas => 'MyItihas నుండి సూక్తి';
	@override late final _TranslationsFeedTabsTe tabs = _TranslationsFeedTabsTe._(_root);
	@override String get tapToShowCaption => 'క్యాప్షన్‌ను చూడటానికి తాకండి';
	@override String get noVideosAvailable => 'వీడియోలు అందుబాటులో లేవు';
	@override String get selectUser => 'వెళ్లాల్సినవి';
	@override String get searchUsers => 'వినియోగదారులను శోధించండి...';
	@override String get noFollowingYet => 'మీరు ఇంకా ఎవరినీ ఫాలో చేయడం లేదు';
	@override String get noUsersFound => 'వినియోగదారులు ఎవరూ కనబడలేదు';
	@override String get tryDifferentSearch => 'వేరే శోధన పదంతో ప్రయత్నించండి';
	@override String sentTo({required Object username}) => '${username} కు పంపబడింది';
}

// Path: social
class _TranslationsSocialTe extends TranslationsSocialEn {
	_TranslationsSocialTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileTe editProfile = _TranslationsSocialEditProfileTe._(_root);
	@override late final _TranslationsSocialCreatePostTe createPost = _TranslationsSocialCreatePostTe._(_root);
	@override late final _TranslationsSocialCommentsTe comments = _TranslationsSocialCommentsTe._(_root);
	@override late final _TranslationsSocialEngagementTe engagement = _TranslationsSocialEngagementTe._(_root);
	@override String get editCaption => 'క్యాప్షన్ సవరించు';
	@override String get reportPost => 'పోస్ట్‌ను నివేదించు';
	@override String get reportReasonHint => 'ఈ పోస్ట్‌లో ఏమి తప్పు ఉందో మాకు చెప్పండి';
	@override String get deletePost => 'పోస్ట్‌ను తొలగించు';
	@override String get deletePostConfirm => 'ఈ చర్యను తిరిగి చేయలేరు.';
	@override String get postDeleted => 'పోస్ట్ తొలగించబడింది';
	@override String failedToDeletePost({required Object error}) => 'పోస్ట్‌ను తొలగించడంలో విఫలమైంది: ${error}';
	@override String failedToReportPost({required Object error}) => 'పోస్ట్‌ను నివేదించడంలో విఫలమైంది: ${error}';
	@override String get reportSubmitted => 'నివేదిక సమర్పించబడింది. ధన్యవాదాలు.';
	@override String get acceptRequestFirst => 'ముందుగా Requests పేజీలో వారి అభ్యర్థనను అంగీకరించండి.';
	@override String get requestSentWait => 'అభ్యర్థన పంపబడింది. వారు అంగీకరిస్తే వేచి ఉండండి.';
	@override String get requestSentTheyWillSee => 'అభ్యర్థన పంపబడింది. వారు "Requests" లో చూస్తారు.';
	@override String failedToShare({required Object error}) => 'పంచుకోవడంలో విఫలమైంది: ${error}';
	@override String get updateCaptionHint => 'మీ పోస్ట్‌కు క్యాప్షన్‌ను నవీకరించండి';
}

// Path: voice
class _TranslationsVoiceTe extends TranslationsVoiceEn {
	_TranslationsVoiceTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'మైక్రోఫోన్ అనుమతి అవసరం';
	@override String get speechRecognitionNotAvailable => 'స్పీచ్ రికగ్నిషన్ అందుబాటులో లేదు';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsTe extends TranslationsFestivalsEn {
	_TranslationsFestivalsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'పండుగ కథలు';
	@override String get tellStory => 'కథ చెప్పండి';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroTe extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'అన్వేషించడానికి ట్యాప్ చేయండి';
	@override late final _TranslationsHomeScreenHeroStoryTe story = _TranslationsHomeScreenHeroStoryTe._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionTe companion = _TranslationsHomeScreenHeroCompanionTe._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageTe heritage = _TranslationsHomeScreenHeroHeritageTe._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityTe community = _TranslationsHomeScreenHeroCommunityTe._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesTe messages = _TranslationsHomeScreenHeroMessagesTe._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthTe extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get short => 'చిన్నది';
	@override String get medium => 'మధ్యస్థం';
	@override String get long => 'పొడవైనది';
	@override String get epic => 'విపులమైనది';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatTe extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'కథన రూపం';
	@override String get dialogue => 'సంభాషణ ఆధారిత';
	@override String get poetic => 'కావ్యరూపం';
	@override String get scriptural => 'శాస్త్ర రూపం';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsTe extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'కృష్ణుడు అర్జునునికి బోధిస్తున్న కథను చెప్పండి...';
	@override String get warriorRedemption => 'పరిహారం కోసం ప్రయత్నిస్తున్న యోధుని గురించి ఒక మహాకావ్య కథను రాయండి...';
	@override String get sageWisdom => 'ఋషుల జ్ఞానం గురించి కథను రూపొందించండి...';
	@override String get devotedSeeker => 'ఒక భక్తుడి సాధన ప్రస్థానాన్ని వివరించండి...';
	@override String get divineIntervention => 'దివ్య జోక్యం గురించి పురాణకథను పంచుకోండి...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsTe extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'దయచేసి అవసరమైన అన్ని ఎంపికలను పూర్తి చేయండి';
	@override String get generationFailed => 'కథను రూపొందించడం విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsTe extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  హలో!';
	@override String get dharma => '📖  ధర్మం అంటే ఏమిటి?';
	@override String get stress => '🧘  ఒత్తిడిని ఎలా ఎదుర్కోవాలి';
	@override String get karma => '⚡  కర్మను సులభంగా వివరించండి';
	@override String get story => '💬  నాకు ఒక కథ చెప్పండి';
	@override String get wisdom => '🌟  ఈరోజు జ్ఞానం';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsTe extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get poll => 'పోల్';
	@override String get camera => 'కెమెరా';
	@override String get photos => 'ఫోటోలు';
	@override String get location => 'స్థానం';
	@override String get pollTitle => 'పోల్ సృష్టించండి';
	@override String get pollQuestionHint => 'ఒక ప్రశ్న అడగండి';
	@override String pollOptionHint({required Object n}) => 'ఎంపిక ${n}';
	@override String get addOption => 'ఎంపిక జోడించండి';
	@override String get removeOption => 'తొలగించు';
	@override String get sendPoll => 'పోల్ పంపండి';
	@override String get pollNeedTwoOptions => 'కనీసం 2 ఎంపికలు (గరిష్ఠం 4).';
	@override String get pollMaxOptions => '4 వరకు ఎంపికలు జోడించవచ్చు.';
	@override String get sharedLocationTitle => 'భాగస్వామ్య స్థానం';
	@override String get sendLocation => 'స్థానం పంపండి';
	@override String get locationPreviewTitle => 'మీ ప్రస్తుత స్థానం పంపాలా?';
	@override String get locationFetching => 'స్థానం పొందుతోంది…';
	@override String get openInMaps => 'మ్యాప్‌లో తెరవండి';
	@override String voteCount({required Object count}) => '${count} ఓట్లు';
	@override String get voteCountOne => '1 ఓటు';
	@override String get tapToVote => 'ఓటు వేయడానికి ఎంపికను తట్టండి';
	@override String get mapsUnavailable => 'మ్యాప్‌ను తెరవలేకపోయాము.';
}

// Path: map.discussions
class _TranslationsMapDiscussionsTe extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'చర్చను పోస్ట్ చేయండి';
	@override String get intentCardCta => 'ఒక చర్చను పోస్ట్ చేయండి';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapTe extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapTe extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapTe extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

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
class _TranslationsMapFoodMapTe extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

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
class _TranslationsFeedTabsTe extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get all => 'అన్నీ';
	@override String get stories => 'కథలు';
	@override String get posts => 'పోస్టులు';
	@override String get videos => 'వీడియోలు';
	@override String get images => 'చిత్రాలు';
	@override String get text => 'ఆలోచనలు';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileTe extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'ప్రొఫైల్‌ను సవరించు';
	@override String get displayName => 'ప్రదర్శన పేరు';
	@override String get displayNameHint => 'మీ ప్రదర్శన పేరును నమోదు చేయండి';
	@override String get displayNameEmpty => 'ప్రదర్శన పేరు ఖాళీగా ఉండకూడదు';
	@override String get bio => 'బయో';
	@override String get bioHint => 'మీ గురించి మాకు చెప్పండి...';
	@override String get changePhoto => 'ప్రొఫైల్ ఫోటో మార్చు';
	@override String get saveChanges => 'మార్పులను సేవ్ చేయి';
	@override String get profileUpdated => 'ప్రొఫైల్ విజయవంతంగా నవీకరించబడింది';
	@override String get profileAndPhotoUpdated => 'ప్రొఫైల్ మరియు ఫోటో విజయవంతంగా నవీకరించబడ్డాయి';
	@override String failedPickImage({required Object error}) => 'చిత్రాన్ని ఎంచుకోవడం విఫలమైంది: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'ఫోటోను అప్‌లోడ్ చేయడం విఫలమైంది: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'ప్రొఫైల్‌ను నవీకరించడం విఫలమైంది: ${error}';
	@override String unexpectedError({required Object error}) => 'అనుకోని లోపం: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostTe extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get title => 'పోస్ట్ రూపొందించు';
	@override String get post => 'పోస్ట్ చేయి';
	@override String get text => 'పాఠ్యం';
	@override String get image => 'చిత్రం';
	@override String get video => 'వీడియో';
	@override String get textHint => 'మీ మనసులో ఏముంది?';
	@override String get imageCaptionHint => 'మీ ఫోటోకు క్యాప్షన్ రాయండి...';
	@override String get videoCaptionHint => 'మీ వీడియోను వివరించండి...';
	@override String get shareCaptionHint => 'మీ ఆలోచనలను జోడించండి...';
	@override String get titleHint => 'శీర్షికను జోడించండి (ఐచ్ఛికం)';
	@override String get selectVideo => 'వీడియోను ఎంచుకోండి';
	@override String get gallery => 'గ్యాలరీ';
	@override String get camera => 'కెమెరా';
	@override String get visibility => 'దీన్ని ఎవరు చూడగలరు?';
	@override String get public => 'పబ్లిక్';
	@override String get followers => 'ఫాలోవర్స్';
	@override String get private => 'ప్రైవేట్';
	@override String get postCreated => 'పోస్ట్ రూపొందించబడింది!';
	@override String get failedPickImages => 'చిత్రాలను ఎంచుకోవడం విఫలమైంది';
	@override String get failedPickVideo => 'వీడియోను ఎంచుకోవడం విఫలమైంది';
	@override String get failedCapturePhoto => 'ఫోటో తీయడం విఫలమైంది';
	@override String get cannotCreateOffline => 'ఆఫ్‌లైన్‌లో ఉండగా పోస్ట్ రూపొందించలేరు';
	@override String get discardTitle => 'పోస్ట్‌ను విస్మరించాలా?';
	@override String get discardMessage => 'మీ వద్ద సేవ్ చేయని మార్పులు ఉన్నాయి. మీరు ఈ పోస్ట్‌ను నిజంగా విస్మరించాలనుకుంటున్నారా?';
	@override String get keepEditing => 'సవరించడం కొనసాగించు';
	@override String get discard => 'విస్మరించు';
	@override String get cropPhoto => 'ఫోటోను కట్ చేయి';
	@override String get trimVideo => 'వీడియోను ట్రిమ్ చేయి';
	@override String get editPhoto => 'ఫోటోను సవరించు';
	@override String get editVideo => 'వీడియోను సవరించు';
	@override String get maxDuration => 'గరిష్టంగా 30 సెకన్లు';
	@override String get aspectSquare => 'చతురస్రము';
	@override String get aspectPortrait => 'నిలువు';
	@override String get aspectLandscape => 'అడ్డం';
	@override String get aspectFree => 'స్వేచ్ఛా ఆకృతి';
	@override String get failedCrop => 'ఫోటోను కట్ చేయడంలో విఫలమైంది';
	@override String get failedTrim => 'వీడియోను ట్రిమ్ చేయడంలో విఫలమైంది';
	@override String get trimmingVideo => 'వీడియో ట్రిమ్ అవుతోంది...';
	@override String trimVideoSubtitle({required Object max}) => 'గరిష్టం ${max}సె · మీ ఉత్తమ భాగాన్ని ఎంచుకోండి';
	@override String get trimVideoInstructionsTitle => 'మీ క్లిప్‌ను ట్రిమ్ చేయండి';
	@override String get trimVideoInstructionsBody => 'ప్రారంభం మరియు ముగింపు హ్యాండిల్స్‌ను లాగి 30 సెకన్ల వరకు భాగాన్ని ఎంచుకోండి.';
	@override String get trimStart => 'ప్రారంభం';
	@override String get trimEnd => 'ముగింపు';
	@override String get trimSelectionEmpty => 'కొనసాగించడానికి చెల్లుబాటు అయ్యే రేంజ్‌ను ఎంచుకోండి';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}సె ఎంపిక చేయబడింది (${start}–${end}) · గరిష్టం ${max}సె';
	@override String get coverFrame => 'కవర్ ఫ్రేమ్';
	@override String get coverFrameUnavailable => 'ప్రివ్యూ లేదు';
	@override String coverFramePosition({required Object time}) => '${time} వద్ద కవర్';
	@override String get overlayLabel => 'వీడియోపై టెక్స్ట్ (ఐచ్ఛికం)';
	@override String get overlayHint => 'చిన్న హుక్ లేదా శీర్షిక జోడించండి';
	@override String get imageSectionHint => 'గ్యాలరీ లేదా కెమెరా నుండి గరిష్టంగా 10 ఫోటోలను జోడించండి';
	@override String get videoSectionHint => 'ఒక వీడియో, గరిష్టంగా 30 సెకన్లు';
	@override String get removePhoto => 'ఫోటోను తొలగించు';
	@override String get removeVideo => 'వీడియోను తొలగించు';
	@override String get photoEditHint => 'కట్ చేయడానికి లేదా తొలగించడానికి ఫోటోపై తాకండి';
	@override String get videoEditOptions => 'సవరింపు ఎంపికలు';
	@override String get addPhoto => 'ఫోటోను జోడించు';
	@override String get done => 'పూర్తయ్యింది';
	@override String get rotate => 'తిరగద్రోపు';
	@override String get editPhotoSubtitle => 'ఫీడ్‌లో మంచి అమరిక కోసం చతురస్రంగా కట్ చేయండి';
	@override String get videoEditorCaptionLabel => 'క్యాప్షన్ / వచనం (ఐచ్ఛికం)';
	@override String get videoEditorCaptionHint => 'ఉదా: మీ రీల్‌కు శీర్షిక లేదా హుక్';
	@override String get videoEditorAspectLabel => 'అనుపాతం';
	@override String get videoEditorAspectOriginal => 'అసలు';
	@override String get videoEditorAspectSquare => '1:1';
	@override String get videoEditorAspectPortrait => '9:16';
	@override String get videoEditorAspectLandscape => '16:9';
	@override String get videoEditorQuickTrim => 'త్వరిత ట్రిమ్';
	@override String get videoEditorSpeed => 'వేగం';
}

// Path: social.comments
class _TranslationsSocialCommentsTe extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} కి సమాధానం ఇస్తున్నారు';
	@override String replyHint({required Object name}) => '${name} కి సమాధానం రాయండి...';
	@override String failedToPost({required Object error}) => 'పోస్ట్ చేయడంలో విఫలమైంది: ${error}';
	@override String get cannotPostOffline => 'ఆఫ్‌లైన్‌లో ఉండగా కామెంట్ చేయలేరు';
	@override String get noComments => 'ఇంకా కామెంట్‌లు లేవు';
	@override String get beFirst => 'మొదటి కామెంట్ మీరే చేయండి!';
}

// Path: social.engagement
class _TranslationsSocialEngagementTe extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'ఆఫ్‌లైన్ మోడ్';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryTe extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ఏఐ కథా సృష్టి';
	@override String get headline => 'ఆకట్టుకునే\nకథలను\nసృష్టించండి';
	@override String get subHeadline => 'ప్రాచీన జ్ఞాన శక్తితో';
	@override String get line1 => '✦  ఒక పవిత్ర శాస్త్రాన్ని ఎంచుకోండి...';
	@override String get line2 => '✦  జీవంతమైన నేపథ్యాన్ని ఎంచుకోండి...';
	@override String get line3 => '✦  ఏఐతో మంత్రముగ్ధం చేసే కథను నేయించండి...';
	@override String get cta => 'కథ సృష్టించండి';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionTe extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ఆధ్యాత్మిక సహచరి';
	@override String get headline => 'మీ దివ్య\nమార్గదర్శి,\nఎల్లప్పుడూ దగ్గరగా';
	@override String get subHeadline => 'కృష్ణుని జ్ఞానం నుండి ప్రేరణ';
	@override String get line1 => '✦  నిజంగా వింటున్న స్నేహితుడు...';
	@override String get line2 => '✦  జీవన పోరాటాలకు జ్ఞానం...';
	@override String get line3 => '✦  మిమ్మల్ని ఉత్తేజపరిచే సంభాషణలు...';
	@override String get cta => 'చాట్ ప్రారంభించండి';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageTe extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'వారసత్వ మ్యాప్';
	@override String get headline => 'శాశ్వత\nవారసత్వాన్ని\nకనుగొనండి';
	@override String get subHeadline => '5000+ పవిత్ర స్థలాలు మ్యాప్‌లో';
	@override String get line1 => '✦  పవిత్ర ప్రదేశాలను అన్వేషించండి...';
	@override String get line2 => '✦  చరిత్ర మరియు గాథలను చదవండి...';
	@override String get line3 => '✦  అర్థవంతమైన ప్రయాణాలు ప్లాన్ చేయండి...';
	@override String get cta => 'మ్యాప్ అన్వేషించండి';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityTe extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'సమాజ స్థలం';
	@override String get headline => 'సంస్కృతిని\nప్రపంచంతో\nపంచుకోండి';
	@override String get subHeadline => 'ఉత్సాహభరితమైన ప్రపంచ సమాజం';
	@override String get line1 => '✦  పోస్టులు మరియు లోతైన చర్చలు...';
	@override String get line2 => '✦  చిన్న సాంస్కృతిక వీడియోలు...';
	@override String get line3 => '✦  ప్రపంచం నలుమూలల కథలు...';
	@override String get cta => 'సమాజంలో చేరండి';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesTe extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesTe._(TranslationsTe root) : this._root = root, super.internal(root);

	final TranslationsTe _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'వ్యక్తిగత సందేశాలు';
	@override String get headline => 'అర్థవంతమైన\nసంభాషణలు\nఇక్కడ ప్రారంభమవుతాయి';
	@override String get subHeadline => 'వ్యక్తిగత మరియు ఆలోచనాత్మక స్థలాలు';
	@override String get line1 => '✦  సమాన మనస్కులతో కలవండి...';
	@override String get line2 => '✦  ఆలోచనలు మరియు కథలపై చర్చించండి...';
	@override String get line3 => '✦  ఆలోచనాత్మక సమూహాలను నిర్మించండి...';
	@override String get cta => 'సందేశాలు తెరవండి';
}
