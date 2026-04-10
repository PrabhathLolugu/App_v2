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
class TranslationsMl extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsMl({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ml,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <ml>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsMl _root = this; // ignore: unused_field

	@override 
	TranslationsMl $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsMl(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppMl app = _TranslationsAppMl._(_root);
	@override late final _TranslationsCommonMl common = _TranslationsCommonMl._(_root);
	@override late final _TranslationsNavigationMl navigation = _TranslationsNavigationMl._(_root);
	@override late final _TranslationsHomeMl home = _TranslationsHomeMl._(_root);
	@override late final _TranslationsHomeScreenMl homeScreen = _TranslationsHomeScreenMl._(_root);
	@override late final _TranslationsStoriesMl stories = _TranslationsStoriesMl._(_root);
	@override late final _TranslationsStoryGeneratorMl storyGenerator = _TranslationsStoryGeneratorMl._(_root);
	@override late final _TranslationsChatMl chat = _TranslationsChatMl._(_root);
	@override late final _TranslationsMapMl map = _TranslationsMapMl._(_root);
	@override late final _TranslationsCommunityMl community = _TranslationsCommunityMl._(_root);
	@override late final _TranslationsDiscoverMl discover = _TranslationsDiscoverMl._(_root);
	@override late final _TranslationsPlanMl plan = _TranslationsPlanMl._(_root);
	@override late final _TranslationsSettingsMl settings = _TranslationsSettingsMl._(_root);
	@override late final _TranslationsAuthMl auth = _TranslationsAuthMl._(_root);
	@override late final _TranslationsErrorMl error = _TranslationsErrorMl._(_root);
	@override late final _TranslationsSubscriptionMl subscription = _TranslationsSubscriptionMl._(_root);
	@override late final _TranslationsNotificationMl notification = _TranslationsNotificationMl._(_root);
	@override late final _TranslationsProfileMl profile = _TranslationsProfileMl._(_root);
	@override late final _TranslationsFeedMl feed = _TranslationsFeedMl._(_root);
	@override late final _TranslationsVoiceMl voice = _TranslationsVoiceMl._(_root);
	@override late final _TranslationsFestivalsMl festivals = _TranslationsFestivalsMl._(_root);
	@override late final _TranslationsSocialMl social = _TranslationsSocialMl._(_root);
}

// Path: app
class _TranslationsAppMl extends TranslationsAppEn {
	_TranslationsAppMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get name => 'MyItihas';
	@override String get tagline => 'ഇന്ത്യൻ ശാസ്ത്രങ്ങൾ കണ്ടെത്തൂ';
}

// Path: common
class _TranslationsCommonMl extends TranslationsCommonEn {
	_TranslationsCommonMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get ok => 'ശരി';
	@override String get cancel => 'റദ്ദാക്കുക';
	@override String get confirm => 'സ്ഥിരീകരിക്കുക';
	@override String get delete => 'ഇല്ലാതാക്കുക';
	@override String get edit => 'തിരുത്തുക';
	@override String get save => 'സേവ് ചെയ്യുക';
	@override String get share => 'പങ്കിടുക';
	@override String get search => 'തിരയുക';
	@override String get loading => 'ലോഡാകുന്നു...';
	@override String get error => 'പിശക്';
	@override String get retry => 'വീണ്ടും ശ്രമിക്കുക';
	@override String get back => 'തിരികെ';
	@override String get next => 'അടുത്തത്';
	@override String get finish => 'പൂര്‍ത്തിയാക്കുക';
	@override String get skip => 'വിട്ടേക്കുക';
	@override String get yes => 'അതെ';
	@override String get no => 'ഇല്ല';
	@override String get readFullStory => 'പൂര്‍ണ കഥ വായിക്കുക';
	@override String get dismiss => 'അടയ്ക്കുക';
	@override String get offlineBannerMessage => 'നിങ്ങൾ ഓഫ്‌ലൈൻ ആണ് – കാഷ് ചെയ്ത ഉള്ളടക്കം കാണിക്കുന്നു';
	@override String get backOnline => 'വീണ്ടും ഓൺലൈൻ ആയി';
}

// Path: navigation
class _TranslationsNavigationMl extends TranslationsNavigationEn {
	_TranslationsNavigationMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get home => 'അന്വേഷണം';
	@override String get stories => 'കഥകൾ';
	@override String get chat => 'ചാറ്റ്';
	@override String get map => 'മാപ്പ്';
	@override String get community => 'സാമൂഹിക';
	@override String get settings => 'സെറ്റിങ്ങുകൾ';
	@override String get profile => 'പ്രൊഫൈൽ';
}

// Path: home
class _TranslationsHomeMl extends TranslationsHomeEn {
	_TranslationsHomeMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'MyItihas';
	@override String get storyGenerator => 'കഥ ജനറേറ്റർ';
	@override String get chatItihas => 'ChatItihas';
	@override String get communityStories => 'സമൂഹത്തിലെ കഥകൾ';
	@override String get maps => 'മാപ്പുകൾ';
	@override String get greetingMorning => 'ശുഭോദയം';
	@override String get continueReading => 'വായനം തുടരുക';
	@override String get greetingAfternoon => 'ശുഭ മധ്യാഹ്നം';
	@override String get greetingEvening => 'ശുഭ സായാഹ്നം';
	@override String get greetingNight => 'ശുഭ രാത്രി';
	@override String get exploreStories => 'കഥകൾ അന്വേഷിക്കുക';
	@override String get generateStory => 'കഥ സൃഷ്ടിക്കുക';
	@override String get content => 'ഹോം ഉള്ളടക്കം';
}

// Path: homeScreen
class _TranslationsHomeScreenMl extends TranslationsHomeScreenEn {
	_TranslationsHomeScreenMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'നമസ്കാരം';
	@override String get quoteOfTheDay => 'ഇന്നത്തെ ചിന്ത';
	@override String get shareQuote => 'ചിന്ത ഷെയർ ചെയ്യുക';
	@override String get copyQuote => 'ചിന്ത കോപ്പി ചെയ്യുക';
	@override String get quoteCopied => 'ചിന്ത ക്ലിപ്പ്ബോർഡിലേക്ക് കോപ്പി ചെയ്തു';
	@override String get featuredStories => 'പ്രമുഖ കഥകൾ';
	@override String get quickActions => 'പെട്ടെന്നുള്ള പ്രവർത്തനങ്ങൾ';
	@override String get generateStory => 'കഥ സൃഷ്ടിക്കുക';
	@override String get chatWithKrishna => 'കൃഷ്ണനോടൊപ്പം സംസാരിക്കുക';
	@override String get myActivity => 'എന്റെ പ്രവർത്തനം';
	@override String get continueReading => 'വായനം തുടരുക';
	@override String get savedStories => 'സേവ് ചെയ്ത കഥകൾ';
	@override String get exploreMyitihas => 'മൈഇതിഹാസ് അന്വേഷിക്കുക';
	@override String get storiesInYourLanguage => 'നിങ്ങളുടെ ഭാഷയിലെ കഥകൾ';
	@override String get seeAll => 'എല്ലാം കാണുക';
	@override String get startReading => 'വായിക്കാൻ തുടങ്ങുക';
	@override String get exploreStories => 'നിങ്ങളുടെ യാത്ര ആരംഭിക്കാൻ കഥകൾ അന്വേഷിക്കുക';
	@override String get saveForLater => 'ഇഷ്ടപ്പെട്ട കഥകൾ ബുക്ക്‌മാർക്ക് ചെയ്യുക';
	@override String get noActivityYet => 'ഇനിയും പ്രവർത്തനം ഒന്നുമില്ല';
	@override String minLeft({required Object count}) => '${count} മിനിറ്റ് ബാക്കി';
	@override String get activityHistory => 'പ്രവർത്തന ചരിത്രം';
	@override String get storyGenerated => 'ഒരു കഥ സൃഷ്ടിച്ചു';
	@override String get storyRead => 'ഒരു കഥ വായിച്ചു';
	@override String get storyBookmarked => 'കഥ ബുക്ക്‌മാർക്ക് ചെയ്തു';
	@override String get storyShared => 'കഥ ഷെയർ ചെയ്തു';
	@override String get storyCompleted => 'കഥ പൂർത്തിയാക്കി';
	@override String get today => 'ഇന്ന്';
	@override String get yesterday => 'ഇന്നലെ';
	@override String get thisWeek => 'ഈ ആഴ്ച';
	@override String get earlier => 'മുമ്പ്';
	@override String get noContinueReading => 'ഇപ്പോൾ വായിക്കാൻ ഒന്നുമില്ല';
	@override String get noSavedStories => 'ഇനിയും സേവ് ചെയ്ത കഥകളില്ല';
	@override String get bookmarkStoriesToSave => 'കഥകൾ സേവ് ചെയ്യാൻ ബുക്ക്‌മാർക്ക് ചെയ്യുക';
	@override String get myGeneratedStories => 'എന്റെ കഥകൾ';
	@override String get noGeneratedStoriesYet => 'ഇനിയും ഒരു കഥയും സൃഷ്ടിച്ചിട്ടില്ല';
	@override String get createYourFirstStory => 'AI ഉപയോഗിച്ച് നിങ്ങളുടെ ആദ്യ കഥ സൃഷ്ടിക്കുക';
	@override String get shareToFeed => 'ഫീഡിൽ പങ്കിടുക';
	@override String get sharedToFeed => 'കഥ ഫീഡിൽ പങ്കിട്ടു';
	@override String get shareStoryTitle => 'കഥ പങ്കിടുക';
	@override String get shareStoryMessage => 'നിങ്ങളുടെ കഥയ്ക്ക് ഒരു ക്യാപ്പ്ഷൻ ചേർക്കുക (ഐച്ഛികം)';
	@override String get shareStoryCaption => 'ക്യാപ്പ്ഷൻ';
	@override String get shareStoryHint => 'ഈ കഥയെ കുറിച്ച് നിങ്ങൾ എന്ത് പറയാൻ ആഗ്രഹിക്കുന്നു?';
	@override String get exploreHeritageTitle => 'പാരമ്പര്യം അന്വേഷിക്കുക';
	@override String get exploreHeritageDesc => 'മാപ്പിൽ സാംസ്കാരിക പൈതൃക കേന്ദ്രങ്ങൾ കണ്ടെത്തുക';
	@override String get whereToVisit => 'അടുത്ത സന്ദർശനം';
	@override String get scriptures => 'ശാസ്ത്രങ്ങൾ';
	@override String get exploreSacredSites => 'പവിത്രമായ സ്ഥലങ്ങൾ അന്വേഷിക്കുക';
	@override String get readStories => 'കഥകൾ വായിക്കുക';
	@override String get yesRemindMe => 'അതെ, എനിക്ക് ഓർമ്മിപ്പിക്കുക';
	@override String get noDontShowAgain => 'ഇല്ല, വീണ്ടും കാണിക്കേണ്ട';
	@override String get discoverDismissTitle => 'Discover MyItihas മറയ്ക്കണോ?';
	@override String get discoverDismissMessage => 'അടുത്ത തവണ ആപ്പ് തുറക്കുമ്പോഴോ ലോഗിൻ ചെയ്യുമ്പോഴോ ഇത് വീണ്ടും കാണണോ?';
	@override String get discoverCardTitle => 'MyItihas കാണുക';
	@override String get discoverCardSubtitle => 'പ്രാചീന ശാസ്ത്രങ്ങളിലേക്കുള്ള കഥകളും, സന്ദർശിക്കേണ്ട പവിത്രസ്ഥലങ്ങളും, നിങ്ങളുടെ കൈവശം ജ്ഞാനവും.';
	@override String get swipeToDismiss => 'അടയ്ക്കാൻ മുകളിലേക്ക് സ്വൈപ്പ് ചെയ്യുക';
	@override String get searchScriptures => 'ശാസ്ത്രങ്ങൾ തിരയുക...';
	@override String get searchLanguages => 'ഭാഷകൾ തിരയുക...';
	@override String get exploreStoriesLabel => 'കഥകൾ അന്വേഷിക്കുക';
	@override String get exploreMore => 'കൂടുതൽ കാണുക';
	@override String get failedToLoadActivity => 'പ്രവർത്തനം ലോഡ് ചെയ്യുന്നതിൽ പിശക് സംഭവിച്ചു';
	@override String get startReadingOrGenerating => 'ഇവിടെ നിങ്ങളുടെ പ്രവർത്തനം കാണാൻ കഥകൾ വായിക്കുകയോ സൃഷ്ടിക്കുകയോ ചെയ്യുക';
	@override late final _TranslationsHomeScreenHeroMl hero = _TranslationsHomeScreenHeroMl._(_root);
}

// Path: stories
class _TranslationsStoriesMl extends TranslationsStoriesEn {
	_TranslationsStoriesMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'കഥകൾ';
	@override String get searchHint => 'തലക്കെട്ട് അല്ലെങ്കിൽ എഴുത്തുകാരൻ ഉപയോഗിച്ച് തിരയുക...';
	@override String get sortBy => 'ക്രമത്തിൽ അടുപ്പിക്കുക';
	@override String get sortNewest => 'പുതിയത് ആദ്യം';
	@override String get sortOldest => 'പഴയത് ആദ്യം';
	@override String get sortPopular => 'ഏറ്റവും ജനപ്രിയം';
	@override String get noStories => 'ഒരു കഥയും കണ്ടെത്തിയില്ല';
	@override String get loadingStories => 'കഥകൾ ലോഡ് ചെയ്യുന്നു...';
	@override String get errorLoadingStories => 'കഥകൾ ലോഡ് ചെയ്യുന്നതിൽ പിശക് സംഭവിച്ചു';
	@override String get storyDetails => 'കഥയുടെ വിശദാംശങ്ങൾ';
	@override String get continueReading => 'വായനം തുടരുക';
	@override String get readMore => 'കൂടുതൽ വായിക്കുക';
	@override String get readLess => 'കുറച്ച് മാത്രം കാണിക്കുക';
	@override String get author => 'എഴുത്തുകാരൻ';
	@override String get publishedOn => 'പ്രസിദ്ധീകരിച്ച തീയതി';
	@override String get category => 'വിഭാഗം';
	@override String get tags => 'ടാഗുകൾ';
	@override String get failedToLoad => 'കഥ ലോഡ് ചെയ്യുന്നതിൽ പിശക് സംഭവിച്ചു';
	@override String get subtitle => 'ശാസ്ത്രങ്ങളിലെ കഥകൾ കണ്ടെത്തൂ';
	@override String get noStoriesHint => 'മറ്റൊരു തിരയൽ അല്ലെങ്കിൽ ഫിൽട്ടർ പരീക്ഷിച്ച് കഥകൾ കണ്ടെത്തൂ.';
	@override String get featured => 'പ്രധാന';
}

// Path: storyGenerator
class _TranslationsStoryGeneratorMl extends TranslationsStoryGeneratorEn {
	_TranslationsStoryGeneratorMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'കഥ ജനറേറ്റർ';
	@override String get subtitle => 'നിങ്ങളുടെ സ്വന്തം ശാസ്ത്രീയ കഥ സൃഷ്ടിക്കുക';
	@override String get quickStart => 'ദ്രുതാരംഭം';
	@override String get interactive => 'ഇന്ററാക്റ്റീവ്';
	@override String get rawPrompt => 'റോ പ്രോംപ്റ്റ്';
	@override String get yourStoryPrompt => 'നിങ്ങളുടെ കഥയുടെ പ്രോംപ്റ്റ്';
	@override String get writeYourPrompt => 'നിങ്ങളുടെ പ്രോംപ്റ്റ് എഴുതുക';
	@override String get selectScripture => 'ശാസ്ത്രം തിരഞ്ഞെടുക്കുക';
	@override String get selectStoryType => 'കഥയുടെ തരം തിരഞ്ഞെടുക്കുക';
	@override String get selectCharacter => 'കഥാപാത്രം തിരഞ്ഞെടുക്കുക';
	@override String get selectTheme => 'വിഷയം തിരഞ്ഞെടുക്കുക';
	@override String get selectSetting => 'സന്ദർഭം/സ്ഥലം തിരഞ്ഞെടുക്കുക';
	@override String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';
	@override String get selectLength => 'കഥയുടെ ദൈർഘ്യം';
	@override String get moreOptions => 'കൂടുതൽ ഓപ്ഷനുകൾ';
	@override String get random => 'യാദൃശ്ചികം';
	@override String get generate => 'കഥ സൃഷ്ടിക്കുക';
	@override String get generating => 'നിങ്ങളുടെ കഥ സൃഷ്ടിക്കുന്നു...';
	@override String get creatingYourStory => 'നിങ്ങളുടെ കഥ രൂപപ്പെടുത്തുന്നു';
	@override String get consultingScriptures => 'പ്രാചീന ശാസ്ത്രങ്ങളുമായി ആശയവിനിമയം നടത്തുന്നു...';
	@override String get weavingTale => 'നിങ്ങളുടെ കഥ നെയ്ത് രൂപപ്പെടുത്തുന്നു...';
	@override String get addingWisdom => 'ദൈവീക ജ്ഞാനം ചേർക്കുന്നു...';
	@override String get polishingNarrative => 'കഥയെ കൂടുതൽ മനോഹരമാക്കുന്നു...';
	@override String get almostThere => 'കുറച്ച് മാത്രം ബാക്കി...';
	@override String get generatedStory => 'നിങ്ങളുടെ സൃഷ്ടിച്ച കഥ';
	@override String get aiGenerated => 'AI ഉപയോഗിച്ച് സൃഷ്ടിച്ചത്';
	@override String get regenerate => 'വീണ്ടും സൃഷ്ടിക്കുക';
	@override String get saveStory => 'കഥ സേവ് ചെയ്യുക';
	@override String get shareStory => 'കഥ പങ്കിടുക';
	@override String get newStory => 'പുതിയ കഥ';
	@override String get saved => 'സേവ് ചെയ്തു';
	@override String get storySaved => 'കഥ നിങ്ങളുടെ ലൈബ്രറിയിൽ സേവ് ചെയ്തു';
	@override String get story => 'കഥ';
	@override String get lesson => 'പാഠം';
	@override String get didYouKnow => 'നിങ്ങൾക്കറിയാമോ?';
	@override String get activity => 'പ്രവർത്തനം';
	@override String get optionalRefine => 'ഐച്ഛികം: ഓപ്ഷനുകളിലൂടെ കൂടുതൽ നയമാക്കുക';
	@override String get applyOptions => 'ഓപ്ഷനുകൾ ഉപയോഗിക്കുക';
	@override String get language => 'ഭാഷ';
	@override String get storyFormat => 'കഥയുടെ ഫോർമാറ്റ്';
	@override String get requiresInternet => 'കഥ സൃഷ്ടിക്കാൻ ഇന്റർനെറ്റ് ആവശ്യമാണ്';
	@override String get notAvailableOffline => 'കഥ ഓഫ്‌ലൈൻ ലഭ്യമല്ല. കാണാൻ ഇന്റർനെറ്റിൽ കണക്റ്റ് ചെയ്യുക.';
	@override String get aiDisclaimer => 'AI ചിലപ്പോൾ പിശക് ചെയ്യാം. ഞങ്ങൾ നിരന്തരം മെച്ചപ്പെടുത്തുകയാണ്; നിങ്ങളുടെ അഭിപ്രായം വളരെ പ്രധാനമാണ്.';
	@override late final _TranslationsStoryGeneratorStoryLengthMl storyLength = _TranslationsStoryGeneratorStoryLengthMl._(_root);
	@override late final _TranslationsStoryGeneratorFormatMl format = _TranslationsStoryGeneratorFormatMl._(_root);
	@override late final _TranslationsStoryGeneratorHintsMl hints = _TranslationsStoryGeneratorHintsMl._(_root);
	@override late final _TranslationsStoryGeneratorErrorsMl errors = _TranslationsStoryGeneratorErrorsMl._(_root);
}

// Path: chat
class _TranslationsChatMl extends TranslationsChatEn {
	_TranslationsChatMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'ChatItihas';
	@override String get subtitle => 'ശാസ്ത്രങ്ങളെക്കുറിച്ച് AI-യുമായി സംവദിക്കുക';
	@override String get friendMode => 'സുഹൃത്ത് മോഡ്';
	@override String get philosophicalMode => 'ദാർശനിക മോഡ്';
	@override String get typeMessage => 'നിങ്ങളുടെ സന്ദേശം ടൈപ്പ് ചെയ്യുക...';
	@override String get send => 'അയക്കുക';
	@override String get newChat => 'പുതിയ ചാറ്റ്';
	@override String get chatsTab => 'ചാറ്റ്';
	@override String get groupsTab => 'ഗ്രൂപ്പുകൾ';
	@override String get chatHistory => 'ചാറ്റ് ചരിത്രം';
	@override String get clearChat => 'ചാറ്റ് മായ്ക്കുക';
	@override String get noMessages => 'ഇനിയും സന്ദേശങ്ങളൊന്നുമില്ല. ഒരു സംഭാഷണം തുടങ്ങൂ!';
	@override String get listPage => 'ചാറ്റ് ലിസ്റ്റ് പേജ്';
	@override String get forwardMessageTo => 'സന്ദേശം ഇതിലേക്ക് മുന്നോട്ട് അയക്കുക...';
	@override String get forwardMessage => 'സന്ദേശം ഫോർവേഡ് ചെയ്യുക';
	@override String get messageForwarded => 'സന്ദേശം ഫോർവേഡ് ചെയ്തു';
	@override String failedToForward({required Object error}) => 'സന്ദേശം ഫോർവേഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല: ${error}';
	@override String get searchChats => 'ചാറ്റുകൾ തിരയുക';
	@override String get noChatsFound => 'ഒരു ചാറ്റും കണ്ടെത്തിയില്ല';
	@override String get requests => 'അഭ്യർത്ഥനകൾ';
	@override String get messageRequests => 'സന്ദേശ അഭ്യർത്ഥനകൾ';
	@override String get groupRequests => 'ഗ്രൂപ്പ് അഭ്യർത്ഥനകൾ';
	@override String get requestSent => 'അഭ്യർത്ഥന അയച്ചു. അവർ "Requests" വിഭാഗത്തിൽ കാണും.';
	@override String get wantsToChat => 'ചാറ്റ് ചെയ്യാൻ ആഗ്രഹിക്കുന്നു';
	@override String addedYouTo({required Object name}) => '${name} നിങ്ങളെ ഗ്രൂപ്പിൽ ചേർത്തു';
	@override String get accept => 'സ്വീകരിക്കുക';
	@override String get noMessageRequests => 'സന്ദേശ അഭ്യർത്ഥനകളൊന്നുമില്ല';
	@override String get noGroupRequests => 'ഗ്രൂപ്പ് അഭ്യർത്ഥനകളൊന്നുമില്ല';
	@override String get invitesSent => 'ആമന്ത്രണങ്ങൾ അയച്ചു. അവർ അവ "Requests" വിഭാഗത്തിൽ കാണും.';
	@override String get cantMessageUser => 'ഈ ഉപയോക്താവിനെ നിങ്ങൾക്ക് സന്ദേശമയയ്‌ക്കാൻ കഴിയില്ല';
	@override String get deleteChat => 'ചാറ്റ് ഇല്ലാതാക്കുക';
	@override String get deleteChats => 'ചാറ്റുകൾ ഇല്ലാതാക്കുക';
	@override String get blockUser => 'ഉപയോക്താവിനെ ബ്ലോക്ക് ചെയ്യുക';
	@override String get reportUser => 'ഉപയോക്താവിനെ റിപ്പോർട്ട് ചെയ്യുക';
	@override String get markAsRead => 'വായിച്ചതായി അടയാളപ്പെടുത്തുക';
	@override String get markedAsRead => 'വായിച്ചതായി അടയാളപ്പെടുത്തി';
	@override String get deleteClearChat => 'ചാറ്റ് ഇല്ലാതാക്കുക / കളയുക';
	@override String get deleteConversation => 'സംഭാഷണം ഇല്ലാതാക്കുക';
	@override String get reasonRequired => 'കാരണം (ആവശ്യമാണ്)';
	@override String get submit => 'സമർപ്പിക്കുക';
	@override String get userReportedBlocked => 'ഉപയോക്താവിനെ റിപ്പോർട്ട് ചെയ്ത് ബ്ലോക്ക് ചെയ്തു.';
	@override String reportFailed({required Object error}) => 'റിപ്പോർട്ട് ചെയ്യാൻ കഴിഞ്ഞില്ല: ${error}';
	@override String get newGroup => 'പുതിയ ഗ്രൂപ്പ്';
	@override String get messageSomeoneDirectly => 'ആർക്കെങ്കിലും നേരിട്ട് ഒരു സന്ദേശം അയക്കുക';
	@override String get createGroupConversation => 'ഗ്രൂപ്പ് സംഭാഷണം സൃഷ്ടിക്കുക';
	@override String get noGroupsYet => 'ഇനിയും ഒരു ഗ്രൂപ്പുമില്ല';
	@override String get noChatsYet => 'ഇനിയും ഒരു ചാറ്റുമില്ല';
	@override String get tapToCreateGroup => 'ഗ്രൂപ്പ് സൃഷ്ടിക്കുകയോ ചേരുകയോ ചെയ്യാൻ + ഞെക്കുക';
	@override String get tapToStartConversation => 'പുതിയ സംഭാഷണം തുടങ്ങാൻ + ഞെക്കുക';
	@override String get conversationDeleted => 'സംഭാഷണം ഇല്ലാതാക്കി';
	@override String conversationsDeleted({required Object count}) => '${count} സംഭാഷണങ്ങൾ ഇല്ലാതാക്കി';
	@override String get searchConversations => 'സംഭാഷണങ്ങൾ തിരയുക...';
	@override String get connectToInternet => 'ദയവായി ഇന്റർനെറ്റുമായി ബന്ധപ്പെട്ടു വീണ്ടും ശ്രമിക്കുക.';
	@override String get littleKrishnaName => 'ചെറുകൃഷ്ണൻ';
	@override String get newConversation => 'പുതിയ സംഭാഷണം';
	@override String get noConversationsYet => 'ഇനിയും ഒരു സംഭാഷണവുമില്ല';
	@override String get confirmDeletion => 'ഇല്ലാതാക്കുന്നത് സ്ഥിരീകരിക്കുക';
	@override String deleteConversationConfirm({required Object title}) => 'നിങ്ങൾക്ക് ${title} എന്ന സംഭാഷണം തീർച്ചയായും ഇല്ലാതാക്കണമെന്നുണ്ടോ?';
	@override String get deleteFailed => 'സംഭാഷണം ഇല്ലാതാക്കാൻ സാധിച്ചില്ല';
	@override String get fullChatCopied => 'മുഴുവൻ ചാറ്റ് ക്ലിപ്പ്ബോർഡിലേക്ക് കോപ്പി ചെയ്തു!';
	@override String get connectionErrorFallback => 'ഇപ്പോൾ കണെക്ട് ചെയ്യാൻ ബുദ്ധിമുട്ട് നേരിടുന്നു. ദയവായി കുറച്ച് സമയത്തിന് ശേഷം വീണ്ടും ശ്രമിക്കുക.';
	@override String krishnaWelcomeWithName({required Object name}) => 'ഹേ ${name}. ഞാൻ നിങ്ങളുടെ സുഹൃത്ത് കൃഷ്ണനാണ്. ഇന്ന് എങ്ങനെയുണ്ട്?';
	@override String get krishnaWelcomeFriend => 'ഹേ പ്രിയ സുഹൃത്തേ. ഞാൻ നിങ്ങളുടെ സുഹൃത്ത് കൃഷ്ണനാണ്. ഇന്ന് എങ്ങനെയുണ്ട്?';
	@override String get copyYouLabel => 'നിങ്ങൾ';
	@override String get copyKrishnaLabel => 'കൃഷ്ണൻ';
	@override late final _TranslationsChatSuggestionsMl suggestions = _TranslationsChatSuggestionsMl._(_root);
	@override String get about => 'കുറിച്ച്';
	@override String get yourFriendlyCompanion => 'നിങ്ങളുടെ സൗഹൃദ കൂട്ടുകാരൻ';
	@override String get mentalHealthSupport => 'മാനസികാരോഗ്യ പിന്തുണ';
	@override String get mentalHealthSupportSubtitle => 'ചിന്തകൾ പങ്കുവെക്കാനും കേൾക്കപ്പെടുന്നുവെന്ന് അനുഭവവേദ്യമാകാനും ഒരു സുരക്ഷിതമായ ഇടം.';
	@override String get friendlyCompanion => 'സൗഹൃദ കൂട്ടുകാരൻ';
	@override String get friendlyCompanionSubtitle => 'എപ്പോഴും സംസാരിക്കാൻ, പ്രോത്സാഹിപ്പിക്കാൻ, ജ്ഞാനം പങ്കിടാൻ തയ്യാറാണ്.';
	@override String get storiesAndWisdom => 'കഥകളും ജ്ഞാനവും';
	@override String get storiesAndWisdomSubtitle => 'കാലാതീതമായ കഥകളിൽ നിന്നും പ്രായോഗിക ജ്ഞാനത്തിൽ നിന്നും പഠിക്കുക.';
	@override String get askAnything => 'ഏതും ചോദിക്കൂ';
	@override String get askAnythingSubtitle => 'നിങ്ങളുടെ ചോദ്യങ്ങൾക്ക് സ്നേഹപൂർവ്വമായ, ആലോചനാപൂർവ്വമായ ഉത്തരങ്ങൾ നേടുക.';
	@override String get startChatting => 'ചാറ്റ് തുടങ്ങുക';
	@override String get maybeLater => 'പിന്നീട് നോക്കാം';
	@override late final _TranslationsChatComposerAttachmentsMl composerAttachments = _TranslationsChatComposerAttachmentsMl._(_root);
}

// Path: map
class _TranslationsMapMl extends TranslationsMapEn {
	_TranslationsMapMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'അഖണ്ഡ ഭാരതം';
	@override String get subtitle => 'ചരിത്രപ്രധാനമായ സ്ഥലങ്ങൾ അന്വേഷിക്കുക';
	@override String get searchLocation => 'സ്ഥലം തിരയുക...';
	@override String get viewDetails => 'വിശദാംശങ്ങൾ കാണുക';
	@override String get viewSites => 'സ്ഥലങ്ങൾ കാണുക';
	@override String get showRoute => 'റൂട്ടു കാണിക്കുക';
	@override String get historicalInfo => 'ചരിത്ര വിവരം';
	@override String get nearbyPlaces => 'സമീപസ്ഥലങ്ങൾ';
	@override String get pickLocationOnMap => 'മാപ്പിൽ സ്ഥലം തിരഞ്ഞെടുക്കുക';
	@override String get sitesVisited => 'സന്ദർശിച്ച സ്ഥലങ്ങൾ';
	@override String get badgesEarned => 'നേടിയ ബാഡ്ജുകൾ';
	@override String get completionRate => 'പൂർത്തീകരണ നിരക്ക്';
	@override String get addToJourney => 'യാത്രയിൽ ചേർക്കുക';
	@override String get addedToJourney => 'യാത്രയിൽ ചേർത്തിരിക്കുന്നു';
	@override String get getDirections => 'ദിശകൾ കണ്ടെത്തുക';
	@override String get viewInMap => 'മാപ്പിൽ കാണുക';
	@override String get directions => 'ദിശകൾ';
	@override String get photoGallery => 'ഫോട്ടോ ഗാലറി';
	@override String get viewAll => 'എല്ലാം കാണുക';
	@override String get photoSavedToGallery => 'ഫോട്ടോ ഗാലറിയിൽ സേവ് ചെയ്തു';
	@override String get sacredSoundscape => 'പവിത്ര ശബ്ദലോകം';
	@override String get allDiscussions => 'എല്ലാ ചര്‍ച്ചകളും';
	@override String get journeyTab => 'യാത്ര';
	@override String get discussionTab => 'ചർച്ച';
	@override String get myActivity => 'എന്റെ പ്രവർത്തനം';
	@override String get anonymousPilgrim => 'പേരറിയാത്ത തീർത്ഥാടനം ചെയ്യുന്നയാൾ';
	@override String get viewProfile => 'പ്രൊഫൈൽ കാണുക';
	@override String get discussionTitleHint => 'ചർച്ചയുടെ തലക്കെട്ട്...';
	@override String get shareYourThoughtsHint => 'നിങ്ങളുടെ ചിന്തകൾ പങ്കിടുക...';
	@override String get pleaseEnterDiscussionTitle => 'ദയവായി ചർച്ചയുടെ തലക്കെട്ട് നൽകുക';
	@override String get addReflection => 'അനുഭവം ചേർക്കുക';
	@override String get reflectionTitle => 'തലക്കെട്ട്';
	@override String get enterReflectionTitle => 'അനുഭവത്തിന്റെ തലക്കെട്ട് നൽകുക';
	@override String get pleaseEnterTitle => 'ദയവായി തലക്കെട്ട് നൽകുക';
	@override String get siteName => 'സ്ഥലത്തിന്റെ പേര്';
	@override String get enterSacredSiteName => 'പവിത്രമായ സ്ഥലത്തിന്റെ പേര് നൽകുക';
	@override String get pleaseEnterSiteName => 'ദയവായി സ്ഥലത്തിന്റെ പേര് നൽകുക';
	@override String get reflection => 'അനുഭവം';
	@override String get reflectionHint => 'നിങ്ങളുടെ അനുഭവങ്ങളും ചിന്തകളും പങ്കിടുക...';
	@override String get pleaseEnterReflection => 'ദയവായി നിങ്ങളുടെ അനുഭവം നൽകുക';
	@override String get saveReflection => 'അനുഭവം സേവ് ചെയ്യുക';
	@override String get journeyProgress => 'യാത്രയുടെ പുരോഗതി';
	@override late final _TranslationsMapDiscussionsMl discussions = _TranslationsMapDiscussionsMl._(_root);
	@override late final _TranslationsMapFabricMapMl fabricMap = _TranslationsMapFabricMapMl._(_root);
	@override late final _TranslationsMapClassicalArtMapMl classicalArtMap = _TranslationsMapClassicalArtMapMl._(_root);
	@override late final _TranslationsMapClassicalDanceMapMl classicalDanceMap = _TranslationsMapClassicalDanceMapMl._(_root);
	@override late final _TranslationsMapFoodMapMl foodMap = _TranslationsMapFoodMapMl._(_root);
}

// Path: community
class _TranslationsCommunityMl extends TranslationsCommunityEn {
	_TranslationsCommunityMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'സമൂഹം';
	@override String get trending => 'ട്രെൻഡിംഗ്';
	@override String get following => 'ഫോളോ ചെയ്യുന്നു';
	@override String get followers => 'ഫോളോവേഴ്സ്';
	@override String get posts => 'പോസ്റ്റുകൾ';
	@override String get follow => 'ഫോളോ ചെയ്യുക';
	@override String get unfollow => 'ഫോളോ ഒഴിവാക്കുക';
	@override String get shareYourStory => 'നിങ്ങളുടെ കഥ പങ്കിടൂ...';
	@override String get post => 'പോസ്റ്റ് ചെയ്യുക';
	@override String get like => 'ഇഷ്ടപ്പെട്ടു';
	@override String get comment => 'കമന്റ്';
	@override String get comments => 'കമന്റുകൾ';
	@override String get noPostsYet => 'ഇനിയും പോസ്റ്റുകളൊന്നുമില്ല';
}

// Path: discover
class _TranslationsDiscoverMl extends TranslationsDiscoverEn {
	_TranslationsDiscoverMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'കണ്ടെത്തുക';
	@override String get searchHint => 'കഥകൾ, ഉപയോക്താക്കൾ, വിഷയങ്ങൾ എന്നിവ തിരയുക...';
	@override String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';
	@override String get somethingWentWrong => 'ഒന്നുകിൽ പിശക് സംഭവിച്ചു';
	@override String get unableToLoadProfiles => 'പ്രൊഫൈലുകൾ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';
	@override String get noProfilesFound => 'ഒരു പ്രൊഫൈലും കണ്ടില്ല';
	@override String get searchToFindPeople => 'ഫോളോ ചെയ്യാൻ ആളുകളെ തിരയുക';
	@override String get noResultsFound => 'ഫലങ്ങളൊന്നുമില്ല';
	@override String get noProfilesYet => 'ഇനിയും പ്രൊഫൈലുകളൊന്നുമില്ല';
	@override String get tryDifferentKeywords => 'മറ്റൊരു തിരച്ചിൽ വാക്ക് ഉപയോഗിച്ച് ശ്രമിക്കുക';
	@override String get beFirstToDiscover => 'പുതിയ ആളുകളെ കണ്ടെത്തുന്ന ആദ്യ വ്യക്തി ആയിക്കൊള്ളൂ!';
}

// Path: plan
class _TranslationsPlanMl extends TranslationsPlanEn {
	_TranslationsPlanMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get signInToSavePlan => 'നിങ്ങളുടെ പദ്ധതി സംരക്ഷിക്കാനായി സൈൻ ഇൻ ചെയ്യുക';
	@override String get planSaved => 'പദ്ധതി സേവ് ചെയ്തു';
	@override String get from => 'എവിടെ നിന്ന്';
	@override String get dates => 'തീയതികൾ';
	@override String get destination => 'ലക്ഷ്യസ്ഥാനം';
	@override String get nearby => 'അടുത്തുള്ള';
	@override String get generatedPlan => 'സൃഷ്ടിച്ച പദ്ധതി';
	@override String get whereTravellingFrom => 'നിങ്ങൾ എവിടെ നിന്ന് യാത്ര ചെയ്യുന്നു?';
	@override String get enterCityOrRegion => 'നിങ്ങളുടെ നഗരം അല്ലെങ്കിൽ മേഖല നൽകുക';
	@override String get travelDates => 'യാത്ര തീയതികൾ';
	@override String get destinationSacredSite => 'ലക്ഷ്യം (പവിത്രസ്ഥലം)';
	@override String get searchOrSelectDestination => 'ലക്ഷ്യം തിരയുകയോ തിരഞ്ഞെടുക്കുകയോ ചെയ്യുക...';
	@override String get shareYourExperience => 'നിങ്ങളുടെ അനുഭവം പങ്കിടുക';
	@override String get planShared => 'പദ്ധതി ഷെയർ ചെയ്തു';
	@override String failedToSharePlan({required Object error}) => 'പദ്ധതി ഷെയർ ചെയ്യുന്നതിൽ പിശക്: ${error}';
	@override String get planUpdated => 'പദ്ധതി പുതുക്കി';
	@override String failedToUpdatePlan({required Object error}) => 'പദ്ധതി പുതുക്കുന്നതിൽ പിശക്: ${error}';
	@override String get deletePlanConfirm => 'പദ്ധതി ഇല്ലാതാക്കണോ?';
	@override String get thisPlanPermanentlyDeleted => 'ഈ പദ്ധതി സ്ഥിരമായി ഇല്ലാതാക്കപ്പെടും.';
	@override String get planDeleted => 'പദ്ധതി ഇല്ലാതാക്കി';
	@override String failedToDeletePlan({required Object error}) => 'പദ്ധതി ഇല്ലാതാക്കാൻ കഴിഞ്ഞില്ല: ${error}';
	@override String get sharePlan => 'പദ്ധതി പങ്കിടുക';
	@override String get deletePlan => 'പദ്ധതി ഇല്ലാതാക്കുക';
	@override String get savedPlanDetails => 'സംരക്ഷിച്ച പദ്ധതിയുടെ വിവരങ്ങൾ';
	@override String get pilgrimagePlan => 'തീർത്ഥയാത്ര പദ്ധതി';
	@override String get planTab => 'പദ്ധതി';
}

// Path: settings
class _TranslationsSettingsMl extends TranslationsSettingsEn {
	_TranslationsSettingsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'സെറ്റിങ്ങുകൾ';
	@override String get language => 'ഭാഷ';
	@override String get theme => 'തീം';
	@override String get themeLight => 'ലൈറ്റ്';
	@override String get themeDark => 'ഡാർക്ക്';
	@override String get themeSystem => 'സിസ്റ്റം തീം ഉപയോഗിക്കുക';
	@override String get darkMode => 'ഡാർക്ക് മോഡ്';
	@override String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';
	@override String get notifications => 'നോട്ടിഫിക്കേഷനുകൾ';
	@override String get cacheSettings => 'കാഷെ & സ്‌റ്റോറേജ്';
	@override String get general => 'സാധാരണ';
	@override String get account => 'അക്കൗണ്ട്';
	@override String get blockedUsers => 'ബ്ലോക്ക് ചെയ്ത ഉപയോക്താക്കൾ';
	@override String get helpSupport => 'സഹായം & പിന്തുണ';
	@override String get contactUs => 'ഞങ്ങളുമായി ബന്ധപ്പെടുക';
	@override String get legal => 'നിയമപരമായ';
	@override String get privacyPolicy => 'സ്വകാര്യതാ നയം';
	@override String get termsConditions => 'നിബന്ധനകളും വ്യവസ്ഥകളും';
	@override String get privacy => 'സ്വകാര്യത';
	@override String get about => 'ആപ്പ് കുറിച്ച്';
	@override String get version => 'പതിപ്പ്';
	@override String get logout => 'ലോഗ് ഔട്ട്';
	@override String get deleteAccount => 'അക്കൗണ്ട് ഇല്ലാതാക്കുക';
	@override String get deleteAccountTitle => 'അക്കൗണ്ട് ഇല്ലാതാക്കുക';
	@override String get deleteAccountWarning => 'ഈ പ്രവർത്തനം തിരികെ എടുക്കാൻ കഴിയില്ല!';
	@override String get deleteAccountDescription => 'നിങ്ങളുടെ അക്കൗണ്ട് ഇല്ലാതാക്കിയാൽ നിങ്ങളുടെ എല്ലാ പോസ്റ്റുകളും, കമന്റുകളും, പ്രൊഫൈലും, ഫോളോവേഴ്സും, സേവ് ചെയ്ത കഥകളും, ബുക്ക്മാർക്കുകളും, ചാറ്റ് സന്ദേശങ്ങളും, സൃഷ്ടിച്ച കഥകളും സ്ഥിരമായി ഇല്ലാതാക്കപ്പെടും.';
	@override String get confirmPassword => 'നിങ്ങളുടെ പാസ്‌വേഡ് സ്ഥിരീകരിക്കുക';
	@override String get confirmPasswordDesc => 'അക്കൗണ്ട് ഇല്ലാതാക്കുന്നത് സ്ഥിരീകരിക്കാൻ നിങ്ങളുടെ പാസ്‌വേഡ് നൽകുക.';
	@override String get googleReauth => 'നിങ്ങളുടെ തിരിച്ചറിയൽ സ്ഥിരീകരിക്കാൻ നിങ്ങളെ Google ലേക്ക് റീഡയറക്ട് ചെയ്യും.';
	@override String get finalConfirmationTitle => 'അവസാന സ്ഥിരീകരണം';
	@override String get finalConfirmation => 'നിങ്ങൾ പൂർണ്ണമായി ഉറപ്പാണോ? ഇത് സ്ഥിരമാണ്, തിരികെ എടുക്കാൻ കഴിയില്ല.';
	@override String get deleteMyAccount => 'എന്റെ അക്കൗണ്ട് ഇല്ലാതാക്കുക';
	@override String get deletingAccount => 'അക്കൗണ്ട് ഇല്ലാതാക്കുന്നു...';
	@override String get accountDeleted => 'നിങ്ങളുടെ അക്കൗണ്ട് സ്ഥിരമായി ഇല്ലാതാക്കി.';
	@override String get deleteAccountFailed => 'അക്കൗണ്ട് ഇല്ലാതാക്കാൻ കഴിഞ്ഞില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';
	@override String get downloadedStories => 'ഡൗൺലോഡ് ചെയ്ത കഥകൾ';
	@override String get couldNotOpenEmail => 'ഇമെയിൽ ആപ്പ് തുറക്കാൻ സാധിച്ചില്ല. ദയവായി ഞങ്ങൾക്ക് myitihas@gmail.com ലേക്ക് ഇമെയിൽ അയയ്ക്കുക.';
	@override String couldNotOpenLabel({required Object label}) => '${label} ഇപ്പോൾ തുറക്കാൻ സാധിച്ചില്ല.';
	@override String get logoutTitle => 'ലോഗ് ഔട്ട്';
	@override String get logoutConfirm => 'നിങ്ങൾക്ക് തീർച്ചയായും ലോഗ് ഔട്ട് ചെയ്യണമെന്നുണ്ടോ?';
	@override String get verifyYourIdentity => 'നിങ്ങളുടെ തിരിച്ചറിയൽ സ്ഥിരീകരിക്കുക';
	@override String get verifyYourIdentityDesc => 'നിങ്ങളുടെ തിരിച്ചറിയൽ സ്ഥിരീകരിക്കാൻ Google ഉപയോഗിച്ച് സൈൻ ഇൻ ചെയ്യാൻ നിങ്ങളോട് അഭ്യർത്ഥിക്കും.';
	@override String get continueWithGoogle => 'Google ഉപയോഗിച്ച് തുടർക്കുക';
	@override String reauthFailed({required Object error}) => 'വീണ്ടും സ്ഥിരീകരണം പരാജയപ്പെട്ടു: ${error}';
	@override String get passwordRequired => 'പാസ്‌വേഡ് ആവശ്യമാണ്';
	@override String get invalidPassword => 'അസാധുവായ പാസ്‌വേഡ്. ദയവായി വീണ്ടും ശ്രമിക്കുക.';
	@override String get verify => 'സ്ഥിരീകരിക്കുക';
	@override String get continueLabel => 'തുടരുക';
	@override String get unableToVerifyIdentity => 'തിരിച്ചറിയൽ സ്ഥിരീകരിക്കാൻ കഴിഞ്ഞില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';
}

// Path: auth
class _TranslationsAuthMl extends TranslationsAuthEn {
	_TranslationsAuthMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get login => 'ലോഗിൻ';
	@override String get signup => 'സൈൻ അപ്പ്';
	@override String get email => 'ഇമെയിൽ';
	@override String get password => 'പാസ്‌വേഡ്';
	@override String get confirmPassword => 'പാസ്‌വേഡ് സ്ഥിരീകരിക്കുക';
	@override String get forgotPassword => 'പാസ്‌വേഡ് മറന്നോ?';
	@override String get resetPassword => 'പാസ്‌വേഡ് റീസെറ്റ് ചെയ്യുക';
	@override String get dontHaveAccount => 'അക്കൗണ്ട് ഇല്ലേ?';
	@override String get alreadyHaveAccount => 'ഇതിനകം അക്കൗണ്ട് ഉണ്ടോ?';
	@override String get loginSuccess => 'ലോഗിൻ വിജയകരമായി';
	@override String get signupSuccess => 'സൈൻ അപ്പ് വിജയകരമായി';
	@override String get loginError => 'ലോഗിൻ പരാജയപ്പെട്ടു';
	@override String get signupError => 'സൈൻ അപ്പ് പരാജയപ്പെട്ടു';
}

// Path: error
class _TranslationsErrorMl extends TranslationsErrorEn {
	_TranslationsErrorMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get network => 'ഇന്റർനെറ്റ് കണക്ഷൻ ഇല്ല';
	@override String get server => 'സെർവറിൽ പിശക് സംഭവിച്ചു';
	@override String get cache => 'കാഷെ ഡാറ്റ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല';
	@override String get timeout => 'അഭ്യർത്ഥനയുടെ സമയം കഴിഞ്ഞു';
	@override String get notFound => 'സ്രോതസ്സ് കണ്ടെത്താനായില്ല';
	@override String get validation => 'സാധൂകരണം പരാജയപ്പെട്ടു';
	@override String get unexpected => 'അപ്രതീക്ഷിതമായ പിശക് സംഭവിച്ചു';
	@override String get tryAgain => 'ദയവായി വീണ്ടും ശ്രമിക്കുക';
	@override String couldNotOpenLink({required Object url}) => 'ലിങ്ക് തുറക്കാൻ കഴിഞ്ഞില്ല: ${url}';
}

// Path: subscription
class _TranslationsSubscriptionMl extends TranslationsSubscriptionEn {
	_TranslationsSubscriptionMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get free => 'സൌജന്യം';
	@override String get plus => 'പ്ലസ്';
	@override String get pro => 'പ്രോ';
	@override String get upgradeToPro => 'പ്രോ ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യുക';
	@override String get features => 'സവിശേഷതകൾ';
	@override String get subscribe => 'സബ്സ്ക്രൈബ് ചെയ്യുക';
	@override String get currentPlan => 'നിലവിലെ പ്ലാൻ';
	@override String get managePlan => 'പ്ലാൻ മാനേജ് ചെയ്യുക';
}

// Path: notification
class _TranslationsNotificationMl extends TranslationsNotificationEn {
	_TranslationsNotificationMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'നോട്ടിഫിക്കേഷനുകൾ';
	@override String get peopleToConnect => 'ബന്ധപ്പെടേണ്ട ആളുകൾ';
	@override String get peopleToConnectSubtitle => 'ഫോളോ ചെയ്യാനുള്ള ആളുകളെ കണ്ടെത്തുക';
	@override String followAgainInMinutes({required Object minutes}) => '${minutes} മിനിറ്റിനുശേഷം വീണ്ടും ഫോളോ ചെയ്യാം';
	@override String get noSuggestions => 'ഇപ്പോൾ യാതൊരു നിർദേശവും ഇല്ല';
	@override String get markAllRead => 'എല്ലാം വായിച്ചതായി അടയാളപ്പെടുത്തുക';
	@override String get noNotifications => 'ഇനിയും ഒരു നോട്ടിഫിക്കേഷനും ഇല്ല';
	@override String get noNotificationsSubtitle => 'ആരെങ്കിലും നിങ്ങളുടെ കഥകളോടൊപ്പം ഇടപെടുമ്പോൾ, നിങ്ങൾക്ക് അത് ഇവിടെ കാണാം';
	@override String get errorPrefix => 'പിശക്:';
	@override String get retry => 'വീണ്ടും ശ്രമിക്കുക';
	@override String likedYourStory({required Object actorName}) => '${actorName} നിങ്ങളുടെ കഥ ഇഷ്‌ടപ്പെട്ടു';
	@override String commentedOnYourStory({required Object actorName}) => '${actorName} നിങ്ങളുടെ കഥയിൽ കമന്റ് ചെയ്തു';
	@override String repliedToYourComment({required Object actorName}) => '${actorName} നിങ്ങളുടെ കമന്റിന് മറുപടി നൽകി';
	@override String startedFollowingYou({required Object actorName}) => '${actorName} നിങ്ങളെ ഫോളോ ചെയ്യാൻ തുടങ്ങി';
	@override String sentYouAMessage({required Object actorName}) => '${actorName} നിങ്ങളെ ഒരു സന്ദേശം അയച്ചു';
	@override String sharedYourStory({required Object actorName}) => '${actorName} നിങ്ങളുടെ കഥ പങ്കിട്ടു';
	@override String repostedYourStory({required Object actorName}) => '${actorName} നിങ്ങളുടെ കഥ വീണ്ടും പോസ്റ്റ് ചെയ്തു';
	@override String mentionedYou({required Object actorName}) => '${actorName} നിങ്ങളെ പരാമർശിച്ചു';
	@override String newPostFrom({required Object actorName}) => '${actorName} ലെ പുതിയ പോസ്റ്റ്';
	@override String get today => 'ഇന്ന്';
	@override String get thisWeek => 'ഈ ആഴ്ച';
	@override String get earlier => 'ഏററവും മുമ്പ്';
	@override String get delete => 'ഇല്ലാതാക്കുക';
}

// Path: profile
class _TranslationsProfileMl extends TranslationsProfileEn {
	_TranslationsProfileMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get followers => 'ഫോളോവേഴ്സ്';
	@override String get following => 'ഫോളോ ചെയ്യുന്നു';
	@override String get unfollow => 'ഫോളോ ഒഴിവാക്കുക';
	@override String get follow => 'ഫോളോ ചെയ്യുക';
	@override String get about => 'കുറിച്ച്';
	@override String get stories => 'കഥകൾ';
	@override String get unableToShareImage => 'ഇമേജ് ഷെയർ ചെയ്യാൻ സാധിച്ചില്ല';
	@override String get imageSavedToPhotos => 'ഇമേജ് ഫോട്ടോസിൽ സേവ് ചെയ്തു';
	@override String get view => 'കാണുക';
	@override String get saveToPhotos => 'ഫോട്ടോസിലേക്ക് സേവ് ചെയ്യുക';
	@override String get failedToLoadImage => 'ഇമേജ് ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല';
}

// Path: feed
class _TranslationsFeedMl extends TranslationsFeedEn {
	_TranslationsFeedMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get loading => 'കഥകൾ ലോഡ് ചെയ്യുന്നു...';
	@override String get loadingPosts => 'പോസ്റ്റുകൾ ലോഡ് ചെയ്യുന്നു...';
	@override String get loadingVideos => 'വീഡിയോകൾ ലോഡ് ചെയ്യുന്നു...';
	@override String get loadingStories => 'കഥകൾ ലോഡ് ചെയ്യുന്നു...';
	@override String get errorTitle => 'അയ്യോ! എന്തോ കേടായി';
	@override String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';
	@override String get noStoriesAvailable => 'ഏതൊരു കഥയും ലഭ്യമല്ല';
	@override String get noImagesAvailable => 'ഇമേജ് പോസ്റ്റുകൾ ഒന്നുമില്ല';
	@override String get noTextPostsAvailable => 'ടെക്‌സ്‌റ്റ് പോസ്റ്റുകൾ ഒന്നുമില്ല';
	@override String get noContentAvailable => 'ഏതൊരു ഉള്ളടക്കവും ഇല്ല';
	@override String get refresh => 'റിഫ്രഷ് ചെയ്യുക';
	@override String get comments => 'കമന്റുകൾ';
	@override String get commentsComingSoon => 'കമന്റുകൾ ഉടൻ വരുന്നു';
	@override String get addCommentHint => 'കമന്റ് ചേർക്കുക...';
	@override String get shareStory => 'കഥ ഷെയർ ചെയ്യുക';
	@override String get sharePost => 'പോസ്റ്റ് ഷെയർ ചെയ്യുക';
	@override String get shareThought => 'ചിന്ത ഷെയർ ചെയ്യുക';
	@override String get shareAsImage => 'ഇമേജായി ഷെയർ ചെയ്യുക';
	@override String get shareAsImageSubtitle => 'ഒരു മനോഹരമായ പ്രിവ്യൂ കാർഡ് സൃഷ്ടിക്കുക';
	@override String get shareLink => 'ലിങ്ക് ഷെയർ ചെയ്യുക';
	@override String get shareLinkSubtitle => 'കഥയുടെ ലിങ്ക് കോപ്പി ചെയ്യുക അല്ലെങ്കിൽ ഷെയർ ചെയ്യുക';
	@override String get shareImageLinkSubtitle => 'പോസ്റ്റിന്റെ ലിങ്ക് കോപ്പി ചെയ്യുക അല്ലെങ്കിൽ ഷെയർ ചെയ്യുക';
	@override String get shareTextLinkSubtitle => 'ചിന്തയുടെ ലിങ്ക് കോപ്പി ചെയ്യുക അല്ലെങ്കിൽ ഷെയർ ചെയ്യുക';
	@override String get shareAsText => 'ടെക്‌സ്‌റ്റായി ഷെയർ ചെയ്യുക';
	@override String get shareAsTextSubtitle => 'കഥയിലെ ഒരു ഭാഗം ഷെയർ ചെയ്യുക';
	@override String get shareQuote => 'ഉദ്ധരണി ഷെയർ ചെയ്യുക';
	@override String get shareQuoteSubtitle => 'ഉദ്ധരണി രൂപത്തിൽ ഷെയർ ചെയ്യുക';
	@override String get shareWithImage => 'ഇമേജും ക്യാപ്പ്ഷനും ചേർത്ത് ഷെയർ ചെയ്യുക';
	@override String get shareWithImageSubtitle => 'ഇമേജും തലക്കെട്ടും ഒന്നിച്ച് ഷെയർ ചെയ്യുക';
	@override String get copyLink => 'ലിങ്ക് കോപ്പി ചെയ്യുക';
	@override String get copyLinkSubtitle => 'ലിങ്ക് ക്ലിപ്പ്ബോർഡിലേക്ക് കോപ്പി ചെയ്യുക';
	@override String get copyText => 'ടെക്‌സ്‌റ്റ് കോപ്പി ചെയ്യുക';
	@override String get copyTextSubtitle => 'ഉദ്ധരണി ക്ലിപ്പ്ബോർഡിലേക്ക് കോപ്പി ചെയ്യുക';
	@override String get linkCopied => 'ലിങ്ക് ക്ലിപ്പ്ബോർഡിലേക്ക് കോപ്പി ചെയ്തു';
	@override String get textCopied => 'ടെക്‌സ്‌റ്റ് ക്ലിപ്പ്ബോർഡിലേക്ക് കോപ്പി ചെയ്തു';
	@override String get sendToUser => 'ഉപയോക്താവിന് അയക്കുക';
	@override String get sendToUserSubtitle => 'ഒരു സുഹൃത്തിനോടൊപ്പം നേരിട്ട് പങ്കിടുക';
	@override String get chooseFormat => 'ഫോർമാറ്റ് തിരഞ്ഞെടുക്കുക';
	@override String get linkPreview => 'ലിങ്ക് പ്രിവ്യൂ';
	@override String get linkPreviewSize => '1200 × 630';
	@override String get storyFormat => 'സ്റ്റോറി ഫോർമാറ്റ്';
	@override String get storyFormatSize => '1080 × 1920 (Instagram/Stories)';
	@override String get generatingPreview => 'പ്രിവ്യൂ സൃഷ്ടിക്കുന്നു...';
	@override String get bookmarked => 'ബുക്ക്‌മാർക്ക് ചെയ്തു';
	@override String get removedFromBookmarks => 'ബുക്ക്‌മാർക്കിൽ നിന്ന് നീക്കി';
	@override String unlike({required Object count}) => 'അൺലൈക്ക്, ${count} ലൈക്കുകൾ';
	@override String like({required Object count}) => 'ലൈക്ക്, ${count} ലൈക്കുകൾ';
	@override String commentCount({required Object count}) => '${count} കമന്റുകൾ';
	@override String shareCount({required Object count}) => 'ഷെയർ, ${count} തവണ ഷെയർ ചെയ്തു';
	@override String get removeBookmark => 'ബുക്ക്‌മാർക്ക് നീക്കുക';
	@override String get addBookmark => 'ബുക്ക്‌മാർക്ക് ചെയ്യുക';
	@override String get quote => 'ഉദ്ധരണി';
	@override String get quoteCopied => 'ഉദ്ധരണി ക്ലിപ്പ്ബോർഡിലേക്ക് കോപ്പി ചെയ്തു';
	@override String get copy => 'കോപ്പി ചെയ്യുക';
	@override String get tapToViewFullQuote => 'പൂർണ്ണ ഉദ്ധരണി കാണാൻ ടാപ്പ് ചെയ്യുക';
	@override String get quoteFromMyitihas => 'MyItihas-ലൂടെ ഉദ്ധരണി';
	@override late final _TranslationsFeedTabsMl tabs = _TranslationsFeedTabsMl._(_root);
	@override String get tapToShowCaption => 'ക്യാപ്പ്ഷൻ കാണാൻ ടാപ്പ് ചെയ്യുക';
	@override String get noVideosAvailable => 'വീഡിയോകൾ ഒന്നും ലഭ്യമല്ല';
	@override String get selectUser => 'ആര്‍ക്ക് അയക്കണം';
	@override String get searchUsers => 'ഉപയോക്താക്കളെ തിരയുക...';
	@override String get noFollowingYet => 'നിങ്ങൾ ഇനിയും ആരെയും ഫോളോ ചെയ്യുന്നില്ല';
	@override String get noUsersFound => 'ഒരു ഉപയോക്താവും കണ്ടില്ല';
	@override String get tryDifferentSearch => 'മറ്റൊരു തിരച്ചിലിനൊപ്പം ശ്രമിക്കുക';
	@override String sentTo({required Object username}) => '${username} നു അയച്ചു';
}

// Path: voice
class _TranslationsVoiceMl extends TranslationsVoiceEn {
	_TranslationsVoiceMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get microphonePermissionRequired => 'മൈക്രോഫോണിന്റെ അനുമതി ആവശ്യമാണ്';
	@override String get speechRecognitionNotAvailable => 'സ്പീച്ച് റെക്കഗ്നിഷൻ ലഭ്യമല്ല';
	@override String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class _TranslationsFestivalsMl extends TranslationsFestivalsEn {
	_TranslationsFestivalsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'ഉത്സവ കഥകൾ';
	@override String get tellStory => 'കഥ പറയുക';
}

// Path: social
class _TranslationsSocialMl extends TranslationsSocialEn {
	_TranslationsSocialMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSocialEditProfileMl editProfile = _TranslationsSocialEditProfileMl._(_root);
	@override late final _TranslationsSocialCreatePostMl createPost = _TranslationsSocialCreatePostMl._(_root);
	@override late final _TranslationsSocialCommentsMl comments = _TranslationsSocialCommentsMl._(_root);
	@override late final _TranslationsSocialEngagementMl engagement = _TranslationsSocialEngagementMl._(_root);
	@override String get editCaption => 'ക്യാപ്പ്ഷൻ എഡിറ്റ് ചെയ്യുക';
	@override String get reportPost => 'പോസ്റ്റ് റിപ്പോർട്ട് ചെയ്യുക';
	@override String get reportReasonHint => 'ഈ പോസ്റ്റിൽ എന്താണ് തെറ്റ് എന്ന് ഞങ്ങൾക്കുപറയൂ';
	@override String get deletePost => 'പോസ്റ്റ് ഇല്ലാതാക്കുക';
	@override String get deletePostConfirm => 'ഈ പ്രവർത്തി തിരിച്ചു എടുക്കാൻ കഴിയില്ല.';
	@override String get postDeleted => 'പോസ്റ്റ് ഇല്ലാതാക്കി';
	@override String failedToDeletePost({required Object error}) => 'പോസ്റ്റ് ഇല്ലാതാക്കാൻ കഴിഞ്ഞില്ല: ${error}';
	@override String failedToReportPost({required Object error}) => 'പോസ്റ്റ് റിപ്പോർട്ട് ചെയ്യാൻ കഴിഞ്ഞില്ല: ${error}';
	@override String get reportSubmitted => 'റിപ്പോർട്ട് സമർപ്പിച്ചു. നന്ദി.';
	@override String get acceptRequestFirst => 'ആദ്യം "Requests" പേജിൽ അവരുടെ അഭ്യർത്ഥന സ്വീകരിക്കുക.';
	@override String get requestSentWait => 'അഭ്യർത്ഥന അയച്ചു. അവർ സ്വീകരിക്കുന്നതിനായി കാത്തിരിക്കൂ.';
	@override String get requestSentTheyWillSee => 'അഭ്യർത്ഥന അയച്ചു. അവർ അത് "Requests" വിഭാഗത്തിൽ കാണും.';
	@override String failedToShare({required Object error}) => 'ഷെയർ ചെയ്യുന്നതിൽ പിശക്: ${error}';
	@override String get updateCaptionHint => 'നിങ്ങളുടെ പോസ്റ്റിന്റെ ക്യാപ്പ്ഷൻ അപ്ഡേറ്റ് ചെയ്യുക';
}

// Path: homeScreen.hero
class _TranslationsHomeScreenHeroMl extends TranslationsHomeScreenHeroEn {
	_TranslationsHomeScreenHeroMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get tapToExplore => 'അന്വേഷിക്കാൻ ടാപ്പ് ചെയ്യൂ';
	@override late final _TranslationsHomeScreenHeroStoryMl story = _TranslationsHomeScreenHeroStoryMl._(_root);
	@override late final _TranslationsHomeScreenHeroCompanionMl companion = _TranslationsHomeScreenHeroCompanionMl._(_root);
	@override late final _TranslationsHomeScreenHeroHeritageMl heritage = _TranslationsHomeScreenHeroHeritageMl._(_root);
	@override late final _TranslationsHomeScreenHeroCommunityMl community = _TranslationsHomeScreenHeroCommunityMl._(_root);
	@override late final _TranslationsHomeScreenHeroMessagesMl messages = _TranslationsHomeScreenHeroMessagesMl._(_root);
}

// Path: storyGenerator.storyLength
class _TranslationsStoryGeneratorStoryLengthMl extends TranslationsStoryGeneratorStoryLengthEn {
	_TranslationsStoryGeneratorStoryLengthMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get short => 'ചെറുത്';
	@override String get medium => 'ഇടത്തരം';
	@override String get long => 'വലുത്';
	@override String get epic => 'ഏറ്റവും ദൈർഘ്യമുള്ള';
}

// Path: storyGenerator.format
class _TranslationsStoryGeneratorFormatMl extends TranslationsStoryGeneratorFormatEn {
	_TranslationsStoryGeneratorFormatMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get narrative => 'കഥാത്മകം';
	@override String get dialogue => 'സംഭാഷണാത്മകം';
	@override String get poetic => 'കാവ്യാത്മകം';
	@override String get scriptural => 'ശാസ്ത്രീയം';
}

// Path: storyGenerator.hints
class _TranslationsStoryGeneratorHintsMl extends TranslationsStoryGeneratorHintsEn {
	_TranslationsStoryGeneratorHintsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get krishnaTeaching => 'കൃഷ്ണൻ അർജുനനോട് ഉപദേശിക്കുന്ന കഥ പറയുക...';
	@override String get warriorRedemption => 'പ്രായശ്ചിത്തം അന്വേഷിക്കുന്ന ഒരു യോദ്ധാവിന്റെ പ്രബലമായ കഥ എഴുതുക...';
	@override String get sageWisdom => 'മഹർഷിമാരുടെ ജ്ഞാനത്തെക്കുറിച്ചുള്ള ഒരു കഥ സൃഷ്ടിക്കുക...';
	@override String get devotedSeeker => 'ഭക്തനായ ഒരു യാത്രക്കാരന്റെ ആത്മീയ യാത്ര വിവരിക്കുക...';
	@override String get divineIntervention => 'ദൈവീക ഇടപെടലിന്റെ ഒരു കഥ പങ്കിടുക...';
}

// Path: storyGenerator.errors
class _TranslationsStoryGeneratorErrorsMl extends TranslationsStoryGeneratorErrorsEn {
	_TranslationsStoryGeneratorErrorsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get incompletePrompt => 'ദയവായി ആവശ്യമായ മുഴുവൻ ഓപ്ഷനുകളും പൂരിപ്പിക്കുക';
	@override String get generationFailed => 'കഥ സൃഷ്ടിക്കാൻ സാധിച്ചില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';
}

// Path: chat.suggestions
class _TranslationsChatSuggestionsMl extends TranslationsChatSuggestionsEn {
	_TranslationsChatSuggestionsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get greeting => '👋  നമസ്കാരം!';
	@override String get dharma => '📖  ധർമ്മം എന്താണ്?';
	@override String get stress => '🧘  സമ്മർദ്ദത്തെ എങ്ങനെ കൈകാര്യം ചെയ്യാം';
	@override String get karma => '⚡  കർമ്മം ലളിതമായി വിശദീകരിക്കൂ';
	@override String get story => '💬  എനിക്ക് ഒരു കഥ പറയൂ';
	@override String get wisdom => '🌟  ഇന്നത്തെ ജ്ഞാനം';
}

// Path: chat.composerAttachments
class _TranslationsChatComposerAttachmentsMl extends TranslationsChatComposerAttachmentsEn {
	_TranslationsChatComposerAttachmentsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

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
class _TranslationsMapDiscussionsMl extends TranslationsMapDiscussionsEn {
	_TranslationsMapDiscussionsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get postDiscussionCta => 'ചർച്ച പോസ്റ്റ് ചെയ്യുക';
	@override String get intentCardCta => 'ഒരു ചർച്ച പോസ്റ്റ് ചെയ്യുക';
}

// Path: map.fabricMap
class _TranslationsMapFabricMapMl extends TranslationsMapFabricMapEn {
	_TranslationsMapFabricMapMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

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
class _TranslationsMapClassicalArtMapMl extends TranslationsMapClassicalArtMapEn {
	_TranslationsMapClassicalArtMapMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

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
class _TranslationsMapClassicalDanceMapMl extends TranslationsMapClassicalDanceMapEn {
	_TranslationsMapClassicalDanceMapMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

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
class _TranslationsMapFoodMapMl extends TranslationsMapFoodMapEn {
	_TranslationsMapFoodMapMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

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
class _TranslationsFeedTabsMl extends TranslationsFeedTabsEn {
	_TranslationsFeedTabsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get all => 'എല്ലാം';
	@override String get stories => 'കഥകൾ';
	@override String get posts => 'പോസ്റ്റുകൾ';
	@override String get videos => 'വീഡിയോകൾ';
	@override String get images => 'ഫോട്ടോകള്‍';
	@override String get text => 'ചിന്തകള്‍';
}

// Path: social.editProfile
class _TranslationsSocialEditProfileMl extends TranslationsSocialEditProfileEn {
	_TranslationsSocialEditProfileMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'പ്രൊഫൈല്‍ എഡിറ്റ് ചെയ്യുക';
	@override String get displayName => 'പ്രദർശന പേര്';
	@override String get displayNameHint => 'നിങ്ങളുടെ പ്രദർശന പേര് നൽകുക';
	@override String get displayNameEmpty => 'പ്രദർശന പേര് ശൂന്യമാകരുത്';
	@override String get bio => 'ജീവിത വിവരണം';
	@override String get bioHint => 'നിങ്ങളെ കുറിച്ച് ഞങ്ങൾക്ക് പറയൂ...';
	@override String get changePhoto => 'പ്രൊഫൈൽ ഫോട്ടോ മാറ്റുക';
	@override String get saveChanges => 'മാറ്റങ്ങൾ സേവ് ചെയ്യുക';
	@override String get profileUpdated => 'പ്രൊഫൈൽ വിജയകരമായി അപ്ഡേറ്റ് ചെയ്തു';
	@override String get profileAndPhotoUpdated => 'പ്രൊഫൈലും ഫോട്ടോയും വിജയകരമായി അപ്ഡേറ്റ് ചെയ്തു';
	@override String failedPickImage({required Object error}) => 'ഇമേജ് തിരഞ്ഞെടുക്കുന്നതിൽ പിശക്: ${error}';
	@override String failedUploadPhoto({required Object error}) => 'ഫോട്ടോ അപ്‌ലോഡ് ചെയ്യുന്നതിൽ പിശക്: ${error}';
	@override String failedUpdateProfile({required Object error}) => 'പ്രൊഫൈൽ അപ്ഡേറ്റ് ചെയ്യുന്നതിൽ പിശക്: ${error}';
	@override String unexpectedError({required Object error}) => 'അപ്രതീക്ഷിതമായ പിശക്: ${error}';
}

// Path: social.createPost
class _TranslationsSocialCreatePostMl extends TranslationsSocialCreatePostEn {
	_TranslationsSocialCreatePostMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get title => 'പോസ്റ്റ് സൃഷ്ടിക്കുക';
	@override String get post => 'പോസ്റ്റ് ചെയ്യുക';
	@override String get text => 'ടെക്സ്റ്റ്';
	@override String get image => 'ഇമേജ്';
	@override String get video => 'വീഡിയോ';
	@override String get textHint => 'നിങ്ങളുടെ മനസ്സിൽ എന്താണ്?';
	@override String get imageCaptionHint => 'നിങ്ങളുടെ ഫോട്ടോയ്ക്ക് ഒരു ക്യാപ്പ്ഷൻ എഴുതൂ...';
	@override String get videoCaptionHint => 'നിങ്ങളുടെ വീഡിയോയെ കുറിച്ച് വിശദീകരിക്കുക...';
	@override String get shareCaptionHint => 'നിങ്ങളുടെ ചിന്തകൾ ചേർക്കുക...';
	@override String get titleHint => 'ഒരു തലക്കെട്ട് ചേർക്കുക (ഐച്ഛികം)';
	@override String get selectVideo => 'വീഡിയോ തിരഞ്ഞെടുക്കുക';
	@override String get gallery => 'ഗാലറി';
	@override String get camera => 'ക്യാമറ';
	@override String get visibility => 'ഇത് ആരെല്ലാം കാണാം?';
	@override String get public => 'പബ്ലിക്';
	@override String get followers => 'ഫോളോവേഴ്സ്';
	@override String get private => 'സ്വകാര്യ';
	@override String get postCreated => 'പോസ്റ്റ് സൃഷ്ടിച്ചു!';
	@override String get failedPickImages => 'ഇമേജുകൾ തിരഞ്ഞെടുക്കുമ്പോൾ പിശക്';
	@override String get failedPickVideo => 'വീഡിയോ തിരഞ്ഞെടുക്കുമ്പോൾ പിശക്';
	@override String get failedCapturePhoto => 'ഫോട്ടോ എടുക്കുന്നതിൽ പിശക്';
	@override String get cannotCreateOffline => 'ഓഫ്‌ലൈൻ മോഡിൽ പോസ്റ്റ് സൃഷ്ടിക്കാൻ കഴിയില്ല';
	@override String get discardTitle => 'പോസ്റ്റ് ഉപേക്ഷിക്കണോ?';
	@override String get discardMessage => 'സേവ് ചെയ്യാത്ത മാറ്റങ്ങൾ ഉണ്ട്. തീർച്ചയായും ഈ പോസ്റ്റ് ഉപേക്ഷിക്കണമോ?';
	@override String get keepEditing => 'എഡിറ്റ് ചെയ്യുന്നത് തുടരുക';
	@override String get discard => 'ഉപേക്ഷിക്കുക';
	@override String get cropPhoto => 'ഫോട്ടോ ക്രോപ്പ് ചെയ്യുക';
	@override String get trimVideo => 'വീഡിയോ ട്രിം ചെയ്യുക';
	@override String get editPhoto => 'ഫോട്ടോ എഡിറ്റ് ചെയ്യുക';
	@override String get editVideo => 'വീഡിയോ എഡിറ്റ് ചെയ്യുക';
	@override String get maxDuration => 'പരമാവധി 30 സെക്കന്റ്';
	@override String get aspectSquare => 'ചതുരം';
	@override String get aspectPortrait => 'നെരാഴ്ച';
	@override String get aspectLandscape => 'താഴോട്ടുള്ള';
	@override String get aspectFree => 'സ്വതന്ത്രം';
	@override String get failedCrop => 'ഫോട്ടോ ക്രോപ്പ് ചെയ്യാൻ കഴിഞ്ഞില്ല';
	@override String get failedTrim => 'വീഡിയോ ട്രിം ചെയ്യാൻ കഴിഞ്ഞില്ല';
	@override String get trimmingVideo => 'വീഡിയോ ട്രിം ചെയ്യുന്നു...';
	@override String trimVideoSubtitle({required Object max}) => 'പരമാവധി ${max}സെ · നിങ്ങളുടെ മികച്ച ഭാഗം തിരഞ്ഞെടുക്കൂ';
	@override String get trimVideoInstructionsTitle => 'നിങ്ങളുടെ ക്ലിപ്പ് ട്രിം ചെയ്യൂ';
	@override String get trimVideoInstructionsBody => 'ആരംഭവും അവസാനവും ഹാൻഡിലുകൾ വലിച്ച് 30 സെക്കൻഡ് വരെ ഭാഗം തിരഞ്ഞെടുക്കൂ.';
	@override String get trimStart => 'ആരംഭം';
	@override String get trimEnd => 'അവസാനം';
	@override String get trimSelectionEmpty => 'തുടരാൻ സാധുവായ റേഞ്ച് തിരഞ്ഞെടുക്കൂ';
	@override String trimSelectionSummary({required Object seconds, required Object start, required Object end, required Object max}) => '${seconds}സെ തിരഞ്ഞെടുക്കപ്പെട്ടു (${start}–${end}) · പരമാവധി ${max}സെ';
	@override String get coverFrame => 'കവർ ഫ്രെയിം';
	@override String get coverFrameUnavailable => 'പ്രിവ്യൂ ഇല്ല';
	@override String coverFramePosition({required Object time}) => '${time} ൽ കവർ';
	@override String get overlayLabel => 'വീഡിയോയിൽ ടെക്സ്റ്റ് (ഐച്ഛികം)';
	@override String get overlayHint => 'ചെറിയ ഹുക്ക് അല്ലെങ്കിൽ തലക്കെട്ട് ചേർക്കൂ';
	@override String get imageSectionHint => 'ഗാലറിയിൽ നിന്ന് അല്ലെങ്കിൽ ക്യാമറയിൽ നിന്ന് പരമാവധി 10 ഫോട്ടോകൾ ചേർക്കുക';
	@override String get videoSectionHint => 'ഒരു വീഡിയോ, പരമാവധി 30 സെക്കന്റ്';
	@override String get removePhoto => 'ഫോട്ടോ നീക്കം ചെയ്യുക';
	@override String get removeVideo => 'വീഡിയോ നീക്കം ചെയ്യുക';
	@override String get photoEditHint => 'ഫോട്ടോ ക്രോപ്പ് ചെയ്യുകയോ നീക്കം ചെയ്യുകയോ ചെയ്യാൻ ടാപ്പ് ചെയ്യുക';
	@override String get videoEditOptions => 'എഡിറ്റ് ഓപ്ഷനുകൾ';
	@override String get addPhoto => 'ഫോട്ടോ ചേർക്കുക';
	@override String get done => 'കഴിഞ്ഞു';
	@override String get rotate => 'തിരിക്കുക';
	@override String get editPhotoSubtitle => 'ഫീഡിൽ കൂടുതൽ നന്നായി കാണാൻ ചതുരത്തിൽ ക്രോപ്പ് ചെയ്യുക';
	@override String get videoEditorCaptionLabel => 'ക്യാപ്ഷൻ / എഴുത്ത് (ഐച്ഛികം)';
	@override String get videoEditorCaptionHint => 'ഉദാ: നിങ്ങളുടെ റീലിനുള്ള തലക്കെട്ട് അല്ലെങ്കിൽ ഹുക്ക്';
	@override String get videoEditorAspectLabel => 'അനുപാതം';
	@override String get videoEditorAspectOriginal => 'മൂലം';
	@override String get videoEditorAspectSquare => '1:1';
	@override String get videoEditorAspectPortrait => '9:16';
	@override String get videoEditorAspectLandscape => '16:9';
	@override String get videoEditorQuickTrim => 'വേഗ ട്രിം';
	@override String get videoEditorSpeed => 'വേഗം';
}

// Path: social.comments
class _TranslationsSocialCommentsMl extends TranslationsSocialCommentsEn {
	_TranslationsSocialCommentsMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String replyingTo({required Object name}) => '${name} എന്നയാളിനു മറുപടി നൽകുന്നു';
	@override String replyHint({required Object name}) => '${name} നു മറുപടി എഴുതുക...';
	@override String failedToPost({required Object error}) => 'കമന്റ് പോസ്റ്റ് ചെയ്യാൻ കഴിഞ്ഞില്ല: ${error}';
	@override String get cannotPostOffline => 'ഓഫ്‌ലൈൻ മോഡിൽ കമന്റ് പോസ്റ്റ് ചെയ്യാൻ കഴിയില്ല';
	@override String get noComments => 'ഇനിയും ഒരു കമന്റുമില്ല';
	@override String get beFirst => 'ആദ്യ കമന്റ് നിങ്ങൾ ചെയ്യൂ!';
}

// Path: social.engagement
class _TranslationsSocialEngagementMl extends TranslationsSocialEngagementEn {
	_TranslationsSocialEngagementMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get offlineMode => 'ഓഫ്‌ലൈൻ മോഡ്';
}

// Path: homeScreen.hero.story
class _TranslationsHomeScreenHeroStoryMl extends TranslationsHomeScreenHeroStoryEn {
	_TranslationsHomeScreenHeroStoryMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'എഐ കഥ സൃഷ്ടിക്കൽ';
	@override String get headline => 'മനസാക്ഷിയെ\nആകർഷിക്കുന്ന കഥകൾ\nസൃഷ്ടിക്കുക';
	@override String get subHeadline => 'പ്രാചീന ജ്ഞാനത്തിന്റെ ശക്തിയിൽ';
	@override String get line1 => '✦  ഒരു പവിത്ര ശാസ്ത്രം തിരഞ്ഞെടുക്കൂ...';
	@override String get line2 => '✦  ജീവന്തമായ പശ്ചാത്തലം തിരഞ്ഞെടുക്കൂ...';
	@override String get line3 => '✦  എഐ കൊണ്ട് മായാജാല കഥ നെയ്യാൻ അനുവദിക്കൂ...';
	@override String get cta => 'കഥ സൃഷ്ടിക്കുക';
}

// Path: homeScreen.hero.companion
class _TranslationsHomeScreenHeroCompanionMl extends TranslationsHomeScreenHeroCompanionEn {
	_TranslationsHomeScreenHeroCompanionMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'ആത്മീയ കൂട്ടായി';
	@override String get headline => 'നിങ്ങളുടെ ദിവ്യ\nമാർഗദർശി,\nഎപ്പോഴും സമീപം';
	@override String get subHeadline => 'കൃഷ്ണന്റെ ജ്ഞാനത്തിൽ നിന്ന് പ്രചോദനം';
	@override String get line1 => '✦  ശരിക്കും കേൾക്കുന്ന ഒരു സുഹൃത്ത്...';
	@override String get line2 => '✦  ജീവിത പോരാട്ടങ്ങൾക്ക് ജ്ഞാനം...';
	@override String get line3 => '✦  നിങ്ങളെ ഉണർത്തുന്ന സംഭാഷണങ്ങൾ...';
	@override String get cta => 'ചാറ്റ് ആരംഭിക്കുക';
}

// Path: homeScreen.hero.heritage
class _TranslationsHomeScreenHeroHeritageMl extends TranslationsHomeScreenHeroHeritageEn {
	_TranslationsHomeScreenHeroHeritageMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'പൈതൃക മാപ്പ്';
	@override String get headline => 'ശാശ്വത\nപൈതൃകം\nകണ്ടെത്തൂ';
	@override String get subHeadline => '5000+ പവിത്ര സ്ഥാനങ്ങൾ മാപ്പിൽ';
	@override String get line1 => '✦  പവിത്ര സ്ഥലങ്ങൾ അന്വേഷിക്കൂ...';
	@override String get line2 => '✦  ചരിത്രവും കഥാപാരമ്പര്യവും വായിക്കൂ...';
	@override String get line3 => '✦  അർത്ഥവത്തായ യാത്രകൾ ആസൂത്രണം ചെയ്യൂ...';
	@override String get cta => 'മാപ്പ് അന്വേഷിക്കൂ';
}

// Path: homeScreen.hero.community
class _TranslationsHomeScreenHeroCommunityMl extends TranslationsHomeScreenHeroCommunityEn {
	_TranslationsHomeScreenHeroCommunityMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'സമൂഹ വേദി';
	@override String get headline => 'സംസ്കാരം\nലോകത്തോട്\nപങ്കിടൂ';
	@override String get subHeadline => 'സജീവമായ ആഗോള സമൂഹം';
	@override String get line1 => '✦  പോസ്റ്റുകളും ആഴമുള്ള ചർച്ചകളും...';
	@override String get line2 => '✦  ചെറു സാംസ്കാരിക വീഡിയോകൾ...';
	@override String get line3 => '✦  ലോകമെമ്പാടുമുള്ള കഥകൾ...';
	@override String get cta => 'സമൂഹത്തിൽ ചേരൂ';
}

// Path: homeScreen.hero.messages
class _TranslationsHomeScreenHeroMessagesMl extends TranslationsHomeScreenHeroMessagesEn {
	_TranslationsHomeScreenHeroMessagesMl._(TranslationsMl root) : this._root = root, super.internal(root);

	final TranslationsMl _root; // ignore: unused_field

	// Translations
	@override String get tagline => 'സ്വകാര്യ സന്ദേശങ്ങൾ';
	@override String get headline => 'അർത്ഥവത്തായ\nസംഭാഷണങ്ങൾ\nഇവിടെ തുടങ്ങുന്നു';
	@override String get subHeadline => 'സ്വകാര്യവും ചിന്താപൂർണ്ണവുമായ ഇടങ്ങൾ';
	@override String get line1 => '✦  സമാന ചിന്തകരുമായി ബന്ധപ്പെടൂ...';
	@override String get line2 => '✦  ആശയങ്ങളും കഥകളും ചര്‍ച്ച ചെയ്യൂ...';
	@override String get line3 => '✦  ചിന്താപൂർണ്ണ സമൂഹങ്ങൾ നിർമ്മിക്കൂ...';
	@override String get cta => 'സന്ദേശങ്ങൾ തുറക്കൂ';
}
