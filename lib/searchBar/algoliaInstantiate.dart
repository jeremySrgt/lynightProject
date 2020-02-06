import 'package:algolia/algolia.dart';

//doit etre instantiée une seule fois dans le projet
class AlgoliaInstance {
  static final Algolia algolia = Algolia.init(
    applicationId: 'OP8EZVD8YH',
    apiKey: '30be1d6a6751f65407e55575dce1bd1b',
  );
}