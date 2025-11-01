import 'dart:convert';
import 'dart:io';

import 'package:deligo_delivery/models/profile_mode.dart';
import 'package:deligo_delivery/models/user_data.dart';
import 'package:deligo_delivery/utility/locale_data_layer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';

import 'package:deligo_delivery/bloc/app_cubit.dart';
import 'package:deligo_delivery/bloc/fetcher_cubit.dart';
import 'package:deligo_delivery/config/assets.dart';
import 'package:deligo_delivery/config/colors.dart';
import 'package:deligo_delivery/localization/app_localization.dart';
import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/driver_profile_update_request.dart';
import 'package:deligo_delivery/models/vehicle_type.dart';
import 'package:deligo_delivery/utility/helper.dart';
import 'package:deligo_delivery/utility/picker.dart';
import 'package:deligo_delivery/utility/remote_uploader.dart';
import 'package:deligo_delivery/widgets/cached_image.dart';
import 'package:deligo_delivery/widgets/custom_button.dart';
import 'package:deligo_delivery/widgets/custom_dropdown_field.dart';
import 'package:deligo_delivery/widgets/entry_field.dart';
import 'package:deligo_delivery/widgets/loader.dart';
import 'package:deligo_delivery/widgets/toaster.dart';

class ProfilePage extends StatelessWidget {
  final bool fromRoot;
  const ProfilePage({super.key, this.fromRoot = false});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: ProfileStateful(fromRoot: fromRoot),
      );
}

class ProfileStateful extends StatefulWidget {
  final bool fromRoot;
  const ProfileStateful({super.key, this.fromRoot = false});

  @override
  State<ProfileStateful> createState() => _ProfileStatefulState();
}

class _ProfileStatefulState extends State<ProfileStateful> {
  late FetcherCubit _fetcherCubit;

  DriverProfile? driverProfile;
  List<VehicleType>? vehicleTypes;
  List<int>? selectedVehicleTypes = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  String? imageUrl;
  File? _filePicked;
  String? ridingMode;
  String? gender;
  String? rideServicePref;
  VehicleType? vehicleTypeSelected;
  bool hotFoodBag = false;
  String? drivingLicense;

  @override
  void initState() {
    _fetcherCubit = BlocProvider.of<FetcherCubit>(context);
    super.initState();
    LocalDataLayer().getProfileMode().then((ProfileMode? pm) {
      if (pm?.riding_mode != null) {
        ridingMode = pm!.riding_mode;
        _fetcherCubit.initFetchProfileMe();
      } else {
        LocalDataLayer().getUserMe().then((UserData? ud) {
          driverProfile = DriverProfile.onlyUser(ud!);
          _nameController.text = driverProfile?.user?.name ?? "";
          _phoneController.text = driverProfile?.user?.mobile_number ?? "";
          _emailController.text = driverProfile?.user?.email ?? "";
          setState(() {});
        });
      }
    });
    _fetcherCubit.initFetchVehicleTypes();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: widget.fromRoot
            ? null
            : Padding(
                padding: EdgeInsetsGeometry.only(left: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                  ),
                  padding: const EdgeInsets.only(left: 16),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
        title: Text(
          AppLocalization.instance.getLocalizationFor("profile"),
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          if (widget.fromRoot)
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AppCubit>(context).logOut();
                Phoenix.rebirth(context);
              },
            ),
        ],
      ),
      body: BlocListener<FetcherCubit, FetcherState>(
        listener: (context, state) {
          if (state is ProfileMeLoaded) {
            driverProfile = state.driverProfile;
            _nameController.text = driverProfile?.user?.name ?? "";
            _phoneController.text = driverProfile?.user?.mobile_number ?? "";
            _emailController.text = driverProfile?.user?.email ?? "";

            gender = driverProfile?.metaValue("gender");
            rideServicePref = driverProfile?.metaValue("ride_serv_pref");
            _vehicleNumberController.text =
                driverProfile?.metaValue("vehicle_number") ?? "";
            hotFoodBag = driverProfile?.metaValue("hot_food_bag") == "true";
            drivingLicense = driverProfile?.metaValue("driving_license");
            selectedVehicleTypes =
                driverProfile?.vehicletypes?.map((e) => e.id).toList() ?? [];

            if (state.ridingMode != null) {
              ridingMode = state.ridingMode;
            }
            setState(() {});
          }
          if (state is VehicleTypeLoaded) {
            vehicleTypes = state.vehicleTypes;
            setState(() {});
          }
          if (state is ProfileMeUpdateLoading || state is ProfileMeLoading) {
            Loader.showLoader(context);
          } else {
            Loader.dismissLoader(context);
          }
          if (state is ProfileMeUpdateLoaded) {
            if (widget.fromRoot) {
              Phoenix.rebirth(context);
            } else {
              Navigator.pop(context);
            }
          }
          if (state is ProfileMeUpdateFail) {
            Toaster.showToastCenter(
                context.getLocalizationFor(state.messageKey));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: GestureDetector(
                            onTap: () => Picker()
                                .pickImageFile(
                              context: context,
                              pickerSource: PickerSource.ask,
                              cropConfig: CropConfig.square,
                            )
                                .then(
                              (File? pickedFile) {
                                _filePicked = pickedFile;
                                setState(() {});
                                if (_filePicked != null && mounted) {
                                  RemoteUploader.uploadFile(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          _filePicked!,
                                          AppLocalization.instance
                                              .getLocalizationFor("uploading"),
                                          AppLocalization.instance
                                              .getLocalizationFor(
                                                  "just_moment"))
                                      .then((String? url) {
                                    imageUrl = url;
                                    setState(() {});
                                  });
                                }
                              },
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      end: 12.0, top: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedImage(
                                      imageUrl: imageUrl ??
                                          driverProfile?.user?.imageUrl,
                                      height: 62,
                                      width: 62,
                                      imagePlaceholder: Assets.emptyProfile,
                                      fit: BoxFit.fill,
                                      placeholderWidget: _filePicked != null
                                          ? Image.file(
                                              _filePicked!,
                                              height: 62,
                                              width: 62,
                                              fit: BoxFit.fill,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        EntryField(
                          label: AppLocalization.instance
                              .getLocalizationFor("fullName"),
                          controller: _nameController,
                        ),
                        const SizedBox(height: 20),
                        CustomDropdownField(
                          label: AppLocalization.instance
                              .getLocalizationFor("riding_mode"),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              AppLocalization.instance
                                  .getLocalizationFor("select_riding_mode"),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: 15,
                              ),
                            ),
                            underline: const SizedBox.shrink(),
                            value: ridingMode,
                            items: [
                              "delivery",
                              "riding",
                            ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(AppLocalization.instance
                                        .getLocalizationFor("riding_mode_$e")),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => _fetcherCubit
                                .initFetchProfileMe(ridingMode: val),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomDropdownField(
                          label: AppLocalization.instance
                              .getLocalizationFor("gender"),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              AppLocalization.instance
                                  .getLocalizationFor("select_gender"),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: 15,
                              ),
                            ),
                            underline: const SizedBox.shrink(),
                            value: gender,
                            items: [
                              "male",
                              "female",
                            ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(toBeginningOfSentenceCase(e)),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => setState(() => gender = val),
                          ),
                        ),
                        const SizedBox(height: 20),
                        EntryField(
                          label: AppLocalization.instance
                              .getLocalizationFor("phoneNumber"),
                          readOnly: true,
                          controller: _phoneController,
                        ),
                        const SizedBox(height: 20),
                        EntryField(
                          label: AppLocalization.instance
                              .getLocalizationFor("emailAddress"),
                          readOnly: true,
                          controller: _emailController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (ridingMode == "riding")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalization.instance
                                .getLocalizationFor("servicePreferences"),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                              AppLocalization.instance
                                  .getLocalizationFor("serviceType"),
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(color: theme.hintColor)),
                          RadioListTile(
                            title: Text(
                                AppLocalization.instance
                                    .getLocalizationFor("rideIntercity"),
                                style: theme.textTheme.labelLarge),
                            contentPadding: EdgeInsets.zero,
                            activeColor: theme.primaryColor,
                            value: "ride_intercity",
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return theme.primaryColor;
                              }
                              return theme.hintColor;
                            }),
                            groupValue: rideServicePref,
                            onChanged: (val) =>
                                setState(() => rideServicePref = val),
                          ),
                          RadioListTile(
                            title: Text(
                                AppLocalization.instance
                                    .getLocalizationFor("package"),
                                style: theme.textTheme.labelLarge),
                            contentPadding: EdgeInsets.zero,
                            activeColor: theme.primaryColor,
                            value: "package",
                            groupValue: rideServicePref,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return theme.primaryColor;
                              }
                              return theme.hintColor;
                            }),
                            onChanged: (val) =>
                                setState(() => rideServicePref = val),
                          ),
                          RadioListTile(
                            title: Text(
                                AppLocalization.instance
                                    .getLocalizationFor("both"),
                                style: theme.textTheme.labelLarge),
                            contentPadding: EdgeInsets.zero,
                            activeColor: theme.primaryColor,
                            value: "both",
                            groupValue: rideServicePref,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return theme.primaryColor;
                              }
                              return theme.hintColor;
                            }),
                            onChanged: (val) =>
                                setState(() => rideServicePref = val),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalization.instance
                                    .getLocalizationFor("vehicleCategory"),
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: theme.hintColor),
                              ),
                              const SizedBox(height: 12),
                              if ((vehicleTypes ?? []).any((e) =>
                                  e.type == "ride" &&
                                  rideServicePref != "package")) ...[
                                Text(
                                  AppLocalization.instance
                                      .getLocalizationFor("ride"),
                                  style: theme.textTheme.titleMedium,
                                ),
                                ...vehicleTypes!
                                    .where((e) => e.type == "ride")
                                    .map(
                                      (vehicle) => CheckboxListTile(
                                        side:
                                            BorderSide(color: theme.hintColor),
                                        activeColor: theme.primaryColor,
                                        checkColor:
                                            theme.scaffoldBackgroundColor,
                                        title: Text(
                                          vehicle.title,
                                          style: theme.textTheme.labelLarge,
                                        ),
                                        value: selectedVehicleTypes
                                                ?.contains(vehicle.id) ??
                                            false,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedVehicleTypes ??= [];
                                              selectedVehicleTypes!.removeWhere(
                                                  (id) =>
                                                      vehicleTypes!
                                                          .firstWhere(
                                                              (v) => v.id == id)
                                                          .type ==
                                                      'ride');
                                              selectedVehicleTypes!
                                                  .add(vehicle.id);
                                            } else {
                                              selectedVehicleTypes
                                                  ?.remove(vehicle.id);
                                            }
                                          });
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                const SizedBox(height: 16),
                              ],

                              // Intercity vehicles
                              if ((vehicleTypes ?? []).any((e) =>
                                  e.type == 'intercity' &&
                                  rideServicePref != "package")) ...[
                                Text(
                                  AppLocalization.instance
                                      .getLocalizationFor("intercity"),
                                  style: theme.textTheme.titleMedium,
                                ),
                                ...vehicleTypes!
                                    .where((e) => e.type == 'intercity')
                                    .map(
                                      (vehicle) => CheckboxListTile(
                                        side:
                                            BorderSide(color: theme.hintColor),
                                        activeColor: theme.primaryColor,
                                        checkColor:
                                            theme.scaffoldBackgroundColor,
                                        title: Text(
                                          vehicle.title,
                                          style: theme.textTheme.labelLarge,
                                        ),
                                        overlayColor: WidgetStateProperty.all(
                                            theme.hintColor),
                                        value: selectedVehicleTypes
                                                ?.contains(vehicle.id) ??
                                            false,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedVehicleTypes ??= [];
                                              selectedVehicleTypes!.removeWhere(
                                                  (id) =>
                                                      vehicleTypes!
                                                          .firstWhere(
                                                              (v) => v.id == id)
                                                          .type ==
                                                      'intercity');
                                              selectedVehicleTypes!
                                                  .add(vehicle.id);
                                            } else {
                                              selectedVehicleTypes
                                                  ?.remove(vehicle.id);
                                            }
                                          });
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                const SizedBox(height: 16),
                              ],
                              if ((vehicleTypes ?? []).any((e) =>
                                  e.type == 'courier' &&
                                  rideServicePref != "ride_intercity")) ...[
                                Text(
                                  AppLocalization.instance
                                      .getLocalizationFor("package"),
                                  style: theme.textTheme.titleMedium,
                                ),
                                ...vehicleTypes!
                                    .where((e) => e.type == 'courier')
                                    .map(
                                      (vehicle) => CheckboxListTile(
                                        side:
                                            BorderSide(color: theme.hintColor),
                                        activeColor: theme.primaryColor,
                                        checkColor:
                                            theme.scaffoldBackgroundColor,
                                        title: Text(
                                          vehicle.title,
                                          style: theme.textTheme.labelLarge,
                                        ),
                                        value: selectedVehicleTypes
                                                ?.contains(vehicle.id) ??
                                            false,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedVehicleTypes ??= [];
                                              selectedVehicleTypes!.removeWhere(
                                                  (id) =>
                                                      vehicleTypes!
                                                          .firstWhere(
                                                              (v) => v.id == id)
                                                          .type ==
                                                      'courier');
                                              selectedVehicleTypes!
                                                  .add(vehicle.id);
                                            } else {
                                              selectedVehicleTypes
                                                  ?.remove(vehicle.id);
                                            }
                                          });
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 22),
                          // CustomDropdownField(
                          //   label: AppLocalization.instance
                          //       .getLocalizationFor("packageVehicleCategory"),
                          //   child: DropdownButton(
                          //     isExpanded: true,
                          //     hint: Text(
                          //       'Scooter',
                          //       style: theme.textTheme.titleSmall?.copyWith(
                          //         fontSize: 15,
                          //       ),
                          //     ),
                          //     underline: const SizedBox.shrink(),
                          //     value: null,
                          //     items: [
                          //       'Scooter',
                          //       'Car',
                          //       'Van',
                          //       'Van',
                          //     ]
                          //         .map(
                          //           (e) => DropdownMenuItem(
                          //             value: e,
                          //             child: Text(e),
                          //           ),
                          //         )
                          //         .toList(),
                          //     onChanged: (val) {},
                          //   ),
                          // ),
                          // const SizedBox(height: 22),
                          // EntryField(
                          //   label: AppLocalization.instance
                          //       .getLocalizationFor("vehicleNumber"),
                          //   controller: _vehicleNumberController,
                          // ),
                        ],
                      ),
                    //if (ridingMode == "riding") const SizedBox(height: 20),
                    EntryField(
                        label: AppLocalization.instance
                            .getLocalizationFor("vehicleNumber"),
                        controller: _vehicleNumberController,
                        readOnly: !widget.fromRoot),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            AppLocalization.instance
                                .getLocalizationFor("hot_food_bag"),
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Transform.scale(
                          scale: 0.6,
                          child: CupertinoSwitch(
                            value: hotFoodBag,
                            // inactiveTrackColor:
                            //     isDark ? Colors.white38 : Colors.black12,
                            // activeTrackColor:
                            //     isDark ? Colors.white70 : Colors.black,
                            activeTrackColor:
                                theme.brightness == Brightness.dark
                                    ? Colors.white70
                                    : theme.primaryColor,
                            onChanged: (val) =>
                                setState(() => hotFoodBag = val),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalization.instance
                              .getLocalizationFor("document"),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 24),
                        EntryField(
                          label: AppLocalization.instance.getLocalizationFor(
                              (drivingLicense == null ||
                                      driverProfile?.is_verified == 1)
                                  ? "drivingLicense"
                                  : "drivingLicensePendingVerification"),
                          initialValue: AppLocalization.instance
                              .getLocalizationFor(drivingLicense == null
                                  ? "drivingLicenseUpload"
                                  : "drivingLicenseUploaded"),
                          readOnly: true,
                          suffix: Icon(
                            (drivingLicense != null &&
                                    driverProfile?.is_verified == 0)
                                ? Icons.schedule
                                : Icons.check_circle,
                            color: drivingLicense == null
                                ? theme.primaryColorLight
                                : (driverProfile?.is_verified == 0
                                    ? orderOrange
                                    : theme.primaryColor),
                          ),
                          onTap: () => Picker()
                              .pickImageFile(
                            context: context,
                            pickerSource: PickerSource.ask,
                          )
                              .then(
                            (File? pickedFile) {
                              if (pickedFile != null && mounted) {
                                RemoteUploader.uploadFile(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        pickedFile,
                                        AppLocalization.instance
                                            .getLocalizationFor("uploading"),
                                        AppLocalization.instance
                                            .getLocalizationFor("just_moment"))
                                    .then((String? url) {
                                  drivingLicense = url;
                                  setState(() {});
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              CustomButton(
                label: AppLocalization.instance.getLocalizationFor("update"),
                onTap: () {
                  Helper.clearFocus(context);
                  if (_nameController.text.trim().isEmpty) {
                    Toaster.showToastCenter(
                        context.getLocalizationFor("enter_profile_name"));
                    return;
                  }
                  if (widget.fromRoot &&
                      _vehicleNumberController.text.isEmpty) {
                    Toaster.showToastCenter(
                        context.getLocalizationFor("enterVehicleNumber"));
                    return;
                  }
                  if (ridingMode == null) {
                    Toaster.showToastCenter(
                        context.getLocalizationFor("select_riding_mode"));
                    return;
                  }
                  if (gender == null) {
                    Toaster.showToastCenter(
                        context.getLocalizationFor("select_gender"));
                    return;
                  }
                  if (ridingMode == "riding") {
                    if (rideServicePref == null) {
                      Toaster.showToastCenter(context
                          .getLocalizationFor("selectServicePreferences"));
                      return;
                    }
                    if (rideServicePref == "both") {
                      bool foundRide = false;
                      bool foundIntercity = false;
                      bool foundPackage = false;
                      for (VehicleType vt in (vehicleTypes ?? [])) {
                        if ((selectedVehicleTypes?.contains(vt.id) ?? false) &&
                            vt.type == "ride") {
                          foundRide = true;
                        }
                        if ((selectedVehicleTypes?.contains(vt.id) ?? false) &&
                            vt.type == "intercity") {
                          foundIntercity = true;
                        }
                        if ((selectedVehicleTypes?.contains(vt.id) ?? false) &&
                            vt.type == "courier") {
                          foundPackage = true;
                        }
                        if (foundRide && foundIntercity && foundPackage) {
                          break;
                        }
                      }
                      if (!(foundRide && foundIntercity && foundPackage)) {
                        Toaster.showToastCenter(context
                            .getLocalizationFor("selectVehicleTypeBoth"));
                        return;
                      }
                    }
                    if (rideServicePref == "ride_intercity") {
                      bool foundRide = false;
                      bool foundIntercity = false;
                      for (VehicleType vt in (vehicleTypes ?? [])) {
                        if ((selectedVehicleTypes?.contains(vt.id) ?? false) &&
                            vt.type == "ride") {
                          foundRide = true;
                        }
                        if ((selectedVehicleTypes?.contains(vt.id) ?? false) &&
                            vt.type == "intercity") {
                          foundIntercity = true;
                        }
                        if (foundRide && foundIntercity) {
                          break;
                        }
                      }
                      if (!(foundRide && foundIntercity)) {
                        Toaster.showToastCenter(context.getLocalizationFor(
                            "selectVehicleTypeRideIntercity"));
                        return;
                      }
                    }
                    if (rideServicePref == "package") {
                      bool foundPackage = false;
                      for (VehicleType vt in (vehicleTypes ?? [])) {
                        if ((selectedVehicleTypes?.contains(vt.id) ?? false) &&
                            vt.type == "courier") {
                          foundPackage = true;
                        }
                        if (foundPackage) {
                          break;
                        }
                      }
                      if (!foundPackage) {
                        Toaster.showToastCenter(context
                            .getLocalizationFor("selectVehicleTypePackge"));
                        return;
                      }
                    }
                    if (selectedVehicleTypes?.isEmpty ?? true) {
                      Toaster.showToastCenter(
                          context.getLocalizationFor("selectVehicleType"));
                      return;
                    }
                  }

                  if (_vehicleNumberController.text.trim().isEmpty) {
                    Toaster.showToastCenter(
                        context.getLocalizationFor("enterVehicleNumber"));
                    return;
                  }
                  if (drivingLicense == null) {
                    Toaster.showToastCenter(
                        context.getLocalizationFor("uploadDrivingLicense"));
                    return;
                  }

                  DriverProfileUpdateRequest driverProfileUpdateRequest =
                      DriverProfileUpdateRequest(
                    vehicletypes:
                        ridingMode == "riding" ? selectedVehicleTypes : null,
                    meta: jsonEncode({
                      "riding_mode": ridingMode,
                      "gender": gender,
                      "ride_serv_pref": rideServicePref,
                      "vehicle_number": _vehicleNumberController.text.trim(),
                      "hot_food_bag": hotFoodBag.toString(),
                      "driving_license": drivingLicense,
                    }),
                  );
                  _fetcherCubit.initUpdateProfileMe(
                    driverProfileUpdateRequest,
                    userName: _nameController.text.trim(),
                    userImage: imageUrl,
                    ridingMode: ridingMode!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }
}
