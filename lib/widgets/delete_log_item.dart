import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:iot_logger/services/arduino_repository.dart';

import 'package:circular_check_box/circular_check_box.dart';

class DeleteLogItem extends StatelessWidget {
  final String fileName;

  final ArduinoRepository arduinoRepository;
  const DeleteLogItem(this.fileName, this.arduinoRepository);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 10,
      ),
      child: InkWell(
        onTap: () => null,
        borderRadius: BorderRadius.circular(4),
        child: Center(
          child: logTile(context, fileName),
        ),
      ),
    );
  }
}

Widget logTile(BuildContext context, String fileName) {
  bool checked = false;
  //context.read<LogDownloadCubit>().downloadFile(fileName);
  return Container(
    child: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Folder
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                alignment: Alignment.center,
                child: Icon(
                  Icons.folder,
                  color: Theme.of(context).accentColor,
                  size: 40,
                ),
              ),
              // File Name (date)
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                alignment: Alignment.center,
                child: logDate(context, fileName),
              ),
              // Check Box
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    checked = true;
                  },
                  child: CircularCheckBox(
                    value: checked,
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    inactiveColor: Colors.redAccent,
                    disabledColor: Colors.grey,
                    onChanged: (bool value) {
                      //checked = value;
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget logDate(BuildContext context, String fileName) {
  return Text(
    fileName,
    style: TextStyle(
        color: Theme.of(context).focusColor,
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontFamily: 'Montserrat'),
  );
}
