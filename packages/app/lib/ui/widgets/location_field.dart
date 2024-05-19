// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/location.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/read_only_value.dart';

const BOX_ICON = Icon(Icons.hive);
const BUILDING_ICON = Icon(Icons.home);
const GROUND_ICON = Icon(Icons.grass);
const TREE_ICON = Icon(Icons.park);

class LocationField extends StatefulWidget {
  /// Document id of the sighting we're managing the location for.
  final DocumentId sightingId;

  const LocationField({super.key, required this.sightingId});

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  /// Is widget currently loading initial data or not.
  bool isReady = false;

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return EditableCard(
        title: t.hiveLocationCardTitle,
        onChanged: _toggleEditMode,
        isEditMode: isEditMode,
        child: Query(
            options:
                QueryOptions(document: gql(locationQuery(widget.sightingId))),
            builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return ErrorCard(message: result.exception.toString());
              }

              if (result.isLoading) {
                return const Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child:
                          CircularProgressIndicator(color: MeliColors.black)),
                );
              }

              Location? location =
                  getLocationFromResults(result.data as Map<String, dynamic>);

              // @TODO: Edit button should be disabled while widget is loading.
              // See related issue: https://github.com/p2panda/meli/issues/93
              isReady = true;

              return LocationFieldInner(
                  initialValue: location,
                  sightingId: widget.sightingId,
                  isEditMode: isEditMode,
                  onUpdated: () {
                    setState(() {
                      isEditMode = false;
                    });
                  });
            }));
  }
}

class LocationFieldInner extends StatefulWidget {
  final Location? initialValue;
  final DocumentId sightingId;

  final bool isEditMode;
  final VoidCallback onUpdated;

  const LocationFieldInner(
      {super.key,
      required this.initialValue,
      required this.sightingId,
      required this.isEditMode,
      required this.onUpdated});

  @override
  State<LocationFieldInner> createState() => _LocationFieldInnerState();
}

class _LocationFieldInnerState extends State<LocationFieldInner> {
  late Location? location;

  @override
  void initState() {
    super.initState();
    location = widget.initialValue;
  }

  void _handleUpdate(LocationType? type, String? treeSpecies,
      double? treeHeight, double? treeDiameter) async {
    if (widget.initialValue != null && type == null) {
      // Delete attached sighting if any existed
      await widget.initialValue!.delete();
      setState(() {});
    } else if (widget.initialValue?.type == LocationType.Tree &&
        type == LocationType.Tree) {
      // Update location if it is a tree location (other location types do not
      // have any special fields to update so we ignore them)
      // @TODO: Also update tree species
      await widget.initialValue!
          .update(height: treeHeight, diameter: treeDiameter);
      setState(() {});
    } else if (widget.initialValue?.type != type && type != null) {
      // Delete previous attached location if any existed
      if (widget.initialValue != null) {
        await widget.initialValue!.delete();
      }

      // Create new location and attach it to sighting
      Location location = await Location.create(
          type: type,
          sightingId: widget.sightingId,
          height: treeHeight,
          diameter: treeDiameter);

      setState(() {
        this.location = location;
      });
    } else {
      // Nothing changed, so do nothing ..
    }

    widget.onUpdated();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditMode) {
      return LocationFieldEdit(
          location: location,
          onUpdated: _handleUpdate,
          onCancelled: () {
            widget.onUpdated();
          });
    }

    return LocationFieldShow(location: location);
  }
}

class LocationFieldShow extends StatelessWidget {
  final Location? location;

  const LocationFieldShow({super.key, required this.location});

  Widget _icon() {
    switch (location!.type) {
      case LocationType.Box:
        return BOX_ICON;
      case LocationType.Building:
        return BUILDING_ICON;
      case LocationType.Ground:
        return GROUND_ICON;
      case LocationType.Tree:
        return TREE_ICON;
    }
  }

  Widget _type() {
    switch (location!.type) {
      case LocationType.Box:
        return const Text("Box");
      case LocationType.Building:
        return const Text("Building");
      case LocationType.Ground:
        return const Text("Ground");
      case LocationType.Tree:
        return const Text("Tree");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReadOnlyBase<Location>(
        value: location,
        builder: (Location location) {
          return Column(children: [
            _icon(),
            _type(),
          ]);
        });
  }
}

typedef OnUpdated = void Function(
    LocationType? type, String? species, double? height, double? diameter);

class LocationFieldEdit extends StatefulWidget {
  final Location? location;
  final OnUpdated onUpdated;
  final Function onCancelled;

  const LocationFieldEdit(
      {super.key,
      required this.location,
      required this.onUpdated,
      required this.onCancelled});

  @override
  State<LocationFieldEdit> createState() => _LocationFieldEditState();
}

class _LocationFieldEditState extends State<LocationFieldEdit> {
  late LocationType? type;
  String? treeSpecies;
  double? height;
  double? diameter;

  @override
  void initState() {
    super.initState();

    if (widget.location == null) {
      type = LocationType.Box;
    } else {
      type = widget.location!.type;

      if (widget.location!.type == LocationType.Tree) {
        // @TODO: Set treeSpecies as well
        height = widget.location!.height;
        diameter = widget.location!.diameter;
      }
    }
  }

  void _handleSave() {
    if (type == LocationType.Tree) {
      widget.onUpdated(type, treeSpecies, height, diameter);
    } else if (type == null) {
      widget.onUpdated(null, null, null, null);
    } else {
      widget.onUpdated(type, null, null, null);
    }
  }

  void _handleCancel() {
    widget.onCancelled();
  }

  Widget _additionalInfo() {
    if (type == LocationType.Tree) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TreeLocationEdit(
              treeSpecies: treeSpecies,
              height: height,
              diameter: diameter,
              onUpdated: (treeSpecies, height, diameter) {
                setState(() {
                  this.treeSpecies = treeSpecies;
                  this.height = height;
                  this.diameter = diameter;
                });
              }));
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LocationTypeSelector(
        locationType: type,
        onUpdated: (LocationType? locationType) {
          setState(() {
            type = locationType;
          });
        },
      ),
      _additionalInfo(),
      Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(children: [
            OverflowBar(
              spacing: 5,
              overflowAlignment: OverflowBarAlignment.start,
              children: [
                FilledButton(
                  onPressed: _handleSave,
                  child: const Text("Save"),
                ),
                OutlinedButton(
                    onPressed: _handleCancel, child: const Text("Cancel"))
              ],
            )
          ])),
    ]);
  }
}

typedef OnTreeUpdated = void Function(
    String? species, double? height, double? diameter);

class TreeLocationEdit extends StatelessWidget {
  final String? treeSpecies;
  final double? diameter;
  final double? height;

  final OnTreeUpdated onUpdated;

  const TreeLocationEdit(
      {super.key,
      required this.treeSpecies,
      required this.diameter,
      required this.height,
      required this.onUpdated});

  Widget _label(String title, double? value) {
    if (value == null) {
      return Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
    }

    return Row(
      children: [
        Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("${value}m"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label("Tree Species", null),
      TextFormField(
          initialValue: treeSpecies,
          onChanged: (String value) {
            onUpdated(value.isEmpty ? null : value, height, diameter);
          }),
      const SizedBox(height: 20.0),
      _label("Height", height),
      Slider(
        min: 0.0,
        max: 100.0,
        divisions: 100,
        value: height != null ? height! : 0.0,
        onChanged: (double value) {
          onUpdated(treeSpecies, value == 0.0 ? null : value.roundToDouble(),
              diameter);
        },
      ),
      const SizedBox(height: 20.0),
      _label("Diameter", diameter),
      Slider(
        min: 0.0,
        max: 10.0,
        divisions: 20,
        value: diameter != null ? diameter! : 0.0,
        onChanged: (double value) {
          onUpdated(treeSpecies, height, value == 0.0 ? null : value);
        },
      ),
    ]);
  }
}

typedef OnTypeUpdated = void Function(LocationType? locationType);

class LocationTypeSelector extends StatelessWidget {
  final LocationType? locationType;
  final OnTypeUpdated onUpdated;

  const LocationTypeSelector(
      {super.key, required this.locationType, required this.onUpdated});

  void _onToggle(LocationType value) {
    if (locationType == value) {
      onUpdated(null);
    } else {
      onUpdated(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 5.0, runSpacing: 5.0, children: [
      LocationTypeButton(
          label: "Box",
          icon: BOX_ICON,
          onPressed: () {
            _onToggle(LocationType.Box);
          },
          active: locationType == LocationType.Box),
      LocationTypeButton(
          label: "Building",
          icon: BUILDING_ICON,
          onPressed: () {
            _onToggle(LocationType.Building);
          },
          active: locationType == LocationType.Building),
      LocationTypeButton(
          label: "Ground",
          icon: GROUND_ICON,
          onPressed: () {
            _onToggle(LocationType.Ground);
          },
          active: locationType == LocationType.Ground),
      LocationTypeButton(
          label: "Tree",
          icon: TREE_ICON,
          onPressed: () {
            _onToggle(LocationType.Tree);
          },
          active: locationType == LocationType.Tree),
    ]);
  }
}

class LocationTypeButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final VoidCallback? onPressed;
  final bool active;

  const LocationTypeButton(
      {super.key,
      required this.active,
      required this.label,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor:
              active ? MeliColors.leaf : MeliColors.leaf.withOpacity(0.3),
          padding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
      onPressed: onPressed,
      child: Column(
        children: [icon, Text(label)],
      ),
    );
  }
}
