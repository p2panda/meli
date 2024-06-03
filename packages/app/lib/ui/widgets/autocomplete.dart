// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/ui/colors.dart';
import 'package:app/utils/debouncable.dart';

typedef OnOptionsRequest = Future<Iterable<AutocompleteItem>> Function(String);

typedef OnChanged = void Function(AutocompleteItem);

/// Define maximum number of options shown in autocomplete, next to the current
/// input value.
const MAX_OPTIONS = 3;

class AutocompleteItem {
  final String value;
  final DocumentId? documentId;
  final DocumentViewId? viewId;

  AutocompleteItem({required this.value, this.documentId, this.viewId});
}

class MeliAutocomplete extends StatefulWidget {
  final OnOptionsRequest onOptionsRequest;
  final OnChanged? onChanged;
  final VoidCallback? onSubmit;
  final AutocompleteItem? initialValue;
  final bool autofocus;

  const MeliAutocomplete({
    super.key,
    required this.onOptionsRequest,
    this.autofocus = false,
    this.initialValue,
    this.onChanged,
    this.onSubmit,
  });

  @override
  State<MeliAutocomplete> createState() => _MeliAutocompleteState();
}

class _MeliAutocompleteState extends State<MeliAutocomplete> {
  late final Debounceable<Iterable<AutocompleteItem>?, String> _debouncedSearch;

  /// The query currently being searched for. If null, there is no pending
  /// request.
  String? _currentQuery;

  /// The most recent options received from the API.
  late Iterable<AutocompleteItem> _lastOptions = <AutocompleteItem>[];

  /// A network error was recieved on the most recent query.
  bool _isError = false;

  /// Flag indicating that we're currently waiting for an network request.
  bool _isLoading = false;

  /// Keep a reference to the Autocomplete focus node instance, so we can
  /// control its focus state from outside of it.
  late FocusNode textInputFocusNode;

  @override
  void initState() {
    super.initState();
    _debouncedSearch = debounce<Iterable<AutocompleteItem>?, String>(_search);
  }

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<AutocompleteItem>?> _search(String query) async {
    _currentQuery = query;

    late final Iterable<AutocompleteItem> options;
    try {
      options = await widget.onOptionsRequest(query);
    } catch (error) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }

      return <AutocompleteItem>[];
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }

    _currentQuery = null;

    return options;
  }

  void _onChanged(String value) {
    // Double-check if user actually typed _exactly_ the same value
    // as one of our existing options
    final Iterable<AutocompleteItem> duplicates = _lastOptions.where(
        (element) => element.value == value && element.documentId != null);
    if (duplicates.isNotEmpty) {
      widget.onChanged!.call(duplicates.first);
    } else {
      // .. otherwise use newly created user value
      widget.onChanged!.call(AutocompleteItem(value: value));
    }
  }

  void _onSubmit() {
    if (widget.onSubmit != null) {
      widget.onSubmit!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Autocomplete<AutocompleteItem>(
        initialValue: widget.initialValue != null
            ? TextEditingValue(text: widget.initialValue!.value)
            : TextEditingValue.empty,
        fieldViewBuilder: (BuildContext context,
            TextEditingController controller,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          textInputFocusNode = focusNode;

          return TextFormField(
            autofocus: widget.autofocus,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: _onChanged,
            onEditingComplete: () {
              // Remove focus from text-field, this will hide the keyboard
              focusNode.unfocus();

              // Submit the value to the parent widget
              _onSubmit();
            },
            // Scroll down a bit more to make sure the keyboard doesn't hide
            // the autocomplete options
            scrollPadding: const EdgeInsets.only(bottom: 200.0),
            decoration: InputDecoration(
              suffixIcon: _isLoading
                  ? Transform.scale(
                      scale: 0.4,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                      ))
                  : const Icon(Icons.arrow_drop_down, color: MeliColors.plum),
              errorText: _isError ? 'Error, please try again.' : null,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MeliColors.plum,
                      width: 3,
                      style: BorderStyle.solid)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MeliColors.plum,
                      width: 3,
                      style: BorderStyle.solid)),
            ),
            controller: controller,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              // NOTE: We do not call "onFieldSubmitted" here as the flutter
              // "Autocomplete" element automatically will then select the first
              // value, potentially overriding manually entered values, which is
              // not the intended behaviour. Read more about it here:
              // https://stackoverflow.com/questions/76572748/flutter-autocomplete-how-to-set-selected-option-to-null
            },
          );
        },
        optionsViewBuilder: (BuildContext context, onSelected,
            Iterable<AutocompleteItem> options) {
          return Container(
              margin: const EdgeInsets.only(top: 1.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 3.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(4.0)),
                  ),
                  child: SizedBox(
                    height: 52.0 * options.length,
                    width: constraints.maxWidth,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      shrinkWrap: false,
                      itemBuilder: (BuildContext context, int index) {
                        final AutocompleteItem option =
                            options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(option.value),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ));
        },
        optionsBuilder: (TextEditingValue textEditingValue) async {
          setState(() {
            _isLoading = true;
          });

          final Iterable<AutocompleteItem>? result =
              await _debouncedSearch(textEditingValue.text);

          // Show last options when the current query is being debounced
          final options =
              result == null ? _lastOptions : result.take(MAX_OPTIONS);

          // Keep track of our options to be able to show them at any point,
          // even when we're currently querying for new ones
          _lastOptions = options;

          // Remove option if it is the same as initial value
          final filtered = options
              .where((element) => element.value != widget.initialValue?.value);

          return filtered;
        },
        onSelected: (AutocompleteItem selection) {
          // Unfocus text field when user clicked on an option, this will hide
          // the keyboard
          textInputFocusNode.unfocus();

          if (widget.onChanged != null) {
            widget.onChanged!.call(selection);
          }
        },
        displayStringForOption: (AutocompleteItem option) {
          return option.value;
        },
      );
    });
  }
}
