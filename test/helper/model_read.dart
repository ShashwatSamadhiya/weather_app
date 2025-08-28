import 'dart:io';

String modelReaderHelper(String name) =>
    File('test/helper/$name').readAsStringSync();
