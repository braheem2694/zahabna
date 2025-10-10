import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ---------- Model for menu items ----------
class AppBarMenuItem<T> {
  final T value;
  final String label;
  final IconData icon;
  final Color? color;
  final bool enabled;
  final FutureOr<void> Function()? onTap;

  const AppBarMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.color,
    this.enabled = true,
    this.onTap,
  });
}

// ---------- Reusable Menu Widget ----------
class ActionsDropdown<T> extends StatefulWidget {
  /// Build your items dynamically (called every build).
  final List<AppBarMenuItem<T>> Function() itemsBuilder;

  /// Menu appearance
  final Color menuBackgroundColor;
  final double menuBorderRadius;
  final double menuYOffset; // how far to push the menu down

  /// Trigger appearance
  final double triggerPadding;
  final double triggerRadius;
  final IconData triggerIcon;
  final Color? triggerIconColor;

  const ActionsDropdown({
    super.key,
    required this.itemsBuilder,
    this.menuBackgroundColor = const Color(0xFFFFFFFF), // matches ColorConstant.whiteA700
    this.menuBorderRadius = 14,
    this.menuYOffset = 10,
    this.triggerPadding = 8,
    this.triggerRadius = 12,
    this.triggerIcon = Icons.more_vert,
    this.triggerIconColor,
  });

  @override
  State<ActionsDropdown<T>> createState() => _AppBarActionsDropdownState<T>();
}

class _AppBarActionsDropdownState<T> extends State<ActionsDropdown<T>> {
  bool _menuOpen = false;

  Future<void> _openMenuAtButton(BuildContext ctx, List<AppBarMenuItem<T>> items) async {
    final RenderBox button = ctx.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(ctx).context.findRenderObject() as RenderBox;

    final topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final bottomRight = button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay);

    final pos = RelativeRect.fromRect(
      Rect.fromPoints(
        topLeft + Offset(0, widget.menuYOffset),
        bottomRight + Offset(0, widget.menuYOffset),
      ),
      Offset.zero & overlay.size,
    );

    setState(() => _menuOpen = true);
    final selected = await showMenu<T>(
      context: ctx,
      position: pos,
      elevation: 0,
      color: widget.menuBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.menuBorderRadius)),
      items: items.map((e) {
        final ic = Icon(e.icon, color: e.color ?? Colors.black87);
        final tx = Text(
          e.label,
          style: TextStyle(
            color: e.enabled ? (e.color ?? Colors.black87) : Colors.black38,
            fontWeight: FontWeight.w600,
          ),
        );
        return PopupMenuItem<T>(
          enabled: e.enabled,
          value: e.value,
          child: Row(children: [
            ic,
            const SizedBox(width: 12),
            tx,
          ]),
        );
      }).toList(),
    );
    setState(() => _menuOpen = false);

    if (selected == null) return;
    HapticFeedback.selectionClick();

    // find the selected item, run its handler if provided
    final match = items.firstWhereOrNull((e) => e.value == selected);
    if (match?.onTap != null) await match!.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.itemsBuilder();
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openMenuAtButton(context, items),
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: _menuOpen ? 0.25 : 0.0,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(widget.triggerPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.triggerRadius),
              ),
              child: Icon(
                widget.triggerIcon,
                color: widget.triggerIconColor ?? Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// small helper since we're not importing collection
extension _FirstWhereOrNullExt<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
