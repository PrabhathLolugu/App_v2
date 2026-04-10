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
class TranslationsSa extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsSa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.sa,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <sa>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsSa _root = this; // ignore: unused_field

	@override 
	TranslationsSa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsSa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppSa app = _TranslationsAppSa._(_root);
	@override late final _TranslationsCommonSa common = _TranslationsCommonSa._(_root);
	@override late final _TranslationsNavigationSa navigation = _TranslationsNavigationSa._(_root);
	@override late final _TranslationsHomeSa home = _TranslationsHomeSa._(_root);
	@override late final _TranslationsHomeScreenSa homeScreen = _TranslationsHomeScreenSa._(_root);
	@override late final _TranslationsStoriesSa stories = _TranslationsStoriesSa._(_root);
	@override late final _TranslationsStoryGeneratorSa storyGenerator = _TranslationsStoryGeneratorSa._(_root);
	@override late final _TranslationsChatSa chat = _TranslationsChatSa._(_root);
	@override late final _TranslationsMapSa map = _TranslationsMapSa._(_root);
	@override late final _TranslationsCommunitySa community = _TranslationsCommunitySa._(_root);
	@override late final _TranslationsDiscoverSa discover = _TranslationsDiscoverSa._(_root);
	@override late final _TranslationsPlanSa plan = _TranslationsPlanSa._(_root);
	@override late final _TranslationsSettingsSa settings = _TranslationsSettingsSa._(_root);
	@override late final _TranslationsAuthSa auth = _TranslationsAuthSa._(_root);
	@override late final _TranslationsErrorSa error = _TranslationsErrorSa._(_root);
	@override late final _TranslationsSubscriptionSa subscription = _TranslationsSubscriptionSa._(_root);
	@override late final _TranslationsNotificationSa notification = _TranslationsNotificationSa._(_root);
	@override late final _TranslationsProfileSa profile = _TranslationsProfileSa._(_root);
	@override late final _TranslationsFeedSa feed = _TranslationsFeedSa._(_root);
	@override late final _TranslationsVoiceSa voice = _TranslationsVoiceSa._(_root);
	@override late final _TranslationsFestivalsSa festivals = _TranslationsFestivalsSa._(_root);
	@override late final _TranslationsSocialSa social = _TranslationsSocialSa._(_root);
}

// Path: app
class _TranslationsAppSa extends TranslationsAppEn {
	_TranslationsAppSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'भारतीयशास्त्राणां अन्वेषणं कुरु';
}

// Path: common
class _TranslationsCommonSa extends TranslationsCommonEn {
	_TranslationsCommonSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get ok => 'सम्यक्';
	@override String get cancel => 'निरसय';
	@override String get confirm => 'निश्चयय';
	@override String get delete => 'लोपय';
	@override String get edit => 'सम्पादय';
	@override String get save => 'रक्ष';
	@override String get share => 'विभज';
	@override String get search => 'अन्वेषय';
	@override String get loading => 'आरोपणं प्रवर्तते...';
	@override String get error => 'दोषः';
	@override String get retry => 'पुनः प्रयतस्व';
	@override String get back => 'प्रतिगच्छ';
	@override String get next => 'परम्';
	@override String get finish => 'समापय';
	@override String get skip => 'उत्सृज';
	@override String get yes => 'आम्';
	@override String get no => 'न';
	@override String get readFullStory => 'समग्रकथां पठ';
	@override String get dismiss => 'निरस्य';
	@override String get offlineBannerMessage => 'भवान् ऑफ़लाइनावस्थायां अस्ति – सञ्चितं वस्तु पश्यति';
	@override String get backOnline => 'पुनरपि ऑनलाइन';
}

// Path: navigation
class _TranslationsNavigationSa extends TranslationsNavigationEn {
	_TranslationsNavigationSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get home => 'अन्वेषणम्';
	@override String get stories => 'कथाः';
	@override String get chat => 'संवादः';
	@override String get map => 'मानचित्रम्';
	@override String get community => 'सामाजिकम्';
	@override String get settings => 'विन्यासाः';
	@override String get profile => 'प्रोफाइल्';
}

// Path: home
class _TranslationsHomeSa extends TranslationsHomeEn {
	_TranslationsHomeSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'कथाजनकः';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'समुदायकथाः';
	@override String get maps => 'मानचित्राणि';
	@override String get greetingMorning => 'सुप्रभातम्';
	@override String get continueReading => 'पठनं अनुवर्तस्व';
	@override String get greetingAfternoon => 'नमस्कारः';
	@override String get greetingEvening => 'शुभसायं';
	@override String get greetingNight => 'शुभरात्रिः';
	@override String get exploreStories => 'कथाः अन्वेषय';
	@override String get generateStory => 'कथां निर्मास्य';
	@override String get content => 'गृहवस्तु';
}

// Path: homeScreen
class _TranslationsHomeScreenSa extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'नमस्ते';
	@override String get quoteOfTheDay => 'अद्यतनवाक्यम्';
	@override String get shareQuote => 'वाक्यं विभज';
	@override String get copyQuote => 'वाक्यं प्रतिलिख';
	@override String get quoteCopied => 'वाक्यं क्लिप्बोर्ड् इति सन्निवेशितम्';
	@override String get featuredStories => 'विशिष्टकथाः';
	@override String get quickActions => 'शीघ्रक्रियाः';
	@override String get generateStory => 'कथां निर्मास्य';
	@override String get chatWithKrishna => 'कृष्णेन सह संवादं कुरु';
	@override String get myActivity => 'मम क्रियाः';
	@override String get continueReading => 'पठनं अनुवर्तस्व';
	@override String get savedStories => 'संरक्षितकथाः';
	@override String get exploreMyitihas => 'मायइतिहास अन्वेषणम्';
	@override String get storiesInYourLanguage => 'तव भाषायां कथाः';
	@override String get seeAll => 'सर्वाणि पश्य';
	@override String get startReading => 'पठनं आरभस्व';
	@override String get exploreStories => 'स्वयस्य यात्रां प्रारभ्य कथाः अन्वेषय';
	@override String get saveForLater => 'प्रियाः कथाः चिन्हय, परं पठिष्यसि';
	@override String get noActivityYet => 'अद्यावधि कापि क्रिया नास्ति';
	@override String minLeft({required Object count}) => '${count} निमेषाः अवशिष्टाः';
	@override String get activityHistory => 'क्रियाचारित्रम्';
	@override String get storyGenerated => 'काचित् कथा निर्मिता';
	@override String get storyRead => 'काचित् कथा कृता';
	@override String get storyBookmarked => 'कथा चिह्निता';
	@override String get storyShared => 'कथा विभक्ता';
	@override String get storyCompleted => 'कथा समाप्ता';
	@override String get today => 'अद्य';
	@override String get yesterday => 'ह्यः';
	@override String get thisWeek => 'अस्य सप्ताहस्य';
	@override String get earlier => 'पूर्वम्';
	@override String get noContinueReading => 'अद्यापि किञ्चित् नास्ति पठनीयम्';
	@override String get noSavedStories => 'अद्यापि न काचित् कथा संरक्षिता';
	@override String get bookmarkStoriesToSave => 'कथाः रक्षितुं चिन्हयतु';
	@override String get myGeneratedStories => 'मम निर्मिताः कथाः';
	@override String get noGeneratedStoriesYet => 'अद्यावधि न काचित् कथा निर्मिता';
	@override String get createYourFirstStory => 'AI साहाय्येन प्रथमां कथां निर्मास्य';
	@override String get shareToFeed => 'प्रवाहे विभज';
	@override String get sharedToFeed => 'कथा प्रवाहे विभक्ता';
	@override String get shareStoryTitle => 'कथां विभज';
	@override String get shareStoryMessage => 'तव कथायाः कृते शीर्षिकां/वर्णनं लिख (ऐच्छिकम्)';
	@override String get shareStoryCaption => 'शीर्षिका';
	@override String get shareStoryHint => 'अस्याः कथायाः विषये किं वक्तुम् इच्छसि?';
	@override String get exploreHeritageTitle => 'परम्परां पश्य';
	@override String get exploreHeritageDesc => 'मानचित्रे सांस्कृतिकविरासत्स्थलानि अन्वेषय';
	@override String get whereToVisit => 'अग्रिम यात्रा';
	@override String get scriptures => 'शास्त्राणि';
	@override String get exploreSacredSites => 'पवित्रस्थलानि अन्वेषय';
	@override String get readStories => 'कथाः पठ';
	@override String get yesRemindMe => 'आम्, मां स्मारय';
	@override String get noDontShowAgain => 'न, पुनः मा दर्शय';
	@override String get discoverDismissTitle => 'Discover MyItihas गोपयितुम् इच्छसि किम्?';
	@override String get discoverDismissMessage => 'आगामिवारे अनुप्रयोगं उद्घाट्य वा प्रवेशं कृत्वा एतत् पुनः द्रष्टुम् इच्छसि किम्?';
	@override String get discoverCardTitle => 'MyItihas इति विज्ञापय';
	@override String get discoverCardSubtitle => 'प्राचीनेभ्यः शास्त्रेभ्यः कथाः, अन्वेषणीयानि पवित्रस्थलानि, हस्तयोः मध्ये ज्ञानम्।';
	@override String get swipeToDismiss => 'निरस्यतु इति उपरि स्वीपं कुरु';
	@override String get searchScriptures => 'शास्त्राणि अन्वेषय...';
	@override String get searchLanguages => 'भाषाः अन्वेषय...';
	@override String get exploreStoriesLabel => 'कथाः अन्वेषय';
	@override String get exploreMore => 'अधिकं पश्य';
	@override String get failedToLoadActivity => 'क्रियाः आरोपयितुं न शक्यन्ते';
	@override String get startReadingOrGenerating => 'अत्र तव क्रियाः द्रष्टुं कथाः पठ वा निर्मास्य';
	@override late final _TranslationsHomeScreenHeroSa hero = _TranslationsHomeScreenHeroSa._(_root);
}

// Path: stories
class _TranslationsStoriesSa extends TranslationsStoriesEn {
	_TranslationsStoriesSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'कथाः';
	@override String get searchHint => 'शीर्षकेन वा कर्त्रा अन्वेषय...';
	@override String get sortBy => 'क्रमं चिनुत';
	@override String get sortNewest => 'नूतनतमाः प्रथमा:';
	@override String get sortOldest => 'प्राचीनतमाः प्रथमा:';
	@override String get sortPopular => 'अत्यधिकं लोकप्रियाः';
	@override String get noStories => 'न काचित् कथा प्राप्यते';
	@override String get loadingStories => 'कथाः आरोप्यन्ते...';
	@override String get errorLoadingStories => 'कथाः आरोपयितुं न शक्यन्ते';
	@override String get storyDetails => 'कथाविवरणम्';
	@override String get continueReading => 'पठनं अनुवर्तस्व';
	@override String get readMore => 'अधिकं पठ';
	@override String get readLess => 'किञ्चित् न्यूनं दर्शय';
	@override String get author => 'लेखकः';
	@override String get publishedOn => 'प्रकाशिततिथि';
	@override String get category => 'वर्गः';
	@override String get tags => 'टैगाः';
	@override String get failedToLoad => 'कथां आरोपयितुं न शक्यते';
	@override String get subtitle => 'शास्त्रकथाः अन्वेषय';
	@override String get noStoriesHint => 'कथाः अन्वेष्टुं भिन्नं अन्वेषणं वा छननीम् उपयुज्यताम्।';
	@override String get featured => 'विशेषम्';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorSa extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'कथाजनकः';
	@override String get subtitle => 'स्वकीयां शास्त्रीयकथां निर्मास्य';
	@override String get quickStart => 'शीघ्रारम्भः';
	@override String get interactive => 'परस्परसंवादात्मकम्';
	@override String get rawPrompt => 'मूलप्रश्नः';
	@override String get yourStoryPrompt => 'तवकथायाः प्राम्प्ट्';
	@override String get writeYourPrompt => 'स्वप्राम्प्ट् लिख';
	@override String get selectScripture => 'शास्त्रं चिनुत';
	@override String get selectStoryType => 'कथाभेदं चिनुत';
	@override String get selectCharacter => 'पात्रं चिनुत';
	@override String get selectTheme => 'विषयं चिनुत';
	@override String get selectSetting => 'परिसरं चिनुत';
	@override String get selectLanguage => 'भाषां चिनुत';
	@override String get selectLength => 'कथाया: दीर्घता';
	@override String get moreOptions => 'अधिकविकल्पाः';
	@override String get random => 'यादृच्छिकम्';
	@override String get generate => 'कथां निर्मास्य';
	@override String get generating => 'तव कथा निर्मीयते...';
	@override String get creatingYourStory => 'तव कथा रच्यते';
	@override String get consultingScriptures => 'प्राचीनशास्त्रैः सह विचारः क्रियते...';
	@override String get weavingTale => 'तव आख्यायिका नीयते...';
	@override String get addingWisdom => 'दिव्यं ज्ञानं योज्यते...';
	@override String get polishingNarrative => 'कथनं स्निग्धीकृत्यते...';
	@override String get almostThere => 'प्रायः समाप्तम्...';
	@override String get generatedStory => 'त्वयि कृता कथा';
	@override String get aiGenerated => 'AI-द्वारा निर्मिता';
	@override String get regenerate => 'पुनर्निर्मास्य';
	@override String get saveStory => 'कथां रक्ष';
	@override String get shareStory => 'कथां विभज';
	@override String get newStory => 'नूतना कथा';
	@override String get saved => 'संरक्षितम्';
	@override String get storySaved => 'कथा तव सङ्ग्रहालये संरक्षिता';
	@override String get story => 'कथा';
	@override String get lesson => 'उपदेशः';
	@override String get didYouKnow => 'किं ज्ञातवान् असि?';
	@override String get activity => 'क्रिया';
	@override String get optionalRefine => 'वैकल्पिकम्: विकल्पैः सूक्ष्मीकरोतु';
	@override String get applyOptions => 'विकल्पान् योजय';
	@override String get language => 'भाषा';
	@override String get storyFormat => 'कथारूपम्';
	@override String get requiresInternet => 'कथाजननाय जालसंबन्धः अपेक्षितः';
	@override String get notAvailableOffline => 'कथा ऑफ़लाइन-अवस्थायां न उपलब्धा। द्रष्टुं जालेन संयोज्यताम्।';
	@override String get aiDisclaimer => 'AI अपि कदाचित् भ्रान्तिं करोति। वयं निरन्तरं सुधारयामः; भवतः अभिप्रायः महत्त्ववान्।';
	@override late final _TranslationsStoryGeneratorStoryLengthSa storyLength = _TranslationsStoryGeneratorStoryLengthSa._(_root);
	@override late final _TranslationsStoryGeneratorFormatSa format = _TranslationsStoryGeneratorFormatSa._(_root);
	@override late final _TranslationsStoryGeneratorHintsSa hints = _TranslationsStoryGeneratorHintsSa._(_root);
	@override late final _TranslationsStoryGeneratorErrorsSa errors = _TranslationsStoryGeneratorErrorsSa._(_root);
}

// Path: chat
class _TranslationsChatSa extends TranslationsChatEn {
	_TranslationsChatSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'शास्त्रविषये AI-सहितं संवादं कुरु';
	@override String get friendMode => 'मित्रभावमोडः';
	@override String get philosophicalMode => 'दर्शनिकमोडः';
	@override String get typeMessage => 'स्वसन्देशं लिख...';
	@override String get send => 'प्रेषय';
	@override String get newChat => 'नवसंवादः';
	@override String get chatsTab => 'संवादाः';
	@override String get groupsTab => 'समूहाः';
	@override String get chatHistory => 'संवादइतिहासः';
	@override String get clearChat => 'संवादं शुद्धय';
	@override String get noMessages => 'अद्यावधि न कश्चन सन्देशः। संवादं आरभस्व!';
	@override String get listPage => 'संवाद-सूची-पृष्ठम्';
	@override String get forwardMessageTo => 'सन्देशं प्रेषय...';
	@override String get forwardMessage => 'सन्देशं अग्रे प्रेषय';
	@override String get messageForwarded => 'सन्देशः अग्रे प्रेषितः';
	@override String failedToForward({required Object error}) => 'सन्देशं प्रेषयितुं न शक्यते: ${error}';
	@override String get searchChats => 'संवादान् अन्वेषय';
	@override String get noChatsFound => 'संवादाः न लब्धाः';
	@override String get requests => 'अनुरोधाः';
	@override String get messageRequests => 'सन्देशनुरोधाः';
	@override String get groupRequests => 'समूहानुरोधाः';
	@override String get requestSent => 'अनुरोधः प्रेषितः। ते "अनुरोधाः" मध्ये द्रक्ष्यन्ति।';
	@override String get wantsToChat => 'संवादं कर्तुम् इच्छति';
	@override String addedYouTo({required Object name}) => '${name} त्वां समूहे न्यासयत्';
	@override String get accept => 'स्वीकरोतु';
	@override String get noMessageRequests => 'सन्देशनुरोधाः न सन्ति';
	@override String get noGroupRequests => 'समूहानुरोधाः न सन्ति';
	@override String get invitesSent => 'आमन्त्रणानि प्रेषितानि। ते "अनुरोधाः" मध्ये द्रक्ष्यन्ति।';
	@override String get cantMessageUser => 'अस्मै उपयोगकर्तृअय सन्देशः न शक्यते';
	@override String get deleteChat => 'संवादं लोपय';
	@override String get deleteChats => 'संवादान् लोपय';
	@override String get blockUser => 'उपयोगकर्तारं निवारय';
	@override String get reportUser => 'उपयोगकर्तुः विषये निवेदय';
	@override String get markAsRead => 'पठितम् इति चिह्नय';
	@override String get markedAsRead => 'पठितम् इति चिह्नितम्';
	@override String get deleteClearChat => 'संवादं लोपय / शुद्धय';
	@override String get deleteConversation => 'वार्तालापं लोपय';
	@override String get reasonRequired => 'कारणम् (आवश्यकम्)';
	@override String get submit => 'प्रेषय';
	@override String get userReportedBlocked => 'उपयोगकर्ता निवेदितः, प्रतिबन्धितश्च।';
	@override String reportFailed({required Object error}) => 'निवेदनं विफलम्: ${error}';
	@override String get newGroup => 'नवसमूहः';
	@override String get messageSomeoneDirectly => 'कस्मिंश्चित् व्यक्तौ सन्देशं साक्षात् प्रेषय';
	@override String get createGroupConversation => 'समूहवार्तालापं निर्मास्य';
	@override String get noGroupsYet => 'अद्यापि न कश्चन समूहः';
	@override String get noChatsYet => 'अद्यापि न कश्चन संवादः';
	@override String get tapToCreateGroup => 'समूहं निर्मातुं वा प्रवेष्टुं + इति स्पृश';
	@override String get tapToStartConversation => 'नूतनं संवादं आरभितुं + इति स्पृश';
	@override String get conversationDeleted => 'वार्तालापः लुप्तः';
	@override String conversationsDeleted({required Object count}) => '${count} वार्तालापाः लुप्ताः';
	@override String get searchConversations => 'वार्तालापान् अन्वेषय...';
	@override String get connectToInternet => 'कृपया जालेन संयोज्य पुनः प्रयतस्व।';
	@override String get littleKrishnaName => 'बालकृष्णः';
	@override String get newConversation => 'नूतनवार्तालापः';
	@override String get noConversationsYet => 'अद्यावधि न कश्चन वार्तालापः';
	@override String get confirmDeletion => 'लोपनस्य निश्वयः';
	@override String deleteConversationConfirm({required Object title}) => 'किं भवान् नूनं ${title} इति वार्तालापं लोपयितुम् इच्छति?';
	@override String get deleteFailed => 'वार्तालापं लोपयितुं न शक्यते';
	@override String get fullChatCopied => 'समस्तः संवादः क्लिप्बोर्ड् इति प्रतिलिखितः!';
	@override String get connectionErrorFallback => 'सम्पर्कः न सिध्यति। कृपया क्षणानन्तरं पुनः प्रयतस्व।';
	@override String krishnaWelcomeWithName({required Object name}) => 'हे ${name}। अहं तव मित्रं कृष्णः। कथं स्थितः असि अद्य?';
	@override String get krishnaWelcomeFriend => 'हे प्रियसखि, अहं कृष्णः, तव मित्रम्। कथं स्थितः असि अद्य?';
	@override String get copyYouLabel => 'त्वम्';
	@override String get copyKrishnaLabel => 'कृष्णः';
	@override late final _TranslationsChatSuggestionsSa suggestions = _TranslationsChatSuggestionsSa._(_root);
	@override String get about => 'सम्बन्धे';
	@override String get yourFriendlyCompanion => 'तव स्नेहमयः सहचरः';
	@override String get mentalHealthSupport => 'मानसिकस्वास्थसाहाय्यम्';
	@override String get mentalHealthSupportSubtitle => 'विचारान् विभजितुं श्रुतिं च अनुभवन्तुं सुरक्षितं स्थानम्।';
	@override String get friendlyCompanion => 'सौहार्दसहचरः';
	@override String get friendlyCompanionSubtitle => 'सदा गदितुं, प्रेरयितुं, ज्ञानं च दातुं सज्जः।';
	@override String get storiesAndWisdom => 'कथाः च प्रज्ञा च';
	@override String get storiesAndWisdomSubtitle => 'नित्यकथाभ्यः, व्यावहारिकप्रज्ञाभ्यश्च अधीयस्व।';
	@override String get askAnything => 'यत् किमपि पृच्छ';
	@override String get askAnythingSubtitle => 'भवतः प्रश्नानां कोमलान्, विचारशीलान् उत्तरान् लभस्व।';
	@override String get startChatting => 'संवादं आरभस्व';
	@override String get maybeLater => 'शायद् परम्';
	@override late final _TranslationsChatComposerAttachmentsSa composerAttachments = _TranslationsChatComposerAttachmentsSa._(_root);
}

// Path: map
class _TranslationsMapSa extends TranslationsMapEn {
	_TranslationsMapSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'अखण्डभारतम्';
	@override String get subtitle => 'इतिहासस्थलानि अन्वेषय';
	@override String get searchLocation => 'स्थानम् अन्वेषय...';
	@override String get viewDetails => 'विवरणं पश्य';
	@override String get viewSites => 'स्थलान् पश्य';
	@override String get showRoute => 'मार्गं दर्शय';
	@override String get historicalInfo => 'इतिहाससम्बद्धा सूचना';
	@override String get nearbyPlaces => 'समिपस्थलानि';
	@override String get pickLocationOnMap => 'मानचित्रे स्थानं चिनुत';
	@override String get sitesVisited => 'दृष्टस्थलानि';
	@override String get badgesEarned => 'लब्धचिह्नानि';
	@override String get completionRate => 'समाप्तितः प्रतिशतः';
	@override String get addToJourney => 'यात्रायां योजय';
	@override String get addedToJourney => 'यात्रायां योजितम्';
	@override String get getDirections => 'दिशाः प्राप्नुहि';
	@override String get viewInMap => 'मानचित्रे पश्य';
	@override String get directions => 'दिशाः';
	@override String get photoGallery => 'चित्र-संग्रहालयः';
	@override String get viewAll => 'सर्वाणि पश्य';
	@override String get photoSavedToGallery => 'चित्रं संग्रहालये संरक्षितम्';
	@override String get sacredSoundscape => 'पवित्रध्वनिपटलम्';
	@override String get allDiscussions => 'सर्वाः चर्चाः';
	@override String get journeyTab => 'यात्रा';
	@override String get discussionTab => 'चर्चा';
	@override String get myActivity => 'मम क्रियाः';
	@override String get anonymousPilgrim => 'अज्ञाततीर्थयात्री';
	@override String get viewProfile => 'प्रोफाइलं पश्य';
	@override String get discussionTitleHint => 'चर्चाशिर्षकं...';
	@override String get shareYourThoughtsHint => 'स्वविचारान् विभज...';
	@override String get pleaseEnterDiscussionTitle => 'कृपया चर्चायाः शीर्षकं लिख';
	@override String get addReflection => 'चिन्तनं योजय';
	@override String get reflectionTitle => 'शीर्षकम्';
	@override String get enterReflectionTitle => 'चिन्तनस्य शीर्षकं लिख';
	@override String get pleaseEnterTitle => 'कृपया शीर्षकं लिख';
	@override String get siteName => 'स्थलनाम';
	@override String get enterSacredSiteName => 'पवित्रस्थलस्य नाम लिख';
	@override String get pleaseEnterSiteName => 'कृपया स्थलस्य नाम लिख';
	@override String get reflection => 'चिन्तनम्';
	@override String get reflectionHint => 'स्वानुभवान् विचारांश्च विभज...';
	@override String get pleaseEnterReflection => 'कृपया स्वचिन्तनं लिख';
	@override String get saveReflection => 'चिन्तनं रक्ष';
	@override String get journeyProgress => 'यात्रागतिः';
	@override late final _TranslationsMapDiscussionsSa discussions = _TranslationsMapDiscussionsSa._(_root);
	@override late final _TranslationsMapFabricMapSa fabricMap = _TranslationsMapFabricMapSa._(_root);
	@override late final _TranslationsMapClassicalArtMapSa classicalArtMap = _TranslationsMapClassicalArtMapSa._(_root);
	@override late final _TranslationsMapClassicalDanceMapSa classicalDanceMap = _TranslationsMapClassicalDanceMapSa._(_root);
	@override late final _TranslationsMapFoodMapSa foodMap = _TranslationsMapFoodMapSa._(_root);
}

// Path: community
class _TranslationsCommunitySa extends TranslationsCommunityEn {
	_TranslationsCommunitySa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'समुदायः';
	@override String get trending => 'प्रचुरप्रचलितम्';
	@override String get following => 'अनुगच्छन्';
	@override String get followers => 'अनुगामिनः';
	@override String get posts => 'लेखाः';
	@override String get follow => 'अनुगच्छ';
	@override String get unfollow => 'अनुगमनं त्यज';
	@override String get shareYourStory => 'स्वकथां विभज...';
	@override String get post => 'प्रकाशय';
	@override String get like => 'रोचते';
	@override String get comment => 'प्रतिक्रिया';
	@override String get comments => 'प्रतिक्रियाः';
	@override String get noPostsYet => 'अद्यावधि लेखाः न सन्ति';
}

// Path: discover
class _TranslationsDiscoverSa extends TranslationsDiscoverEn {
	_TranslationsDiscoverSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'अन्वेषय';
	@override String get searchHint => 'कथाः, जनान्, विषयांश्च अन्वेषय...';
	@override String get tryAgain => 'पुनः प्रयतस्व';
	@override String get somethingWentWrong => 'किञ्चिद् दोषः अभवत्';
	@override String get unableToLoadProfiles => 'प्रोफाइल् आरोपयितुं न शक्यते। पुनः प्रयतस्व।';
	@override String get noProfilesFound => 'प्रोफाइल् न लब्धाः';
	@override String get searchToFindPeople => 'अनुगन्तुम् इच्छन्ति चेत्तु जनान् अन्वेषय';
	@override String get noResultsFound => 'न कश्चन फलः प्राप्तः';
	@override String get noProfilesYet => 'अद्यापि न कापि प्रोफाइल् अस्ति';
	@override String get tryDifferentKeywords => 'भिन्नैः पदैः अन्वेषणं कुरु';
	@override String get beFirstToDiscover => 'नूतनान् जनान् ज्ञातुं प्रथमः भव!';
}

// Path: plan
class _TranslationsPlanSa extends TranslationsPlanEn {
	_TranslationsPlanSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'योजनां रक्षितुं प्रथमं प्रविश';
	@override String get planSaved => 'योजना संरक्षिता';
	@override String get from => 'कस्मात्';
	@override String get dates => 'तिथयः';
	@override String get destination => 'गन्तव्यस्थानम्';
	@override String get nearby => 'समिपस्थितम्';
	@override String get generatedPlan => 'निर्मितयोजना';
	@override String get whereTravellingFrom => 'कस्मात् प्रदेशात् गमिष्यसि?';
	@override String get enterCityOrRegion => 'स्वनगरं वा क्षेत्रं लिख';
	@override String get travelDates => 'यात्रातिथयः';
	@override String get destinationSacredSite => 'गन्तव्यं (पवित्रस्थलम्)';
	@override String get searchOrSelectDestination => 'गन्तव्यं अन्वेषय वा चिनुत...';
	@override String get shareYourExperience => 'स्वं अनुभवम् विभज';
	@override String get planShared => 'योजना विभक्ता';
	@override String failedToSharePlan({required Object error}) => 'योजनां विभजितुं न शक्यते: ${error}';
	@override String get planUpdated => 'योजना अद्यतनीकृता';
	@override String failedToUpdatePlan({required Object error}) => 'योजनां अद्यतनीकर्तुं न शक्यते: ${error}';
	@override String get deletePlanConfirm => 'किं योजनां लोपयितुम् इच्छसि?';
	@override String get thisPlanPermanentlyDeleted => 'एषा योजना स्थायी रूपेण लुप्यते।';
	@override String get planDeleted => 'योजना लुप्ता';
	@override String failedToDeletePlan({required Object error}) => 'योजनां लोपयितुं न शक्यते: ${error}';
	@override String get sharePlan => 'योजनां विभज';
	@override String get deletePlan => 'योजनां लोपय';
	@override String get savedPlanDetails => 'संरक्षितायाः योजनायाः विवरणानि';
	@override String get pilgrimagePlan => 'तीर्थयात्रायोजनम्';
	@override String get planTab => 'योजना';
}

// Path: settings
class _TranslationsSettingsSa extends TranslationsSettingsEn {
	_TranslationsSettingsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'विन्यासाः';
	@override String get language => 'भाषा';
	@override String get theme => 'आभासः';
	@override String get themeLight => 'दीप्तिमान्';
	@override String get themeDark => 'अन्धकारः';
	@override String get themeSystem => 'तन्त्रस्य विषयं प्रयुञ्जीत';
	@override String get darkMode => 'अन्धकारमोडः';
	@override String get selectLanguage => 'भाषां चिनुत';
	@override String get notifications => 'सूचनाः';
	@override String get cacheSettings => 'कॅश तथा संग्रहः';
	@override String get general => 'सामान्यम्';
	@override String get account => 'खातम्';
	@override String get blockedUsers => 'निवारितोपयोगकर्तारः';
	@override String get helpSupport => 'साहाय्यं च समर्थनं च';
	@override String get contactUs => 'स्मान् सम्पृक्तवान् भव';
	@override String get legal => 'वैधानिकम्';
	@override String get privacyPolicy => 'गोपनीयतानीतिः';
	@override String get termsConditions => 'शर्ताः नियमाश्च';
	@override String get privacy => 'गोपनीयता';
	@override String get about => 'सम्बन्धे';
	@override String get version => 'संस्करणम्';
	@override String get logout => 'निर्गच्छ';
	@override String get deleteAccount => 'खातं लोपय';
	@override String get deleteAccountTitle => 'खातं लोपय';
	@override String get deleteAccountWarning => 'एषा क्रिया पुनर्न कर्तुं शक्यते!';
	@override String get deleteAccountDescription => 'खातं लोपयन् भवतः सर्वाः पोस्टाः, टिप्पण्यः, प्रोफाइल्, अनुगामिनः, संरक्षितकथाः, बुक्मार्क्, संवादसन्देशाः, निर्मिताः कथाश्च स्थायी रूपेण लुप्यन्ते।';
	@override String get confirmPassword => 'स्वपदं पुनः लिख';
	@override String get confirmPasswordDesc => 'खातं लोपयितुं पुष्टि-कृते स्वपदं लिख।';
	@override String get googleReauth => 'परिचयं प्रमाणयितुं त्वां Google इति देशं प्रेषयस्यामः।';
	@override String get finalConfirmationTitle => 'अन्तिमनिश्चयः';
	@override String get finalConfirmation => 'किं त्वं सम्यक् निश्चितः असि? एतत् स्थायी कार्यं, प्रत्यावर्तयितुं न शक्यते।';
	@override String get deleteMyAccount => 'मम खातं लोपय';
	@override String get deletingAccount => 'खातं लोपितुं प्रवर्तते...';
	@override String get accountDeleted => 'तव खातं स्थायी रूपेण लुप्तम्।';
	@override String get deleteAccountFailed => 'खातं लोपयितुं न शक्यते। पुनः प्रयतस्व।';
	@override String get downloadedStories => 'डाउनलोड् कृता: कथाः';
	@override String get couldNotOpenEmail => 'ईमेल-अनुप्रयोगः न उद्घाटितः। कृपया अस्मभ्यं myitihas@gmail.com इति लिखत।';
	@override String couldNotOpenLabel({required Object label}) => '${label} इदानीं उद्घाटयितुं न शक्यते।';
	@override String get logoutTitle => 'निर्गमनम्';
	@override String get logoutConfirm => 'किं नूनं निर्गन्तुम् इच्छसि?';
	@override String get verifyYourIdentity => 'स्वपरिचयं प्रमाणय';
	@override String get verifyYourIdentityDesc => 'परिचयं प्रमाणयितुं त्वां Google-द्वारा साइन्-इन कर्तुं याचयिष्यामः।';
	@override String get continueWithGoogle => 'Google इत्यनेन अनुवर्तस्व';
	@override String reauthFailed({required Object error}) => 'पुनः प्रमाणीकरणं विफलम्: ${error}';
	@override String get passwordRequired => 'गुप्तपदं आवश्यकम्';
	@override String get invalidPassword => 'अमान्यं गुप्तपदम्। पुनः प्रयतस्व।';
	@override String get verify => 'सत्यापय';
	@override String get continueLabel => 'अनुवर्तस्व';
	@override String get unableToVerifyIdentity => 'परिचयं सत्यापयितुं न शक्यते। पुनः प्रयतस्व।';
}

// Path: auth
class _TranslationsAuthSa extends TranslationsAuthEn {
	_TranslationsAuthSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get login => 'प्रवेशः';
	@override String get signup => 'पञ्जीकरणम्';
	@override String get email => 'ईमेल्';
	@override String get password => 'गुप्तपदम्';
	@override String get confirmPassword => 'गुप्तपदस्य पुष्टि:';
	@override String get forgotPassword => 'किं गुप्तपदं विस्मृतवान् असि?';
	@override String get resetPassword => 'गुप्तपदं पुनः निर्धारय';
	@override String get dontHaveAccount => 'किं खातं नास्ति?';
	@override String get alreadyHaveAccount => 'किं पूर्वमेव खातं अस्ति?';
	@override String get loginSuccess => 'प्रवेशः सफलः';
	@override String get signupSuccess => 'पञ्जीकरणं सफलम्';
	@override String get loginError => 'प्रवेशे दोषः';
	@override String get signupError => 'पञ्जीकरणे दोषः';
}

// Path: error
class _TranslationsErrorSa extends TranslationsErrorEn {
	_TranslationsErrorSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get network => 'जालसंबन्धः नास्ति';
	@override String get server => 'सर्वरे दोषः जातः';
	@override String get cache => 'सञ्चितं दत्तांशं आरोपयितुं न शक्यते';
	@override String get timeout => 'अनुरोधस्य समयः समाप्तः';
	@override String get notFound => 'संसाधनं न लब्धम्';
	@override String get validation => 'सत्यापनं विफलम्';
	@override String get unexpected => 'अप्रत्याशितदोषः अभवत्';
	@override String get tryAgain => 'पुनः प्रयतस्व';
	@override String couldNotOpenLink({required Object url}) => 'लिङ्क् उद्घाटयितुं न शक्यते: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionSa extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get free => 'निःशुल्कम्';
	@override String get plus => 'प्लस্';
	@override String get pro => 'प्रो';
	@override String get upgradeToPro => 'प्रो इत्यस्मिन् उत्कर्षय';
	@override String get features => 'विशेषताः';
	@override String get subscribe => 'सदस्यतां गृहाण';
	@override String get currentPlan => 'वर्तमानयोजना';
	@override String get managePlan => 'योजनां प्रबन्धय';
}

// Path: notification
class _TranslationsNotificationSa extends TranslationsNotificationEn {
	_TranslationsNotificationSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'सूचनाः';
	@override String get peopleToConnect => 'यैः सह संयोजनीयम्';
	@override String get peopleToConnectSubtitle => 'अनुगन्तुं जनान् अन्वेषय';
	@override String followAgainInMinutes({required Object minutes}) => 'त्वं ${minutes} निमेषेषु punar anugन्तुं शक्नोषि';
	@override String get noSuggestions => 'इदानीं न काचित् सिफारिश् अस्ति';
	@override String get markAllRead => 'सर्वाणि पठितानि इति चिह्नय';
	@override String get noNotifications => 'अद्यावधि न काचित् सूचना';
	@override String get noNotificationsSubtitle => 'यदा कश्चित् तव कथाभिः सह क्रियते, अत्र द्रक्ष्यसि।';
	@override String get errorPrefix => 'दोषः:';
	@override String get retry => 'पुनः प्रयतस्व';
	@override String likedYourStory({required Object actorName}) => '${actorName} तव कथां रोचते';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} तव कथायाः विषये टिप्पणीं कृतवान्';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} तव टिप्पण्याः उत्तरं दत्तवान्';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} त्वां अनुगन्तुं आरब्धवान्';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} त्वां प्रति सन्देशं प्रेषितवान्';
	@override String sharedYourStory({required Object actorName}) => '${actorName} तव कथां विभक्तवान्';
	@override String repostedYourStory({required Object actorName}) => '${actorName} तव कथां punar प्रकाशितवान्';
	@override String mentionedYou({required Object actorName}) => '${actorName} त्वां उल्लिखितवान्';
	@override String newPostFrom({required Object actorName}) => '${actorName} इत्यस्मात् नूतनलेखः';
	@override String get today => 'अद्य';
	@override String get thisWeek => 'अस्य सप्ताहस्य';
	@override String get earlier => 'पूर्वम्';
	@override String get delete => 'लोपय';
}

// Path: profile
class _TranslationsProfileSa extends TranslationsProfileEn {
	_TranslationsProfileSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get followers => 'अनुगामिनः';
	@override String get following => 'येषां त्वम् अनुगच्छसि';
	@override String get unfollow => 'अनुगमनं त्यज';
	@override String get follow => 'अनुगच्छ';
	@override String get about => 'सम्बन्धे';
	@override String get stories => 'कथाः';
	@override String get unableToShareImage => 'चित्रं विभजितुं न शक्यते';
	@override String get imageSavedToPhotos => 'चित्रं चित्रसंग्रहालये संरक्षितम्';
	@override String get view => 'पश्य';
	@override String get saveToPhotos => 'चित्रेषु रक्ष';
	@override String get failedToLoadImage => 'चित्रं आरोपयितुं न शक्यते';
}

// Path: feed
class _TranslationsFeedSa extends TranslationsFeedEn {
	_TranslationsFeedSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get loading => 'कथाः आरोप्यन्ते...';
	@override String get loadingPosts => 'लेखाः आरोप्यन्ते...';
	@override String get loadingVideos => 'चलच्चित्राणि आरोप्यन्ते...';
	@override String get loadingStories => 'कथाः आरोप्यन्ते...';
	@override String get errorTitle => 'अहो! किञ्चिद् दोषः अभवत्';
	@override String get tryAgain => 'पुनः प्रयतस्व';
	@override String get noStoriesAvailable => 'कथाः न उपलब्धाः';
	@override String get noImagesAvailable => 'चित्रलेखाः न सन्ति';
	@override String get noTextPostsAvailable => 'पाठ्यलेखाः न सन्ति';
	@override String get noContentAvailable => 'न काचित् सामग्री उपलब्धा';
	@override String get refresh => 'नवीनतां कुरु';
	@override String get comments => 'टिप्पण्यः';
	@override String get commentsComingSoon => 'टिप्पण्यः शीघ्रं आगमिष्यन्ति';
	@override String get addCommentHint => 'टिप्पणीं योजय...';
	@override String get shareStory => 'कथां विभज';
	@override String get sharePost => 'लेखं विभज';
	@override String get shareThought => 'चिन्तनं विभज';
	@override String get shareAsImage => 'चित्ररूपेण विभज';
	@override String get shareAsImageSubtitle => 'सुन्दरं पूर्वावलोकनपत्रं निर्मास्य';
	@override String get shareLink => 'लिङ्कं विभज';
	@override String get shareLinkSubtitle => 'कथालिङ्कं प्रतिलिख वा विभज';
	@override String get shareImageLinkSubtitle => 'लेखस्य लिङ्कं प्रतिलिख वा विभज';
	@override String get shareTextLinkSubtitle => 'चिन्तनस्य लिङ्कं प्रतिलिख वा विभज';
	@override String get shareAsText => 'पाठ्यरूपेण विभज';
	@override String get shareAsTextSubtitle => 'कथाया अंशं विभज';
	@override String get shareQuote => 'उक्ति विभज';
	@override String get shareQuoteSubtitle => 'उक्तिरूपेण विभज';
	@override String get shareWithImage => 'चित्रसहितं विभज';
	@override String get shareWithImageSubtitle => 'चित्रं शीर्षिकया सह विभज';
	@override String get copyLink => 'लिङ्कं प्रतिलिख';
	@override String get copyLinkSubtitle => 'लिङ्कं क्लिप्बोर्डे स्थापय';
	@override String get copyText => 'पाठ्यं प्रतिलिख';
	@override String get copyTextSubtitle => 'उक्तिं क्लिप्बोर्डे स्थापय';
	@override String get linkCopied => 'लिङ्कं क्लिप्बोर्डे स्थापितम्';
	@override String get textCopied => 'पाठ्यं क्लिप्बोर्डे स्थापितम्';
	@override String get sendToUser => 'उपयोगकर्त्रे प्रेषय';
	@override String get sendToUserSubtitle => 'मित्रे साक्षात् विभज';
	@override String get chooseFormat => 'रूपं चिनुत';
	@override String get linkPreview => 'लिङ्कपूर्वावलोकनम्';
	@override String get linkPreviewSize => '१२०० × ६३०';
	@override String get storyFormat => 'स्टोरीरूपम्';
	@override String get storyFormatSize => '१०८० × १९२० (Instagram/Stories)';
	@override String get generatingPreview => 'पूर्वावलोकनं निर्मीयते...';
	@override String get bookmarked => 'चिह्नितम्';
	@override String get removedFromBookmarks => 'चिह्नात् निष्कासितम्';
	@override String unlike({required Object count}) => 'अनलाइक्, ${count} रोचने';
	@override String like({required Object count}) => 'लाइक्, ${count} रोचने';
	@override String commentCount({required Object count}) => '${count} टिप्पण्यः';
	@override String shareCount({required Object count}) => 'विभज, ${count} वारं विभक्तम्';
	@override String get removeBookmark => 'चिह्नं निष्कासय';
	@override String get addBookmark => 'चिह्नं कुरु';
	@override String get quote => 'उक्ति:';
	@override String get quoteCopied => 'उक्ति: क्लिप्बोर्डे स्थापितम्';
	@override String get copy => 'प्रतिलिख';
	@override String get tapToViewFullQuote => 'समग्रां उक्तिं द्रष्टुं स्पृश';
	@override String get quoteFromMyitihas => 'MyItihas इत्यस्मात् उक्तिः';
	@override late final _TranslationsFeedTabsSa tabs = _TranslationsFeedTabsSa._(_root);
	@override String get tapToShowCaption => 'शीर्षिकां द्रष्टुं स्पृश';
	@override String get noVideosAvailable => 'चलच्चित्राणि न सन्ति';
	@override String get selectUser => 'कस्मै प्रेषय';
	@override String get searchUsers => 'उपयोगकर्तॄन् अन्वेषय...';
	@override String get noFollowingYet => 'त्वं अद्यावधि न कस्यापि अनुगामी';
	@override String get noUsersFound => 'उपयोगकर्तारः न लब्धाः';
	@override String get tryDifferentSearch => 'भिन्नस्य शब्दस्य प्रयोजनं कुरु';
	@override String sentTo({required Object username}) => '${username} इत्यस्मै प्रेषितम्';
}

// Path: voice
class _TranslationsVoiceSa extends TranslationsVoiceEn {
	_TranslationsVoiceSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'माइक्रोफोन-अनुमतिः आवश्यकाः';
	@override String get speechRecognitionNotAvailable => 'वाक्परिज्ञान-सेवा उपलब्धा नास्ति';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsSa extends TranslationsFestivalsEn {
	_TranslationsFestivalsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'उत्सवकथाः';
	@override String get tellStory => 'कथां वदतु';
}

// Path: social
class _TranslationsSocialSa extends TranslationsSocialEn {
	_TranslationsSocialSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileSa editProfile = _TranslationsSocialEditProfileSa._(_root);
	@override late final _TranslationsSocialCreatePostSa createPost = _TranslationsSocialCreatePostSa._(_root);
	@override late final _TranslationsSocialCommentsSa comments = _TranslationsSocialCommentsSa._(_root);
	@override late final _TranslationsSocialEngagementSa engagement = _TranslationsSocialEngagementSa._(_root);
	@override String get editCaption => 'शीर्षिकां सम्पादय';
	@override String get reportPost => 'लेखस्य विषये निवेदय';
	@override String get reportReasonHint => 'अस्मै लेखे किं दोषः अस्ति इति वद';
	@override String get deletePost => 'लेखं लोपय';
	@override String get deletePostConfirm => 'एषा क्रिया पुनर्न कर्तुं शक्यते।';
	@override String get postDeleted => 'लेखः लुप्तः';
	@override String failedToDeletePost({required Object error}) => 'लेखं लोपयितुं न शक्यते: ${error}';
	@override String failedToReportPost({required Object error}) => 'लेखस्य विषये निवेदयितुं न शक्यते: ${error}';
	@override String get reportSubmitted => 'निवेदनं समर्पितम्। धन्यवादः।';
	@override String get acceptRequestFirst => 'प्रथमं अनुरोध-पृष्ठे तेषां अनुरोधं स्वीकुरु।';
	@override String get requestSentWait => 'अनुरोधः प्रेषितः। तेषां स्वीकृतिं प्रतीक्षस्व।';
	@override String get requestSentTheyWillSee => 'अनुरोधः प्रेषितः। ते "अनुरोधाः" मध्ये द्रक्ष्यन्ति।';
	@override String failedToShare({required Object error}) => 'विभजनं विफलम्: ${error}';
	@override String get updateCaptionHint => 'स्वलेखस्य शीर्षिकां अद्यतनीकुरु';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroSa extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'अन्वेष्टुं स्पृशतु';
	@override late final _TranslationsHomeScreenHeroStorySa story = _TranslationsHomeScreenHeroStorySa._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionSa companion = _TranslationsHomeScreenHeroCompanionSa._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageSa heritage = _TranslationsHomeScreenHeroHeritageSa._(_root);
	@override late final _TranslationsHomeScreenHeroCommunitySa community = _TranslationsHomeScreenHeroCommunitySa._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesSa messages = _TranslationsHomeScreenHeroMessagesSa._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthSa extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get short => 'ह्रस्वा';
	@override String get medium => 'मध्यमा';
	@override String get long => 'दीर्घा';
	@override String get epic => 'महाकाव्यरूपा';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatSa extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'वर्णनात्मकम्';
	@override String get dialogue => 'संवादात्मकम्';
	@override String get poetic => 'काव्यमयम्';
	@override String get scriptural => 'शास्त्रीयम्';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsSa extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'कृष्णस्य अर्जुनं प्रति उपदेशस्य कथां वद...';
	@override String get warriorRedemption => 'प्रायश्चित्तं अन्वेषयतः योद्धुः विषये महाकाव्यकथां लिख...';
	@override String get sageWisdom => 'ऋषीणां प्रज्ञाया विषये कथां रच...';
	@override String get devotedSeeker => 'भक्तस्य साधकस्य यात्रां वर्णय...';
	@override String get divineIntervention => 'दिव्यहस्तक्षेपस्य आख्यायिकां विभज...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsSa extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'कृपया सर्वान् आवश्यकविकल्पान् पूरय';
	@override String get generationFailed => 'कथाजननं विफलम्। पुनः प्रयतस्व।';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsSa extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  नमस्ते!';
	@override String get dharma => '📖  धर्मः किम्?';
	@override String get stress => '🧘  तनावं कथं नियच्छेत्';
	@override String get karma => '⚡  कर्म सरलतया व्याख्याहि';
	@override String get story => '💬  मह्यं एकां कथां कथय';
	@override String get wisdom => '🌟  अद्यतनं ज्ञानम्';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsSa extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

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
class _TranslationsMapDiscussionsSa extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'चर्चां प्रेषय';
	@override String get intentCardCta => 'एकां चर्चां प्रेषय';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapSa extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapSa extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapSa extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

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
class _TranslationsMapFoodMapSa extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

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
class _TranslationsFeedTabsSa extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get all => 'सर्वम्';
	@override String get stories => 'कथाः';
	@override String get posts => 'लेखाः';
	@override String get videos => 'चलच्चित्राणि';
	@override String get images => 'चित्राणि';
	@override String get text => 'चिन्तनानि';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileSa extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'प्रोफाइल् सम्पादय';
	@override String get displayName => 'दर्शितनाम';
	@override String get displayNameHint => 'स्वदर्शितनाम लिख';
	@override String get displayNameEmpty => 'दर्शितनाम रिक्तं न भवेत्';
	@override String get bio => 'जीवनवृत्तान्तः';
	@override String get bioHint => 'स्वयं विषये वद...';
	@override String get changePhoto => 'प्रोफाइल्-चित्रं परिवर्तय';
	@override String get saveChanges => 'परिवर्तनानि रक्ष';
	@override String get profileUpdated => 'प्रोफाइल् सफलतया अद्यतनीकृता';
	@override String get profileAndPhotoUpdated => 'प्रोफाइल् चित्रञ्च सफलतया अद्यतनीकृतम्';
	@override String failedPickImage({required Object error}) => 'चित्रं गृह्णातुं न शक्यते: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'चित्रं उच्चैः स्थापयितुं न शक्यते: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'प्रोफाइल् अद्यतनीकर्तुं न शक्यते: ${error}';
	@override String unexpectedError({required Object error}) => 'अप्रत्याशितदोषः अभवत्: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostSa extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get title => 'लेखं निर्मास्य';
	@override String get post => 'प्रकाशय';
	@override String get text => 'पाठ्यम्';
	@override String get image => 'चित्रम्';
	@override String get video => 'चलच्चित्रम्';
	@override String get textHint => 'तव मनसि किं विद्यते?';
	@override String get imageCaptionHint => 'चित्रस्य कृते शीर्षिकां लिख...';
	@override String get videoCaptionHint => 'स्वचलच्चित्रं वर्णय...';
	@override String get shareCaptionHint => 'स्वचिन्तनानि योजय...';
	@override String get titleHint => 'शीर्षकं योजय (ऐच्छिकम्)';
	@override String get selectVideo => 'चलच्चित्रं चिनुत';
	@override String get gallery => 'संग्रहालयः';
	@override String get camera => 'दर्शकयन्त्रः';
	@override String get visibility => 'इदं के पश्येयुः?';
	@override String get public => 'सार्वजनिकम्';
	@override String get followers => 'अनुगामिनः';
	@override String get private => 'निजम्';
	@override String get postCreated => 'लेखः निर्मितः!';
	@override String get failedPickImages => 'चित्राणि गृह्णातुं न शक्यन्ते';
	@override String get failedPickVideo => 'चलच्चित्रं गृह्णातुं न शक्यते';
	@override String get failedCapturePhoto => 'चित्रग्रहणं विफलम्';
	@override String get cannotCreateOffline => 'ऑफ़लाइन-अवस्थायां लेखः निर्मातुं न शक्यते';
	@override String get discardTitle => 'लेखं परित्यजसि?';
	@override String get discardMessage => 'असुरक्षितपरिवर्तनानि सन्ति। किं नूनं एतं लेखं परित्यक्तुम् इच्छसि?';
	@override String get keepEditing => 'सम्पादनं अनुवर्तस्व';
	@override String get discard => 'परित्यज';
	@override String get cropPhoto => 'चित्रं छिन्दि';
	@override String get trimVideo => 'चलच्चित्रं संक्षिपय';
	@override String get editPhoto => 'चित्रं सम्पादय';
	@override String get editVideo => 'चलच्चित्रं सम्पादय';
	@override String get maxDuration => 'परम ३० निमेषाः';
	@override String get aspectSquare => 'वर्गाकारम्';
	@override String get aspectPortrait => 'ऊर्ध्वविस्तीर्णम्';
	@override String get aspectLandscape => 'अधोविस्तीर्णम्';
	@override String get aspectFree => 'स्वतन्त्राकारः';
	@override String get failedCrop => 'चित्रछेदनं विफलम्';
	@override String get failedTrim => 'चलच्चित्रसंक्षेपः विफलः';
	@override String get trimmingVideo => 'चलच्चित्रं संक्षिप्यते...';
	@override String trimVideoSubtitle({required Object max}) => 'परमं ${max}से · स्वस्य श्रेष्ठभागं चिनुत';
	@override String get trimVideoInstructionsTitle => 'स्वक्लिप् संक्षिपय';
	@override String get trimVideoInstructionsBody => 'आदिअन्तहस्तिकौ आक्रुष्य 30 सेकण्ड् पर्यन्तं भागं चिनुत।';
	@override String get trimStart => 'आदि';
	@override String get trimEnd => 'अन्त';
	@override String get trimSelectionEmpty => 'अनुवर्तनाय वैधपरिसरं चिनुत';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}से चयनितम् (${start}–${end}) · परमं ${max}से';
	@override String get coverFrame => 'आवरणफ्रेम्';
	@override String get coverFrameUnavailable => 'पूर्वावलोकनं नास्ति';
	@override String coverFramePosition({required Object time}) => '${time} समये आवरणम्';
	@override String get overlayLabel => 'विडियो उपरि पाठः (ऐच्छिकम्)';
	@override String get overlayHint => 'लघु-हुक् अथवा शीर्षकं योजय';
	@override String get imageSectionHint => 'संग्रहालयात् वा दर्शकयन्त्रात् यावत् १० चित्राणि योजय';
	@override String get videoSectionHint => 'एकं चलच्चित्रम्, परम ३० निमेषाः';
	@override String get removePhoto => 'चित्रं निष्कासय';
	@override String get removeVideo => 'चलच्चित्रं निष्कासय';
	@override String get photoEditHint => 'छिन्दितुं निष्कासयितुं वा चित्रं स्पृश';
	@override String get videoEditOptions => 'सम्पादनविकल्पाः';
	@override String get addPhoto => 'चित्रं योजय';
	@override String get done => 'समाप्तम्';
	@override String get rotate => 'घूर्णनं कुरु';
	@override String get editPhotoSubtitle => 'फीड् मध्ये उत्तमदर्शने कृते वर्गाकारं कुरु';
	@override String get videoEditorCaptionLabel => 'शीर्षकं / पाठः (ऐच्छिकम्)';
	@override String get videoEditorCaptionHint => 'उदाहरणम्: भवतः रील्-निमित्तं शीर्षकं वा आकर्षक-वाक्यम्';
	@override String get videoEditorAspectLabel => 'अनुपातः';
	@override String get videoEditorAspectOriginal => 'मूलम्';
	@override String get videoEditorAspectSquare => '१:१';
	@override String get videoEditorAspectPortrait => '९:१६';
	@override String get videoEditorAspectLandscape => '१६:९';
	@override String get videoEditorQuickTrim => 'शीघ्र-छेदनम्';
	@override String get videoEditorSpeed => 'वेगः';
}

// Path: social.comments
class _TranslationsSocialCommentsSa extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} इत्यस्मै प्रत्युत्तरं दद्यते';
	@override String replyHint({required Object name}) => '${name} इत्यस्मै प्रत्युत्तरं लिख...';
	@override String failedToPost({required Object error}) => 'प्रकाशयितुं न शक्यते: ${error}';
	@override String get cannotPostOffline => 'ऑफ़लाइन-अवस्थायां टिप्पणीं कर्तुं न शक्यते';
	@override String get noComments => 'अद्यावधि न कापि टिप्पणी';
	@override String get beFirst => 'प्रथमं टिप्पणीं कुरु!';
}

// Path: social.engagement
class _TranslationsSocialEngagementSa extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'ऑफ़लाइनमोडः';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStorySa extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStorySa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'एआइ-कथा-सृजनम्';
	@override String get headline => 'मनोरमाः\nकथाः\nनिर्मीयन्ताम्';
	@override String get subHeadline => 'प्राचीन-प्रज्ञया प्रेरितम्';
	@override String get line1 => '✦  एकं पवित्रं शास्त्रं वृणुत...';
	@override String get line2 => '✦  सजीवं परिवेशं चिनुत...';
	@override String get line3 => '✦  एआइं मोहमयीं कथां विनेतुं अनुमन्यताम्...';
	@override String get cta => 'कथां जनय';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionSa extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'आध्यात्मिकः साथी';
	@override String get headline => 'तव दिव्यः\nमार्गदर्शकः,\nसदा समीपे';
	@override String get subHeadline => 'कृष्णस्य प्रज्ञया प्रेरितम्';
	@override String get line1 => '✦  यः मित्रः सत्येन शृणोति...';
	@override String get line2 => '✦  जीवन-संघर्षेषु प्रज्ञा...';
	@override String get line3 => '✦  ये संवादाः त्वां उत्थापयन्ति...';
	@override String get cta => 'संवादं आरभस्व';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageSa extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'धरोहर-मानचित्रम्';
	@override String get headline => 'सनातनां\nधरोहरां\nअवलोकय';
	@override String get subHeadline => '5000+ पवित्र-स्थलानि मानचित्रितानि';
	@override String get line1 => '✦  पवित्रस्थानानि अन्वेषय...';
	@override String get line2 => '✦  इतिहासं कथाश्रुतिं च पठ...';
	@override String get line3 => '✦  सार्थक-यात्राः योजनय...';
	@override String get cta => 'मानचित्रम् अवलोकय';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunitySa extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunitySa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'समुदाय-क्षेत्रम्';
	@override String get headline => 'संस्कृतिं\nविश्वेन सह\nविभजस्व';
	@override String get subHeadline => 'सजीवः वैश्विकः समुदायः';
	@override String get line1 => '✦  लेखाः गभीर-विमर्शाश्च...';
	@override String get line2 => '✦  लघवः सांस्कृतिक-चलच्चित्राः...';
	@override String get line3 => '✦  विश्वस्य सर्वतः कथाः...';
	@override String get cta => 'समुदाये सम्मिलस्व';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesSa extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesSa._(TranslationsSa root) : this._root = root, super.internal(root);

	final TranslationsSa _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'निज-सन्देशाः';
	@override String get headline => 'अर्थपूर्णाः\nसंवादाः\nअत्र आरभ्यन्ते';
	@override String get subHeadline => 'निजानि चिन्तनशीलानि च स्थानानि';
	@override String get line1 => '✦  समचित्तैः सह संयुज्यस्व...';
	@override String get line2 => '✦  विचारान् कथाश्च चर्चय...';
	@override String get line3 => '✦  चिन्तनशीलान् समुदायान् निर्माहि...';
	@override String get cta => 'सन्देशान् उद्घाटय';
}
