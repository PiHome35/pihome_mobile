// const ipHost = "192.168.32.36";
const ipHost = "192.168.1.154";
const port = "3000";
const hostUrl = "http://$ipHost:$port";
const wsHostUrl = "ws://$ipHost:$port/graphql";
const baseUrl = "$hostUrl/api/v1";

const getAccessTokenUrl = "$baseUrl/auth/login/user";
const registerUrl = "$baseUrl/auth/register/user";
const getMeUrl = "$baseUrl/me";

const createFamilyUrl = "$baseUrl/me/family";
const currentUserFamilyUrl = "$baseUrl/me/family";
const userInCurrentFamilyUrl = "$baseUrl/me/family/users";
const getUserInCurrentFamilyPathParamUrl = "$baseUrl/me/family/users/";
const familyInviteCodeUrl = "$baseUrl/me/family/invite-code";


const joinFamilyUrl = "$baseUrl/me/join-family";
const spotifyConnectionUrl = "$baseUrl/me/family/spotify-connection";

const listDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices";
const updateDeviceCurrentUserFamilyUrl = "$baseUrl/me/family/devices";
const deleteDeviceCurrentUserFamilyUrl = "$baseUrl/me/family/devices";
const createGroupDeviceUrl = "$baseUrl/me/family/devices/group";
const listGroupDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices-group";
const getGroupDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices-group";
const updateGroupDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices-group";
const deleteGroupDeviceCurrentFamilyUrl = "$baseUrl/me/family/devices-group";
