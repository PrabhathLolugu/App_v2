///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsNavigationEn navigation = TranslationsNavigationEn.internal(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsHomeScreenEn homeScreen = TranslationsHomeScreenEn.internal(_root);
	late final TranslationsStoriesEn stories = TranslationsStoriesEn.internal(_root);
	late final TranslationsStoryGeneratorEn storyGenerator = TranslationsStoryGeneratorEn.internal(_root);
	late final TranslationsChatEn chat = TranslationsChatEn.internal(_root);
	late final TranslationsMapEn map = TranslationsMapEn.internal(_root);
	late final TranslationsCommunityEn community = TranslationsCommunityEn.internal(_root);
	late final TranslationsDiscoverEn discover = TranslationsDiscoverEn.internal(_root);
	late final TranslationsPlanEn plan = TranslationsPlanEn.internal(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn.internal(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn.internal(_root);
	late final TranslationsErrorEn error = TranslationsErrorEn.internal(_root);
	late final TranslationsSubscriptionEn subscription = TranslationsSubscriptionEn.internal(_root);
	late final TranslationsNotificationEn notification = TranslationsNotificationEn.internal(_root);
	late final TranslationsProfileEn profile = TranslationsProfileEn.internal(_root);
	late final TranslationsFeedEn feed = TranslationsFeedEn.internal(_root);
	late final TranslationsSocialEn social = TranslationsSocialEn.internal(_root);
	late final TranslationsVoiceEn voice = TranslationsVoiceEn.internal(_root);
	late final TranslationsFestivalsEn festivals = TranslationsFestivalsEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'MyItihas'
	String get name => 'MyItihas';

	/// en: 'Discover Bharatiya Content'
	String get tagline => 'Discover Bharatiya Content';
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Share'
	String get share => 'Share';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Finish'
	String get finish => 'Finish';

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Yes'
	String get yes => 'Yes';

	/// en: 'No'
	String get no => 'No';

	/// en: 'Read the full story'
	String get readFullStory => 'Read the full story';

	/// en: 'Dismiss'
	String get dismiss => 'Dismiss';

	/// en: 'You are offline – viewing cached content'
	String get offlineBannerMessage => 'You are offline – viewing cached content';

	/// en: 'Back online'
	String get backOnline => 'Back online';
}

// Path: navigation
class TranslationsNavigationEn {
	TranslationsNavigationEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Explore'
	String get home => 'Explore';

	/// en: 'Stories'
	String get stories => 'Stories';

	/// en: 'Chat'
	String get chat => 'Chat';

	/// en: 'Map'
	String get map => 'Map';

	/// en: 'Social'
	String get community => 'Social';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'MyItihas'
	String get title => 'MyItihas';

	/// en: 'Story Generator'
	String get storyGenerator => 'Story Generator';

	/// en: 'ChatItihas'
	String get chatItihas => 'ChatItihas';

	/// en: 'Community Stories'
	String get communityStories => 'Community Stories';

	/// en: 'Maps'
	String get maps => 'Maps';

	/// en: 'Good Morning'
	String get greetingMorning => 'Good Morning';

	/// en: 'Continue reading'
	String get continueReading => 'Continue reading';

	/// en: 'Good Afternoon'
	String get greetingAfternoon => 'Good Afternoon';

	/// en: 'Good Evening'
	String get greetingEvening => 'Good Evening';

	/// en: 'Good Night'
	String get greetingNight => 'Good Night';

	/// en: 'Explore Stories'
	String get exploreStories => 'Explore Stories';

	/// en: 'Generate Story'
	String get generateStory => 'Generate Story';

	/// en: 'Home Content'
	String get content => 'Home Content';
}

// Path: homeScreen
class TranslationsHomeScreenEn {
	TranslationsHomeScreenEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hello'
	String get greeting => 'Hello';

	/// en: 'Quote of the Day'
	String get quoteOfTheDay => 'Quote of the Day';

	/// en: 'Share Quote'
	String get shareQuote => 'Share Quote';

	/// en: 'Copy Quote'
	String get copyQuote => 'Copy Quote';

	/// en: 'Quote copied to clipboard'
	String get quoteCopied => 'Quote copied to clipboard';

	/// en: 'Featured Stories'
	String get featuredStories => 'Featured Stories';

	/// en: 'Quick Actions'
	String get quickActions => 'Quick Actions';

	/// en: 'Generate Story'
	String get generateStory => 'Generate Story';

	/// en: 'Chat with Krishna'
	String get chatWithKrishna => 'Chat with Krishna';

	/// en: 'My Activity'
	String get myActivity => 'My Activity';

	/// en: 'Continue Reading'
	String get continueReading => 'Continue Reading';

	/// en: 'Saved Stories'
	String get savedStories => 'Saved Stories';

	/// en: 'Explore Myitihas'
	String get exploreMyitihas => 'Explore Myitihas';

	/// en: 'Stories in your language'
	String get storiesInYourLanguage => 'Stories in your language';

	/// en: 'See All'
	String get seeAll => 'See All';

	/// en: 'Start Reading'
	String get startReading => 'Start Reading';

	/// en: 'Explore stories to start your journey'
	String get exploreStories => 'Explore stories to start your journey';

	/// en: 'Bookmark stories you love'
	String get saveForLater => 'Bookmark stories you love';

	/// en: 'No activity yet'
	String get noActivityYet => 'No activity yet';

	/// en: '{{count}} min left'
	String minLeft({required Object count}) => '${count} min left';

	/// en: 'Activity History'
	String get activityHistory => 'Activity History';

	/// en: 'Generated a story'
	String get storyGenerated => 'Generated a story';

	/// en: 'Read a story'
	String get storyRead => 'Read a story';

	/// en: 'Bookmarked a story'
	String get storyBookmarked => 'Bookmarked a story';

	/// en: 'Shared a story'
	String get storyShared => 'Shared a story';

	/// en: 'Completed a story'
	String get storyCompleted => 'Completed a story';

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';

	/// en: 'This Week'
	String get thisWeek => 'This Week';

	/// en: 'Earlier'
	String get earlier => 'Earlier';

	/// en: 'Nothing to read yet'
	String get noContinueReading => 'Nothing to read yet';

	/// en: 'No saved stories yet'
	String get noSavedStories => 'No saved stories yet';

	/// en: 'Bookmark stories to save them'
	String get bookmarkStoriesToSave => 'Bookmark stories to save them';

	/// en: 'My Stories'
	String get myGeneratedStories => 'My Stories';

	/// en: 'No stories created yet'
	String get noGeneratedStoriesYet => 'No stories created yet';

	/// en: 'Generate your first story using AI'
	String get createYourFirstStory => 'Generate your first story using AI';

	/// en: 'Share to Feed'
	String get shareToFeed => 'Share to Feed';

	/// en: 'Story shared to feed'
	String get sharedToFeed => 'Story shared to feed';

	/// en: 'Share Story'
	String get shareStoryTitle => 'Share Story';

	/// en: 'Add a caption for your story (optional)'
	String get shareStoryMessage => 'Add a caption for your story (optional)';

	/// en: 'Caption'
	String get shareStoryCaption => 'Caption';

	/// en: 'What would you like to say about this story?'
	String get shareStoryHint => 'What would you like to say about this story?';

	/// en: 'Explore Heritage'
	String get exploreHeritageTitle => 'Explore Heritage';

	/// en: 'Discover cultural heritage sites on the map'
	String get exploreHeritageDesc => 'Discover cultural heritage sites on the map';

	/// en: 'Next visit?'
	String get whereToVisit => 'Next visit?';

	/// en: 'Scriptures'
	String get scriptures => 'Scriptures';

	/// en: 'Explore sacred sites'
	String get exploreSacredSites => 'Explore sacred sites';

	/// en: 'Read stories'
	String get readStories => 'Read stories';

	/// en: 'Yes, remind me'
	String get yesRemindMe => 'Yes, remind me';

	/// en: 'No, don't show again'
	String get noDontShowAgain => 'No, don\'t show again';

	/// en: 'Hide Discover MyItihas?'
	String get discoverDismissTitle => 'Hide Discover MyItihas?';

	/// en: 'Would you like to see this again next time you open or login to the app?'
	String get discoverDismissMessage => 'Would you like to see this again next time you open or login to the app?';

	/// en: 'Discover MyItihas'
	String get discoverCardTitle => 'Discover MyItihas';

	/// en: 'Stories from ancient scriptures, sacred sites to explore, and wisdom at your fingertips.'
	String get discoverCardSubtitle => 'Stories from ancient scriptures, sacred sites to explore, and wisdom at your fingertips.';

	/// en: 'Swipe up to dismiss'
	String get swipeToDismiss => 'Swipe up to dismiss';

	/// en: 'Search scriptures...'
	String get searchScriptures => 'Search scriptures...';

	/// en: 'Search languages...'
	String get searchLanguages => 'Search languages...';

	/// en: 'Explore Stories'
	String get exploreStoriesLabel => 'Explore Stories';

	/// en: 'Explore more'
	String get exploreMore => 'Explore more';

	/// en: 'Failed to load activity'
	String get failedToLoadActivity => 'Failed to load activity';

	/// en: 'Start reading or generating stories to see your activity here'
	String get startReadingOrGenerating => 'Start reading or generating stories to see your activity here';

	late final TranslationsHomeScreenHeroEn hero = TranslationsHomeScreenHeroEn.internal(_root);
}

// Path: stories
class TranslationsStoriesEn {
	TranslationsStoriesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Stories'
	String get title => 'Stories';

	/// en: 'Discover tales from scriptures'
	String get subtitle => 'Discover tales from scriptures';

	/// en: 'Search by title or author...'
	String get searchHint => 'Search by title or author...';

	/// en: 'Sort by'
	String get sortBy => 'Sort by';

	/// en: 'Newest First'
	String get sortNewest => 'Newest First';

	/// en: 'Oldest First'
	String get sortOldest => 'Oldest First';

	/// en: 'Most Popular'
	String get sortPopular => 'Most Popular';

	/// en: 'No stories found'
	String get noStories => 'No stories found';

	/// en: 'Try a different search or filter to discover stories.'
	String get noStoriesHint => 'Try a different search or filter to discover stories.';

	/// en: 'Loading stories...'
	String get loadingStories => 'Loading stories...';

	/// en: 'Failed to load stories'
	String get errorLoadingStories => 'Failed to load stories';

	/// en: 'Featured'
	String get featured => 'Featured';

	/// en: 'Story Details'
	String get storyDetails => 'Story Details';

	/// en: 'Continue reading'
	String get continueReading => 'Continue reading';

	/// en: 'Read More'
	String get readMore => 'Read More';

	/// en: 'Read Less'
	String get readLess => 'Read Less';

	/// en: 'Author'
	String get author => 'Author';

	/// en: 'Published on'
	String get publishedOn => 'Published on';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Tags'
	String get tags => 'Tags';

	/// en: 'Failed to load story'
	String get failedToLoad => 'Failed to load story';
}

// Path: storyGenerator
class TranslationsStoryGeneratorEn {
	TranslationsStoryGeneratorEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Story Generator'
	String get title => 'Story Generator';

	/// en: 'Create your own scriptural story'
	String get subtitle => 'Create your own scriptural story';

	/// en: 'Quick Start'
	String get quickStart => 'Quick Start';

	/// en: 'Interactive'
	String get interactive => 'Interactive';

	/// en: 'Raw Prompt'
	String get rawPrompt => 'Raw Prompt';

	/// en: 'Your Story Prompt'
	String get yourStoryPrompt => 'Your Story Prompt';

	/// en: 'Write Your Prompt'
	String get writeYourPrompt => 'Write Your Prompt';

	/// en: 'Select Scripture'
	String get selectScripture => 'Select Scripture';

	/// en: 'Select Story Type'
	String get selectStoryType => 'Select Story Type';

	/// en: 'Select Character'
	String get selectCharacter => 'Select Character';

	/// en: 'Select Theme'
	String get selectTheme => 'Select Theme';

	/// en: 'Select Setting'
	String get selectSetting => 'Select Setting';

	/// en: 'Select Language'
	String get selectLanguage => 'Select Language';

	/// en: 'Story Length'
	String get selectLength => 'Story Length';

	/// en: 'More Options'
	String get moreOptions => 'More Options';

	/// en: 'Random'
	String get random => 'Random';

	/// en: 'Generate Story'
	String get generate => 'Generate Story';

	/// en: 'Generating your story...'
	String get generating => 'Generating your story...';

	/// en: 'Creating Your Story'
	String get creatingYourStory => 'Creating Your Story';

	/// en: 'Consulting the ancient scriptures...'
	String get consultingScriptures => 'Consulting the ancient scriptures...';

	/// en: 'Weaving your tale...'
	String get weavingTale => 'Weaving your tale...';

	/// en: 'Adding divine wisdom...'
	String get addingWisdom => 'Adding divine wisdom...';

	/// en: 'Polishing the narrative...'
	String get polishingNarrative => 'Polishing the narrative...';

	/// en: 'Almost there...'
	String get almostThere => 'Almost there...';

	/// en: 'Your Generated Story'
	String get generatedStory => 'Your Generated Story';

	/// en: 'AI Generated'
	String get aiGenerated => 'AI Generated';

	/// en: 'Regenerate'
	String get regenerate => 'Regenerate';

	/// en: 'Save Story'
	String get saveStory => 'Save Story';

	/// en: 'Share Story'
	String get shareStory => 'Share Story';

	/// en: 'New Story'
	String get newStory => 'New Story';

	/// en: 'Saved'
	String get saved => 'Saved';

	/// en: 'Story saved to your library'
	String get storySaved => 'Story saved to your library';

	/// en: 'Story'
	String get story => 'Story';

	/// en: 'Lesson'
	String get lesson => 'Lesson';

	/// en: 'Did You Know?'
	String get didYouKnow => 'Did You Know?';

	/// en: 'Activity'
	String get activity => 'Activity';

	/// en: 'Optional: Refine with options'
	String get optionalRefine => 'Optional: Refine with options';

	/// en: 'Apply Options'
	String get applyOptions => 'Apply Options';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Story Format'
	String get storyFormat => 'Story Format';

	/// en: 'Story generation requires internet connection'
	String get requiresInternet => 'Story generation requires internet connection';

	/// en: 'Story not available offline. Connect to internet to view.'
	String get notAvailableOffline => 'Story not available offline. Connect to internet to view.';

	/// en: 'AI may make mistakes. We are improving and your feedback matters.'
	String get aiDisclaimer => 'AI may make mistakes. We are improving and your feedback matters.';

	late final TranslationsStoryGeneratorStoryLengthEn storyLength = TranslationsStoryGeneratorStoryLengthEn.internal(_root);
	late final TranslationsStoryGeneratorFormatEn format = TranslationsStoryGeneratorFormatEn.internal(_root);
	late final TranslationsStoryGeneratorHintsEn hints = TranslationsStoryGeneratorHintsEn.internal(_root);
	late final TranslationsStoryGeneratorErrorsEn errors = TranslationsStoryGeneratorErrorsEn.internal(_root);
}

// Path: chat
class TranslationsChatEn {
	TranslationsChatEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ChatItihas'
	String get title => 'ChatItihas';

	/// en: 'Chat with AI about scriptures'
	String get subtitle => 'Chat with AI about scriptures';

	/// en: 'Friend Mode'
	String get friendMode => 'Friend Mode';

	/// en: 'Philosophical Mode'
	String get philosophicalMode => 'Philosophical Mode';

	/// en: 'Type your message...'
	String get typeMessage => 'Type your message...';

	/// en: 'Send'
	String get send => 'Send';

	/// en: 'New Chat'
	String get newChat => 'New Chat';

	/// en: 'Chats'
	String get chatsTab => 'Chats';

	/// en: 'Groups'
	String get groupsTab => 'Groups';

	/// en: 'Chats'
	String get chatHistory => 'Chats';

	/// en: 'Clear Chat'
	String get clearChat => 'Clear Chat';

	/// en: 'No messages yet. Start a conversation!'
	String get noMessages => 'No messages yet. Start a conversation!';

	/// en: 'Chat List Page'
	String get listPage => 'Chat List Page';

	/// en: 'Forward message to...'
	String get forwardMessageTo => 'Forward message to...';

	/// en: 'Forward message'
	String get forwardMessage => 'Forward message';

	/// en: 'Message forwarded'
	String get messageForwarded => 'Message forwarded';

	/// en: 'Failed to forward message: {{error}}'
	String failedToForward({required Object error}) => 'Failed to forward message: ${error}';

	/// en: 'Search chats'
	String get searchChats => 'Search chats';

	/// en: 'No chats found'
	String get noChatsFound => 'No chats found';

	/// en: 'Requests'
	String get requests => 'Requests';

	/// en: 'Message requests'
	String get messageRequests => 'Message requests';

	/// en: 'Group requests'
	String get groupRequests => 'Group requests';

	/// en: 'Request sent. They’ll see it in Requests.'
	String get requestSent => 'Request sent. They’ll see it in Requests.';

	/// en: 'Wants to chat'
	String get wantsToChat => 'Wants to chat';

	/// en: '{{name}} added you'
	String addedYouTo({required Object name}) => '${name} added you';

	/// en: 'Accept'
	String get accept => 'Accept';

	/// en: 'No message requests'
	String get noMessageRequests => 'No message requests';

	/// en: 'No group requests'
	String get noGroupRequests => 'No group requests';

	/// en: 'Invite(s) sent. They’ll see them in Requests.'
	String get invitesSent => 'Invite(s) sent. They’ll see them in Requests.';

	/// en: 'You can't message this user'
	String get cantMessageUser => 'You can\'t message this user';

	/// en: 'Delete Chat'
	String get deleteChat => 'Delete Chat';

	/// en: 'Delete Chats'
	String get deleteChats => 'Delete Chats';

	/// en: 'Block user'
	String get blockUser => 'Block user';

	/// en: 'Report user'
	String get reportUser => 'Report user';

	/// en: 'Mark as read'
	String get markAsRead => 'Mark as read';

	/// en: 'Marked as read'
	String get markedAsRead => 'Marked as read';

	/// en: 'Delete / Clear chat'
	String get deleteClearChat => 'Delete / Clear chat';

	/// en: 'Delete Conversation'
	String get deleteConversation => 'Delete Conversation';

	/// en: 'Reason (required)'
	String get reasonRequired => 'Reason (required)';

	/// en: 'Submit'
	String get submit => 'Submit';

	/// en: 'User reported. Thank you.'
	String get userReportedBlocked => 'User reported. Thank you.';

	/// en: 'Failed to report: {{error}}'
	String reportFailed({required Object error}) => 'Failed to report: ${error}';

	/// en: 'New Group'
	String get newGroup => 'New Group';

	/// en: 'Message someone directly'
	String get messageSomeoneDirectly => 'Message someone directly';

	/// en: 'Create a group conversation'
	String get createGroupConversation => 'Create a group conversation';

	/// en: 'No groups yet'
	String get noGroupsYet => 'No groups yet';

	/// en: 'No chats yet'
	String get noChatsYet => 'No chats yet';

	/// en: 'Tap + to create or join a group'
	String get tapToCreateGroup => 'Tap + to create or join a group';

	/// en: 'Tap + to start a new conversation'
	String get tapToStartConversation => 'Tap + to start a new conversation';

	/// en: 'Conversation deleted'
	String get conversationDeleted => 'Conversation deleted';

	/// en: '{{count}} conversation(s) deleted'
	String conversationsDeleted({required Object count}) => '${count} conversation(s) deleted';

	/// en: 'Search conversations...'
	String get searchConversations => 'Search conversations...';

	/// en: 'Please connect to the internet and try again.'
	String get connectToInternet => 'Please connect to the internet and try again.';

	/// en: 'Little Krishna'
	String get littleKrishnaName => 'Little Krishna';

	/// en: 'New Conversation'
	String get newConversation => 'New Conversation';

	/// en: 'No conversations yet'
	String get noConversationsYet => 'No conversations yet';

	/// en: 'Confirm Deletion'
	String get confirmDeletion => 'Confirm Deletion';

	/// en: 'Are you sure you want to delete {{title}}?'
	String deleteConversationConfirm({required Object title}) => 'Are you sure you want to delete ${title}?';

	/// en: 'Failed to delete conversation'
	String get deleteFailed => 'Failed to delete conversation';

	/// en: 'Full chat copied to clipboard!'
	String get fullChatCopied => 'Full chat copied to clipboard!';

	/// en: 'I'm having trouble connecting right now. Please try again in a moment.'
	String get connectionErrorFallback => 'I\'m having trouble connecting right now. Please try again in a moment.';

	/// en: 'Hey, {{name}}. I'm Krishna, your friend. How are you doing today?'
	String krishnaWelcomeWithName({required Object name}) => 'Hey, ${name}. I\'m Krishna, your friend. How are you doing today?';

	/// en: 'Hey, my dear friend. I'm Krishna, your friend. How are you doing today?'
	String get krishnaWelcomeFriend => 'Hey, my dear friend. I\'m Krishna, your friend. How are you doing today?';

	late final TranslationsChatSuggestionsEn suggestions = TranslationsChatSuggestionsEn.internal(_root);

	/// en: 'You'
	String get copyYouLabel => 'You';

	/// en: 'Krishna'
	String get copyKrishnaLabel => 'Krishna';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Your friendly companion'
	String get yourFriendlyCompanion => 'Your friendly companion';

	/// en: 'Mental health support'
	String get mentalHealthSupport => 'Mental health support';

	/// en: 'A safe space to share thoughts and feel heard.'
	String get mentalHealthSupportSubtitle => 'A safe space to share thoughts and feel heard.';

	/// en: 'Friendly companion'
	String get friendlyCompanion => 'Friendly companion';

	/// en: 'Always here to chat, encourage, and offer wisdom.'
	String get friendlyCompanionSubtitle => 'Always here to chat, encourage, and offer wisdom.';

	/// en: 'Stories & wisdom'
	String get storiesAndWisdom => 'Stories & wisdom';

	/// en: 'Learn from timeless tales and practical insights.'
	String get storiesAndWisdomSubtitle => 'Learn from timeless tales and practical insights.';

	/// en: 'Ask anything'
	String get askAnything => 'Ask anything';

	/// en: 'Get gentle, thoughtful answers to your questions.'
	String get askAnythingSubtitle => 'Get gentle, thoughtful answers to your questions.';

	/// en: 'Start chatting'
	String get startChatting => 'Start chatting';

	/// en: 'Maybe later'
	String get maybeLater => 'Maybe later';

	late final TranslationsChatComposerAttachmentsEn composerAttachments = TranslationsChatComposerAttachmentsEn.internal(_root);
}

// Path: map
class TranslationsMapEn {
	TranslationsMapEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Akhanda Bharata'
	String get title => 'Akhanda Bharata';

	/// en: 'Explore historical locations'
	String get subtitle => 'Explore historical locations';

	/// en: 'Search location...'
	String get searchLocation => 'Search location...';

	/// en: 'View Details'
	String get viewDetails => 'View Details';

	/// en: 'View sites'
	String get viewSites => 'View sites';

	/// en: 'Show Route'
	String get showRoute => 'Show Route';

	/// en: 'Historical Information'
	String get historicalInfo => 'Historical Information';

	/// en: 'Nearby Places'
	String get nearbyPlaces => 'Nearby Places';

	/// en: 'Pick location on map'
	String get pickLocationOnMap => 'Pick location on map';

	/// en: 'Sites Visited'
	String get sitesVisited => 'Sites Visited';

	/// en: 'Badges Earned'
	String get badgesEarned => 'Badges Earned';

	/// en: 'Completion Rate'
	String get completionRate => 'Completion Rate';

	/// en: 'Add to Journey'
	String get addToJourney => 'Add to Journey';

	/// en: 'Added to Journey'
	String get addedToJourney => 'Added to Journey';

	/// en: 'Get Directions'
	String get getDirections => 'Get Directions';

	/// en: 'View in Map'
	String get viewInMap => 'View in Map';

	/// en: 'Directions'
	String get directions => 'Directions';

	/// en: 'Photo Gallery'
	String get photoGallery => 'Photo Gallery';

	/// en: 'View All'
	String get viewAll => 'View All';

	/// en: 'Photo saved to gallery'
	String get photoSavedToGallery => 'Photo saved to gallery';

	/// en: 'Sacred Soundscape'
	String get sacredSoundscape => 'Sacred Soundscape';

	/// en: 'All Discussions'
	String get allDiscussions => 'All Discussions';

	/// en: 'Journey'
	String get journeyTab => 'Journey';

	/// en: 'Discussion'
	String get discussionTab => 'Discussion';

	/// en: 'My Activity'
	String get myActivity => 'My Activity';

	/// en: 'Anonymous Pilgrim'
	String get anonymousPilgrim => 'Anonymous Pilgrim';

	/// en: 'View Profile'
	String get viewProfile => 'View Profile';

	/// en: 'Discussion title...'
	String get discussionTitleHint => 'Discussion title...';

	/// en: 'Share your thoughts...'
	String get shareYourThoughtsHint => 'Share your thoughts...';

	/// en: 'Hashtags'
	String get hashtagsLabel => 'Hashtags';

	/// en: 'Add hashtag (e.g. '
	String get hashtagsHintIntro => 'Add hashtag (e.g. ';

	/// en: ')'
	String get hashtagsHintOutro => ')';

	/// en: 'Use only letters and numbers'
	String get invalidHashtagLabel => 'Use only letters and numbers';

	/// en: 'You can add up to 5 hashtags'
	String get hashtagMaxLimitReached => 'You can add up to 5 hashtags';

	/// en: 'Up to 5 hashtags. Location tags are auto-added when available.'
	String get hashtagLimitHint => 'Up to 5 hashtags. Location tags are auto-added when available.';

	/// en: 'Please enter a discussion title'
	String get pleaseEnterDiscussionTitle => 'Please enter a discussion title';

	late final TranslationsMapDiscussionsEn discussions = TranslationsMapDiscussionsEn.internal(_root);

	/// en: 'Add Reflection'
	String get addReflection => 'Add Reflection';

	/// en: 'Title'
	String get reflectionTitle => 'Title';

	/// en: 'Enter reflection title'
	String get enterReflectionTitle => 'Enter reflection title';

	/// en: 'Please enter a title'
	String get pleaseEnterTitle => 'Please enter a title';

	/// en: 'Site Name'
	String get siteName => 'Site Name';

	/// en: 'Enter sacred site name'
	String get enterSacredSiteName => 'Enter sacred site name';

	/// en: 'Please enter site name'
	String get pleaseEnterSiteName => 'Please enter site name';

	/// en: 'Reflection'
	String get reflection => 'Reflection';

	/// en: 'Share your thoughts and experiences...'
	String get reflectionHint => 'Share your thoughts and experiences...';

	/// en: 'Please enter your reflection'
	String get pleaseEnterReflection => 'Please enter your reflection';

	/// en: 'Save Reflection'
	String get saveReflection => 'Save Reflection';

	/// en: 'Journey Progress'
	String get journeyProgress => 'Journey Progress';

	late final TranslationsMapFabricMapEn fabricMap = TranslationsMapFabricMapEn.internal(_root);
	late final TranslationsMapClassicalArtMapEn classicalArtMap = TranslationsMapClassicalArtMapEn.internal(_root);
	late final TranslationsMapClassicalDanceMapEn classicalDanceMap = TranslationsMapClassicalDanceMapEn.internal(_root);
	late final TranslationsMapFoodMapEn foodMap = TranslationsMapFoodMapEn.internal(_root);
}

// Path: community
class TranslationsCommunityEn {
	TranslationsCommunityEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Community'
	String get title => 'Community';

	/// en: 'Trending'
	String get trending => 'Trending';

	/// en: 'Following'
	String get following => 'Following';

	/// en: 'Followers'
	String get followers => 'Followers';

	/// en: 'Posts'
	String get posts => 'Posts';

	/// en: 'Follow'
	String get follow => 'Follow';

	/// en: 'Unfollow'
	String get unfollow => 'Unfollow';

	/// en: 'Share your story...'
	String get shareYourStory => 'Share your story...';

	/// en: 'Post'
	String get post => 'Post';

	/// en: 'Like'
	String get like => 'Like';

	/// en: 'Comment'
	String get comment => 'Comment';

	/// en: 'Comments'
	String get comments => 'Comments';

	/// en: 'No posts yet'
	String get noPostsYet => 'No posts yet';
}

// Path: discover
class TranslationsDiscoverEn {
	TranslationsDiscoverEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Discover'
	String get title => 'Discover';

	/// en: 'Search stories, users, or topics...'
	String get searchHint => 'Search stories, users, or topics...';

	/// en: 'Try Again'
	String get tryAgain => 'Try Again';

	/// en: 'Something went wrong'
	String get somethingWentWrong => 'Something went wrong';

	/// en: 'Unable to load profiles. Please try again.'
	String get unableToLoadProfiles => 'Unable to load profiles. Please try again.';

	/// en: 'No profiles found'
	String get noProfilesFound => 'No profiles found';

	/// en: 'Search to find people to follow'
	String get searchToFindPeople => 'Search to find people to follow';

	/// en: 'No results found'
	String get noResultsFound => 'No results found';

	/// en: 'No profiles yet'
	String get noProfilesYet => 'No profiles yet';

	/// en: 'Try searching with different keywords'
	String get tryDifferentKeywords => 'Try searching with different keywords';

	/// en: 'Be the first to discover new people!'
	String get beFirstToDiscover => 'Be the first to discover new people!';
}

// Path: plan
class TranslationsPlanEn {
	TranslationsPlanEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign in to save your plan'
	String get signInToSavePlan => 'Sign in to save your plan';

	/// en: 'Plan saved'
	String get planSaved => 'Plan saved';

	/// en: 'From'
	String get from => 'From';

	/// en: 'Dates'
	String get dates => 'Dates';

	/// en: 'Destination'
	String get destination => 'Destination';

	/// en: 'Nearby'
	String get nearby => 'Nearby';

	/// en: 'Generated Plan'
	String get generatedPlan => 'Generated Plan';

	/// en: 'Where are you travelling from?'
	String get whereTravellingFrom => 'Where are you travelling from?';

	/// en: 'Enter your city or region'
	String get enterCityOrRegion => 'Enter your city or region';

	/// en: 'Travel dates'
	String get travelDates => 'Travel dates';

	/// en: 'Destination (sacred site)'
	String get destinationSacredSite => 'Destination (sacred site)';

	/// en: 'Search or select destination...'
	String get searchOrSelectDestination => 'Search or select destination...';

	/// en: 'Share your experience'
	String get shareYourExperience => 'Share your experience';

	/// en: 'Plan shared'
	String get planShared => 'Plan shared';

	/// en: 'Failed to share plan: {{error}}'
	String failedToSharePlan({required Object error}) => 'Failed to share plan: ${error}';

	/// en: 'Plan updated'
	String get planUpdated => 'Plan updated';

	/// en: 'Failed to update plan: {{error}}'
	String failedToUpdatePlan({required Object error}) => 'Failed to update plan: ${error}';

	/// en: 'Delete plan?'
	String get deletePlanConfirm => 'Delete plan?';

	/// en: 'This plan will be permanently deleted.'
	String get thisPlanPermanentlyDeleted => 'This plan will be permanently deleted.';

	/// en: 'Plan deleted'
	String get planDeleted => 'Plan deleted';

	/// en: 'Failed to delete plan: {{error}}'
	String failedToDeletePlan({required Object error}) => 'Failed to delete plan: ${error}';

	/// en: 'Share plan'
	String get sharePlan => 'Share plan';

	/// en: 'Delete plan'
	String get deletePlan => 'Delete plan';

	/// en: 'Saved plan details'
	String get savedPlanDetails => 'Saved plan details';

	/// en: 'Quick bookings'
	String get quickBookings => 'Quick bookings';

	/// en: 'Replan with AI'
	String get replanWithAi => 'Replan with AI';

	/// en: 'Full regenerate'
	String get fullRegenerate => 'Full regenerate';

	/// en: 'Surgical modify'
	String get surgicalModify => 'Surgical modify';

	/// en: 'Train'
	String get travelModeTrain => 'Train';

	/// en: 'Flight'
	String get travelModeFlight => 'Flight';

	/// en: 'Bus'
	String get travelModeBus => 'Bus';

	/// en: 'Hotel'
	String get travelModeHotel => 'Hotel';

	/// en: 'Car'
	String get travelModeCar => 'Car';

	/// en: 'Pilgrimage Plan'
	String get pilgrimagePlan => 'Pilgrimage Plan';

	/// en: 'Plan'
	String get planTab => 'Plan';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'Use system theme'
	String get themeSystem => 'Use system theme';

	/// en: 'Dark Mode'
	String get darkMode => 'Dark Mode';

	/// en: 'Select Language'
	String get selectLanguage => 'Select Language';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Cache & Storage'
	String get cacheSettings => 'Cache & Storage';

	/// en: 'General'
	String get general => 'General';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Blocked Users'
	String get blockedUsers => 'Blocked Users';

	/// en: 'Help & Support'
	String get helpSupport => 'Help & Support';

	/// en: 'Contact Us'
	String get contactUs => 'Contact Us';

	/// en: 'Legal'
	String get legal => 'Legal';

	/// en: 'Privacy Policy'
	String get privacyPolicy => 'Privacy Policy';

	/// en: 'Terms & Conditions'
	String get termsConditions => 'Terms & Conditions';

	/// en: 'Privacy'
	String get privacy => 'Privacy';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Delete Account'
	String get deleteAccount => 'Delete Account';

	/// en: 'Delete Account'
	String get deleteAccountTitle => 'Delete Account';

	/// en: 'This action cannot be undone!'
	String get deleteAccountWarning => 'This action cannot be undone!';

	/// en: 'Deleting your account will permanently remove all your posts, comments, profile, followers, saved stories, bookmarks, chat messages, and generated stories.'
	String get deleteAccountDescription => 'Deleting your account will permanently remove all your posts, comments, profile, followers, saved stories, bookmarks, chat messages, and generated stories.';

	/// en: 'Confirm Your Password'
	String get confirmPassword => 'Confirm Your Password';

	/// en: 'Enter your password to confirm account deletion.'
	String get confirmPasswordDesc => 'Enter your password to confirm account deletion.';

	/// en: 'You will be redirected to Google to verify your identity.'
	String get googleReauth => 'You will be redirected to Google to verify your identity.';

	/// en: 'Final Confirmation'
	String get finalConfirmationTitle => 'Final Confirmation';

	/// en: 'Are you absolutely sure? This is permanent and cannot be reversed.'
	String get finalConfirmation => 'Are you absolutely sure? This is permanent and cannot be reversed.';

	/// en: 'Delete My Account'
	String get deleteMyAccount => 'Delete My Account';

	/// en: 'Deleting account...'
	String get deletingAccount => 'Deleting account...';

	/// en: 'Your account has been permanently deleted.'
	String get accountDeleted => 'Your account has been permanently deleted.';

	/// en: 'Failed to delete account. Please try again.'
	String get deleteAccountFailed => 'Failed to delete account. Please try again.';

	/// en: 'Downloaded Stories'
	String get downloadedStories => 'Downloaded Stories';

	/// en: 'Could not open email app. Please email us at: myitihas@gmail.com'
	String get couldNotOpenEmail => 'Could not open email app. Please email us at: myitihas@gmail.com';

	/// en: 'Could not open {{label}} right now.'
	String couldNotOpenLabel({required Object label}) => 'Could not open ${label} right now.';

	/// en: 'Logout'
	String get logoutTitle => 'Logout';

	/// en: 'Are you sure you want to logout?'
	String get logoutConfirm => 'Are you sure you want to logout?';

	/// en: 'Verify Your Identity'
	String get verifyYourIdentity => 'Verify Your Identity';

	/// en: 'You will be asked to sign in with Google to verify your identity.'
	String get verifyYourIdentityDesc => 'You will be asked to sign in with Google to verify your identity.';

	/// en: 'Continue with Google'
	String get continueWithGoogle => 'Continue with Google';

	/// en: 'Re-authentication failed: {{error}}'
	String reauthFailed({required Object error}) => 'Re-authentication failed: ${error}';

	/// en: 'Password is required'
	String get passwordRequired => 'Password is required';

	/// en: 'Invalid password. Please try again.'
	String get invalidPassword => 'Invalid password. Please try again.';

	/// en: 'Verify'
	String get verify => 'Verify';

	/// en: 'Continue'
	String get continueLabel => 'Continue';

	/// en: 'Unable to verify identity. Please try again.'
	String get unableToVerifyIdentity => 'Unable to verify identity. Please try again.';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Sign Up'
	String get signup => 'Sign Up';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Confirm Password'
	String get confirmPassword => 'Confirm Password';

	/// en: 'Forgot Password?'
	String get forgotPassword => 'Forgot Password?';

	/// en: 'Reset Password'
	String get resetPassword => 'Reset Password';

	/// en: 'Don't have an account?'
	String get dontHaveAccount => 'Don\'t have an account?';

	/// en: 'Already have an account?'
	String get alreadyHaveAccount => 'Already have an account?';

	/// en: 'Login successful'
	String get loginSuccess => 'Login successful';

	/// en: 'Sign up successful'
	String get signupSuccess => 'Sign up successful';

	/// en: 'Login failed'
	String get loginError => 'Login failed';

	/// en: 'Sign up failed'
	String get signupError => 'Sign up failed';
}

// Path: error
class TranslationsErrorEn {
	TranslationsErrorEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No internet connection'
	String get network => 'No internet connection';

	/// en: 'Server error occurred'
	String get server => 'Server error occurred';

	/// en: 'Failed to load cached data'
	String get cache => 'Failed to load cached data';

	/// en: 'Request timed out'
	String get timeout => 'Request timed out';

	/// en: 'Resource not found'
	String get notFound => 'Resource not found';

	/// en: 'Validation failed'
	String get validation => 'Validation failed';

	/// en: 'An unexpected error occurred'
	String get unexpected => 'An unexpected error occurred';

	/// en: 'Please try again'
	String get tryAgain => 'Please try again';

	/// en: 'Could not open link: {{url}}'
	String couldNotOpenLink({required Object url}) => 'Could not open link: ${url}';
}

// Path: subscription
class TranslationsSubscriptionEn {
	TranslationsSubscriptionEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Free'
	String get free => 'Free';

	/// en: 'Plus'
	String get plus => 'Plus';

	/// en: 'Pro'
	String get pro => 'Pro';

	/// en: 'Upgrade to Pro'
	String get upgradeToPro => 'Upgrade to Pro';

	/// en: 'Features'
	String get features => 'Features';

	/// en: 'Subscribe'
	String get subscribe => 'Subscribe';

	/// en: 'Current Plan'
	String get currentPlan => 'Current Plan';

	/// en: 'Manage Plan'
	String get managePlan => 'Manage Plan';
}

// Path: notification
class TranslationsNotificationEn {
	TranslationsNotificationEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications'
	String get title => 'Notifications';

	/// en: 'People to connect'
	String get peopleToConnect => 'People to connect';

	/// en: 'Discover people to follow'
	String get peopleToConnectSubtitle => 'Discover people to follow';

	/// en: 'You can follow again in {{minutes}} minutes'
	String followAgainInMinutes({required Object minutes}) => 'You can follow again in ${minutes} minutes';

	/// en: 'No suggestions right now'
	String get noSuggestions => 'No suggestions right now';

	/// en: 'Mark all read'
	String get markAllRead => 'Mark all read';

	/// en: 'No notifications yet'
	String get noNotifications => 'No notifications yet';

	/// en: 'When someone interacts with your stories, you'll see it here'
	String get noNotificationsSubtitle => 'When someone interacts with your stories, you\'ll see it here';

	/// en: 'Error:'
	String get errorPrefix => 'Error:';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: '{{actorName}} liked your story'
	String likedYourStory({required Object actorName}) => '${actorName} liked your story';

	/// en: '{{actorName}} commented on your story'
	String commentedOnYourStory({required Object actorName}) => '${actorName} commented on your story';

	/// en: '{{actorName}} replied to your comment'
	String repliedToYourComment({required Object actorName}) => '${actorName} replied to your comment';

	/// en: '{{actorName}} started following you'
	String startedFollowingYou({required Object actorName}) => '${actorName} started following you';

	/// en: '{{actorName}} sent you a message'
	String sentYouAMessage({required Object actorName}) => '${actorName} sent you a message';

	/// en: '{{actorName}} shared your story'
	String sharedYourStory({required Object actorName}) => '${actorName} shared your story';

	/// en: '{{actorName}} reposted your story'
	String repostedYourStory({required Object actorName}) => '${actorName} reposted your story';

	/// en: '{{actorName}} mentioned you'
	String mentionedYou({required Object actorName}) => '${actorName} mentioned you';

	/// en: 'New post from {{actorName}}'
	String newPostFrom({required Object actorName}) => 'New post from ${actorName}';

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'This Week'
	String get thisWeek => 'This Week';

	/// en: 'Earlier'
	String get earlier => 'Earlier';

	/// en: 'Delete'
	String get delete => 'Delete';
}

// Path: profile
class TranslationsProfileEn {
	TranslationsProfileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Followers'
	String get followers => 'Followers';

	/// en: 'Following'
	String get following => 'Following';

	/// en: 'Unfollow'
	String get unfollow => 'Unfollow';

	/// en: 'Follow'
	String get follow => 'Follow';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Stories'
	String get stories => 'Stories';

	/// en: 'Unable to share image'
	String get unableToShareImage => 'Unable to share image';

	/// en: 'Image saved to Photos'
	String get imageSavedToPhotos => 'Image saved to Photos';

	/// en: 'View'
	String get view => 'View';

	/// en: 'Save to Photos'
	String get saveToPhotos => 'Save to Photos';

	/// en: 'Failed to load image'
	String get failedToLoadImage => 'Failed to load image';
}

// Path: feed
class TranslationsFeedEn {
	TranslationsFeedEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading stories...'
	String get loading => 'Loading stories...';

	/// en: 'Loading posts...'
	String get loadingPosts => 'Loading posts...';

	/// en: 'Loading videos...'
	String get loadingVideos => 'Loading videos...';

	/// en: 'Loading stories...'
	String get loadingStories => 'Loading stories...';

	/// en: 'Oops! Something went wrong'
	String get errorTitle => 'Oops! Something went wrong';

	/// en: 'Try Again'
	String get tryAgain => 'Try Again';

	/// en: 'No stories available'
	String get noStoriesAvailable => 'No stories available';

	/// en: 'No image posts available'
	String get noImagesAvailable => 'No image posts available';

	/// en: 'No text posts available'
	String get noTextPostsAvailable => 'No text posts available';

	/// en: 'No content available'
	String get noContentAvailable => 'No content available';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Comments'
	String get comments => 'Comments';

	/// en: 'Comments coming soon'
	String get commentsComingSoon => 'Comments coming soon';

	/// en: 'Add a comment...'
	String get addCommentHint => 'Add a comment...';

	/// en: 'Share Story'
	String get shareStory => 'Share Story';

	/// en: 'Share Post'
	String get sharePost => 'Share Post';

	/// en: 'Share Thought'
	String get shareThought => 'Share Thought';

	/// en: 'Share as Image'
	String get shareAsImage => 'Share as Image';

	/// en: 'Create a beautiful preview card'
	String get shareAsImageSubtitle => 'Create a beautiful preview card';

	/// en: 'Share Link'
	String get shareLink => 'Share Link';

	/// en: 'Copy or share the story link'
	String get shareLinkSubtitle => 'Copy or share the story link';

	/// en: 'Copy or share the post link'
	String get shareImageLinkSubtitle => 'Copy or share the post link';

	/// en: 'Copy or share the thought link'
	String get shareTextLinkSubtitle => 'Copy or share the thought link';

	/// en: 'Share as Text'
	String get shareAsText => 'Share as Text';

	/// en: 'Share the story excerpt'
	String get shareAsTextSubtitle => 'Share the story excerpt';

	/// en: 'Share Quote'
	String get shareQuote => 'Share Quote';

	/// en: 'Share as a quotable text'
	String get shareQuoteSubtitle => 'Share as a quotable text';

	/// en: 'Share with Image'
	String get shareWithImage => 'Share with Image';

	/// en: 'Share the image with caption'
	String get shareWithImageSubtitle => 'Share the image with caption';

	/// en: 'Copy Link'
	String get copyLink => 'Copy Link';

	/// en: 'Copy link to clipboard'
	String get copyLinkSubtitle => 'Copy link to clipboard';

	/// en: 'Copy Text'
	String get copyText => 'Copy Text';

	/// en: 'Copy the quote to clipboard'
	String get copyTextSubtitle => 'Copy the quote to clipboard';

	/// en: 'Link copied to clipboard'
	String get linkCopied => 'Link copied to clipboard';

	/// en: 'Text copied to clipboard'
	String get textCopied => 'Text copied to clipboard';

	/// en: 'Send to User'
	String get sendToUser => 'Send to User';

	/// en: 'Share directly with a friend'
	String get sendToUserSubtitle => 'Share directly with a friend';

	/// en: 'Choose Format'
	String get chooseFormat => 'Choose Format';

	/// en: 'Link Preview'
	String get linkPreview => 'Link Preview';

	/// en: '1200 × 630'
	String get linkPreviewSize => '1200 × 630';

	/// en: 'Story Format'
	String get storyFormat => 'Story Format';

	/// en: '1080 × 1920 (Instagram/Stories)'
	String get storyFormatSize => '1080 × 1920 (Instagram/Stories)';

	/// en: 'Generating preview...'
	String get generatingPreview => 'Generating preview...';

	/// en: 'Bookmarked'
	String get bookmarked => 'Bookmarked';

	/// en: 'Removed from bookmarks'
	String get removedFromBookmarks => 'Removed from bookmarks';

	/// en: 'Unlike, {{count}} likes'
	String unlike({required Object count}) => 'Unlike, ${count} likes';

	/// en: 'Like, {{count}} likes'
	String like({required Object count}) => 'Like, ${count} likes';

	/// en: '{{count}} comments'
	String commentCount({required Object count}) => '${count} comments';

	/// en: 'Share, {{count}} shares'
	String shareCount({required Object count}) => 'Share, ${count} shares';

	/// en: 'Remove bookmark'
	String get removeBookmark => 'Remove bookmark';

	/// en: 'Bookmark'
	String get addBookmark => 'Bookmark';

	/// en: 'Quote'
	String get quote => 'Quote';

	/// en: 'Quote copied to clipboard'
	String get quoteCopied => 'Quote copied to clipboard';

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Tap to view full quote'
	String get tapToViewFullQuote => 'Tap to view full quote';

	/// en: 'Quote from MyItihas'
	String get quoteFromMyitihas => 'Quote from MyItihas';

	late final TranslationsFeedTabsEn tabs = TranslationsFeedTabsEn.internal(_root);

	/// en: 'Tap to show caption'
	String get tapToShowCaption => 'Tap to show caption';

	/// en: 'No videos available'
	String get noVideosAvailable => 'No videos available';

	/// en: 'Send to'
	String get selectUser => 'Send to';

	/// en: 'Search users...'
	String get searchUsers => 'Search users...';

	/// en: 'You're not following anyone yet'
	String get noFollowingYet => 'You\'re not following anyone yet';

	/// en: 'No users found'
	String get noUsersFound => 'No users found';

	/// en: 'Try a different search term'
	String get tryDifferentSearch => 'Try a different search term';

	/// en: 'Sent to {{username}}'
	String sentTo({required Object username}) => 'Sent to ${username}';

	/// en: 'Show all posts'
	String get clearHashtagFilter => 'Show all posts';

	/// en: 'Use #hashtags and @username in your caption'
	String get captionHashtagsMentionsHint => 'Use #hashtags and @username in your caption';
}

// Path: social
class TranslationsSocialEn {
	TranslationsSocialEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSocialEditProfileEn editProfile = TranslationsSocialEditProfileEn.internal(_root);
	late final TranslationsSocialCreatePostEn createPost = TranslationsSocialCreatePostEn.internal(_root);
	late final TranslationsSocialCommentsEn comments = TranslationsSocialCommentsEn.internal(_root);
	late final TranslationsSocialEngagementEn engagement = TranslationsSocialEngagementEn.internal(_root);

	/// en: 'Edit caption'
	String get editCaption => 'Edit caption';

	/// en: 'Repost'
	String get repost => 'Repost';

	/// en: 'Repost now'
	String get repostNow => 'Repost now';

	/// en: 'Share instantly to your feed'
	String get repostNowSubtitle => 'Share instantly to your feed';

	/// en: 'Repost with your thoughts'
	String get repostWithThoughts => 'Repost with your thoughts';

	/// en: 'Add your own caption'
	String get repostWithThoughtsSubtitle => 'Add your own caption';

	/// en: 'Add your thoughts...'
	String get repostThoughtsHint => 'Add your thoughts...';

	/// en: 'Reposted'
	String get repostedLabel => 'Reposted';

	/// en: 'Reposted to your feed'
	String get repostedToFeed => 'Reposted to your feed';

	/// en: 'Report post'
	String get reportPost => 'Report post';

	/// en: 'Tell us what is wrong with this post'
	String get reportReasonHint => 'Tell us what is wrong with this post';

	/// en: 'Spam'
	String get reportReasonSpam => 'Spam';

	/// en: 'Harassment or bullying'
	String get reportReasonHarassment => 'Harassment or bullying';

	/// en: 'Hate speech'
	String get reportReasonHateSpeech => 'Hate speech';

	/// en: 'Violence'
	String get reportReasonViolence => 'Violence';

	/// en: 'False information'
	String get reportReasonFalseInfo => 'False information';

	/// en: 'Not relevant content'
	String get reportReasonNotRelevant => 'Not relevant content';

	/// en: 'Other'
	String get reportReasonOther => 'Other';

	/// en: 'Please provide details'
	String get reportDetailsRequired => 'Please provide details';

	/// en: 'Delete post'
	String get deletePost => 'Delete post';

	/// en: 'This action cannot be undone.'
	String get deletePostConfirm => 'This action cannot be undone.';

	/// en: 'Post deleted'
	String get postDeleted => 'Post deleted';

	/// en: 'Failed to delete post: {{error}}'
	String failedToDeletePost({required Object error}) => 'Failed to delete post: ${error}';

	/// en: 'Failed to report post: {{error}}'
	String failedToReportPost({required Object error}) => 'Failed to report post: ${error}';

	/// en: 'Report submitted. Thank you.'
	String get reportSubmitted => 'Report submitted. Thank you.';

	/// en: 'Accept their request in Requests first.'
	String get acceptRequestFirst => 'Accept their request in Requests first.';

	/// en: 'Request sent. Wait for them to accept.'
	String get requestSentWait => 'Request sent. Wait for them to accept.';

	/// en: 'Request sent. They'll see it in Requests.'
	String get requestSentTheyWillSee => 'Request sent. They\'ll see it in Requests.';

	/// en: 'Failed to share: {{error}}'
	String failedToShare({required Object error}) => 'Failed to share: ${error}';

	/// en: 'Update the caption for your post'
	String get updateCaptionHint => 'Update the caption for your post';

	late final TranslationsSocialPollEn poll = TranslationsSocialPollEn.internal(_root);
}

// Path: voice
class TranslationsVoiceEn {
	TranslationsVoiceEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Microphone permission required'
	String get microphonePermissionRequired => 'Microphone permission required';

	/// en: 'Voice input needs microphone access. Tap Open settings to enable it for MyItihas in your device settings.'
	String get microphonePermissionSettingsHint => 'Voice input needs microphone access. Tap Open settings to enable it for MyItihas in your device settings.';

	/// en: 'Open settings'
	String get openDeviceSettings => 'Open settings';

	/// en: 'Speech recognition not available'
	String get speechRecognitionNotAvailable => 'Speech recognition not available';

	/// en: 'You can pause briefly while you think. Tap the mic when you're done.'
	String get storyVoiceListeningHint => 'You can pause briefly while you think. Tap the mic when you\'re done.';
}

// Path: festivals
class TranslationsFestivalsEn {
	TranslationsFestivalsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Festival Stories'
	String get title => 'Festival Stories';

	/// en: 'Tell Story'
	String get tellStory => 'Tell Story';
}

// Path: homeScreen.hero
class TranslationsHomeScreenHeroEn {
	TranslationsHomeScreenHeroEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tap to explore'
	String get tapToExplore => 'Tap to explore';

	late final TranslationsHomeScreenHeroStoryEn story = TranslationsHomeScreenHeroStoryEn.internal(_root);
	late final TranslationsHomeScreenHeroCompanionEn companion = TranslationsHomeScreenHeroCompanionEn.internal(_root);
	late final TranslationsHomeScreenHeroHeritageEn heritage = TranslationsHomeScreenHeroHeritageEn.internal(_root);
	late final TranslationsHomeScreenHeroCommunityEn community = TranslationsHomeScreenHeroCommunityEn.internal(_root);
	late final TranslationsHomeScreenHeroMessagesEn messages = TranslationsHomeScreenHeroMessagesEn.internal(_root);
}

// Path: storyGenerator.storyLength
class TranslationsStoryGeneratorStoryLengthEn {
	TranslationsStoryGeneratorStoryLengthEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Short'
	String get short => 'Short';

	/// en: 'Medium'
	String get medium => 'Medium';

	/// en: 'Long'
	String get long => 'Long';

	/// en: 'Epic'
	String get epic => 'Epic';
}

// Path: storyGenerator.format
class TranslationsStoryGeneratorFormatEn {
	TranslationsStoryGeneratorFormatEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Narrative'
	String get narrative => 'Narrative';

	/// en: 'Dialogue-based'
	String get dialogue => 'Dialogue-based';

	/// en: 'Poetic'
	String get poetic => 'Poetic';

	/// en: 'Scriptural'
	String get scriptural => 'Scriptural';
}

// Path: storyGenerator.hints
class TranslationsStoryGeneratorHintsEn {
	TranslationsStoryGeneratorHintsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tell me a story about Krishna teaching Arjuna...'
	String get krishnaTeaching => 'Tell me a story about Krishna teaching Arjuna...';

	/// en: 'Write an epic tale of a warrior seeking redemption...'
	String get warriorRedemption => 'Write an epic tale of a warrior seeking redemption...';

	/// en: 'Create a story about the wisdom of the sages...'
	String get sageWisdom => 'Create a story about the wisdom of the sages...';

	/// en: 'Narrate the journey of a devoted seeker...'
	String get devotedSeeker => 'Narrate the journey of a devoted seeker...';

	/// en: 'Share the legend of divine intervention...'
	String get divineIntervention => 'Share the legend of divine intervention...';
}

// Path: storyGenerator.errors
class TranslationsStoryGeneratorErrorsEn {
	TranslationsStoryGeneratorErrorsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please complete all required options'
	String get incompletePrompt => 'Please complete all required options';

	/// en: 'Failed to generate story. Please try again.'
	String get generationFailed => 'Failed to generate story. Please try again.';
}

// Path: chat.suggestions
class TranslationsChatSuggestionsEn {
	TranslationsChatSuggestionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '👋 Hey!'
	String get greeting => '👋  Hey!';

	/// en: '📖 What is dharma?'
	String get dharma => '📖  What is dharma?';

	/// en: '🧘 Deal with stress'
	String get stress => '🧘  Deal with stress';

	/// en: '⚡ Karma explained'
	String get karma => '⚡  Karma explained';

	/// en: '💬 Tell me a story'
	String get story => '💬  Tell me a story';

	/// en: '🌟 Daily wisdom'
	String get wisdom => '🌟  Daily wisdom';
}

// Path: chat.composerAttachments
class TranslationsChatComposerAttachmentsEn {
	TranslationsChatComposerAttachmentsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Poll'
	String get poll => 'Poll';

	/// en: 'Camera'
	String get camera => 'Camera';

	/// en: 'Photos'
	String get photos => 'Photos';

	/// en: 'Location'
	String get location => 'Location';

	/// en: 'Create poll'
	String get pollTitle => 'Create poll';

	/// en: 'Ask a question'
	String get pollQuestionHint => 'Ask a question';

	/// en: 'Option {{n}}'
	String pollOptionHint({required Object n}) => 'Option ${n}';

	/// en: 'Add option'
	String get addOption => 'Add option';

	/// en: 'Remove'
	String get removeOption => 'Remove';

	/// en: 'Send poll'
	String get sendPoll => 'Send poll';

	/// en: 'Add at least 2 options (maximum 4).'
	String get pollNeedTwoOptions => 'Add at least 2 options (maximum 4).';

	/// en: 'You can add up to 4 options.'
	String get pollMaxOptions => 'You can add up to 4 options.';

	/// en: 'Shared location'
	String get sharedLocationTitle => 'Shared location';

	/// en: 'Send location'
	String get sendLocation => 'Send location';

	/// en: 'Send your current location?'
	String get locationPreviewTitle => 'Send your current location?';

	/// en: 'Getting location…'
	String get locationFetching => 'Getting location…';

	/// en: 'Open in Maps'
	String get openInMaps => 'Open in Maps';

	/// en: '{{count}} votes'
	String voteCount({required Object count}) => '${count} votes';

	/// en: '1 vote'
	String get voteCountOne => '1 vote';

	/// en: 'Tap an option to vote'
	String get tapToVote => 'Tap an option to vote';

	/// en: 'Could not open maps.'
	String get mapsUnavailable => 'Could not open maps.';
}

// Path: map.discussions
class TranslationsMapDiscussionsEn {
	TranslationsMapDiscussionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'General'
	String get generalCategory => 'General';

	/// en: 'Location'
	String get locationCategory => 'Location';

	/// en: 'Search discussions'
	String get searchTooltip => 'Search discussions';

	/// en: 'Search discussions'
	String get searchTitle => 'Search discussions';

	/// en: 'Search by text, keyword, or #hashtag'
	String get searchHint => 'Search by text, keyword, or #hashtag';

	/// en: 'Start typing to search'
	String get startTyping => 'Start typing to search';

	/// en: 'Searching…'
	String get searching => 'Searching…';

	/// en: 'No discussions match your search'
	String get noResults => 'No discussions match your search';

	/// en: 'Try other words, a #hashtag, or change the filter above'
	String get noResultsHint => 'Try other words, a #hashtag, or change the filter above';

	/// en: 'Could not search discussions. Try again.'
	String get searchErrorFallback => 'Could not search discussions. Try again.';

	/// en: 'Sign in to like discussions'
	String get loginToLike => 'Sign in to like discussions';

	/// en: 'Something went wrong. Try again.'
	String get genericActionError => 'Something went wrong. Try again.';

	/// en: 'Delete this post from the Discussions tab'
	String get deleteFromTabHint => 'Delete this post from the Discussions tab';

	/// en: 'All topics'
	String get allContextChip => 'All topics';

	/// en: 'No discussions yet.'
	String get emptyAll => 'No discussions yet.';

	/// en: 'No discussions in your activity yet.'
	String get emptyMyActivity => 'No discussions in your activity yet.';

	/// en: 'Please enter a title and your thoughts to post a discussion.'
	String get postTitleAndBodyRequired => 'Please enter a title and your thoughts to post a discussion.';

	/// en: 'Please enter a discussion title.'
	String get postTitleRequiredSnackbar => 'Please enter a discussion title.';

	/// en: 'Please share your thoughts to post a discussion.'
	String get postBodyRequiredSnackbar => 'Please share your thoughts to post a discussion.';

	/// en: 'Please enter your message'
	String get composerBodyRequired => 'Please enter your message';

	/// en: 'Discussion posted successfully.'
	String get postedSuccess => 'Discussion posted successfully.';

	/// en: 'Failed to post discussion. Please try again.'
	String get postFailed => 'Failed to post discussion. Please try again.';

	/// en: 'Posting…'
	String get posting => 'Posting…';

	/// en: 'Post discussion'
	String get postDiscussionCta => 'Post discussion';

	/// en: 'Discussion deleted'
	String get deleteSuccess => 'Discussion deleted';

	/// en: 'Delete post?'
	String get deletePostTitle => 'Delete post?';

	/// en: 'This action cannot be undone.'
	String get deletePostBody => 'This action cannot be undone.';

	/// en: 'New discussion'
	String get newDiscussionCta => 'New discussion';

	/// en: 'Start a discussion'
	String get intentCardTitle => 'Start a discussion';

	/// en: 'Ask a question or start a conversation with the whole MyItihas community.'
	String get intentCardSubtitle => 'Ask a question or start a conversation with the whole MyItihas community.';

	/// en: 'Post a discussion'
	String get intentCardCta => 'Post a discussion';

	/// en: 'Anonymous'
	String get anonymous => 'Anonymous';

	/// en: 'No title'
	String get noTitle => 'No title';

	/// en: 'Just now'
	String get justNow => 'Just now';

	/// en: 'Profile photo'
	String get profilePhotoSemantic => 'Profile photo';

	/// en: 'Like'
	String get likeAction => 'Like';
}

// Path: map.fabricMap
class TranslationsMapFabricMapEn {
	TranslationsMapFabricMapEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Indian traditional fabrics'
	String get sectionTitle => 'Indian traditional fabrics';

	/// en: 'Open a dedicated map of handloom and GI-linked textile hubs.'
	String get sectionSubtitle => 'Open a dedicated map of handloom and GI-linked textile hubs.';

	/// en: 'Indian fabrics'
	String get screenTitle => 'Indian fabrics';

	/// en: 'Fabric'
	String get fabricLabel => 'Fabric';

	/// en: 'About this place'
	String get aboutTitle => 'About this place';

	/// en: 'Shop'
	String get shopCta => 'Shop';

	/// en: 'Sellers'
	String get shopTitle => 'Sellers';

	/// en: 'Official & government-linked outlets'
	String get govSellers => 'Official & government-linked outlets';

	/// en: 'Suggest a seller'
	String get addSeller => 'Suggest a seller';

	/// en: 'Send by email'
	String get submitSeller => 'Send by email';

	/// en: 'Seller or organization name'
	String get sellerNameHint => 'Seller or organization name';

	/// en: 'Phone or email'
	String get contactHint => 'Phone or email';

	/// en: 'City / town'
	String get cityHint => 'City / town';

	/// en: 'Short note'
	String get noteHint => 'Short note';

	/// en: 'Website (optional)'
	String get linkHint => 'Website (optional)';

	/// en: 'Fabric seller suggestion — MyItihas'
	String get emailSubject => 'Fabric seller suggestion — MyItihas';

	/// en: 'Details copied to clipboard'
	String get copyBody => 'Details copied to clipboard';

	/// en: 'Could not open email. Copy details manually.'
	String get openMailFailed => 'Could not open email. Copy details manually.';
}

// Path: map.classicalArtMap
class TranslationsMapClassicalArtMapEn {
	TranslationsMapClassicalArtMapEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Indian classical artforms'
	String get sectionTitle => 'Indian classical artforms';

	/// en: 'Explore state-level visual and performance art traditions.'
	String get sectionSubtitle => 'Explore state-level visual and performance art traditions.';

	/// en: 'Classical artforms by state'
	String get screenTitle => 'Classical artforms by state';

	/// en: 'State'
	String get stateLabel => 'State';

	/// en: 'View details'
	String get detailsCta => 'View details';

	/// en: 'Discussion forum'
	String get discussionCta => 'Discussion forum';

	/// en: 'Post to community'
	String get postCta => 'Post to community';
}

// Path: map.classicalDanceMap
class TranslationsMapClassicalDanceMapEn {
	TranslationsMapClassicalDanceMapEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Indian classical dances'
	String get sectionTitle => 'Indian classical dances';

	/// en: 'Explore state-level dance traditions and lineages.'
	String get sectionSubtitle => 'Explore state-level dance traditions and lineages.';

	/// en: 'Classical dances by state'
	String get screenTitle => 'Classical dances by state';

	/// en: 'State'
	String get stateLabel => 'State';

	/// en: 'View details'
	String get detailsCta => 'View details';

	/// en: 'Discussion forum'
	String get discussionCta => 'Discussion forum';

	/// en: 'Post to community'
	String get postCta => 'Post to community';
}

// Path: map.foodMap
class TranslationsMapFoodMapEn {
	TranslationsMapFoodMapEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Indian foods by state'
	String get sectionTitle => 'Indian foods by state';

	/// en: 'Explore native cultural Hindu foods rooted in regional traditions.'
	String get sectionSubtitle => 'Explore native cultural Hindu foods rooted in regional traditions.';

	/// en: 'Indian foods by state'
	String get screenTitle => 'Indian foods by state';

	/// en: 'State'
	String get stateLabel => 'State';

	/// en: 'View details'
	String get detailsCta => 'View details';

	/// en: 'Discussion forum'
	String get discussionCta => 'Discussion forum';

	/// en: 'Post to community'
	String get postCta => 'Post to community';
}

// Path: feed.tabs
class TranslationsFeedTabsEn {
	TranslationsFeedTabsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All'
	String get all => 'All';

	/// en: 'Stories'
	String get stories => 'Stories';

	/// en: 'Posts'
	String get posts => 'Posts';

	/// en: 'Videos'
	String get videos => 'Videos';

	/// en: 'Images'
	String get images => 'Images';

	/// en: 'Thoughts'
	String get text => 'Thoughts';
}

// Path: social.editProfile
class TranslationsSocialEditProfileEn {
	TranslationsSocialEditProfileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Profile'
	String get title => 'Edit Profile';

	/// en: 'Display Name'
	String get displayName => 'Display Name';

	/// en: 'Enter your display name'
	String get displayNameHint => 'Enter your display name';

	/// en: 'Display name cannot be empty'
	String get displayNameEmpty => 'Display name cannot be empty';

	/// en: 'Bio'
	String get bio => 'Bio';

	/// en: 'Tell us about yourself...'
	String get bioHint => 'Tell us about yourself...';

	/// en: 'Change Profile Photo'
	String get changePhoto => 'Change Profile Photo';

	/// en: 'Save Changes'
	String get saveChanges => 'Save Changes';

	/// en: 'Profile updated successfully'
	String get profileUpdated => 'Profile updated successfully';

	/// en: 'Profile and photo updated successfully'
	String get profileAndPhotoUpdated => 'Profile and photo updated successfully';

	/// en: 'Failed to pick image: {{error}}'
	String failedPickImage({required Object error}) => 'Failed to pick image: ${error}';

	/// en: 'Failed to upload photo: {{error}}'
	String failedUploadPhoto({required Object error}) => 'Failed to upload photo: ${error}';

	/// en: 'Failed to update profile: {{error}}'
	String failedUpdateProfile({required Object error}) => 'Failed to update profile: ${error}';

	/// en: 'An unexpected error occurred: {{error}}'
	String unexpectedError({required Object error}) => 'An unexpected error occurred: ${error}';
}

// Path: social.createPost
class TranslationsSocialCreatePostEn {
	TranslationsSocialCreatePostEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create Post'
	String get title => 'Create Post';

	/// en: 'Post'
	String get post => 'Post';

	/// en: 'Text'
	String get text => 'Text';

	/// en: 'Image'
	String get image => 'Image';

	/// en: 'Video'
	String get video => 'Video';

	/// en: 'What's on your mind?'
	String get textHint => 'What\'s on your mind?';

	/// en: 'Write a caption for your photo...'
	String get imageCaptionHint => 'Write a caption for your photo...';

	/// en: 'Describe your video...'
	String get videoCaptionHint => 'Describe your video...';

	/// en: 'Add your thoughts...'
	String get shareCaptionHint => 'Add your thoughts...';

	/// en: 'Add a title (optional)'
	String get titleHint => 'Add a title (optional)';

	/// en: 'Select Video'
	String get selectVideo => 'Select Video';

	/// en: 'Gallery'
	String get gallery => 'Gallery';

	/// en: 'Camera'
	String get camera => 'Camera';

	/// en: 'Who can see this?'
	String get visibility => 'Who can see this?';

	/// en: 'Public'
	String get public => 'Public';

	/// en: 'Followers'
	String get followers => 'Followers';

	/// en: 'Private'
	String get private => 'Private';

	/// en: 'Post created!'
	String get postCreated => 'Post created!';

	/// en: 'Failed to pick images'
	String get failedPickImages => 'Failed to pick images';

	/// en: 'Failed to pick video'
	String get failedPickVideo => 'Failed to pick video';

	/// en: 'Failed to capture photo'
	String get failedCapturePhoto => 'Failed to capture photo';

	/// en: 'Cannot create post while offline'
	String get cannotCreateOffline => 'Cannot create post while offline';

	/// en: 'Discard Post?'
	String get discardTitle => 'Discard Post?';

	/// en: 'You have unsaved changes. Are you sure you want to discard this post?'
	String get discardMessage => 'You have unsaved changes. Are you sure you want to discard this post?';

	/// en: 'Keep Editing'
	String get keepEditing => 'Keep Editing';

	/// en: 'Discard'
	String get discard => 'Discard';

	/// en: 'Crop photo'
	String get cropPhoto => 'Crop photo';

	/// en: 'Trim video'
	String get trimVideo => 'Trim video';

	/// en: 'Edit photo'
	String get editPhoto => 'Edit photo';

	/// en: 'Edit video'
	String get editVideo => 'Edit video';

	/// en: 'Max 30 seconds'
	String get maxDuration => 'Max 30 seconds';

	/// en: 'Square'
	String get aspectSquare => 'Square';

	/// en: 'Portrait'
	String get aspectPortrait => 'Portrait';

	/// en: 'Landscape'
	String get aspectLandscape => 'Landscape';

	/// en: 'Free'
	String get aspectFree => 'Free';

	/// en: 'Failed to crop image'
	String get failedCrop => 'Failed to crop image';

	/// en: 'Failed to trim video'
	String get failedTrim => 'Failed to trim video';

	/// en: 'Trimming video...'
	String get trimmingVideo => 'Trimming video...';

	/// en: 'Add up to 10 photos from gallery or camera'
	String get imageSectionHint => 'Add up to 10 photos from gallery or camera';

	/// en: 'One video, max 30 seconds'
	String get videoSectionHint => 'One video, max 30 seconds';

	/// en: 'Remove'
	String get removePhoto => 'Remove';

	/// en: 'Remove video'
	String get removeVideo => 'Remove video';

	/// en: 'Tap a photo to crop or remove it'
	String get photoEditHint => 'Tap a photo to crop or remove it';

	/// en: 'Edit options'
	String get videoEditOptions => 'Edit options';

	/// en: 'Add photo'
	String get addPhoto => 'Add photo';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Rotate'
	String get rotate => 'Rotate';

	/// en: 'Crop to square for best fit in feed'
	String get editPhotoSubtitle => 'Crop to square for best fit in feed';

	/// en: 'Caption / text (optional)'
	String get videoEditorCaptionLabel => 'Caption / text (optional)';

	/// en: 'E.g. title or hook for your Reel'
	String get videoEditorCaptionHint => 'E.g. title or hook for your Reel';

	/// en: 'Aspect'
	String get videoEditorAspectLabel => 'Aspect';

	/// en: 'Original'
	String get videoEditorAspectOriginal => 'Original';

	/// en: '1:1'
	String get videoEditorAspectSquare => '1:1';

	/// en: '9:16'
	String get videoEditorAspectPortrait => '9:16';

	/// en: '16:9'
	String get videoEditorAspectLandscape => '16:9';

	/// en: 'Quick trim'
	String get videoEditorQuickTrim => 'Quick trim';

	/// en: 'Speed'
	String get videoEditorSpeed => 'Speed';

	/// en: 'Poll'
	String get pollTitle => 'Poll';

	/// en: 'Add between 2 and 4 options.'
	String get pollSubtitle => 'Add between 2 and 4 options.';

	/// en: 'Add option'
	String get addPollOption => 'Add option';

	/// en: 'Max 4 options'
	String get pollMaxOptionsReached => 'Max 4 options';

	/// en: 'Choice {{index}}'
	String pollChoiceLabel({required Object index}) => 'Choice ${index}';

	/// en: 'Searching…'
	String get mentionSearching => 'Searching…';

	/// en: 'No users found'
	String get mentionNoUsers => 'No users found';

	/// en: 'Couldn't load users'
	String get mentionLoadFailed => 'Couldn\'t load users';
}

// Path: social.comments
class TranslationsSocialCommentsEn {
	TranslationsSocialCommentsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Replying to {{name}}'
	String replyingTo({required Object name}) => 'Replying to ${name}';

	/// en: 'Reply to {{name}}...'
	String replyHint({required Object name}) => 'Reply to ${name}...';

	/// en: 'Failed to post: {{error}}'
	String failedToPost({required Object error}) => 'Failed to post: ${error}';

	/// en: 'Cannot post comment while offline'
	String get cannotPostOffline => 'Cannot post comment while offline';

	/// en: 'No comments yet'
	String get noComments => 'No comments yet';

	/// en: 'Be the first to comment!'
	String get beFirst => 'Be the first to comment!';
}

// Path: social.engagement
class TranslationsSocialEngagementEn {
	TranslationsSocialEngagementEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Offline mode'
	String get offlineMode => 'Offline mode';
}

// Path: social.poll
class TranslationsSocialPollEn {
	TranslationsSocialPollEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Poll'
	String get title => 'Poll';

	/// en: 'Tap an option to vote'
	String get tapToVote => 'Tap an option to vote';

	/// en: '{{count}} votes'
	String votes({required Object count}) => '${count} votes';

	/// en: 'Please sign in to vote'
	String get signInToVote => 'Please sign in to vote';

	/// en: 'Could not submit vote. Please try again.'
	String get voteFailed => 'Could not submit vote. Please try again.';
}

// Path: homeScreen.hero.story
class TranslationsHomeScreenHeroStoryEn {
	TranslationsHomeScreenHeroStoryEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'AI Story Generation'
	String get tagline => 'AI Story Generation';

	/// en: 'Generate Immersive Stories'
	String get headline => 'Generate\nImmersive\nStories';

	/// en: 'Powered by ancient wisdom'
	String get subHeadline => 'Powered by ancient wisdom';

	/// en: '✦ Choose a sacred scripture...'
	String get line1 => '✦  Choose a sacred scripture...';

	/// en: '✦ Select a vivid setting...'
	String get line2 => '✦  Select a vivid setting...';

	/// en: '✦ Let AI weave a mesmerising tale...'
	String get line3 => '✦  Let AI weave a mesmerising tale...';

	/// en: 'Generate Story'
	String get cta => 'Generate Story';
}

// Path: homeScreen.hero.companion
class TranslationsHomeScreenHeroCompanionEn {
	TranslationsHomeScreenHeroCompanionEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Spiritual Companion'
	String get tagline => 'Spiritual Companion';

	/// en: 'Your Divine Guide, Always Near'
	String get headline => 'Your Divine\nGuide,\nAlways Near';

	/// en: 'Inspired by Krishna's wisdom'
	String get subHeadline => 'Inspired by Krishna\'s wisdom';

	/// en: '✦ A friend who truly listens...'
	String get line1 => '✦  A friend who truly listens...';

	/// en: '✦ Wisdom for life's struggles...'
	String get line2 => '✦  Wisdom for life\'s struggles...';

	/// en: '✦ Conversations that uplift you...'
	String get line3 => '✦  Conversations that uplift you...';

	/// en: 'Start Chat'
	String get cta => 'Start Chat';
}

// Path: homeScreen.hero.heritage
class TranslationsHomeScreenHeroHeritageEn {
	TranslationsHomeScreenHeroHeritageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Heritage Map'
	String get tagline => 'Heritage Map';

	/// en: 'Discover Timeless Heritage'
	String get headline => 'Discover\nTimeless\nHeritage';

	/// en: '5000+ sacred sites mapped'
	String get subHeadline => '5000+ sacred sites mapped';

	/// en: '✦ Explore sacred places...'
	String get line1 => '✦  Explore sacred places...';

	/// en: '✦ Read history and lore...'
	String get line2 => '✦  Read history and lore...';

	/// en: '✦ Plan meaningful journeys...'
	String get line3 => '✦  Plan meaningful journeys...';

	/// en: 'Explore Map'
	String get cta => 'Explore Map';
}

// Path: homeScreen.hero.community
class TranslationsHomeScreenHeroCommunityEn {
	TranslationsHomeScreenHeroCommunityEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Community Space'
	String get tagline => 'Community Space';

	/// en: 'Share Culture With The World'
	String get headline => 'Share\nCulture With\nThe World';

	/// en: 'A vibrant global community'
	String get subHeadline => 'A vibrant global community';

	/// en: '✦ Posts and deep discussions...'
	String get line1 => '✦  Posts and deep discussions...';

	/// en: '✦ Short cultural videos...'
	String get line2 => '✦  Short cultural videos...';

	/// en: '✦ Stories from around the world...'
	String get line3 => '✦  Stories from around the world...';

	/// en: 'Join Community'
	String get cta => 'Join Community';
}

// Path: homeScreen.hero.messages
class TranslationsHomeScreenHeroMessagesEn {
	TranslationsHomeScreenHeroMessagesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Private Messaging'
	String get tagline => 'Private Messaging';

	/// en: 'Meaningful Conversations Start Here'
	String get headline => 'Meaningful\nConversations\nStart Here';

	/// en: 'Private & thoughtful spaces'
	String get subHeadline => 'Private & thoughtful spaces';

	/// en: '✦ Connect with kindred souls...'
	String get line1 => '✦  Connect with kindred souls...';

	/// en: '✦ Discuss ideas and stories...'
	String get line2 => '✦  Discuss ideas and stories...';

	/// en: '✦ Build thoughtful communities...'
	String get line3 => '✦  Build thoughtful communities...';

	/// en: 'Open Messages'
	String get cta => 'Open Messages';
}
