import 'package:flutter/material.dart';
import 'package:yaaseen/hive_helper/app_prefs.dart';
import 'package:yaaseen/hive_helper/hive_boxes.dart';
import 'package:yaaseen/models/verse/verse_model.dart';
import 'package:yaaseen/widgets/widgets.dart';
import 'package:yaaseen/core/core.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final VerseModel _verse = HiveBoxes.verseBox.getAt(27)!;
  AppFormatter formatter = AppFormatter();
  late String number = formatter.numberFormat(_verse.verseId!);
  late String formatted = '\uFD3F$number\uFD3E';

  double _arabicSize = AppPrefs.arabicSize;
  double _meainingSize = AppPrefs.meaningSize;
  double _trSize = AppPrefs.trSize;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: 'Sozlamalar'),
      body: Column(
        children: [
          _showVerse(),
          _setData(SizeType.arabic),
          _setData(SizeType.meainig),
          _setData(SizeType.transcription),
        ],
      ),
    );
  }

  Row _setData(SizeType type) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: AppCheckboxListTile(
            title: _getTitle(type),
            value: true,
            onChanged: (v) {},
          ),
        ),
        Expanded(
          flex: 7,
          child: Slider(
            max: 24,
            min: 12,
            value: _getSize(type),
            onChanged: (v) async {
              switch (type) {
                case SizeType.arabic:
                  _arabicSize = v;
                  // await AppPrefs.setArabicSize(v);
                  break;

                case SizeType.meainig:
                  _meainingSize = v;
                  // await AppPrefs.setMeaingSize(v);
                  break;

                case SizeType.transcription:
                  _trSize = v;
                  // await AppPrefs.setTranscriptionSize(v);
                  break;
              }
              setState(() {});
            },
            onChangeEnd: (v) async {
              switch (type) {
                case SizeType.arabic:
                  // _arabicSize = v;
                  await AppPrefs.setArabicSize(v);
                  break;

                case SizeType.meainig:
                  // _meainingSize = v;
                  await AppPrefs.setMeaingSize(v);
                  break;

                case SizeType.transcription:
                  // _trSize = v;
                  await AppPrefs.setTranscriptionSize(v);
                  break;
              }
            },
          ),
        )
      ],
    );
  }

  double _getSize(SizeType type) {
    switch (type) {
      case SizeType.arabic:
        return _arabicSize;
      case SizeType.meainig:
        return _meainingSize;
      case SizeType.transcription:
        return _trSize;
    }
  }

  String _getTitle(SizeType type) {
    switch (type) {
      case SizeType.arabic:
        return 'Arabic';

      case SizeType.meainig:
        return 'Meaing';
      case SizeType.transcription:
        return 'Transcription';
    }
  }

  Widget _showVerse() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_verse.arabic!.replaceFirst('\n', '')} $formatted',
                textAlign: TextAlign.start,
                locale: const Locale('ar'),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: _arabicSize,
                  fontFamily: AppFonts.meQuran,
                  wordSpacing: 12,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              '${_verse.verseId}. ${_verse.meaning}',
              style: TextStyle(fontSize: _meainingSize),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      );
}

enum SizeType { arabic, meainig, transcription }