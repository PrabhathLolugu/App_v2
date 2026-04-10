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
class TranslationsOr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsOr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.or,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <or>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsOr _root = this; // ignore: unused_field

	@override 
	TranslationsOr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsOr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppOr app = _TranslationsAppOr._(_root);
	@override late final _TranslationsCommonOr common = _TranslationsCommonOr._(_root);
	@override late final _TranslationsNavigationOr navigation = _TranslationsNavigationOr._(_root);
	@override late final _TranslationsHomeOr home = _TranslationsHomeOr._(_root);
	@override late final _TranslationsHomeScreenOr homeScreen = _TranslationsHomeScreenOr._(_root);
	@override late final _TranslationsStoriesOr stories = _TranslationsStoriesOr._(_root);
	@override late final _TranslationsStoryGeneratorOr storyGenerator = _TranslationsStoryGeneratorOr._(_root);
	@override late final _TranslationsChatOr chat = _TranslationsChatOr._(_root);
	@override late final _TranslationsMapOr map = _TranslationsMapOr._(_root);
	@override late final _TranslationsCommunityOr community = _TranslationsCommunityOr._(_root);
	@override late final _TranslationsDiscoverOr discover = _TranslationsDiscoverOr._(_root);
	@override late final _TranslationsPlanOr plan = _TranslationsPlanOr._(_root);
	@override late final _TranslationsSettingsOr settings = _TranslationsSettingsOr._(_root);
	@override late final _TranslationsAuthOr auth = _TranslationsAuthOr._(_root);
	@override late final _TranslationsErrorOr error = _TranslationsErrorOr._(_root);
	@override late final _TranslationsSubscriptionOr subscription = _TranslationsSubscriptionOr._(_root);
	@override late final _TranslationsNotificationOr notification = _TranslationsNotificationOr._(_root);
	@override late final _TranslationsProfileOr profile = _TranslationsProfileOr._(_root);
	@override late final _TranslationsFeedOr feed = _TranslationsFeedOr._(_root);
	@override late final _TranslationsVoiceOr voice = _TranslationsVoiceOr._(_root);
	@override late final _TranslationsFestivalsOr festivals = _TranslationsFestivalsOr._(_root);
	@override late final _TranslationsSocialOr social = _TranslationsSocialOr._(_root);
}

// Path: app
class _TranslationsAppOr extends TranslationsAppEn {
	_TranslationsAppOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'ଭାରତୀୟ ଶାସ୍ତ୍ରଗୁଡ଼ିକୁ ଅନୁସନ୍ଧାନ କରନ୍ତୁ';
}

// Path: common
class _TranslationsCommonOr extends TranslationsCommonEn {
	_TranslationsCommonOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ଠିକ ଅଛି';
	@override String get cancel => 'ବାତିଲ୍';
	@override String get confirm => 'ନିଶ୍ଚିତ କରନ୍ତୁ';
	@override String get delete => 'ମିଛାନ୍ତୁ';
	@override String get edit => 'ସମ୍ପାଦନା କରନ୍ତୁ';
	@override String get save => 'ସେଭ୍ କରନ୍ତୁ';
	@override String get share => 'ସେୟାର୍ କରନ୍ତୁ';
	@override String get search => 'ଖୋଜନ୍ତୁ';
	@override String get loading => 'ଲୋଡ୍ ହେଉଛି...';
	@override String get error => 'ତ୍ରୁଟି';
	@override String get retry => 'ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ';
	@override String get back => 'ପଛକୁ';
	@override String get next => 'ପରବର୍ତ୍ତୀ';
	@override String get finish => 'ସମାପ୍ତ';
	@override String get skip => 'ଏଡିଯାଆନ୍ତୁ';
	@override String get yes => 'ହଁ';
	@override String get no => 'ନା';
	@override String get readFullStory => 'ପୂର୍ଣ୍ଣ କଥା ପଢ଼ନ୍ତୁ';
	@override String get dismiss => 'ବନ୍ଦ କରନ୍ତୁ';
	@override String get offlineBannerMessage => 'ଆପଣ ଅଫ୍ଲାଇନ୍ ଅଛନ୍ତି – ସଞ୍ଚିତ ବିଷୟବସ୍ତୁ ଦେଖୁଛନ୍ତି';
	@override String get backOnline => 'ପୁନର୍ବାର ଅନଲାଇନ୍';
}

// Path: navigation
class _TranslationsNavigationOr extends TranslationsNavigationEn {
	_TranslationsNavigationOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get home => 'ଅନ୍ୱେଷଣ';
	@override String get stories => 'କଥା';
	@override String get chat => 'ଚାଟ୍';
	@override String get map => 'ମାନଚିତ୍ର';
	@override String get community => 'ସାମାଜିକ';
	@override String get settings => 'ସେଟିଂସ୍';
	@override String get profile => 'ପ୍ରୋଫାଇଲ୍';
}

// Path: home
class _TranslationsHomeOr extends TranslationsHomeEn {
	_TranslationsHomeOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'କଥା ଜେନେରେଟର୍';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'ସମୁଦାୟ କଥା';
	@override String get maps => 'ମାନଚିତ୍ରଗୁଡ଼ିକ';
	@override String get greetingMorning => 'ଶୁଭ ସକାଳ';
	@override String get continueReading => 'ପଢ଼ିବା ଜାରି ରଖନ୍ତୁ';
	@override String get greetingAfternoon => 'ଶୁଭ ଦୁପର';
	@override String get greetingEvening => 'ଶୁଭ ସନ୍ଧ୍ୟା';
	@override String get greetingNight => 'ଶୁଭ ରାତ୍ରି';
	@override String get exploreStories => 'କଥାଗୁଡ଼ିକୁ ଅନୁସନ୍ଧାନ କରନ୍ତୁ';
	@override String get generateStory => 'କଥା ସୃଷ୍ଟି କରନ୍ତୁ';
	@override String get content => 'ହୋମ୍ ବିଷୟବସ୍ତୁ';
}

// Path: homeScreen
class _TranslationsHomeScreenOr extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'ନମସ୍କାର';
	@override String get quoteOfTheDay => 'ଆଜିର ଉକ୍ତି';
	@override String get shareQuote => 'ଉକ୍ତି ସେୟାର୍ କରନ୍ତୁ';
	@override String get copyQuote => 'ଉକ୍ତି କପି କରନ୍ତୁ';
	@override String get quoteCopied => 'ଉକ୍ତି କ୍ଲିପ୍‌ବୋର୍ଡକୁ କପି ହୋଇଗଲା';
	@override String get featuredStories => 'ବିଶେଷ କଥା';
	@override String get quickActions => 'ଦ୍ରୁତ କାର୍ଯ୍ୟଗୁଡ଼ିକ';
	@override String get generateStory => 'କଥା ସୃଷ୍ଟି କରନ୍ତୁ';
	@override String get chatWithKrishna => 'କୃଷ୍ଣଙ୍କ ସହ ଆଲୋଚନା କରନ୍ତୁ';
	@override String get myActivity => 'ମୋର କାର୍ଯ୍ୟକଳାପ';
	@override String get continueReading => 'ପଢ଼ିବା ଜାରି ରଖନ୍ତୁ';
	@override String get savedStories => 'ସଞ୍ଚିତ କଥାଗୁଡ଼ିକ';
	@override String get exploreMyitihas => 'ମାଇଇତିହାସ ଅନ୍ୱେଷଣ କରନ୍ତୁ';
	@override String get storiesInYourLanguage => 'ଆପଣଙ୍କ ଭାଷାରେ କଥାଗୁଡ଼ିକ';
	@override String get seeAll => 'ସବୁ ଦେଖନ୍ତୁ';
	@override String get startReading => 'ପଢ଼ିବା ଆରମ୍ଭ କରନ୍ତୁ';
	@override String get exploreStories => 'ଆପଣଙ୍କ ଯାତ୍ରା ଆରମ୍ଭ କରିବାକୁ କଥାଗୁଡ଼ିକ ଖୋଜନ୍ତୁ';
	@override String get saveForLater => 'ଯେ କଥା ଭଲ ଲାଗେ, ସେଗୁଡ଼ିକୁ ବୁକମାର୍କ କରନ୍ତୁ';
	@override String get noActivityYet => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି କାର୍ଯ୍ୟକଳାପ ନାହିଁ';
	@override String minLeft({required Object count}) => '${count} ମିନିଟ୍ ଅବଶିଷ୍ଟ';
	@override String get activityHistory => 'କାର୍ଯ୍ୟକଳାପ ଇତିହାସ';
	@override String get storyGenerated => 'ଗୋଟିଏ କଥା ସୃଷ୍ଟି ହୋଇଛି';
	@override String get storyRead => 'ଗୋଟିଏ କଥା ପଢ଼ାଗଲା';
	@override String get storyBookmarked => 'କଥା ବୁକମାର୍କ କରାଗଲା';
	@override String get storyShared => 'କଥା ସେୟାର୍ ହେଲା';
	@override String get storyCompleted => 'କଥା ସମାପ୍ତ ହେଲା';
	@override String get today => 'ଆଜି';
	@override String get yesterday => 'ଗତକାଲି';
	@override String get thisWeek => 'ଏହି ସପ୍ତାହ';
	@override String get earlier => 'ପୂର୍ବରୁ';
	@override String get noContinueReading => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ ପଢ଼ିବା ପାଇଁ କିଛି ନାହିଁ';
	@override String get noSavedStories => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି ସଞ୍ଚିତ କଥା ନାହିଁ';
	@override String get bookmarkStoriesToSave => 'କଥାଗୁଡ଼ିକୁ ସଞ୍ଚୟ କରିବାକୁ ବୁକମାର୍କ କରନ୍ତୁ';
	@override String get myGeneratedStories => 'ମୋର ସୃଷ୍ଟିତ କଥାଗୁଡ଼ିକ';
	@override String get noGeneratedStoriesYet => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି କଥା ସୃଷ୍ଟି ହୋଇନାହିଁ';
	@override String get createYourFirstStory => 'AI ର ମଦଦରେ ଆପଣଙ୍କ ପ୍ରଥମ କଥା ସୃଷ୍ଟି କରନ୍ତୁ';
	@override String get shareToFeed => 'ଫିଡ୍‌ରେ ସେୟାର୍ କରନ୍ତୁ';
	@override String get sharedToFeed => 'କଥା ଫିଡ୍‌ରେ ସେୟାର୍ ହେଲା';
	@override String get shareStoryTitle => 'କଥା ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareStoryMessage => 'ଆପଣଙ୍କ କଥା ପାଇଁ ଏକ କ୍ୟାପ୍ସନ୍ ଲେଖନ୍ତୁ (ଇଚ୍ଛାନୁସାରେ)';
	@override String get shareStoryCaption => 'କ୍ୟାପ୍ସନ୍';
	@override String get shareStoryHint => 'ଏହି କଥା ବିଷୟରେ ଆପଣ କଣ କହିବାକୁ ଚାହୁଁଛନ୍ତି?';
	@override String get exploreHeritageTitle => 'ଐତିହ୍ୟକୁ ଅନୁସନ୍ଧାନ କରନ୍ତୁ';
	@override String get exploreHeritageDesc => 'ମାନଚିତ୍ରରେ ସାସ୍କୃତିକ ଐତିହ୍ୟ ସ୍ଥଳଗୁଡ଼ିକୁ ଖୋଜନ୍ତୁ';
	@override String get whereToVisit => 'ପରବର୍ତ୍ତୀ ଭ୍ରମଣ';
	@override String get scriptures => 'ଶାସ୍ତ୍ର';
	@override String get exploreSacredSites => 'ପବିତ୍ର ସ୍ଥଳଗୁଡ଼ିକୁ ଅନୁସନ୍ଧାନ କରନ୍ତୁ';
	@override String get readStories => 'କଥା ପଢ଼ନ୍ତୁ';
	@override String get yesRemindMe => 'ହଁ, ମୋତେ ସ୍ମରଣ କରାନ୍ତୁ';
	@override String get noDontShowAgain => 'ନା, ପୁଣି ଦେଖାନ୍ତୁ ନାହିଁ';
	@override String get discoverDismissTitle => 'Discover MyItihas ଲୁଚାଇବେ କି?';
	@override String get discoverDismissMessage => 'ପରବର୍ତ୍ତୀଥର ଆପ୍ ଖୋଲିବା କିମ୍ବା ଲଗଇନ୍ କଲେ ଆପଣ ଏହାକୁ ପୁଣି ଦେଖିବାକୁ ଚାହିଁବେ କି?';
	@override String get discoverCardTitle => 'MyItihas ଅନୁସନ୍ଧାନ କରନ୍ତୁ';
	@override String get discoverCardSubtitle => 'ପ୍ରାଚୀନ ଶାସ୍ତ୍ରରୁ କଥାଗୁଡ଼ିକ, ଦର୍ଶନୀୟ ପବିତ୍ର ସ୍ଥଳ ଏବଂ ଆପଣଙ୍କ ହାତତଳାରେ ଜ୍ଞାନ।';
	@override String get swipeToDismiss => 'ବନ୍ଦ କରିବାକୁ ଉପରକୁ ସ୍ୱାଇପ୍ କରନ୍ତୁ';
	@override String get searchScriptures => 'ଶାସ୍ତ୍ର ଖୋଜନ୍ତୁ...';
	@override String get searchLanguages => 'ଭାଷାଗୁଡ଼ିକୁ ଖୋଜନ୍ତୁ...';
	@override String get exploreStoriesLabel => 'କଥାଗୁଡିକୁ ଖୋଜନ୍ତୁ';
	@override String get exploreMore => 'ଅଧିକ ଦେଖନ୍ତୁ';
	@override String get failedToLoadActivity => 'କାର୍ଯ୍ୟକଳାପ ଲୋଡ୍ କରିବାରେ ବିଫଳ ହେଲା';
	@override String get startReadingOrGenerating => 'ଏଠାରେ ଆପଣଙ୍କ କାର୍ଯ୍ୟକଳାପ ଦେଖିବା ପାଇଁ କଥା ପଢ଼ିବା କିମ୍ବା ସୃଷ୍ଟି କରିବା ଆରମ୍ଭ କରନ୍ତୁ';
	@override late final _TranslationsHomeScreenHeroOr hero = _TranslationsHomeScreenHeroOr._(_root);
}

// Path: stories
class _TranslationsStoriesOr extends TranslationsStoriesEn {
	_TranslationsStoriesOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'କଥାଗୁଡ଼ିକ';
	@override String get searchHint => 'ଶିରୋନାମା ବା ଲେଖକ ଦ୍ୱାରା ଖୋଜନ୍ତୁ...';
	@override String get sortBy => 'ଏହା ଅନୁଯାୟୀ ଚୟନ କରନ୍ତୁ';
	@override String get sortNewest => 'ନୂତନ ଥିବାଗୁଡ଼ିକ ପ୍ରଥମେ';
	@override String get sortOldest => 'ପୁରୁଣା ଥିବାଗୁଡ଼ିକ ପ୍ରଥମେ';
	@override String get sortPopular => 'ଅଧିକ ଜନପ୍ରିୟ';
	@override String get noStories => 'କୌଣସି କଥା ମିଳିଲା ନାହିଁ';
	@override String get loadingStories => 'କଥାଗୁଡ଼ିକ ଲୋଡ୍ ହେଉଛି...';
	@override String get errorLoadingStories => 'କଥାଗୁଡିକୁ ଲୋଡ୍ କରିବାରେ ତ୍ରୁଟି ହେଲା';
	@override String get storyDetails => 'କଥାର ବିବରଣୀ';
	@override String get continueReading => 'ପଢ଼ିବା ଜାରି ରଖନ୍ତୁ';
	@override String get readMore => 'ଅଧିକ ପଢ଼ନ୍ତୁ';
	@override String get readLess => 'କମ୍ ଦେଖାନ୍ତୁ';
	@override String get author => 'ଲେଖକ';
	@override String get publishedOn => 'ପ୍ରକାଶିତ ତାରିଖ';
	@override String get category => 'ଶ୍ରେଣୀ';
	@override String get tags => 'ଟ୍ୟାଗ୍ସ';
	@override String get failedToLoad => 'କଥା ଲୋଡ୍ ହେବାରେ ବିଫଳ';
	@override String get subtitle => 'ଶାସ୍ତ୍ରର କାହାଣୀ ଆବିଷ୍କାର କରନ୍ତୁ';
	@override String get noStoriesHint => 'କାହାଣୀ ଖୋଜିବା ପାଇଁ ଅନ୍ୟ ଖୋଜା କିମ୍ବା ଫିଲ୍ଟର ଚେଷ୍ଟା କରନ୍ତୁ।';
	@override String get featured => 'ବିଶେଷ';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorOr extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'କଥା ଜେନେରେଟର୍';
	@override String get subtitle => 'ନିଜର ଶାସ୍ତ୍ରୀୟ କଥା ସୃଷ୍ଟି କରନ୍ତୁ';
	@override String get quickStart => 'ଦ୍ରୁତ ଆରମ୍ଭ';
	@override String get interactive => 'ଇଣ୍ଟରାକ୍ଟିଭ୍';
	@override String get rawPrompt => 'କାଚା ପ୍ରମ୍ପ୍ଟ';
	@override String get yourStoryPrompt => 'ଆପଣଙ୍କ କଥା ପ୍ରମ୍ପ୍ଟ';
	@override String get writeYourPrompt => 'ଆପଣଙ୍କ ପ୍ରମ୍ପ୍ଟ ଲେଖନ୍ତୁ';
	@override String get selectScripture => 'ଶାସ୍ତ୍ର ବାଛନ୍ତୁ';
	@override String get selectStoryType => 'କଥାର ପ୍ରକାର ବାଛନ୍ତୁ';
	@override String get selectCharacter => 'ଚରିତ୍ର ବାଛନ୍ତୁ';
	@override String get selectTheme => 'ଥିମ୍ ବାଛନ୍ତୁ';
	@override String get selectSetting => 'ପରିବେଶ ବାଛନ୍ତୁ';
	@override String get selectLanguage => 'ଭାଷା ବାଛନ୍ତୁ';
	@override String get selectLength => 'କଥାର ଲମ୍ବ';
	@override String get moreOptions => 'ଅଧିକ ବିକଳ୍ପ';
	@override String get random => 'ଯାଦୃଚ୍ଛିକ';
	@override String get generate => 'କଥା ସୃଷ୍ଟି କରନ୍ତୁ';
	@override String get generating => 'ଆପଣଙ୍କ କଥା ସୃଷ୍ଟି ହେଉଛି...';
	@override String get creatingYourStory => 'ଆପଣଙ୍କ କଥା ସୃଷ୍ଟି ହେଉଛି';
	@override String get consultingScriptures => 'ପ୍ରାଚୀନ ଶାସ୍ତ୍ର ସହିତ ପରାମର୍ଶ ହେଉଛି...';
	@override String get weavingTale => 'ଆପଣଙ୍କ କଥାକୁ ବୁନାଯାଉଛି...';
	@override String get addingWisdom => 'ଦିବ୍ୟ ଜ୍ଞାନ ଯୋଡ଼ାଯାଉଛି...';
	@override String get polishingNarrative => 'କଥାକୁ ନିଖୁତ କରାଯାଉଛି...';
	@override String get almostThere => 'ପ୍ରାୟ ସମାପ୍ତ...';
	@override String get generatedStory => 'ଆପଣଙ୍କ ତିଆରି କରା କଥା';
	@override String get aiGenerated => 'AI ଦ୍ୱାରା ସୃଷ୍ଟିତ';
	@override String get regenerate => 'ପୁନର୍ବାର ସୃଷ୍ଟି କରନ୍ତୁ';
	@override String get saveStory => 'କଥା ସେଭ୍ କରନ୍ତୁ';
	@override String get shareStory => 'କଥା ସେୟାର୍ କରନ୍ତୁ';
	@override String get newStory => 'ନୂଆ କଥା';
	@override String get saved => 'ସଞ୍ଚିତ';
	@override String get storySaved => 'କଥାଟି ଆପଣଙ୍କ ଲାଇବ୍ରେରୀରେ ସଞ୍ଚିତ ହୋଇଗଲା';
	@override String get story => 'କଥା';
	@override String get lesson => 'ଶିକ୍ଷା';
	@override String get didYouKnow => 'ଆପଣ ଜାଣିଥିଲେ କି?';
	@override String get activity => 'କାର୍ଯ୍ୟକଳାପ';
	@override String get optionalRefine => 'ଇଚ୍ଛାନୁସାରେ: ବିକଳ୍ପ ସହିତ ଅଧିକ ସ୍ପଷ୍ଟ କରନ୍ତୁ';
	@override String get applyOptions => 'ବିକଳ୍ପ ଲାଗୁ କରନ୍ତୁ';
	@override String get language => 'ଭାଷା';
	@override String get storyFormat => 'କଥା ଫର୍ମାଟ୍';
	@override String get requiresInternet => 'କଥା ସୃଷ୍ଟି ପାଇଁ ଇଣ୍ଟରନେଟ୍ ଆବଶ୍ୟକ';
	@override String get notAvailableOffline => 'କଥା ଅଫ୍ଲାଇନ୍ ଉପଲବ୍ଧ ନୁହେଁ। ଦେଖିବା ପାଇଁ ଇଣ୍ଟରନେଟ୍ ସଂଯୋଗ କରନ୍ତୁ।';
	@override String get aiDisclaimer => 'AI ତ୍ରୁଟି କରିପାରେ। ଆମେ ନିରନ୍ତର ସୁଧାର କରୁଛୁ; ଆପଣଙ୍କ ମତାମତ ଗୁରୁତ୍ୱପୂର୍ଣ୍ଣ।';
	@override late final _TranslationsStoryGeneratorStoryLengthOr storyLength = _TranslationsStoryGeneratorStoryLengthOr._(_root);
	@override late final _TranslationsStoryGeneratorFormatOr format = _TranslationsStoryGeneratorFormatOr._(_root);
	@override late final _TranslationsStoryGeneratorHintsOr hints = _TranslationsStoryGeneratorHintsOr._(_root);
	@override late final _TranslationsStoryGeneratorErrorsOr errors = _TranslationsStoryGeneratorErrorsOr._(_root);
}

// Path: chat
class _TranslationsChatOr extends TranslationsChatEn {
	_TranslationsChatOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'ଶାସ୍ତ୍ର ବିଷୟରେ AI ସହ ଆଲୋଚନା କରନ୍ତୁ';
	@override String get friendMode => 'ମିତ୍ର ମୋଡ୍';
	@override String get philosophicalMode => 'ଦାର୍ଶନିକ ମୋଡ୍';
	@override String get typeMessage => 'ଆପଣଙ୍କ ସନ୍ଦେଶ ଟାଇପ୍ କରନ୍ତୁ...';
	@override String get send => 'ପଠାନ୍ତୁ';
	@override String get newChat => 'ନୂଆ ଚାଟ୍';
	@override String get chatsTab => 'ଚାଟ୍';
	@override String get groupsTab => 'ଗ୍ରୁପ୍‍ଗୁଡିକ';
	@override String get chatHistory => 'ଚାଟ ଇତିହାସ';
	@override String get clearChat => 'ଚାଟ୍ ସଫା କରନ୍ତୁ';
	@override String get noMessages => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ସନ୍ଦେଶ ନାହିଁ। ଗୋଟିଏ ଆଲୋଚନା ଆରମ୍ଭ କରନ୍ତୁ!';
	@override String get listPage => 'ଚାଟ ସୂଚୀ ପୃଷ୍ଠା';
	@override String get forwardMessageTo => 'ସନ୍ଦେଶକୁ ଆଗକୁ ପଠାନ୍ତୁ...';
	@override String get forwardMessage => 'ଫର୍ୱାର୍ଡ କରନ୍ତୁ';
	@override String get messageForwarded => 'ସନ୍ଦେଶ ଫର୍ୱାର୍ଡ ହେଲା';
	@override String failedToForward({required Object error}) => 'ସନ୍ଦେଶ ଫର୍ୱାର୍ଡ କରିବାରେ ବିଫଳ: ${error}';
	@override String get searchChats => 'ଚାଟଗୁଡ଼ିକୁ ଖୋଜନ୍ତୁ';
	@override String get noChatsFound => 'କୌଣସି ଚାଟ୍ ମିଳିଲା ନାହିଁ';
	@override String get requests => 'ଅନୁରୋଧ';
	@override String get messageRequests => 'ସନ୍ଦେଶ ଅନୁରୋଧ';
	@override String get groupRequests => 'ଗ୍ରୁପ୍ ଅନୁରୋଧ';
	@override String get requestSent => 'ଅନୁରୋଧ ପଠାଯାଇଛି। ସେମାନେ "ଅନୁରୋଧ" ଭିତରେ ଦେଖିବେ।';
	@override String get wantsToChat => 'ଚାଟ୍ କରିବାକୁ ଚାହୁଁଛନ୍ତି';
	@override String addedYouTo({required Object name}) => '${name} ଆପଣଙ୍କୁ ଯୋଡିଦେଇଛନ୍ତି';
	@override String get accept => 'ଗ୍ରହଣ କରନ୍ତୁ';
	@override String get noMessageRequests => 'କୌଣସି ସନ୍ଦେଶ ଅନୁରୋଧ ନାହିଁ';
	@override String get noGroupRequests => 'କୌଣସି ଗ୍ରୁପ୍ ଅନୁରୋଧ ନାହିଁ';
	@override String get invitesSent => 'ଆମନ୍ତ୍ରଣ ପଠାଯାଇଛି। ସେମାନେ "ଅନୁରୋଧ" ଭିତରେ ଦେଖିବେ।';
	@override String get cantMessageUser => 'ଆପଣ ଏହି ବ୍ୟବହାରକର୍ତ୍ତାଙ୍କୁ ସନ୍ଦେଶ ପଠାଇପାରିବେ ନାହିଁ';
	@override String get deleteChat => 'ଚାଟ୍ ବିଲୋପ କରନ୍ତୁ';
	@override String get deleteChats => 'ଚାଟଗୁଡ଼ିକୁ ବିଲୋପ କରନ୍ତୁ';
	@override String get blockUser => 'ବ୍ୟବହାରକର୍ତ୍ତାଙ୍କୁ ବ୍ଲକ୍ କରନ୍ତୁ';
	@override String get reportUser => 'ବ୍ୟବହାରକର୍ତ୍ତାଙ୍କୁ ରିପୋର୍ଟ କରନ୍ତୁ';
	@override String get markAsRead => 'ପଢ଼ିସାରିଲା ବୋଲି ଚିହ୍ନିତ କରନ୍ତୁ';
	@override String get markedAsRead => 'ପଢ଼ିସାରିଲା ବୋଲି ଚିହ୍ନିତ ହେଲା';
	@override String get deleteClearChat => 'ଚାଟ୍ ବିଲୋପ / ସଫା କରନ୍ତୁ';
	@override String get deleteConversation => 'କଥାବାର୍ତ୍ତା ବିଲୋପ କରନ୍ତୁ';
	@override String get reasonRequired => 'କାରଣ (ଆବଶ୍ୟକ)';
	@override String get submit => 'ଦାଖଲ କରନ୍ତୁ';
	@override String get userReportedBlocked => 'ବ୍ୟବହାରକର୍ତ୍ତା ରିପୋର୍ଟ ହେଲେ ଏବଂ ବ୍ଲକ୍ କରାଗଲା।';
	@override String reportFailed({required Object error}) => 'ରିପୋର୍ଟ କରିବାରେ ବିଫଳ: ${error}';
	@override String get newGroup => 'ନୂଆ ଦଳ';
	@override String get messageSomeoneDirectly => 'କାହାକୁ ସିଧାସଳଖ ସନ୍ଦେଶ ପଠାନ୍ତୁ';
	@override String get createGroupConversation => 'ଗ୍ରୁପ୍ କଥାବାର୍ତ୍ତା ସୃଷ୍ଟି କରନ୍ତୁ';
	@override String get noGroupsYet => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି ଗ୍ରୁପ୍ ନାହିଁ';
	@override String get noChatsYet => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି ଚାଟ୍ ନାହିଁ';
	@override String get tapToCreateGroup => 'ଗ୍ରୁପ୍ ସୃଷ୍ଟି କିମ୍ବା ଯୋଡ଼ିବାକୁ + ଦବାନ୍ତୁ';
	@override String get tapToStartConversation => 'ନୂତନ କଥାବାର୍ତ୍ତା ଆରମ୍ଭ କରିବାକୁ + ଦବାନ୍ତୁ';
	@override String get conversationDeleted => 'କଥାବାର୍ତ୍ତା ବିଲୋପ ହୋଇଗଲା';
	@override String conversationsDeleted({required Object count}) => '${count}ଟି କଥାବାର୍ତ୍ତା ବିଲୋପ ହେଲା';
	@override String get searchConversations => 'କଥାବାର୍ତ୍ତାଗୁଡ଼ିକୁ ଖୋଜନ୍ତୁ...';
	@override String get connectToInternet => 'ଦୟାକରି ଇଣ୍ଟରନେଟ୍ ସଂଯୋଗ କରି ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ।';
	@override String get littleKrishnaName => 'ଛୋଟ କୃଷ୍ଣ';
	@override String get newConversation => 'ନୂଆ କଥାବାର୍ତ୍ତା';
	@override String get noConversationsYet => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି କଥାବାର୍ତ୍ତା ନାହିଁ';
	@override String get confirmDeletion => 'ବିଲୋପ କରିବାକୁ ନିଶ୍ଚିତ କରନ୍ତୁ';
	@override String deleteConversationConfirm({required Object title}) => 'ଆପଣ ନିଶ୍ଚୟ ${title} କଥାବାର୍ତ୍ତାକୁ ବିଲୋପ କରିବାକୁ ଚାହୁଁଛନ୍ତି କି?';
	@override String get deleteFailed => 'କଥାବାର୍ତ୍ତା ବିଲୋପ କରିବାରେ ବିଫଳ';
	@override String get fullChatCopied => 'ସମ୍ପୂର୍ଣ୍ଣ ଚାଟ୍ କ୍ଲିପ୍‌ବୋର୍ଡକୁ କପି ହୋଇଯାଇଛି!';
	@override String get connectionErrorFallback => 'ଏହି ସମୟରେ ସଂଯୋଗରେ ସମସ୍ୟା ହେଉଛି। କିଛି ସମୟ ପରେ ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ।';
	@override String krishnaWelcomeWithName({required Object name}) => 'ହେ ${name}। ମୁଁ ଆପଣଙ୍କ ମିତ୍ର କୃଷ୍ଣ। ଆଜି କେମିତି ଅଛନ୍ତି?';
	@override String get krishnaWelcomeFriend => 'ହେ ପ୍ରିୟ ବନ୍ଧୁ, ମୁଁ ଆପଣଙ୍କ ମିତ୍ର କୃଷ୍ଣ। ଆଜି କେମିତି ଅଛନ୍ତି?';
	@override String get copyYouLabel => 'ଆପଣ';
	@override String get copyKrishnaLabel => 'କୃଷ୍ଣ';
	@override late final _TranslationsChatSuggestionsOr suggestions = _TranslationsChatSuggestionsOr._(_root);
	@override String get about => 'ସମ୍ବନ୍ଧରେ';
	@override String get yourFriendlyCompanion => 'ଆପଣଙ୍କ ମିତ୍ରତାପୂର୍ଣ୍ଣ ସହଚର';
	@override String get mentalHealthSupport => 'ମନୋସ୍ୱାସ୍ଥ୍ୟ ସହଯୋଗ';
	@override String get mentalHealthSupportSubtitle => 'ଚିନ୍ତା ଅଭିବ୍ୟକ୍ତ କରିବା ଏବଂ ଶୁଣାଯିବାର ଭାବ ହେବା ପାଇଁ ଏକ ସୁରକ୍ଷିତ ସ୍ଥାନ।';
	@override String get friendlyCompanion => 'ମିତ୍ରତାପୂର୍ଣ୍ଣ ସହଚର';
	@override String get friendlyCompanionSubtitle => 'କଥାହେବା, ପ୍ରେରଣା ଦେବା ଏବଂ ଜ୍ଞାନ ଦେବା ପାଇଁ ସର୍ବଦା ପ୍ରସ୍ତୁତ।';
	@override String get storiesAndWisdom => 'କଥା ଏବଂ ଜ୍ଞାନ';
	@override String get storiesAndWisdomSubtitle => 'ଅନନ୍ତ କାଳର କଥା ଏବଂ ବ୍ୟବହାରିକ ଜ୍ଞାନରୁ ଶିଖନ୍ତୁ।';
	@override String get askAnything => 'ଯାହାକୁଣି ପଚାରନ୍ତୁ';
	@override String get askAnythingSubtitle => 'ଆପଣଙ୍କ ପ୍ରଶ୍ନଗୁଡ଼ିକର ସମ୍ବେଦନଶୀଳ ଏବଂ ଭାବପୂର୍ଣ୍ଣ ଉତ୍ତର ପାଆନ୍ତୁ।';
	@override String get startChatting => 'ଚାଟ୍ ଆରମ୍ଭ କରନ୍ତୁ';
	@override String get maybeLater => 'ହୋଇପାରେ ପରେ';
	@override late final _TranslationsChatComposerAttachmentsOr composerAttachments = _TranslationsChatComposerAttachmentsOr._(_root);
}

// Path: map
class _TranslationsMapOr extends TranslationsMapEn {
	_TranslationsMapOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ଅଖଣ୍ଡ ଭାରତ';
	@override String get subtitle => 'ଇତିହାସିକ ସ୍ଥାନଗୁଡ଼ିକୁ ଅନୁସନ୍ଧାନ କରନ୍ତୁ';
	@override String get searchLocation => 'ସ୍ଥାନ ଖୋଜନ୍ତୁ...';
	@override String get viewDetails => 'ବିବରଣୀ ଦେଖନ୍ତୁ';
	@override String get viewSites => 'ସ୍ଥଳଗୁଡ଼ିକୁ ଦେଖନ୍ତୁ';
	@override String get showRoute => 'ପଥ ଦେଖାନ୍ତୁ';
	@override String get historicalInfo => 'ଇତିହାସିକ ସୂଚନା';
	@override String get nearbyPlaces => 'ନିକଟସ୍ଥ ସ୍ଥାନଗୁଡ଼ିକ';
	@override String get pickLocationOnMap => 'ମାନଚିତ୍ର ଉପରେ ସ୍ଥାନ ଚୟନ କରନ୍ତୁ';
	@override String get sitesVisited => 'ଭ୍ରମଣ କରା ସ୍ଥାନଗୁଡ଼ିକ';
	@override String get badgesEarned => 'ଅର୍ଜନ କରା ବ୍ୟାଜ୍';
	@override String get completionRate => 'ସମାପ୍ତି ହାର';
	@override String get addToJourney => 'ଯାତ୍ରାରେ ଯୋଡ଼ନ୍ତୁ';
	@override String get addedToJourney => 'ଯାତ୍ରାରେ ଯୋଡ଼ାଗଲା';
	@override String get getDirections => 'ନିର୍ଦ୍ଦେଶ ପାଆନ୍ତୁ';
	@override String get viewInMap => 'ମାନଚିତ୍ରରେ ଦେଖନ୍ତୁ';
	@override String get directions => 'ନିର୍ଦ୍ଦେଶଗୁଡ଼ିକ';
	@override String get photoGallery => 'ଫଟୋ ଗ୍ୟାଲେରୀ';
	@override String get viewAll => 'ସବୁ ଦେଖନ୍ତୁ';
	@override String get photoSavedToGallery => 'ଫଟୋ ଗ୍ୟାଲେରୀରେ ସଞ୍ଚିତ ହୋଇଗଲା';
	@override String get sacredSoundscape => 'ପବିତ୍ର ଶବ୍ଦ ପରିଦୃଶ୍ୟ';
	@override String get allDiscussions => 'ସମସ୍ତ ଆଲୋଚନା';
	@override String get journeyTab => 'ଯାତ୍ରା';
	@override String get discussionTab => 'ଆଲୋଚନା';
	@override String get myActivity => 'ମୋର କାର୍ଯ୍ୟକଳାପ';
	@override String get anonymousPilgrim => 'ନାମବିହୀନ ତୀର୍ଥଯାତ୍ରୀ';
	@override String get viewProfile => 'ପ୍ରୋଫାଇଲ୍ ଦେଖନ୍ତୁ';
	@override String get discussionTitleHint => 'ଆଲୋଚନା ଶିରୋନାମା...';
	@override String get shareYourThoughtsHint => 'ଆପଣଙ୍କ ବିଚାରଗୁଡ଼ିକୁ ସେୟାର୍ କରନ୍ତୁ...';
	@override String get pleaseEnterDiscussionTitle => 'ଦୟାକରି ଆଲୋଚନା ଶିରୋନାମା ଲେଖନ୍ତୁ';
	@override String get addReflection => 'ଅନୁଭବ ଯୋଡ଼ନ୍ତୁ';
	@override String get reflectionTitle => 'ଶିରୋନାମା';
	@override String get enterReflectionTitle => 'ଅନୁଭବର ଶିରୋନାମା ଲେଖନ୍ତୁ';
	@override String get pleaseEnterTitle => 'ଦୟାକରି ଏକ ଶିରୋନାମା ଲେଖନ୍ତୁ';
	@override String get siteName => 'ସ୍ଥାନର ନାମ';
	@override String get enterSacredSiteName => 'ପବିତ୍ର ସ୍ଥାନର ନାମ ଲେଖନ୍ତୁ';
	@override String get pleaseEnterSiteName => 'ଦୟାକରି ସ୍ଥାନର ନାମ ଲେଖନ୍ତୁ';
	@override String get reflection => 'ଅନୁଭବ';
	@override String get reflectionHint => 'ଆପଣଙ୍କ ଅନୁଭବ ଏବଂ ଭାବନାଗୁଡ଼ିକୁ ସେୟାର୍ କରନ୍ତୁ...';
	@override String get pleaseEnterReflection => 'ଦୟାକରି ଆପଣଙ୍କ ଅନୁଭବ ଲେଖନ୍ତୁ';
	@override String get saveReflection => 'ଅନୁଭବ ସେଭ୍ କରନ୍ତୁ';
	@override String get journeyProgress => 'ଯାତ୍ରାର ଅଗ୍ରଗତି';
	@override late final _TranslationsMapDiscussionsOr discussions = _TranslationsMapDiscussionsOr._(_root);
	@override late final _TranslationsMapFabricMapOr fabricMap = _TranslationsMapFabricMapOr._(_root);
	@override late final _TranslationsMapClassicalArtMapOr classicalArtMap = _TranslationsMapClassicalArtMapOr._(_root);
	@override late final _TranslationsMapClassicalDanceMapOr classicalDanceMap = _TranslationsMapClassicalDanceMapOr._(_root);
	@override late final _TranslationsMapFoodMapOr foodMap = _TranslationsMapFoodMapOr._(_root);
}

// Path: community
class _TranslationsCommunityOr extends TranslationsCommunityEn {
	_TranslationsCommunityOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ସମୁଦାୟ';
	@override String get trending => 'ଟ୍ରେଣ୍ଡିଂ';
	@override String get following => 'ଅନୁସରଣ କରୁଛନ୍ତି';
	@override String get followers => 'ଅନୁସରଣକାରୀ';
	@override String get posts => 'ପୋଷ୍ଟଗୁଡ଼ିକ';
	@override String get follow => 'ଅନୁସରଣ କରନ୍ତୁ';
	@override String get unfollow => 'ଅନୁସରଣ ବନ୍ଦ କରନ୍ତୁ';
	@override String get shareYourStory => 'ଆପଣଙ୍କ କଥା ଶେୟର କରନ୍ତୁ...';
	@override String get post => 'ପୋଷ୍ଟ କରନ୍ତୁ';
	@override String get like => 'ପସନ୍ଦ';
	@override String get comment => 'ମନ୍ତବ୍ୟ';
	@override String get comments => 'ମନ୍ତବ୍ୟଗୁଡ଼ିକ';
	@override String get noPostsYet => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି ପୋଷ୍ଟ ନାହିଁ';
}

// Path: discover
class _TranslationsDiscoverOr extends TranslationsDiscoverEn {
	_TranslationsDiscoverOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ଖୋଜନ୍ତୁ';
	@override String get searchHint => 'କଥା, ବ୍ୟବହାରକର୍ତ୍ତା କିମ୍ବା ବିଷୟ ଖୋଜନ୍ତୁ...';
	@override String get tryAgain => 'ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ';
	@override String get somethingWentWrong => 'କିଛି ଭୁଲ୍ ହେଲା';
	@override String get unableToLoadProfiles => 'ପ୍ରୋଫାଇଲ୍ ଲୋଡ୍ କରିପାରିଲା ନାହିଁ। ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ।';
	@override String get noProfilesFound => 'କୌଣସି ପ୍ରୋଫାଇଲ୍ ମିଳିଲା ନାହିଁ';
	@override String get searchToFindPeople => 'ଅନୁସରଣ କରିବାକୁ ଲୋକଙ୍କୁ ଖୋଜନ୍ତୁ';
	@override String get noResultsFound => 'କୌଣସି ଫଳାଫଳ ମିଳିଲା ନାହିଁ';
	@override String get noProfilesYet => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି ପ୍ରୋଫାଇଲ୍ ନାହିଁ';
	@override String get tryDifferentKeywords => 'ଭିନ୍ନ କୀୱାର୍ଡ୍ ଦ୍ୱାରା ଖୋଜନ୍ତୁ';
	@override String get beFirstToDiscover => 'ନୂତନ ଲୋକଙ୍କୁ ଖୋଜିବାରେ ପ୍ରଥମ ହୁଅନ୍ତୁ!';
}

// Path: plan
class _TranslationsPlanOr extends TranslationsPlanEn {
	_TranslationsPlanOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'ଆପଣଙ୍କ ପ୍ରଯୋଜନା ସଞ୍ଚିତ କରିବାକୁ ସାଇନ୍ ଇନ୍ କରନ୍ତୁ';
	@override String get planSaved => 'ପ୍ରଯୋଜନା ସଞ୍ଚିତ ହୋଇଗଲା';
	@override String get from => 'କୋଠାରୁ';
	@override String get dates => 'ତାରିଖଗୁଡ଼ିକ';
	@override String get destination => 'ଗନ୍ତବ୍ୟ ସ୍ଥାନ';
	@override String get nearby => 'ନିକଟସ୍ଥ';
	@override String get generatedPlan => 'ସୃଷ୍ଟିତ ପ୍ରଯୋଜନା';
	@override String get whereTravellingFrom => 'ଆପଣ କେଉଁଠାରୁ ଯାତ୍ରା କରୁଛନ୍ତି?';
	@override String get enterCityOrRegion => 'ଆପଣଙ୍କ ସହର କିମ୍ବା ଅଞ୍ଚଳ ଲେଖନ୍ତୁ';
	@override String get travelDates => 'ଭ୍ରମଣ ତାରିଖଗୁଡ଼ିକ';
	@override String get destinationSacredSite => 'ଗନ୍ତବ୍ୟ (ପବିତ୍ର ସ୍ଥାନ)';
	@override String get searchOrSelectDestination => 'ଗନ୍ତବ୍ୟ ସ୍ଥାନ ଖୋଜନ୍ତୁ କିମ୍ବା ଚୟନ କରନ୍ତୁ...';
	@override String get shareYourExperience => 'ଆପଣଙ୍କ ଅନୁଭବ ଶେୟାର୍ କରନ୍ତୁ';
	@override String get planShared => 'ପ୍ରଯୋଜନା ସେୟାର୍ ହୋଇଗଲା';
	@override String failedToSharePlan({required Object error}) => 'ପ୍ରଯୋଜନା ସେୟାର୍ କରିବାରେ ବିଫଳ: ${error}';
	@override String get planUpdated => 'ପ୍ରଯୋଜନା ଅଦ୍ୟତିତ ହୋଇଗଲା';
	@override String failedToUpdatePlan({required Object error}) => 'ପ୍ରଯୋଜନା ଅଦ୍ୟତନ କରିବାରେ ବିଫଳ: ${error}';
	@override String get deletePlanConfirm => 'ପ୍ରଯୋଜନା ବିଲୋପ କରିବେ କି?';
	@override String get thisPlanPermanentlyDeleted => 'ଏହି ପ୍ରଯୋଜନା ସ୍ଥାୟୀଭାବେ ବିଲୋପ ହେବ।';
	@override String get planDeleted => 'ପ୍ରଯୋଜନା ବିଲୋପ ହୋଇଗଲା';
	@override String failedToDeletePlan({required Object error}) => 'ପ୍ରଯୋଜନା ବିଲୋପ କରିବାରେ ବିଫଳ: ${error}';
	@override String get sharePlan => 'ପ୍ରଯୋଜନା ସେୟାର୍ କରନ୍ତୁ';
	@override String get deletePlan => 'ପ୍ରଯୋଜନା ବିଲୋପ କରନ୍ତୁ';
	@override String get savedPlanDetails => 'ସଞ୍ଚିତ ପ୍ରଯୋଜନା ବିବରଣୀ';
	@override String get pilgrimagePlan => 'ତୀର୍ଥଯାତ୍ରା ପ୍ରଯୋଜନା';
	@override String get planTab => 'ଯୋଜନା';
}

// Path: settings
class _TranslationsSettingsOr extends TranslationsSettingsEn {
	_TranslationsSettingsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ସେଟିଂସ୍';
	@override String get language => 'ଭାଷା';
	@override String get theme => 'ଥିମ୍';
	@override String get themeLight => 'ହାଲୁକା';
	@override String get themeDark => 'ଗାଢ଼';
	@override String get themeSystem => 'ସିଷ୍ଟମ୍ ଥିମ୍ ବ୍ୟବହାର କରନ୍ତୁ';
	@override String get darkMode => 'ଗାଢ଼ ମୋଡ୍';
	@override String get selectLanguage => 'ଭାଷା ବାଛନ୍ତୁ';
	@override String get notifications => 'ବିଜ୍ଞପ୍ତି';
	@override String get cacheSettings => 'କ୍ୟାଚେ ଏବଂ ସ୍ଟୋରେଜ୍';
	@override String get general => 'ସାମାନ୍ୟ';
	@override String get account => 'ଖାତା';
	@override String get blockedUsers => 'ବ୍ଲକ୍ କରା ବ୍ୟବହାରକର୍ତ୍ତା';
	@override String get helpSupport => 'ସାହାଯ୍ୟ ଏବଂ ସମର୍ଥନ';
	@override String get contactUs => 'ଆମ ସହ ସମ୍ପର୍କ କରନ୍ତୁ';
	@override String get legal => 'ଆଇନଗତ';
	@override String get privacyPolicy => 'ଗୋପନୀୟତା ନୀତି';
	@override String get termsConditions => 'ନିୟମ ଏବଂ ନିବନ୍ଧନ';
	@override String get privacy => 'ଗୋପନୀୟତା';
	@override String get about => 'ଏପ୍ ବିଷୟରେ';
	@override String get version => 'ସଂସ୍କରଣ';
	@override String get logout => 'ଲଗ୍ଆଉଟ୍';
	@override String get deleteAccount => 'ଖାତା ବିଲୋପ କରନ୍ତୁ';
	@override String get deleteAccountTitle => 'ଖାତା ବିଲୋପ କରନ୍ତୁ';
	@override String get deleteAccountWarning => 'ଏହି କାମଟି ପଛକୁ ନେଇପାରିବେ ନାହିଁ!';
	@override String get deleteAccountDescription => 'ଆପଣଙ୍କ ଖାତା ବିଲୋପ କରିବା ପରେ ଆପଣଙ୍କ ସମସ୍ତ ପୋଷ୍ଟ, ମନ୍ତବ୍ୟ, ପ୍ରୋଫାଇଲ୍, ଫଲୋଆର୍, ସଞ୍ଚିତ କଥା, ବୁକମାର୍କ, ଚାଟ୍ ସନ୍ଦେଶ ଏବଂ ସୃଷ୍ଟିତ କଥାଗୁଡ଼ିକ ସ୍ଥାୟୀଭାବେ ମିଛିଯିବ।';
	@override String get confirmPassword => 'ଆପଣଙ୍କ ପାସୱାର୍ଡ ନିଶ୍ଚିତ କରନ୍ତୁ';
	@override String get confirmPasswordDesc => 'ଖାତା ବିଲୋପ ନିଶ୍ଚିତ କରିବାକୁ ପାସୱାର୍ଡ ଲେଖନ୍ତୁ।';
	@override String get googleReauth => 'ଆପଣଙ୍କ ପରିଚୟ ସନ୍ଦିଗ୍ଧ କରିବାକୁ ଆପଣଙ୍କୁ Google କୁ ପଠାଯିବ।';
	@override String get finalConfirmationTitle => 'ଚୁଡ଼ାନ୍ତ ନିଶ୍ଚୟ';
	@override String get finalConfirmation => 'ଆପଣ ନିଶ୍ଚିତ କି? ଏହା ସ୍ଥାୟୀ ଏବଂ ପଛକୁ ନେଇପାରିବେ ନାହିଁ।';
	@override String get deleteMyAccount => 'ମୋର ଖାତା ବିଲୋପ କରନ୍ତୁ';
	@override String get deletingAccount => 'ଖାତା ବିଲୋପ କରାଯାଉଛି...';
	@override String get accountDeleted => 'ଆପଣଙ୍କ ଖାତା ସ୍ଥାୟୀଭାବେ ବିଲୋପ ହୋଇଗଲା।';
	@override String get deleteAccountFailed => 'ଖାତା ବିଲୋପ କରିବାରେ ବିଫଳ। ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ।';
	@override String get downloadedStories => 'ଡାଉନ୍ଲୋଡ୍ କରା କଥାଗୁଡ଼ିକ';
	@override String get couldNotOpenEmail => 'ଇମେଲ୍ ଆପ୍ ଖୋଲିବାକୁ ସମର୍ଥ ହେଲା ନାହିଁ। ଦୟାକରି ଆମକୁ myitihas@gmail.com କୁ ଇମେଲ୍ କରନ୍ତୁ।';
	@override String couldNotOpenLabel({required Object label}) => '${label} କୁ ଏହି ସମୟରେ ଖୋଲିପାରିଲା ନାହିଁ।';
	@override String get logoutTitle => 'ଲଗ୍ଆଉଟ୍';
	@override String get logoutConfirm => 'ଆପଣ ନିଶ୍ଚିତ ଲଗ୍ଆଉଟ୍ କରିବାକୁ ଚାହୁଁଛନ୍ତି କି?';
	@override String get verifyYourIdentity => 'ଆପଣଙ୍କ ପରିଚୟ ସନ୍ଦିଗ୍ଧ କରନ୍ତୁ';
	@override String get verifyYourIdentityDesc => 'ପରିଚୟ ସନ୍ଦିଗ୍ଧ କରିବାକୁ ଆପଣଙ୍କୁ Google ସହିତ ସାଇନ୍ ଇନ୍ କରିବାକୁ କୁହାଯିବ।';
	@override String get continueWithGoogle => 'Google ଦ୍ୱାରା ଅଗ୍ରଗତି କରନ୍ତୁ';
	@override String reauthFailed({required Object error}) => 'ପୁନର୍ବାର ପ୍ରାମାଣିକତା ବିଫଳ: ${error}';
	@override String get passwordRequired => 'ପାସୱାର୍ଡ ଆବଶ୍ୟକ';
	@override String get invalidPassword => 'ଅବୈଧ ପାସୱାର୍ଡ। ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ।';
	@override String get verify => 'ସନ୍ଦିଗ୍ଧ କରନ୍ତୁ';
	@override String get continueLabel => 'ଅଗ୍ରଗତି କରନ୍ତୁ';
	@override String get unableToVerifyIdentity => 'ପରିଚୟ ସନ୍ଦିଗ୍ଧ କରିପାରିଲା ନାହିଁ। ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ।';
}

// Path: auth
class _TranslationsAuthOr extends TranslationsAuthEn {
	_TranslationsAuthOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get login => 'ଲଗିନ୍';
	@override String get signup => 'ସାଇନ୍ ଅପ୍';
	@override String get email => 'ଇମେଲ୍';
	@override String get password => 'ପାସୱାର୍ଡ';
	@override String get confirmPassword => 'ପାସୱାର୍ଡ ନିଶ୍ଚିତ କରନ୍ତୁ';
	@override String get forgotPassword => 'ପାସୱାର୍ଡ ଭୁଲି ଯାଇଛନ୍ତି କି?';
	@override String get resetPassword => 'ପାସୱାର୍ଡ ରିସେଟ୍ କରନ୍ତୁ';
	@override String get dontHaveAccount => 'ଖାତା ନାହିଁ କି?';
	@override String get alreadyHaveAccount => 'ପୂର୍ବରୁ ଖାତା ଅଛି କି?';
	@override String get loginSuccess => 'ଲଗିନ୍ ସଫଳ';
	@override String get signupSuccess => 'ସାଇନ୍ ଅପ୍ ସଫଳ';
	@override String get loginError => 'ଲଗିନ୍ ବିଫଳ';
	@override String get signupError => 'ସାଇନ୍ ଅପ୍ ବିଫଳ';
}

// Path: error
class _TranslationsErrorOr extends TranslationsErrorEn {
	_TranslationsErrorOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get network => 'ଇଣ୍ଟରନେଟ୍ ସଂଯୋଗ ନାହିଁ';
	@override String get server => 'ସର୍ଭରରେ ତ୍ରୁଟି ହୋଇଛି';
	@override String get cache => 'ସଞ୍ଚିତ ତଥ୍ୟ ଲୋଡ୍ କରିବାରେ ବିଫଳ';
	@override String get timeout => 'ଅନୁରୋଧର ସମୟ ସମାପ୍ତ';
	@override String get notFound => 'ସଂସାଧନ ମିଳିଲା ନାହିଁ';
	@override String get validation => 'ଯାଞ୍ଚ ବିଫଳ';
	@override String get unexpected => 'ଅପ୍ରତ୍ୟାଶିତ ତ୍ରୁଟି ଘଟିଛି';
	@override String get tryAgain => 'ଦୟାକରି ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ';
	@override String couldNotOpenLink({required Object url}) => 'ଲିଙ୍କ ଖୋଲିହେଲା ନାହିଁ: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionOr extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get free => 'ନିଶୁଳ୍କ';
	@override String get plus => 'ପ୍ଲସ୍';
	@override String get pro => 'ପ୍ରୋ';
	@override String get upgradeToPro => 'ପ୍ରୋକୁ ଅପ୍‌ଗ୍ରେଡ୍ କରନ୍ତୁ';
	@override String get features => 'ବୈଶିଷ୍ଟ୍ୟଗୁଡ଼ିକ';
	@override String get subscribe => 'ସବ୍ସ୍କ୍ରାଇବ୍ କରନ୍ତୁ';
	@override String get currentPlan => 'ବର୍ତ୍ତମାନ ପ୍ରଯୋଜନା';
	@override String get managePlan => 'ପ୍ରଯୋଜନା ପରିଚାଳନା କରନ୍ତୁ';
}

// Path: notification
class _TranslationsNotificationOr extends TranslationsNotificationEn {
	_TranslationsNotificationOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ସୂଚନା';
	@override String get peopleToConnect => 'ଯାହାଙ୍କ ସହ ଯୋଡ଼ିବା ଉଚିତ';
	@override String get peopleToConnectSubtitle => 'ଅନୁସରଣ କରିବା ପାଇଁ ଲୋକମାନଙ୍କୁ ଖୋଜନ୍ତୁ';
	@override String followAgainInMinutes({required Object minutes}) => '${minutes} ମିନିଟ୍ ପରେ ପୁନର୍ବାର ଅନୁସରଣ କରିପାରିବେ';
	@override String get noSuggestions => 'ଏହି ସମୟରେ କୌଣସି ପ୍ରସ୍ତାବ ନାହିଁ';
	@override String get markAllRead => 'ସବୁକୁ ପଢ଼ିହେଲା ବୋଲି ଚିହ୍ନିତ କରନ୍ତୁ';
	@override String get noNotifications => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି ସୂଚନା ନାହିଁ';
	@override String get noNotificationsSubtitle => 'କେହି ଆପଣଙ୍କ କଥା ସହ ଯୋଡ଼ିବା ପରେ ଏଠାରେ ଦେଖିବେ';
	@override String get errorPrefix => 'ତ୍ରୁଟି:';
	@override String get retry => 'ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ';
	@override String likedYourStory({required Object actorName}) => '${actorName} ଆପଣଙ୍କ କଥାକୁ ପସନ୍ଦ କରିଛନ୍ତି';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} ଆପଣଙ୍କ କଥା ଉପରେ ମନ୍ତବ୍ୟ କରିଛନ୍ତି';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} ଆପଣଙ୍କ ମନ୍ତବ୍ୟକୁ ଉତ୍ତର ଦେଇଛନ୍ତି';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} ଆପଣଙ୍କୁ ଅନୁସରଣ କରିବା ଆରମ୍ଭ କରିଛନ୍ତି';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} ଆପଣଙ୍କୁ ଗୋଟିଏ ସନ୍ଦେଶ ପଠାଇଛନ୍ତି';
	@override String sharedYourStory({required Object actorName}) => '${actorName} ଆପଣଙ୍କ କଥା ସେୟାର୍ କରିଛନ୍ତି';
	@override String repostedYourStory({required Object actorName}) => '${actorName} ଆପଣଙ୍କ କଥାକୁ ପୁନର୍ବାର ପୋଷ୍ଟ କରିଛନ୍ତି';
	@override String mentionedYou({required Object actorName}) => '${actorName} ଆପଣଙ୍କୁ ଉଲ୍ଲେଖ କରିଛନ୍ତି';
	@override String newPostFrom({required Object actorName}) => '${actorName} ଙ୍କ ନୂଆ ପୋଷ୍ଟ';
	@override String get today => 'ଆଜି';
	@override String get thisWeek => 'ଏହି ସପ୍ତାହ';
	@override String get earlier => 'ପୂର୍ବରୁ';
	@override String get delete => 'ବିଲୋପ କରନ୍ତୁ';
}

// Path: profile
class _TranslationsProfileOr extends TranslationsProfileEn {
	_TranslationsProfileOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get followers => 'ଅନୁସରଣକାରୀ';
	@override String get following => 'ଅନୁସରଣ କରୁଛନ୍ତି';
	@override String get unfollow => 'ଅନୁସରଣ ବନ୍ଦ କରନ୍ତୁ';
	@override String get follow => 'ଅନୁସରଣ କରନ୍ତୁ';
	@override String get about => 'ବିଷୟରେ';
	@override String get stories => 'କଥା';
	@override String get unableToShareImage => 'ଛବି ସେୟାର୍ କରିପାରିଲା ନାହିଁ';
	@override String get imageSavedToPhotos => 'ଛବି ଫଟୋଗୁଡ଼ିକୁ ସଞ୍ଚିତ ହୋଇଗଲା';
	@override String get view => 'ଦେଖନ୍ତୁ';
	@override String get saveToPhotos => 'ଫଟୋରେ ସଞ୍ଚୟ କରନ୍ତୁ';
	@override String get failedToLoadImage => 'ଛବି ଲୋଡ୍ କରିବାରେ ବିଫଳ';
}

// Path: feed
class _TranslationsFeedOr extends TranslationsFeedEn {
	_TranslationsFeedOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get loading => 'କଥାଗୁଡ଼ିକ ଲୋଡ୍ ହେଉଛି...';
	@override String get loadingPosts => 'ପୋଷ୍ଟଗୁଡ଼ିକ ଲୋଡ୍ ହେଉଛି...';
	@override String get loadingVideos => 'ଭିଡିଓଗୁଡ଼ିକ ଲୋଡ୍ ହେଉଛି...';
	@override String get loadingStories => 'କଥାଗୁଡ଼ିକ ଲୋଡ୍ ହେଉଛି...';
	@override String get errorTitle => 'ହାଏ! କିଛି ଭୁଲ୍ ହେଲା';
	@override String get tryAgain => 'ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ';
	@override String get noStoriesAvailable => 'କୌଣସି କଥା ଉପଲବ୍ଧ ନାହିଁ';
	@override String get noImagesAvailable => 'କୌଣସି ଛବି ପୋଷ୍ଟ ଉପଲବ୍ଧ ନାହିଁ';
	@override String get noTextPostsAvailable => 'କୌଣସି ଟେକ୍ସଟ୍ ପୋଷ୍ଟ ଉପଲବ୍ଧ ନାହିଁ';
	@override String get noContentAvailable => 'କୌଣସି ବିଷୟବସ୍ତୁ ଉପଲବ୍ଧ ନାହିଁ';
	@override String get refresh => 'ରିଫ୍ରେଶ୍ କରନ୍ତୁ';
	@override String get comments => 'ମନ୍ତବ୍ୟଗୁଡ଼ିକ';
	@override String get commentsComingSoon => 'ଶୀଘ୍ର ମନ୍ତବ୍ୟ ବିଶେଷତା ଆସୁଛି';
	@override String get addCommentHint => 'ମନ୍ତବ୍ୟ ଯୋଡ଼ନ୍ତୁ...';
	@override String get shareStory => 'କଥା ସେୟାର୍ କରନ୍ତୁ';
	@override String get sharePost => 'ପୋଷ୍ଟ ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareThought => 'ଚିନ୍ତା ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareAsImage => 'ଛବି ଭାବେ ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareAsImageSubtitle => 'ସୁନ୍ଦର ପ୍ରିଭ୍ୟୁ କାର୍ଡ୍ ତିଆରି କରନ୍ତୁ';
	@override String get shareLink => 'ଲିଙ୍କ ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareLinkSubtitle => 'କଥାର ଲିଙ୍କକୁ କପି କିମ୍ବା ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareImageLinkSubtitle => 'ପୋଷ୍ଟର ଲିଙ୍କକୁ କପି କିମ୍ବା ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareTextLinkSubtitle => 'ଚିନ୍ତାର ଲିଙ୍କକୁ କପି କିମ୍ବା ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareAsText => 'ଟେକ୍ସଟ୍ ଭାବେ ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareAsTextSubtitle => 'କଥାର ଏକ ଅଂଶ ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareQuote => 'ଉକ୍ତି ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareQuoteSubtitle => 'ଉକ୍ତି ଭାବେ ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareWithImage => 'ଛବି ସହିତ ସେୟାର୍ କରନ୍ତୁ';
	@override String get shareWithImageSubtitle => 'ଛବି ସହିତ କ୍ୟାପ୍ସନ୍ ସେୟାର୍ କରନ୍ତୁ';
	@override String get copyLink => 'ଲିଙ୍କ କପି କରନ୍ତୁ';
	@override String get copyLinkSubtitle => 'ଲିଙ୍କକୁ କ୍ଲିପ୍‌ବୋର୍ଡକୁ କପି କରନ୍ତୁ';
	@override String get copyText => 'ଟେକ୍ସଟ୍ କପି କରନ୍ତୁ';
	@override String get copyTextSubtitle => 'ଉକ୍ତିକୁ କ୍ଲିପ୍‌ବୋର୍ଡକୁ କପି କରନ୍ତୁ';
	@override String get linkCopied => 'ଲିଙ୍କ କ୍ଲିପ୍‌ବୋର୍ଡକୁ କପି ହୋଇଗଲା';
	@override String get textCopied => 'ଟେକ୍ସଟ୍ କ୍ଲିପ୍‌ବୋର୍ଡକୁ କପି ହୋଇଗଲା';
	@override String get sendToUser => 'ବ୍ୟବହାରକର୍ତ୍ତାଙ୍କୁ ପଠାନ୍ତୁ';
	@override String get sendToUserSubtitle => 'ଜଣେ ବନ୍ଧୁଙ୍କୁ ସିଧାସଳଖ ସେୟାର୍ କରନ୍ତୁ';
	@override String get chooseFormat => 'ଫର୍ମାଟ୍ ବାଛନ୍ତୁ';
	@override String get linkPreview => 'ଲିଙ୍କ ପ୍ରିଭ୍ୟୁ';
	@override String get linkPreviewSize => '୧୨୦୦ × ୬୩୦';
	@override String get storyFormat => 'ଷ୍ଟୋରି ଫର୍ମାଟ୍';
	@override String get storyFormatSize => '୧୦୮୦ × ୧୯୨୦ (Instagram/Stories)';
	@override String get generatingPreview => 'ପ୍ରିଭ୍ୟୁ ସୃଷ୍ଟି ହେଉଛି...';
	@override String get bookmarked => 'ବୁକମାର୍କ କରାଗଲା';
	@override String get removedFromBookmarks => 'ବୁକମାର୍କରୁ ବିଲୋପ ହେଲା';
	@override String unlike({required Object count}) => 'ଅପସନ୍ଦ, ${count}ଟି ପସନ୍ଦ';
	@override String like({required Object count}) => 'ପସନ୍ଦ, ${count}ଟି ପସନ୍ଦ';
	@override String commentCount({required Object count}) => '${count}ଟି ମନ୍ତବ୍ୟ';
	@override String shareCount({required Object count}) => 'ସେୟାର୍, ${count} ଥର ସେୟାର୍';
	@override String get removeBookmark => 'ବୁକମାର୍କ ବିଲୋପ କରନ୍ତୁ';
	@override String get addBookmark => 'ବୁକମାର୍କ କରନ୍ତୁ';
	@override String get quote => 'ଉକ୍ତି';
	@override String get quoteCopied => 'ଉକ୍ତି କ୍ଲିପ୍‌ବୋର୍ଡକୁ କପି ହୋଇଗଲା';
	@override String get copy => 'କପି କରନ୍ତୁ';
	@override String get tapToViewFullQuote => 'ପୂର୍ଣ୍ଣ ଉକ୍ତି ଦେଖିବାକୁ ଟାପ୍ କରନ୍ତୁ';
	@override String get quoteFromMyitihas => 'MyItihas ରୁ ଉକ୍ତି';
	@override late final _TranslationsFeedTabsOr tabs = _TranslationsFeedTabsOr._(_root);
	@override String get tapToShowCaption => 'କ୍ୟାପ୍ସନ୍ ଦେଖିବାକୁ ଟାପ୍ କରନ୍ତୁ';
	@override String get noVideosAvailable => 'କୌଣସି ଭିଡିଓ ଉପଲବ୍ଧ ନାହିଁ';
	@override String get selectUser => 'କାହାକୁ ପଠାଇବେ';
	@override String get searchUsers => 'ବ୍ୟବହାରକର୍ତ୍ତାଙ୍କୁ ଖୋଜନ୍ତୁ...';
	@override String get noFollowingYet => 'ଆପଣ ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କାହାକୁ ଅନୁସରଣ କରୁନାହାନ୍ତି';
	@override String get noUsersFound => 'କୌଣସି ବ୍ୟବହାରକର୍ତ୍ତା ମିଳିଲା ନାହିଁ';
	@override String get tryDifferentSearch => 'ଭିନ୍ନ ଖୋଜ ବାକ୍ୟ ବ୍ୟବହାର କରନ୍ତୁ';
	@override String sentTo({required Object username}) => '${username}ଙ୍କୁ ପଠାଯାଇଛି';
}

// Path: voice
class _TranslationsVoiceOr extends TranslationsVoiceEn {
	_TranslationsVoiceOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'ମାଇକ୍ରୋଫୋନ୍ ଅନୁମତି ଆବଶ୍ୟକ';
	@override String get speechRecognitionNotAvailable => 'ସ୍ୱର ଚିହ୍ନଟ ସୁବିଧା ଉପଲବ୍ଧ ନାହିଁ';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsOr extends TranslationsFestivalsEn {
	_TranslationsFestivalsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ପର୍ବ କାହାଣୀ';
	@override String get tellStory => 'କାହାଣୀ କୁହନ୍ତୁ';
}

// Path: social
class _TranslationsSocialOr extends TranslationsSocialEn {
	_TranslationsSocialOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileOr editProfile = _TranslationsSocialEditProfileOr._(_root);
	@override late final _TranslationsSocialCreatePostOr createPost = _TranslationsSocialCreatePostOr._(_root);
	@override late final _TranslationsSocialCommentsOr comments = _TranslationsSocialCommentsOr._(_root);
	@override late final _TranslationsSocialEngagementOr engagement = _TranslationsSocialEngagementOr._(_root);
	@override String get editCaption => 'କ୍ୟାପ୍ସନ ସମ୍ପାଦନ କରନ୍ତୁ';
	@override String get reportPost => 'ପୋଷ୍ଟ ରିପୋର୍ଟ କରନ୍ତୁ';
	@override String get reportReasonHint => 'ଏହି ପୋଷ୍ଟରେ କଣ ଭୁଲ୍ ଅଛି ଆମକୁ କହନ୍ତୁ';
	@override String get deletePost => 'ପୋଷ୍ଟ ବିଲୋପ କରନ୍ତୁ';
	@override String get deletePostConfirm => 'ଏହି କାମଟିକୁ ପଛକୁ ନେଇପାରିବେ ନାହିଁ।';
	@override String get postDeleted => 'ପୋଷ୍ଟ ବିଲୋପ ହୋଇଗଲା';
	@override String failedToDeletePost({required Object error}) => 'ପୋଷ୍ଟ ବିଲୋପ କରିବାରେ ବିଫଳ: ${error}';
	@override String failedToReportPost({required Object error}) => 'ପୋଷ୍ଟ ରିପୋର୍ଟ କରିବାରେ ବିଫଳ: ${error}';
	@override String get reportSubmitted => 'ରିପୋର୍ଟ ସମର୍ପିତ ହୋଇଗଲା। ଧନ୍ୟବାଦ।';
	@override String get acceptRequestFirst => 'ପ୍ରଥମେ "ଅନୁରୋଧ" ପୃଷ୍ଠାରେ ସେମାନଙ୍କ ଅନୁରୋଧ ଗ୍ରହଣ କରନ୍ତୁ।';
	@override String get requestSentWait => 'ଅନୁରୋଧ ପଠାଯାଇଛି। ସେମାନେ ଗ୍ରହଣ କରିବା ପର୍ଯ୍ୟନ୍ତ ଅପେକ୍ଷା କରନ୍ତୁ।';
	@override String get requestSentTheyWillSee => 'ଅନୁରୋଧ ପଠାଯାଇଛି। ସେମାନେ "ଅନୁରୋଧ" ଭିତରେ ଦେଖିବେ।';
	@override String failedToShare({required Object error}) => 'ସେୟାର୍ କରିବାରେ ବିଫଳ: ${error}';
	@override String get updateCaptionHint => 'ଆପଣଙ୍କ ପୋଷ୍ଟ ପାଇଁ କ୍ୟାପ୍ସନ୍ ଅଦ୍ୟତନ କରନ୍ତୁ';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroOr extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'ଅନ୍ବେଷଣ ପାଇଁ ଟ୍ୟାପ୍ କରନ୍ତୁ';
	@override late final _TranslationsHomeScreenHeroStoryOr story = _TranslationsHomeScreenHeroStoryOr._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionOr companion = _TranslationsHomeScreenHeroCompanionOr._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageOr heritage = _TranslationsHomeScreenHeroHeritageOr._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityOr community = _TranslationsHomeScreenHeroCommunityOr._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesOr messages = _TranslationsHomeScreenHeroMessagesOr._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthOr extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get short => 'ଛୋଟ';
	@override String get medium => 'ମଧ୍ୟମ';
	@override String get long => 'ଦୀର୍ଘ';
	@override String get epic => 'ଆଳଙ୍କାରିକ';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatOr extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'ବର୍ଣ୍ଣନାତ୍ମକ';
	@override String get dialogue => 'ସଂଭାଷଣାଧାରିତ';
	@override String get poetic => 'କାବ୍ୟମୟ';
	@override String get scriptural => 'ଶାସ୍ତ୍ରୀୟ';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsOr extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'କୃଷ୍ଣଙ୍କ ଅର୍ଜୁନଙ୍କୁ ଶିଖାଇବା ବିଷୟରେ ଏକ କଥା କହନ୍ତୁ...';
	@override String get warriorRedemption => 'ପ୍ରାୟଶ୍ଚିତ୍ତ ଖୋଜୁଥିବା ଜଣେ ଯୋଧା ବିଷୟରେ ଏକ ମହାକାବ୍ୟ ଲେଖନ୍ତୁ...';
	@override String get sageWisdom => 'ଋଷିମାନଙ୍କ ଜ୍ଞାନ ବିଷୟରେ ଏକ କଥା ସୃଷ୍ଟି କରନ୍ତୁ...';
	@override String get devotedSeeker => 'ଏକ ଭକ୍ତ ଖୋଜାଳା ବ୍ୟକ୍ତିଙ୍କ ଯାତ୍ରା ବର୍ଣ୍ଣନା କରନ୍ତୁ...';
	@override String get divineIntervention => 'ଦୈବୀ ହସ୍ତକ୍ଷେପ ବିଷୟରେ ଗଳ୍ପଟି ସେୟାର୍ କରନ୍ତୁ...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsOr extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'ଦୟାକରି ସମସ୍ତ ଆବଶ୍ୟକ ବିକଳ୍ପ ପୂରଣ କରନ୍ତୁ';
	@override String get generationFailed => 'କଥା ସୃଷ୍ଟି ହେବାରେ ବିଫଳ। ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ।';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsOr extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  ନମସ୍କାର!';
	@override String get dharma => '📖  ଧର୍ମ କ\'ଣ?';
	@override String get stress => '🧘  ଚାପକୁ କେମିତି ସମ୍ଭାଳିବେ';
	@override String get karma => '⚡  କର୍ମକୁ ସହଜରେ ବୁଝାନ୍ତୁ';
	@override String get story => '💬  ମୋତେ ଗୋଟେ କାହାଣୀ କହନ୍ତୁ';
	@override String get wisdom => '🌟  ଆଜିର ଜ୍ଞାନ';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsOr extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

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
class _TranslationsMapDiscussionsOr extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'ଆଲୋଚନା ପୋଷ୍ଟ କରନ୍ତୁ';
	@override String get intentCardCta => 'ଗୋଟିଏ ଆଲୋଚନା ପୋଷ୍ଟ କରନ୍ତୁ';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapOr extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapOr extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapOr extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

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
class _TranslationsMapFoodMapOr extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

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
class _TranslationsFeedTabsOr extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get all => 'ସବୁ';
	@override String get stories => 'କଥାଗୁଡ଼ିକ';
	@override String get posts => 'ପୋଷ୍ଟଗୁଡ଼ିକ';
	@override String get videos => 'ଭିଡିଓଗୁଡ଼ିକ';
	@override String get images => 'ଫଟୋଗୁଡ଼ିକ';
	@override String get text => 'ଚିନ୍ତାଧାରା';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileOr extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ପ୍ରୋଫାଇଲ ସମ୍ପାଦନ କରନ୍ତୁ';
	@override String get displayName => 'ପ୍ରଦର୍ଶିତ ନାମ';
	@override String get displayNameHint => 'ଆପଣଙ୍କ ପ୍ରଦର୍ଶିତ ନାମ ଲେଖନ୍ତୁ';
	@override String get displayNameEmpty => 'ପ୍ରଦର୍ଶିତ ନାମ ଖାଲି ରହିପାରିବ ନାହିଁ';
	@override String get bio => 'ଜୀବନୀ';
	@override String get bioHint => 'ଆପଣ ନିଜ ବିଷୟରେ ଆମକୁ କହନ୍ତୁ...';
	@override String get changePhoto => 'ପ୍ରୋଫାଇଲ ଫଟୋ ପରିବର୍ତ୍ତନ କରନ୍ତୁ';
	@override String get saveChanges => 'ପରିବର୍ତ୍ତନଗୁଡ଼ିକୁ ସେଭ୍ କରନ୍ତୁ';
	@override String get profileUpdated => 'ପ୍ରୋଫାଇଲ ସଫଳତାର ସହିତ ଅଦ୍ୟତନ ହେଲା';
	@override String get profileAndPhotoUpdated => 'ପ୍ରୋଫାଇଲ ଏବଂ ଫଟୋ ସଫଳତାର ସହିତ ଅଦ୍ୟତନ ହେଲା';
	@override String failedPickImage({required Object error}) => 'ଛବି ବାଛିବାରେ ବିଫଳ: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'ଫଟୋ ଅପ୍ଲୋଡ୍ କରିବାରେ ବିଫଳ: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'ପ୍ରୋଫାଇଲ ଅଦ୍ୟତନ କରିବାରେ ବିଫଳ: ${error}';
	@override String unexpectedError({required Object error}) => 'ଅପ୍ରତ୍ୟାଶିତ ତ୍ରୁଟି: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostOr extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ପୋଷ୍ଟ ସୃଷ୍ଟି କରନ୍ତୁ';
	@override String get post => 'ପୋଷ୍ଟ କରନ୍ତୁ';
	@override String get text => 'ପାଠ୍ୟ';
	@override String get image => 'ଛବି';
	@override String get video => 'ଭିଡିଓ';
	@override String get textHint => 'ଆପଣଙ୍କ ମନରେ କଣ ଅଛି?';
	@override String get imageCaptionHint => 'ଆପଣଙ୍କ ଛବି ପାଇଁ ଏକ କ୍ୟାପ୍ସନ୍ ଲେଖନ୍ତୁ...';
	@override String get videoCaptionHint => 'ଆପଣଙ୍କ ଭିଡିଓର ବର୍ଣ୍ଣନା କରନ୍ତୁ...';
	@override String get shareCaptionHint => 'ଆପଣଙ୍କ ଚିନ୍ତାଗୁଡ଼ିକୁ ଯୋଡ଼ନ୍ତୁ...';
	@override String get titleHint => 'ଗୋଟିଏ ଶିରୋନାମା ଯୋଡ଼ନ୍ତୁ (ଇଚ୍ଛାନୁସାରେ)';
	@override String get selectVideo => 'ଭିଡିଓ ବାଛନ୍ତୁ';
	@override String get gallery => 'ଗ୍ୟାଲେରୀ';
	@override String get camera => 'କ୍ୟାମେରା';
	@override String get visibility => 'ଏହାକୁ କେଉଁମାନେ ଦେଖିବେ?';
	@override String get public => 'ସାର୍ବଜନୀନ';
	@override String get followers => 'ଅନୁସରଣକାରୀ';
	@override String get private => 'ନିଜସ୍ୱ';
	@override String get postCreated => 'ପୋଷ୍ଟ ସୃଷ୍ଟି ହୋଇଗଲା!';
	@override String get failedPickImages => 'ଛବି ବାଛିବାରେ ବିଫଳ';
	@override String get failedPickVideo => 'ଭିଡିଓ ବାଛିବାରେ ବିଫଳ';
	@override String get failedCapturePhoto => 'ଫଟୋ ଧରିବାରେ ବିଫଳ';
	@override String get cannotCreateOffline => 'ଅଫ୍ଲାଇନ୍ ଅବସ୍ଥାରେ ପୋଷ୍ଟ ସୃଷ୍ଟି କରିପାରିବେ ନାହିଁ';
	@override String get discardTitle => 'ପୋଷ୍ଟ ବିଲୋପ କରିବେ କି?';
	@override String get discardMessage => 'କିଛି ପରିବର୍ତ୍ତନ ସଞ୍ଚିତ ହୋଇନାହିଁ। ଆପଣ ନିଶ୍ଚିତ କି ଏହି ପୋଷ୍ଟକୁ ବିଲୋପ କରିବାକୁ ଚାହୁଁଛନ୍ତି?';
	@override String get keepEditing => 'ସମ୍ପାଦନା ଜାରି ରଖନ୍ତୁ';
	@override String get discard => 'ବିଲୋପ କରନ୍ତୁ';
	@override String get cropPhoto => 'ଛବି କ୍ରପ୍ କରନ୍ତୁ';
	@override String get trimVideo => 'ଭିଡିଓ କଟ କରନ୍ତୁ';
	@override String get editPhoto => 'ଛବି ସମ୍ପାଦନ କରନ୍ତୁ';
	@override String get editVideo => 'ଭିଡିଓ ସମ୍ପାଦନ କରନ୍ତୁ';
	@override String get maxDuration => 'ସର୍ବାଧିକ 30 ସେକେଣ୍ଡ';
	@override String get aspectSquare => 'ଚତୁର୍ଭୁଜ';
	@override String get aspectPortrait => 'ଉର୍ଦ୍ଧ୍ୱାଧର';
	@override String get aspectLandscape => 'ଆନୁଲମ୍ବିକ';
	@override String get aspectFree => 'ସ୍ୱତନ୍ତ୍ର ଫର୍ମାଟ୍';
	@override String get failedCrop => 'ଛବି କ୍ରପ୍ କରିବାରେ ବିଫଳ';
	@override String get failedTrim => 'ଭିଡିଓ କଟ କରିବାରେ ବିଫଳ';
	@override String get trimmingVideo => 'ଭିଡିଓ କଟ ହେଉଛି...';
	@override String trimVideoSubtitle({required Object max}) => 'ସର୍ବାଧିକ ${max}ସେ · ଆପଣଙ୍କ ଭଲ ଅଂଶ ବାଛନ୍ତୁ';
	@override String get trimVideoInstructionsTitle => 'ଆପଣଙ୍କ କ୍ଲିପ୍ ଟ୍ରିମ୍ କରନ୍ତୁ';
	@override String get trimVideoInstructionsBody => 'ଆରମ୍ଭ ଓ ଶେଷ ହ୍ୟାଣ୍ଡଲ୍ ଟାଣି 30 ସେକେଣ୍ଡ ପର୍ଯ୍ୟନ୍ତ ଅଂଶ ବାଛନ୍ତୁ।';
	@override String get trimStart => 'ଆରମ୍ଭ';
	@override String get trimEnd => 'ଶେଷ';
	@override String get trimSelectionEmpty => 'ଆଗକୁ ବଢ଼ିବାକୁ ବୈଧ ରେଞ୍ଜ ବାଛନ୍ତୁ';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}ସେ ବାଛାଗଲା (${start}–${end}) · ସର୍ବାଧିକ ${max}ସେ';
	@override String get coverFrame => 'କଭର୍ ଫ୍ରେମ୍';
	@override String get coverFrameUnavailable => 'ପ୍ରିଭ୍ୟୁ ନାହିଁ';
	@override String coverFramePosition({required Object time}) => '${time} ରେ କଭର୍';
	@override String get overlayLabel => 'ଭିଡିଓ ଉପରେ ଟେକ୍ସ୍ଟ (ଇଚ୍ଛାନୁସାରେ)';
	@override String get overlayHint => 'ଛୋଟ ହୁକ୍ କିମ୍ବା ଶିରୋନାମା ଯୋଡନ୍ତୁ';
	@override String get imageSectionHint => 'ଗ୍ୟାଲେରୀ କିମ୍ବା କ୍ୟାମେରାରୁ ସର୍ବାଧିକ 10ଟି ଛବି ଯୋଡ଼ନ୍ତୁ';
	@override String get videoSectionHint => 'ଗୋଟିଏ ଭିଡିଓ, ସର୍ବାଧିକ 30 ସେକେଣ୍ଡ';
	@override String get removePhoto => 'ଛବି ବିଲୋପ କରନ୍ତୁ';
	@override String get removeVideo => 'ଭିଡିଓ ବିଲୋପ କରନ୍ତୁ';
	@override String get photoEditHint => 'ଛବି କ୍ରପ୍ କିମ୍ବା ବିଲୋପ କରିବାକୁ ଟାପ୍ କରନ୍ତୁ';
	@override String get videoEditOptions => 'ସମ୍ପାଦନ ବିକଳ୍ପ';
	@override String get addPhoto => 'ଛବି ଯୋଡ଼ନ୍ତୁ';
	@override String get done => 'ହୋଇଗଲା';
	@override String get rotate => 'ଘୁଞ୍ଚାନ୍ତୁ';
	@override String get editPhotoSubtitle => 'ଫିଡ୍‌ରେ ଭଲ ଦେଖାବା ପାଇଁ ଚତୁର୍ଭୁଜ ରେ କ୍ରପ୍ କରନ୍ତୁ';
	@override String get videoEditorCaptionLabel => 'କ୍ୟାପ୍ସନ / ଟେକ୍ସଟ (ଇଚ୍ଛାଧୀନ)';
	@override String get videoEditorCaptionHint => 'ଉଦାହରଣ: ଆପଣଙ୍କ ରିଲ୍ ପାଇଁ ଶିରୋନାମ କିମ୍ବା ହୁକ୍';
	@override String get videoEditorAspectLabel => 'ଅନୁପାତ';
	@override String get videoEditorAspectOriginal => 'ମୂଳ';
	@override String get videoEditorAspectSquare => '୧:୧';
	@override String get videoEditorAspectPortrait => '୯:୧୬';
	@override String get videoEditorAspectLandscape => '୧୬:୯';
	@override String get videoEditorQuickTrim => 'ଦ୍ରୁତ ଟ୍ରିମ୍';
	@override String get videoEditorSpeed => 'ଗତି';
}

// Path: social.comments
class _TranslationsSocialCommentsOr extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} ଙ୍କୁ ଉତ୍ତର ଦେଉଛନ୍ତି';
	@override String replyHint({required Object name}) => '${name} ଙ୍କୁ ଉତ୍ତର ଲେଖନ୍ତୁ...';
	@override String failedToPost({required Object error}) => 'ମନ୍ତବ୍ୟ ପୋଷ୍ଟ କରିବାରେ ବିଫଳ: ${error}';
	@override String get cannotPostOffline => 'ଅଫ୍ଲାଇନ୍ ଅବସ୍ଥାରେ ମନ୍ତବ୍ୟ ପୋଷ୍ଟ କରିପାରିବେ ନାହିଁ';
	@override String get noComments => 'ଏଯାଏ ପର୍ଯ୍ୟନ୍ତ କୌଣସି ମନ୍ତବ୍ୟ ନାହିଁ';
	@override String get beFirst => 'ପ୍ରଥମେ ମନ୍ତବ୍ୟ କରନ୍ତୁ!';
}

// Path: social.engagement
class _TranslationsSocialEngagementOr extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'ଅଫ୍ଲାଇନ୍ ମୋଡ୍';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryOr extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ଏଆଇ କାହାଣୀ ସୃଷ୍ଟି';
	@override String get headline => 'ମନମୁଗ୍ଧକର\nକାହାଣୀ\nତିଆରି କରନ୍ତୁ';
	@override String get subHeadline => 'ପ୍ରାଚୀନ ଜ୍ଞାନରେ ପ୍ରେରିତ';
	@override String get line1 => '✦  ଗୋଟିଏ ପବିତ୍ର ଶାସ୍ତ୍ର ବାଛନ୍ତୁ...';
	@override String get line2 => '✦  ଜୀବନ୍ତ ପରିବେଶ ବାଛନ୍ତୁ...';
	@override String get line3 => '✦  ଏଆଇକୁ ମନୋହର କାହାଣୀ ବୁନିବାକୁ ଦିଅନ୍ତୁ...';
	@override String get cta => 'କାହାଣୀ ତିଆରି କରନ୍ତୁ';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionOr extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ଆଧ୍ୟାତ୍ମିକ ସାଥୀ';
	@override String get headline => 'ଆପଣଙ୍କ ଦିବ୍ୟ\nମାର୍ଗଦର୍ଶକ,\nସଦା ସମୀପରେ';
	@override String get subHeadline => 'କୃଷ୍ଣଙ୍କ ଜ୍ଞାନରୁ ପ୍ରେରିତ';
	@override String get line1 => '✦  ସତରେ ଶୁଣୁଥିବା ମିତ୍ର...';
	@override String get line2 => '✦  ଜୀବନ ସଂଘର୍ଷ ପାଇଁ ଜ୍ଞାନ...';
	@override String get line3 => '✦  ଆପଣଙ୍କୁ ଉତ୍ସାହିତ କରୁଥିବା ଆଲୋଚନା...';
	@override String get cta => 'ଚାଟ୍ ଆରମ୍ଭ କରନ୍ତୁ';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageOr extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ଐତିହ୍ୟ ମାନଚିତ୍ର';
	@override String get headline => 'ଚିରନ୍ତନ\nଐତିହ୍ୟ\nଆବିଷ୍କାର କରନ୍ତୁ';
	@override String get subHeadline => '5000+ ପବିତ୍ର ସ୍ଥଳ ମାନଚିତ୍ରିତ';
	@override String get line1 => '✦  ପବିତ୍ର ସ୍ଥାନ ଅନ୍ବେଷଣ କରନ୍ତୁ...';
	@override String get line2 => '✦  ଇତିହାସ ଓ ଲୋକକଥା ପଢନ୍ତୁ...';
	@override String get line3 => '✦  ଅର୍ଥପୂର୍ଣ୍ଣ ଯାତ୍ରା ଯୋଜନା କରନ୍ତୁ...';
	@override String get cta => 'ମାନଚିତ୍ର ଦେଖନ୍ତୁ';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityOr extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ସମୁଦାୟ ସ୍ପେସ୍';
	@override String get headline => 'ସଂସ୍କୃତିକୁ\nବିଶ୍ୱ ସହିତ\nଭାଗ କରନ୍ତୁ';
	@override String get subHeadline => 'ସଜୀବ ବିଶ୍ୱ ସମୁଦାୟ';
	@override String get line1 => '✦  ପୋଷ୍ଟ ଓ ଗଭୀର ଆଲୋଚନା...';
	@override String get line2 => '✦  ଛୋଟ ସାଂସ୍କୃତିକ ଭିଡିଓ...';
	@override String get line3 => '✦  ସାରା ବିଶ୍ୱର କାହାଣୀ...';
	@override String get cta => 'ସମୁଦାୟରେ ଯୋଗଦିଅନ୍ତୁ';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesOr extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesOr._(TranslationsOr root) : this._root = root, super.internal(root);

	final TranslationsOr _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ବ୍ୟକ୍ତିଗତ ବାର୍ତ୍ତା';
	@override String get headline => 'ଅର୍ଥପୂର୍ଣ୍ଣ\nଆଲୋଚନା\nଏଠାରୁ ଆରମ୍ଭ';
	@override String get subHeadline => 'ବ୍ୟକ୍ତିଗତ ଓ ଚିନ୍ତନଶୀଳ ସ୍ଥାନ';
	@override String get line1 => '✦  ସମମନସ୍କ ଲୋକଙ୍କ ସହିତ ଯୁକ୍ତ ହୁଅନ୍ତୁ...';
	@override String get line2 => '✦  ଭାବନା ଓ କାହାଣୀ ଉପରେ ଆଲୋଚନା କରନ୍ତୁ...';
	@override String get line3 => '✦  ଚିନ୍ତନଶୀଳ ସମୁଦାୟ ଗଢନ୍ତୁ...';
	@override String get cta => 'ବାର୍ତ୍ତା ଖୋଲନ୍ତୁ';
}
