import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:myitihas/core/errors/failures.dart';

/// Base class for all use cases in the application
///
/// ReturnType: The return type of the use case
/// Params: The parameters required for the use case
abstract class UseCase<ReturnType, Params> {
  /// Executes the use case with the given parameters
  ///
  /// Returns [Either<Failure, ReturnType>] to handle errors gracefully
  Future<Either<Failure, ReturnType>> call(Params params);
}

/// Use case that doesn't require any parameters
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
