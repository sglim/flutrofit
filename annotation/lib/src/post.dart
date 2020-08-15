class Post {
  final String path;
  final String req;
  final String res;
  // TODO(sglim): Add to ignore http error like 404

  const Post(this.path, {this.req, this.res}) : assert(path != null && req != null && res != null);
}
