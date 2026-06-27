class AppStrings {
  static const _values = {
    "en": {
      "settings": "Settings",
      "language": "Language",
      "theme": "Theme",
      "delete_account": "Delete account",
      "favorites": "Favorite Albums",
      "no_favorites": "No favorite albums yet",
      "search_hint": "Search albums...",
      "home": "Home",
      "search": "Search",
      "start_typing": "Start typing to search albums",
      "profile": "Profile",
      "artist": "Artist",
      "login": "Log in",
      "register": "Register",
      "welcome_back": "Welcome back!",
      "email": "email",
      "password": "password",
      "create_account": "Create account",
      "already_have_account": "Do You already have an account? Log in here",
    },
    "pl": {
      "settings": "Ustawienia",
      "language": "Język",
      "theme": "Motyw",
      "delete_account": "Usuń konto",
      "favorites": "Ulubione albumy",
      "no_favorites": "Brak ulubionych albumów",
      "search_hint": "Szukaj albumów...",
      "home": "Główna",
      "search": "Szukaj albumu",
      "start_typing": "Zacznij wpisywać nazwę albumu do szukania",
      "profile": "Profil",
      "artist": "Autor",
      "login": "Zaloguj się",
      "register": "Zarejestruj się",
      "welcome_back": "Witaj ponownie!",
      "email": "email",
      "password": "hasło",
      "create_account": "Utwórz konto",
      "already_have_account": "Masz już konto? Zaloguj się tutaj",
    }
  };

  static String get(String key, String lang) {
    return _values[lang]?[key] ?? _values["en"]![key] ?? key;
  }
}