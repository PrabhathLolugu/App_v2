import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_hub.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FabricShopPage extends StatelessWidget {
  const FabricShopPage({super.key, required this.hub});

  final FabricHub hub;

  SupabaseClient get _supabase => Supabase.instance.client;

  Future<void> _openWebsite(BuildContext context, String website) async {
    final raw = website.trim();
    if (raw.isEmpty) return;
    final uri = Uri.tryParse(
      raw.startsWith('http://') || raw.startsWith('https://')
          ? raw
          : 'https://$raw',
    );
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open portal right now.')),
      );
    }
  }

  Future<void> _submitToMyItihas({
    required String sellerName,
    required String organization,
    required String sellerType,
    required String contact,
    required String email,
    required String officeAddress,
    required String city,
    required String note,
    required String website,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    await _supabase.from('fabric_seller_submissions').insert({
      'fabric_hub_id': hub.id,
      'submitted_by': userId,
      'status': 'pending',
      'payload': {
        'sellerName': sellerName,
        'organization': organization,
        'sellerType': sellerType,
        'contact': contact,
        'officialEmail': email,
        'officeAddress': officeAddress,
        'city': city,
        'note': note,
        'website': website,
        'hubName': hub.name,
        'fabricName': hub.fabricName,
      },
    });
  }

  Future<void> _showAddSellerSheet(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final orgCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final websiteCtrl = TextEditingController();
    String sellerType = 'verified';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final pad = MediaQuery.viewInsetsOf(ctx).bottom;
        return Padding(
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 2.h,
            bottom: pad + 2.h,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Submit seller to MyItihas',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  SizedBox(height: 0.8.h),
                  Text(
                    'This goes to MyItihas moderation queue (not email).',
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Seller name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: orgCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Organization / portal',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  StatefulBuilder(
                    builder: (context, setStateLocal) {
                      return DropdownButtonFormField<String>(
                        initialValue: sellerType,
                        decoration: const InputDecoration(
                          labelText: 'Seller type',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'government',
                            child: Text('Government'),
                          ),
                          DropdownMenuItem(
                            value: 'cooperative',
                            child: Text('Cooperative'),
                          ),
                          DropdownMenuItem(
                            value: 'verified',
                            child: Text('Verified'),
                          ),
                        ],
                        onChanged: (v) =>
                            setStateLocal(() => sellerType = v ?? sellerType),
                      );
                    },
                  ),
                  TextFormField(
                    controller: contactCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Support phone / helpline',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Official email (optional)',
                    ),
                  ),
                  TextFormField(
                    controller: websiteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Official website / portal (optional)',
                    ),
                  ),
                  TextFormField(
                    controller: addressCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Office address (optional)',
                    ),
                  ),
                  TextFormField(
                    controller: cityCtrl,
                    decoration: const InputDecoration(labelText: 'City'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: noteCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Why should this seller be listed?',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  FilledButton(
                    onPressed: () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      Navigator.of(ctx).pop();
                      if (!context.mounted) return;
                      try {
                        await _submitToMyItihas(
                          sellerName: nameCtrl.text.trim(),
                          organization: orgCtrl.text.trim(),
                          sellerType: sellerType,
                          contact: contactCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          officeAddress: addressCtrl.text.trim(),
                          city: cityCtrl.text.trim(),
                          note: noteCtrl.text.trim(),
                          website: websiteCtrl.text.trim(),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Submission stored in MyItihas review queue.',
                            ),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Submission failed. Please retry. ($e)',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit to MyItihas'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    nameCtrl.dispose();
    orgCtrl.dispose();
    contactCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    noteCtrl.dispose();
    websiteCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.map.fabricMap.shopTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSellerSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Seller'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          Text(
            hub.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.4.h),
          Text(
            hub.fabricName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.8.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.45,
              ),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Text(
              'Curated official and trusted channels for ${hub.fabricName}. '
              'Always confirm authenticity, return policy, and current stock on official portals.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Official, cooperative & verified sellers',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          if (hub.sellers.isEmpty)
            Card(
              child: ListTile(
                title: const Text('No sellers listed yet'),
                subtitle: const Text(
                  'Use Add Seller to submit an official portal or cooperative for review.',
                ),
                trailing: const Icon(Icons.pending_actions_outlined),
              ),
            ),
          ...hub.sellers.map((s) {
            final type = s.sellerType.toLowerCase();
            final badge = type == 'cooperative'
                ? 'Co-op'
                : (type == 'verified' ? 'Verified' : 'Government');
            return Card(
              margin: EdgeInsets.only(bottom: 1.4.h),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(s.name)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.3.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.35,
                            ),
                          ),
                        ),
                        child: Text(
                          badge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${s.organization}\n'
                    '${s.contactLine}'
                    '${(s.city ?? '').isEmpty ? '' : '\nCity: ${s.city}'}'
                    '${(s.website ?? '').isEmpty ? '' : '\nPortal: ${s.website}'}',
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Icon(
                    s.isFeatured
                        ? Icons.workspace_premium
                        : Icons.verified_outlined,
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          }),
          ...hub.sellers
              .where((s) => (s.website ?? '').trim().isNotEmpty)
              .map(
                (s) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: OutlinedButton.icon(
                    onPressed: () => _openWebsite(context, s.website!),
                    icon: const Icon(Icons.open_in_new),
                    label: Text('Open ${s.name} portal'),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
