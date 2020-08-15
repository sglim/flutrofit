/// Get rest api
///
/// Get doesn't have any request.
class Get {
  final String path;
  final String res;
  // TODO(sglim): Add to ignore http error like 404

  const Get(this.path, {this.res}) : assert(path != null && res != null);
}
