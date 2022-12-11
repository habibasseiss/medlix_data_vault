part of medlix_sso;

abstract class Options {
  const Options();

  Map<String, String> get params => toMap();

  @protected
  Map<String, String> toMap();
}
