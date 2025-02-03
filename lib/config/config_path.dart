// const ipHost = "192.168.32.36";
// const ipHost = "192.168.1.154";
// const ipHost = "10.31.106.100";
const ipHost = "192.168.1.104";

// const ipHost = "172.23.103.191";
const port = "3000";
const hostUrl = "http://$ipHost:$port";
const wsHostUrl = "ws://$ipHost:$port/graphql";
const baseUrl = "$hostUrl/api/v1";

const getAccessTokenUrl = "$baseUrl/auth/login/user";
const registerUrl = "$baseUrl/auth/register/user";
const getMeUrl = "$baseUrl/me";

const registerDeviceUrl = "$baseUrl/auth/register/device";
const getChatAiModelsUrl = "$baseUrl/chat-models";

const createFamilyUrl = "$baseUrl/me/family";
const currentUserFamilyUrl = "$baseUrl/me/family";
const userInCurrentFamilyUrl = "$baseUrl/me/family/users";
const getUserInCurrentFamilyPathParamUrl = "$baseUrl/me/family/users/";
const familyInviteCodeUrl = "$baseUrl/me/family/invite-code";

const joinFamilyUrl = "$baseUrl/me/join-family";
const spotifyConnectionUrl = "$baseUrl/me/family/spotify-connection";

const deviceCurrentFamilyUrl = "$baseUrl/me/family/devices";
const groupDeviceUrl = "$baseUrl/me/family/device-groups";
