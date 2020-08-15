import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutrofit_generator/src/api_builders.dart';

Builder restApiBuilder(BuilderOptions options) => SharedPartBuilder([
      GetBuilderGenerator(),
      PostBuilderGenerator(),
      PutBuilderGenerator(),
      DeleteBuilderGenerator(),
    ], 'flutrofit');
