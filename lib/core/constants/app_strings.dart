/// ─── App-wide string constants ───────────────────────────────────────────────
/// Backend dev: replace hard-coded strings with i18n keys here as needed.
class AppStrings {
  AppStrings._();

  // ── App ─────────────────────────────────────────────────────────────────────
  static const String appName = 'Cultini';
  static const String appTagline = 'Apprendre la culture berbère';

  // ── Auth ─────────────────────────────────────────────────────────────────────
  static const String login = 'Connexion';
  static const String register = "S'inscrire";
  static const String email = 'Adresse e-mail';
  static const String password = 'Mot de passe';
  static const String confirmPassword = 'Confirmer le mot de passe';
  static const String fullName = 'Nom complet';
  static const String forgotPassword = 'Mot de passe oublié ?';
  static const String noAccount = "Vous n'avez pas de compte ? ";
  static const String hasAccount = 'Déjà inscrit ? ';
  static const String continueWith = 'Ou continuer avec';
  static const String googleSignIn = 'Continuer avec Google';
  static const String orSeparator = 'ou';

  // ── Nav ──────────────────────────────────────────────────────────────────────
  static const String navMap = 'Carte';
  static const String navDocs = 'Docs';
  static const String navChat = 'Assistant';
  static const String navContribute = 'Contribuer';
  static const String navProfile = 'Profil';

  // ── Learn ────────────────────────────────────────────────────────────────────
  static const String unitLabel = 'UNITÉ';
  static const String lessonLabel = 'Leçon';
  static const String startLesson = 'COMMENCER';
  static const String continueLesson = 'CONTINUER';
  static const String xpGain = 'Gain';
  static const String timeEst = 'Temps';

  // ── Chat ─────────────────────────────────────────────────────────────────────
  static const String chatTitle = 'Cultini AI';
  static const String chatPlaceholder = 'Écrivez un message…';
  static const String chatWelcome =
      "Bienvenue ! Je suis votre assistant Kabyle. Comment puis-je vous aider aujourd'hui ?";

  // ── Map ──────────────────────────────────────────────────────────────────────
  static const String mapTitle = 'Carte Culturelle';
  static const String exploreCulture = 'Explorer la culture';

  // ── Marketplace ──────────────────────────────────────────────────────────────
  static const String marketplaceTitle = 'Boutique';
  static const String certifiedSeller = 'Vendeur certifié';
  static const String addToCart = 'Ajouter';
  static const String currency = 'د.م';

  // ── Profile ──────────────────────────────────────────────────────────────────
  static const String profileTitle = 'Profil';
  static const String editProfile = 'Modifier le profil';
  static const String settings = 'Paramètres';
  static const String logout = 'Déconnexion';
  static const String streak = 'Série';
  static const String totalXp = 'XP Total';
  static const String lessonsCompleted = 'Leçons';
}
