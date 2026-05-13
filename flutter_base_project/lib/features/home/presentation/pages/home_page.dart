import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../mvp/BaseView.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/profile_card.dart';
import '../mvp/home_presenter.dart';
import '../mvp/i_home_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomePage — BaseView (MVP View)
// ─────────────────────────────────────────────────────────────────────────────
//
// Kiến trúc kết hợp MVP + BLoC:
//
//   HomePage (BaseView)
//     └── _HomePageState (BaseViewState) implements IHomeView
//           ├── HomePresenter (BasePresenter)
//           │     └── điều phối navigation, dialog, side-effects
//           └── HomeBloc (từ context)
//                 └── quản lý data state (loading / loaded / error / logout)
//
// Phân công rõ ràng:
//   • Presenter → NAVIGATION, dialog confirm, snackbar
//   • BLoC      → DATA STATE (loading, profile data, error message)
//   • View      → chỉ render UI và forward action lên Presenter
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class HomePage extends BaseView {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseViewState<HomePresenter, HomePage>
    implements IHomeView {
  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  HomePresenter createPresenter() => HomePresenter();

  /// Load profile ngay sau frame đầu tiên
  @override
  void afterInit() {
    presenter?.loadProfile(context.read<HomeBloc>());
  }

  // ─── IHomeView implementation ─────────────────────────────────────────────

  @override
  void navigateToLogin() {
    context.router.replaceNamed('/login');
  }

  @override
  void showLogoutConfirmDialog({required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 24),
            const SizedBox(width: 10),
            const Text('Đăng xuất'),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất không?\nBạn sẽ cần đăng nhập lại để sử dụng app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Hủy',
              style: TextStyle(color: Theme.of(context).primaryColorDark),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  @override
  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (ctx, state) {
        // Presenter là coordinator — ra lệnh cho View dựa trên BLoC state
        if (state is HomeLoggedOut) {
          presenter?.onLoggedOut();
        }
        if (state is HomeError) {
          presenter?.onError(state.message);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeLoggingOut) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Đang đăng xuất...'),
                  ],
                ),
              );
            }
            if (state is HomeError) {
              return _buildErrorView(state.message);
            }
            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  // Forward lên Presenter — không gọi BLoC trực tiếp từ View
                  presenter?.refresh(context.read<HomeBloc>());
                  await Future.delayed(const Duration(milliseconds: 1200));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(state.profile.name),
                      const SizedBox(height: 24),
                      ProfileCard(profile: state.profile),
                      const SizedBox(height: 28),
                      _buildSectionTitle('Thống kê'),
                      const SizedBox(height: 12),
                      _buildStatsRow(),
                      const SizedBox(height: 28),
                      _buildSectionTitle('Tính năng'),
                      const SizedBox(height: 12),
                      _buildMenuGrid(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Trang chủ'),
      actions: [
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final isLoggingOut = state is HomeLoggingOut;
            return IconButton(
              icon: isLoggingOut
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout_rounded),
              tooltip: 'Đăng xuất',
              onPressed: isLoggingOut
                  ? null
                  // Forward lên Presenter — Presenter quyết định show dialog
                  : () => presenter?.onLogoutPressed(context.read<HomeBloc>()),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  Widget _buildGreeting(String name) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Chào buổi sáng ☀️'
        : hour < 17
            ? 'Chào buổi chiều 🌤'
            : 'Chào buổi tối 🌙';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColorDark,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight,
              ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight,
          ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('12', 'Dự án', Icons.folder_outlined,
              Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('48', 'Task', Icons.task_outlined,
              Colors.orange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('5', 'Thông báo',
              Icons.notifications_outlined, Colors.green),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).primaryColorDark,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    const items = [
      _MenuItem('Hồ sơ', Icons.person_outline, Colors.blue),
      _MenuItem('Cài đặt', Icons.settings_outlined, Colors.orange),
      _MenuItem('Thông báo', Icons.notifications_outlined, Colors.green),
      _MenuItem('Hỗ trợ', Icons.help_outline, Colors.purple),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _buildMenuItem(items[i]),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorLight,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline,
                  size: 52, color: Colors.red.shade400),
            ),
            const SizedBox(height: 20),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColorDark,
                  ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              // Forward lên Presenter
              onPressed: () =>
                  presenter?.loadProfile(context.read<HomeBloc>()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper class ─────────────────────────────────────────────────────────────

class _MenuItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _MenuItem(this.label, this.icon, this.color, [this.onTap]);
}
