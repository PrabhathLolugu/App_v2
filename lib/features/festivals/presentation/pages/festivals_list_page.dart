import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/features/festivals/domain/entities/hindu_festival.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Lists all Sanatan festivals; tap opens [FestivalDetailPage].
class FestivalsListPage extends StatefulWidget {
  const FestivalsListPage({super.key});

  @override
  State<FestivalsListPage> createState() => _FestivalsListPageState();
}

class _FestivalsListPageState extends State<FestivalsListPage> {
  List<HinduFestival> _festivals = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFestivals();
  }

  Future<void> _loadFestivals() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await Supabase.instance.client
          .from('hindu_festivals')
          .select()
          .order('order_index');
      final list = (response as List)
          .map((e) => HinduFestival.fromJson(e as Map<String, dynamic>))
          .toList();
      if (mounted) {
        setState(() {
          _festivals = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).festivals.title),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: _loadFestivals,
                          child: Text(Translations.of(context).common.retry),
                        ),
                      ],
                    ),
                  ),
                )
              : _festivals.isEmpty
                  ? Center(
                      child: Text(
                        'No festivals to show.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadFestivals,
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          16.w,
                          16.w,
                          16.w,
                          16.w + MediaQuery.paddingOf(context).bottom,
                        ),
                        itemCount: _festivals.length,
                        itemBuilder: (context, index) {
                          final festival = _festivals[index];
                          return _FestivalListTile(
                            festival: festival,
                            onTap: () {
                              FestivalDetailRoute($extra: festival)
                                  .push(context);
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}

class _FestivalListTile extends StatelessWidget {
  final HinduFestival festival;
  final VoidCallback onTap;

  const _FestivalListTile({
    required this.festival,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: festival.imageUrl,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  semanticLabel: festival.name,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      festival.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (festival.whenCelebrated != null &&
                        festival.whenCelebrated!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        festival.whenCelebrated!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (festival.shortDescription != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        festival.shortDescription!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
