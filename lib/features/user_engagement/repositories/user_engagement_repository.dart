class UserEngagementRepository {
  int _buttonClickCount = 0;
  int getButtonClickCount() {
    _buttonClickCount++;
    return _buttonClickCount;
  }
}
