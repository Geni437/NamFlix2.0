import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../app.dart' show localeNotifier;
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

// Locale metadata — mirrors i18n/request.ts
const _supportedLocales = [
  ('en', 'English',    '🇺🇸'),
  ('fr', 'Français',   '🇫🇷'),
  ('es', 'Español',    '🇪🇸'),
  ('ar', 'العربية',    '🇸🇦'),
  ('pt', 'Português',  '🇧🇷'),
  ('de', 'Deutsch',    '🇩🇪'),
  ('hi', 'हिंदी',      '🇮🇳'),
  ('ru', 'Русский',    '🇷🇺'),
  ('zh', '中文',        '🇨🇳'),
  ('id', 'Indonesia',  '🇮🇩'),
  ('tr', 'Türkçe',     '🇹🇷'),
  ('sw', 'Kiswahili',  '🇰🇪'),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        title: const Text('Profile', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.go('/auth');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is! Authenticated) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.go('/auth'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
                  child: const Text('Sign In', style: TextStyle(color: Colors.white)),
                ),
              );
            }

            final user = state.user;
            final email = user.email ?? '';
            final initials = email.isNotEmpty ? email[0].toUpperCase() : '?';

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Avatar
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.accentRed,
                        child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 12),
                      Text(email, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(
                        'Member since ${_formatDate(user.createdAt)}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const _SectionHeader('Account'),
                _ProfileTile(
                  icon: Icons.favorite_outline_rounded,
                  label: 'Favorites',
                  onTap: () => context.push('/favorites'),
                ),
                _ProfileTile(
                  icon: Icons.history_rounded,
                  label: 'Watch History',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                const _SectionHeader('App'),
                _ProfileTile(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  onTap: () => _showLanguageDialog(context),
                ),
                _ProfileTile(
                  icon: Icons.info_outline_rounded,
                  label: 'About NamFlix',
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'NamFlix',
                    applicationVersion: '1.0.0',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          title: const Text('Sign Out', style: TextStyle(color: AppColors.textPrimary)),
                          content: const Text('Are you sure you want to sign out?',
                              style: TextStyle(color: AppColors.textSecondary)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<AuthBloc>().add(const SignOut());
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
                              child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, color: AppColors.accentRed),
                    label: const Text('Sign Out', style: TextStyle(color: AppColors.accentRed)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.accentRed),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final current = localeNotifier.value.languageCode;
    showDialog(
      context: context,
      builder: (_) => _LanguageDialog(currentCode: current),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}

class _LanguageDialog extends StatelessWidget {
  final String currentCode;
  const _LanguageDialog({required this.currentCode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      title: const Text('Language', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _supportedLocales.length,
          itemBuilder: (context, i) {
            final (code, name, flag) = _supportedLocales[i];
            final selected = code == currentCode;
            return ListTile(
              leading: Text(flag, style: const TextStyle(fontSize: 22)),
              title: Text(name, style: TextStyle(
                color: selected ? AppColors.accentRed : AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              )),
              trailing: selected
                  ? const Icon(Icons.check_rounded, color: AppColors.accentRed, size: 18)
                  : null,
              onTap: () {
                _applyLocale(context, code);
                Navigator.pop(context);
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              dense: true,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }

  void _applyLocale(BuildContext context, String code) {
    final box = Hive.box<dynamic>(AppConstants.boxSettings);
    box.put('ui_language', code);
    localeNotifier.value = Locale(code);
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
  );
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 1),
    child: ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
