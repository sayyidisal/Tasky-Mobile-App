final String baseUrl = 'http://localhost:3000/dev';
final String loginPath = '$baseUrl/login';
final String organizationPath = '$baseUrl/getOrganizationById';
final String updateTeamPath = '$baseUrl/updateUserTeam';
final String createOrganizationPath = '$baseUrl/createOrganization';
final String getUserInformationPath = '$baseUrl/getUserInformation';
final String inviteMembersPath = '$baseUrl/inviteMembers';
final String createTaskPath = '$baseUrl/createTask';
String listMembersPath(int organizationId) =>
    '$baseUrl/listMembers/$organizationId';
final String fileUploaderPath =
    'http://tasty-file-uploader.us-east-2.elasticbeanstalk.com/api/v0/upload';
final String updateTokenPath = '$baseUrl/updateUserToken';
String getTaskPath(int organizationId) => '$baseUrl/getTasks/$organizationId';
String getTaskStatisticsPath(int userId) =>
    '$baseUrl/getTaskStatusCount/$userId';
final String updateTaskPath = '$baseUrl/updateTask';
