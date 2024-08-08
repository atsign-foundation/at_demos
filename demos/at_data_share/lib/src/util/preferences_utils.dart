import 'package:at_client/at_client.dart';

AtClientPreference getAtClientPreference() {
  AtClientPreference atClientPreference = AtClientPreference();
  atClientPreference.hiveStoragePath =
      '/home/sitaram/work/hive/data_share_hive_storage/hive/client';
  atClientPreference.commitLogPath =
      '/home/sitaram/work/hive/data_share_hive_storage/hive/client/commit';
  atClientPreference.isLocalStoreRequired = true;
  atClientPreference.privateKey =
      'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCvaeUiDK57NC4Y0oBV5g8kwZy9izXc95eoHK5To+SsJcDamQPH3UrKcG/X4zOKAyX++NiIyvXb6QTZ+692U4Ybm04vP5vr2ztZJS/ADLgVruFFVbGd+OhYPYNvkR0RxpWkqTTIvgpE78rqCuOSu0r3Yl6ovGTIx84zCNMP+Y7QFl+AK0aBJ4lA9zDYgG44BilUlVSwjLmU9koSTWWbsRjHdR8DliDDVUfw33NhS7Y64cO+ZA0xoNnGPYv70dHvWPlTVyrY8rpomoRlzrafGgEunit6Zobrr8QXMc1sIpVnUEaHzc9j1pNvDnY9Np/tTGJWU03LgerCncLUqGr3quolAgMBAAECggEAKNbEq+q77J83ZDwN+PG48NvKvC5e+fUC7/bNd1ee851OixY41R1mPj9zKpYQ977H59bTwvVNzEcyA/Ye4bOMc3zy9PkgOgcuiBCqT1ImwZWXiObslVTP80tPAHiOhgbv7Agg6+OizG3vlhG27gCA8ZuLYkmKRVyPWz5gtUVqxHMtUy0LP+h2v0k6llpjAigvyOESXJkkErK6qjxTyMYGvu75/FcHYZc76DP8jsufoVYV2d2WFg/Ytbm1akHXRCFQSk8X00G5S1hD04ro6Dlak5Yohq6pcNHhAMp6NpxRUP85H1RiaQvqezFpspfnERVVKd/JWNB3eEFnG0Xpww0BAQKBgQD0qQP4tNTnqWkUm/DmjUgZmiumJGfRcS6lM/JEky8AChi0U3nGZkWt1Ykuf3bBuc0wFnLoFcmQ6lXaB+vnR86reyGcR4rRwFbBJFwNzinaSlth9fgIVnJOwsEymWfV2vMHE30JD8r+fmHqVsXyWtkOQzu/kJf7T3wpS97FhozIoQKBgQC3iz5IYS7IQL7nMPeqWtvTpQ6Fv6lGTRL0agAGEbSsgUQ9qsIgCFJAwZN2dw2XPEuFmMi16NYypumwehFybFZiuQu+YTF4sivRSQ2De5EbgBVZqRatCIzsG4D2nVUsyP2+uT+H/ZDGLpZAECg8Z3VWb9NIJ59EowBSnmoPmO+fBQKBgDftLsg6ZfSyyB966h15rEKV+GZZKhY5XiVLc5TzZCoJJM6Lymls1X7AMkSbxITSOTJF32xoFpR2zLszVlyfEIIoem1j+TqrUemCqzxIpU6N8se410Lop+aTJGCxqoe7LhSvAsUAhDGaqD1OKp+U3ssg2VaX8fXznHlAK6NRd3shAoGAZtat3wAUpj8gt4jIO7sM0Fj6+hWZUrp8lFWQDdZ91OnYwnSasDf5Xi8X4Jh0FPjDl+czDjmXSmobJbY/cE0jWc00t0bd4TJzOqAj4jep5i6tx77l5a2Ux/XhHEyrHJzBD8vbvOZl56TSqrJi2PVe2T9usk8A/gQWejQoWPTnzcECgYEA033FyXqWkazF30tqUXgKmnKcT0BsM0PLyIZPu1RtRH09JNTbBeNwtRw3QjDlk1gEPf2hApaluFk97BYk/jSXn7s/fUKH10TSulPXHxFKCyfzq+xASS9Kf39WZ+WM5p1EDbsoSVYaW0d2MICkFO3PedVTipN838IX/RNIatSUG84=';
  atClientPreference.rootDomain = 'vip.ve.atsign.zone';
  return atClientPreference;
}