import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iq_mall/cores/math_utils.dart';
// ignore: unused_import
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/store_request/widgets/payment_widget.dart';
import 'package:iq_mall/screens/transactions/contract_pdf_view.dart';
import 'package:iq_mall/screens/transactions/controllers/transactrions_controller.dart';
import 'package:flutter/src/services/system_chrome.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/custom_drop_menu.dart';
import 'package:iq_mall/widgets/ui.dart';

enum _Action { cancel, save, edit, delete }

// If you have your own colors, replace these two lines with your constants.
const _appBarColor = Colors.white; // Title bar color (no purple)
Color _accentColor = ColorConstant.logoSecondColorConstant; // Accents (icons, chips highlights)

class TransactionsView extends GetView<TransactionsController> {
  const TransactionsView({super.key});

// Build defaults exactly like your current logic
  List<AppBarMenuItem<_Action>> defaultTxnMenuItems(dynamic c, bool isEnabled) {
    final items = <AppBarMenuItem<_Action>>[];

    items.add(
      AppBarMenuItem<_Action>(
        value: _Action.delete,
        label: !isEnabled ? "Enable Store" : 'Delete Store'.tr,
        icon: isEnabled ? Icons.delete_forever : Icons.check_circle,
        color: isEnabled ? Colors.red : Colors.green,
        onTap: () async {
          final confirmed = await showDialog<bool>(
            context: Get.context!,
            barrierDismissible: true,
            builder: (ctx) => ConfirmToggleStoreDialog(isEnabled: isEnabled),
          );

          if (confirmed == true) {
            try {
              await c.deleteRequest();
              if (Get.context!.mounted) Get.back();
            } catch (_) {
              Ui.flutterToast('Disable failed'.tr, Toast.LENGTH_SHORT, Colors.red, Colors.white);
            }
          }
        },
      ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          Obx(
            () => controller.isLoading.value
                ? const SizedBox(width: 48) // placeholder to avoid jump when loading completes
                : ActionsDropdown(
                    menuYOffset: 40,
                    itemsBuilder: () {
                      final c = Get.find<TransactionsController>(); // same controller
                      return defaultTxnMenuItems(c, controller.requests.first.status.toLowerCase() == "deleted" ? false : true);
                    },
                  ),
          ),
        ],
        title: const Text(
          'Transactions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          tooltip: 'Back',
        ),
      ),
      body: const _Body(),
      // ignore: prefer_const_constructors
      floatingActionButton: RenewSubscriptionFab(
        paymentRoute: '/payment-view', // your GetX route name
        // optional: pass data to payment screen
        routeArgs: const {'subscriptionId': 123},
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Get.find<TransactionsController>().refreshData(),
      color: ColorConstant.logoFirstColor,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Pinned header: TOTAL + FILTERS
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedHeaderDelegate(
              minExtent: getVerticalSize(247),
              maxExtent: getVerticalSize(247),
              child: const _PinnedTotalAndFilters(),
            ),
          ),

          // List
          const _TransactionsSliverList(),
        ],
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });
  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent || oldDelegate.child != child;
  }
}

class _PinnedTotalAndFilters extends StatelessWidget {
  const _PinnedTotalAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final c = Get.find<TransactionsController>();
      final loading = c.isLoading.value;

      return Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        color: Colors.white,
        child: Column(
          children: [
            loading
                ? const StoreRegisterCardShimmer()
                : StoreRegisterCard(
                    storeName: c.requests.first.storeName,
                    registerDate: c.requests.first.createdAt ?? DateTime.now(),
                    endDate: c.requests.first.endDate,
                  ),
            const SizedBox(height: 8),
            loading ? const TotalCardShimmer() : _buildRealTotal(theme),
            const SizedBox(height: 8),
            // Filters stay visible (optionally disable taps while loading)
            loading ? const FilterBarShimmer() : const Align(alignment: Alignment.centerLeft, child: _FilterBar()),
          ],
        ),
      );
    });
  }

  Widget _buildRealTotal(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: getVerticalSize(70),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: _accentColor),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() {
                  final c = Get.find<TransactionsController>();
                  final total = c.filteredTxns.fold<double>(0, (p, e) => p + e.amount);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total', style: theme.textTheme.labelMedium?.copyWith(color: Colors.black54)),
                      const SizedBox(height: 2),
                      Text(
                        '${c.currency.value}${c.money.format(total)}',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ],
                  );
                }),
              ),
              Obx(() {
                final c = Get.find<TransactionsController>();
                return RotationTransition(
                  turns: c.refreshController,
                  child: IconButton(
                    onPressed: c.isLoadingTransactions.value ? null : c.refreshData,
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: getSize(20),
                      color: c.isLoadingTransactions.value ? Colors.grey : Colors.black87,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransactionsController>();
    final df = DateFormat('yMMMd');

    return Obx(() {
      final f = c.activeFilter.value;
      final customLabel = () {
        if (f != TxnFilter.custom) return 'Custom';
        final from = c.customFrom.value;
        final to = c.customTo.value;
        if (from == null || to == null) return 'Custom';
        return '${df.format(from)} — ${df.format(to)}';
      }();

      return

          //   c.isLoading.value?
          //   Container(
          //   padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          //   color: Colors.white,
          //   child: const Column(
          //     children: [
          //       StoreRegisterCardShimmer(),

          //       SizedBox(height: 8),
          //        TotalCardShimmer(),
          //       SizedBox(height: 10),
          //       // Filters stay visible (optionally disable taps while loading)
          //       Align(alignment: Alignment.centerLeft, child: _FilterBar()),
          //     ],
          //   ),
          // ):
          Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _Chip(label: 'All', selected: f == TxnFilter.all, onTap: () => c.applyFilter(TxnFilter.all)),
          _Chip(label: '1D', selected: f == TxnFilter.day, onTap: () => c.applyFilter(TxnFilter.day)),
          _Chip(label: '1W', selected: f == TxnFilter.week, onTap: () => c.applyFilter(TxnFilter.week)),
          _Chip(label: '1M', selected: f == TxnFilter.month, onTap: () => c.applyFilter(TxnFilter.month)),
          _Chip(
            label: customLabel,
            selected: f == TxnFilter.custom,
            onTap: () async {
              final now = DateTime.now();
              final first = DateTime(now.year - 1);
              final picked = await showDateRangePicker(
                context: context,
                firstDate: first,
                lastDate: DateTime(now.year + 1, 12, 31),
                initialDateRange: c.customFrom.value != null && c.customTo.value != null ? DateTimeRange(start: c.customFrom.value!, end: c.customTo.value!) : DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
                helpText: 'Custom Date Range',
                builder: (ctx, child) {
                  final baseTheme = Theme.of(ctx);
                  return Theme(
                    data: baseTheme.copyWith(
                      colorScheme: baseTheme.colorScheme.copyWith(
                        brightness: Brightness.light, // ensure dark text/icons
                        primary: _accentColor,
                        onPrimary: Colors.black, // icons & text inside header
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                      appBarTheme: const AppBarTheme(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black, // text + icons dark
                        iconTheme: IconThemeData(color: Colors.black),
                        titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        systemOverlayStyle: SystemUiOverlayStyle.dark, // dark status bar icons
                      ),
                      dialogBackgroundColor: Colors.white,
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: _accentColor),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                c.applyFilter(TxnFilter.custom, from: picked.start, to: picked.end);
              }
            },
          ),
        ],
      );
    });
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _Chip({required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: getPadding(all: 7),
        decoration: BoxDecoration(
          color: selected ? _accentColor.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? _accentColor : Colors.black12),
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w800, color: selected ? _accentColor : Colors.black87, fontSize: getFontSize(12)),
        ),
      ),
    );
  }
}

class _TransactionsSliverList extends StatelessWidget {
  const _TransactionsSliverList();
  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransactionsController>();
    final theme = Theme.of(context);

    return Obx(() {
      if (c.isLoadingTransactions.value || c.isLoading.value) {
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(4, 2, 4, getBottomPadding() + 5),
          sliver: SliverList.separated(
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (_, __) => const TxnTileShimmer(),
          ),
        );
      }

      final items = c.filteredTxns;
      if (items.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inbox_outlined, size: 48, color: theme.disabledColor),
                const SizedBox(height: 8),
                Text('No transactions found', style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor)),
              ],
            ),
          ),
        );
      }

      return c.isLoadingTransactions.value
          ? SizedBox()
          : SliverPadding(
              padding: EdgeInsets.fromLTRB(4, 2, 4, getBottomPadding() + 5),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (_, i) => _TxnTile(index: i),
              ),
            );
    });
  }
}

class _TxnTile extends StatelessWidget {
  const _TxnTile({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransactionsController>();
    final t = c.filteredTxns[index];
    final df = DateFormat('yMMMd • HH:mm');

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 220 + (index % 6) * 25),
      curve: Curves.easeOutCubic,
      builder: (ctx, v, child) => Transform.translate(
        offset: Offset(0, (1 - v) * 8),
        child: Opacity(opacity: v, child: child),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          dense: true,
          horizontalTitleGap: 10,
          leading: _PaymentTypeIcon(type: t.paymentType),
          title: Text(
            '${c.currency.value}${c.money.format(t.amount)}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  df.format(t.date),
                  style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                ),
                const SizedBox(height: 1),
                Text(
                  'Recipient: ${t.recipientName}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                Text(
                  'Ends: ${DateFormat('yMMMd').format(t.subscriptionEndDate)}',
                  style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentTypeIcon extends StatelessWidget {
  final String type;
  const _PaymentTypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.payments_rounded;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: _accentColor),
    );
  }
}

class StoreRegisterCard extends StatelessWidget {
  final String storeName;
  final DateTime registerDate;
  final DateTime? endDate;

  const StoreRegisterCard({
    Key? key,
    required this.storeName,
    required this.registerDate,
    this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final c = Get.find<TransactionsController>();

    return SizedBox(
      height: 110, // reduced from 150
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.store, color: Colors.blueGrey, size: 18),
                  const SizedBox(width: 6),
                  SizedBox(
                    child: Text(
                      storeName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87, overflow: TextOverflow.ellipsis),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  PdfActionsCard(
                    pdfUrl: c.contractPdf.value?.pdfUrl ?? '',
                    fileName: "contract".tr,
                    viewInBrowserByDefault: true,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(height: 1, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              // Dates section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateColumn(
                    label: 'Register',
                    date: dateFormat.format(registerDate),
                    icon: Icons.calendar_today_outlined,
                    color: Colors.green,
                  ),
                  _buildDateColumn(
                    label: 'End',
                    date: endDate != null ? dateFormat.format(endDate!) : "N/A",
                    icon: Icons.event_busy,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateColumn({
    required String label,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class RenewSubscriptionFab extends StatelessWidget {
  final String paymentRoute;
  final Map<String, dynamic>? routeArgs;

  const RenewSubscriptionFab({
    Key? key,
    required this.paymentRoute,
    this.routeArgs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Get.find<TransactionsController>().isLoading.value
        ? const SizedBox()
        : FloatingActionButton.extended(
            heroTag: 'renew_sub_fab',
            backgroundColor: ColorConstant.logoSecondColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 👈 smaller, sharper corners (was pill shape)
              side: BorderSide(
                color: Colors.white.withOpacity(0.3), // optional thin border outline
                width: 1.0,
              ),
            ),
            icon: Icon(
              Icons.autorenew_rounded,
              size: getSize(22),
              color: Colors.white,
            ),
            label: Text('Renew',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: getFontSize(14),
                  color: Colors.white,
                )),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                barrierDismissible: true,
                builder: (ctx) => Dialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 28),
                  backgroundColor: ColorConstant.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.autorenew_rounded, size: 40, color: Colors.black),
                        const SizedBox(height: 12),
                        Text(
                          'Renew Subscription?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Are you sure you want to renew your subscription now?',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red, width: 1), // ✅ red border
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red), // ✅ red text
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  Get.to(
                                      () => PaymentImagePickerScreen(
                                            request: Get.find<TransactionsController>().requests.first,
                                            isReneu: true,
                                          ),
                                      transition: Transition.rightToLeft,
                                      duration: const Duration(milliseconds: 200));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accentColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Yes, Renew'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );

              if (confirmed == true) {
                Get.toNamed(paymentRoute, arguments: routeArgs);
              }
            },
          ));
  }
}

/// Simple shimmer using a moving gradient in a ShaderMask.
/// Usage: Shimmer(child: <your skeleton container>)
class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const Shimmer({super.key, required this.child, this.duration = const Duration(milliseconds: 1200)});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final double slide = (_c.value * 2 - 0.5); // [-0.5, 1.5]
        return ShaderMask(
          shaderCallback: (rect) {
            final width = rect.width;
            return LinearGradient(
              begin: Alignment(-1 + slide, 0),
              end: Alignment(1 + slide, 0),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(rect.shift(Offset(width * (slide - 0.5), 0)));
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

/// Quick skeleton box with radius
Widget shimmerBox({double height = 12, double? width, double radius = 8}) {
  return Shimmer(
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

class StoreRegisterCardShimmer extends StatelessWidget {
  const StoreRegisterCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  // icon circle
                  Shimmer(
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: shimmerBox(height: 14, radius: 4)),
                  const SizedBox(width: 8),
                  // pdf button placeholder
                  shimmerBox(height: 28, width: 90, radius: 6),
                ],
              ),
              const SizedBox(height: 8),
              Divider(height: 1, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    shimmerBox(height: 12, width: 80, radius: 4),
                    const SizedBox(height: 6),
                    shimmerBox(height: 14, width: 120, radius: 4),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    shimmerBox(height: 12, width: 60, radius: 4),
                    const SizedBox(height: 6),
                    shimmerBox(height: 14, width: 110, radius: 4),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalCardShimmer extends StatelessWidget {
  const TotalCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: getVerticalSize(70),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              shimmerBox(height: 22, width: 22, radius: 11),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(height: 10, width: 50, radius: 4),
                    const SizedBox(height: 6),
                    shimmerBox(height: 18, width: 140, radius: 6),
                  ],
                ),
              ),
              shimmerBox(height: 24, width: 24, radius: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class TxnTileShimmer extends StatelessWidget {
  const TxnTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        dense: true,
        horizontalTitleGap: 10,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: shimmerBox(height: 20, width: 20, radius: 10),
          alignment: Alignment.center,
        ),
        title: shimmerBox(height: 14, width: 100, radius: 4),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: 10, width: 140, radius: 4),
              const SizedBox(height: 4),
              shimmerBox(height: 10, width: 120, radius: 4),
              const SizedBox(height: 4),
              shimmerBox(height: 10, width: 100, radius: 4),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single shimmer chip placeholder (rounded, bordered), matching your chip style.
class _ChipShimmer extends StatelessWidget {
  final double width;
  final bool emphasized; // slightly darker bg to simulate "selected"
  const _ChipShimmer({required this.width, this.emphasized = false});

  @override
  Widget build(BuildContext context) {
    final bg = emphasized ? Colors.grey.shade300 : Colors.white;
    final border = emphasized ? _accentColor : Colors.black12;

    return Shimmer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border, width: 1),
        ),
        child: Container(
          // inner bar to mimic text length
          height: 10,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}

class FilterBarShimmer extends StatelessWidget {
  final int count;
  const FilterBarShimmer({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    // Simulate "All, 1D, 1W, 1M, Custom" widths
    final widths = <double>[26, 22, 28, 30, 80];
    final chips = List.generate(count, (i) {
      final w = widths[i % widths.length];
      final emphasized = (i % widths.length) == widths.length - 1;
      return _ChipShimmer(width: w, emphasized: emphasized);
    });

    return Wrap(
      spacing: 6, // tighter spacing
      runSpacing: 6,
      children: chips,
    );
  }
}

class ConfirmToggleStoreDialog extends StatelessWidget {
  final bool isEnabled; // true = store currently enabled, false = disabled

  const ConfirmToggleStoreDialog({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    final title = isEnabled ? 'Disable store?' : 'Enable store?';
    final actionText = isEnabled ? 'Disable' : 'Enable';
    final color = isEnabled ? Colors.red : Colors.green;
    final icon = isEnabled ? Icons.warning_rounded : Icons.check_circle_rounded;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              isEnabled ? 'This action will disable the store and cannot be undone.'.tr : 'This action will enable the store for operations.'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Cancel'.tr),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(actionText.tr),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
