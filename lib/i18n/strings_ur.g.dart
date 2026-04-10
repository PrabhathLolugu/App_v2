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
class TranslationsUr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsUr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ur,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <ur>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsUr _root = this; // ignore: unused_field

	@override 
	TranslationsUr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsUr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppUr app = _TranslationsAppUr._(_root);
	@override late final _TranslationsCommonUr common = _TranslationsCommonUr._(_root);
	@override late final _TranslationsNavigationUr navigation = _TranslationsNavigationUr._(_root);
	@override late final _TranslationsHomeUr home = _TranslationsHomeUr._(_root);
	@override late final _TranslationsHomeScreenUr homeScreen = _TranslationsHomeScreenUr._(_root);
	@override late final _TranslationsStoriesUr stories = _TranslationsStoriesUr._(_root);
	@override late final _TranslationsStoryGeneratorUr storyGenerator = _TranslationsStoryGeneratorUr._(_root);
	@override late final _TranslationsChatUr chat = _TranslationsChatUr._(_root);
	@override late final _TranslationsMapUr map = _TranslationsMapUr._(_root);
	@override late final _TranslationsCommunityUr community = _TranslationsCommunityUr._(_root);
	@override late final _TranslationsDiscoverUr discover = _TranslationsDiscoverUr._(_root);
	@override late final _TranslationsPlanUr plan = _TranslationsPlanUr._(_root);
	@override late final _TranslationsSettingsUr settings = _TranslationsSettingsUr._(_root);
	@override late final _TranslationsAuthUr auth = _TranslationsAuthUr._(_root);
	@override late final _TranslationsErrorUr error = _TranslationsErrorUr._(_root);
	@override late final _TranslationsSubscriptionUr subscription = _TranslationsSubscriptionUr._(_root);
	@override late final _TranslationsNotificationUr notification = _TranslationsNotificationUr._(_root);
	@override late final _TranslationsProfileUr profile = _TranslationsProfileUr._(_root);
	@override late final _TranslationsFeedUr feed = _TranslationsFeedUr._(_root);
	@override late final _TranslationsVoiceUr voice = _TranslationsVoiceUr._(_root);
	@override late final _TranslationsFestivalsUr festivals = _TranslationsFestivalsUr._(_root);
	@override late final _TranslationsSocialUr social = _TranslationsSocialUr._(_root);
}

// Path: app
class _TranslationsAppUr extends TranslationsAppEn {
	_TranslationsAppUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'بھارتی صحیفوں کو دریافت کریں';
}

// Path: common
class _TranslationsCommonUr extends TranslationsCommonEn {
	_TranslationsCommonUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ٹھیک ہے';
	@override String get cancel => 'منسوخ کریں';
	@override String get confirm => 'تصدیق کریں';
	@override String get delete => 'حذف کریں';
	@override String get edit => 'ترمیم کریں';
	@override String get save => 'محفوظ کریں';
	@override String get share => 'شیئر کریں';
	@override String get search => 'تلاش کریں';
	@override String get loading => 'لوڈ ہو رہا ہے...';
	@override String get error => 'خرابی';
	@override String get retry => 'دوبارہ کوشش کریں';
	@override String get back => 'واپس';
	@override String get next => 'اگلا';
	@override String get finish => 'مکمل کریں';
	@override String get skip => 'چھوڑ دیں';
	@override String get yes => 'ہاں';
	@override String get no => 'نہیں';
	@override String get readFullStory => 'مکمل کہانی پڑھیں';
	@override String get dismiss => 'بند کریں';
	@override String get offlineBannerMessage => 'آپ آف لائن ہیں – محفوظ شدہ مواد دیکھ رہے ہیں';
	@override String get backOnline => 'دوبارہ آن لائن';
}

// Path: navigation
class _TranslationsNavigationUr extends TranslationsNavigationEn {
	_TranslationsNavigationUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get home => 'دریافت';
	@override String get stories => 'کہانیاں';
	@override String get chat => 'چیٹ';
	@override String get map => 'نقشہ';
	@override String get community => 'سوشل';
	@override String get settings => 'سیٹنگز';
	@override String get profile => 'پروفائل';
}

// Path: home
class _TranslationsHomeUr extends TranslationsHomeEn {
	_TranslationsHomeUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'اسٹوری جنریٹر';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'کمیونٹی کی کہانیاں';
	@override String get maps => 'نقشے';
	@override String get greetingMorning => 'صبح بخیر';
	@override String get continueReading => 'پڑھنا جاری رکھیں';
	@override String get greetingAfternoon => 'دوپہر بخیر';
	@override String get greetingEvening => 'شام بخیر';
	@override String get greetingNight => 'شب بخیر';
	@override String get exploreStories => 'کہانیاں دریافت کریں';
	@override String get generateStory => 'کہانی بنائیں';
	@override String get content => 'ہوم مواد';
}

// Path: homeScreen
class _TranslationsHomeScreenUr extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'السلام علیکم';
	@override String get quoteOfTheDay => 'آج کا اقتباس';
	@override String get shareQuote => 'اقتباس شیئر کریں';
	@override String get copyQuote => 'اقتباس کاپی کریں';
	@override String get quoteCopied => 'اقتباس کلپ بورڈ پر کاپی ہو گیا';
	@override String get featuredStories => 'منتخب کہانیاں';
	@override String get quickActions => 'فوری عمل';
	@override String get generateStory => 'کہانی بنائیں';
	@override String get chatWithKrishna => 'کرشن سے بات کریں';
	@override String get myActivity => 'میری سرگرمیاں';
	@override String get continueReading => 'پڑھائی جاری رکھیں';
	@override String get savedStories => 'محفوظ شدہ کہانیاں';
	@override String get exploreMyitihas => 'مائیتہاس دریافت کریں';
	@override String get storiesInYourLanguage => 'آپ کی زبان میں کہانیاں';
	@override String get seeAll => 'سب دیکھیں';
	@override String get startReading => 'پڑھنا شروع کریں';
	@override String get exploreStories => 'اپنی روحانی سفر شروع کرنے کے لیے کہانیاں دریافت کریں';
	@override String get saveForLater => 'پسندیدہ کہانیوں کو بعد کے لیے محفوظ کریں';
	@override String get noActivityYet => 'ابھی تک کوئی سرگرمی نہیں';
	@override String minLeft({required Object count}) => '${count} منٹ باقی';
	@override String get activityHistory => 'سرگرمیوں کی تاریخ';
	@override String get storyGenerated => 'ایک کہانی بنائی گئی';
	@override String get storyRead => 'ایک کہانی پڑھی گئی';
	@override String get storyBookmarked => 'کہانی کو بُک مارک کیا گیا';
	@override String get storyShared => 'کہانی شیئر کی گئی';
	@override String get storyCompleted => 'کہانی مکمل ہوئی';
	@override String get today => 'آج';
	@override String get yesterday => 'کل';
	@override String get thisWeek => 'اس ہفتے';
	@override String get earlier => 'اس سے پہلے';
	@override String get noContinueReading => 'فی الحال پڑھنے کے لیے کچھ نہیں';
	@override String get noSavedStories => 'ابھی تک کوئی محفوظ کہانی نہیں';
	@override String get bookmarkStoriesToSave => 'کہانیوں کو محفوظ کرنے کے لیے بُک مارک کریں';
	@override String get myGeneratedStories => 'میری کہانیاں';
	@override String get noGeneratedStoriesYet => 'ابھی تک کوئی کہانی نہیں بنائی گئی';
	@override String get createYourFirstStory => 'AI کی مدد سے اپنی پہلی کہانی بنائیں';
	@override String get shareToFeed => 'فیڈ پر شیئر کریں';
	@override String get sharedToFeed => 'کہانی فیڈ پر شیئر کر دی گئی';
	@override String get shareStoryTitle => 'کہانی شیئر کریں';
	@override String get shareStoryMessage => 'اپنی کہانی کے لیے ایک عنوان / کیپشن لکھیں (اختیاری)';
	@override String get shareStoryCaption => 'کیپشن';
	@override String get shareStoryHint => 'آپ اس کہانی کے بارے میں کیا کہنا چاہتے ہیں؟';
	@override String get exploreHeritageTitle => 'ورثہ تلاش کریں';
	@override String get exploreHeritageDesc => 'نقشے پر ثقافتی ورثہ کی جگہیں دریافت کریں';
	@override String get whereToVisit => 'اگلا دورہ';
	@override String get scriptures => 'صحیفے';
	@override String get exploreSacredSites => 'مقدس مقامات دریافت کریں';
	@override String get readStories => 'کہانیاں پڑھیں';
	@override String get yesRemindMe => 'جی ہاں، مجھے یاد دلائیں';
	@override String get noDontShowAgain => 'نہیں، دوبارہ مت دکھائیں';
	@override String get discoverDismissTitle => 'Discover MyItihas کو چھپانا ہے؟';
	@override String get discoverDismissMessage => 'کیا آپ اگلی بار ایپ کھولنے یا لاگ اِن کرنے پر اسے دوبارہ دیکھنا چاہیں گے؟';
	@override String get discoverCardTitle => 'MyItihas دریافت کریں';
	@override String get discoverCardSubtitle => 'قدیم صحیفوں کی کہانیاں، مقدس مقامات اور حکمت آپ کی انگلیوں پر۔';
	@override String get swipeToDismiss => 'بند کرنے کے لیے اوپر کی طرف سوائپ کریں';
	@override String get searchScriptures => 'صحیفے تلاش کریں...';
	@override String get searchLanguages => 'زبانیں تلاش کریں...';
	@override String get exploreStoriesLabel => 'کہانیاں دریافت کریں';
	@override String get exploreMore => 'مزید دیکھیں';
	@override String get failedToLoadActivity => 'سرگرمی لوڈ نہیں ہو سکی';
	@override String get startReadingOrGenerating => 'یہاں اپنی سرگرمیاں دیکھنے کے لیے کہانیاں پڑھنا یا بنانا شروع کریں';
	@override late final _TranslationsHomeScreenHeroUr hero = _TranslationsHomeScreenHeroUr._(_root);
}

// Path: stories
class _TranslationsStoriesUr extends TranslationsStoriesEn {
	_TranslationsStoriesUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'کہانیاں';
	@override String get searchHint => 'عنوان یا مصنف کے نام سے تلاش کریں...';
	@override String get sortBy => 'ترتیب دیں';
	@override String get sortNewest => 'نیا پہلے';
	@override String get sortOldest => 'پرانا پہلے';
	@override String get sortPopular => 'سب سے مقبول';
	@override String get noStories => 'کوئی کہانی نہیں ملی';
	@override String get loadingStories => 'کہانیاں لوڈ ہو رہی ہیں...';
	@override String get errorLoadingStories => 'کہانیاں لوڈ کرنے میں خرابی';
	@override String get storyDetails => 'کہانی کی تفصیل';
	@override String get continueReading => 'پڑھائی جاری رکھیں';
	@override String get readMore => 'مزید پڑھیں';
	@override String get readLess => 'کم دکھائیں';
	@override String get author => 'مصنف';
	@override String get publishedOn => 'شائع شدہ تاریخ';
	@override String get category => 'زمرہ';
	@override String get tags => 'ٹیگز';
	@override String get failedToLoad => 'کہانی لوڈ نہیں ہو سکی';
	@override String get subtitle => 'صحیفوں کی کہانیاں دریافت کریں';
	@override String get noStoriesHint => 'کہانیاں ڈھونڈنے کے لیے مختلف تلاش یا فلٹر آزمائیں۔';
	@override String get featured => 'نمایاں';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorUr extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'اسٹوری جنریٹر';
	@override String get subtitle => 'اپنی اپنی صحیفائی کہانی بنائیں';
	@override String get quickStart => 'فوری آغاز';
	@override String get interactive => 'انٹرایکٹو';
	@override String get rawPrompt => 'را پروامپٹ';
	@override String get yourStoryPrompt => 'آپ کی کہانی کے لیے پروامپٹ';
	@override String get writeYourPrompt => 'اپنا پروامپٹ لکھیں';
	@override String get selectScripture => 'صحیفہ منتخب کریں';
	@override String get selectStoryType => 'کہانی کی قسم منتخب کریں';
	@override String get selectCharacter => 'کردار منتخب کریں';
	@override String get selectTheme => 'موضوع منتخب کریں';
	@override String get selectSetting => 'پس منظر / جگہ منتخب کریں';
	@override String get selectLanguage => 'زبان منتخب کریں';
	@override String get selectLength => 'کہانی کی لمبائی';
	@override String get moreOptions => 'مزید اختیارات';
	@override String get random => 'رینڈم';
	@override String get generate => 'کہانی بنائیں';
	@override String get generating => 'آپ کی کہانی تیار کی جا رہی ہے...';
	@override String get creatingYourStory => 'آپ کی کہانی بنائی جا رہی ہے';
	@override String get consultingScriptures => 'قدیم صحیفوں سے رجوع کیا جا رہا ہے...';
	@override String get weavingTale => 'آپ کی داستان بُنی جا رہی ہے...';
	@override String get addingWisdom => 'الٰہی حکمت شامل کی جا رہی ہے...';
	@override String get polishingNarrative => 'کہانی کو خوبصورت بنایا جا رہا ہے...';
	@override String get almostThere => 'تقریباً مکمل...';
	@override String get generatedStory => 'آپ کی تیار کردہ کہانی';
	@override String get aiGenerated => 'AI کے ذریعے تیار کردہ';
	@override String get regenerate => 'دوبارہ بنائیں';
	@override String get saveStory => 'کہانی محفوظ کریں';
	@override String get shareStory => 'کہانی شیئر کریں';
	@override String get newStory => 'نئی کہانی';
	@override String get saved => 'محفوظ';
	@override String get storySaved => 'کہانی آپ کی لائبریری میں محفوظ ہو گئی';
	@override String get story => 'کہانی';
	@override String get lesson => 'سبق';
	@override String get didYouKnow => 'کیا آپ جانتے ہیں؟';
	@override String get activity => 'سرگرمی';
	@override String get optionalRefine => 'اختیاری: اختیارات کے ساتھ مزید بہتر بنائیں';
	@override String get applyOptions => 'اختیارات لاگو کریں';
	@override String get language => 'زبان';
	@override String get storyFormat => 'کہانی کی شکل';
	@override String get requiresInternet => 'کہانی بنانے کے لیے انٹرنیٹ درکار ہے';
	@override String get notAvailableOffline => 'کہانی آف لائن دستیاب نہیں۔ دیکھنے کے لیے انٹرنیٹ سے جڑیں۔';
	@override String get aiDisclaimer => 'AI کبھی کبھار غلطی کر سکتا ہے۔ ہم مسلسل بہتری پر کام کر رہے ہیں، آپ کی رائے ہمارے لیے اہم ہے۔';
	@override late final _TranslationsStoryGeneratorStoryLengthUr storyLength = _TranslationsStoryGeneratorStoryLengthUr._(_root);
	@override late final _TranslationsStoryGeneratorFormatUr format = _TranslationsStoryGeneratorFormatUr._(_root);
	@override late final _TranslationsStoryGeneratorHintsUr hints = _TranslationsStoryGeneratorHintsUr._(_root);
	@override late final _TranslationsStoryGeneratorErrorsUr errors = _TranslationsStoryGeneratorErrorsUr._(_root);
}

// Path: chat
class _TranslationsChatUr extends TranslationsChatEn {
	_TranslationsChatUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'صحیفوں کے بارے میں AI سے گفتگو کریں';
	@override String get friendMode => 'دوست موڈ';
	@override String get philosophicalMode => 'فلسفیانہ موڈ';
	@override String get typeMessage => 'اپنا پیغام لکھیں...';
	@override String get send => 'بھیجیں';
	@override String get newChat => 'نئی چیٹ';
	@override String get chatsTab => 'چیٹ';
	@override String get groupsTab => 'گروپس';
	@override String get chatHistory => 'چیٹ ہسٹری';
	@override String get clearChat => 'چیٹ صاف کریں';
	@override String get noMessages => 'ابھی تک کوئی پیغام نہیں۔ بات چیت شروع کریں!';
	@override String get listPage => 'چیٹ فہرست صفحہ';
	@override String get forwardMessageTo => 'پیغام فارورڈ کریں...';
	@override String get forwardMessage => 'پیغام فارورڈ کریں';
	@override String get messageForwarded => 'پیغام فارورڈ ہو گیا';
	@override String failedToForward({required Object error}) => 'پیغام فارورڈ کرنے میں ناکامی: ${error}';
	@override String get searchChats => 'چیٹس تلاش کریں';
	@override String get noChatsFound => 'کوئی چیٹ نہیں ملی';
	@override String get requests => 'درخواستیں';
	@override String get messageRequests => 'پیغام کی درخواستیں';
	@override String get groupRequests => 'گروپ کی درخواستیں';
	@override String get requestSent => 'درخواست بھیج دی گئی۔ وہ اسے "Requests" میں دیکھیں گے۔';
	@override String get wantsToChat => 'بات چیت کرنا چاہتا ہے';
	@override String addedYouTo({required Object name}) => '${name} نے آپ کو شامل کیا ہے';
	@override String get accept => 'قبول کریں';
	@override String get noMessageRequests => 'کوئی پیغام کی درخواست نہیں';
	@override String get noGroupRequests => 'کوئی گروپ کی درخواست نہیں';
	@override String get invitesSent => 'دعوت نامے بھیج دیے گئے۔ وہ انہیں "Requests" میں دیکھیں گے۔';
	@override String get cantMessageUser => 'آپ اس صارف کو پیغام نہیں بھیج سکتے';
	@override String get deleteChat => 'چیٹ حذف کریں';
	@override String get deleteChats => 'چیٹس حذف کریں';
	@override String get blockUser => 'صارف کو بلاک کریں';
	@override String get reportUser => 'صارف کی رپورٹ کریں';
	@override String get markAsRead => 'بطور پڑھی گئی نشان زد کریں';
	@override String get markedAsRead => 'پڑھی گئی کے طور پر نشان زد کیا گیا';
	@override String get deleteClearChat => 'چیٹ حذف / صاف کریں';
	@override String get deleteConversation => 'گفتگو حذف کریں';
	@override String get reasonRequired => 'وجہ (ضروری)';
	@override String get submit => 'جمع کریں';
	@override String get userReportedBlocked => 'صارف کی رپورٹ کر دی گئی اور بلاک کر دیا گیا۔';
	@override String reportFailed({required Object error}) => 'رپورٹ کرنے میں ناکامی: ${error}';
	@override String get newGroup => 'نیا گروپ';
	@override String get messageSomeoneDirectly => 'کسی کو براہِ راست پیغام بھیجیں';
	@override String get createGroupConversation => 'گروپ گفتگو بنائیں';
	@override String get noGroupsYet => 'ابھی تک کوئی گروپ نہیں';
	@override String get noChatsYet => 'ابھی تک کوئی چیٹ نہیں';
	@override String get tapToCreateGroup => 'گروپ بنانے یا شامل ہونے کے لیے + دبائیں';
	@override String get tapToStartConversation => 'نئی گفتگو شروع کرنے کے لیے + دبائیں';
	@override String get conversationDeleted => 'گفتگو حذف کر دی گئی';
	@override String conversationsDeleted({required Object count}) => '${count} گفتگو(ئیں) حذف کر دی گئیں';
	@override String get searchConversations => 'گفتگوئیں تلاش کریں...';
	@override String get connectToInternet => 'براہ کرم انٹرنیٹ سے جڑیں اور دوبارہ کوشش کریں۔';
	@override String get littleKrishnaName => 'چھوٹا کرشن';
	@override String get newConversation => 'نئی گفتگو';
	@override String get noConversationsYet => 'ابھی تک کوئی گفتگو نہیں';
	@override String get confirmDeletion => 'حذف کی تصدیق کریں';
	@override String deleteConversationConfirm({required Object title}) => 'کیا آپ واقعی ${title} گفتگو حذف کرنا چاہتے ہیں؟';
	@override String get deleteFailed => 'گفتگو حذف کرنے میں ناکام';
	@override String get fullChatCopied => 'پوری چیٹ کلپ بورڈ پر کاپی ہو گئی!';
	@override String get connectionErrorFallback => 'فی الحال کنکشن میں مسئلہ ہے۔ براہ کرم کچھ دیر بعد دوبارہ کوشش کریں۔';
	@override String krishnaWelcomeWithName({required Object name}) => 'ہی ${name}۔ میں آپ کا دوست کرشن ہوں۔ آج آپ کیسا محسوس کر رہے ہیں؟';
	@override String get krishnaWelcomeFriend => 'ہی میرے پیارے دوست۔ میں آپ کا دوست کرشن ہوں۔ آج آپ کیسا محسوس کر رہے ہیں؟';
	@override String get copyYouLabel => 'آپ';
	@override String get copyKrishnaLabel => 'کرشن';
	@override late final _TranslationsChatSuggestionsUr suggestions = _TranslationsChatSuggestionsUr._(_root);
	@override String get about => 'متعلق';
	@override String get yourFriendlyCompanion => 'آپ کا مخلص ساتھی';
	@override String get mentalHealthSupport => 'ذہنی صحت میں مدد';
	@override String get mentalHealthSupportSubtitle => 'ایسی محفوظ جگہ جہاں آپ اپنے خیالات بانٹ سکیں اور سنے جانے کا احساس ہو۔';
	@override String get friendlyCompanion => 'دوستانہ ساتھی';
	@override String get friendlyCompanionSubtitle => 'ہمیشہ بات کرنے، حوصلہ دینے اور حکمت بانٹنے کے لیے موجود۔';
	@override String get storiesAndWisdom => 'کہانیاں اور حکمت';
	@override String get storiesAndWisdomSubtitle => 'ہمیشہ رہنے والی کہانیوں اور عملی بصیرت سے سیکھیں۔';
	@override String get askAnything => 'جو چاہیں پوچھیں';
	@override String get askAnythingSubtitle => 'اپنے سوالات کے لیے نرم، سوچ سمجھ کر دیے گئے جوابات حاصل کریں۔';
	@override String get startChatting => 'چیٹنگ شروع کریں';
	@override String get maybeLater => 'بعد میں';
	@override late final _TranslationsChatComposerAttachmentsUr composerAttachments = _TranslationsChatComposerAttachmentsUr._(_root);
}

// Path: map
class _TranslationsMapUr extends TranslationsMapEn {
	_TranslationsMapUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'اَکھنڈ بھارت';
	@override String get subtitle => 'تاریخی مقامات دریافت کریں';
	@override String get searchLocation => 'مقام تلاش کریں...';
	@override String get viewDetails => 'تفصیلات دیکھیں';
	@override String get viewSites => 'مقامات دیکھیں';
	@override String get showRoute => 'روٹ دکھائیں';
	@override String get historicalInfo => 'تاریخی معلومات';
	@override String get nearbyPlaces => 'قریبی مقامات';
	@override String get pickLocationOnMap => 'نقشے پر مقام منتخب کریں';
	@override String get sitesVisited => 'دورہ کیے گئے مقامات';
	@override String get badgesEarned => 'حاصل کردہ بیجز';
	@override String get completionRate => 'مکمل ہونے کی شرح';
	@override String get addToJourney => 'سفر میں شامل کریں';
	@override String get addedToJourney => 'سفر میں شامل کر دیا گیا';
	@override String get getDirections => 'ہدایات حاصل کریں';
	@override String get viewInMap => 'نقشے میں دیکھیں';
	@override String get directions => 'ہدایات';
	@override String get photoGallery => 'فوٹو گیلری';
	@override String get viewAll => 'سب دیکھیں';
	@override String get photoSavedToGallery => 'فوٹو گیلری میں محفوظ کر دی گئی';
	@override String get sacredSoundscape => 'مقدس صوتی منظر';
	@override String get allDiscussions => 'تمام مباحثے';
	@override String get journeyTab => 'سفر';
	@override String get discussionTab => 'بحث';
	@override String get myActivity => 'میری سرگرمی';
	@override String get anonymousPilgrim => 'گمنام زائر';
	@override String get viewProfile => 'پروفائل دیکھیں';
	@override String get discussionTitleHint => 'مباحثے کا عنوان...';
	@override String get shareYourThoughtsHint => 'اپنے خیالات شیئر کریں...';
	@override String get pleaseEnterDiscussionTitle => 'براہ کرم مباحثے کا عنوان درج کریں';
	@override String get addReflection => 'تجربہ شامل کریں';
	@override String get reflectionTitle => 'عنوان';
	@override String get enterReflectionTitle => 'تجربے کا عنوان درج کریں';
	@override String get pleaseEnterTitle => 'براہ کرم عنوان درج کریں';
	@override String get siteName => 'مقام کا نام';
	@override String get enterSacredSiteName => 'مقدس مقام کا نام درج کریں';
	@override String get pleaseEnterSiteName => 'براہ کرم مقام کا نام درج کریں';
	@override String get reflection => 'تجربہ';
	@override String get reflectionHint => 'اپنے احساسات اور تجربات شیئر کریں...';
	@override String get pleaseEnterReflection => 'براہ کرم اپنا تجربہ درج کریں';
	@override String get saveReflection => 'تجربہ محفوظ کریں';
	@override String get journeyProgress => 'سفر کی پیش رفت';
	@override late final _TranslationsMapDiscussionsUr discussions = _TranslationsMapDiscussionsUr._(_root);
	@override late final _TranslationsMapFabricMapUr fabricMap = _TranslationsMapFabricMapUr._(_root);
	@override late final _TranslationsMapClassicalArtMapUr classicalArtMap = _TranslationsMapClassicalArtMapUr._(_root);
	@override late final _TranslationsMapClassicalDanceMapUr classicalDanceMap = _TranslationsMapClassicalDanceMapUr._(_root);
	@override late final _TranslationsMapFoodMapUr foodMap = _TranslationsMapFoodMapUr._(_root);
}

// Path: community
class _TranslationsCommunityUr extends TranslationsCommunityEn {
	_TranslationsCommunityUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'کمیونٹی';
	@override String get trending => 'ٹرینڈنگ';
	@override String get following => 'فالوونگ';
	@override String get followers => 'فالوورز';
	@override String get posts => 'پوسٹس';
	@override String get follow => 'فالو کریں';
	@override String get unfollow => 'فالو ختم کریں';
	@override String get shareYourStory => 'اپنی کہانی شیئر کریں...';
	@override String get post => 'پوسٹ کریں';
	@override String get like => 'پسند';
	@override String get comment => 'تبصرہ';
	@override String get comments => 'تبصرے';
	@override String get noPostsYet => 'ابھی تک کوئی پوسٹ نہیں';
}

// Path: discover
class _TranslationsDiscoverUr extends TranslationsDiscoverEn {
	_TranslationsDiscoverUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'دریافت کریں';
	@override String get searchHint => 'کہانیاں، صارفین یا موضوعات تلاش کریں...';
	@override String get tryAgain => 'دوبارہ کوشش کریں';
	@override String get somethingWentWrong => 'کچھ غلط ہو گیا';
	@override String get unableToLoadProfiles => 'پروفائلز لوڈ نہیں ہو سکے۔ براہ کرم دوبارہ کوشش کریں۔';
	@override String get noProfilesFound => 'کوئی پروفائل نہیں ملا';
	@override String get searchToFindPeople => 'فالو کرنے کے لیے لوگوں کو تلاش کریں';
	@override String get noResultsFound => 'کوئی نتیجہ نہیں ملا';
	@override String get noProfilesYet => 'ابھی تک کوئی پروفائل نہیں';
	@override String get tryDifferentKeywords => 'براہ کرم مختلف الفاظ سے تلاش کریں';
	@override String get beFirstToDiscover => 'نئے لوگوں کو دریافت کرنے والے پہلے بنیں!';
}

// Path: plan
class _TranslationsPlanUr extends TranslationsPlanEn {
	_TranslationsPlanUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'اپنی پلان محفوظ کرنے کے لیے سائن ان کریں';
	@override String get planSaved => 'پلان محفوظ ہو گئی';
	@override String get from => 'کہاں سے';
	@override String get dates => 'تاریخیں';
	@override String get destination => 'منزل';
	@override String get nearby => 'قریب';
	@override String get generatedPlan => 'تیار کردہ پلان';
	@override String get whereTravellingFrom => 'آپ کہاں سے سفر کر رہے ہیں؟';
	@override String get enterCityOrRegion => 'اپنا شہر یا علاقہ درج کریں';
	@override String get travelDates => 'سفر کی تاریخیں';
	@override String get destinationSacredSite => 'منزل (مقدس جگہ)';
	@override String get searchOrSelectDestination => 'منزل تلاش کریں یا منتخب کریں...';
	@override String get shareYourExperience => 'اپنا تجربہ شیئر کریں';
	@override String get planShared => 'پلان شیئر کر دی گئی';
	@override String failedToSharePlan({required Object error}) => 'پلان شیئر کرنے میں ناکامی: ${error}';
	@override String get planUpdated => 'پلان اپ ڈیٹ کر دی گئی';
	@override String failedToUpdatePlan({required Object error}) => 'پلان اپ ڈیٹ کرنے میں ناکامی: ${error}';
	@override String get deletePlanConfirm => 'پلان کو حذف کریں؟';
	@override String get thisPlanPermanentlyDeleted => 'یہ پلان مستقل طور پر حذف ہو جائے گی۔';
	@override String get planDeleted => 'پلان حذف کر دی گئی';
	@override String failedToDeletePlan({required Object error}) => 'پلان حذف کرنے میں ناکامی: ${error}';
	@override String get sharePlan => 'پلان شیئر کریں';
	@override String get deletePlan => 'پلان حذف کریں';
	@override String get savedPlanDetails => 'محفوظ شدہ پلان کی تفصیلات';
	@override String get pilgrimagePlan => 'زیارت کا منصوبہ';
	@override String get planTab => 'منصوبہ';
}

// Path: settings
class _TranslationsSettingsUr extends TranslationsSettingsEn {
	_TranslationsSettingsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'سیٹنگز';
	@override String get language => 'زبان';
	@override String get theme => 'تھیم';
	@override String get themeLight => 'لائٹ';
	@override String get themeDark => 'ڈارک';
	@override String get themeSystem => 'سسٹم تھیم استعمال کریں';
	@override String get darkMode => 'ڈارک موڈ';
	@override String get selectLanguage => 'زبان منتخب کریں';
	@override String get notifications => 'نوٹیفیکیشنز';
	@override String get cacheSettings => 'کیچ اور اسٹوریج';
	@override String get general => 'عام';
	@override String get account => 'اکاؤنٹ';
	@override String get blockedUsers => 'بلاک شدہ صارفین';
	@override String get helpSupport => 'مدد اور معاونت';
	@override String get contactUs => 'ہم سے رابطہ کریں';
	@override String get legal => 'قانونی';
	@override String get privacyPolicy => 'پرائیویسی پالیسی';
	@override String get termsConditions => 'شرائط و ضوابط';
	@override String get privacy => 'پرائیویسی';
	@override String get about => 'ایپ کے بارے میں';
	@override String get version => 'ورژن';
	@override String get logout => 'لاگ آؤٹ';
	@override String get deleteAccount => 'اکاؤنٹ حذف کریں';
	@override String get deleteAccountTitle => 'اکاؤنٹ حذف کریں';
	@override String get deleteAccountWarning => 'یہ عمل واپس نہیں لیا جا سکتا!';
	@override String get deleteAccountDescription => 'اپنا اکاؤنٹ حذف کرنے سے آپ کی تمام پوسٹس، تبصرے، پروفائل، فالوورز، محفوظ کہانیاں، بُک مارکس، چیٹ پیغامات، اور تیار کی گئی کہانیاں مستقل طور پر حذف ہو جائیں گی۔';
	@override String get confirmPassword => 'اپنا پاس ورڈ تصدیق کریں';
	@override String get confirmPasswordDesc => 'اکاؤنٹ حذف کرنے کی تصدیق کے لیے اپنا پاس ورڈ درج کریں۔';
	@override String get googleReauth => 'اپنی شناخت کی تصدیق کے لیے آپ کو Google پر بھیجا جائے گا۔';
	@override String get finalConfirmationTitle => 'آخری تصدیق';
	@override String get finalConfirmation => 'کیا آپ واقعی یقین رکھتے ہیں؟ یہ مستقل ہے اور واپس نہیں ہو سکتا۔';
	@override String get deleteMyAccount => 'میرا اکاؤنٹ حذف کریں';
	@override String get deletingAccount => 'اکاؤنٹ حذف کیا جا رہا ہے...';
	@override String get accountDeleted => 'آپ کا اکاؤنٹ مستقل طور پر حذف کر دیا گیا ہے۔';
	@override String get deleteAccountFailed => 'اکاؤنٹ حذف کرنے میں ناکامی۔ براہ کرم دوبارہ کوشش کریں۔';
	@override String get downloadedStories => 'ڈاؤن لوڈ کی گئی کہانیاں';
	@override String get couldNotOpenEmail => 'ای میل ایپ کھولنے میں ناکامی۔ براہ کرم ہمیں `myitihas@gmail.com` پر ای میل کریں۔';
	@override String couldNotOpenLabel({required Object label}) => '${label} کو اس وقت نہیں کھولا جا سکا۔';
	@override String get logoutTitle => 'لاگ آؤٹ';
	@override String get logoutConfirm => 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';
	@override String get verifyYourIdentity => 'اپنی شناخت کی تصدیق کریں';
	@override String get verifyYourIdentityDesc => 'آپ کی شناخت کی تصدیق کے لیے آپ کو Google کے ساتھ سائن ان کرنے کو کہا جائے گا۔';
	@override String get continueWithGoogle => 'Google کے ساتھ جاری رکھیں';
	@override String reauthFailed({required Object error}) => 'دوبارہ تصدیق میں ناکامی: ${error}';
	@override String get passwordRequired => 'پاس ورڈ درکار ہے';
	@override String get invalidPassword => 'غلط پاس ورڈ۔ براہ کرم دوبارہ کوشش کریں۔';
	@override String get verify => 'تصدیق کریں';
	@override String get continueLabel => 'جاری رکھیں';
	@override String get unableToVerifyIdentity => 'شناخت کی تصدیق نہیں ہو سکی۔ براہ کرم دوبارہ کوشش کریں۔';
}

// Path: auth
class _TranslationsAuthUr extends TranslationsAuthEn {
	_TranslationsAuthUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get login => 'لاگ ان';
	@override String get signup => 'سائن اپ';
	@override String get email => 'ای میل';
	@override String get password => 'پاس ورڈ';
	@override String get confirmPassword => 'پاس ورڈ کی تصدیق کریں';
	@override String get forgotPassword => 'پاس ورڈ بھول گئے؟';
	@override String get resetPassword => 'پاس ورڈ ری سیٹ کریں';
	@override String get dontHaveAccount => 'کیا آپ کا اکاؤنٹ نہیں ہے؟';
	@override String get alreadyHaveAccount => 'کیا آپ کا پہلے سے اکاؤنٹ موجود ہے؟';
	@override String get loginSuccess => 'لاگ ان کامیاب';
	@override String get signupSuccess => 'سائن اپ کامیاب';
	@override String get loginError => 'لاگ ان ناکام';
	@override String get signupError => 'سائن اپ ناکام';
}

// Path: error
class _TranslationsErrorUr extends TranslationsErrorEn {
	_TranslationsErrorUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get network => 'انٹرنیٹ کنکشن نہیں ہے';
	@override String get server => 'سرور پر خرابی پیش آ گئی';
	@override String get cache => 'کیچ ڈیٹا لوڈ کرنے میں ناکامی';
	@override String get timeout => 'درخواست کا وقت ختم ہو گیا';
	@override String get notFound => 'وسیلہ نہیں ملا';
	@override String get validation => 'تصدیق ناکام';
	@override String get unexpected => 'غیر متوقع خرابی پیش آ گئی';
	@override String get tryAgain => 'براہ کرم دوبارہ کوشش کریں';
	@override String couldNotOpenLink({required Object url}) => 'لنک نہیں کھولا جا سکا: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionUr extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get free => 'مفت';
	@override String get plus => 'پلس';
	@override String get pro => 'پرو';
	@override String get upgradeToPro => 'پرو میں اپ گریڈ کریں';
	@override String get features => 'خصوصیات';
	@override String get subscribe => 'سبسکرائب کریں';
	@override String get currentPlan => 'موجودہ پلان';
	@override String get managePlan => 'پلان کو منظم کریں';
}

// Path: notification
class _TranslationsNotificationUr extends TranslationsNotificationEn {
	_TranslationsNotificationUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'نوٹیفیکیشنز';
	@override String get peopleToConnect => 'لوگوں سے جڑیں';
	@override String get peopleToConnectSubtitle => 'فالو کرنے کے لیے لوگوں کو دریافت کریں';
	@override String followAgainInMinutes({required Object minutes}) => 'آپ ${minutes} منٹ بعد دوبارہ فالو کر سکتے ہیں';
	@override String get noSuggestions => 'اس وقت کوئی تجاویز نہیں';
	@override String get markAllRead => 'سب کو بطور پڑھی گئی نشان زد کریں';
	@override String get noNotifications => 'ابھی تک کوئی نوٹیفیکیشن نہیں';
	@override String get noNotificationsSubtitle => 'جب کوئی آپ کی کہانیوں کے ساتھ تعامل کرے گا، آپ کو یہاں نظر آئے گا';
	@override String get errorPrefix => 'خرابی:';
	@override String get retry => 'دوبارہ کوشش کریں';
	@override String likedYourStory({required Object actorName}) => '${actorName} نے آپ کی کہانی کو پسند کیا';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} نے آپ کی کہانی پر تبصرہ کیا';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} نے آپ کے تبصرے کا جواب دیا';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} نے آپ کو فالو کرنا شروع کیا';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} نے آپ کو پیغام بھیجا';
	@override String sharedYourStory({required Object actorName}) => '${actorName} نے آپ کی کہانی شیئر کی';
	@override String repostedYourStory({required Object actorName}) => '${actorName} نے آپ کی کہانی دوبارہ پوسٹ کی';
	@override String mentionedYou({required Object actorName}) => '${actorName} نے آپ کا ذکر کیا';
	@override String newPostFrom({required Object actorName}) => '${actorName} کی نئی پوسٹ';
	@override String get today => 'آج';
	@override String get thisWeek => 'اس ہفتے';
	@override String get earlier => 'اس سے پہلے';
	@override String get delete => 'حذف کریں';
}

// Path: profile
class _TranslationsProfileUr extends TranslationsProfileEn {
	_TranslationsProfileUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get followers => 'فالوورز';
	@override String get following => 'فالوونگ';
	@override String get unfollow => 'فالو ختم کریں';
	@override String get follow => 'فالو کریں';
	@override String get about => 'متعلق';
	@override String get stories => 'کہانیاں';
	@override String get unableToShareImage => 'تصویر شیئر نہیں کی جا سکی';
	@override String get imageSavedToPhotos => 'تصویر فوٹوز میں محفوظ ہو گئی';
	@override String get view => 'دیکھیں';
	@override String get saveToPhotos => 'فوٹوز میں محفوظ کریں';
	@override String get failedToLoadImage => 'تصویر لوڈ کرنے میں ناکامی';
}

// Path: feed
class _TranslationsFeedUr extends TranslationsFeedEn {
	_TranslationsFeedUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'کہانیاں لوڈ ہو رہی ہیں...';
	@override String get loadingPosts => 'پوسٹس لوڈ ہو رہی ہیں...';
	@override String get loadingVideos => 'ویڈیوز لوڈ ہو رہی ہیں...';
	@override String get loadingStories => 'کہانیاں لوڈ ہو رہی ہیں...';
	@override String get errorTitle => 'اوہ! کچھ غلط ہو گیا';
	@override String get tryAgain => 'دوبارہ کوشش کریں';
	@override String get noStoriesAvailable => 'کوئی کہانیاں دستیاب نہیں';
	@override String get noImagesAvailable => 'کوئی تصویری پوسٹس دستیاب نہیں';
	@override String get noTextPostsAvailable => 'کوئی تحریری پوسٹس دستیاب نہیں';
	@override String get noContentAvailable => 'کوئی مواد دستیاب نہیں';
	@override String get refresh => 'ریفریش کریں';
	@override String get comments => 'تبصرے';
	@override String get commentsComingSoon => 'تبصروں کا فیچر جلد آرہا ہے';
	@override String get addCommentHint => 'تبصرہ لکھیں...';
	@override String get shareStory => 'کہانی شیئر کریں';
	@override String get sharePost => 'پوسٹ شیئر کریں';
	@override String get shareThought => 'خیال شیئر کریں';
	@override String get shareAsImage => 'بطور تصویر شیئر کریں';
	@override String get shareAsImageSubtitle => 'خوبصورت پری ویو کارڈ بنائیں';
	@override String get shareLink => 'لنک شیئر کریں';
	@override String get shareLinkSubtitle => 'کہانی کا لنک کاپی یا شیئر کریں';
	@override String get shareImageLinkSubtitle => 'پوسٹ کا لنک کاپی یا شیئر کریں';
	@override String get shareTextLinkSubtitle => 'خیال کا لنک کاپی یا شیئر کریں';
	@override String get shareAsText => 'بطور متن شیئر کریں';
	@override String get shareAsTextSubtitle => 'کہانی کا ایک حصہ شیئر کریں';
	@override String get shareQuote => 'اقتباس شیئر کریں';
	@override String get shareQuoteSubtitle => 'اقتباس کی صورت میں شیئر کریں';
	@override String get shareWithImage => 'تصویر کے ساتھ شیئر کریں';
	@override String get shareWithImageSubtitle => 'تصویر کو کیپشن کے ساتھ شیئر کریں';
	@override String get copyLink => 'لنک کاپی کریں';
	@override String get copyLinkSubtitle => 'لنک کو کلپ بورڈ پر کاپی کریں';
	@override String get copyText => 'متن کاپی کریں';
	@override String get copyTextSubtitle => 'اقتباس کو کلپ بورڈ پر کاپی کریں';
	@override String get linkCopied => 'لنک کلپ بورڈ پر کاپی ہو گیا';
	@override String get textCopied => 'متن کلپ بورڈ پر کاپی ہو گیا';
	@override String get sendToUser => 'صارف کو بھیجیں';
	@override String get sendToUserSubtitle => 'کسی دوست کے ساتھ براہِ راست شیئر کریں';
	@override String get chooseFormat => 'فارمیٹ منتخب کریں';
	@override String get linkPreview => 'لنک پری ویو';
	@override String get linkPreviewSize => '۱۲۰۰ × ۶۳۰';
	@override String get storyFormat => 'اسٹوری فارمیٹ';
	@override String get storyFormatSize => '۱۰۸۰ × ۱۹۲۰ (Instagram/Stories)';
	@override String get generatingPreview => 'پری ویو تیار کیا جا رہا ہے...';
	@override String get bookmarked => 'بُک مارک کیا گیا';
	@override String get removedFromBookmarks => 'بُک مارکس سے ہٹا دیا گیا';
	@override String unlike({required Object count}) => 'ان لائک، ${count} لائکس';
	@override String like({required Object count}) => 'لائک، ${count} لائکس';
	@override String commentCount({required Object count}) => '${count} تبصرے';
	@override String shareCount({required Object count}) => 'شیئر، ${count} مرتبہ شیئر کیا گیا';
	@override String get removeBookmark => 'بُک مارک ہٹائیں';
	@override String get addBookmark => 'بُک مارک کریں';
	@override String get quote => 'اقتباس';
	@override String get quoteCopied => 'اقتباس کلپ بورڈ پر کاپی ہو گیا';
	@override String get copy => 'کاپی کریں';
	@override String get tapToViewFullQuote => 'مکمل اقتباس دیکھنے کے لیے ٹیپ کریں';
	@override String get quoteFromMyitihas => 'MyItihas سے اقتباس';
	@override late final _TranslationsFeedTabsUr tabs = _TranslationsFeedTabsUr._(_root);
	@override String get tapToShowCaption => 'کیپشن دیکھنے کے لیے ٹیپ کریں';
	@override String get noVideosAvailable => 'کوئی ویڈیو دستیاب نہیں';
	@override String get selectUser => 'کسے بھیجیں';
	@override String get searchUsers => 'صارفین تلاش کریں...';
	@override String get noFollowingYet => 'آپ فی الحال کسی کو فالو نہیں کر رہے';
	@override String get noUsersFound => 'کوئی صارف نہیں ملا';
	@override String get tryDifferentSearch => 'براہ کرم مختلف تلاش آزما کر دیکھیں';
	@override String sentTo({required Object username}) => '${username} کو بھیج دیا گیا';
}

// Path: voice
class _TranslationsVoiceUr extends TranslationsVoiceEn {
	_TranslationsVoiceUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'مائیکروفون کی اجازت درکار ہے';
	@override String get speechRecognitionNotAvailable => 'اسپیچ ریکگنیشن دستیاب نہیں';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsUr extends TranslationsFestivalsEn {
	_TranslationsFestivalsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تہوار کی کہانیاں';
	@override String get tellStory => 'کہانی سنائیں';
}

// Path: social
class _TranslationsSocialUr extends TranslationsSocialEn {
	_TranslationsSocialUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileUr editProfile = _TranslationsSocialEditProfileUr._(_root);
	@override late final _TranslationsSocialCreatePostUr createPost = _TranslationsSocialCreatePostUr._(_root);
	@override late final _TranslationsSocialCommentsUr comments = _TranslationsSocialCommentsUr._(_root);
	@override late final _TranslationsSocialEngagementUr engagement = _TranslationsSocialEngagementUr._(_root);
	@override String get editCaption => 'کیپشن میں ترمیم کریں';
	@override String get reportPost => 'پوسٹ کی رپورٹ کریں';
	@override String get reportReasonHint => 'ہمیں بتائیں کہ اس پوسٹ میں کیا غلط ہے';
	@override String get deletePost => 'پوسٹ حذف کریں';
	@override String get deletePostConfirm => 'یہ عمل واپس نہیں لیا جا سکتا۔';
	@override String get postDeleted => 'پوسٹ حذف کر دی گئی';
	@override String failedToDeletePost({required Object error}) => 'پوسٹ حذف کرنے میں ناکامی: ${error}';
	@override String failedToReportPost({required Object error}) => 'پوسٹ کی رپورٹ کرنے میں ناکامی: ${error}';
	@override String get reportSubmitted => 'رپورٹ جمع ہو گئی۔ شکریہ۔';
	@override String get acceptRequestFirst => 'پہلے "Requests" میں ان کی درخواست قبول کریں۔';
	@override String get requestSentWait => 'درخواست بھیج دی گئی۔ براہ کرم قبولیت کا انتظار کریں۔';
	@override String get requestSentTheyWillSee => 'درخواست بھیج دی گئی۔ وہ اسے "Requests" میں دیکھیں گے۔';
	@override String failedToShare({required Object error}) => 'شیئر کرنے میں ناکامی: ${error}';
	@override String get updateCaptionHint => 'اپنی پوسٹ کے کیپشن کو اپ ڈیٹ کریں';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroUr extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'دریافت کرنے کے لیے ٹیپ کریں';
	@override late final _TranslationsHomeScreenHeroStoryUr story = _TranslationsHomeScreenHeroStoryUr._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionUr companion = _TranslationsHomeScreenHeroCompanionUr._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageUr heritage = _TranslationsHomeScreenHeroHeritageUr._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityUr community = _TranslationsHomeScreenHeroCommunityUr._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesUr messages = _TranslationsHomeScreenHeroMessagesUr._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthUr extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get short => 'چھوٹی';
	@override String get medium => 'درمیانی';
	@override String get long => 'لمبی';
	@override String get epic => 'طویل';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatUr extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'بیانیہ';
	@override String get dialogue => 'مکالمہ پر مبنی';
	@override String get poetic => 'شاعرانہ';
	@override String get scriptural => 'صحیفائی';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsUr extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'کرشن کے ارجن کو تعلیم دینے کی کہانی سنائیں...';
	@override String get warriorRedemption => 'ایک ایسے جنگجو کی شان دار کہانی لکھیں جو توبہ کی راہ پر ہے...';
	@override String get sageWisdom => 'حکیموں اور رشیوں کی حکمت پر مبنی کہانی بنائیں...';
	@override String get devotedSeeker => 'ایک مخلص طالبِ حق کے روحانی سفر کا بیان کریں...';
	@override String get divineIntervention => 'الٰہی مداخلت پر مبنی ایک لوک کہانی شیئر کریں...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsUr extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'براہ کرم تمام ضروری اختیارات مکمل کریں';
	@override String get generationFailed => 'کہانی بنانے میں ناکامی۔ براہ کرم دوبارہ کوشش کریں۔';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsUr extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  السلام!';
	@override String get dharma => '📖  دھرم کیا ہے؟';
	@override String get stress => '🧘  دباؤ کو کیسے سنبھالیں';
	@override String get karma => '⚡  کرم کو آسان انداز میں سمجھائیں';
	@override String get story => '💬  مجھے ایک کہانی سنائیں';
	@override String get wisdom => '🌟  آج کی دانائی';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsUr extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

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
class _TranslationsMapDiscussionsUr extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'بحث پوسٹ کریں';
	@override String get intentCardCta => 'ایک بحث پوسٹ کریں';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapUr extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapUr extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapUr extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

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
class _TranslationsMapFoodMapUr extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

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
class _TranslationsFeedTabsUr extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get all => 'سب';
	@override String get stories => 'کہانیاں';
	@override String get posts => 'پوسٹس';
	@override String get videos => 'ویڈیوز';
	@override String get images => 'تصاویر';
	@override String get text => 'خیالات';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileUr extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'پروفائل میں ترمیم کریں';
	@override String get displayName => 'ڈسپلے نام';
	@override String get displayNameHint => 'اپنا ڈسپلے نام درج کریں';
	@override String get displayNameEmpty => 'ڈسپلے نام خالی نہیں ہو سکتا';
	@override String get bio => 'بائیو';
	@override String get bioHint => 'اپنے بارے میں بتائیں...';
	@override String get changePhoto => 'پروفائل تصویر تبدیل کریں';
	@override String get saveChanges => 'تبدیلیاں محفوظ کریں';
	@override String get profileUpdated => 'پروفائل کامیابی سے اپ ڈیٹ ہو گیا';
	@override String get profileAndPhotoUpdated => 'پروفائل اور تصویر کامیابی سے اپ ڈیٹ ہو گئیں';
	@override String failedPickImage({required Object error}) => 'تصویر منتخب کرنے میں ناکامی: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'تصویر اپ لوڈ کرنے میں ناکامی: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'پروفائل اپ ڈیٹ کرنے میں ناکامی: ${error}';
	@override String unexpectedError({required Object error}) => 'غیر متوقع خرابی: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostUr extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'پوسٹ بنائیں';
	@override String get post => 'پوسٹ کریں';
	@override String get text => 'متن';
	@override String get image => 'تصویر';
	@override String get video => 'ویڈیو';
	@override String get textHint => 'آپ کے ذہن میں کیا ہے؟';
	@override String get imageCaptionHint => 'اپنی تصویر کے لیے کیپشن لکھیں...';
	@override String get videoCaptionHint => 'اپنی ویڈیو کی وضاحت کریں...';
	@override String get shareCaptionHint => 'اپنے خیالات شامل کریں...';
	@override String get titleHint => 'ایک عنوان شامل کریں (اختیاری)';
	@override String get selectVideo => 'ویڈیو منتخب کریں';
	@override String get gallery => 'گیلری';
	@override String get camera => 'کیمرہ';
	@override String get visibility => 'کون دیکھ سکتا ہے؟';
	@override String get public => 'عوامی';
	@override String get followers => 'فالوورز';
	@override String get private => 'نجی';
	@override String get postCreated => 'پوسٹ بن گئی!';
	@override String get failedPickImages => 'تصاویر منتخب کرنے میں ناکامی';
	@override String get failedPickVideo => 'ویڈیو منتخب کرنے میں ناکامی';
	@override String get failedCapturePhoto => 'تصویر لینے میں ناکامی';
	@override String get cannotCreateOffline => 'آف لائن حالت میں پوسٹ نہیں بنائی جا سکتی';
	@override String get discardTitle => 'پوسٹ ختم کریں؟';
	@override String get discardMessage => 'آپ کی بعض تبدیلیاں محفوظ نہیں ہوئیں۔ کیا آپ واقعی یہ پوسٹ ختم کرنا چاہتے ہیں؟';
	@override String get keepEditing => 'ترمیم جاری رکھیں';
	@override String get discard => 'ختم کریں';
	@override String get cropPhoto => 'تصویر کاٹیں';
	@override String get trimVideo => 'ویڈیو کاٹیں';
	@override String get editPhoto => 'تصویر میں ترمیم کریں';
	@override String get editVideo => 'ویڈیو میں ترمیم کریں';
	@override String get maxDuration => 'زیادہ سے زیادہ ۳۰ سیکنڈ';
	@override String get aspectSquare => 'مربع';
	@override String get aspectPortrait => 'عمودی';
	@override String get aspectLandscape => 'افقی';
	@override String get aspectFree => 'آزاد';
	@override String get failedCrop => 'تصویر کاٹنے میں ناکامی';
	@override String get failedTrim => 'ویڈیو کاٹنے میں ناکامی';
	@override String get trimmingVideo => 'ویڈیو کاٹی جا رہی ہے...';
	@override String trimVideoSubtitle({required Object max}) => 'زیادہ سے زیادہ ${max}سیک · اپنا بہترین حصہ منتخب کریں';
	@override String get trimVideoInstructionsTitle => 'اپنی کلپ ٹرم کریں';
	@override String get trimVideoInstructionsBody => 'شروع اور اختتام کے ہینڈلز کھینچ کر 30 سیکنڈ تک کا حصہ منتخب کریں۔';
	@override String get trimStart => 'شروع';
	@override String get trimEnd => 'اختتام';
	@override String get trimSelectionEmpty => 'جاری رکھنے کے لیے درست رینج منتخب کریں';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}سیک منتخب (${start}–${end}) · زیادہ سے زیادہ ${max}سیک';
	@override String get coverFrame => 'کور فریم';
	@override String get coverFrameUnavailable => 'کوئی پیش منظر نہیں';
	@override String coverFramePosition({required Object time}) => '${time} پر کور';
	@override String get overlayLabel => 'ویڈیو پر متن (اختیاری)';
	@override String get overlayHint => 'چھوٹا ہک یا عنوان شامل کریں';
	@override String get imageSectionHint => 'گیلری یا کیمرے سے زیادہ سے زیادہ ۱۰ تصاویر شامل کریں';
	@override String get videoSectionHint => 'ایک ویڈیو، زیادہ سے زیادہ ۳۰ سیکنڈ';
	@override String get removePhoto => 'تصویر ہٹائیں';
	@override String get removeVideo => 'ویڈیو ہٹائیں';
	@override String get photoEditHint => 'تصویر کاٹنے یا ہٹانے کے لیے ٹیپ کریں';
	@override String get videoEditOptions => 'ترمیم کے اختیارات';
	@override String get addPhoto => 'تصویر شامل کریں';
	@override String get done => 'ہو گیا';
	@override String get rotate => 'گھمائیں';
	@override String get editPhotoSubtitle => 'فیڈ میں بہترین نظر آنے کے لیے مربع میں کاٹیں';
	@override String get videoEditorCaptionLabel => 'کیپشن / متن (اختیاری)';
	@override String get videoEditorCaptionHint => 'مثلاً: آپ کی ریل کے لیے عنوان یا ہک';
	@override String get videoEditorAspectLabel => 'تناسب';
	@override String get videoEditorAspectOriginal => 'اصل';
	@override String get videoEditorAspectSquare => '1:1';
	@override String get videoEditorAspectPortrait => '9:16';
	@override String get videoEditorAspectLandscape => '16:9';
	@override String get videoEditorQuickTrim => 'فوری ٹرم';
	@override String get videoEditorSpeed => 'رفتار';
}

// Path: social.comments
class _TranslationsSocialCommentsUr extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} کو جواب دیا جا رہا ہے';
	@override String replyHint({required Object name}) => '${name} کو جواب لکھیں...';
	@override String failedToPost({required Object error}) => 'تبصرہ پوسٹ کرنے میں ناکامی: ${error}';
	@override String get cannotPostOffline => 'آف لائن حالت میں تبصرہ پوسٹ نہیں کیا جا سکتا';
	@override String get noComments => 'ابھی تک کوئی تبصرے نہیں';
	@override String get beFirst => 'پہلا تبصرہ آپ کریں!';
}

// Path: social.engagement
class _TranslationsSocialEngagementUr extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'آف لائن موڈ';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryUr extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'اے آئی کہانی تخلیق';
	@override String get headline => 'دلکش\nکہانیاں\nبنائیں';
	@override String get subHeadline => 'قدیم دانائی کی طاقت سے';
	@override String get line1 => '✦  ایک مقدس صحیفہ منتخب کریں...';
	@override String get line2 => '✦  ایک جاندار منظر منتخب کریں...';
	@override String get line3 => '✦  اے آئی کو دل موہ لینے والی کہانی بُننے دیں...';
	@override String get cta => 'کہانی بنائیں';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionUr extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'روحانی ساتھی';
	@override String get headline => 'آپ کا الٰہی\nرہنما،\nہمیشہ قریب';
	@override String get subHeadline => 'کرشن کی دانائی سے متاثر';
	@override String get line1 => '✦  ایک دوست جو واقعی سنتا ہے...';
	@override String get line2 => '✦  زندگی کی کشمکش کے لیے حکمت...';
	@override String get line3 => '✦  ایسی باتیں جو آپ کو اٹھائیں...';
	@override String get cta => 'چیٹ شروع کریں';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageUr extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ورثہ نقشہ';
	@override String get headline => 'لازوال\nورثہ\nدریافت کریں';
	@override String get subHeadline => '5000+ مقدس مقامات نقشے میں';
	@override String get line1 => '✦  مقدس مقامات دریافت کریں...';
	@override String get line2 => '✦  تاریخ اور داستانیں پڑھیں...';
	@override String get line3 => '✦  بامعنی سفر کی منصوبہ بندی کریں...';
	@override String get cta => 'نقشہ دیکھیں';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityUr extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'کمیونٹی اسپیس';
	@override String get headline => 'ثقافت کو\nدنیا کے ساتھ\nشیئر کریں';
	@override String get subHeadline => 'ایک متحرک عالمی کمیونٹی';
	@override String get line1 => '✦  پوسٹس اور گہری گفتگو...';
	@override String get line2 => '✦  مختصر ثقافتی ویڈیوز...';
	@override String get line3 => '✦  دنیا بھر کی کہانیاں...';
	@override String get cta => 'کمیونٹی میں شامل ہوں';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesUr extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesUr._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'نجی پیغامات';
	@override String get headline => 'بامعنی\nگفتگو\nیہیں سے شروع';
	@override String get subHeadline => 'نجی اور بامقصد جگہیں';
	@override String get line1 => '✦  ہم خیال لوگوں سے جڑیں...';
	@override String get line2 => '✦  خیالات اور کہانیوں پر بات کریں...';
	@override String get line3 => '✦  فکری کمیونٹیز بنائیں...';
	@override String get cta => 'پیغامات کھولیں';
}
