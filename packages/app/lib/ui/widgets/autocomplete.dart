// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/utils/debouncable.dart';

typedef OptionsRequest = Future<Iterable<String>> Function(String);

/// Define maximum number of options shown in autocomplete, next to the current
/// input value.
const MAX_OPTIONS = 5;

class MeliAutocomplete extends StatefulWidget {
  final OptionsRequest onOptionsRequest;
  final Function? onChanged;

  MeliAutocomplete({
    super.key,
    required this.onOptionsRequest,
    this.onChanged,
  });

  @override
  State<MeliAutocomplete> createState() => _MeliAutocompleteState();
}

class _MeliAutocompleteState extends State<MeliAutocomplete> {
  late final Debounceable<Iterable<String>?, String> _debouncedSearch;

  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;

  // The most recent options received from the API.
  late Iterable<String> _lastOptions = <String>[];

  // A network error was recieved on the most recent query.
  bool _isError = false;

  // Flag indicating that we're currently waiting for an network request.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _debouncedSearch = debounce<Iterable<String>?, String>(_search);
  }

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<String>?> _search(String query) async {
    _currentQuery = query;

    late final Iterable<String> options;
    try {
      options = await widget.onOptionsRequest(query);
    } catch (error) {
      setState(() {
        _isError = true;
      });

      return <String>[];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }

    _currentQuery = null;

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Autocomplete<String>(
        fieldViewBuilder: (BuildContext context,
            TextEditingController controller,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextFormField(
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!.call(value);
              }
            },
            decoration: InputDecoration(
              suffixIcon: _isLoading
                  ? Transform.scale(
                      scale: 0.4,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ))
                  : Icon(Icons.arrow_drop_down, color: Colors.black),
              errorText: _isError ? 'Error, please try again.' : null,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                      style: BorderStyle.solid)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                      style: BorderStyle.solid)),
            ),
            controller: controller,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
          );
        },
        optionsViewBuilder:
            (BuildContext context, onSelected, Iterable<String> options) {
          return Container(
              margin: EdgeInsets.only(top: 1.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 3.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(4.0)),
                  ),
                  child: Container(
                    height: 52.0 * options.length,
                    width: constraints.maxWidth,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      shrinkWrap: false,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(option),
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

          final Iterable<String>? result =
              await _debouncedSearch(textEditingValue.text);

          // Show last options when the current query is being debounced
          final options =
              result == null ? _lastOptions : result.take(MAX_OPTIONS);

          // Keep track of our options to be able to show them at any point,
          // even when we're currently querying for new ones
          _lastOptions = options;

          // Include what the user is currently typing to make this an selectable
          // "free form" option
          return textEditingValue.text.isNotEmpty
              ? [textEditingValue.text, ...options]
              : options;
        },
        onSelected: (String selection) {
          if (widget.onChanged != null) {
            widget.onChanged!.call(selection);
          }
        },
      );
    });
  }
}
