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
class TranslationsMr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsMr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.mr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <mr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsMr _root = this; // ignore: unused_field

	@override 
	TranslationsMr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsMr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppMr app = _TranslationsAppMr._(_root);
	@override late final _TranslationsCommonMr common = _TranslationsCommonMr._(_root);
	@override late final _TranslationsNavigationMr navigation = _TranslationsNavigationMr._(_root);
	@override late final _TranslationsHomeMr home = _TranslationsHomeMr._(_root);
	@override late final _TranslationsHomeScreenMr homeScreen = _TranslationsHomeScreenMr._(_root);
	@override late final _TranslationsStoriesMr stories = _TranslationsStoriesMr._(_root);
	@override late final _TranslationsStoryGeneratorMr storyGenerator = _TranslationsStoryGeneratorMr._(_root);
	@override late final _TranslationsChatMr chat = _TranslationsChatMr._(_root);
	@override late final _TranslationsMapMr map = _TranslationsMapMr._(_root);
	@override late final _TranslationsCommunityMr community = _TranslationsCommunityMr._(_root);
	@override late final _TranslationsDiscoverMr discover = _TranslationsDiscoverMr._(_root);
	@override late final _TranslationsPlanMr plan = _TranslationsPlanMr._(_root);
	@override late final _TranslationsSettingsMr settings = _TranslationsSettingsMr._(_root);
	@override late final _TranslationsAuthMr auth = _TranslationsAuthMr._(_root);
	@override late final _TranslationsErrorMr error = _TranslationsErrorMr._(_root);
	@override late final _TranslationsSubscriptionMr subscription = _TranslationsSubscriptionMr._(_root);
	@override late final _TranslationsNotificationMr notification = _TranslationsNotificationMr._(_root);
	@override late final _TranslationsProfileMr profile = _TranslationsProfileMr._(_root);
	@override late final _TranslationsFeedMr feed = _TranslationsFeedMr._(_root);
	@override late final _TranslationsVoiceMr voice = _TranslationsVoiceMr._(_root);
	@override late final _TranslationsFestivalsMr festivals = _TranslationsFestivalsMr._(_root);
	@override late final _TranslationsSocialMr social = _TranslationsSocialMr._(_root);
}

// Path: app
class _TranslationsAppMr extends TranslationsAppEn {
	_TranslationsAppMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'भारतीय शास्त्रे शोधा';
}

// Path: common
class _TranslationsCommonMr extends TranslationsCommonEn {
	_TranslationsCommonMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ठीक आहे';
	@override String get cancel => 'रद्द करा';
	@override String get confirm => 'निश्चित करा';
	@override String get delete => 'काढून टाका';
	@override String get edit => 'संपादित करा';
	@override String get save => 'जतन करा';
	@override String get share => 'शेअर करा';
	@override String get search => 'शोधा';
	@override String get loading => 'लोड होत आहे...';
	@override String get error => 'त्रुटी';
	@override String get retry => 'पुन्हा प्रयत्न करा';
	@override String get back => 'मागे';
	@override String get next => 'पुढे';
	@override String get finish => 'पूर्ण करा';
	@override String get skip => 'वगळा';
	@override String get yes => 'होय';
	@override String get no => 'नाही';
	@override String get readFullStory => 'पूर्ण कथा वाचा';
	@override String get dismiss => 'बंद करा';
	@override String get offlineBannerMessage => 'तुम्ही ऑफलाइन आहात – कॅश केलेली सामग्री पाहत आहात';
	@override String get backOnline => 'पुन्हा ऑनलाइन';
}

// Path: navigation
class _TranslationsNavigationMr extends TranslationsNavigationEn {
	_TranslationsNavigationMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get home => 'शोध';
	@override String get stories => 'कथा';
	@override String get chat => 'चॅट';
	@override String get map => 'नकाशा';
	@override String get community => 'सामाजिक';
	@override String get settings => 'सेटिंग्ज';
	@override String get profile => 'प्रोफाइल';
}

// Path: home
class _TranslationsHomeMr extends TranslationsHomeEn {
	_TranslationsHomeMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'कथा जनरेटर';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'समुदाय कथा';
	@override String get maps => 'नकाशे';
	@override String get greetingMorning => 'शुभ सकाळ';
	@override String get continueReading => 'वाचन सुरू ठेवा';
	@override String get greetingAfternoon => 'शुभ दुपार';
	@override String get greetingEvening => 'शुभ संध्या';
	@override String get greetingNight => 'शुभ रात्री';
	@override String get exploreStories => 'कथा शोधा';
	@override String get generateStory => 'कथा तयार करा';
	@override String get content => 'होम सामग्री';
}

// Path: homeScreen
class _TranslationsHomeScreenMr extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'नमस्कार';
	@override String get quoteOfTheDay => 'आजचा विचार';
	@override String get shareQuote => 'विचार शेअर करा';
	@override String get copyQuote => 'विचार कॉपी करा';
	@override String get quoteCopied => 'विचार क्लिपबोर्डवर कॉपी झाला';
	@override String get featuredStories => 'विशेष कथा';
	@override String get quickActions => 'द्रुत क्रिया';
	@override String get generateStory => 'कथा तयार करा';
	@override String get chatWithKrishna => 'कृष्णाशी संवाद करा';
	@override String get myActivity => 'माझी कृती';
	@override String get continueReading => 'वाचन सुरू ठेवा';
	@override String get savedStories => 'जतन केलेल्या कथा';
	@override String get exploreMyitihas => 'मायइतिहास शोधा';
	@override String get storiesInYourLanguage => 'तुमच्या भाषेतल्या कथा';
	@override String get seeAll => 'सर्व पहा';
	@override String get startReading => 'वाचायला सुरू करा';
	@override String get exploreStories => 'तुमची यात्रा सुरू करण्यासाठी कथा शोधा';
	@override String get saveForLater => 'ज्या कथा आवडतात त्या बुकमार्क करा';
	@override String get noActivityYet => 'अजून कोणतीही कृती नाही';
	@override String minLeft({required Object count}) => '${count} मिनिटे शिल्लक';
	@override String get activityHistory => 'कृती इतिहास';
	@override String get storyGenerated => 'कथा तयार केली';
	@override String get storyRead => 'कथा वाचली';
	@override String get storyBookmarked => 'कथा बुकमार्क केली';
	@override String get storyShared => 'कथा शेअर केली';
	@override String get storyCompleted => 'कथा पूर्ण केली';
	@override String get today => 'आज';
	@override String get yesterday => 'काल';
	@override String get thisWeek => 'या आठवड्यात';
	@override String get earlier => 'यापूर्वी';
	@override String get noContinueReading => 'सध्या वाचण्यासाठी काही नाही';
	@override String get noSavedStories => 'अजून कोणतीही जतन केलेली कथा नाही';
	@override String get bookmarkStoriesToSave => 'कथा जतन करण्यासाठी त्यांना बुकमार्क करा';
	@override String get myGeneratedStories => 'माझ्या कथा';
	@override String get noGeneratedStoriesYet => 'अजून कोणतीही कथा तयार केलेली नाही';
	@override String get createYourFirstStory => 'AI च्या मदतीने तुमची पहिली कथा तयार करा';
	@override String get shareToFeed => 'फीडवर शेअर करा';
	@override String get sharedToFeed => 'कथा फीडवर शेअर केली';
	@override String get shareStoryTitle => 'कथा शेअर करा';
	@override String get shareStoryMessage => 'तुमच्या कथेसाठी कॅप्शन जोडा (ऐच्छिक)';
	@override String get shareStoryCaption => 'कॅप्शन';
	@override String get shareStoryHint => 'या कथेबद्दल तुम्हाला काय सांगायचे आहे?';
	@override String get exploreHeritageTitle => 'वारसा पाहा';
	@override String get exploreHeritageDesc => 'नकाशावर सांस्कृतिक वारसा स्थळे शोधा';
	@override String get whereToVisit => 'पुढील भेट';
	@override String get scriptures => 'शास्त्रे';
	@override String get exploreSacredSites => 'पवित्र स्थळे शोधा';
	@override String get readStories => 'कथा वाचा';
	@override String get yesRemindMe => 'होय, मला आठवण करून द्या';
	@override String get noDontShowAgain => 'नाही, पुन्हा दाखवू नका';
	@override String get discoverDismissTitle => 'Discover MyItihas लपवायचे का?';
	@override String get discoverDismissMessage => 'पुढच्या वेळी अॅप उघडल्यावर किंवा लॉगिन केल्यावर हे पुन्हा पाहायचे आहे का?';
	@override String get discoverCardTitle => 'MyItihas शोधा';
	@override String get discoverCardSubtitle => 'प्राचीन शास्त्रांमधील कथा, फिरून पाहण्यासारखी पवित्र स्थळे आणि तुमच्या बोटांच्या टोकावर ज्ञान.';
	@override String get swipeToDismiss => 'बंद करण्यासाठी वर स्वाईप करा';
	@override String get searchScriptures => 'शास्त्रे शोधा...';
	@override String get searchLanguages => 'भाषा शोधा...';
	@override String get exploreStoriesLabel => 'कथा शोधा';
	@override String get exploreMore => 'आणखी पाहा';
	@override String get failedToLoadActivity => 'कृती लोड करण्यात अयशस्वी';
	@override String get startReadingOrGenerating => 'इथे तुमच्या कृती पाहण्यासाठी वाचायला किंवा कथा तयार करायला सुरू करा';
	@override late final _TranslationsHomeScreenHeroMr hero = _TranslationsHomeScreenHeroMr._(_root);
}

// Path: stories
class _TranslationsStoriesMr extends TranslationsStoriesEn {
	_TranslationsStoriesMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'कथा';
	@override String get searchHint => 'शीर्षक किंवा लेखकानुसार शोधा...';
	@override String get sortBy => 'क्रम लावा';
	@override String get sortNewest => 'नवीन प्रथम';
	@override String get sortOldest => 'जुने प्रथम';
	@override String get sortPopular => 'सर्वात लोकप्रिय';
	@override String get noStories => 'कोणतीही कथा सापडली नाही';
	@override String get loadingStories => 'कथा लोड होत आहेत...';
	@override String get errorLoadingStories => 'कथा लोड करण्यात अयशस्वी';
	@override String get storyDetails => 'कथेचे तपशील';
	@override String get continueReading => 'वाचन सुरू ठेवा';
	@override String get readMore => 'अधिक वाचा';
	@override String get readLess => 'कमी दाखवा';
	@override String get author => 'लेखक';
	@override String get publishedOn => 'प्रकाशित दिनांक';
	@override String get category => 'वर्ग';
	@override String get tags => 'टॅग';
	@override String get failedToLoad => 'कथा लोड करण्यात अयशस्वी';
	@override String get subtitle => 'शास्त्रांतील कथा शोधा';
	@override String get noStoriesHint => 'कथा शोधण्यासाठी वेगळा शोध किंवा फिल्टर वापरून पाहा.';
	@override String get featured => 'वैशिष्ट्यपूर्ण';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorMr extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'कथा जनरेटर';
	@override String get subtitle => 'तुमची स्वतःची शास्त्रीय कथा तयार करा';
	@override String get quickStart => 'द्रुत प्रारंभ';
	@override String get interactive => 'संवादी';
	@override String get rawPrompt => 'मूळ प्रॉम्प्ट';
	@override String get yourStoryPrompt => 'तुमच्या कथेचा प्रॉम्प्ट';
	@override String get writeYourPrompt => 'तुमचा प्रॉम्प्ट लिहा';
	@override String get selectScripture => 'शास्त्र निवडा';
	@override String get selectStoryType => 'कथेचा प्रकार निवडा';
	@override String get selectCharacter => 'पात्र निवडा';
	@override String get selectTheme => 'थीम निवडा';
	@override String get selectSetting => 'पार्श्वभूमी निवडा';
	@override String get selectLanguage => 'भाषा निवडा';
	@override String get selectLength => 'कथेची लांबी';
	@override String get moreOptions => 'आणखी पर्याय';
	@override String get random => 'अकस्मात';
	@override String get generate => 'कथा तयार करा';
	@override String get generating => 'तुमची कथा तयार होत आहे...';
	@override String get creatingYourStory => 'तुमची कथा तयार केली जात आहे';
	@override String get consultingScriptures => 'प्राचीन शास्त्रांचा सल्ला घेत आहोत...';
	@override String get weavingTale => 'तुमची गोष्ट विणत आहोत...';
	@override String get addingWisdom => 'दिव्य ज्ञान जोडत आहोत...';
	@override String get polishingNarrative => 'कथानक घासून-पुसून चमकदार करत आहोत...';
	@override String get almostThere => 'जवळजवळ झाले...';
	@override String get generatedStory => 'तुमची तयार केलेली कथा';
	@override String get aiGenerated => 'AI-ने तयार केलेली';
	@override String get regenerate => 'परत तयार करा';
	@override String get saveStory => 'कथा जतन करा';
	@override String get shareStory => 'कथा शेअर करा';
	@override String get newStory => 'नवी कथा';
	@override String get saved => 'जतन केले';
	@override String get storySaved => 'कथा तुमच्या लायब्ररीत जतन केली गेली आहे';
	@override String get story => 'कथा';
	@override String get lesson => 'शिक्षा';
	@override String get didYouKnow => 'तुम्हाला माहीत आहे का?';
	@override String get activity => 'कृती';
	@override String get optionalRefine => 'ऐच्छिक: पर्यायांद्वारे अधिक स्पष्ट करा';
	@override String get applyOptions => 'पर्याय लागू करा';
	@override String get language => 'भाषा';
	@override String get storyFormat => 'कथेचा फॉरमॅट';
	@override String get requiresInternet => 'कथा तयार करण्यासाठी इंटरनेट आवश्यक आहे';
	@override String get notAvailableOffline => 'कथा ऑफलाइन उपलब्ध नाही. पाहण्यासाठी इंटरनेटला जोडले जा.';
	@override String get aiDisclaimer => 'AI चुका करू शकतो. आम्ही सतत सुधारणा करत आहोत; तुमचा अभिप्राय महत्त्वाचा आहे.';
	@override late final _TranslationsStoryGeneratorStoryLengthMr storyLength = _TranslationsStoryGeneratorStoryLengthMr._(_root);
	@override late final _TranslationsStoryGeneratorFormatMr format = _TranslationsStoryGeneratorFormatMr._(_root);
	@override late final _TranslationsStoryGeneratorHintsMr hints = _TranslationsStoryGeneratorHintsMr._(_root);
	@override late final _TranslationsStoryGeneratorErrorsMr errors = _TranslationsStoryGeneratorErrorsMr._(_root);
}

// Path: chat
class _TranslationsChatMr extends TranslationsChatEn {
	_TranslationsChatMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'शास्त्रांबद्दल AI सोबत संवाद करा';
	@override String get friendMode => 'मित्र मोड';
	@override String get philosophicalMode => 'तत्त्वचिंतनात्मक मोड';
	@override String get typeMessage => 'तुमचा संदेश टाइप करा...';
	@override String get send => 'पाठवा';
	@override String get newChat => 'नवीन चॅट';
	@override String get chatsTab => 'चॅट';
	@override String get groupsTab => 'ग्रुप्स';
	@override String get chatHistory => 'चॅट इतिहास';
	@override String get clearChat => 'चॅट साफ करा';
	@override String get noMessages => 'अजून कोणतेही संदेश नाहीत. संवाद सुरू करा!';
	@override String get listPage => 'चॅट सूची पृष्ठ';
	@override String get forwardMessageTo => 'संदेश यांना पुढे पाठवा...';
	@override String get forwardMessage => 'संदेश फॉरवर्ड करा';
	@override String get messageForwarded => 'संदेश फॉरवर्ड केला गेला';
	@override String failedToForward({required Object error}) => 'संदेश फॉरवर्ड करण्यात अयशस्वी: ${error}';
	@override String get searchChats => 'चॅट शोधा';
	@override String get noChatsFound => 'कोणतीही चॅट आढळली नाही';
	@override String get requests => 'विनंत्या';
	@override String get messageRequests => 'संदेश विनंत्या';
	@override String get groupRequests => 'गट विनंत्या';
	@override String get requestSent => 'विनंती पाठवली गेली. त्या "विनंत्या" विभागात दिसतील.';
	@override String get wantsToChat => 'चॅट करायची इच्छा आहे';
	@override String addedYouTo({required Object name}) => '${name} यांनी तुम्हाला जोडले आहे';
	@override String get accept => 'स्वीकारा';
	@override String get noMessageRequests => 'कोणतीही संदेश विनंती नाही';
	@override String get noGroupRequests => 'कोणतीही गट विनंती नाही';
	@override String get invitesSent => 'आमंत्रणे पाठवली गेली. त्या "विनंत्या" विभागात दिसतील.';
	@override String get cantMessageUser => 'तुम्ही या वापरकर्त्याला संदेश पाठवू शकत नाही';
	@override String get deleteChat => 'चॅट काढून टाका';
	@override String get deleteChats => 'चॅट्स काढून टाका';
	@override String get blockUser => 'वापरकर्त्याला ब्लॉक करा';
	@override String get reportUser => 'वापरकर्त्याची तक्रार करा';
	@override String get markAsRead => 'वाचले म्हणून चिन्हांकित करा';
	@override String get markedAsRead => 'वाचले म्हणून चिन्हांकित केले गेले';
	@override String get deleteClearChat => 'चॅट काढून टाका / साफ करा';
	@override String get deleteConversation => 'संवाद काढून टाका';
	@override String get reasonRequired => 'कारण (आवश्यक)';
	@override String get submit => 'सबमिट करा';
	@override String get userReportedBlocked => 'वापरकर्त्याची तक्रार करण्यात आली आणि ब्लॉक करण्यात आला आहे.';
	@override String reportFailed({required Object error}) => 'तक्रार करण्यास अयशस्वी: ${error}';
	@override String get newGroup => 'नवीन गट';
	@override String get messageSomeoneDirectly => 'कुणाला थेट संदेश पाठवा';
	@override String get createGroupConversation => 'गट संवाद तयार करा';
	@override String get noGroupsYet => 'अजून कोणताही गट नाही';
	@override String get noChatsYet => 'अजून कोणतीही चॅट नाही';
	@override String get tapToCreateGroup => 'गट तयार करण्यासाठी किंवा सामील होण्यासाठी + टॅप करा';
	@override String get tapToStartConversation => 'नवीन संवाद सुरू करण्यासाठी + टॅप करा';
	@override String get conversationDeleted => 'संवाद काढून टाकला गेला';
	@override String conversationsDeleted({required Object count}) => '${count} संवाद काढून टाकले गेले';
	@override String get searchConversations => 'संवाद शोधा...';
	@override String get connectToInternet => 'कृपया इंटरनेटशी कनेक्ट व्हा आणि पुन्हा प्रयत्न करा.';
	@override String get littleKrishnaName => 'लहान कृष्ण';
	@override String get newConversation => 'नवीन संवाद';
	@override String get noConversationsYet => 'अजून कोणताही संवाद नाही';
	@override String get confirmDeletion => 'काढून टाकणे निश्चित करा';
	@override String deleteConversationConfirm({required Object title}) => 'तुम्हाला नक्की ${title} संवाद काढून टाकायचा आहे का?';
	@override String get deleteFailed => 'संवाद काढून टाकण्यात अयशस्वी';
	@override String get fullChatCopied => 'संपूर्ण चॅट क्लिपबोर्डवर कॉपी झाले!';
	@override String get connectionErrorFallback => 'सध्या कनेक्ट करण्यात अडचण येत आहे. कृपया थोड्या वेळाने पुन्हा प्रयत्न करा.';
	@override String krishnaWelcomeWithName({required Object name}) => 'हाय ${name}. मी तुमचा मित्र कृष्ण आहे. तुम्ही आज कसे आहात?';
	@override String get krishnaWelcomeFriend => 'हाय प्रिय मित्रा. मी तुमचा मित्र कृष्ण आहे. तुम्ही आज कसे आहात?';
	@override String get copyYouLabel => 'तुम्ही';
	@override String get copyKrishnaLabel => 'कृष्ण';
	@override late final _TranslationsChatSuggestionsMr suggestions = _TranslationsChatSuggestionsMr._(_root);
	@override String get about => 'बद्दल';
	@override String get yourFriendlyCompanion => 'तुमचा मैत्रीपूर्ण साथीदार';
	@override String get mentalHealthSupport => 'मानसिक आरोग्य सहाय्य';
	@override String get mentalHealthSupportSubtitle => 'विचार शेअर करण्यासाठी आणि ऐकले गेल्याची भावना होण्यासाठी सुरक्षित जागा.';
	@override String get friendlyCompanion => 'मैत्रीपूर्ण सोबती';
	@override String get friendlyCompanionSubtitle => 'नेहमी बोलण्यासाठी, प्रोत्साहित करण्यासाठी आणि ज्ञान शेअर करण्यासाठी तयार.';
	@override String get storiesAndWisdom => 'कथा आणि शहाणपण';
	@override String get storiesAndWisdomSubtitle => 'कालातीत कथांमधून आणि व्यवहार्य ज्ञानातून शिका.';
	@override String get askAnything => 'काहीही विचारा';
	@override String get askAnythingSubtitle => 'तुमच्या प्रश्नांना कोमल, विचारपूर्वक उत्तरे मिळवा.';
	@override String get startChatting => 'चॅट करायला सुरू करा';
	@override String get maybeLater => 'कदाचित नंतर';
	@override late final _TranslationsChatComposerAttachmentsMr composerAttachments = _TranslationsChatComposerAttachmentsMr._(_root);
}

// Path: map
class _TranslationsMapMr extends TranslationsMapEn {
	_TranslationsMapMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'अखंड भारत';
	@override String get subtitle => 'ऐतिहासिक स्थळे शोधा';
	@override String get searchLocation => 'स्थळ शोधा...';
	@override String get viewDetails => 'तपशील पहा';
	@override String get viewSites => 'स्थळे पहा';
	@override String get showRoute => 'मार्ग दाखवा';
	@override String get historicalInfo => 'ऐतिहासिक माहिती';
	@override String get nearbyPlaces => 'जवळची स्थळे';
	@override String get pickLocationOnMap => 'नकाशावर स्थळ निवडा';
	@override String get sitesVisited => 'भेट दिलेली स्थळे';
	@override String get badgesEarned => 'मिळालेले बॅज';
	@override String get completionRate => 'पूर्णत्व दर';
	@override String get addToJourney => 'प्रवासात जोडा';
	@override String get addedToJourney => 'प्रवासात जोडले गेले';
	@override String get getDirections => 'मार्ग मिळवा';
	@override String get viewInMap => 'नकाशावर पहा';
	@override String get directions => 'मार्गदर्शन';
	@override String get photoGallery => 'फोटो गॅलरी';
	@override String get viewAll => 'सर्व पहा';
	@override String get photoSavedToGallery => 'फोटो गॅलरीत जतन केला गेला';
	@override String get sacredSoundscape => 'पवित्र ध्वनी विश्व';
	@override String get allDiscussions => 'सर्व चर्चा';
	@override String get journeyTab => 'प्रवास';
	@override String get discussionTab => 'चर्चा';
	@override String get myActivity => 'माझी कृती';
	@override String get anonymousPilgrim => 'अनामिक यात्रेकरू';
	@override String get viewProfile => 'प्रोफाइल पहा';
	@override String get discussionTitleHint => 'चर्चेचे शीर्षक...';
	@override String get shareYourThoughtsHint => 'तुमचे विचार शेअर करा...';
	@override String get pleaseEnterDiscussionTitle => 'कृपया चर्चेचे शीर्षक लिहा';
	@override String get addReflection => 'अनुभव जोडा';
	@override String get reflectionTitle => 'शीर्षक';
	@override String get enterReflectionTitle => 'अनुभवाचे शीर्षक लिहा';
	@override String get pleaseEnterTitle => 'कृपया शीर्षक लिहा';
	@override String get siteName => 'स्थळाचे नाव';
	@override String get enterSacredSiteName => 'पवित्र स्थळाचे नाव लिहा';
	@override String get pleaseEnterSiteName => 'कृपया स्थळाचे नाव लिहा';
	@override String get reflection => 'अनुभव';
	@override String get reflectionHint => 'तुमचे अनुभव आणि विचार शेअर करा...';
	@override String get pleaseEnterReflection => 'कृपया तुमचा अनुभव लिहा';
	@override String get saveReflection => 'अनुभव जतन करा';
	@override String get journeyProgress => 'प्रवास प्रगती';
	@override late final _TranslationsMapDiscussionsMr discussions = _TranslationsMapDiscussionsMr._(_root);
	@override late final _TranslationsMapFabricMapMr fabricMap = _TranslationsMapFabricMapMr._(_root);
	@override late final _TranslationsMapClassicalArtMapMr classicalArtMap = _TranslationsMapClassicalArtMapMr._(_root);
	@override late final _TranslationsMapClassicalDanceMapMr classicalDanceMap = _TranslationsMapClassicalDanceMapMr._(_root);
	@override late final _TranslationsMapFoodMapMr foodMap = _TranslationsMapFoodMapMr._(_root);
}

// Path: community
class _TranslationsCommunityMr extends TranslationsCommunityEn {
	_TranslationsCommunityMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'समुदाय';
	@override String get trending => 'ट्रेंडिंग';
	@override String get following => 'फॉलो करत आहात';
	@override String get followers => 'फॉलोअर्स';
	@override String get posts => 'पोस्ट्स';
	@override String get follow => 'फॉलो करा';
	@override String get unfollow => 'फॉलो काढा';
	@override String get shareYourStory => 'तुमची कथा शेअर करा...';
	@override String get post => 'पोस्ट करा';
	@override String get like => 'लाईक';
	@override String get comment => 'टिप्पणी';
	@override String get comments => 'टिप्पण्या';
	@override String get noPostsYet => 'अजून कोणतीही पोस्ट नाही';
}

// Path: discover
class _TranslationsDiscoverMr extends TranslationsDiscoverEn {
	_TranslationsDiscoverMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'शोधा';
	@override String get searchHint => 'कथा, वापरकर्ते किंवा विषय शोधा...';
	@override String get tryAgain => 'पुन्हा प्रयत्न करा';
	@override String get somethingWentWrong => 'काहीतरी चूक झाली';
	@override String get unableToLoadProfiles => 'प्रोफाइल लोड करता आले नाहीत. पुन्हा प्रयत्न करा.';
	@override String get noProfilesFound => 'कोणतीही प्रोफाइल सापडली नाहीत';
	@override String get searchToFindPeople => 'फॉलो करण्यासाठी लोक शोधा';
	@override String get noResultsFound => 'कोणतेही परिणाम आढळले नाहीत';
	@override String get noProfilesYet => 'अजून कोणतीही प्रोफाइल नाही';
	@override String get tryDifferentKeywords => 'वेगवेगळ्या कीवर्ड्सने शोधा';
	@override String get beFirstToDiscover => 'नवीन लोक शोधणारे पहिले बना!';
}

// Path: plan
class _TranslationsPlanMr extends TranslationsPlanEn {
	_TranslationsPlanMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'तुमची योजना जतन करण्यासाठी साइन इन करा';
	@override String get planSaved => 'योजना जतन केली गेली';
	@override String get from => 'कुठून';
	@override String get dates => 'तारखा';
	@override String get destination => 'गंतव्य';
	@override String get nearby => 'जवळपास';
	@override String get generatedPlan => 'तयार केलेली योजना';
	@override String get whereTravellingFrom => 'तुम्ही कुठून प्रवास करत आहात?';
	@override String get enterCityOrRegion => 'तुमचे शहर किंवा प्रदेश लिहा';
	@override String get travelDates => 'प्रवासाच्या तारखा';
	@override String get destinationSacredSite => 'गंतव्य (पवित्र स्थळ)';
	@override String get searchOrSelectDestination => 'गंतव्य शोधा किंवा निवडा...';
	@override String get shareYourExperience => 'तुमचा अनुभव शेअर करा';
	@override String get planShared => 'योजना शेअर केली गेली';
	@override String failedToSharePlan({required Object error}) => 'योजना शेअर करण्यात अयशस्वी: ${error}';
	@override String get planUpdated => 'योजना अद्ययावत केली गेली';
	@override String failedToUpdatePlan({required Object error}) => 'योजना अद्ययावत करण्यात अयशस्वी: ${error}';
	@override String get deletePlanConfirm => 'योजना काढून टाकावी का?';
	@override String get thisPlanPermanentlyDeleted => 'ही योजना कायमची काढून टाकली जाईल.';
	@override String get planDeleted => 'योजना काढून टाकली गेली';
	@override String failedToDeletePlan({required Object error}) => 'योजना काढून टाकण्यात अयशस्वी: ${error}';
	@override String get sharePlan => 'योजना शेअर करा';
	@override String get deletePlan => 'योजना काढून टाका';
	@override String get savedPlanDetails => 'जतन केलेल्या योजनेचे तपशील';
	@override String get pilgrimagePlan => 'तीर्थयात्रा योजना';
	@override String get planTab => 'योजना';
}

// Path: settings
class _TranslationsSettingsMr extends TranslationsSettingsEn {
	_TranslationsSettingsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'सेटिंग्ज';
	@override String get language => 'भाषा';
	@override String get theme => 'थीम';
	@override String get themeLight => 'लाइट';
	@override String get themeDark => 'डार्क';
	@override String get themeSystem => 'सिस्टीम थीम वापरा';
	@override String get darkMode => 'डार्क मोड';
	@override String get selectLanguage => 'भाषा निवडा';
	@override String get notifications => 'सूचना';
	@override String get cacheSettings => 'कॅशे आणि स्टोरेज';
	@override String get general => 'सामान्य';
	@override String get account => 'खाते';
	@override String get blockedUsers => 'ब्लॉक केलेले वापरकर्ते';
	@override String get helpSupport => 'मदत आणि समर्थन';
	@override String get contactUs => 'आमच्याशी संपर्क करा';
	@override String get legal => 'कायदेशीर';
	@override String get privacyPolicy => 'गोपनीयता धोरण';
	@override String get termsConditions => 'अटी आणि शर्ती';
	@override String get privacy => 'गोपनीयता';
	@override String get about => 'ऍप बद्दल';
	@override String get version => 'आवृत्ती';
	@override String get logout => 'लॉगआऊट';
	@override String get deleteAccount => 'खाते काढून टाका';
	@override String get deleteAccountTitle => 'खाते काढून टाका';
	@override String get deleteAccountWarning => 'हे कार्य मागे घेता येणार नाही!';
	@override String get deleteAccountDescription => 'तुमचे खाते काढून टाकल्यास तुमच्या सर्व पोस्ट्स, टिप्पण्या, प्रोफाइल, फॉलोअर्स, जतन केलेल्या कथा, बुकमार्क्स, चॅट संदेश आणि तयार केलेल्या कथा कायमच्या काढून टाकल्या जातील.';
	@override String get confirmPassword => 'तुमचा पासवर्ड निश्चित करा';
	@override String get confirmPasswordDesc => 'खाते काढून टाकण्याची खात्री करण्यासाठी तुमचा पासवर्ड लिहा.';
	@override String get googleReauth => 'तुमची ओळख पडताळण्यासाठी तुम्हाला Google कडे पाठवले जाईल.';
	@override String get finalConfirmationTitle => 'अंतिम खात्री';
	@override String get finalConfirmation => 'तुम्ही पूर्णपणे खात्री आहात का? हे कायमचे आहे आणि मागे घेता येणार नाही.';
	@override String get deleteMyAccount => 'माझे खाते काढून टाका';
	@override String get deletingAccount => 'खाते काढून टाकले जात आहे...';
	@override String get accountDeleted => 'तुमचे खाते कायमचे काढून टाकले गेले आहे.';
	@override String get deleteAccountFailed => 'खाते काढून टाकण्यात अयशस्वी. पुन्हा प्रयत्न करा.';
	@override String get downloadedStories => 'डाउनलोड केलेल्या कथा';
	@override String get couldNotOpenEmail => 'ईमेल ऍप उघडता आले नाही. कृपया आम्हाला myitihas@gmail.com वर ईमेल करा.';
	@override String couldNotOpenLabel({required Object label}) => 'सध्या ${label} उघडता आले नाही.';
	@override String get logoutTitle => 'लॉगआऊट';
	@override String get logoutConfirm => 'तुम्हाला खरोखर लॉगआऊट करायचे आहे का?';
	@override String get verifyYourIdentity => 'तुमची ओळख पडताळा';
	@override String get verifyYourIdentityDesc => 'तुमची ओळख पडताळण्यासाठी तुम्हाला Google सोबत साइन इन करण्यास सांगितले जाईल.';
	@override String get continueWithGoogle => 'Google सोबत पुढे जा';
	@override String reauthFailed({required Object error}) => 'पुन्हा प्रमाणीकरण करण्यात अयशस्वी: ${error}';
	@override String get passwordRequired => 'पासवर्ड आवश्यक आहे';
	@override String get invalidPassword => 'अवैध पासवर्ड. पुन्हा प्रयत्न करा.';
	@override String get verify => 'पडताळा';
	@override String get continueLabel => 'पुढे चालू ठेवा';
	@override String get unableToVerifyIdentity => 'ओळख पडताळण्यात अयशस्वी. पुन्हा प्रयत्न करा.';
}

// Path: auth
class _TranslationsAuthMr extends TranslationsAuthEn {
	_TranslationsAuthMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get login => 'लॉगिन';
	@override String get signup => 'साइन अप';
	@override String get email => 'ईमेल';
	@override String get password => 'पासवर्ड';
	@override String get confirmPassword => 'पासवर्डची खात्री करा';
	@override String get forgotPassword => 'पासवर्ड विसरलात?';
	@override String get resetPassword => 'पासवर्ड रीसेट करा';
	@override String get dontHaveAccount => 'खाते नाही?';
	@override String get alreadyHaveAccount => 'आधीच खाते आहे?';
	@override String get loginSuccess => 'लॉगिन यशस्वी';
	@override String get signupSuccess => 'साइन अप यशस्वी';
	@override String get loginError => 'लॉगिन अयशस्वी';
	@override String get signupError => 'साइन अप अयशस्वी';
}

// Path: error
class _TranslationsErrorMr extends TranslationsErrorEn {
	_TranslationsErrorMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get network => 'इंटरनेट कनेक्शन नाही';
	@override String get server => 'सर्व्हरवर त्रुटी आली';
	@override String get cache => 'कॅश केलेला डेटा लोड करण्यात अयशस्वी';
	@override String get timeout => 'विनंतीचा वेळ संपला';
	@override String get notFound => 'संसाधन सापडले नाही';
	@override String get validation => 'तपासणी अयशस्वी';
	@override String get unexpected => 'अप्रत्याशित त्रुटी आली';
	@override String get tryAgain => 'कृपया पुन्हा प्रयत्न करा';
	@override String couldNotOpenLink({required Object url}) => 'लिंक उघडता आली नाही: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionMr extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get free => 'मोफत';
	@override String get plus => 'प्लस';
	@override String get pro => 'प्रो';
	@override String get upgradeToPro => 'प्रोवर अपग्रेड करा';
	@override String get features => 'वैशिष्ट्ये';
	@override String get subscribe => 'सबस्क्राइब करा';
	@override String get currentPlan => 'सध्याची योजना';
	@override String get managePlan => 'योजना व्यवस्थापित करा';
}

// Path: notification
class _TranslationsNotificationMr extends TranslationsNotificationEn {
	_TranslationsNotificationMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'सूचना';
	@override String get peopleToConnect => 'ज्यांच्याशी जोडले जावे';
	@override String get peopleToConnectSubtitle => 'फॉलो करण्यासाठी लोक शोधा';
	@override String followAgainInMinutes({required Object minutes}) => 'तुम्ही ${minutes} मिनिटांनंतर पुन्हा फॉलो करू शकता';
	@override String get noSuggestions => 'सध्या कोणतीही सूचना नाही';
	@override String get markAllRead => 'सर्व वाचले म्हणून चिन्हांकित करा';
	@override String get noNotifications => 'अजून कोणतीही सूचना नाही';
	@override String get noNotificationsSubtitle => 'कोणी तुमच्या कथांशी संवाद साधल्यास, ते येथे दिसेल';
	@override String get errorPrefix => 'त्रुटी:';
	@override String get retry => 'पुन्हा प्रयत्न करा';
	@override String likedYourStory({required Object actorName}) => '${actorName} यांनी तुमची कथा लाईक केली';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} यांनी तुमच्या कथेवर टिप्पणी केली';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} यांनी तुमच्या टिप्पणीला उत्तर दिले';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} यांनी तुम्हाला फॉलो करायला सुरुवात केली';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} यांनी तुम्हाला एक संदेश पाठवला';
	@override String sharedYourStory({required Object actorName}) => '${actorName} यांनी तुमची कथा शेअर केली';
	@override String repostedYourStory({required Object actorName}) => '${actorName} यांनी तुमची कथा पुन्हा पोस्ट केली';
	@override String mentionedYou({required Object actorName}) => '${actorName} यांनी तुमचा उल्लेख केला';
	@override String newPostFrom({required Object actorName}) => '${actorName} यांची नवीन पोस्ट';
	@override String get today => 'आज';
	@override String get thisWeek => 'या आठवड्यात';
	@override String get earlier => 'पूर्वी';
	@override String get delete => 'काढून टाका';
}

// Path: profile
class _TranslationsProfileMr extends TranslationsProfileEn {
	_TranslationsProfileMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get followers => 'फॉलोअर्स';
	@override String get following => 'फॉलो करत आहात';
	@override String get unfollow => 'फॉलो काढा';
	@override String get follow => 'फॉलो करा';
	@override String get about => 'बद्दल';
	@override String get stories => 'कथा';
	@override String get unableToShareImage => 'चित्र शेअर करता आले नाही';
	@override String get imageSavedToPhotos => 'चित्र फोटोमध्ये जतन केले गेले';
	@override String get view => 'पहा';
	@override String get saveToPhotos => 'फोटोमध्ये जतन करा';
	@override String get failedToLoadImage => 'चित्र लोड करण्यात अयशस्वी';
}

// Path: feed
class _TranslationsFeedMr extends TranslationsFeedEn {
	_TranslationsFeedMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'कथा लोड होत आहेत...';
	@override String get loadingPosts => 'पोस्ट्स लोड होत आहेत...';
	@override String get loadingVideos => 'व्हिडिओ लोड होत आहेत...';
	@override String get loadingStories => 'कथा लोड होत आहेत...';
	@override String get errorTitle => 'अरेरे! काहीतरी चूक झाली';
	@override String get tryAgain => 'पुन्हा प्रयत्न करा';
	@override String get noStoriesAvailable => 'कोणतीही कथा उपलब्ध नाही';
	@override String get noImagesAvailable => 'कोणतीही इमेज पोस्ट उपलब्ध नाही';
	@override String get noTextPostsAvailable => 'कोणतीही मजकूर पोस्ट उपलब्ध नाही';
	@override String get noContentAvailable => 'कोणतीही सामग्री उपलब्ध नाही';
	@override String get refresh => 'रिफ्रेश करा';
	@override String get comments => 'टिप्पण्या';
	@override String get commentsComingSoon => 'टिप्पण्या लवकरच येत आहेत';
	@override String get addCommentHint => 'टिप्पणी जोडा...';
	@override String get shareStory => 'कथा शेअर करा';
	@override String get sharePost => 'पोस्ट शेअर करा';
	@override String get shareThought => 'विचार शेअर करा';
	@override String get shareAsImage => 'इमेज म्हणून शेअर करा';
	@override String get shareAsImageSubtitle => 'सुंदर प्रीव्ह्यू कार्ड तयार करा';
	@override String get shareLink => 'लिंक शेअर करा';
	@override String get shareLinkSubtitle => 'कथेचा लिंक कॉपी किंवा शेअर करा';
	@override String get shareImageLinkSubtitle => 'पोस्टचा लिंक कॉपी किंवा शेअर करा';
	@override String get shareTextLinkSubtitle => 'विचाराचा लिंक कॉपी किंवा शेअर करा';
	@override String get shareAsText => 'मजकूर म्हणून शेअर करा';
	@override String get shareAsTextSubtitle => 'कथेचा काही भाग शेअर करा';
	@override String get shareQuote => 'उक्ती शेअर करा';
	@override String get shareQuoteSubtitle => 'उक्ती म्हणून शेअर करा';
	@override String get shareWithImage => 'चित्रासह शेअर करा';
	@override String get shareWithImageSubtitle => 'चित्र आणि कॅप्शन एकत्र शेअर करा';
	@override String get copyLink => 'लिंक कॉपी करा';
	@override String get copyLinkSubtitle => 'लिंक क्लिपबोर्डवर कॉपी करा';
	@override String get copyText => 'मजकूर कॉपी करा';
	@override String get copyTextSubtitle => 'उक्ती क्लिपबोर्डवर कॉपी करा';
	@override String get linkCopied => 'लिंक क्लिपबोर्डवर कॉपी केली गेली';
	@override String get textCopied => 'मजकूर क्लिपबोर्डवर कॉपी केला गेला';
	@override String get sendToUser => 'वापरकर्त्यास पाठवा';
	@override String get sendToUserSubtitle => 'मित्रास थेट शेअर करा';
	@override String get chooseFormat => 'फॉरमॅट निवडा';
	@override String get linkPreview => 'लिंक प्रीव्ह्यू';
	@override String get linkPreviewSize => '१२०० × ६३०';
	@override String get storyFormat => 'स्टोरी फॉरमॅट';
	@override String get storyFormatSize => '१०८० × १९२० (Instagram/Stories)';
	@override String get generatingPreview => 'प्रीव्ह्यू तयार होत आहे...';
	@override String get bookmarked => 'बुकमार्क केले';
	@override String get removedFromBookmarks => 'बुकमार्कमधून काढून टाकले';
	@override String unlike({required Object count}) => 'अनलाईक, ${count} लाईक्स';
	@override String like({required Object count}) => 'लाईक, ${count} लाईक्स';
	@override String commentCount({required Object count}) => '${count} टिप्पण्या';
	@override String shareCount({required Object count}) => 'शेअर, ${count} वेळा शेअर';
	@override String get removeBookmark => 'बुकमार्क काढून टाका';
	@override String get addBookmark => 'बुकमार्क करा';
	@override String get quote => 'उक्ती';
	@override String get quoteCopied => 'उक्ती क्लिपबोर्डवर कॉपी केली गेली';
	@override String get copy => 'कॉपी करा';
	@override String get tapToViewFullQuote => 'पूर्ण उक्ती पाहण्यासाठी टॅप करा';
	@override String get quoteFromMyitihas => 'MyItihas मधील उक्ती';
	@override late final _TranslationsFeedTabsMr tabs = _TranslationsFeedTabsMr._(_root);
	@override String get tapToShowCaption => 'कॅप्शन पाहण्यासाठी टॅप करा';
	@override String get noVideosAvailable => 'कोणतेही व्हिडिओ उपलब्ध नाहीत';
	@override String get selectUser => 'कोणाला पाठवायचे';
	@override String get searchUsers => 'वापरकर्ते शोधा...';
	@override String get noFollowingYet => 'तुम्ही अजून कोणालाही फॉलो करत नाही';
	@override String get noUsersFound => 'कोणतेही वापरकर्ते आढळले नाहीत';
	@override String get tryDifferentSearch => 'वेगळ्या शोधशब्दाने प्रयत्न करा';
	@override String sentTo({required Object username}) => '${username} यांना पाठवले';
}

// Path: voice
class _TranslationsVoiceMr extends TranslationsVoiceEn {
	_TranslationsVoiceMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'मायक्रोफोनची परवानगी आवश्यक आहे';
	@override String get speechRecognitionNotAvailable => 'स्पीच रेकग्निशन उपलब्ध नाही';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsMr extends TranslationsFestivalsEn {
	_TranslationsFestivalsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'सणांच्या गोष्टी';
	@override String get tellStory => 'गोष्ट सांगा';
}

// Path: social
class _TranslationsSocialMr extends TranslationsSocialEn {
	_TranslationsSocialMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileMr editProfile = _TranslationsSocialEditProfileMr._(_root);
	@override late final _TranslationsSocialCreatePostMr createPost = _TranslationsSocialCreatePostMr._(_root);
	@override late final _TranslationsSocialCommentsMr comments = _TranslationsSocialCommentsMr._(_root);
	@override late final _TranslationsSocialEngagementMr engagement = _TranslationsSocialEngagementMr._(_root);
	@override String get editCaption => 'कॅप्शन संपादित करा';
	@override String get reportPost => 'पोस्टची तक्रार करा';
	@override String get reportReasonHint => 'या पोस्टमध्ये काय चुकीचे आहे ते आम्हाला सांगा';
	@override String get deletePost => 'पोस्ट काढून टाका';
	@override String get deletePostConfirm => 'ही कृती मागे घेता येणार नाही.';
	@override String get postDeleted => 'पोस्ट काढून टाकली गेली आहे';
	@override String failedToDeletePost({required Object error}) => 'पोस्ट काढून टाकण्यात अयशस्वी: ${error}';
	@override String failedToReportPost({required Object error}) => 'पोस्टची तक्रार करण्यात अयशस्वी: ${error}';
	@override String get reportSubmitted => 'तक्रार सबमिट झाली आहे. धन्यवाद.';
	@override String get acceptRequestFirst => 'प्रथम "विनंत्या" पृष्ठावर त्यांची विनंती स्वीकारा.';
	@override String get requestSentWait => 'विनंती पाठवली गेली आहे. ते स्वीकारेपर्यंत प्रतीक्षा करा.';
	@override String get requestSentTheyWillSee => 'विनंती पाठवली गेली आहे. ते "विनंत्या" विभागात पाहतील.';
	@override String failedToShare({required Object error}) => 'शेअर करण्यात अयशस्वी: ${error}';
	@override String get updateCaptionHint => 'तुमच्या पोस्टसाठी कॅप्शन अद्ययावत करा';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroMr extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'अन्वेषणासाठी टॅप करा';
	@override late final _TranslationsHomeScreenHeroStoryMr story = _TranslationsHomeScreenHeroStoryMr._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionMr companion = _TranslationsHomeScreenHeroCompanionMr._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageMr heritage = _TranslationsHomeScreenHeroHeritageMr._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityMr community = _TranslationsHomeScreenHeroCommunityMr._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesMr messages = _TranslationsHomeScreenHeroMessagesMr._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthMr extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get short => 'लहान';
	@override String get medium => 'मध्यम';
	@override String get long => 'लांब';
	@override String get epic => 'महाकाव्यात्मक';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatMr extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'कथात्मक';
	@override String get dialogue => 'संवाद-आधारित';
	@override String get poetic => 'काव्यात्मक';
	@override String get scriptural => 'शास्त्रीय';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsMr extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'कृष्ण अर्जुनाला शिक्षण देत आहे अशी गोष्ट सांगा...';
	@override String get warriorRedemption => 'प्रायश्चित्त शोधणाऱ्या योद्ध्याची एक भव्य कथा लिहा...';
	@override String get sageWisdom => 'ऋषींच्या ज्ञानाबद्दल एक कथा तयार करा...';
	@override String get devotedSeeker => 'भक्त साधकाच्या प्रवासाचे वर्णन करा...';
	@override String get divineIntervention => 'दिव्य हस्तक्षेपाबद्दलची दंतकथा शेअर करा...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsMr extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'कृपया सर्व आवश्यक पर्याय पूर्ण करा';
	@override String get generationFailed => 'कथा तयार करण्यात अयशस्वी. पुन्हा प्रयत्न करा.';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsMr extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  नमस्कार!';
	@override String get dharma => '📖  धर्म म्हणजे काय?';
	@override String get stress => '🧘  ताण कसा हाताळावा';
	@override String get karma => '⚡  कर्म सोप्या भाषेत समजावून सांगा';
	@override String get story => '💬  मला एक गोष्ट सांगा';
	@override String get wisdom => '🌟  आजचे ज्ञान';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsMr extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

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
class _TranslationsMapDiscussionsMr extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'चर्चा पोस्ट करा';
	@override String get intentCardCta => 'एक चर्चा पोस्ट करा';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapMr extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapMr extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapMr extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

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
class _TranslationsMapFoodMapMr extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

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
class _TranslationsFeedTabsMr extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get all => 'सर्व';
	@override String get stories => 'कथा';
	@override String get posts => 'पोस्ट्स';
	@override String get videos => 'व्हिडिओ';
	@override String get images => 'फोटो';
	@override String get text => 'विचार';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileMr extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'प्रोफाइल संपादित करा';
	@override String get displayName => 'दर्शविलेले नाव';
	@override String get displayNameHint => 'तुमचे दर्शविलेले नाव लिहा';
	@override String get displayNameEmpty => 'दर्शविलेले नाव रिक्त असू शकत नाही';
	@override String get bio => 'परिचय';
	@override String get bioHint => 'आम्हाला तुमच्याबद्दल सांगा...';
	@override String get changePhoto => 'प्रोफाइल फोटो बदला';
	@override String get saveChanges => 'बदल जतन करा';
	@override String get profileUpdated => 'प्रोफाइल यशस्वीरीत्या अद्ययावत केले';
	@override String get profileAndPhotoUpdated => 'प्रोफाइल आणि फोटो यशस्वीरीत्या अद्ययावत केले';
	@override String failedPickImage({required Object error}) => 'चित्र निवडण्यात अयशस्वी: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'फोटो अपलोड करण्यात अयशस्वी: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'प्रोफाइल अद्ययावत करण्यात अयशस्वी: ${error}';
	@override String unexpectedError({required Object error}) => 'अप्रत्याशित त्रुटी: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostMr extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get title => 'पोस्ट तयार करा';
	@override String get post => 'पोस्ट करा';
	@override String get text => 'मजकूर';
	@override String get image => 'चित्र';
	@override String get video => 'व्हिडिओ';
	@override String get textHint => 'तुमच्या मनात काय आहे?';
	@override String get imageCaptionHint => 'तुमच्या चित्रासाठी कॅप्शन लिहा...';
	@override String get videoCaptionHint => 'तुमच्या व्हिडिओचे वर्णन करा...';
	@override String get shareCaptionHint => 'तुमचे विचार जोडा...';
	@override String get titleHint => 'शीर्षक जोडा (ऐच्छिक)';
	@override String get selectVideo => 'व्हिडिओ निवडा';
	@override String get gallery => 'गॅलरी';
	@override String get camera => 'कॅमेरा';
	@override String get visibility => 'हे कोण पाहू शकेल?';
	@override String get public => 'सार्वजनिक';
	@override String get followers => 'फॉलोअर्स';
	@override String get private => 'खाजगी';
	@override String get postCreated => 'पोस्ट तयार झाली!';
	@override String get failedPickImages => 'चित्रे निवडण्यात अयशस्वी';
	@override String get failedPickVideo => 'व्हिडिओ निवडण्यात अयशस्वी';
	@override String get failedCapturePhoto => 'फोटो घेण्यात अयशस्वी';
	@override String get cannotCreateOffline => 'ऑफलाइन असताना पोस्ट तयार करू शकत नाही';
	@override String get discardTitle => 'पोस्ट रद्द करायची?';
	@override String get discardMessage => 'तुमच्याकडे न जतन केलेले बदल आहेत. तुम्ही नक्की ही पोस्ट रद्द करू इच्छिता का?';
	@override String get keepEditing => 'संपादन सुरू ठेवा';
	@override String get discard => 'रद्द करा';
	@override String get cropPhoto => 'चित्र क्रॉप करा';
	@override String get trimVideo => 'व्हिडिओ ट्रिम करा';
	@override String get editPhoto => 'चित्र संपादित करा';
	@override String get editVideo => 'व्हिडिओ संपादित करा';
	@override String get maxDuration => 'कमाल ३० सेकंद';
	@override String get aspectSquare => 'चौरस';
	@override String get aspectPortrait => 'उभा';
	@override String get aspectLandscape => 'आडवा';
	@override String get aspectFree => 'मुक्त';
	@override String get failedCrop => 'चित्र क्रॉप करण्यात अयशस्वी';
	@override String get failedTrim => 'व्हिडिओ ट्रिम करण्यात अयशस्वी';
	@override String get trimmingVideo => 'व्हिडिओ ट्रिम केला जात आहे...';
	@override String trimVideoSubtitle({required Object max}) => 'कमाल ${max}से · तुमचा सर्वोत्तम भाग निवडा';
	@override String get trimVideoInstructionsTitle => 'तुमची क्लिप ट्रिम करा';
	@override String get trimVideoInstructionsBody => 'सुरुवात आणि शेवटचे हँडल ओढून 30 सेकंदांपर्यंतचा भाग निवडा.';
	@override String get trimStart => 'सुरुवात';
	@override String get trimEnd => 'शेवट';
	@override String get trimSelectionEmpty => 'पुढे जाण्यासाठी वैध रेंज निवडा';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}से निवडले (${start}–${end}) · कमाल ${max}से';
	@override String get coverFrame => 'कव्हर फ्रेम';
	@override String get coverFrameUnavailable => 'पूर्वावलोकन उपलब्ध नाही';
	@override String coverFramePosition({required Object time}) => '${time} ला कव्हर';
	@override String get overlayLabel => 'व्हिडिओवर मजकूर (ऐच्छिक)';
	@override String get overlayHint => 'लहान हुक किंवा शीर्षक जोडा';
	@override String get imageSectionHint => 'गॅलरी किंवा कॅमेरातून जास्तीत जास्त १० फोटो जोडा';
	@override String get videoSectionHint => 'एक व्हिडिओ, कमाल ३० सेकंद';
	@override String get removePhoto => 'चित्र काढून टाका';
	@override String get removeVideo => 'व्हिडिओ काढून टाका';
	@override String get photoEditHint => 'क्रॉप किंवा काढण्यासाठी चित्रावर टॅप करा';
	@override String get videoEditOptions => 'संपादन पर्याय';
	@override String get addPhoto => 'चित्र जोडा';
	@override String get done => 'पूर्ण';
	@override String get rotate => 'फिरवा';
	@override String get editPhotoSubtitle => 'फीडमध्ये चांगले दिसण्यासाठी चौरस आकारात क्रॉप करा';
	@override String get videoEditorCaptionLabel => 'कॅप्शन / मजकूर (पर्यायी)';
	@override String get videoEditorCaptionHint => 'उदा. तुमच्या रीलसाठी शीर्षक किंवा हुक';
	@override String get videoEditorAspectLabel => 'अनुपात';
	@override String get videoEditorAspectOriginal => 'मूळ';
	@override String get videoEditorAspectSquare => '१:१';
	@override String get videoEditorAspectPortrait => '९:१६';
	@override String get videoEditorAspectLandscape => '१६:९';
	@override String get videoEditorQuickTrim => 'जलद ट्रिम';
	@override String get videoEditorSpeed => 'वेग';
}

// Path: social.comments
class _TranslationsSocialCommentsMr extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} यांना उत्तर देत आहात';
	@override String replyHint({required Object name}) => '${name} यांना उत्तर लिहा...';
	@override String failedToPost({required Object error}) => 'टिप्पणी पोस्ट करण्यात अयशस्वी: ${error}';
	@override String get cannotPostOffline => 'ऑफलाइन असताना टिप्पणी पोस्ट करू शकत नाही';
	@override String get noComments => 'अजून कोणतीही टिप्पणी नाही';
	@override String get beFirst => 'पहिली टिप्पणी तुम्ही करा!';
}

// Path: social.engagement
class _TranslationsSocialEngagementMr extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'ऑफलाइन मोड';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryMr extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'एआय कथा निर्मिती';
	@override String get headline => 'रम्य\nकथा\nतयार करा';
	@override String get subHeadline => 'प्राचीन ज्ञानाच्या बळावर';
	@override String get line1 => '✦  एखादे पवित्र शास्त्र निवडा...';
	@override String get line2 => '✦  जिवंत पार्श्वभूमी निवडा...';
	@override String get line3 => '✦  एआयला मोहक कथा विणू द्या...';
	@override String get cta => 'कथा तयार करा';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionMr extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'आध्यात्मिक सोबती';
	@override String get headline => 'तुमचा दिव्य\nमार्गदर्शक,\nनेहमी जवळ';
	@override String get subHeadline => 'कृष्णाच्या ज्ञानातून प्रेरित';
	@override String get line1 => '✦  खऱ्या अर्थाने ऐकणारा मित्र...';
	@override String get line2 => '✦  जीवनातील संघर्षांसाठी ज्ञान...';
	@override String get line3 => '✦  तुम्हाला उभारी देणाऱ्या गप्पा...';
	@override String get cta => 'चॅट सुरू करा';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageMr extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'वारसा नकाशा';
	@override String get headline => 'कालातीत\nवारसा\nशोधा';
	@override String get subHeadline => '5000+ पवित्र स्थळे नकाशात';
	@override String get line1 => '✦  पवित्र ठिकाणे शोधा...';
	@override String get line2 => '✦  इतिहास आणि लोककथा वाचा...';
	@override String get line3 => '✦  अर्थपूर्ण प्रवासाचे नियोजन करा...';
	@override String get cta => 'नकाशा पाहा';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityMr extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'समुदाय मंच';
	@override String get headline => 'संस्कृती\nजगाशी\nसामायिक करा';
	@override String get subHeadline => 'एक जिवंत जागतिक समुदाय';
	@override String get line1 => '✦  पोस्ट्स आणि सखोल चर्चा...';
	@override String get line2 => '✦  लघु सांस्कृतिक व्हिडिओ...';
	@override String get line3 => '✦  जगभरातील कथा...';
	@override String get cta => 'समुदायात सामील व्हा';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesMr extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesMr._(TranslationsMr root) : this._root = root, super.internal(root);

	final TranslationsMr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'खाजगी संदेश';
	@override String get headline => 'अर्थपूर्ण\nसंवाद\nइथून सुरू होतो';
	@override String get subHeadline => 'खाजगी आणि विचारपूर्ण जागा';
	@override String get line1 => '✦  समान विचारांच्या लोकांशी जुळा...';
	@override String get line2 => '✦  कल्पना आणि कथा चर्चा करा...';
	@override String get line3 => '✦  विचारशील समुदाय उभारा...';
	@override String get cta => 'संदेश उघडा';
}
