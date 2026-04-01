class EndpointConstant {
  //* Auth
  static const String signUp = '/user/register';
  static const String login = '/user/login';
  static const String verifySignUp = '/user/account/verify';
  static const String forgotPassword = '/user/account/forgot-password';
  static const String verifyForgotPassword =
      '/user/account/reset-password/verify';
  static const String refreshToken = '/users/refresh-token';
  static const String resetPassword = '/user/account/update-password';
  static const String updatePassword = '/user/account/update-password';
  static const String logOut = '/user/logout';
  static const String googleelogin = '/user/google/callback?id_token=';

  static const String loadInterests = '/interests';
  static const String getRandomUserList = '/onboarding/users';
  static const String saveInterests = '/interests/build';
  static const String sendClapRequests = '/clap/requests';
  static const String acceptClapRequest = '/clap/requests/accept';
  static const String rejectClapRequest = '/clap/requests/decline';
  static const String reactToClapRequest = '/clap/request/react';
  static const String updateUserDetails = '/account/update';
  static const String clapRequest = '/clap/requests';
  static const String getPeopleNearMe = '/nearby/users';
  //* Posts
  static const String getAllPosts = '/posts/all';
  static const String getAllVideoPosts = '/videos/all';
  static const String registerFCMtoken = '/notifications/token/register';
  static const String unregisterFCMtoken = '/notifications/token/unregister';

  static const String toogleNotificationState = '/notifications/token/toggle';

  static const String getSinglePost = '/posts';
  static const String commentOnPost = '/posts/comments/create';
  static const String clapAPost = '/posts/clap';
  static const String unclapAPost = '/posts/unclap'; // Added unclap endpoint
  static const String notInterestedInPost = '/posts/not-interested';
  static const String createPost = '/posts/create';
  static const String savePost = '/posts/save';
  static const String sharePost = '/posts/share';
  static const String getUserPosts = '/posts/user';
  static const String getUserKYCStatus = '/user/kyc/status';
  static const String kycInitaite = '/user/kyc/initiate';
  static const String kycupload = '/user/kyc/upload';

  static const String getFollowersPost = '/posts/followers';
  static const String blockUser = '/posts/block';
  static const String delPost = '/posts';
  static const String editPost = '/posts';

  //* Leaderboard Payment Grades
  static const String paymentGrades = '/creator/payment-grades';
  static const String subscribeToGrade = '/creators/subscribe';

  static const String createVideoPost = '/videos/create';
  static const String uploadUrl = '/upload-url';

  //* Profile
  static const String getMyProfile = '/user';
  static const String getUserProfile = '/user/profile';

  //* Rewards
  static const String claimDailyReward = '/rewards/claim';
  static const String rewardClaimStatus = '/rewards/activities/status';
  static const String getRewardHistory = '/rewards/history';
  static const String getRewardBalance = '/rewards/balance';
  static const String withdraw10kLimit = '/rewards/10k/withdraw';
  static const String claimReferred5People =
      '/rewards/claim/has-referred-5-people';
  static const String getReferrerQrCode = '/rewards/referral/qr';
  static const String getLeaderboard = '/rewards/leaderboards';
  static const String getCreatorLeaderboard = '/creators/ranking';
  static const String getCreatorLevels = '/creators/levels';
  static const String referralCount = '/referrals/count';

  //* Settings
  static const String privacySettings = '/user/settings/privacy';
  static const String notificationSettings = '/user/settings/notifications';
  static const String deleteAccount = '/users/profile/delete-account';

  //* Search
  static const String generalUsersSearch = '/users/search';

  static const String resendVerificationCode =
      '/user/account/verification-mail/send';
  static const String buildProfile = '/profile/build';
  static const String challengeSomething = '/brags/challenge';
  static const String challengeSingleLive = '/brags/challenge';
  static const String acceptChallenge = '/brags/challenge/accept';
  static const String declineChallenge = '/brags/challenge/decline';
  static const String singleLiveacceptChallenge = '/brags/challenge/accept';
  static const String singleLivedeclineChallenge = '/brags/challenge/decline';
  static const String rescheduleChallenge = '/brags/challenge/reschedule';

  static const String createCombo = '/combos/create';
  static const String singlecreateCombo = '/combos/create';
  static const String getAvatars = '/avatars';
  static const String getAvatar = '/avatars';
  static const String getUpcomingCombos = '/combos/upcoming';
  static const String getLiveCombos = '/combos/live';
  static const String getSingleCombo = '/combos/';
  static const String setReminderForCombo = '/combos/reminder';
  static const String joinComboGround = '/combo-grounds/join';
  static const String leaveComboGround = '/combo-grounds/leave';
  static const String switchDevice = '/combo-grounds/switch-device';
  static const String joinCompanion = '/combo-grounds/join-companion';
  static const String getListofBragchallenger = '/brags/';
  // static const String getListofSingleBragchallenger = '/brags/';
  static const String getLiveCombo = '/combo-grounds/';

  static const String commentOnAPost = '/posts/comments/create';
  static const String notificationList = '/notifications/list';
  static const String markNotificationAsRead = '/notifications/read';
  static const String clearNotification = '/notifications/clear';
  static const String clearAllNotifications = '/notifications/clear-all';

  static const String markAllNotificationAsRead = '/notifications/read-all';

  static const String getUserDetails = '/user';
  static const String getCategories = '/categories';

  //walletsection
  static const String getTransactionsList = '/wallets/transactions/list';
  static const String getTransactionsListRecent =
      '/wallets/transactions/list?recent=true';

  static const String getBalance = '/assets';
  static const String giftClapPoint = '/gift/user';
  static const String getTransactionsDetail = '/wallets/transactions/details';
  static const String getRecentgifiting = '/gifts/history';
  static const String swapCoin = '/swap';

  static const String getWalletAddresses = '/wallet/USDT/addresses';
  static const String getWalletUSDCAddresses = '/wallet/USDC/addresses';
  static const String twoFAverification = '/wallet/2fa/authentication';
  static const String verify2FAcode = '/wallet/verify/2fa/code';
  static const String createwithdrawalPin = '/create/withdrawal/pin';
  static const String getAvailableCoin = '/assets/CAPP/balance';
  static const String getWalletProperties = '/wallet/properties';
  static const String initiateWithdrawal = '/wallet/withdrawal/create';
  static const String buypoint = '/wallets/fiat-deposit/quote';
  static const String supportedBanks = '/banks/supported';
  static const String verifyBankAccount = '/banks/resolver';
  static const String userAccount = '/bank/accounts';
  static const String getQuote = '/wallets/fiat-withdrawal/quote';
  static const String createOrder = '/wallets/fiat-withdrawal/order';
  static const String paywithTranferFiat = '/wallets/fiat-deposit/quote';
  static const String verifyorderStatus = '/verify/fiat/order';
  static const String otpForgetPin = '/forgot/withdrawal/pin/otp';
  static const String verifyForgotPin = '/verify/forgot/withdrawal/pin/otp';
  static const String updatePin = '/update/withdrawal/pin';
  static const String depositConfirmation = '/deposit/confirm';
  static const String stripeCheckout = '/stripe/checkout';
  //

  //chats
  static const String fetchChatMessages = '/chat/messages';
  static const String chatFriends = '/chat/list/people/chatted';
  static const String clappers = '/clap/clappers';
  static const String createConversation = '/conversations/create';
}
