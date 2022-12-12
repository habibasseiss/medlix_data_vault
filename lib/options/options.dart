part of medlix_data_vault;

abstract class Options {
  const Options();

  Map<String, String> get params => toMap();

  @protected
  Map<String, String> toMap();
}
