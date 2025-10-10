import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:path/path.dart' as path;
import 'package:animated_icon/animated_icon.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/Stores_screen/widgets/style_bottomsheet.dart';
import 'package:iq_mall/screens/Stores_screen/widgets/video_item.dart';
import 'dart:io';
import 'package:lottie/src/lottie.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart' as fn; // ✅ Import compute function

import '../../../API.dart';
import '../../../cores/assets.dart';
import '../../../models/HomeData.dart';
import '../../../models/Stores.dart';
import '../../../utils/ShImages.dart';
import '../../../widgets/ViewAllButton.dart';
import '../../../widgets/chewie_player.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/html_widget.dart';
import '../../ProductDetails_screen/widgets/better_player.dart';
import '../controller/my_store_controller.dart';
import 'description_widget.dart';
import 'package:iq_mall/models/functions.dart';
import 'package:dio/dio.dart' as dio;
import 'package:percent_indicator/percent_indicator.dart';

import 'item_bottomsheet_widget.dart';

class AddNewItemScreen extends StatefulWidget {
  final String? fromKey;
  final Product? product;

  const AddNewItemScreen({super.key, this.fromKey, this.product});

  @override
  _AddNewItemScreenState createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Define controllers for text fields
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController priceAfterDiscountController = TextEditingController();
  final TextEditingController productCodeController = TextEditingController();

  // final TextEditingController productWeightController = TextEditingController();
  final TextEditingController productkeratController = TextEditingController();
  final TextEditingController salesDiscountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController optionsController = TextEditingController();
  final TextEditingController variationFoundController = TextEditingController();
  final TextEditingController variantIdController = TextEditingController();
  late HtmlEditorController descriptionController;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  RxBool refreshDropDown = false.obs;
  late final AnimationController _animationController;

  String? mainImage;

  List<int> gemstoneStylesIds = <int>[];
  List<String> moreImages = [];
  List<String> moreVideos = [];
  RxBool addingItem = false.obs;
  RxBool deletingItem = false.obs;
  RxList<RxDouble> imageUploadPercent = <RxDouble>[].obs;
  RxList<String> images = <String>[].obs;
  bool flatDiscount = true;
  bool loadingStores = true;
  String? dynamicFieldsJson;
  Map<String, String> dynamicFields = <String, String>{};
  String? selectedMetalType;
  String? selectedGemstoneType;
  bool isStyleEmpty = false;
  String? selectedGemstoneStyleFirst;
  RxString? selectedCut;
  RxString? selectedClarity;
  RxString selectedCatId = "".obs;
  RxString? selectedColor;
  RxList? diamondColors = [].obs;

  RxInt remainingFiles = 0.obs;

  RxList<Category> selectedCategoriesList = <Category>[].obs;
  RxMap<int, List<Category>> selectedCategoriesMap = RxMap<int, List<Category>>();
  Rx<ProductType>? selectedTypeObject = ProductType(items: []).obs;
  List dynamicTextControllers = [];
  RxMap<int, List<Category>> selectedCatObjectList = RxMap<int, List<Category>>();
  Rxn<StoreClass>? selectedStoreObject = Rxn();
  RxList<List<Category>> subCategoriesList = RxList<List<Category>>();
  Rx<String> productTypeName = ''.obs;
  Rx<int> productTypeId = 0.obs;
  Rxn<Category>? selectedCatObject = Rxn();
  Rx<Product>? product;
  RxBool policyAlert = false.obs;
  RxBool categoryAlert = false.obs;
  RxBool categoryAlertText = false.obs;
  RxBool policyAlertText = false.obs;
  RxBool loadingProduct = true.obs;
  RxBool loadingCategory = true.obs;
  RxBool loadingCategoriesDropDown = false.obs;
  RxList<Widget> categoriesDropDown = <Widget>[].obs;
  RxList<Widget> gemstonStylesDropDowns = <Widget>[].obs;

  List<String> cut = ['Excellent', 'Very Good', 'Good', 'Fair', 'Poor'];
  List<String> clarity = [
    'FL (Flawless)',
    'IF (Internally Flawless)',
    'VVS1/VVS2 (Very Very Slightly Included)',
    'VS1/VS2 (Very Slightly Included)',
    'SI1/SI2 (Slightly Included)',
    'I1/I2/I3 (Included)',
  ];

  final List<Map<String, dynamic>> items = [
    {'type': 'textfield', 'label': 'Name'},
    {
      'type': 'dropdown',
      'label': 'Hobbies',
      'options': ['Reading', 'Gaming', 'Traveling', 'Cooking']
    },
  ];

  RxList<Category> itemCategories = <Category>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMainImage() async {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        height: getVerticalSize(120),
        width: Get.width,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                function.SingleImagePicker(ImageSource.gallery).then((value) {
                  if (value != null) {
                    setState(() {
                      mainImage = value.path;
                    });
                  }
                  Get.back();
                });
              },
              child: Text(
                "Select Image",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Divider(
              color: ColorConstant.black900,
            ),
            TextButton(
              onPressed: () {
                function.SingleImagePicker(ImageSource.camera).then((value) {
                  if (value != null) {
                    setState(() {
                      mainImage = value.path;
                    });
                  }
                  Get.back();
                });
              },
              child: Text(
                "Take Photo",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  void resetFields() {
    productNameController.clear();
    productPriceController.clear();
    priceAfterDiscountController.clear();
    productCodeController.clear();
    // productWeightController.clear();
    productkeratController.clear();
    salesDiscountController.clear();
    quantityController.clear();
    optionsController.clear();
    variationFoundController.clear();
    variantIdController.clear();
    selectedStoreObject?.value = null; // Reset selected store
    selectedCatId.value = ''; // Reset selected category
    flatDiscount = false; // Reset flatDiscount flag if it's a boolean
    dynamicFieldsJson = null; // Reset dynamic fields JSON if it's a Map
    selectedCategoriesMap.clear();
    selectedCatObjectList.clear();
    selectedStoreObject?.value = null;
    selectedMetalType = null;
    selectedGemstoneType = null;
    selectedCategoriesMap.clear();
    globalController.selectedGemstoneStyle.clear();
    globalController.selectedGemstoneStyle.add(null);
    globalController.itemGemstoneStyles.clear();
    globalController.gemstonesDropDownMap.clear();
    globalController.gemstonStylesDropList.removeRange(1, globalController.gemstonStylesDropList.length);
    globalController.resetMetalFields(globalController.metals, globalController.gemstones);
    globalController.resetGemstonStylesDropList();
    globalController.resetgemstonesDropDownMap();
    try {
      descriptionController.setText(""); // For HtmlEditorController
    } catch (e) {
      print(e);
    }
    // Reset dynamic fields JSON if it's a Map
  }

  resetStyle(int index){
    globalController.selectedGemstoneStyle.removeAt(index);
    if(index==0){
      globalController.selectedGemstoneStyle.add(null);

    }
    if(index>0){
      globalController.gemstonStylesDropList.removeAt(index);

    }
    try{
      globalController.itemGemstoneStyles.removeAt(index);

    }catch(e){

    }


    // globalController.resetGemstonStylesDropList();
    // globalController.resetgemstonesDropDownMap();
  }

  void fillDiamondColors() {
    // ASCII values of 'D' to 'z'
    for (int i = 'D'.codeUnitAt(0); i <= 'z'.codeUnitAt(0); i++) {
      diamondColors?.add(String.fromCharCode(i));
    }
  }

  Future<void> _changeMainImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        mainImage = pickedFile.path;
      });
    }
  }

  Future<void> _removeMainImage() async {
    setState(() {
      mainImage = null;
    });
  }

  Future<void> _pickMoreImages() async {
    // MediaPicker.pickImagesAndVideos().then((value) {
    //   try {
    //     if (value!.isNotEmpty) {
    //       setState(() {
    //         value.forEach(
    //               (element) {
    //             moreImages.add(element.path ?? "");
    //           },
    //         );
    //       });
    //     }
    //   } catch (e) {
    //     print(e);
    //   }
    // },);
    function.multiImagePicker().then((value) {
      try {
        if (value!.isNotEmpty) {
          setState(() {
            value.forEach(
                  (element) {
                moreImages.add(element.path ?? "");
              },
            );
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> _pickVideos() async {
    MediaPicker.pickVideos().then(
          (value) {
        try {
          if (value != null) {
            setState(() {
              moreVideos.add(value.path ?? "");
            });
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      moreImages.removeAt(index);
    });
  }

  void _removeVideo(int index) {
    setState(() {
      moreVideos.removeAt(index);
    });
  }

  void organizeCategories(dynamic apiResponse) {
    try {
      // Clear old data
      selectedCategoriesList.clear();
      selectedCategoriesMap.clear();
      selectedCatObjectList.clear();
      categoriesDropDown.clear();

      // Ensure API response is valid
      if (apiResponse is! List) {
        throw Exception("API response is not a List");
      }

      // Convert API response into a list of Category objects
      List<Category> categories = apiResponse.map((e) => Category.fromJson(e)).toList();

      // Map categories by parent ID
      Map<int?, List<Category>> categoryMap = {};

      for (var category in categories) {
        categoryMap.putIfAbsent(category.parent, () => []).add(category);
      }

      // Organize categories into two levels
      List<Category> mainCategories = categoryMap[null] ?? []; // Parent categories
      List<Category> subCategories = [];

      for (var mainCategory in mainCategories) {
        if (categoryMap.containsKey(mainCategory.id)) {
          subCategories.addAll(categoryMap[mainCategory.id]!);
        }
      }

      // Add categories to selectedCatObjectList properly
      selectedCatObjectList[0] = mainCategories;
      selectedCatObjectList[1] = subCategories;

      // Add categories to selectedCategoriesMap
      if (mainCategories.isNotEmpty) {
        selectedCategoriesMap[0] = mainCategories;
      }
      if (subCategories.isNotEmpty) {
        selectedCategoriesMap[1] = subCategories;
      }

      // Ensure we have only two dropdowns
      categoriesDropDown.add(categoriesList(context, 0)); // Main categories dropdown
      if (subCategories.isNotEmpty) {
        categoriesDropDown.add(categoriesList(context, 1)); // Subcategories dropdown
      }
    } catch (e) {
      print("Error in organizeCategories: $e");
    }
  }

  void _changeImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        moreImages[index] = pickedFile.path;
      });
    }
  }

  void addStoreCategoriesToSelectedCatObjectList() {
    try {
      selectedCategoriesList.clear();
      selectedCategoriesMap.forEach((key, value) {
        selectedCategoriesList.addAll(value);
      });

      // Ensure only 2 levels exist in categoriesDropDown
      if (categoriesDropDown.length > 2) {
        categoriesDropDown.removeRange(2, categoriesDropDown.length);
      }

      // Reset category selection structure
      selectedCatObjectList.clear();

      // Get all main categories (parent == null) and set them at index 0
      selectedCatObjectList[0] = globalController.homeDataList.value.categories!.where((element) => element.parent == null).toList();

      // Collect all subcategories and set them at index 1
      List<Category> subcategories = [];
      for (var category in selectedCategoriesList) {
        subcategories.addAll(globalController.homeDataList.value.categories!.where((element) => element.parent == category.id));
      }

      // Ensure subcategories are added only once at index 1
      if (subcategories.isNotEmpty) {
        selectedCatObjectList[1] = subcategories.toSet().toList(); // Remove duplicates
      }
    } catch (e) {
      print("Error updating category selection: $e");
    }
    print("Error updating category selection: ");
  }

  @override
  void initState() {
    fillDiamondColors();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 5000));

    globalController.descriptionController = HtmlEditorController();

    super.initState();

    if (widget.product != null) {
      editItemInitialize();
    } else {
      addItemInitialize();
    }
  }

  @override
  dispose() {
    // resetFields();
    super.dispose();
  }

  editItemInitialize() async {
    // Initialize basic product details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.updateAddItemDropDownLists();
    });
    productTypeName.value = widget.product!.productTypeName ?? '';
    productTypeId.value = widget.product!.productTypeId ?? 0;
    product = widget.product!.obs;
    mainImage = widget.product!.main_image;

    // Process additional images
    widget.product?.more_images?.forEach((element) {
      if (element.file_path != mainImage.toString()) {
        moreImages.add(element.file_path!);
      }
    });

    // Initialize input fields with product values
    productNameController.text = widget.product!.product_name ?? '';
    productPriceController.text = widget.product!.product_price.toString() ?? '';
    priceAfterDiscountController.text = widget.product!.price_after_discount?.toString() ?? '';
    productCodeController.text = widget.product!.model ?? '';
    // productWeightController.text = widget.product!.product_weight?.toString() ?? '';
    productkeratController.text = widget.product!.product_kerat?.toString() ?? '';
    salesDiscountController.text = widget.product!.sales_discount?.toString() ?? '';
    quantityController.text = widget.product!.product_qty_left.toString() ?? '';

    // Set discount type
    flatDiscount = widget.product!.boolean_percent_discount == 0;

    setState(() {
      try {
        // Fetch related store and product type details
        selectedStoreObject?.value = globalController.stores.firstWhere((element) => element.store_name == widget.product?.store.name);

        selectedTypeObject?.value = globalController.homeDataList.value.productTypes!.firstWhere((element) => element.name == widget.product?.productTypeName);

        // Generate controllers for dynamic text fields
        dynamicTextControllers = List.generate(selectedTypeObject!.value.items!.length, (index) => TextEditingController());
      } catch (e) {
        print("Error in fetching store/type: $e");
      }
    });

    // Fetch product details after initializing
    loadingCategory.value = false;
    GetProductDetails(widget.product?.product_id);
  }

  addItemInitialize() async {
    productTypeId.value = widget.product?.productTypeId ?? 0;
    productTypeName.value = widget.product?.productTypeName ?? '';
    loadingCategory.value = false;
  }

// Function to parse response and populate RxLists
  void populateMetalsAndGemstones(Map<String, dynamic> response) {
    // Extract metals from response
    List<ProductType> extractedMetals = (response["metals"] != null) ? List<ProductType>.from(response["metals"].where((element) => element["type"] == "Metal").map((x) => ProductType.fromJson(x))) : [];

    List<ProductType> extractedGemstones = (response["metals"] != null) ? List<ProductType>.from(response["metals"].where((element) => element["type"] == "Gemstone").map((x) => ProductType.fromJson(x))) : [];

    List<ProductType> extractedGemstonesStyles = [];
    RxList<List<ProductType>> extractedGemstonStylesDropList = <List<ProductType>>[].obs;
    globalController.selectedGemstoneStyle.clear();

    if (response["gemstones_styles"] != null && response["gemstones_styles"]
        .toList()
        .length > 0) {
      List<ProductType> temp = [...globalController.gemstonStylesDropList[0]];

      globalController.gemstonStylesDropList.clear();
      for (int i = 0; i < response["gemstones_styles"]
          .toList()
          .length; i++) {
        var gemstoneStyle = response["gemstones_styles"][i]["style_name"];
        response["gemstones_styles"][i]["data"].forEach((element) {
          if (element["isEdited"] == true) {
            ProductType tempMetal = ProductType.fromJson(element);

            for (int i = 0; i < temp.length; i++) {
              if (temp[i].name == gemstoneStyle) {
                temp.forEach(
                      (element) => element.isEdited = false,
                );
                temp[i].metalName = tempMetal.metalName;
                temp[i].items?.clear();
                temp[i].isEdited = true;
                temp[i].items?.addAll(tempMetal.items!.toList());
                try {
                  gemstoneStylesIds[i] = int.parse(temp[i].id.toString());
                } catch (e) {
                  print(e);
                  gemstoneStylesIds.add(int.parse(temp[i].id.toString()));
                }
              }
            }
          }
        });
        globalController.gemstonStylesDropList.add(temp.map((product) => product.copyWith()).toList());

        globalController.selectedGemstoneStyle.add(gemstoneStyle);
      }

      for (var gemstoneStyle in response["gemstones_styles"]) {
        if (gemstoneStyle["data"] != null) {
          List<ProductType> gemstoneData = List<ProductType>.from(
            gemstoneStyle["data"].map((x) => ProductType.fromJson(x)),
          );
          extractedGemstonesStyles.addAll(gemstoneData);
          extractedGemstonStylesDropList.add(gemstoneData); // Add gemstone styles list
        }
      }
    }

// Assign the extracted list to the global controller

    // ✅ Update the RxLists and RxMap
    setState(() {
      globalController.selectedGemstonStylesDropList.clear(); // Clear before adding new values
      globalController.selectedGemstonStylesDropList.assignAll(extractedGemstonStylesDropList);

      // Clear existing data in gemstonStylesDropList

      // for (int i = 0; i < globalController.selectedGemstonStylesDropList.length; i++) {
      //   List<ProductType> selectedList = globalController.selectedGemstonStylesDropList[i];
      //   List<ProductType> updatedList = []; // Temporary list for modified items
      //
      //   for (int j = 0; j < selectedList.length; j++) {
      //     var selectedElement = selectedList[j];
      //
      //     // Create a copy of selectedElement to prevent modifying the original list
      //     ProductType updatedElement = ProductType(
      //       name: selectedElement.name,
      //       items: selectedElement.items != null ? List.from(selectedElement.items!) : [],
      //       isEdited: selectedElement.isEdited,
      //       type: selectedElement.type,
      //       id: selectedElement.id,
      //       metalName: selectedElement.metalName,
      //       metalId: selectedElement.metalId,
      //       unit: selectedElement.unit,
      //     );
      //
      //     updatedList.add(updatedElement);
      //     globalController.gemstonStylesDropList[i][j].items?.clear();
      //     globalController.gemstonStylesDropList[i][j].items?.addAll(updatedElement.items!.toList());
      //   }
      //
      //   // Update the selectedGemstonStylesDropList at index i
      //   // globalController.selectedGemstonStylesDropList[i] = updatedList;
      // }

// Now, populate gemstonesDropDownMap with gemstonStylesDropList
      globalController.gemstonesDropDownMap.clear(); // Clear the existing map

      for (int i = 0; i < globalController.gemstonStylesDropList.length; i++) {
        globalController.gemstonesDropDownMap[i] = globalController.gemstonStylesDropList[i];
      }

      // **Metals Processing**
      // globalController.selectedMetals.assignAll(extractedMetals);
      globalController.selectedMetals.assignAll(extractedMetals);

      if (globalController.selectedMetals.isNotEmpty) {
        globalController.itemMetal.value = globalController.selectedMetals[0];
      }

      // Sync items list for metals
      globalController.metals.forEach((metalElement) {
        for (var selectedElement in globalController.selectedMetals) {
          if (selectedElement.name == metalElement.name) {
            metalElement.items?.clear();
            metalElement.items?.addAll(selectedElement.items ?? []);
          }
          if (selectedElement.isEdited) {
            metalElement.isEdited = true;

            selectedMetalType = selectedElement.name;
          }
        }
      });

      // **Gemstones Processing**
      globalController.selectedGemstones.assignAll(extractedGemstones);

      // Sync items list for gemstones
      globalController.gemstones.forEach((gemElement) {
        for (var selectedElement in globalController.selectedGemstones) {
          if (selectedElement.name == gemElement.name) {
            gemElement.items?.clear();
            gemElement.items?.addAll(selectedElement.items ?? []);
          }
          if (selectedElement.isEdited) {
            gemElement.isEdited = true;
            selectedGemstoneType = selectedElement.name;
          }
        }
      });

      // ✅ Assign gemstones dropdown list (gemstone styles mapped by ID)
    });
    if (globalController.gemstonesDropDownMap.isEmpty) {
      isStyleEmpty = true;
      globalController.updateEditItemStyleList();
    }

    globalController.update();
    globalController.refresh();
  }

  Future<bool> GetProductDetails(id) async {
    bool success = false;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'productId': id,
    }, "products/get-product-by-id");
    if (response.isNotEmpty) {
      try {
        print(response["product_categories"]);
        if (success = response["succeeded"]) {
          product?.value = Product.fromJson(response["product"]);
          globalController.description.value = product!.value.description ?? '';
          populateMetalsAndGemstones(response);

          organizeCategories(response["product_categories"]);
          if (widget.product != null) {
            addStoreCategoriesToSelectedCatObjectList();
          }
        }
      } catch (e) {
        print(e);
      }
    }
    if (success) {} else {
      loadingProduct.value = false;
    }
    mainImage = product!.value.main_image;
    moreImages.clear();
    moreVideos.clear();
    product!.value.more_images?.forEach((element) {
      if (element.file_path != mainImage.toString()) {
        if (element.file_path!.toString().isImageFileName) {
          moreImages.add(element.file_path.toString());
        } else {
          moreVideos.add(element.file_path.toString());
        }
      }
    });
    if (mounted) {
      setState(() {
        productNameController.text = product!.value.product_name ?? '';
        productPriceController.text = product!.value.product_price.toString() ?? '';
        priceAfterDiscountController.text = product!.value.price_after_discount?.toString() ?? '';
        productCodeController.text = product!.value.model ?? '';
        // productWeightController.text = product!.value.product_weight?.toString() ?? '';
        productkeratController.text = product!.value.product_kerat?.toString() ?? '';
        salesDiscountController.text = product!.value.sales_discount?.toString() ?? '';
        quantityController.text = product!.value.product_qty_left.toString() ?? '';
      });
    }
    print(product);
    return success;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      // drawer: MainDrawer(),
      appBar: widget.product != null
          ? AppBar(
        toolbarHeight: getSize(50),
        title:  Text('Edit Item'.tr),
        elevation: 1,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      )
          : null,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView(
                  key: PageStorageKey('addProductScroll'),
                  controller: scrollController,
                  padding: getPadding(
                    top: getTopPadding() + (widget.product == null ? getSize(55) : 0),
                    bottom: (widget.product == null ? getSize(55) : 0) + getBottomPadding(),
                  ),
                  children: [
                    _buildMainImageSection(),
                    SizedBox(height: 20),
                    Container(
                      height: getSize(50),
                      child: Obx(() {
                        return Container(
                          width: Get.width,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: policyAlert.value ? Colors.red : ColorConstant.logoFirstColor.withOpacity(0.5), // Matching border style
                              width: 0.5,
                            ),
                            color: Colors.white, // Background color to match the first dropdown
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          // Adjust padding
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Store'.tr,
                                style: TextStyle(fontSize: getFontSize(14), color: Theme
                                    .of(context)
                                    .hintColor),
                              ),
                              items: globalController.stores.map((store) {
                                return DropdownMenuItem<String>(
                                  value: store.store_name,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0), // Consistent padding
                                    child: Text(
                                      store.store_name ?? '',
                                      style: TextStyle(fontSize: getFontSize(14), color: Colors.black), // Match text style
                                    ),
                                  ),
                                );
                              }).toList(),
                              value: selectedStoreObject?.value?.store_name,
                              onChanged: (newValue) {
                                setState(() {
                                  loadingCategory.value = true;
                                  categoriesDropDown.clear();
                                  selectedCatObjectList.clear();

                                  selectedStoreObject?.value = globalController.stores.firstWhere(
                                        (element) => element.store_name == newValue.toString(),
                                  );

                                  selectedCatObject?.value = selectedStoreObject?.value?.categories?.first;
                                  selectedCatObjectList.addAll({
                                    selectedCatObjectList.length: [selectedCatObject!.value!]
                                  });

                                  for (int i = 0; i < selectedStoreObject!.value!.categories!.length; i++) {
                                    if (selectedCatObjectList.isEmpty) {
                                      selectedCatObjectList.value = {
                                        0: [selectedStoreObject!.value!.categories![i]]
                                      };
                                    } else {
                                      selectedCatObjectList[i]?.add(selectedStoreObject!.value!.categories![i]);
                                    }
                                  }
                                });

                                categoriesDropDown.add(categoriesList(context, 0));
                                loadingCategory.value = false;
                              },
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: Colors.white, // Background color
                                  borderRadius: BorderRadius.circular(15), // Rounded border
                                  border: Border.all(
                                    color: ColorConstant.logoFirstColor.withOpacity(0.5),
                                    width: 0.5,
                                  ),
                                ),
                                offset: Offset(0, 10), // Adds 10px top padding when opened
                              ),
                              buttonStyleData: const ButtonStyleData(
                                height: 50,
                                width: double.infinity, // Match width to parent container
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: 40,
                              ),
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                  size: getSize(20),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    typeDropDown(context, "Metal", globalController.metals),
                    SizedBox(height: 20),
                    // typeDropDown(context, "Gemstone", globalController.gemstones),

                    // SizedBox(height: 20),
                    // typeDropDown(context, "Gemstone Style".tr, globalController.gemstonStylesDropList[0], index: 1000),
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: getPadding(all: 0),
                        itemCount: globalController.gemstonStylesDropList.length,
                        itemBuilder: (context, index) {
                          final model = globalController.gemstonStylesDropList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: typeDropDown(context, "Gemstone Style".tr, model, index: index),
                          );
                        },
                      );
                    }),

                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: getPadding(all: 0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoriesDropDown.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: getPadding(bottom: 20.0),
                            child: categoriesList(context, index),
                          );
                        },
                      );
                    }),
                    // Obx(() {
                    //   return selectedTypeObject?.value.name == "Diamond"
                    //       ? Column(
                    //           children: [
                    //             SizedBox(height: 20),
                    //             colorDropDown(context),
                    //           ],
                    //         )
                    //       : SizedBox();
                    // }),
                    // Obx(() {
                    //   return selectedTypeObject?.value.name == "Diamond"
                    //       ? Column(
                    //           children: [
                    //             SizedBox(height: 20),
                    //             cutDropDown(context),
                    //           ],
                    //         )
                    //       : SizedBox();
                    // }),
                    // Obx(() {
                    //   return selectedTypeObject?.value.name == "Diamond"
                    //       ? Column(
                    //           children: [
                    //             SizedBox(height: 20),
                    //             clarityDropDown(context),
                    //             SizedBox(height: 20),
                    //           ],
                    //         )
                    //       : SizedBox();
                    // }),

                    _buildTextField(
                      productNameController,
                      'Product Name'.tr,
                      'Enter product name'.tr,
                      required: true,
                    ),

                    // SizedBox(height: 20),
                    _buildTextField(
                      productPriceController,
                      'Product Price'.tr,
                      'Enter product price'.tr,
                      inputType: TextInputType.number,
                      required: true,
                    ),
                    // Obx(() {
                    //   return selectedTypeObject!.value.items.isNotEmpty
                    //       ? ListView.builder(
                    //           shrinkWrap: true,
                    //           padding: EdgeInsets.zero,
                    //           physics: const NeverScrollableScrollPhysics(),
                    //           itemCount: selectedTypeObject!.value.items.length,
                    //           itemBuilder: (context, index) {
                    //             ItemFormField item = selectedTypeObject!.value.items[index];
                    //             return
                    //               _buildTextField(
                    //               dynamicTextControllers[index],
                    //               selectedTypeObject!.value.items[index].field ?? '',
                    //               'Enter ${selectedTypeObject!.value.items[index].field}',
                    //               inputType: TextInputType.name,
                    //               required: selectedTypeObject!.value.items[index].isRequired ?? false,
                    //               isDynamicField: true,
                    //               item: selectedTypeObject!.value.items[index],
                    //             );
                    //           })
                    //       : SizedBox();
                    // }),
                    _buildTextField(
                      productCodeController,
                      'Product Model'.tr,
                      'Enter product model'.tr,
                      required: false,
                    ),
                    // _buildTextField(
                    //   productWeightController,
                    //   'Product Weight',
                    //   'Enter product weight',
                    //   inputType: TextInputType.number,
                    //   required: false,
                    // ),
                    // _buildTextField(
                    //   productkeratController,
                    //   'cerat',
                    //   'Enter product kerat',
                    //   inputType: TextInputType.number,
                    //   required: false,
                    // ),
                    _buildTextField(
                      salesDiscountController,
                      'Sales Discount'.tr,
                      'Enter sales discount'.tr,
                      inputType: TextInputType.number,
                      required: false,
                      isSwitch: true,
                    ),
                    _buildTextField(priceAfterDiscountController, 'Price After Discount', 'Enter price after discount', inputType: TextInputType.number, required: false, readOnly: true),

                    _buildTextField(
                      quantityController,
                      'Quantity'.tr,
                      'Enter quantity'.tr,
                      inputType: TextInputType.number,
                      required: false,
                    ),
                    SizedBox(height: 20),

                    SizedBox(height: 20),
                    MyCustomButton(
                        height: getVerticalSize(50),
                        text: "Add description".tr,
                        fontSize: 20,
                        borderRadius: 15,
                        width: 200,
                        buttonColor: ColorConstant.logoSecondColor,
                        borderColor: Colors.transparent,
                        isExpanded: false,
                        onTap: () async {
                          descriptionBottomSheet();
                        }),

                    widget.product == null
                        ? Obx(() {
                      return MyCustomButton(
                        height: getVerticalSize(50),
                        text: "Submit".tr,
                        fontSize: 20,
                        borderRadius: 15,
                        width: widget.product != null ? 150 : 320,
                        buttonColor: ColorConstant.logoSecondColor,
                        borderColor: Colors.transparent,
                        isExpanded: addingItem.value,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (selectedStoreObject?.value?.id == null) {
                              scrollController.animateTo(
                                scrollController.position.minScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );

                              if (!Get.isSnackbarOpen) {
                                Get.snackbar("Alert".tr, 'Please select a store first'.tr, snackPosition: SnackPosition.TOP, colorText: ColorConstant.white, backgroundColor: ColorConstant.logoSecondColor);
                                policyAlert.value = true;
                                policyAlertText.value = true;
                                Future.delayed(Duration(seconds: 1)).then((value) {
                                  policyAlert.value = false;
                                });
                                Future.delayed(Duration(milliseconds: 1400)).then((value) {
                                  policyAlertText.value = false;
                                });
                              }
                            } else {
                              String dynamicFieldsCustomFormat(Map<String, String> map) {
                                return map.entries.map((entry) => '${entry.key}:${entry.value}').join(',');
                              }

                              // Get the output in the desired format
                              dynamicFieldsJson = '{${dynamicFieldsCustomFormat(dynamicFields)}}';

                              if (widget.fromKey == "edit") {
                                editItem(context);
                              } else {
                                if (selectedCatObject?.value?.id != null) {
                                  addNewItem(context);
                                } else {
                                  if (!Get.isSnackbarOpen) {
                                    scrollController.animateTo(
                                      scrollController.position.minScrollExtent,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    Get.snackbar("Alert".tr, 'Please select a category first'.tr, snackPosition: SnackPosition.BOTTOM, colorText: ColorConstant.white, backgroundColor: ColorConstant.logoSecondColor);
                                    categoryAlert.value = true;
                                    categoryAlertText.value = true;
                                    Future.delayed(Duration(seconds: 1)).then((value) {
                                      categoryAlert.value = false;
                                    });
                                    Future.delayed(Duration(milliseconds: 1400)).then((value) {
                                      categoryAlertText.value = false;
                                    });
                                  }
                                }
                              }
                            }
                          }
                        },
                      );
                    })
                        : Row(
                      mainAxisAlignment: widget.product == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return MyCustomButton(
                            height: getVerticalSize(50),
                            text: "Submit".tr,
                            fontSize: 20,
                            borderRadius: 15,
                            width: widget.product != null ? 150 : 320,
                            buttonColor: ColorConstant.logoSecondColor,
                            borderColor: Colors.transparent,
                            isExpanded: addingItem.value,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (selectedStoreObject?.value?.id == null) {
                                  scrollController.animateTo(
                                    scrollController.position.minScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );

                                  if (!Get.isSnackbarOpen) {
                                    Get.snackbar("Alert".tr, 'Please select a store first'.tr, snackPosition: SnackPosition.TOP, colorText: ColorConstant.white, backgroundColor: ColorConstant.logoSecondColor);
                                    policyAlert.value = true;
                                    policyAlertText.value = true;
                                    Future.delayed(Duration(seconds: 1)).then((value) {
                                      policyAlert.value = false;
                                    });
                                    Future.delayed(Duration(milliseconds: 1400)).then((value) {
                                      policyAlertText.value = false;
                                    });
                                  }
                                } else {
                                  String dynamicFieldsCustomFormat(Map<String, String> map) {
                                    return map.entries.map((entry) => '${entry.key}:${entry.value}').join(',');
                                  }

                                  // Get the output in the desired format
                                  dynamicFieldsJson = '{${dynamicFieldsCustomFormat(dynamicFields)}}';

                                  if (widget.fromKey == "edit") {
                                    editItem(context);
                                  } else {
                                    if (selectedCatObject?.value?.id != null) {
                                      addNewItem(context);
                                    } else {
                                      if (!Get.isSnackbarOpen) {
                                        scrollController.animateTo(
                                          scrollController.position.minScrollExtent,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                        Get.snackbar("Alert".tr, 'Please select a category first'.tr, snackPosition: SnackPosition.TOP, colorText: ColorConstant.white, backgroundColor: ColorConstant.logoSecondColor);
                                        categoryAlert.value = true;
                                        categoryAlertText.value = true;
                                        Future.delayed(Duration(seconds: 1)).then((value) {
                                          categoryAlert.value = false;
                                        });
                                        Future.delayed(Duration(milliseconds: 1400)).then((value) {
                                          categoryAlertText.value = false;
                                        });
                                      }
                                    }
                                  }
                                }
                              }
                            },
                          );
                        }),
                        Expanded(
                          child: widget.product == null
                              ? SizedBox()
                              : MyCustomButton(
                            height: getVerticalSize(50),
                            text: "Delete".tr,
                            fontSize: 20,
                            borderRadius: 15,
                            width: 150,
                            buttonColor: ColorConstant.logoFirstColor,
                            borderColor: Colors.transparent,
                            isExpanded: deletingItem.value,
                            onTap: () {
                              AwesomeDialog(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width < 1000 ? 350 : 600,
                                  context: context,
                                  dialogType: DialogType.question,
                                  body: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Container(
                                        height: getSize(170),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Warning'.tr,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${'Are you sure you want to delete '.tr}${product?.value.product_name}?",
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(''),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: MainColor,
                                                        textStyle: const TextStyle(fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        deleteItem(context).then(
                                                              (value) => Get.back(),
                                                        );
                                                      },
                                                      child: Text('Yes'.tr, style: const TextStyle(color: Colors.white)),
                                                    ),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: MainColor,
                                                        textStyle: const TextStyle(fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child:  Text(
                                                        'No'.tr,
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    Text(''),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )).show();
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Obx(() {
                  return addingItem.value
                      ? Align(
                    alignment: Alignment.center,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Required for BackdropFilter to respect the borderRadius
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: getHorizontalSize(150),
                                child: Lottie.asset(
                                  AssetPaths.addingItemLoader,
                                  repeat: true,
                                  animate: true,
                                ),
                              ),
                              Text(
                                'Please wait while adding product...'.tr,
                                style: TextStyle(
                                  color: ColorConstant.logoFirstColor,
                                  fontSize: getFontSize(15),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Obx(() {
                                return Padding(
                                  padding: getPadding(top: 8.0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: remainingFiles.value.toString(),
                                          style: TextStyle(
                                            color: Colors.red, // Choose your desired color
                                            fontSize: getFontSize(15),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' files remaining...'.tr,
                                          style: TextStyle(
                                            color: ColorConstant.logoFirstColor, // Keep your theme color
                                            fontSize: getFontSize(15),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      : SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateAllGemstonesDropDownMap() {
    // Loop through all indexes in gemstonStylesDropList
    for (int index = 0; index < globalController.gemstonStylesDropList.length; index++) {
      if (globalController.gemstonStylesDropList[index].isNotEmpty) {
        var deepCopiedList = globalController.gemstonStylesDropList[index]
            .map((productType) =>
            productType.copyWith(
              items: productType.items?.map((item) {
                return item.copyWith(
                  options: item.options?.map((option) => option.copyWith()).toList(),
                );
              }).toList(),
            ))
            .toList();

        // Update gemstonesDropDownMap at the current index
        globalController.gemstonesDropDownMap[index] = deepCopiedList;
      }
    }
  }



  Future<bool?> addNewItem(BuildContext context) async {
    if(globalController.itemMetal.value.id==null){
      Get.snackbar("Alert".tr, 'Please select a metal first'.tr, snackPosition: SnackPosition.BOTTOM, colorText: ColorConstant.white, backgroundColor: ColorConstant.logoSecondColor);

      return null;
    }
    bool success = false;
    addingItem.value = true;
    remainingFiles.value = moreImages.length + moreVideos.length;
    List<int> tempIds = selectedCategoriesList.map((e) => e.id).toList();

    selectedCatId.value = jsonEncode(tempIds);
    String itemMetalString = jsonEncode(globalController.itemMetal.value);
    updateAllGemstonesDropDownMap();
    String itemGemstoneStyleString = '';

    if (gemstoneStylesIds.isNotEmpty) {
      itemGemstoneStyleString = jsonEncode(
        globalController.gemstonesDropDownMap.map(
              (key, value) => MapEntry(
            key.toString(),
            {
              "id": gemstoneStylesIds[key],
              "data": value.map((product) => product.toJson()).toList(),
            },
          ),
        ),
      );
    }

    Map<String, dynamic> parameters = {
      'token': prefs!.getString("token") ?? "",
      'storeId': selectedStoreObject?.value!.id.toString(),
      'product_name': productNameController.text.toString(),
      'product_code': productCodeController.text.toString(),
      'description': globalController.description.value,
      'product_price': productPriceController.text.toString(),
      'product_metal': itemMetalString.toString(),
      'style': itemGemstoneStyleString.toString(),
      'quantity': quantityController.text.toString(),
      'fields': dynamicFieldsJson,
      'category': selectedCatId.value,
      'boolean_percent_discount': flatDiscount ? 0 : 1,
      'discount': salesDiscountController.text,
    };

    try {
      Map<String, dynamic> response = await api.getData(parameters, "products/add-provider-product");

      if (response.isNotEmpty) {
        success = response["succeeded"];
        if (success) {
          if (mainImage != null) {
            await uploadImageInBackground({
              "table_name": response["table_name"],
              "product_id": response["product_id"],
              "file_path": mainImage!,
              "file_name": mainImage!.split("/").last,
              "size": 1000,
              "type": 1,
              "token": prefs!.getString("token"),
            });
          }

          for (int i = 0; i < moreImages.length; i++) {
            imageUploadPercent.add(0.0.obs);
            if (!moreImages[i].startsWith("http")) {
              await uploadImageInBackground({
                "table_name": response["table_name"],
                "product_id": response["product_id"],
                "file_path": moreImages[i],
                "file_name": moreImages[i].split("/").last,
                "size": i,
                "type": 2,
                "token": prefs!.getString("token"),
              });
            }
            remainingFiles -= 1;
          }

          for (int i = 0; i < moreVideos.length; i++) {
            imageUploadPercent.add(0.0.obs);
            if (!moreVideos[i].toString().startsWith("http")) {
              await uploadImageInBackground({
                "table_name": response["table_name"],
                "product_id": response["product_id"],
                "file_path": moreVideos[i],
                "file_name": moreVideos[i].split("/").last,
                "size": i,
                "type": 4,
                "token": prefs!.getString("token"),
              });
            }
            remainingFiles -= 1;
          }
        }

        if (success) {

          setState(() {
            mainImage = null;
            globalController.description.value = "";
            imageUploadPercent.clear();
            moreImages.clear();
            moreVideos.clear();
            resetFields();

          });
        }

        Ui.flutterToast(
          response["message"].toString().tr,
          Toast.LENGTH_LONG,
          ColorConstant.logoFirstColor,
          whiteA700,
        );
        toggleAddingItem(false);
        return success;
      } else {
        toggleAddingItem(false);
      }
    } catch (e) {
      toggleAddingItem(false);
    }
    return null;
  }




  Future<void> uploadImageInBackground(Map<String, dynamic> args) async {
    String filePath = args["file_path"];
    if (filePath.isNotEmpty) {
      File file = File(filePath);
      if (!await file.exists()) {
        print("❌ File does not exist: $filePath");
        return;
      }

      try {
        fn.Uint8List fileBytes = await file.readAsBytes();

        dio. FormData data = dio.FormData.fromMap({
          "file": dio.MultipartFile.fromBytes(
            fileBytes,
            filename: args["file_name"],
          ),
          "file_name": args["file_name"],
          "token": args["token"],
          "table_name": args["table_name"].toString(),
          "row_id": args["product_id"].toString(),
          "type": args["type"].toString(),
        });

        dio.Dio dio2 = dio.Dio();

        var response = await dio2.post(
          "${con!}side/upload-images",
          data: data,
          options: dio.Options(
            headers: {
              'Accept': "application/json",
              'Authorization': 'Bearer ${args["token"]}',
            },
          ),
        );

        if (response.statusCode == 200) {
          var responseData = response.data;
          if (responseData['succeeded'] == true) {
            print("✅ Image uploaded successfully: ${args["file_name"]}");
          } else {
            print('❌ Error: ${responseData["message"]}');
          }
        } else {
          print('❌ Failed with status code: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ Error while uploading: $e');
      }
    }
  }



  toggleAddingItem(bool value) {
    Future.delayed(Duration(milliseconds: 1500), () {
      addingItem.value = value;
    });
  }

  Future<bool?> deleteItem(context) async {
    bool success = false;

    setState(() {
      deletingItem.value = false;
    });

    Map<String, dynamic> parameters = {
      'token': prefs!.getString("token") ?? "",
      'id': product?.value.product_id,
    };
    print(parameters);

    try {
      Map<String, dynamic> response = await api.getData(parameters, "products/delete-product");

      if (response.isNotEmpty) {
        success = response["succeeded"];

        if (success) {
          resetFields();
        }
        if (success) {
          Get.back();
        }
        Ui.flutterToast(response["message"]
            .toString()
            .tr, Toast.LENGTH_LONG, ColorConstant.logoFirstColor, whiteA700);

        setState(() {
          deletingItem.value = false;
        });
        return success;
      } else {
        setState(() {
          deletingItem.value = false;
        });
      }
      setState(() {
        deletingItem.value = false;
      });
    } catch (e) {
      setState(() {
        deletingItem.value = false;
      });
    }
    return null;
  }


  Future<bool?> editItem(BuildContext context) async {
    bool success = false;
    addingItem.value = true;
    remainingFiles.value = moreImages.length + moreVideos.length;

    List tempIds = [];
    for (int i = 0; i < selectedCategoriesList.length; i++) {
      tempIds.add(selectedCategoriesList[i].id);
    }

    selectedCatId.value = jsonEncode(tempIds);
    String itemMetalString = jsonEncode(globalController.itemMetal.value);
    updateAllGemstonesDropDownMap();
    String itemGemstoneStyleString = '';

    if (gemstoneStylesIds.isNotEmpty) {
      itemGemstoneStyleString = jsonEncode(
        globalController.gemstonesDropDownMap.map(
              (key, value) => MapEntry(
            key.toString(),
            {
              "id": gemstoneStylesIds[key],
              "data": value.map((product) => product.toJson()).toList(),
            },
          ),
        ),
      );
    }

    moreImages.forEach((element) {
      images.add(element.split("/").last);
    });
    moreVideos.forEach((element) {
      images.add(element.split("/").last);
    });

    String imageString = jsonEncode(images);

    Map<String, dynamic> parameters = {
      'token': prefs!.getString("token") ?? "",
      'id': product?.value.product_id,
      'storeId': selectedStoreObject?.value!.id.toString(),
      'product_name': productNameController.text.toString(),
      'product_code': productCodeController.text.toString(),
      'description': globalController.description.value,
      'product_price': productPriceController.text.toString(),
      'product_metal': itemMetalString.toString(),
      'style': itemGemstoneStyleString.toString(),
      'quantity': quantityController.text.toString(),
      'fields': dynamicFieldsJson,
      'files_names': imageString,
      'category': selectedCatId.value,
      'boolean_percent_discount': flatDiscount ? 0 : 1,
      'discount': salesDiscountController.text,
    };

    try {
      Map<String, dynamic> response =
      await api.getData(parameters, "products/edit-provider-product");

      if (response.isNotEmpty) {
        success = response["succeeded"];

        if (success) {
          if (mainImage != null && !mainImage!.startsWith("http")) {
            await uploadImageInBackground({
              "table_name": response["table_name"],
              "product_id": product?.value.product_id,
              "file_path": mainImage!,
              "file_name": mainImage!.split("/").last,
              "size": 1000,
              "type": 1,
              "token": prefs!.getString("token"),
            });
          }

          for (int i = 0; i < moreImages.length; i++) {
            imageUploadPercent.add(0.0.obs);
            if (!moreImages[i].startsWith("http")) {
              await uploadImageInBackground({
                "table_name": response["table_name"],
                "product_id": product?.value.product_id,
                "file_path": moreImages[i],
                "file_name": moreImages[i].split("/").last,
                "size": i,
                "type": 2,
                "token": prefs!.getString("token"),
              });
            }

            remainingFiles -= 1;
          }
          for (int i = 0; i < moreVideos.length; i++) {
            imageUploadPercent.add(0.0.obs);
            if (!moreVideos[i].toString().startsWith("http")) {
              await uploadImageInBackground({
                "table_name": response["table_name"],
                "product_id": product?.value.product_id,
                "file_path": moreVideos[i],
                "file_name": moreVideos[i].split("/").last,
                "size": i,
                "type": 4,
                "token": prefs!.getString("token"),
              });
            }
            remainingFiles -= 1;
          }


        }

        toggleAddingItem(false);
        Ui.flutterToast(
          response["message"].toString().tr,
          Toast.LENGTH_LONG,
          ColorConstant.logoFirstColor,
          whiteA700,
        );
        return success;
      } else {
        toggleAddingItem(false);
      }
    } catch (e) {
      print(e);
      toggleAddingItem(false);
    }
    return null;
  }



  // Future<void> uploadImageInBackground(Map<String, dynamic> args) async {
  //   String? image = args["image"];
  //   if (image != null) {
  //     dio.FormData data = dio.FormData.fromMap({
  //       "file": await dio.MultipartFile.fromFile(
  //         image,
  //         filename: args["file_name"].toString(),
  //       ).catchError((e) {}),
  //       "file_name": args["file_name"],
  //       "token": args["token"],
  //       "table_name": args["table_name"].toString(),
  //       "row_id": args["row_id"].toString(),
  //       "type": args["type"].toString(),
  //     });
  //
  //     dio.Dio dio2 = dio.Dio();
  //
  //     try {
  //       var response = await dio2.post(
  //         "${args["con"]}side/upload-images",
  //         data: data,
  //         options: dio.Options(
  //           headers: {
  //             'Accept': "application/json",
  //             'Authorization': 'Bearer ${args["token"]}',
  //           },
  //         ),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         var responseData = response.data;
  //         if (responseData['succeeded'] == true) {
  //           print("✅ Image uploaded successfully: ${args["file_name"]}");
  //         } else {
  //           print('❌ Error: ${responseData["message"]}');
  //         }
  //       } else {
  //         print('❌ Failed with status code: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       print('❌ Error while uploading: $e');
  //     }
  //   }
  // }

  clearForm() {
    productNameController.clear();
    productPriceController.clear();
    priceAfterDiscountController.clear();
    productCodeController.clear();
    // productWeightController.clear();
    productkeratController.clear();
    salesDiscountController.clear();
    quantityController.clear();
    optionsController.clear();
    variationFoundController.clear();
    variantIdController.clear();
    globalController.descriptionController.clear();
    setState(() {
      moreImages.clear();
      moreVideos.clear();
      imageUploadPercent.clear();
      mainImage = null;
    });
  }

  Widget _buildTextField(TextEditingController controller,
      String label,
      String hint, {
        TextInputType inputType = TextInputType.text,
        bool required = true,
        bool isSwitch = false,
        bool readOnly = false,
        bool isDynamicField = false,
        ItemFormField? item,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          SizedBox(
            height: getSize(50),
            child: TextFormField(
              controller: controller,
              readOnly: readOnly,
              onChanged: isSwitch
                  ? (value) {
                if (flatDiscount) {
                  setState(() {
                    try {
                      double discountedPrice = double.parse(productPriceController.text) - double.parse(salesDiscountController.text.isNotEmpty ? salesDiscountController.text : "0");
                      priceAfterDiscountController.text = discountedPrice < 0 ? "0" : discountedPrice.toString();
                    } catch (e) {
                      print(e);
                    }
                  });
                } else {
                  setState(() {
                    try {
                      double productPrice = double.parse(productPriceController.text.isNotEmpty ? productPriceController.text : "0");
                      double discount = double.parse(salesDiscountController.text.isNotEmpty ? salesDiscountController.text : "0");
                      double discountedPrice = productPrice - (productPrice * discount / 100);
                      priceAfterDiscountController.text = discountedPrice < 0 ? "0" : discountedPrice.toString();
                    } catch (e) {
                      print(e);
                    }
                  });
                }
              }
                  : isDynamicField
                  ? (value) {
                if (dynamicFields.containsKey(item?.id.toString())) {
                  dynamicFields[item!.id!.toString()] = value;
                } else {
                  dynamicFields.addAll({item!.id!.toString(): value});
                }
              }
                  : label == "Product Price".tr
                  ? (value) {
                if (flatDiscount) {
                  setState(() {
                    try {
                      priceAfterDiscountController.text = (double.parse(productPriceController.text) - double.parse(salesDiscountController.text != "" ? salesDiscountController.text : "0")).toString();
                    } catch (e) {
                      print(e);
                    }
                  });
                } else {
                  setState(() {
                    try {
                      priceAfterDiscountController.text =
                          (double.parse(productPriceController.text) - (double.parse(productPriceController.text != "" ? productPriceController.text : "0") * double.parse(salesDiscountController.text != "" ? salesDiscountController.text : "0") / 100)).toString();
                    } catch (e) {
                      print(e);
                    }
                  });
                }
                if (double.parse(priceAfterDiscountController.text) < 0) {
                  priceAfterDiscountController.text = "0";
                }
              }
                  : null,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                labelStyle: TextStyle(
                  color: ColorConstant.gray500,
                ),
                hintStyle: TextStyle(
                  color: ColorConstant.gray500,
                ),
                focusColor: ColorConstant.logoFirstColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                fillColor: ColorConstant.whiteA700,
              ),
              keyboardType: inputType,
              validator: required
                  ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              }
                  : null,
            ),
          ),
          if (isSwitch)
            SizedBox(
              width: getSize(120),
              height: 30,
              child: Padding(
                padding: getPadding(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      FontAwesomeIcons.percent,
                      size: getSize(13),
                    ),
                    Switch(
                        value: flatDiscount,
                        inactiveTrackColor: ColorConstant.gray300,
                        activeTrackColor: ColorConstant.gray300,
                        activeColor: ColorConstant.logoFirstColor,
                        inactiveThumbColor: ColorConstant.logoFirstColor,
                        onChanged: (value) {
                          try {
                            setState(() {
                              flatDiscount = value;
                              double productPrice = double.tryParse(productPriceController.text) ?? 0;
                              double discount = double.tryParse(salesDiscountController.text) ?? 0;
                              double discountedPrice;

                              if (flatDiscount) {
                                discountedPrice = productPrice - discount;
                                Ui.flutterToast("flat discount".tr, Toast.LENGTH_LONG, ColorConstant.logoFirstColor, whiteA700);
                              } else {
                                discountedPrice = productPrice - (productPrice * discount / 100);
                                Ui.flutterToast("percent discount".tr, Toast.LENGTH_LONG, ColorConstant.logoFirstColor, whiteA700);
                              }

                              // Ensure price is not negative
                              priceAfterDiscountController.text = discountedPrice < 0 ? "0" : discountedPrice.toString();
                            });
                          } catch (e) {
                            Ui.flutterToast("please fill the price first".tr, Toast.LENGTH_LONG, ColorConstant.logoFirstColor, whiteA700);
                          }
                        }

                    ),
                    Icon(
                      FontAwesomeIcons.listNumeric,
                      size: getSize(13),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Main Image'.tr,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MainColor),
        ),
        SizedBox(height: 10),
        mainImage == null
            ? GestureDetector(
          onTap: _pickMainImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey[200],
            ),
            child: Center(
              child: Icon(
                Icons.add_a_photo,
                color: Colors.grey,
                size: 50,
              ),
            ),
          ),
        )
            : Column(
          children: [
            CustomImageView(
              image: mainImage,
              height: 200,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _changeMainImage,
                  style: ElevatedButton.styleFrom(backgroundColor: ColorConstant.logoSecondColor),
                  child: Text('Change'.tr, style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _removeMainImage,
                  style: ElevatedButton.styleFrom(backgroundColor: ColorConstant.logoFirstColor),
                  child: Text('Remove'.tr, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'More Images'.tr,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MainColor),
        ),
        SizedBox(height: 10),
        Obx(() {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: getPadding(all: 0),
            itemCount: moreImages.length + 1,
            itemBuilder: (context, index) {
              if (index == moreImages.length) {
                return GestureDetector(
                  onTap: _pickMoreImages,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                );
              } else {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      children: [
                        CustomImageView(
                          image: moreImages[index],
                          fit: BoxFit.cover,
                          width: Get.width * 0.2,
                          height: Get.height * 0.1,
                          color: ColorConstant.logoSecondColor,
                        ),
                        Positioned(
                          top: 1,
                          right: -1,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (imageUploadPercent.length > index) {
                        print(imageUploadPercent[index]);
                      }

                      return addingItem.value == true
                          ? imageUploadPercent.length > index
                          ? CircularPercentIndicator(
                        radius: 25.0,
                        lineWidth: 3.0,
                        percent: imageUploadPercent[index].value,
                        center: Container(
                            child: Text(
                              "${imageUploadPercent[index] * 100}%",
                              style: TextStyle(
                                  fontSize: getFontSize(
                                    13,
                                  ),
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            )),
                        progressColor: Colors.grey,
                      )
                          : SizedBox()
                          : SizedBox();
                    })
                  ],
                );
              }
            },
          );
        }),
        SizedBox(height: 20),
        Text(
          'Select Videos'.tr,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MainColor),
        ),
        SizedBox(height: 10),
        Obx(() {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1, // Ensure uniform height and width
            ),
            padding: getPadding(all: 0),
            itemCount: moreVideos.length + 1,
            itemBuilder: (context, index) {
              if (index == moreVideos.length) {
                return GestureDetector(
                  onTap: _pickVideos,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.video_file,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                );
              } else {
                return Obx(() {
                  return VideoGridItem(
                    key: ValueKey(moreVideos[index]),
                    // Helps Flutter understand the uniqueness
                    videoPath: moreVideos[index],
                    isAdding: addingItem.value,
                    uploadProgress: imageUploadPercent.length > index ? imageUploadPercent[index] : null,
                    onDelete: () => _removeVideo(index),
                    onPreview: () => showVideo(context, moreVideos[index]),
                  );
                });
              }
            },
          );
        }),
      ],
    );
  }

  Widget categoriesList(BuildContext context, int index) {
    return Obx(() {
      final isLoading = loadingCategoriesDropDown.value;
      final selectedCategories = selectedCategoriesMap[index] ?? [];
      final availableCategories = (index > 0
          ? selectedCatObjectList[index]
          : selectedStoreObject?.value?.categories
          ?.where((category) => category.parent == null))
          ?.toList() ??
          [];

      String? selectedValue = selectedCategories.isNotEmpty
          ? selectedCategories.last.categoryName
          : null;

      return isLoading
          ? SizedBox(
        height: getSize(50),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: getSize(100),
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: getSize(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: categoryAlert.value
                    ? Colors.red
                    : ColorConstant.logoFirstColor.withOpacity(0.5),
                width: 0.5,
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  index == 0 ? "Select Category".tr : "Select Subcategory".tr,
                  style: TextStyle(
                    fontSize: getFontSize(14),
                    color: Theme.of(context).hintColor,
                  ),
                ),
                value: availableCategories.any((cat) => cat.categoryName == selectedValue)
                    ? selectedValue
                    : null, // Prevents assertion error
                items: availableCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.categoryName,
                    child: Text(category.categoryName ?? ''),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    bool isCategoryAdded = false;

                    // Find the selected category
                    Category tempCategory = globalController
                        .homeDataList.value.categories!
                        .firstWhere((element) =>
                    element.categoryName == newValue.toString());

                    int key = index;

                    selectedCategoriesMap.putIfAbsent(key, () => []);

                    bool contains = selectedCategoriesMap[key]!.any(
                            (element) =>
                        element.categoryName == tempCategory.categoryName);

                    if (!contains) {
                      tempCategory.isSelected = true;
                      selectedCategoriesMap[key]!.add(tempCategory);
                    }

                    if (!selectedCategoriesList
                        .any((cat) => cat.id == tempCategory.id)) {
                      selectedCategoriesList.add(tempCategory);
                      selectedCategoriesList.refresh();
                    }

                    selectedCatObjectList[index] ??= [];
                    for (var element
                    in globalController.homeDataList.value.categories!) {
                      if (element.parent == tempCategory.id) {
                        bool exists = selectedCatObjectList[index]!.any(
                                (existingCategory) =>
                            existingCategory.categoryName ==
                                element.categoryName);

                        if (!exists) {
                          element.isSelected = true;
                          selectedCatObjectList[index]!.add(element);
                        }
                      }
                    }

                    selectedCatObjectList[index + 1] ??= [];
                    for (var element
                    in globalController.homeDataList.value.categories!) {
                      if (element.parent == tempCategory.id) {
                        isCategoryAdded = true;

                        bool exists = selectedCatObjectList[index + 1]!.any(
                                (existingCategory) =>
                            existingCategory.categoryName ==
                                element.categoryName);

                        if (!exists) {
                          element.isSelected = true;
                          selectedCatObjectList[index + 1]!.add(element);
                        }
                      }
                    }

                    if (isCategoryAdded) {
                      if (index + 1 < categoriesDropDown.length) {
                        categoriesDropDown[index + 1] =
                            categoriesList(context, index + 1);
                      } else {
                        categoriesDropDown
                            .add(categoriesList(context, index + 1));
                      }
                    }
                  });

                  setState(() {
                    selectedValue = selectedCatObjectList[index]?.isNotEmpty == true
                        ? selectedCatObjectList[index]?.first.categoryName
                        : null;
                  });
                },
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: selectedCategories.map((category) {
              return Chip(
                label: Text(category.categoryName ?? ''),
                  onDeleted: () {
                    setState(() {
                      // ✅ Remove the category from all relevant lists
                      selectedCategoriesMap[index]?.removeWhere((cat) => cat.id == category.id);
                      selectedCatObjectList[index]?.removeWhere((cat) => cat.id == category.id);
                      category.isSelected = false;

                      // ✅ Remove from selectedCategoriesList
                      selectedCategoriesList.removeWhere((cat) => cat.id == category.id);

                      // ✅ Remove all subcategories of the deleted category at all levels
                      void removeSubcategoriesFromAllIndexes(int parentId) {
                        // 1️⃣ Remove from selectedCategoriesList
                        selectedCategoriesList.removeWhere((cat) => cat.parent == parentId);

                        // 2️⃣ Remove from selectedCategoriesMap
                        selectedCategoriesMap.forEach((key, categoryList) {
                          categoryList.removeWhere((cat) => cat.parent == parentId);
                        });

                        // 3️⃣ Remove from selectedCatObjectList across all indexes
                        for (int i = 0; i < selectedCatObjectList.length; i++) {
                          selectedCatObjectList[i]?.removeWhere((cat) => cat.parent == parentId);
                        }

                        // 4️⃣ Remove dropdowns that reference the deleted subcategories
                        categoriesDropDown.removeWhere((widget) {
                          int widgetIndex = categoriesDropDown.indexOf(widget);
                          if (widgetIndex > index) {
                            List<Category>? subCategories = selectedCatObjectList[widgetIndex];
                            return subCategories != null && subCategories.any((cat) => cat.parent == parentId);
                          }
                          return false;
                        });

                        // 🛑 Recursively remove deeper subcategories
                        final subcategories = selectedCategoriesList.where((cat) => cat.parent == parentId).toList();
                        for (var subCat in subcategories) {
                          removeSubcategoriesFromAllIndexes(subCat.id);
                        }
                      }

                      removeSubcategoriesFromAllIndexes(category.id);

                      // ✅ Ensure UI updates properly
                      selectedCategoriesList.refresh();
                      selectedCategoriesMap.refresh();
                      selectedCatObjectList.refresh();
                      categoriesDropDown.refresh();

                      // ✅ Ensure dropdown value is valid
                      if (selectedValue == category.categoryName) {
                        selectedValue = null;
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final availableCategories = selectedCatObjectList[index] ?? [];
                        if (!availableCategories.any((cat) => cat.categoryName == selectedValue)) {
                          setState(() {
                            selectedValue = null;
                          });
                        }
                      });
                    });
                  },
              );
            }).toList(),
          )
        ],
      );
    });
  }

  Widget typeDropDown(BuildContext context, String type, List<ProductType>? metal, {int? index}) {
    RxBool isEdit = false.obs;
    print(type);
    return Obx(() {
      return refreshDropDown.value
          ? SizedBox(
        height: getSize(50),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: getSize(100),
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      )
          : Container(
        height: getSize(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: ColorConstant.logoFirstColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dropdownMenuTheme: DropdownMenuThemeData(
              textStyle: TextStyle(color: Colors.black, fontSize: getFontSize(14)),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: ColorConstant.logoFirstColor.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color
                borderRadius: BorderRadius.circular(15), // Rounded border
                border: Border.all(
                  color: ColorConstant.logoFirstColor.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12), // Adjust padding
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Select $type',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme
                        .of(context)
                        .hintColor,
                  ),
                ),
                items: metal?.map((element) {
                  List<ItemFormField> metalOptions = element.items ?? [];
                  metalOptions.forEach((mainElement) {
                    mainElement.options?.forEach((value) {
                      if (value.isSelected) {
                        isEdit.value = true;
                      }
                    });
                  });

                  return DropdownMenuItem<String>(
                    value: element.name,
                    child: Text(
                      element.name ?? '',
                      style: TextStyle(fontSize: getFontSize(14), color: Colors.black),
                    ),
                  );
                }).toList(),
                value: type == "Metal"
                    ? selectedMetalType
                    : type == "Gemstone"
                    ? selectedGemstoneType
                    : globalController.selectedGemstoneStyle.isNotEmpty
                    ? globalController.selectedGemstoneStyle[index ?? 0]
                    : null,
                onChanged: (newValue) {
                  refreshDropDown.value = true;
                  setState(() {
                    // metal?.firstWhere((element) => element.name == newValue).metalName = newValue;
                    if (type == "Metal") {
                      selectedMetalType = newValue;
                    } else if (type == "Gemstone") {
                      selectedGemstoneType = newValue;
                    } else {
                      // if (index == 1000) {
                      //   selectedGemstoneStyleFirst = newValue;
                      // } else {
                      try {
                        globalController.selectedGemstoneStyle[index!] = newValue!;
                      } catch (e) {
                        globalController.selectedGemstoneStyle.add(newValue);
                        print(e);
                      }
                      // }
                    }
                    String name = "";

                    // if (index == 1000) {
                    //   name = selectedGemstoneStyleFirst ?? '';
                    // } else
                    if (index == null) {
                      if (type == "Gemstone") {
                        name = selectedGemstoneType ?? '';
                      } else {
                        name = selectedMetalType ?? '';
                      }
                    } else {
                      name = globalController.selectedGemstoneStyle[index] ?? '';
                    }
                    print(name);

                    String? metalName;
                    try {
                      metalName = globalController.gemstonesDropDownMap[index]
                          ?.firstWhere((element) => element.isEdited)
                          .metalName;
                    } catch (e) {
                      print(e);
                      metalName = metal
                          ?.firstWhere((element) => element.name == name)
                          .metalName;
                    }
                    // if (type == "Metal") {
                    //   globalController.itemMetal.value = metal?.firstWhereOrNull((element) => element.name == newValue) ?? ProductType();
                    // } else if (type == "Gemstone") {
                    //   globalController.itemGemstone.value = metal!.firstWhere((element) => element.name == newValue);
                    // } else {
                    //   for (var element in globalController.itemGemstoneStyles) {
                    //     if (element.id != null) {
                    //       globalController.itemGemstoneStyles[index!] = metal!.firstWhere((element) => element.name == newValue);
                    //     } else {
                    //       globalController.itemGemstoneStyles.add(metal!.firstWhere((element) => element.name == newValue));
                    //     }
                    //   }
                    // }

                    if (type == "Gemstone Style") {
                      try {
                        gemstoneStylesIds[index!] = int.parse(metal!.firstWhere((element) => element.name == newValue).id.toString());
                      } catch (e) {
                        print(e);
                        gemstoneStylesIds.add(int.parse(metal!.firstWhere((element) => element.name == newValue).id.toString()));
                      }
                    }

                    showBottomSheet(context, type,
                        properties: metal!.firstWhere((element) => element.name == newValue).items,
                        gemstoneProperties: type == "Gemstone Style" ? metal : null,
                        styleType: type == "Gemstone Style" ? newValue : null,
                        gemstoneStyleName: metalName,
                        selectedName: name,
                        isAdd: (widget.product == null || isStyleEmpty) ? true : false,
                        metal: metal.firstWhere((element) => element.name == newValue),
                        index: index ?? 0)
                        .then((value) {
                      isEdit.value = true;
                      isEdit.refresh();
                      refreshDropDown.refresh();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        isEdit.value = value;
                        refreshDropDown.value = false;
                        isEdit.refresh();
                        refreshDropDown.refresh();
                      });

                      print("e");
                    });
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  height: 40,
                  width: 140,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: Get.height * 0.5, // ✅ Make the dropdown scrollable
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(15), // Rounded border
                    border: Border.all(
                      color: ColorConstant.logoFirstColor.withOpacity(0.5),
                      width: 0.5,
                    ),
                  ),
                  offset: Offset(0, 10), // Adds 10px top padding when opened
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 40,
                ),
                iconStyleData: IconStyleData(
                  icon: Obx(() {
                    RxBool isEdited = false.obs;
                    if (type == "Gemstone Style") {
                      metal!.forEach(
                            (element) {
                          if (element.isEdited) {
                            isEdited.value = true;
                          }
                        },
                      );
                    }

                    print(type);
                    return Row(
                      children: [
                        if (type == "Gemstone Style" && index == 0)

                          Obx(()=>
                          globalController.selectedGemstoneStyle.first!=null?
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    resetStyle(index??0);
                                  },
                                  child: Icon(
                                    Icons.remove_circle_outline, // Use a dropdown arrow icon
                                    color: ColorConstant.logoSecondColor, // Customize color
                                    size: getSize(25), // Customize size
                                  ),
                                ),
                              ):SizedBox(),
                          ),


                        if (type == "Gemstone Style" && index == 0)
                          InkWell(
                            onTap: () {
                              globalController.selectedGemstoneStyle.add(null);

                              globalController.gemstonStylesDropList.add(globalController.homeDataList.value.gemstoneStyles!);
                            },
                            child: Icon(
                              Icons.add_circle_outlined, // Use a dropdown arrow icon
                              color: ColorConstant.logoSecondColor, // Customize color
                              size: getSize(25), // Customize size
                            ),
                          ),

                        if (type == "Gemstone Style" && index != 0)
                          InkWell(
                            onTap: () {
                              globalController.gemstonesDropDownMap.removeWhere(
                                    (key, value) {
                                  key == index;
                                  return true;
                                },
                              );
                              globalController.selectedGemstoneStyle[index!] = null;
                              globalController.gemstonStylesDropList.removeAt(index!);
                            },
                            child: Icon(
                              Icons.remove_circle, // Use a dropdown arrow icon
                              color: ColorConstant.logoSecondColor, // Customize color
                              size: getSize(25), // Customize size
                            ),
                          ),
                        Icon(
                          Icons.keyboard_arrow_down, // Use a dropdown arrow icon
                          color: Colors.black, // Customize color
                          size: getSize(20), // Customize size
                        ),
                        SizedBox(width: getSize(8)),
                        (type == "Metal" && selectedMetalType != null) || (type == "Gemstone" && selectedGemstoneType != null) || (type == "Gemstone Style" && globalController.selectedGemstoneStyle.isNotEmpty && globalController.selectedGemstoneStyle[index!] != null)
                            ? InkWell(
                          onTap: () {
                            String name = "";

                            // if (index == 1000) {
                            //   name = selectedGemstoneStyleFirst ?? '';
                            // } else
                            if (index == null) {
                              if (type == "Gemstone") {
                                name = selectedGemstoneType ?? '';
                              } else {
                                name = selectedMetalType ?? '';
                              }
                            } else {
                              name = globalController.selectedGemstoneStyle[index] ?? '';
                            }
                            print(name);

                            String? metalName;
                            // try {
                            //   metalName = globalController.gemstonStylesDropList[index!].firstWhere((element) => element.isEdited && element.metalName==name).metalName;
                            // } catch (e) {
                            //   print(e);
                            //   metalName = metal?.firstWhere((element) => element.name == name).metalName;
                            // }

                            if (type == "Metal") {
                              globalController.itemMetal.value = metal!.firstWhere((element) => element.name == name);
                              metalName = name;
                            } else if (type == "Gemstone") {
                              globalController.itemGemstone.value = metal!.firstWhere((element) => element.name == name);
                              metalName = name;
                            } else {
                              try {
                                metalName = globalController.gemstonStylesDropList[index!]
                                    .firstWhere((element) => element.isEdited && element.name == name)
                                    .metalName;
                              } catch (e) {
                                print(e);
                                metalName = metal
                                    ?.firstWhere((element) => element.name == name)
                                    .metalName;
                              }
                              for (var gemstoneList in globalController.gemstonStylesDropList) {
                                for (var gemstone in gemstoneList) {
                                  if (gemstone.id != null) {
                                    gemstone = metal!.firstWhere((element) => element.name == name);
                                  } else {
                                    gemstoneList.add(metal!.firstWhere((element) => element.name == name));
                                  }
                                }
                              }
                            }

                            showBottomSheet(context, type,
                                properties: metal!.firstWhere((element) => element.name == name).items,
                                gemstoneProperties: type == "Gemstone Style" ? metal : null,
                                styleType: type == "Gemstone Style" ? globalController.selectedGemstoneStyle[index!] : null,
                                gemstoneStyleName: metalName,
                                selectedName: name,
                                isAdd: false,
                                metal: metal.firstWhere((element) => element.name == name),
                                index: index ?? 0)
                                .then((value) {
                              isEdit.value = true;
                              isEdit.refresh();
                              refreshDropDown.refresh();
                              Future.delayed(const Duration(milliseconds: 500), () {
                                isEdit.value = value;
                                refreshDropDown.value = false;
                                isEdit.refresh();
                                refreshDropDown.refresh();
                              });

                              print("e");
                            });
                          },
                          child: Icon(
                            Icons.edit, // Use a dropdown arrow icon
                            color: ColorConstant.logoSecondColor, // Customize color
                            size: getSize(25), // Customize size
                          ),
                        )
                            : SizedBox(),
                      ],
                    );
                  }),
                  openMenuIcon: Icon(
                    Icons.keyboard_arrow_up, // Change icon when menu opens
                    color: Colors.black,
                    size: getSize(20), // Customize size
                  ),
                  iconSize: getSize(20),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<bool> showBottomSheet(BuildContext context, String type, {List<ItemFormField>? properties, List<ProductType>? gemstoneProperties, String? styleType, bool isAdd = false, String? gemstoneStyleName, int? index, ProductType? metal, String? selectedName}) async {
    RxBool isEdit = false.obs;

    await Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          // Start height (60% of screen)
          minChildSize: 0.4,
          // Minimum height (40% of screen)
          maxChildSize: 0.9,
          // Maximum height (90% of screen)
          expand: false,

          // Prevent forced expansion
          builder: (context, scrollController) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: type != "Gemstone Style"
                      ? BottomSheetContent(
                    fields: properties!,
                    type: type,
                    metalType: selectedName!,
                  )
                      : StyleSheetContent(
                    fields: gemstoneProperties!,
                    type: styleType ?? type,
                    metalName: gemstoneStyleName,
                    index: index ?? 0,
                    isAdd: isAdd,
                    isStyleEmpty: isStyleEmpty,
                  ),
                ),

                Obx(() =>
                    MyCustomButton(
                      height: getVerticalSize(50),
                      text: "Save".tr,
                      fontSize: 20,
                      borderRadius: 15,
                      width: Get.width * 0.3,
                      buttonColor: ColorConstant.logoSecondColor,
                      borderColor: Colors.transparent,
                      isExpanded: false,
                      onTap: () {
                        if (globalController.isRequiredCheck.value) {
                          Ui.flutterToast("Please fill all required fields".tr, Toast.LENGTH_SHORT, ColorConstant.logoSecondColor, whiteA700);
                        } else {
                          if (type != "Gemstone Style") {
                            properties?.forEach((mainElement) {
                              if (mainElement.isEdited) {
                                isEdit.value = true;
                              }
                              mainElement.options?.forEach((value) {
                                if (value.isSelected) {
                                  isEdit.value = true;
                                }
                              });
                            });
                          } else {
                            gemstoneProperties?.forEach((mainElement) {
                              if (mainElement.isEdited) {
                                isEdit.value = true;
                              }
                              for (var element in mainElement.items ?? []) {
                                if (element.isEdited) {
                                  isEdit.value = true;
                                }
                                element.options?.forEach((value) {
                                  if (value.isSelected) {
                                    isEdit.value = true;
                                  }
                                });
                              }
                            });
                          }

                          Get.back(result: true);
                        }
                      },
                    )),

              ],
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: false,
    ).then((value) {
      if (type != "Gemstone Style") {
        properties?.forEach((mainElement) {
          if (mainElement.isEdited) {
            isEdit.value = true;
          }
          mainElement.options?.forEach((value) {
            if (value.isSelected) {
              isEdit.value = true;
            }
          });
        });
      } else {
        gemstoneProperties?.forEach((mainElement) {
          if (mainElement.isEdited) {
            isEdit.value = true;
          }
          for (var element in mainElement.items ?? []) {
            if (element.isEdited) {
              isEdit.value = true;
            }
            element.options?.forEach((value) {
              if (value.isSelected) {
                isEdit.value = true;
              }
            });
          }
        });
      }
    });

    return isEdit.value;
  }

  Widget cutDropDown(BuildContext context,) {
    return Obx(() {
      return Container(
        height: getSize(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonFormField(
          value: selectedCut?.value,
          items: cut.map((cutValue) {
            return DropdownMenuItem<String>(
              value: cutValue,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Add padding here
                child: Text(cutValue ?? ''),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "Cut".tr,
            hintText: "Select cut".tr,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            labelStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            hintStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            focusColor: ColorConstant.logoFirstColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: false,
            fillColor: ColorConstant.whiteA700,
          ),
          onChanged: (newValue) {
            setState(() {
              selectedCut?.value = newValue!;
            });
          },
          hint: Text('Select cut'.tr),
        ),
      );
    });
  }

  Widget clarityDropDown(BuildContext context,) {
    return Obx(() {
      return Container(
        height: getSize(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonFormField(
          value: selectedClarity?.value,
          items: clarity.map((clarityValue) {
            return DropdownMenuItem<String>(
              value: clarityValue,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Add padding here
                child: Text(
                  clarityValue ?? '',
                  style: TextStyle(fontSize: getFontSize(13)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "clarity".tr,
            hintText: "Select clarity".tr,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            labelStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            hintStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            focusColor: ColorConstant.logoFirstColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: false,
            fillColor: ColorConstant.whiteA700,
          ),
          onChanged: (newValue) {
            setState(() {
              selectedClarity?.value = newValue!;
            });
          },
          hint: Text('Select clarity'.tr),
        ),
      );
    });
  }

  Widget colorDropDown(BuildContext context,) {
    return Obx(() {
      return Container(
        height: getSize(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonFormField(
          value: selectedColor?.value,
          items: diamondColors?.map((color) {
            return DropdownMenuItem<String>(
              value: color,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Add padding here
                child: Text(color ?? ''),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "Diamond color".tr,
            hintText: "Select color".tr,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            labelStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            hintStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            focusColor: ColorConstant.logoFirstColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: false,
            fillColor: ColorConstant.whiteA700,
          ),
          onChanged: (newValue) {
            setState(() {
              selectedColor?.value = newValue!;
            });
          },
          hint: Text('Select Color'.tr),
        ),
      );
    });
  }

  showVideo(context, String video) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      content: Container(
        padding: getPadding(all: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
        ),
        child: ChewieVideoPlayer(
          initialQuality: video,
          isMuted: false,
          videoThumb: AssetPaths.placeholder,
          videoQualities: {
            "360": video,
            "720": video,
          },
          isGeneral: true,
          looping: false,
          allowFullScreen: false,
          allowMute: false,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: getPadding(left: 8),
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MainColor,
              ),
              alignment: Alignment.center,
              child: Text(
                "Close".tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  descriptionBottomSheet() {
    Get.bottomSheet(
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: DescriptionEditor(
              args: product?.value.description,
              isLoading: isLoading,
            ),
          ),
          Padding(
            padding: getPadding(bottom: getBottomPadding()+10,right: 10),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.save),
              style: IconButton.styleFrom(
                backgroundColor: ColorConstant.logoSecondColor,
                foregroundColor: Colors.white,
              ),
              color: ColorConstant.logoSecondColor,
              iconSize: getSize(20),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent, // Crucial to avoid the border effect!
      isScrollControlled: true, // Allows it to expand properly if content is large
    );
  }
}
