/// Endpoint to connect to server
// ignore_for_file: avoid_classes_with_only_static_members
class Endpoint {
  /// Asset url for dev environment
  static final String assetEndpointDev =
      'https://tabula-bucket.s3.us-west-2.amazonaws.com';

  /// Asset url for staging environment
  static final String assetEndpointStaging =
      'https://tabula-bucket-stg.s3.us-west-2.amazonaws.com';

  /// Base Production URL
  static final String baseProd = 'https://api.tabulalearning.net/1.0';

  /// Base Staging URL
  static final String baseStaging = 'https://api.tabulalearning.net/1.0';

  /// Base Dev URL
  static final String baseDev = 'https://tabula-dev.codestringers.com/1.0';

  /// Login endpoint
  static final String login = '/organization/session';

  /// Get Organization user endpoint
  static final String getOrgUser = '/organization/me';

  /// Get user by organization endpoint
  static final String getUserByOrganization = '/organizations/{id}/users';

  /// Get my organization endpoint
  static final String getMyOrganization = '/organization/me';

  /// Get organization by user endpoint
  static final String getOrganizationsByUser = '/user/organizations';

  /// Forget password endpoint
  static final String forgotPassword = '/organization/forgot-password';

  /// Set password endpoint
  static final String setPassword = '/organizations/set-password';

  /// Get mycourse endpoint
  static final String getMyCourses = '/organization/{id}/user/courses';

  /// Get course navigation content data
  static final String getCourseNavContent =
      '/organization/{id}/courses/{courseId}/content';

  /// Get course navigation content data
  static final String getClassSessionData = '/organization/{id}/courses/'
      '{courseId}/{gradingDailyTemplateId}/{dailyTemplatePeriodId}';

  /// Get assignment detail
  static final String getAssignmentDetail = '/organization/{id}/courses/'
      '{coursesId}/assignments/{assignmentId}';

  /// Resend invitation endpoint
  static final String resendInvitation = '/organization/resend-invitation';
}
