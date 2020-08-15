/// Delete rest api
///
/// Delete doesn't have any request commonly.
class Delete {
  final String path;
  final String res;
  // TODO(sglim): Add to ignore http error like 404

  const Delete(this.path, {this.res = 'void'})
      : assert(path != null && res != null);
}
