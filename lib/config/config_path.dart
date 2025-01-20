const hostUrl = "http://192.168.32.36:3000";
// const hostUrl = "http://192.168.1.127:3000";
const String wsHostUrl = "ws://$hostUrl/graphql";
const baseUrl = "$hostUrl/api/v1";

const getAccessTokenUrl = "$baseUrl/auth/login/user";
const registerUrl = "$baseUrl/auth/register/user";
const getMeUrl = "$baseUrl/me";

const createFamilyUrl = "$baseUrl/me/family";
const currentUserFamilyUrl = "$baseUrl/me/family";
const updateCurrentUserFamilyUrl = "$baseUrl/me/family";
const deleteCurrentUserFamilyUrl = "$baseUrl/me/family";
const userInCurrentFamilyUrl = "$baseUrl/me/family/users";
const getUserInCurrentFamilyPathParamUrl = "$baseUrl/me/family/users/";
const familyInviteCodeUrl = "$baseUrl/me/family/invite-code";


const joinFamilyUrl = "$baseUrl/me/family/join-family";

const createSpotifyConnectionUrl = "$baseUrl/me/family/spotify-connection";
const getSpotifyConnectionUrl = "$baseUrl/me/family/spotify-connection";
const deleteSpotifyConnectionUrl = "$baseUrl/me/family/spotify-connection";

const listDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices";
const updateDeviceCurrentUserFamilyUrl = "$baseUrl/me/family/devices";
const deleteDeviceCurrentUserFamilyUrl = "$baseUrl/me/family/devices";
const createGroupDeviceUrl = "$baseUrl/me/family/devices/group";
const listGroupDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices-group";
const getGroupDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices-group";
const updateGroupDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices-group";
const deleteGroupDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices-group";
