sealed class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error de almacenamiento local']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Datos no válidos']);
}
