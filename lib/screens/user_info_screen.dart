import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_project/cubits/user_info_cubit.dart';

import '../cubits/auth_cubit.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Large user avatar
            Expanded(
              child: BlocBuilder<UserInfoCubit, UserInfoState>(
                builder: (context, state) {
                  if (state is UserInfoLoaded) {
                    final user = state.user;
                    return Column(
                      children: [
                        Hero(
                          tag: 'user-avatar',
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: NetworkImage(user.image),
                            child: Text(
                              user.firstName[0].toUpperCase(),
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // User personal information
                        Text(
                          //user.fullName,
                          '${user.firstName} ${user.lastName}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),

                        // User details card
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildInfoRow(context, Icons.person,
                                    'First Name', user.firstName),
                                const Divider(),
                                _buildInfoRow(context, Icons.person_outline,
                                    'Last Name', user.lastName),
                                const Divider(),
                                _buildInfoRow(context, Icons.calendar_today,
                                    'Age', user.age.toString()),
                                const Divider(),
                                _buildInfoRow(
                                    context, Icons.email, 'Email', user.email),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is UserInfoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text('An error occured'));
                  }
                },
              ),
            ),

            //const Spacer(),

            // Sign Out button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Access AuthCubit to sign out
                  await context.read<AuthCubit>().logout();
                  if (context.mounted) context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
