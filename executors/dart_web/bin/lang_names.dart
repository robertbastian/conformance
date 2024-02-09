import 'dart:convert';

import 'package:intl4x/display_names.dart';
import 'package:intl4x/intl4x.dart';

String testLangNames(String jsonEncoded) {
  final json = jsonDecode(jsonEncoded) as Map<String, dynamic>;

  final Locale locale;
  if (json['locale_label'] != null) {
    // Fix to use dash, not underscore.
    final localeJson = json['locale_label'] as String;
    locale = Locale.parse(localeJson.replaceAll('/_/g', '-'));
  } else {
    locale = Locale(language: 'en');
  }
  final languageLabel =
      (json['language_label'] as String).replaceAll('/_/g', '-');

  final outputLine = <String, dynamic>{};
  try {
    final options = DisplayNamesOptions(
      languageDisplay: LanguageDisplay.standard,
    );
    final displayNames = Intl(locale: locale).displayNames(options);
    final resultLocale = displayNames.ofLanguage(Locale.parse(languageLabel));

    outputLine['label'] = json['label'];
    outputLine['result'] = resultLocale;
  } catch (error) {
    outputLine.addAll({
      'error': error.toString(),
      'label': json['label'],
      'locale_label': locale.toLanguageTag(),
      'language_label': languageLabel,
      'test_type': 'display_names',
      'error_type': 'unsupported',
      'error_retry': false // Do not repeat
    });
  }
  return jsonEncode(outputLine);
}
