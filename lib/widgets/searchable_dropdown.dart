import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShColors.dart';

class SearchableDropdown<T> extends StatelessWidget {
  final String label;
  final String? value;
  final String? hint;
  final IconData? icon;
  final bool isReadOnly;
  final bool isLocalSearch;
  final Future<List<T>> Function(String search, int page) fetchItems;
  final String Function(T item) itemLabel;
  final void Function(T item) onChanged;
  final String? Function(String?)? validator;

  const SearchableDropdown({
    Key? key,
    required this.label,
    this.value,
    this.hint,
    this.icon,
    this.isReadOnly = false,
    this.isLocalSearch = false,
    required this.fetchItems,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isReadOnly,
      child: GestureDetector(
        onTap: () {
          if (!isReadOnly) {
            _showSearchBottomSheet(context);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: TextEditingController(text: value),
            readOnly: true,
            style: TextStyle(
                color: ColorConstant.black900,
                fontSize: 15,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              labelText: label.tr,
              labelStyle: TextStyle(color: ColorConstant.gray500, fontSize: 14),
              floatingLabelStyle:
                  TextStyle(color: ColorConstant.logoSecondColor, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFFFFBF5),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: icon != null
                  ? Icon(icon, color: ColorConstant.logoSecondColor, size: 20)
                  : null,
              suffixIcon: Icon(Icons.arrow_drop_down,
                  color: ColorConstant.logoSecondColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: ColorConstant.logoSecondColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchBottomSheet<T>(
        label: label,
        fetchItems: fetchItems,
        itemLabel: itemLabel,
        onChanged: onChanged,
        isLocalSearch: isLocalSearch,
      ),
    );
  }
}

class _SearchBottomSheet<T> extends StatefulWidget {
  final String label;
  final Future<List<T>> Function(String search, int page) fetchItems;
  final String Function(T item) itemLabel;
  final void Function(T item) onChanged;
  final bool isLocalSearch;

  const _SearchBottomSheet({
    Key? key,
    required this.label,
    required this.fetchItems,
    required this.itemLabel,
    required this.onChanged,
    this.isLocalSearch = false,
  }) : super(key: key);

  @override
  State<_SearchBottomSheet<T>> createState() => _SearchBottomSheetState<T>();
}

class _SearchBottomSheetState<T> extends State<_SearchBottomSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<T> _items = [];
  List<T> _allItems = []; // Store all fetched items for local search
  bool _isLoading = false;
  int _page = 1;
  bool _hasMore = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      if (!widget.isLocalSearch) {
        _loadItems();
      }
    }
  }

  void _onSearchChanged(String query) {
    if (widget.isLocalSearch) {
      // Local filtering
      setState(() {
        if (query.isEmpty) {
          _items = List.from(_allItems);
        } else {
          _items = _allItems
              .where((item) => widget
                  .itemLabel(item)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }
      });
    } else {
      // Server-side filtering
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _items.clear();
          _page = 1;
          _hasMore = true;
        });
        _loadItems();
      });
    }
  }

  Future<void> _loadItems() async {
    if (_isLoading || (!_hasMore && !widget.isLocalSearch)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // If local search, we fetch with empty search initially (or whatever the controller logic handles)
      // We assume fetchItems handles the logic for "initial load" correctly.
      final newItems = await widget.fetchItems(
          widget.isLocalSearch ? "" : _searchController.text, _page);

      if (mounted) {
        setState(() {
          if (widget.isLocalSearch) {
            // For local search, we assume potentially one large page or we keep appending?
            // "data returned only" implies we fetch once.
            // Let's assume pagination might still apply if we want to fetch *all* pages,
            // but for simplicity and typical dropdown use cases, we might just load one big page or append.
            _allItems.addAll(newItems);
            _items = List.from(_allItems);
            // Re-apply filter if there is search text (edge case: loading more while searching locally)
            if (_searchController.text.isNotEmpty) {
              _items = _allItems
                  .where((item) => widget
                      .itemLabel(item)
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .toList();
            }
          } else {
            _items.addAll(newItems);
          }

          _page++;
          if (newItems.isEmpty || newItems.length < 10) {
            _hasMore = false;
          }
        });
      }
    } catch (e) {
      print("Error loading items: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Text(
                  "Select ${widget.label}".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.black900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search...".tr,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          // List
          Expanded(
            child: _items.isEmpty && !_isLoading
                ? Center(child: Text("No items found".tr))
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: _items.length + (_isLoading ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index == _items.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final item = _items[index];
                      return ListTile(
                        title: Text(widget.itemLabel(item)),
                        onTap: () {
                          widget.onChanged(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
