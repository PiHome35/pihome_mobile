sealed class LoadingRemoteEvent {
  const LoadingRemoteEvent();
}

final class LoadUserData extends LoadingRemoteEvent {
  const LoadUserData();
}

final class LoadLocalStorage extends LoadingRemoteEvent {
  const LoadLocalStorage();
}


