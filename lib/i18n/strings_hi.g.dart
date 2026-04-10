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
class TranslationsHi extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsHi({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.hi,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <hi>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsHi _root = this; // ignore: unused_field

	@override 
	TranslationsHi $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsHi(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppHi app = _TranslationsAppHi._(_root);
	@override late final _TranslationsCommonHi common = _TranslationsCommonHi._(_root);
	@override late final _TranslationsNavigationHi navigation = _TranslationsNavigationHi._(_root);
	@override late final _TranslationsHomeHi home = _TranslationsHomeHi._(_root);
	@override late final _TranslationsStoriesHi stories = _TranslationsStoriesHi._(_root);
	@override late final _TranslationsStoryGeneratorHi storyGenerator = _TranslationsStoryGeneratorHi._(_root);
	@override late final _TranslationsChatHi chat = _TranslationsChatHi._(_root);
	@override late final _TranslationsMapHi map = _TranslationsMapHi._(_root);
	@override late final _TranslationsCommunityHi community = _TranslationsCommunityHi._(_root);
	@override late final _TranslationsDiscoverHi discover = _TranslationsDiscoverHi._(_root);
	@override late final _TranslationsPlanHi plan = _TranslationsPlanHi._(_root);
	@override late final _TranslationsSettingsHi settings = _TranslationsSettingsHi._(_root);
	@override late final _TranslationsAuthHi auth = _TranslationsAuthHi._(_root);
	@override late final _TranslationsErrorHi error = _TranslationsErrorHi._(_root);
	@override late final _TranslationsSubscriptionHi subscription = _TranslationsSubscriptionHi._(_root);
	@override late final _TranslationsNotificationHi notification = _TranslationsNotificationHi._(_root);
	@override late final _TranslationsProfileHi profile = _TranslationsProfileHi._(_root);
	@override late final _TranslationsFeedHi feed = _TranslationsFeedHi._(_root);
	@override late final _TranslationsSocialHi social = _TranslationsSocialHi._(_root);
	@override late final _TranslationsVoiceHi voice = _TranslationsVoiceHi._(_root);
	@override late final _TranslationsFestivalsHi festivals = _TranslationsFestivalsHi._(_root);
	@override late final _TranslationsHomeScreenHi homeScreen = _TranslationsHomeScreenHi._(_root);
}

// Path: app
class _TranslationsAppHi extends TranslationsAppEn {
	_TranslationsAppHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get name => 'मायइतिहास';
	@override String get tagline => 'भारतीय शास्त्र खोजें';
}

// Path: common
class _TranslationsCommonHi extends TranslationsCommonEn {
	_TranslationsCommonHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ठीक है';
	@override String get cancel => 'रद्द करें';
	@override String get confirm => 'पुष्टि करें';
	@override String get delete => 'हटाएं';
	@override String get edit => 'संपादित करें';
	@override String get save => 'सहेजें';
	@override String get share => 'साझा करें';
	@override String get search => 'खोजें';
	@override String get loading => 'लोड हो रहा है...';
	@override String get error => 'त्रुटि';
	@override String get retry => 'पुनः प्रयास करें';
	@override String get back => 'वापस';
	@override String get next => 'अगला';
	@override String get finish => 'समाप्त';
	@override String get skip => 'छोड़ें';
	@override String get yes => 'हां';
	@override String get no => 'नहीं';
	@override String get readFullStory => 'पूरी कहानी पढ़ें';
	@override String get dismiss => 'खारिज करें';
	@override String get offlineBannerMessage => 'आप ऑफ़लाइन हैं – कैश की गई सामग्री देख रहे हैं';
	@override String get backOnline => 'वापस ऑनलाइन';
}

// Path: navigation
class _TranslationsNavigationHi extends TranslationsNavigationEn {
	_TranslationsNavigationHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get home => 'अन्वेषण';
	@override String get stories => 'कहानियां';
	@override String get chat => 'चैट';
	@override String get map => 'मानचित्र';
	@override String get community => 'सामाजिक';
	@override String get settings => 'सेटिंग्स';
	@override String get profile => 'प्रोफाइल';
}

// Path: home
class _TranslationsHomeHi extends TranslationsHomeEn {
	_TranslationsHomeHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'मायइतिहास';
	@override String get storyGenerator => 'कहानी जनरेटर';
	@override String get chatItihas => 'चैटइतिहास';
	@override String get communityStories => 'सामुदायिक कहानियां';
	@override String get maps => 'मानचित्र';
	@override String get greetingMorning => 'सुप्रभात';
	@override String get continueReading => 'पढ़ना जारी रखें';
	@override String get greetingAfternoon => 'नमस्कार';
	@override String get greetingEvening => 'शुभ संध्या';
	@override String get greetingNight => 'शुभ रात्रि';
	@override String get exploreStories => 'कहानियां खोजें';
	@override String get generateStory => 'कहानी बनाएं';
	@override String get content => 'होम सामग्री';
}

// Path: stories
class _TranslationsStoriesHi extends TranslationsStoriesEn {
	_TranslationsStoriesHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'कहानियां';
	@override String get searchHint => 'शीर्षक या लेखक से खोजें...';
	@override String get sortBy => 'क्रमबद्ध करें';
	@override String get sortNewest => 'नवीनतम पहले';
	@override String get sortOldest => 'पुरानी पहले';
	@override String get sortPopular => 'सबसे लोकप्रिय';
	@override String get noStories => 'कोई कहानी नहीं मिली';
	@override String get loadingStories => 'कहानियां लोड हो रही हैं...';
	@override String get errorLoadingStories => 'कहानियां लोड करने में विफल';
	@override String get storyDetails => 'कहानी विवरण';
	@override String get continueReading => 'पढ़ना जारी रखें';
	@override String get readMore => 'और पढ़ें';
	@override String get readLess => 'कम पढ़ें';
	@override String get author => 'लेखक';
	@override String get publishedOn => 'प्रकाशित';
	@override String get category => 'श्रेणी';
	@override String get tags => 'टैग';
	@override String get failedToLoad => 'कहानी लोड करने में विफल';
	@override String get subtitle => 'शास्त्रों की कथाएं खोजें';
	@override String get noStoriesHint => 'कहानियां खोजने के लिए अलग खोज या फ़िल्टर आज़माएं।';
	@override String get featured => 'विशेष';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorHi extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'कहानी जनरेटर';
	@override String get subtitle => 'अपनी पौराणिक कहानी बनाएं';
	@override String get quickStart => 'त्वरित प्रारंभ';
	@override String get interactive => 'इंटरैक्टिव';
	@override String get rawPrompt => 'कच्चा प्रॉम्प्ट';
	@override String get yourStoryPrompt => 'आपका कहानी प्रॉम्प्ट';
	@override String get writeYourPrompt => 'अपना प्रॉम्प्ट लिखें';
	@override String get selectScripture => 'शास्त्र चुनें';
	@override String get selectStoryType => 'कहानी प्रकार चुनें';
	@override String get selectCharacter => 'पात्र चुनें';
	@override String get selectTheme => 'विषय चुनें';
	@override String get selectSetting => 'स्थान चुनें';
	@override String get selectLanguage => 'भाषा चुनें';
	@override String get selectLength => 'कहानी की लंबाई';
	@override String get moreOptions => 'अधिक विकल्प';
	@override String get random => 'यादृच्छिक';
	@override String get generate => 'कहानी बनाएं';
	@override String get generating => 'आपकी कहानी बन रही है...';
	@override String get creatingYourStory => 'आपकी कहानी बनाई जा रही है';
	@override String get consultingScriptures => 'प्राचीन शास्त्रों से परामर्श...';
	@override String get weavingTale => 'आपकी कथा बुनी जा रही है...';
	@override String get addingWisdom => 'दिव्य ज्ञान जोड़ रहे हैं...';
	@override String get polishingNarrative => 'कथा को निखारा जा रहा है...';
	@override String get almostThere => 'लगभग हो गया...';
	@override String get generatedStory => 'आपकी बनाई कहानी';
	@override String get aiGenerated => 'AI निर्मित';
	@override String get regenerate => 'फिर से बनाएं';
	@override String get saveStory => 'कहानी सहेजें';
	@override String get shareStory => 'कहानी साझा करें';
	@override String get newStory => 'नई कहानी';
	@override String get saved => 'सहेजा गया';
	@override String get storySaved => 'कहानी आपकी लाइब्रेरी में सहेजी गई';
	@override String get story => 'कहानी';
	@override String get lesson => 'सीख';
	@override String get didYouKnow => 'क्या आप जानते हैं?';
	@override String get activity => 'गतिविधि';
	@override String get optionalRefine => 'वैकल्पिक: विकल्पों से परिष्कृत करें';
	@override String get applyOptions => 'विकल्प लागू करें';
	@override String get language => 'भाषा';
	@override String get storyFormat => 'कहानी प्रारूप';
	@override String get aiDisclaimer => 'AI गलतियाँ कर सकता है। हम सुधार कर रहे हैं और आपकी प्रतिक्रिया मायने रखती है।';
	@override late final _TranslationsStoryGeneratorStoryLengthHi storyLength = _TranslationsStoryGeneratorStoryLengthHi._(_root);
	@override late final _TranslationsStoryGeneratorFormatHi format = _TranslationsStoryGeneratorFormatHi._(_root);
	@override late final _TranslationsStoryGeneratorHintsHi hints = _TranslationsStoryGeneratorHintsHi._(_root);
	@override late final _TranslationsStoryGeneratorErrorsHi errors = _TranslationsStoryGeneratorErrorsHi._(_root);
	@override String get requiresInternet => 'कहानी बनाने के लिए इंटरनेट कनेक्शन की आवश्यकता है';
	@override String get notAvailableOffline => 'कहानी ऑफ़लाइन उपलब्ध नहीं है। देखने के लिए इंटरनेट से कनेक्ट करें।';
}

// Path: chat
class _TranslationsChatHi extends TranslationsChatEn {
	_TranslationsChatHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'चैटइतिहास';
	@override String get subtitle => 'शास्त्रों के बारे में AI से चैट करें';
	@override String get friendMode => 'मित्र मोड';
	@override String get philosophicalMode => 'दार्शनिक मोड';
	@override String get typeMessage => 'अपना संदेश लिखें...';
	@override String get send => 'भेजें';
	@override String get newChat => 'नई चैट';
	@override String get chatsTab => 'चैट';
	@override String get groupsTab => 'ग्रुप';
	@override String get chatHistory => 'चैट इतिहास';
	@override String get clearChat => 'चैट साफ़ करें';
	@override String get noMessages => 'अभी तक कोई संदेश नहीं। बातचीत शुरू करें!';
	@override String get listPage => 'चैट सूची पृष्ठ';
	@override String get forwardMessageTo => 'संदेश को यहां भेजें...';
	@override String get forwardMessage => 'संदेश अग्रेषित करें';
	@override String get messageForwarded => 'संदेश अग्रेषित किया गया';
	@override String failedToForward({required Object error}) => 'संदेश अग्रेषित करने में विफल: ${error}';
	@override String get searchChats => 'चैट खोजें';
	@override String get noChatsFound => 'कोई चैट नहीं मिली';
	@override String get requests => 'अनुरोध';
	@override String get messageRequests => 'संदेश अनुरोध';
	@override String get groupRequests => 'ग्रुप अनुरोध';
	@override String get requestSent => 'अनुरोध भेज दिया। वे इसे अनुरोध में देखेंगे।';
	@override String get wantsToChat => 'चैट करना चाहते हैं';
	@override String addedYouTo({required Object name}) => '${name} ने आपको जोड़ा';
	@override String get accept => 'स्वीकार करें';
	@override String get noMessageRequests => 'कोई संदेश अनुरोध नहीं';
	@override String get noGroupRequests => 'कोई ग्रुप अनुरोध नहीं';
	@override String get invitesSent => 'निमंत्रण भेज दिए। वे अनुरोध में देखेंगे।';
	@override String get cantMessageUser => 'आप इस उपयोगकर्ता को संदेश नहीं भेज सकते';
	@override String get deleteChat => 'चैट हटाएं';
	@override String get deleteChats => 'चैट हटाएं';
	@override String get blockUser => 'उपयोगकर्ता को ब्लॉक करें';
	@override String get reportUser => 'उपयोगकर्ता की रिपोर्ट करें';
	@override String get markAsRead => 'पढ़ा हुआ मार्क करें';
	@override String get markedAsRead => 'पढ़ा हुआ मार्क किया गया';
	@override String get deleteClearChat => 'चैट हटाएं / साफ़ करें';
	@override String get deleteConversation => 'बातचीत हटाएं';
	@override String get reasonRequired => 'कारण (आवश्यक)';
	@override String get submit => 'जमा करें';
	@override String get userReportedBlocked => 'उपयोगकर्ता की रिपोर्ट की गई। उन्हें ब्लॉक कर दिया गया है।';
	@override String reportFailed({required Object error}) => 'रिपोर्ट करने में विफल: ${error}';
	@override String get newGroup => 'नया ग्रुप';
	@override String get messageSomeoneDirectly => 'किसी को सीधे संदेश भेजें';
	@override String get createGroupConversation => 'ग्रुप बातचीत बनाएं';
	@override String get noGroupsYet => 'अभी तक कोई ग्रुप नहीं';
	@override String get noChatsYet => 'अभी तक कोई चैट नहीं';
	@override String get tapToCreateGroup => 'ग्रुप बनाने या जोड़ने के लिए + टैप करें';
	@override String get tapToStartConversation => 'नई बातचीत शुरू करने के लिए + टैप करें';
	@override String get conversationDeleted => 'बातचीत हटा दी गई';
	@override String conversationsDeleted({required Object count}) => '${count} बातचीत(एं) हटाई गई';
	@override String get searchConversations => 'बातचीत खोजें...';
	@override String get connectToInternet => 'कृपया इंटरनेट से कनेक्ट करें और पुनः प्रयास करें।';
	@override String get littleKrishnaName => 'बाल कृष्ण';
	@override String get newConversation => 'नई बातचीत';
	@override String get noConversationsYet => 'अभी तक कोई बातचीत नहीं';
	@override String get confirmDeletion => 'हटाने की पुष्टि करें';
	@override String deleteConversationConfirm({required Object title}) => 'क्या आप वाकई ${title} हटाना चाहते हैं?';
	@override String get deleteFailed => 'बातचीत हटाने में विफल';
	@override String get fullChatCopied => 'पूरी चैट क्लिपबोर्ड पर कॉपी हो गई!';
	@override String get connectionErrorFallback => 'अभी कनेक्ट होने में दिक्कत हो रही है। कृपया थोड़ी देर बाद पुनः प्रयास करें।';
	@override String krishnaWelcomeWithName({required Object name}) => 'नमस्ते, ${name}। मैं कृष्ण, आपका मित्र। आज आप कैसे हैं?';
	@override String get krishnaWelcomeFriend => 'नमस्ते, मेरे प्रिय मित्र। मैं कृष्ण, आपका मित्र। आज आप कैसे हैं?';
	@override String get copyYouLabel => 'आप';
	@override String get copyKrishnaLabel => 'कृष्ण';
	@override late final _TranslationsChatSuggestionsHi suggestions = _TranslationsChatSuggestionsHi._(_root);
	@override String get about => 'के बारे में';
	@override String get yourFriendlyCompanion => 'आपका मित्रवत साथी';
	@override String get mentalHealthSupport => 'मानसिक स्वास्थ्य सहायता';
	@override String get mentalHealthSupportSubtitle => 'विचार साझा करने और सुने जाने के लिए एक सुरक्षित जगह।';
	@override String get friendlyCompanion => 'मित्रवत साथी';
	@override String get friendlyCompanionSubtitle => 'हमेशा बात करने, प्रोत्साहित करने और ज्ञान देने के लिए यहां।';
	@override String get storiesAndWisdom => 'कहानियां और ज्ञान';
	@override String get storiesAndWisdomSubtitle => 'कालातीत कथाओं और व्यावहारिक ज्ञान से सीखें।';
	@override String get askAnything => 'कुछ भी पूछें';
	@override String get askAnythingSubtitle => 'अपने सवालों के कोमल, विचारशील जवाब पाएं।';
	@override String get startChatting => 'चैट शुरू करें';
	@override String get maybeLater => 'बाद में';
	@override late final _TranslationsChatComposerAttachmentsHi composerAttachments = _TranslationsChatComposerAttachmentsHi._(_root);
}

// Path: map
class _TranslationsMapHi extends TranslationsMapEn {
	_TranslationsMapHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'अखंड भारत';
	@override String get subtitle => 'ऐतिहासिक स्थानों का अन्वेषण करें';
	@override String get searchLocation => 'स्थान खोजें...';
	@override String get viewDetails => 'विवरण देखें';
	@override String get viewSites => 'स्थल देखें';
	@override String get showRoute => 'मार्ग दिखाएं';
	@override String get historicalInfo => 'ऐतिहासिक जानकारी';
	@override String get nearbyPlaces => 'निकटवर्ती स्थान';
	@override String get pickLocationOnMap => 'मानचित्र पर स्थान चुनें';
	@override String get sitesVisited => 'देखे गए स्थल';
	@override String get badgesEarned => 'अर्जित बैज';
	@override String get completionRate => 'पूर्णता दर';
	@override String get addToJourney => 'यात्रा में जोड़ें';
	@override String get addedToJourney => 'यात्रा में जोड़ा गया';
	@override String get getDirections => 'मार्ग देखें';
	@override String get viewInMap => 'मानचित्र में देखें';
	@override String get directions => 'मार्ग';
	@override String get photoGallery => 'फोटो गैलरी';
	@override String get viewAll => 'सभी देखें';
	@override String get photoSavedToGallery => 'फोटो गैलरी में सहेजा गया';
	@override String get sacredSoundscape => 'पवित्र ध्वनि';
	@override String get allDiscussions => 'सभी चर्चाएं';
	@override String get journeyTab => 'यात्रा';
	@override String get discussionTab => 'चर्चा';
	@override String get myActivity => 'मेरी गतिविधि';
	@override String get anonymousPilgrim => 'अनाम तीर्थयात्री';
	@override String get viewProfile => 'प्रोफाइल देखें';
	@override String get discussionTitleHint => 'चर्चा का शीर्षक...';
	@override String get shareYourThoughtsHint => 'अपने विचार साझा करें...';
	@override String get pleaseEnterDiscussionTitle => 'कृपया चर्चा का शीर्षक दर्ज करें';
	@override String get addReflection => 'प्रतिबिंब जोड़ें';
	@override String get reflectionTitle => 'शीर्षक';
	@override String get enterReflectionTitle => 'प्रतिबिंब शीर्षक दर्ज करें';
	@override String get pleaseEnterTitle => 'कृपया शीर्षक दर्ज करें';
	@override String get siteName => 'स्थल का नाम';
	@override String get enterSacredSiteName => 'पवित्र स्थल का नाम दर्ज करें';
	@override String get pleaseEnterSiteName => 'कृपया स्थल का नाम दर्ज करें';
	@override String get reflection => 'प्रतिबिंब';
	@override String get reflectionHint => 'अपने विचार और अनुभव साझा करें...';
	@override String get pleaseEnterReflection => 'कृपया अपना प्रतिबिंब दर्ज करें';
	@override String get saveReflection => 'प्रतिबिंब सहेजें';
	@override String get journeyProgress => 'यात्रा की प्रगति';
	@override late final _TranslationsMapDiscussionsHi discussions = _TranslationsMapDiscussionsHi._(_root);
	@override late final _TranslationsMapFabricMapHi fabricMap = _TranslationsMapFabricMapHi._(_root);
	@override late final _TranslationsMapClassicalArtMapHi classicalArtMap = _TranslationsMapClassicalArtMapHi._(_root);
	@override late final _TranslationsMapClassicalDanceMapHi classicalDanceMap = _TranslationsMapClassicalDanceMapHi._(_root);
	@override late final _TranslationsMapFoodMapHi foodMap = _TranslationsMapFoodMapHi._(_root);
}

// Path: community
class _TranslationsCommunityHi extends TranslationsCommunityEn {
	_TranslationsCommunityHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'समुदाय';
	@override String get trending => 'ट्रेंडिंग';
	@override String get following => 'फॉलोइंग';
	@override String get followers => 'फॉलोवर्स';
	@override String get posts => 'पोस्ट';
	@override String get follow => 'फॉलो करें';
	@override String get unfollow => 'अनफॉलो करें';
	@override String get shareYourStory => 'अपनी कहानी साझा करें...';
	@override String get post => 'पोस्ट करें';
	@override String get like => 'पसंद';
	@override String get comment => 'टिप्पणी';
	@override String get comments => 'टिप्पणियां';
	@override String get noPostsYet => 'अभी तक कोई पोस्ट नहीं';
}

// Path: discover
class _TranslationsDiscoverHi extends TranslationsDiscoverEn {
	_TranslationsDiscoverHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'खोजें';
	@override String get searchHint => 'कहानियां, उपयोगकर्ता या विषय खोजें...';
	@override String get tryAgain => 'पुनः प्रयास करें';
	@override String get somethingWentWrong => 'कुछ गलत हो गया';
	@override String get unableToLoadProfiles => 'प्रोफाइल लोड करने में असमर्थ। कृपया पुनः प्रयास करें।';
	@override String get noProfilesFound => 'कोई प्रोफाइल नहीं मिली';
	@override String get searchToFindPeople => 'फॉलो करने के लिए लोग खोजें';
	@override String get noResultsFound => 'कोई परिणाम नहीं मिला';
	@override String get noProfilesYet => 'अभी तक कोई प्रोफाइल नहीं';
	@override String get tryDifferentKeywords => 'अलग कीवर्ड से खोजें';
	@override String get beFirstToDiscover => 'नए लोगों को खोजने वाले पहले बनें!';
}

// Path: plan
class _TranslationsPlanHi extends TranslationsPlanEn {
	_TranslationsPlanHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'अपनी योजना सहेजने के लिए साइन इन करें';
	@override String get planSaved => 'योजना सहेजी गई';
	@override String get from => 'कहाँ से';
	@override String get dates => 'तारीखें';
	@override String get destination => 'गंतव्य';
	@override String get nearby => 'निकट';
	@override String get generatedPlan => 'बनाई गई योजना';
	@override String get whereTravellingFrom => 'आप कहाँ से यात्रा कर रहे हैं?';
	@override String get enterCityOrRegion => 'अपना शहर या क्षेत्र दर्ज करें';
	@override String get travelDates => 'यात्रा की तारीखें';
	@override String get destinationSacredSite => 'गंतव्य (पवित्र स्थल)';
	@override String get searchOrSelectDestination => 'गंतव्य खोजें या चुनें...';
	@override String get shareYourExperience => 'अपना अनुभव साझा करें';
	@override String get planShared => 'योजना साझा की गई';
	@override String failedToSharePlan({required Object error}) => 'योजना साझा करने में विफल: ${error}';
	@override String get planUpdated => 'योजना अपडेट की गई';
	@override String failedToUpdatePlan({required Object error}) => 'योजना अपडेट करने में विफल: ${error}';
	@override String get deletePlanConfirm => 'योजना हटाएं?';
	@override String get thisPlanPermanentlyDeleted => 'यह योजना स्थायी रूप से हटा दी जाएगी।';
	@override String get planDeleted => 'योजना हटा दी गई';
	@override String failedToDeletePlan({required Object error}) => 'योजना हटाने में विफल: ${error}';
	@override String get sharePlan => 'योजना साझा करें';
	@override String get deletePlan => 'योजना हटाएं';
	@override String get savedPlanDetails => 'सहेजी गई योजना का विवरण';
	@override String get quickBookings => 'त्वरित बुकिंग';
	@override String get replanWithAi => 'AI के साथ फिर से योजना बनाएं';
	@override String get fullRegenerate => 'पूरी तरह नई योजना';
	@override String get surgicalModify => 'चुने हुए हिस्से बदलें';
	@override String get travelModeTrain => 'ट्रेन';
	@override String get travelModeFlight => 'फ्लाइट';
	@override String get travelModeBus => 'बस';
	@override String get travelModeHotel => 'होटल';
	@override String get travelModeCar => 'कार';
	@override String get pilgrimagePlan => 'तीर्थ यात्रा योजना';
	@override String get planTab => 'योजना';
}

// Path: settings
class _TranslationsSettingsHi extends TranslationsSettingsEn {
	_TranslationsSettingsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'सेटिंग्स';
	@override String get language => 'भाषा';
	@override String get theme => 'थीम';
	@override String get themeLight => 'लाइट';
	@override String get themeDark => 'डार्क';
	@override String get themeSystem => 'सिस्टम थीम का उपयोग करें';
	@override String get darkMode => 'डार्क मोड';
	@override String get selectLanguage => 'भाषा चुनें';
	@override String get notifications => 'सूचनाएं';
	@override String get cacheSettings => 'कैश और स्टोरेज';
	@override String get blockedUsers => 'ब्लॉक्ड यूजर';
	@override String get helpSupport => 'मदद और सहायता';
	@override String get contactUs => 'संपर्क करें';
	@override String get legal => 'कानूनी';
	@override String get privacyPolicy => 'गोपनीयता नीति';
	@override String get termsConditions => 'नियम और शर्तें';
	@override String get general => 'सामान्य';
	@override String get account => 'खाता';
	@override String get privacy => 'गोपनीयता';
	@override String get about => 'हमारे बारे में';
	@override String get version => 'संस्करण';
	@override String get logout => 'लॉग आउट';
	@override String get deleteAccount => 'खाता हटाएं';
	@override String get deleteAccountTitle => 'खाता हटाएं';
	@override String get deleteAccountWarning => 'यह क्रिया वापस नहीं की जा सकती!';
	@override String get deleteAccountDescription => 'खाता हटाने से आपके सभी पोस्ट, टिप्पणियां, प्रोफाइल, फॉलोवर्स, सहेजी गई कहानियां, बुकमार्क, चैट संदेश और बनाई गई कहानियां स्थायी रूप से हटा दी जाएंगी।';
	@override String get confirmPassword => 'अपना पासवर्ड पुष्टि करें';
	@override String get confirmPasswordDesc => 'खाता हटाने की पुष्टि के लिए अपना पासवर्ड दर्ज करें।';
	@override String get googleReauth => 'आपकी पहचान सत्यापित करने के लिए आपको Google पर पुनर्निर्देशित किया जाएगा।';
	@override String get finalConfirmationTitle => 'अंतिम पुष्टि';
	@override String get finalConfirmation => 'क्या आप पूरी तरह निश्चित हैं? यह स्थायी है और इसे वापस नहीं किया जा सकता।';
	@override String get deleteMyAccount => 'मेरा खाता हटाएं';
	@override String get deletingAccount => 'खाता हटाया जा रहा है...';
	@override String get accountDeleted => 'आपका खाता स्थायी रूप से हटा दिया गया है।';
	@override String get deleteAccountFailed => 'खाता हटाने में विफल। कृपया पुनः प्रयास करें।';
	@override String get downloadedStories => 'डाउनलोड की गई कहानियां';
	@override String get couldNotOpenEmail => 'ईमेल ऐप नहीं खोल सके। कृपया हमें ईमेल करें: myitihas@gmail.com';
	@override String couldNotOpenLabel({required Object label}) => '${label} अभी नहीं खोल सके।';
	@override String get logoutTitle => 'लॉग आउट';
	@override String get logoutConfirm => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';
	@override String get verifyYourIdentity => 'अपनी पहचान सत्यापित करें';
	@override String get verifyYourIdentityDesc => 'पहचान सत्यापित करने के लिए आपसे Google से साइन इन करने के लिए कहा जाएगा।';
	@override String get continueWithGoogle => 'Google के साथ जारी रखें';
	@override String reauthFailed({required Object error}) => 'पुनः प्रमाणीकरण विफल: ${error}';
	@override String get passwordRequired => 'पासवर्ड आवश्यक है';
	@override String get invalidPassword => 'गलत पासवर्ड। कृपया पुनः प्रयास करें।';
	@override String get verify => 'सत्यापित करें';
	@override String get continueLabel => 'जारी रखें';
	@override String get unableToVerifyIdentity => 'पहचान सत्यापित करने में असमर्थ। कृपया पुनः प्रयास करें।';
}

// Path: auth
class _TranslationsAuthHi extends TranslationsAuthEn {
	_TranslationsAuthHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get login => 'लॉगिन';
	@override String get signup => 'साइन अप';
	@override String get email => 'ईमेल';
	@override String get password => 'पासवर्ड';
	@override String get confirmPassword => 'पासवर्ड की पुष्टि करें';
	@override String get forgotPassword => 'पासवर्ड भूल गए?';
	@override String get resetPassword => 'पासवर्ड रीसेट करें';
	@override String get dontHaveAccount => 'खाता नहीं है?';
	@override String get alreadyHaveAccount => 'पहले से खाता है?';
	@override String get loginSuccess => 'लॉगिन सफल';
	@override String get signupSuccess => 'साइन अप सफल';
	@override String get loginError => 'लॉगिन विफल';
	@override String get signupError => 'साइन अप विफल';
}

// Path: error
class _TranslationsErrorHi extends TranslationsErrorEn {
	_TranslationsErrorHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get network => 'इंटरनेट कनेक्शन नहीं है';
	@override String get server => 'सर्वर त्रुटि हुई';
	@override String get cache => 'कैश्ड डेटा लोड करने में विफल';
	@override String get timeout => 'अनुरोध समय समाप्त';
	@override String get notFound => 'संसाधन नहीं मिला';
	@override String get validation => 'सत्यापन विफल';
	@override String get unexpected => 'एक अप्रत्याशित त्रुटि हुई';
	@override String get tryAgain => 'कृपया पुनः प्रयास करें';
	@override String couldNotOpenLink({required Object url}) => 'लिंक नहीं खोल सके: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionHi extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get free => 'मुफ़्त';
	@override String get plus => 'प्लस';
	@override String get pro => 'प्रो';
	@override String get upgradeToPro => 'प्रो में अपग्रेड करें';
	@override String get features => 'सुविधाएँ';
	@override String get subscribe => 'सदस्यता लें';
	@override String get currentPlan => 'वर्तमान योजना';
	@override String get managePlan => 'योजना प्रबंधित करें';
}

// Path: notification
class _TranslationsNotificationHi extends TranslationsNotificationEn {
	_TranslationsNotificationHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'सूचनाएं';
	@override String get peopleToConnect => 'लोगों से जुड़ें';
	@override String get peopleToConnectSubtitle => 'फॉलो करने के लिए लोग खोजें';
	@override String followAgainInMinutes({required Object minutes}) => 'आप ${minutes} मिनट में फिर से फॉलो कर सकते हैं';
	@override String get noSuggestions => 'अभी कोई सुझाव नहीं';
	@override String get markAllRead => 'सभी को पढ़ा हुआ मार्क करें';
	@override String get noNotifications => 'अभी तक कोई सूचना नहीं';
	@override String get noNotificationsSubtitle => 'जब कोई आपकी कहानियों से जुड़ेगा, तो आप यहां देखेंगे';
	@override String get errorPrefix => 'त्रुटि:';
	@override String get retry => 'पुनः प्रयास करें';
	@override String likedYourStory({required Object actorName}) => '${actorName} ने आपकी कहानी को लाइक किया';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} ने आपकी कहानी पर टिप्पणी की';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} ने आपके कमेंट का जवाब दिया';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} ने आपको फॉलो करना शुरू किया';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} ने आपको एक संदेश भेजा';
	@override String sharedYourStory({required Object actorName}) => '${actorName} ने आपकी कहानी साझा की';
	@override String repostedYourStory({required Object actorName}) => '${actorName} ने आपकी कहानी रीपोस्ट की';
	@override String mentionedYou({required Object actorName}) => '${actorName} ने आपका उल्लेख किया';
	@override String newPostFrom({required Object actorName}) => '${actorName} की नई पोस्ट';
	@override String get today => 'आज';
	@override String get thisWeek => 'इस सप्ताह';
	@override String get earlier => 'पहले';
	@override String get delete => 'हटाएं';
}

// Path: profile
class _TranslationsProfileHi extends TranslationsProfileEn {
	_TranslationsProfileHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get followers => 'फॉलोअर्स';
	@override String get following => 'फॉलोइंग';
	@override String get unfollow => 'अनफॉलो करें';
	@override String get follow => 'फॉलो करें';
	@override String get about => 'के बारे में';
	@override String get stories => 'कहानियाँ';
	@override String get unableToShareImage => 'चित्र साझा करने में असमर्थ';
	@override String get imageSavedToPhotos => 'चित्र फोटो में सहेजा गया';
	@override String get view => 'देखें';
	@override String get saveToPhotos => 'फोटो में सहेजें';
	@override String get failedToLoadImage => 'चित्र लोड करने में विफल';
}

// Path: feed
class _TranslationsFeedHi extends TranslationsFeedEn {
	_TranslationsFeedHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get loading => 'कहानियाँ लोड हो रही हैं...';
	@override String get loadingPosts => 'पोस्ट लोड हो रही हैं...';
	@override String get loadingVideos => 'वीडियो लोड हो रहे हैं...';
	@override String get loadingStories => 'कहानियाँ लोड हो रही हैं...';
	@override String get errorTitle => 'अरे! कुछ गलत हो गया';
	@override String get tryAgain => 'फिर से प्रयास करें';
	@override String get noStoriesAvailable => 'कोई कहानी उपलब्ध नहीं';
	@override String get noImagesAvailable => 'कोई चित्र पोस्ट उपलब्ध नहीं';
	@override String get noTextPostsAvailable => 'कोई विचार पोस्ट उपलब्ध नहीं';
	@override String get noContentAvailable => 'कोई सामग्री उपलब्ध नहीं';
	@override String get refresh => 'रिफ्रेश';
	@override String get comments => 'टिप्पणियाँ';
	@override String get commentsComingSoon => 'टिप्पणियाँ जल्द ही आ रही हैं';
	@override String get addCommentHint => 'टिप्पणी जोड़ें...';
	@override String get shareStory => 'कहानी साझा करें';
	@override String get sharePost => 'पोस्ट साझा करें';
	@override String get shareThought => 'विचार साझा करें';
	@override String get shareAsImage => 'चित्र के रूप में साझा करें';
	@override String get shareAsImageSubtitle => 'एक सुंदर पूर्वावलोकन कार्ड बनाएं';
	@override String get shareLink => 'लिंक साझा करें';
	@override String get shareLinkSubtitle => 'कहानी लिंक कॉपी या साझा करें';
	@override String get shareImageLinkSubtitle => 'पोस्ट लिंक कॉपी या साझा करें';
	@override String get shareTextLinkSubtitle => 'विचार लिंक कॉपी या साझा करें';
	@override String get shareAsText => 'पाठ के रूप में साझा करें';
	@override String get shareAsTextSubtitle => 'कहानी के अंश साझा करें';
	@override String get shareQuote => 'उद्धरण साझा करें';
	@override String get shareQuoteSubtitle => 'उद्धरण के रूप में साझा करें';
	@override String get shareWithImage => 'चित्र सहित साझा करें';
	@override String get shareWithImageSubtitle => 'कैप्शन सहित चित्र साझा करें';
	@override String get copyLink => 'लिंक कॉपी करें';
	@override String get copyLinkSubtitle => 'क्लिपबोर्ड पर लिंक कॉपी करें';
	@override String get copyText => 'पाठ कॉपी करें';
	@override String get copyTextSubtitle => 'क्लिपबोर्ड पर उद्धरण कॉपी करें';
	@override String get linkCopied => 'लिंक क्लिपबोर्ड पर कॉपी हो गया';
	@override String get textCopied => 'पाठ क्लिपबोर्ड पर कॉपी हो गया';
	@override String get sendToUser => 'उपयोगकर्ता को भेजें';
	@override String get sendToUserSubtitle => 'सीधे मित्र के साथ साझा करें';
	@override String get chooseFormat => 'प्रारूप चुनें';
	@override String get linkPreview => 'लिंक पूर्वावलोकन';
	@override String get linkPreviewSize => '1200 × 630';
	@override String get storyFormat => 'स्टोरी प्रारूप';
	@override String get storyFormatSize => '1080 × 1920 (Instagram/Stories)';
	@override String get generatingPreview => 'पूर्वावलोकन तैयार किया जा रहा है...';
	@override String get bookmarked => 'बुकमार्क किया गया';
	@override String get removedFromBookmarks => 'बुकमार्क से हटाया गया';
	@override String unlike({required Object count}) => 'अनलाइक, ${count} पसंद';
	@override String like({required Object count}) => 'पसंद, ${count} पसंद';
	@override String commentCount({required Object count}) => '${count} टिप्पणियां';
	@override String shareCount({required Object count}) => 'साझा करें, ${count} साझा';
	@override String get removeBookmark => 'बुकमार्क हटाएं';
	@override String get addBookmark => 'बुकमार्क करें';
	@override String get quote => 'उद्धरण';
	@override String get quoteCopied => 'उद्धरण क्लिपबोर्ड पर कॉपी हो गया';
	@override String get copy => 'कॉपी करें';
	@override String get tapToViewFullQuote => 'पूरा उद्धरण देखने के लिए टैप करें';
	@override String get quoteFromMyitihas => 'MyItihas से उद्धरण';
	@override late final _TranslationsFeedTabsHi tabs = _TranslationsFeedTabsHi._(_root);
	@override String get tapToShowCaption => 'कैप्शन देखने के लिए टैप करें';
	@override String get noVideosAvailable => 'कोई वीडियो उपलब्ध नहीं';
	@override String get selectUser => 'भेजें';
	@override String get searchUsers => 'उपयोगकर्ता खोजें...';
	@override String get noFollowingYet => 'आप अभी किसी को फॉलो नहीं कर रहे';
	@override String get noUsersFound => 'कोई उपयोगकर्ता नहीं मिला';
	@override String get tryDifferentSearch => 'अलग शब्द से खोजें';
	@override String sentTo({required Object username}) => '${username} को भेजा गया';
}

// Path: social
class _TranslationsSocialHi extends TranslationsSocialEn {
	_TranslationsSocialHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileHi editProfile = _TranslationsSocialEditProfileHi._(_root);
	@override late final _TranslationsSocialCreatePostHi createPost = _TranslationsSocialCreatePostHi._(_root);
	@override late final _TranslationsSocialCommentsHi comments = _TranslationsSocialCommentsHi._(_root);
	@override late final _TranslationsSocialEngagementHi engagement = _TranslationsSocialEngagementHi._(_root);
	@override String get editCaption => 'कैप्शन संपादित करें';
	@override String get reportPost => 'पोस्ट की रिपोर्ट करें';
	@override String get reportReasonHint => 'बताएं कि इस पोस्ट में क्या गलत है';
	@override String get deletePost => 'पोस्ट हटाएं';
	@override String get deletePostConfirm => 'इस क्रिया को पूर्ववत नहीं किया जा सकता।';
	@override String get postDeleted => 'पोस्ट हटा दी गई';
	@override String failedToDeletePost({required Object error}) => 'पोस्ट हटाने में विफल: ${error}';
	@override String failedToReportPost({required Object error}) => 'पोस्ट की रिपोर्ट करने में विफल: ${error}';
	@override String get reportSubmitted => 'रिपोर्ट जमा की गई। धन्यवाद।';
	@override String get acceptRequestFirst => 'पहले अनुरोध में उनका अनुरोध स्वीकार करें।';
	@override String get requestSentWait => 'अनुरोध भेज दिया। उनके स्वीकार करने की प्रतीक्षा करें।';
	@override String get requestSentTheyWillSee => 'अनुरोध भेज दिया। वे इसे अनुरोध में देखेंगे।';
	@override String failedToShare({required Object error}) => 'साझा करने में विफल: ${error}';
	@override String get updateCaptionHint => 'अपनी पोस्ट के लिए कैप्शन अपडेट करें';
}

// Path: voice
class _TranslationsVoiceHi extends TranslationsVoiceEn {
	_TranslationsVoiceHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'माइक्रोफोन अनुमति आवश्यक';
	@override String get speechRecognitionNotAvailable => 'स्पीच रिकॉग्निशन उपलब्ध नहीं';
	@override String get storyVoiceListeningHint => 'सोचते समय थोड़ा रुक सकते हैं। समाप्त करने पर माइक टैप करें।';
}

// Path: festivals
class _TranslationsFestivalsHi extends TranslationsFestivalsEn {
	_TranslationsFestivalsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'त्योहार की कथाएँ';
	@override String get tellStory => 'कथा सुनाएँ';
}

// Path: homeScreen
class _TranslationsHomeScreenHi extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'नमस्ते';
	@override String get quoteOfTheDay => 'आज का विचार';
	@override String get shareQuote => 'विचार साझा करें';
	@override String get copyQuote => 'विचार कॉपी करें';
	@override String get quoteCopied => 'विचार क्लिपबोर्ड पर कॉपी किया गया';
	@override String get featuredStories => 'विशेष कहानियां';
	@override String get quickActions => 'त्वरित क्रियाएं';
	@override String get generateStory => 'कहानी बनाएं';
	@override String get chatWithKrishna => 'कृष्ण से बातचीत';
	@override String get myActivity => 'मेरी गतिविधि';
	@override String get continueReading => 'पढ़ना जारी रखें';
	@override String get savedStories => 'सहेजी गई कहानियां';
	@override String get exploreMyitihas => 'मायइतिहास अन्वेषण';
	@override String get storiesInYourLanguage => 'आपकी भाषा में कहानियां';
	@override String get seeAll => 'सभी देखें';
	@override String get startReading => 'पढ़ना शुरू करें';
	@override String get exploreStories => 'अपनी यात्रा शुरू करने के लिए कहानियां खोजें';
	@override String get saveForLater => 'पसंदीदा कहानियां बुकमार्क करें';
	@override String get noActivityYet => 'अभी तक कोई गतिविधि नहीं';
	@override String minLeft({required Object count}) => '${count} मिनट बाकी';
	@override String get activityHistory => 'गतिविधि इतिहास';
	@override String get storyGenerated => 'कहानी बनाई';
	@override String get storyRead => 'कहानी पढ़ी';
	@override String get storyBookmarked => 'कहानी सहेजी';
	@override String get storyShared => 'कहानी साझा की';
	@override String get storyCompleted => 'कहानी पूरी की';
	@override String get today => 'आज';
	@override String get yesterday => 'कल';
	@override String get thisWeek => 'इस सप्ताह';
	@override String get earlier => 'पहले';
	@override String get noContinueReading => 'अभी पढ़ने के लिए कुछ नहीं';
	@override String get noSavedStories => 'अभी कोई सहेजी गई कहानी नहीं';
	@override String get bookmarkStoriesToSave => 'कहानियां सहेजने के लिए बुकमार्क करें';
	@override String get myGeneratedStories => 'मेरी कहानियां';
	@override String get noGeneratedStoriesYet => 'अभी तक कोई कहानी नहीं बनाई गई';
	@override String get createYourFirstStory => 'AI का उपयोग करके अपनी पहली कहानी बनाएं';
	@override String get shareToFeed => 'फीड पर साझा करें';
	@override String get sharedToFeed => 'कहानी फीड पर साझा की गई';
	@override String get shareStoryTitle => 'कहानी साझा करें';
	@override String get shareStoryMessage => 'अपनी कहानी के लिए एक कैप्शन जोड़ें (वैकल्पिक)';
	@override String get shareStoryCaption => 'कैप्शन';
	@override String get shareStoryHint => 'आप इस कहानी के बारे में क्या कहना चाहते हैं?';
	@override String get exploreHeritageTitle => 'विरासत स्थल';
	@override String get exploreHeritageDesc => 'मानचित्र पर अपने सांस्कृतिक विरासत स्थलों को खोजें';
	@override String get whereToVisit => 'अगली यात्रा';
	@override String get scriptures => 'शास्त्र';
	@override String get exploreSacredSites => 'पवित्र स्थल खोजें';
	@override String get readStories => 'कहानियां पढ़ें';
	@override String get yesRemindMe => 'हां, मुझे याद दिलाएं';
	@override String get noDontShowAgain => 'नहीं, दोबारा न दिखाएं';
	@override String get discoverDismissTitle => 'Discover MyItihas छिपाएं?';
	@override String get discoverDismissMessage => 'क्या आप इसे अगली बार ऐप खोलने या लॉगिन करने पर फिर से देखना चाहेंगे?';
	@override String get discoverCardTitle => 'मायइतिहास खोजें';
	@override String get discoverCardSubtitle => 'प्राचीन शास्त्रों की कहानियां, खोजने के लिए पवित्र स्थल, और ज्ञान आपकी उंगलियों पर।';
	@override String get swipeToDismiss => 'खारिज करने के लिए ऊपर स्वाइप करें';
	@override String get searchScriptures => 'शास्त्र खोजें...';
	@override String get searchLanguages => 'भाषाएं खोजें...';
	@override String get exploreStoriesLabel => 'कहानियां खोजें';
	@override String get exploreMore => 'और खोजें';
	@override String get failedToLoadActivity => 'गतिविधि लोड करने में विफल';
	@override String get startReadingOrGenerating => 'अपनी गतिविधि यहां देखने के लिए कहानियां पढ़ें या बनाएं';
	@override String get beginYourStory => 'अपनी कहानी शुरू करें';
	@override String get createTaleWithAI => 'AI के साथ एक कहानी बनाएं';
	@override String get yourJourney => 'आपकी यात्रा';
	@override String get shareToCommunity => 'समुदाय के साथ साझा करें';
	@override String get journeyBeginsWithStory => 'आपकी यात्रा एक कहानी से शुरू होती है';
	@override late final _TranslationsHomeScreenHeroHi hero = _TranslationsHomeScreenHeroHi._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthHi extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get short => 'छोटी';
	@override String get medium => 'मध्यम';
	@override String get long => 'लंबी';
	@override String get epic => 'महाकाव्य';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatHi extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'कथात्मक';
	@override String get dialogue => 'संवाद-आधारित';
	@override String get poetic => 'काव्यात्मक';
	@override String get scriptural => 'शास्त्रीय';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsHi extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'कृष्ण द्वारा अर्जुन को शिक्षा देने की कहानी...';
	@override String get warriorRedemption => 'मुक्ति की खोज में एक योद्धा की महाकाव्य...';
	@override String get sageWisdom => 'ऋषियों की बुद्धि की कहानी...';
	@override String get devotedSeeker => 'एक भक्त साधक की यात्रा...';
	@override String get divineIntervention => 'दिव्य हस्तक्षेप की किंवदंती...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsHi extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'कृपया सभी आवश्यक विकल्प पूरे करें';
	@override String get generationFailed => 'कहानी बनाने में विफल। कृपया पुनः प्रयास करें।';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsHi extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  नमस्ते!';
	@override String get dharma => '📖  धर्म क्या है?';
	@override String get stress => '🧘  तनाव से कैसे निपटें';
	@override String get karma => '⚡  कर्म को सरल भाषा में समझाओ';
	@override String get story => '💬  मुझे एक कहानी सुनाओ';
	@override String get wisdom => '🌟  आज का ज्ञान';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsHi extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get poll => 'पोल';
	@override String get camera => 'कैमरा';
	@override String get photos => 'फ़ोटो';
	@override String get location => 'स्थान';
	@override String get pollTitle => 'पोल बनाएं';
	@override String get pollQuestionHint => 'एक सवाल पूछें';
	@override String pollOptionHint({required Object n}) => 'विकल्प ${n}';
	@override String get addOption => 'विकल्प जोड़ें';
	@override String get removeOption => 'हटाएं';
	@override String get sendPoll => 'पोल भेजें';
	@override String get pollNeedTwoOptions => 'कम से कम 2 विकल्प जोड़ें (अधिकतम 4)।';
	@override String get pollMaxOptions => 'अधिकतम 4 विकल्प जोड़ सकते हैं।';
	@override String get sharedLocationTitle => 'साझा स्थान';
	@override String get sendLocation => 'स्थान भेजें';
	@override String get locationPreviewTitle => 'अपना वर्तमान स्थान भेजें?';
	@override String get locationFetching => 'स्थान प्राप्त किया जा रहा है…';
	@override String get openInMaps => 'मानचित्र में खोलें';
	@override String voteCount({required Object count}) => '${count} वोट';
	@override String get voteCountOne => '1 वोट';
	@override String get tapToVote => 'वोट के लिए विकल्प पर टैप करें';
	@override String get mapsUnavailable => 'मानचित्र नहीं खोला जा सका।';
}

// Path: map.discussions
class _TranslationsMapDiscussionsHi extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'चर्चा पोस्ट करें';
	@override String get intentCardCta => 'एक चर्चा पोस्ट करें';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapHi extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapHi extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapHi extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

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
class _TranslationsMapFoodMapHi extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

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
class _TranslationsFeedTabsHi extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get all => 'सभी';
	@override String get stories => 'कहानियाँ';
	@override String get posts => 'पोस्ट';
	@override String get videos => 'वीडियो';
	@override String get images => 'चित्र';
	@override String get text => 'विचार';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileHi extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'प्रोफाइल संपादित करें';
	@override String get displayName => 'प्रदर्शन नाम';
	@override String get displayNameHint => 'अपना प्रदर्शन नाम दर्ज करें';
	@override String get displayNameEmpty => 'प्रदर्शन नाम खाली नहीं हो सकता';
	@override String get bio => 'परिचय';
	@override String get bioHint => 'अपने बारे में बताएं...';
	@override String get changePhoto => 'प्रोफाइल फोटो बदलें';
	@override String get saveChanges => 'बदलाव सहेजें';
	@override String get profileUpdated => 'प्रोफाइल सफलतापूर्वक अपडेट की गई';
	@override String get profileAndPhotoUpdated => 'प्रोफाइल और फोटो सफलतापूर्वक अपडेट की गई';
	@override String failedPickImage({required Object error}) => 'चित्र चुनने में विफल: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'फोटो अपलोड करने में विफल: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'प्रोफाइल अपडेट करने में विफल: ${error}';
	@override String unexpectedError({required Object error}) => 'एक अप्रत्याशित त्रुटि हुई: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostHi extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'पोस्ट बनाएं';
	@override String get post => 'पोस्ट करें';
	@override String get text => 'पाठ';
	@override String get image => 'चित्र';
	@override String get video => 'वीडियो';
	@override String get textHint => 'आपके मन में क्या है?';
	@override String get imageCaptionHint => 'अपनी फोटो के लिए कैप्शन लिखें...';
	@override String get videoCaptionHint => 'अपने वीडियो का वर्णन करें...';
	@override String get shareCaptionHint => 'अपने विचार जोड़ें...';
	@override String get titleHint => 'शीर्षक जोड़ें (वैकल्पिक)';
	@override String get selectVideo => 'वीडियो चुनें';
	@override String get gallery => 'गैलरी';
	@override String get camera => 'कैमरा';
	@override String get visibility => 'यह कौन देख सकता है?';
	@override String get public => 'सार्वजनिक';
	@override String get followers => 'फॉलोवर्स';
	@override String get private => 'निजी';
	@override String get postCreated => 'पोस्ट बन गई!';
	@override String get failedPickImages => 'चित्र चुनने में विफल';
	@override String get failedPickVideo => 'वीडियो चुनने में विफल';
	@override String get failedCapturePhoto => 'फोटो लेने में विफल';
	@override String get cannotCreateOffline => 'ऑफ़लाइन होने पर पोस्ट नहीं बनाई जा सकती';
	@override String get discardTitle => 'पोस्ट हटाएं?';
	@override String get discardMessage => 'आपके पास बिना सहेजे बदलाव हैं। क्या आप इस पोस्ट को हटाना चाहते हैं?';
	@override String get keepEditing => 'संपादन जारी रखें';
	@override String get discard => 'हटाएं';
	@override String get cropPhoto => 'फोटो काटें';
	@override String get trimVideo => 'वीडियो ट्रिम करें';
	@override String get editPhoto => 'फोटो संपादित करें';
	@override String get editVideo => 'वीडियो संपादित करें';
	@override String get maxDuration => 'अधिकतम 30 सेकंड';
	@override String get aspectSquare => 'वर्ग';
	@override String get aspectPortrait => 'पोर्ट्रेट';
	@override String get aspectLandscape => 'लैंडस्केप';
	@override String get aspectFree => 'मुक्त';
	@override String get failedCrop => 'चित्र काटने में विफल';
	@override String get failedTrim => 'वीडियो ट्रिम करने में विफल';
	@override String get trimmingVideo => 'वीडियो ट्रिम हो रहा है...';
	@override String trimVideoSubtitle({required Object max}) => 'अधिकतम ${max}से · अपना बेहतरीन हिस्सा चुनें';
	@override String get trimVideoInstructionsTitle => 'अपनी क्लिप ट्रिम करें';
	@override String get trimVideoInstructionsBody => 'शुरुआत और अंत हैंडल खींचकर 30 सेकंड तक का हिस्सा चुनें।';
	@override String get trimStart => 'शुरुआत';
	@override String get trimEnd => 'अंत';
	@override String get trimSelectionEmpty => 'जारी रखने के लिए मान्य रेंज चुनें';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}से चुना गया (${start}–${end}) · अधिकतम ${max}से';
	@override String get coverFrame => 'कवर फ्रेम';
	@override String get coverFrameUnavailable => 'कोई प्रीव्यू नहीं';
	@override String coverFramePosition({required Object time}) => '${time} पर कवर';
	@override String get overlayLabel => 'वीडियो पर टेक्स्ट (वैकल्पिक)';
	@override String get overlayHint => 'छोटा हुक या शीर्षक जोड़ें';
	@override String get imageSectionHint => 'गैलरी या कैमरे से अधिकतम 10 फोटो जोड़ें';
	@override String get videoSectionHint => 'एक वीडियो, अधिकतम 30 सेकंड';
	@override String get removePhoto => 'हटाएं';
	@override String get removeVideo => 'वीडियो हटाएं';
	@override String get photoEditHint => 'काटने या हटाने के लिए फोटो पर टैप करें';
	@override String get videoEditOptions => 'संपादन विकल्प';
	@override String get addPhoto => 'फोटो जोड़ें';
	@override String get done => 'हो गया';
	@override String get rotate => 'घुमाएं';
	@override String get editPhotoSubtitle => 'फ़ीड में बेहतर फिट के लिए वर्ग में काटें';
	@override String get videoEditorCaptionLabel => 'कैप्शन / टेक्स्ट (वैकल्पिक)';
	@override String get videoEditorCaptionHint => 'जैसे: आपकी रील के लिए शीर्षक या हुक';
	@override String get videoEditorAspectLabel => 'अनुपात';
	@override String get videoEditorAspectOriginal => 'मूल';
	@override String get videoEditorAspectSquare => '१:१';
	@override String get videoEditorAspectPortrait => '९:१६';
	@override String get videoEditorAspectLandscape => '१६:९';
	@override String get videoEditorQuickTrim => 'त्वरित ट्रिम';
	@override String get videoEditorSpeed => 'गति';
}

// Path: social.comments
class _TranslationsSocialCommentsHi extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} को जवाब दे रहे हैं';
	@override String replyHint({required Object name}) => '${name} को जवाब दें...';
	@override String failedToPost({required Object error}) => 'पोस्ट करने में विफल: ${error}';
	@override String get cannotPostOffline => 'ऑफ़लाइन होने पर टिप्पणी नहीं की जा सकती';
	@override String get noComments => 'अभी तक कोई टिप्पणी नहीं';
	@override String get beFirst => 'पहली टिप्पणी करें!';
}

// Path: social.engagement
class _TranslationsSocialEngagementHi extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'ऑफ़लाइन मोड';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroHi extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'खोजने के लिए टैप करें';
	@override late final _TranslationsHomeScreenHeroStoryHi story = _TranslationsHomeScreenHeroStoryHi._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionHi companion = _TranslationsHomeScreenHeroCompanionHi._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageHi heritage = _TranslationsHomeScreenHeroHeritageHi._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityHi community = _TranslationsHomeScreenHeroCommunityHi._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesHi messages = _TranslationsHomeScreenHeroMessagesHi._(_root);
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryHi extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'एआई कहानी निर्माण';
	@override String get headline => 'रोमांचक\nकहानियां\nबनाएं';
	@override String get subHeadline => 'प्राचीन ज्ञान से प्रेरित';
	@override String get line1 => '✦  कोई पवित्र शास्त्र चुनें...';
	@override String get line2 => '✦  एक जीवंत परिवेश चुनें...';
	@override String get line3 => '✦  एआई से एक मोहक कथा बुनवाएं...';
	@override String get cta => 'कहानी बनाएं';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionHi extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'आध्यात्मिक साथी';
	@override String get headline => 'आपका दिव्य\nमार्गदर्शक,\nहमेशा पास';
	@override String get subHeadline => 'कृष्ण के ज्ञान से प्रेरित';
	@override String get line1 => '✦  एक मित्र जो सच में सुनता है...';
	@override String get line2 => '✦  जीवन की चुनौतियों के लिए ज्ञान...';
	@override String get line3 => '✦  बातचीत जो आपको उठाए...';
	@override String get cta => 'चैट शुरू करें';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageHi extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'विरासत मानचित्र';
	@override String get headline => 'सनातन\nविरासत\nखोजें';
	@override String get subHeadline => '5000+ पवित्र स्थल मानचित्रित';
	@override String get line1 => '✦  पवित्र स्थलों का अन्वेषण करें...';
	@override String get line2 => '✦  इतिहास और लोककथाएं पढ़ें...';
	@override String get line3 => '✦  सार्थक यात्राओं की योजना बनाएं...';
	@override String get cta => 'मानचित्र देखें';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityHi extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'समुदाय मंच';
	@override String get headline => 'संस्कृति को\nदुनिया के साथ\nसाझा करें';
	@override String get subHeadline => 'एक जीवंत वैश्विक समुदाय';
	@override String get line1 => '✦  पोस्ट और गहन चर्चाएं...';
	@override String get line2 => '✦  छोटे सांस्कृतिक वीडियो...';
	@override String get line3 => '✦  दुनिया भर की कहानियां...';
	@override String get cta => 'समुदाय से जुड़ें';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesHi extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesHi._(TranslationsHi root) : this._root = root, super.internal(root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'निजी संदेश';
	@override String get headline => 'अर्थपूर्ण\nबातचीत\nयहीं से शुरू';
	@override String get subHeadline => 'निजी और विचारपूर्ण स्थान';
	@override String get line1 => '✦  समान सोच वालों से जुड़ें...';
	@override String get line2 => '✦  विचारों और कहानियों पर चर्चा करें...';
	@override String get line3 => '✦  सोचपूर्ण समुदाय बनाएं...';
	@override String get cta => 'संदेश खोलें';
}
