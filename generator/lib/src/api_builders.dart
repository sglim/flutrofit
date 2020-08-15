import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:flutrofit/flutrofit.dart';

String _generateParamsCode(List<String> params) {
  if (params.isEmpty) {
    return '';
  }
  return ', ' + params.map((param) => 'String ${param}').join(',');
}

String _generateReturnResponse(String res) {
  switch (res) {
    case 'String':
      return 'response.body';
    case 'void':
      return '';
    default:
      return '$res.fromJson(json.decode(response.body))';
  }
}

FutureOr<String> _generateCode(
    String method, Element element, ConstantReader annotation) {
  String className = element.displayName;
  String methodName = '${className[0].toLowerCase()}${className.substring(1)}';
  String path = annotation.read('path').stringValue;
  // TODO(sglim): Handle path required String. like '/account/{int uid}/

  String req = annotation.read('req').stringValue;
  String res = annotation.read('res').stringValue;

  bool isVoidRequest = req == 'void';
  String reqCode = isVoidRequest ? '' : ', {$req request}';
  String bodyString =
      isVoidRequest ? '' : 'body: json.encode(request.toJson()),';
  String bodyDebugPrint = isVoidRequest
      ? ''
      : ' \${JsonEncoder.withIndent(\'  \').convert(request.toJson())}';

  RegExp exp = new RegExp(r'{(\w+)}');
  Iterable<Match> matches = exp.allMatches(path);
  // Group 0 is {abc}, Group1 is abc.
  List<String> params = matches.map((match) => match.group(1)).toList();
  final paramsCode = _generateParamsCode(params);
  params.forEach((param) => path = path.replaceAll('{$param}', '\$$param'));

  return '''
Future<$res> _\$$methodName(client$paramsCode$reqCode) async {
  print('[$method] \${client.host}$path$bodyDebugPrint');
  final response = await client.$method('\${client.host}$path',
    ${bodyString}
  );

  if (HttpStatus.isSuccess(response.statusCode)) {
    return ${_generateReturnResponse(res)};
  } else {
    throw Exception('[$className] Failed: \${response.reasonPhrase}');
  }
  // Do we need to close the connection after a request?
}
  ''';
}

class GetBuilderGenerator extends GeneratorForAnnotation<Get> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    // TODO(sglim): Handle Get path param.
    return _generateCode('get', element, annotation);
  }
}

class PostBuilderGenerator extends GeneratorForAnnotation<Post> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return _generateCode('post', element, annotation);
  }
}

class PutBuilderGenerator extends GeneratorForAnnotation<Put> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return _generateCode('put', element, annotation);
  }
}

class DeleteBuilderGenerator extends GeneratorForAnnotation<Delete> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return _generateCode('delete', element, annotation);
  }
}
