import re
import sys

path = r'lib\services\auth_service.dart'
content = open(path, encoding='utf-8').read()

old = (
    '      // If user signed up with email confirmation, users/profile may not exist yet; create them now\n'
    '      await ensureUserAndProfileAfterSignIn();\n'
    '\n'
    '      return response;\n'
    '    } on AuthServiceException {'
)

new = (
    '      // Gate: block sign-in for users whose email is not yet confirmed.\n'
    '      // Defence-in-depth: Supabase enforces this server-side when "Confirm email"\n'
    '      // is ON, but accounts created while it was OFF bypass that check.\n'
    '      // We sign them back out here so they cannot enter authenticated routes.\n'
    '      if (response.user!.emailConfirmedAt == null) {\n'
    '        talker.warning(\'[SignIn] Email not confirmed for ${response.user!.id} — signing out.\');\n'
    '        try { await _supabase.auth.signOut(); } catch (_) {}\n'
    '        throw AuthServiceException(\n'
    '          \'Please verify your email address before signing in. Check your inbox for the verification link.\',\n'
    '          originalError: \'email_not_confirmed\',\n'
    '        );\n'
    '      }\n'
    '\n'
    '      // If user signed up with email confirmation, users/profile may not exist yet; create them now\n'
    '      await ensureUserAndProfileAfterSignIn();\n'
    '\n'
    '      return response;\n'
    '    } on AuthServiceException {'
)

if old in content:
    result = content.replace(old, new, 1)
    open(path, 'w', encoding='utf-8').write(result)
    print('REPLACED OK')
else:
    print('NOT FOUND — dump first 2 chars of expected vs actual:')
    idx = content.find('// If user signed up with email confirmation')
    print(repr(content[idx-10:idx+120]))
    print(repr(content[idx-10:idx+120]))
