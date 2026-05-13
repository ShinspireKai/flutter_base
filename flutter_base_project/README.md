# Flutter Base Project

> A production-ready Flutter base project applying **Clean Architecture**, **SOLID principles**, and **MVP pattern** — with BLoC as the primary state management solution.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [SOLID Principles](#solid-principles)
- [MVP Pattern](#mvp-pattern)
- [Project Structure](#project-structure)
- [Packages](#packages)
- [Getting Started](#getting-started)
- [Code Generation](#code-generation)
- [Routing](#routing)
- [State Management (BLoC)](#state-management-bloc)
- [MVP + BLoC Combined Pattern](#mvp--bloc-combined-pattern)
- [Dependency Injection](#dependency-injection)
- [Networking](#networking)
- [Local Storage](#local-storage)
- [Localization](#localization)
- [Asset Generation](#asset-generation)
- [Adding a New Feature](#adding-a-new-feature)

---

## Overview

This project serves as a scalable foundation for Flutter applications. It is designed with separation of concerns in mind — business logic, data handling, and UI are fully decoupled. The sample includes two complete working screens:

- **Login Page** — form validation, BLoC integration, error handling
- **Home Page** — profile display, pull-to-refresh, logout flow

**Demo credentials:** `test@example.com` / `password123`

---

## Architecture

The project follows **Clean Architecture** as defined by Robert C. Martin (Uncle Bob), organized into three concentric layers:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │  ← Pages, Widgets, BLoC
├─────────────────────────────────────┤
│           Domain Layer              │  ← Entities, Use Cases, Repository (abstract)
├─────────────────────────────────────┤
│            Data Layer               │  ← Models, DataSources, Repository (impl)
└─────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Contains | Depends On |
|---|---|---|
| **Presentation** | Pages, Widgets, BLoC/Cubit | Domain only |
| **Domain** | Entities, UseCases, Repository interfaces | Nothing (pure Dart) |
| **Data** | Models, Remote/Local DataSources, Repository implementations | Domain interfaces |

> The **Domain layer has zero external dependencies** — it is pure Dart and fully testable without Flutter or any package.

---

## SOLID Principles

| Principle | How it's applied |
|---|---|
| **S** — Single Responsibility | Each class has one job: `LoginBloc` handles login state only; `LoginForm` renders form only; `DioFactory` builds Dio only |
| **O** — Open/Closed | Add new `Event`/`State` subclasses without modifying existing handlers. Add new `Failure` types without touching base class |
| **L** — Liskov Substitution | `UserModel extends UserEntity` — usable anywhere `UserEntity` is expected |
| **I** — Interface Segregation | `AuthRemoteDataSource` and `AuthLocalDataSource` are separate interfaces; consumers only depend on what they need |
| **D** — Dependency Inversion | All BLoC classes depend on `UseCase` abstractions; all repositories depend on `DataSource` abstractions — never on concrete implementations |

---

## MVP Pattern

The project includes a complete MVP base layer for screens that require a traditional View-Presenter-Model separation.

```
lib/mvp/
├── IView.dart           ← View interface (showLoading, showToast, routePush...)
├── IPresenter.dart      ← Presenter interface (attachView, detachView)
├── IModel.dart          ← Model interface + HttpBase helper
├── BaseModel.dart       ← Abstract Model base
├── BasePresenter.dart   ← Generic Presenter<V extends IView, M extends BaseModel>
└── BaseView.dart        ← StatefulWidget + IView implementation
```

### How to create an MVP screen

**1. Define the View interface**
```dart
abstract class ILoginView extends IView {
  void navigateToHome();
}
```

**2. Create the Model**
```dart
class LoginModel extends BaseModel {
  Future<UserEntity> login(String email, String password) async {
    // call API or repository
  }
}
```

**3. Create the Presenter**
```dart
class LoginPresenter extends BasePresenter<ILoginView, LoginModel> {
  @override
  IModel createModel() => LoginModel();

  void doLogin(String email, String password) async {
    final result = await mvpModel.http.execute(
      () => mvpModel.login(email, password),
    );
    if (result != null) mvpView.navigateToHome();
  }
}
```

**4. Create the View (Page)**
```dart
class LoginPage extends BaseView {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseViewState<LoginPresenter, LoginPage>
    implements ILoginView {
  @override
  LoginPresenter createPresenter() => LoginPresenter();

  @override
  void navigateToHome() => routePushAndRemoveUntil(const HomePage());

  @override
  Widget buildView(BuildContext context) => Scaffold(...);
}
```

> **Note:** In this base project, the sample Login and Home screens use **BLoC** instead of MVP Presenter — to demonstrate BLoC integration. The MVP base classes are available for any screen that prefers that pattern.

---

## Project Structure

```
lib/
├── core/
│   ├── constans.dart              # App-wide constants (BASE_URL, timeouts...)
│   ├── di.dart                    # GetIt setup entry point
│   ├── di.config.dart             # Auto-generated DI config
│   ├── di/
│   │   └── features_di.dart       # Feature-level DI registrations
│   ├── error/
│   │   └── failures.dart          # Failure classes (Server, Network, Cache, Auth)
│   ├── gen/                       # Auto-generated (flutter_gen)
│   │   ├── assets.gen.dart
│   │   ├── colors.gen.dart
│   │   └── fonts.gen.dart
│   ├── l10n/                      # Localization ARB files + generated classes
│   ├── local/
│   │   ├── local_storage.dart     # LocalStorage interface + implementation
│   │   └── isar_service.dart      # Isar local database service
│   ├── network/
│   │   ├── api_service.dart       # HTTP client wrapper (GET/POST/PUT/PATCH/DELETE)
│   │   ├── dio_factory.dart       # Dio builder (auth interceptor, logging, timeout)
│   │   ├── error_handle.dart      # DioException → Failure mapper
│   │   ├── failure.dart           # HTTP Failure model
│   │   └── nnetword_infor.dart    # Network connectivity checker
│   ├── router/
│   │   ├── auto_route_config.dart # Route definitions
│   │   └── auto_route_config.gr.dart # Auto-generated route classes
│   └── usecases/
│       └── usecase.dart           # UseCase<T, P> base + NoParams
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart      ← abstract
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── check_login_status_usecase.dart
│   │   └── presentation/
│   │       ├── mvp/
│   │       │   ├── i_login_view.dart         # ILoginView contract
│   │       │   ├── login_model.dart          # LoginModel (BaseModel)
│   │       │   └── login_presenter.dart      # LoginPresenter (BasePresenter)
│   │       ├── bloc/
│   │       │   ├── login_bloc.dart
│   │       │   ├── login_event.dart
│   │       │   └── login_state.dart
│   │       ├── pages/
│   │       │   └── login_page.dart           # BaseView + BaseViewState
│   │       └── widgets/
│   │           └── login_form.dart
│   │
│   └── home/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── home_remote_datasource.dart
│       │   ├── models/
│       │   │   └── user_profile_model.dart
│       │   └── repositories/
│       │       └── home_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_profile_entity.dart
│       │   ├── repositories/
│       │   │   └── home_repository.dart      ← abstract
│       │   └── usecases/
│       │       └── get_user_profile_usecase.dart
│       └── presentation/
│           ├── mvp/
│           │   ├── i_home_view.dart          # IHomeView contract
│           │   ├── home_model.dart           # HomeModel (BaseModel)
│           │   └── home_presenter.dart       # HomePresenter (BasePresenter)
│           ├── bloc/
│           │   ├── home_bloc.dart
│           │   ├── home_event.dart
│           │   └── home_state.dart
│           ├── pages/
│           │   └── home_page.dart            # BaseView + BaseViewState
│           └── widgets/
│               └── profile_card.dart
│
├── mvp/
│   ├── IView.dart
│   ├── IPresenter.dart
│   ├── IModel.dart
│   ├── BaseModel.dart
│   ├── BasePresenter.dart
│   └── BaseView.dart
│
├── view/
│   ├── res/
│   │   ├── theme_manager.dart
│   │   ├── font_manager.dart
│   │   └── responsive/
│   └── widgets/              # Shared reusable widgets
│
└── main.dart                 # App entry point + BlocProvider setup
```

---

## Packages

### Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^8.1.6 | State management (BLoC pattern) |
| `equatable` | ^2.0.5 | Value equality for States/Events/Entities |
| `dartz` | ^0.10.1 | Functional types (`Either<Failure, T>`) |
| `get_it` | ^7.7.0 | Service locator for dependency injection |
| `injectable` | ^2.4.4 | Code-gen annotations for GetIt |
| `dio` | ^5.5.0+1 | HTTP client |
| `pretty_dio_logger` | ^1.4.0 | HTTP request/response logging |
| `auto_route` | ^9.2.2 | Type-safe declarative routing |
| `shared_preferences` | ^2.3.2 | Key-value local storage |
| `flutter_secure_storage` | ^4.2.1 | Encrypted storage for tokens |
| `isar` | ^3.1.0+1 | High-performance local database |
| `cached_network_image` | ^3.4.0 | Image caching from network |
| `flutter_svg` | ^2.0.10+1 | SVG rendering |
| `flutter_easyloading` | ^3.0.5 | Global loading overlay |
| `fluttertoast` | ^9.0.0 | Toast notifications |
| `internet_connection_checker` | ^1.0.0+1 | Network connectivity |
| `intl` | any | Internationalization |
| `flutter_localizations` | sdk | Flutter localization support |

### Dev Dependencies

| Package | Purpose |
|---|---|
| `build_runner` | Code generation runner |
| `auto_route_generator` | Route class generation |
| `injectable_generator` | DI config generation |
| `flutter_gen_runner` | Asset/color/font class generation |
| `json_serializable` | JSON serialization code-gen |
| `flutter_lints` | Dart linting rules |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.4.4`
- Dart SDK `>=3.4.4 <4.0.0`

### 1. Clone & install

```bash
git clone <repo-url>
cd flutter_base_project
flutter pub get
```

### 2. Run code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the app

```bash
flutter run
```

---

## Code Generation

This project uses `build_runner` to generate boilerplate for routes, DI, and assets. Run after any changes to annotated files:

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto rebuild on save)
dart run build_runner watch --delete-conflicting-outputs
```

Files that trigger regeneration:

| Change | File to watch | Generated output |
|---|---|---|
| Add/remove `@RoutePage()` | `*_page.dart` | `auto_route_config.gr.dart` |
| Add/remove `@injectable` | Any DI-annotated class | `di.config.dart` |
| Add assets/colors/fonts | `pubspec.yaml`, `assets/colors/colors.xml` | `lib/core/gen/*.gen.dart` |

---

## Routing

Routes are defined in `lib/core/router/auto_route_config.dart` using `auto_route`:

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MainAppRoute.page, initial: true), // Splash + auth check
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: HomeRoute.page),
  ];
}
```

### Adding a new route

1. Annotate your page with `@RoutePage()`:
```dart
@RoutePage()
class ProfilePage extends StatelessWidget { ... }
```

2. Add it to `AppRouter.routes`:
```dart
AutoRoute(page: ProfileRoute.page),
```

3. Regenerate:
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Navigate:
```dart
context.router.push(const ProfileRoute());
// or by name
context.router.pushNamed('/profile');
```

---

## State Management (BLoC)

Each feature has its own isolated BLoC. The pattern is:

```
Event  →  BLoC  →  State
```

### Files per feature

```
presentation/bloc/
├── feature_event.dart   # Abstract event + concrete subclasses
├── feature_state.dart   # Abstract state + concrete subclasses
└── feature_bloc.dart    # Bloc<Event, State> with handlers
```

### Example — Login flow

```dart
// 1. Dispatch event from UI
context.read<LoginBloc>().add(
  LoginSubmitted(email: email, password: password),
);

// 2. BLoC processes it
Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter emit) async {
  emit(const LoginLoading());
  final result = await _loginUseCase(LoginParams(...));
  result.fold(
    (failure) => emit(LoginFailure(errorMessage: failure.message)),
    (user)    => emit(LoginSuccess(user: user)),
  );
}

// 3. UI reacts via BlocListener + BlocBuilder
BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) context.router.replaceNamed('/home');
    if (state is LoginFailure) showSnackBar(state.errorMessage);
  },
  child: BlocBuilder<LoginBloc, LoginState>(
    builder: (context, state) {
      if (state is LoginLoading) return CircularProgressIndicator();
      return LoginForm();
    },
  ),
)
```

### BLoC registration

BLoCs are provided via `MultiBlocProvider` in `main.dart`:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => LoginBloc(loginUseCase: sl())),
    BlocProvider(create: (_) => HomeBloc(
      getUserProfileUseCase: sl(),
      logoutUseCase: sl(),
    )..add(const HomeLoadUserProfile())),
  ],
  child: MaterialApp.router(...),
)
```

---

## Dependency Injection

DI is powered by `get_it` + `injectable`. The service locator is accessed via `sl<T>()`.

### Registration

**Core services** (auto-scanned via `@lazySingleton`, `@singleton` annotations):
```bash
dart run build_runner build  # → generates lib/core/di.config.dart
```

**Feature services** (manually registered in `lib/core/di/features_di.dart`):
```dart
// Data Sources
sl.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(),
);

// Repository — inject abstractions
sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ),
);

// Use Cases — registerFactory for fresh instances per BLoC
sl.registerFactory(() => LoginUseCase(sl()));
```

### Resolving

```dart
// In main.dart / BlocProvider
BlocProvider(
  create: (_) => LoginBloc(loginUseCase: sl<LoginUseCase>()),
)
```

---

## Networking

`DioFactory` builds the Dio client with:

- ✅ `baseUrl` from `Constants.BASE_URL`
- ✅ 30s connect/receive/send timeout
- ✅ Auto Bearer token injection from `SharedPreferences`
- ✅ 401 → auto clear token
- ✅ `PrettyDioLogger` (debug only)

### Making an API call

Use `ApiService` injected via DI:

```dart
// In a DataSource implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final response = await _apiService.post(
      endPoint: 'auth/login',
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data['data']);
  }
}
```

### Error handling

Errors are mapped through `ErrorHandler` → `Failure`:

```dart
try {
  final user = await _remote.login(email: email, password: password);
  return Right(user);
} on DioException catch (e) {
  final failure = ErrorHandler.handle(e).failure;
  return Left(ServerFailure(message: failure.message));
} on Exception catch (e) {
  return Left(AuthFailure(message: e.toString()));
}
```

---

## Local Storage

Two storage layers are available:

| Storage | Class | Use case |
|---|---|---|
| `SharedPreferences` | `LocalStorageImpl` | Non-sensitive data (language, userId, flags) |
| `FlutterSecureStorage` | `LocalStorageImpl` | Sensitive data (access token, refresh token) |
| `Isar` | `IsarService` | Complex local data (offline-first features) |

### Usage via `LocalStorage` interface

```dart
// Inject
final LocalStorage _storage;

// Save token after login
await _storage.saveAccessToken(user.token);

// Check login status
bool loggedIn = _storage.isLoggedIn;

// Clear on logout
await _storage.clearAuthData();
```

---

## Localization

Supports **Vietnamese (vi)**, **English (en)**, and **Chinese (zh)**.

### ARB files location

```
lib/core/l10n/
├── app_vi.arb   ← Vietnamese (primary)
├── app_en.arb   ← English
└── app_zh.arb   ← Chinese
```

### Adding a new string

1. Add key to all `.arb` files:
```json
// app_vi.arb
{ "welcomeMessage": "Chào mừng!" }

// app_en.arb
{ "welcomeMessage": "Welcome!" }
```

2. Run `flutter gen-l10n` (or `flutter pub get`) to regenerate.

3. Use in code:
```dart
Text(AppLocalizations.of(context)!.welcomeMessage)
```

---

## Asset Generation

Assets are auto-generated via `flutter_gen`. After adding files to `assets/`, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Using generated assets

```dart
// Images
Image.asset(Assets.images.logo.path)

// SVG
Assets.images.iconBack.svg(width: 24)

// Fonts
TextStyle(fontFamily: FontFamily.dMSans)

// Colors (from assets/colors/colors.xml)
Color myColor = ColorName.primary;
```

---

## MVP + BLoC Combined Pattern

Login và Home page trong project này áp dụng **kết hợp MVP + BLoC** — đây là pattern chính của base:

```
FeaturePage (BaseView)
  └── _FeaturePageState (BaseViewState) implements IFeatureView
        ├── FeaturePresenter (BasePresenter)   ← navigation, dialog, side-effects
        └── FeatureBloc (từ context)            ← data state, API calls
```

### Cấu trúc thư mục

```
features/your_feature/presentation/
├── mvp/
│   ├── i_feature_view.dart      # View contract (extends IView)
│   ├── feature_model.dart       # Model (extends BaseModel)
│   └── feature_presenter.dart   # Presenter (extends BasePresenter)
├── bloc/
│   ├── feature_bloc.dart
│   ├── feature_event.dart
│   └── feature_state.dart
├── pages/
│   └── feature_page.dart        # BaseView + BaseViewState implements IFeatureView
└── widgets/
```

### Phân công trách nhiệm

| Nhiệm vụ | Presenter | BLoC |
|---|---|---|
| Navigate sang page khác | ✅ | ❌ |
| Hiện dialog xác nhận | ✅ | ❌ |
| Hiện snackbar / toast | ✅ | ❌ |
| Gọi API / UseCase | ❌ | ✅ |
| Quản lý loading state | ❌ | ✅ |
| Quản lý data (entities) | ❌ | ✅ |

### Quy tắc quan trọng

> **View chỉ được giao tiếp qua `presenter?.method()`** — không gọi BLoC trực tiếp từ View, ngoại trừ bên trong `BlocListener` / `BlocBuilder`.

### Ví dụ — Presenter điều phối BLoC state

```dart
// Trong buildView() của Page:
BlocListener<FeatureBloc, FeatureState>(
  listener: (ctx, state) {
    if (state is FeatureSuccess) presenter?.onSuccess();
    if (state is FeatureError)   presenter?.onError(state.message);
  },
  child: ...,
)

// Presenter xử lý side-effect:
void onSuccess() => mvpView.navigateToNext();
void onError(String msg) => mvpView.showErrorSnackbar(msg);

// View chỉ forward action lên Presenter:
ElevatedButton(
  onPressed: () => presenter?.onSubmitPressed(context.read<FeatureBloc>()),
)
```

### Tạo MVP layer cho feature mới

**1. IFeatureView** — khai báo contract
```dart
abstract class IFeatureView extends IView {
  void navigateToNext();
  void showErrorSnackbar(String message);
}
```

**2. FeatureModel** — UI state nhỏ
```dart
class FeatureModel extends BaseModel {
  int selectedTab = 0;
}
```

**3. FeaturePresenter** — coordinator
```dart
class FeaturePresenter extends BasePresenter<IFeatureView, FeatureModel> {
  @override
  IModel createModel() => FeatureModel();

  void onSubmitPressed(FeatureBloc bloc) {
    bloc.add(const FeatureSubmitted());
  }

  void onSuccess() => mvpView.navigateToNext();
  void onError(String msg) => mvpView.showErrorSnackbar(msg);
}
```

**4. FeaturePage** — BaseView
```dart
@RoutePage()
class FeaturePage extends BaseView {
  const FeaturePage({super.key});
  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState
    extends BaseViewState<FeaturePresenter, FeaturePage>
    implements IFeatureView {

  @override
  FeaturePresenter createPresenter() => FeaturePresenter();

  @override
  void afterInit() {
    presenter?.loadData(context.read<FeatureBloc>());
  }

  // IFeatureView
  @override
  void navigateToNext() => context.router.pushNamed('/next');

  @override
  void showErrorSnackbar(String msg) { /* show snackbar */ }

  @override
  Widget buildView(BuildContext context) => Scaffold(...);
}
```

---

## Adding a New Feature

Follow this checklist when adding a new feature (e.g., `profile`):

```
lib/features/profile/
├── domain/
│   ├── entities/profile_entity.dart          # 1. Pure Dart entity
│   ├── repositories/profile_repository.dart  # 2. Abstract repository
│   └── usecases/get_profile_usecase.dart      # 3. UseCase(s)
├── data/
│   ├── models/profile_model.dart              # 4. Model (extends entity)
│   ├── datasources/profile_remote_datasource.dart  # 5. DataSource interface + impl
│   └── repositories/profile_repository_impl.dart   # 6. Repository implementation
└── presentation/
    ├── bloc/
    │   ├── profile_event.dart                 # 7. Events
    │   ├── profile_state.dart                 # 8. States
    │   └── profile_bloc.dart                  # 9. BLoC
    ├── pages/profile_page.dart                # 10. Page (@RoutePage)
    └── widgets/                               # 11. Sub-widgets
```

**Then:**
1. Register in `lib/core/di/features_di.dart`
2. Add `BlocProvider` in `main.dart`
3. Add route in `auto_route_config.dart`
4. Run `dart run build_runner build --delete-conflicting-outputs`

---

## License

MIT License. Free to use as a base template for your Flutter projects.
