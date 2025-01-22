sealed class LoadingRemoteEvent {
  const LoadingRemoteEvent();
}

final class LoadUserData extends LoadingRemoteEvent {
  const LoadUserData();
}

final class LoadLocalStorage extends LoadingRemoteEvent {
  const LoadLocalStorage();
}

final class LoadSetting extends LoadingRemoteEvent {
  const LoadSetting();
}

final class LoadSpotifyConnect extends LoadingRemoteEvent {
  const LoadSpotifyConnect();
}

final class LoadFamily extends LoadingRemoteEvent {
  const LoadFamily();
}
