class Put {
  final String path;
  final String req;
  final String res;
  // TODO(sglim): Add to ignore http error like 404

  const Put(this.path, {this.req = 'void', this.res = 'void'}) : assert(path != null && req != null && res != null);
}
