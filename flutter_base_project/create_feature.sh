#!/usr/bin/env bash
#
# create_feature.sh — scaffold a new feature following this project's
# Clean Architecture (data/domain/presentation) + BLoC + MVP convention,
# modeled after lib/features/inspector_home.
#
# Usage:
#   ./create_feature.sh <feature_snake_case> [EntityPascalCase]
#
# Examples:
#   ./create_feature.sh notification_center
#   ./create_feature.sh notification_center Notification
#
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Args & validation
# ─────────────────────────────────────────────────────────────────────────────

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: $0 <feature_snake_case> [EntityPascalCase]"
  echo "  feature_snake_case   e.g. notification_center"
  echo "  EntityPascalCase     optional, defaults to the feature name in PascalCase"
  exit 1
fi

FEATURE_SNAKE="$1"

if [[ ! "$FEATURE_SNAKE" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "Error: feature name must be snake_case (lowercase letters, digits, underscores), e.g. notification_center" >&2
  exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FEATURE_DIR="$PROJECT_ROOT/lib/features/$FEATURE_SNAKE"

if [[ -e "$FEATURE_DIR" ]]; then
  echo "Error: $FEATURE_DIR already exists. Choose another name or remove it first." >&2
  exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# Case conversion helpers
# ─────────────────────────────────────────────────────────────────────────────

snake_to_pascal() {
  local input="$1" result="" part
  IFS='_' read -ra parts <<< "$input"
  for part in "${parts[@]}"; do
    result+="$(tr '[:lower:]' '[:upper:]' <<< "${part:0:1}")${part:1}"
  done
  echo "$result"
}

pascal_to_camel() {
  local input="$1"
  echo "$(tr '[:upper:]' '[:lower:]' <<< "${input:0:1}")${input:1}"
}

pascal_to_snake() {
  local input="$1"
  echo "$input" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]'
}

FEATURE_PASCAL="$(snake_to_pascal "$FEATURE_SNAKE")"
FEATURE_CAMEL="$(pascal_to_camel "$FEATURE_PASCAL")"

if [[ $# -ge 2 ]]; then
  ENTITY_PASCAL="$2"
else
  ENTITY_PASCAL="$FEATURE_PASCAL"
fi
ENTITY_SNAKE="$(pascal_to_snake "$ENTITY_PASCAL")"
ENTITY_CAMEL="$(pascal_to_camel "$ENTITY_PASCAL")"

echo "Scaffolding feature '$FEATURE_SNAKE' (entity: $ENTITY_PASCAL) at lib/features/$FEATURE_SNAKE ..."

# ─────────────────────────────────────────────────────────────────────────────
# Directories
# ─────────────────────────────────────────────────────────────────────────────

mkdir -p \
  "$FEATURE_DIR/data/datasources" \
  "$FEATURE_DIR/data/models" \
  "$FEATURE_DIR/data/repositories" \
  "$FEATURE_DIR/domain/entities" \
  "$FEATURE_DIR/domain/repositories" \
  "$FEATURE_DIR/domain/usecases" \
  "$FEATURE_DIR/presentation/bloc" \
  "$FEATURE_DIR/presentation/mvp" \
  "$FEATURE_DIR/presentation/pages" \
  "$FEATURE_DIR/presentation/widgets"

# render <output_path_with_@TOKEN@_placeholders> <<'EOF' ... EOF
# Substitutes @TOKEN@ placeholders in both the path itself (so filenames are
# derived automatically) and in the heredoc body, then writes the result.
render() {
  local template_path="$1"
  local out
  out="$(sed \
    -e "s|@FEATURE_PASCAL@|$FEATURE_PASCAL|g" \
    -e "s|@FEATURE_CAMEL@|$FEATURE_CAMEL|g" \
    -e "s|@FEATURE_SNAKE@|$FEATURE_SNAKE|g" \
    -e "s|@ENTITY_PASCAL@|$ENTITY_PASCAL|g" \
    -e "s|@ENTITY_CAMEL@|$ENTITY_CAMEL|g" \
    -e "s|@ENTITY_SNAKE@|$ENTITY_SNAKE|g" \
    <<< "$template_path")"

  cat > "$out"
  sed -i.bak \
    -e "s|@FEATURE_PASCAL@|$FEATURE_PASCAL|g" \
    -e "s|@FEATURE_CAMEL@|$FEATURE_CAMEL|g" \
    -e "s|@FEATURE_SNAKE@|$FEATURE_SNAKE|g" \
    -e "s|@ENTITY_PASCAL@|$ENTITY_PASCAL|g" \
    -e "s|@ENTITY_CAMEL@|$ENTITY_CAMEL|g" \
    -e "s|@ENTITY_SNAKE@|$ENTITY_SNAKE|g" \
    "$out"
  rm -f "$out.bak"
}

# ─────────────────────────────────────────────────────────────────────────────
# domain/entities
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/domain/entities/@ENTITY_SNAKE@_entity.dart" <<'EOF'
import 'package:equatable/equatable.dart';

/// @ENTITY_PASCAL@Entity — pure domain object cho feature @FEATURE_PASCAL@
class @ENTITY_PASCAL@Entity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime? createdAt;

  const @ENTITY_PASCAL@Entity({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, createdAt];
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# domain/repositories
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/domain/repositories/@FEATURE_SNAKE@_repository.dart" <<'EOF'
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/@ENTITY_SNAKE@_entity.dart';

/// Abstract repository cho @FEATURE_PASCAL@ feature
abstract class @FEATURE_PASCAL@Repository {
  Future<Either<Failure, List<@ENTITY_PASCAL@Entity>>> get@ENTITY_PASCAL@List();
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# domain/usecases
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/domain/usecases/get_@ENTITY_SNAKE@_list_usecase.dart" <<'EOF'
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/@ENTITY_SNAKE@_entity.dart';
import '../repositories/@FEATURE_SNAKE@_repository.dart';

/// UseCase lấy danh sách @ENTITY_PASCAL@ cho feature @FEATURE_PASCAL@
class Get@ENTITY_PASCAL@ListUseCase
    extends UseCase<List<@ENTITY_PASCAL@Entity>, NoParams> {
  final @FEATURE_PASCAL@Repository _repository;

  Get@ENTITY_PASCAL@ListUseCase(this._repository);

  @override
  Future<Either<Failure, List<@ENTITY_PASCAL@Entity>>> call(NoParams params) {
    return _repository.get@ENTITY_PASCAL@List();
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# data/models
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/data/models/@ENTITY_SNAKE@_model.dart" <<'EOF'
import '../../domain/entities/@ENTITY_SNAKE@_entity.dart';

/// @ENTITY_PASCAL@Model — data layer model, extends @ENTITY_PASCAL@Entity
class @ENTITY_PASCAL@Model extends @ENTITY_PASCAL@Entity {
  const @ENTITY_PASCAL@Model({
    required super.id,
    required super.name,
    super.description,
    super.createdAt,
  });

  factory @ENTITY_PASCAL@Model.fromJson(Map<String, dynamic> json) {
    return @ENTITY_PASCAL@Model(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# data/datasources
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/data/datasources/@FEATURE_SNAKE@_remote_datasource.dart" <<'EOF'
import '../models/@ENTITY_SNAKE@_model.dart';

/// Abstract interface cho @FEATURE_PASCAL@ remote data source
abstract class @FEATURE_PASCAL@RemoteDataSource {
  Future<List<@ENTITY_PASCAL@Model>> get@ENTITY_PASCAL@List();
}

/// Mock implementation — thay bằng gọi API thật (DioBase) khi có backend
class @FEATURE_PASCAL@RemoteDataSourceImpl implements @FEATURE_PASCAL@RemoteDataSource {
  @override
  Future<List<@ENTITY_PASCAL@Model>> get@ENTITY_PASCAL@List() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      @ENTITY_PASCAL@Model(
        id: '@ENTITY_CAMEL@_001',
        name: '@ENTITY_PASCAL@ 1',
        description: 'Mock @ENTITY_CAMEL@ #1',
        createdAt: DateTime(2026, 1, 1),
      ),
      @ENTITY_PASCAL@Model(
        id: '@ENTITY_CAMEL@_002',
        name: '@ENTITY_PASCAL@ 2',
        description: 'Mock @ENTITY_CAMEL@ #2',
        createdAt: DateTime(2026, 1, 2),
      ),
    ];
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# data/repositories
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/data/repositories/@FEATURE_SNAKE@_repository_impl.dart" <<'EOF'
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/@ENTITY_SNAKE@_entity.dart';
import '../../domain/repositories/@FEATURE_SNAKE@_repository.dart';
import '../datasources/@FEATURE_SNAKE@_remote_datasource.dart';

/// Concrete implementation của @FEATURE_PASCAL@Repository
class @FEATURE_PASCAL@RepositoryImpl implements @FEATURE_PASCAL@Repository {
  final @FEATURE_PASCAL@RemoteDataSource _remoteDataSource;

  @FEATURE_PASCAL@RepositoryImpl({
    required @FEATURE_PASCAL@RemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<@ENTITY_PASCAL@Entity>>> get@ENTITY_PASCAL@List() async {
    try {
      final list = await _remoteDataSource.get@ENTITY_PASCAL@List();
      return Right(list);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# presentation/bloc
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/presentation/bloc/@FEATURE_SNAKE@_event.dart" <<'EOF'
import 'package:equatable/equatable.dart';

/// @FEATURE_PASCAL@ Events
abstract class @FEATURE_PASCAL@Event extends Equatable {
  const @FEATURE_PASCAL@Event();

  @override
  List<Object?> get props => [];
}

/// Load lần đầu khi vào trang
class @FEATURE_PASCAL@LoadRequested extends @FEATURE_PASCAL@Event {
  const @FEATURE_PASCAL@LoadRequested();
}

/// Pull-to-refresh
class @FEATURE_PASCAL@Refreshed extends @FEATURE_PASCAL@Event {
  const @FEATURE_PASCAL@Refreshed();
}
EOF

render "$FEATURE_DIR/presentation/bloc/@FEATURE_SNAKE@_state.dart" <<'EOF'
import 'package:equatable/equatable.dart';

import '../../domain/entities/@ENTITY_SNAKE@_entity.dart';

/// @FEATURE_PASCAL@ States
abstract class @FEATURE_PASCAL@State extends Equatable {
  const @FEATURE_PASCAL@State();

  @override
  List<Object?> get props => [];
}

class @FEATURE_PASCAL@Initial extends @FEATURE_PASCAL@State {
  const @FEATURE_PASCAL@Initial();
}

class @FEATURE_PASCAL@Loading extends @FEATURE_PASCAL@State {
  const @FEATURE_PASCAL@Loading();
}

class @FEATURE_PASCAL@Loaded extends @FEATURE_PASCAL@State {
  final List<@ENTITY_PASCAL@Entity> items;
  final bool isRefreshing;

  const @FEATURE_PASCAL@Loaded({required this.items, this.isRefreshing = false});

  @FEATURE_PASCAL@Loaded copyWith({
    List<@ENTITY_PASCAL@Entity>? items,
    bool? isRefreshing,
  }) {
    return @FEATURE_PASCAL@Loaded(
      items: items ?? this.items,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [items, isRefreshing];
}

class @FEATURE_PASCAL@Error extends @FEATURE_PASCAL@State {
  final String message;

  const @FEATURE_PASCAL@Error({required this.message});

  @override
  List<Object?> get props => [message];
}
EOF

render "$FEATURE_DIR/presentation/bloc/@FEATURE_SNAKE@_bloc.dart" <<'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_@ENTITY_SNAKE@_list_usecase.dart';
import '@FEATURE_SNAKE@_event.dart';
import '@FEATURE_SNAKE@_state.dart';

/// @FEATURE_PASCAL@Bloc — quản lý state cho feature @FEATURE_PASCAL@
///
/// Events → States:
///   @FEATURE_PASCAL@LoadRequested → @FEATURE_PASCAL@Loading → @FEATURE_PASCAL@Loaded | @FEATURE_PASCAL@Error
///   @FEATURE_PASCAL@Refreshed     → @FEATURE_PASCAL@Loaded(isRefreshing: true) → @FEATURE_PASCAL@Loaded
class @FEATURE_PASCAL@Bloc extends Bloc<@FEATURE_PASCAL@Event, @FEATURE_PASCAL@State> {
  final Get@ENTITY_PASCAL@ListUseCase _get@ENTITY_PASCAL@ListUseCase;

  @FEATURE_PASCAL@Bloc({
    required Get@ENTITY_PASCAL@ListUseCase get@ENTITY_PASCAL@ListUseCase,
  })  : _get@ENTITY_PASCAL@ListUseCase = get@ENTITY_PASCAL@ListUseCase,
        super(const @FEATURE_PASCAL@Initial()) {
    on<@FEATURE_PASCAL@LoadRequested>(_onLoadRequested);
    on<@FEATURE_PASCAL@Refreshed>(_onRefreshed);
  }

  Future<void> _onLoadRequested(
    @FEATURE_PASCAL@LoadRequested event,
    Emitter<@FEATURE_PASCAL@State> emit,
  ) async {
    emit(const @FEATURE_PASCAL@Loading());
    final result = await _get@ENTITY_PASCAL@ListUseCase(NoParams());
    result.fold(
      (failure) => emit(@FEATURE_PASCAL@Error(message: failure.message)),
      (items) => emit(@FEATURE_PASCAL@Loaded(items: items)),
    );
  }

  Future<void> _onRefreshed(
    @FEATURE_PASCAL@Refreshed event,
    Emitter<@FEATURE_PASCAL@State> emit,
  ) async {
    if (state is @FEATURE_PASCAL@Loaded) {
      emit((state as @FEATURE_PASCAL@Loaded).copyWith(isRefreshing: true));
    }
    final result = await _get@ENTITY_PASCAL@ListUseCase(NoParams());
    result.fold(
      (failure) => emit(@FEATURE_PASCAL@Error(message: failure.message)),
      (items) => emit(@FEATURE_PASCAL@Loaded(items: items)),
    );
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# presentation/mvp
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/presentation/mvp/i_@FEATURE_SNAKE@_view.dart" <<'EOF'
import '../../../../mvp/IView.dart';

/// I@FEATURE_PASCAL@View — View contract cho @FEATURE_PASCAL@ screen
///
/// Interface Segregation: chỉ khai báo method Presenter cần để điều khiển View.
abstract class I@FEATURE_PASCAL@View extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);
}
EOF

render "$FEATURE_DIR/presentation/mvp/@FEATURE_SNAKE@_model.dart" <<'EOF'
import '../../../../mvp/BaseModel.dart';

/// @FEATURE_PASCAL@Model — tầng Model của MVP cho @FEATURE_PASCAL@
///
/// Single Responsibility: chỉ chứa data/state cần thiết cho presentation.
/// Business logic thực sự nằm ở UseCase (domain layer).
class @FEATURE_PASCAL@Model extends BaseModel {}
EOF

render "$FEATURE_DIR/presentation/mvp/@FEATURE_SNAKE@_presenter.dart" <<'EOF'
import '../../../../mvp/BasePresenter.dart';
import '../../../../mvp/IModel.dart';
import 'i_@FEATURE_SNAKE@_view.dart';
import '@FEATURE_SNAKE@_model.dart';

/// @FEATURE_PASCAL@Presenter — điều phối navigation & side-effects cho @FEATURE_PASCAL@
///
/// SOLID:
/// - S: Chỉ điều phối giữa View và BLoC, không chứa business logic
/// - D: Phụ thuộc vào I@FEATURE_PASCAL@View (abstraction), không phụ thuộc Page cụ thể
class @FEATURE_PASCAL@Presenter extends BasePresenter<I@FEATURE_PASCAL@View, @FEATURE_PASCAL@Model> {
  @override
  IModel createModel() => @FEATURE_PASCAL@Model();

  /// Gọi khi BLoC emit lỗi — Presenter ra lệnh View hiện thông báo
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# presentation/widgets
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/presentation/widgets/@ENTITY_SNAKE@_list_tile.dart" <<'EOF'
import 'package:flutter/material.dart';

import '../../domain/entities/@ENTITY_SNAKE@_entity.dart';

/// @ENTITY_PASCAL@ListTile — hiển thị 1 item @ENTITY_PASCAL@Entity trong danh sách
class @ENTITY_PASCAL@ListTile extends StatelessWidget {
  final @ENTITY_PASCAL@Entity @ENTITY_CAMEL@;
  final VoidCallback? onTap;

  const @ENTITY_PASCAL@ListTile({super.key, required this.@ENTITY_CAMEL@, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(@ENTITY_CAMEL@.name),
      subtitle: @ENTITY_CAMEL@.description != null ? Text(@ENTITY_CAMEL@.description!) : null,
      onTap: onTap,
    );
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# presentation/pages
# ─────────────────────────────────────────────────────────────────────────────

render "$FEATURE_DIR/presentation/pages/@FEATURE_SNAKE@_page.dart" <<'EOF'
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../mvp/BaseView.dart';
import '../bloc/@FEATURE_SNAKE@_bloc.dart';
import '../bloc/@FEATURE_SNAKE@_event.dart';
import '../bloc/@FEATURE_SNAKE@_state.dart';
import '../mvp/i_@FEATURE_SNAKE@_view.dart';
import '../mvp/@FEATURE_SNAKE@_presenter.dart';
import '../widgets/@ENTITY_SNAKE@_list_tile.dart';

// ─────────────────────────────────────────────────────────────────────────────
// @FEATURE_PASCAL@Page — BaseView (MVP View)
//
//   @FEATURE_PASCAL@Page (BaseView)
//     └── _@FEATURE_PASCAL@PageState (BaseViewState) implements I@FEATURE_PASCAL@View
//           ├── @FEATURE_PASCAL@Presenter (BasePresenter) → navigation & side-effects
//           └── @FEATURE_PASCAL@Bloc (từ context) → form/list state
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class @FEATURE_PASCAL@Page extends BaseView {
  const @FEATURE_PASCAL@Page({super.key});

  @override
  State<@FEATURE_PASCAL@Page> createState() => _@FEATURE_PASCAL@PageState();
}

class _@FEATURE_PASCAL@PageState extends BaseViewState<@FEATURE_PASCAL@Presenter, @FEATURE_PASCAL@Page>
    implements I@FEATURE_PASCAL@View {
  @override
  @FEATURE_PASCAL@Presenter createPresenter() => @FEATURE_PASCAL@Presenter();

  @override
  void afterInit() {
    context.read<@FEATURE_PASCAL@Bloc>().add(const @FEATURE_PASCAL@LoadRequested());
  }

  @override
  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('@FEATURE_PASCAL@')),
      body: BlocConsumer<@FEATURE_PASCAL@Bloc, @FEATURE_PASCAL@State>(
        listener: (ctx, state) {
          if (state is @FEATURE_PASCAL@Error) {
            presenter?.onError(state.message);
          }
        },
        builder: (ctx, state) {
          if (state is @FEATURE_PASCAL@Loading || state is @FEATURE_PASCAL@Initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is @FEATURE_PASCAL@Error) {
            return Center(child: Text(state.message));
          }
          final items = (state as @FEATURE_PASCAL@Loaded).items;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<@FEATURE_PASCAL@Bloc>().add(const @FEATURE_PASCAL@Refreshed());
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, index) => @ENTITY_PASCAL@ListTile(@ENTITY_CAMEL@: items[index]),
            ),
          );
        },
      ),
    );
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# Done — print manual wiring steps
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo "Created lib/features/$FEATURE_SNAKE:"
find "$FEATURE_DIR" -type f | sed "s|$PROJECT_ROOT/|  |" | sort

cat <<STEPS

Next steps (manual wiring — not automated by this script):

1) Register DI in lib/core/di/features_di.dart:

  sl.registerLazySingleton<${FEATURE_PASCAL}RemoteDataSource>(
    () => ${FEATURE_PASCAL}RemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<${FEATURE_PASCAL}Repository>(
    () => ${FEATURE_PASCAL}RepositoryImpl(remoteDataSource: sl<${FEATURE_PASCAL}RemoteDataSource>()),
  );
  sl.registerFactory(() => Get${ENTITY_PASCAL}ListUseCase(sl<${FEATURE_PASCAL}Repository>()));

  Also add the matching imports for these classes.

2) Register the route in lib/core/router/app_router.dart:

  AutoRoute(page: ${FEATURE_PASCAL}Route.page),

3) Provide ${FEATURE_PASCAL}Bloc where the page is pushed, e.g.:

  BlocProvider(
    create: (_) => sl<${FEATURE_PASCAL}Bloc>()..add(const ${FEATURE_PASCAL}LoadRequested()),
    child: const ${FEATURE_PASCAL}Page(),
  )

  (register ${FEATURE_PASCAL}Bloc as a factory in features_di.dart too)

4) Regenerate routing code:

  flutter pub run build_runner build --delete-conflicting-outputs

STEPS
