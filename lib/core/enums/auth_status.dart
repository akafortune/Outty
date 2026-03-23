enum AuthStatus {
  initial,
  unauthenticated,
  authenticating,
  authenticated,
  error;

  bool get isAuthenticated => this == AuthStatus.authenticated;
  bool get isAuthenticating => this == AuthStatus.authenticating;
  bool get isUnauthenticatied => this == AuthStatus.unauthenticated;
  bool get hasError => this == AuthStatus.error;
}
