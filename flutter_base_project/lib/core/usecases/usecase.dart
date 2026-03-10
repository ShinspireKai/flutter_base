import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Base abstract class cho tất cả Use Cases
/// Tuân thủ Interface Segregation & Single Responsibility Principle
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Dùng khi UseCase không cần params
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
