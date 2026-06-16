// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get navHome => '首页';

  @override
  String get navLiveTv => '直播';

  @override
  String get navSearch => '搜索';

  @override
  String get navFavorites => '收藏';

  @override
  String get navHistory => '历史记录';

  @override
  String get navProfile => '个人资料';

  @override
  String get navSignIn => '登录';

  @override
  String get navSignOut => '退出';

  @override
  String get navSettings => '设置';

  @override
  String get homeLiveNow => '正在直播';

  @override
  String get homeNews => '新闻';

  @override
  String get homeSports => '体育';

  @override
  String get homeEntertainment => '娱乐';

  @override
  String get homeMusic => '音乐';

  @override
  String get homeMovies => '电影';

  @override
  String get homeSeeAll => '查看全部';

  @override
  String homeChannelsInCountry(String country) {
    return '$country的频道';
  }

  @override
  String get homeWatchNow => '立即观看';

  @override
  String get homeTrendingGlobally => '全球热门';

  @override
  String get homeFeatured => '精选';

  @override
  String get liveAllChannels => '所有频道';

  @override
  String get liveFilter => '筛选';

  @override
  String get liveSort => '排序';

  @override
  String get liveSearchPlaceholder => '搜索频道...';

  @override
  String liveShowingCount(int count) {
    return '显示 $count 个频道';
  }

  @override
  String get liveNoResults => '未找到频道';

  @override
  String get liveLiveOnly => '仅直播';

  @override
  String get liveAllCountries => '所有国家';

  @override
  String get liveAllCategories => '所有分类';

  @override
  String get liveAllLanguages => '所有语言';

  @override
  String get liveSortAz => 'A 到 Z';

  @override
  String get liveSortPopular => '最受欢迎';

  @override
  String get liveSortCountry => '按国家';

  @override
  String get liveLoadMore => '加载更多';

  @override
  String liveChannelCount(int count) {
    return '$count 个频道';
  }

  @override
  String get channelWatchNow => '立即观看';

  @override
  String get channelAddFavorite => '添加到收藏';

  @override
  String get channelRemoveFavorite => '从收藏中移除';

  @override
  String get channelReportStream => '举报直播';

  @override
  String channelMoreFromCountry(String country) {
    return '更多来自$country';
  }

  @override
  String get channelStreamUnavailable => '直播不可用';

  @override
  String get channelTryAnotherQuality => '尝试其他清晰度';

  @override
  String get channelRetry => '重试';

  @override
  String get channelNowPlaying => '正在播放';

  @override
  String get channelUpNext => '下一个';

  @override
  String channelEndsAt(String time) {
    return '结束于 $time';
  }

  @override
  String get channelOfficialWebsite => '官方网站';

  @override
  String get channelQualityAuto => '自动';

  @override
  String get channelQualityHd => '高清';

  @override
  String get channelQualitySd => '标清';

  @override
  String get playerPlay => '播放';

  @override
  String get playerPause => '暂停';

  @override
  String get playerFullscreen => '全屏';

  @override
  String get playerExitFullscreen => '退出全屏';

  @override
  String get playerMute => '静音';

  @override
  String get playerUnmute => '取消静音';

  @override
  String get playerQuality => '清晰度';

  @override
  String get playerLiveLabel => '直播';

  @override
  String get playerLoading => '正在加载直播...';

  @override
  String get playerErrorTitle => '播放错误';

  @override
  String get playerErrorMessage => '无法加载此直播。请尝试其他清晰度或稍后再试。';

  @override
  String get searchPlaceholder => '搜索频道...';

  @override
  String searchResultsFor(String query) {
    return '\"$query\"的搜索结果';
  }

  @override
  String get searchNoResultsTitle => '未找到结果';

  @override
  String get searchNoResultsSubtitle => '尝试不同的搜索词或按类别浏览';

  @override
  String get searchRecentSearches => '最近搜索';

  @override
  String get searchClearRecent => '清除';

  @override
  String get authSignIn => '登录';

  @override
  String get authSignUp => '注册';

  @override
  String get authEmail => '电子邮件';

  @override
  String get authPassword => '密码';

  @override
  String get authConfirmPassword => '确认密码';

  @override
  String get authGoogleSignIn => '使用 Google 继续';

  @override
  String get authForgotPassword => '忘记密码？';

  @override
  String get authNoAccount => '没有账号？';

  @override
  String get authHaveAccount => '已有账号？';

  @override
  String get authContinueAsGuest => '以访客身份继续';

  @override
  String get authSignInToContinue => '登录以继续';

  @override
  String get authSignInForFavorites => '登录以保存收藏';

  @override
  String get authSignInForHistory => '登录以查看观看历史';

  @override
  String get authCreateAccount => '创建账号';

  @override
  String get authOrContinueWith => '或使用以下方式继续';

  @override
  String get epgNowPlaying => '正在播放';

  @override
  String get epgUpNext => '下一个';

  @override
  String epgEndsAt(String time) {
    return '结束于 $time';
  }

  @override
  String get epgNoGuideAvailable => '节目指南不可用';

  @override
  String get epgTodaysSchedule => '今日节目表';

  @override
  String get epgNowBadge => '直播';

  @override
  String get epgScheduleCollapsed => '显示节目表';

  @override
  String get epgScheduleExpanded => '隐藏节目表';

  @override
  String get reportTitle => '举报直播问题';

  @override
  String get reportReasonOffline => '直播已下线';

  @override
  String get reportReasonGeoBlocked => '在我的地区受到地理限制';

  @override
  String get reportReasonPoorQuality => '视频质量差';

  @override
  String get reportReasonWrongContent => '错误的频道内容';

  @override
  String get reportSubmit => '提交举报';

  @override
  String get reportCancel => '取消';

  @override
  String get reportThankYou => '感谢您的举报！';

  @override
  String get onboardingWhereWatching => '您在哪里观看？';

  @override
  String get onboardingWhatEnjoy => '您喜欢看什么？';

  @override
  String get onboardingFreeOrSignin => '免费观看或登录以获取更多';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingContinueBtn => '继续';

  @override
  String get onboardingSelectCountry => '选择您的国家';

  @override
  String get onboardingSelectCategories => '选择您的兴趣';

  @override
  String get errorsSomethingWrong => '出现错误';

  @override
  String get errorsStreamUnavailable => '此直播目前不可用';

  @override
  String get errorsNoInternet => '无网络连接';

  @override
  String get errorsTryAgain => '请重试';

  @override
  String get errorsNotFound => '页面未找到';

  @override
  String get errorsGoHome => '返回首页';

  @override
  String get errorsServerError => '服务器错误。请稍后重试。';

  @override
  String get commonLoading => '加载中...';

  @override
  String get commonError => '错误';

  @override
  String get commonRetry => '重试';

  @override
  String get commonClose => '关闭';

  @override
  String get commonCancel => '取消';

  @override
  String get commonSave => '保存';

  @override
  String get commonDone => '完成';

  @override
  String get commonBack => '返回';

  @override
  String get commonOk => '确定';

  @override
  String get commonShare => '分享';

  @override
  String get commonReport => '举报';

  @override
  String get commonFavorite => '收藏';

  @override
  String get commonUnfavorite => '取消收藏';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => '直播';

  @override
  String get commonHdBadge => '高清';

  @override
  String get commonSdBadge => '标清';

  @override
  String get commonMore => '更多';

  @override
  String get commonLess => '收起';

  @override
  String get commonSeeAll => '查看全部';
}
