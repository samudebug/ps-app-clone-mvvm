import 'package:flutter/material.dart';
import 'package:ps_app_clone_mvvm/ui/core/ui/error_indicator.dart';
import 'package:ps_app_clone_mvvm/ui/profile/view_models/profile_viewmodel.dart';
import 'package:ps_app_clone_mvvm/ui/profile/views/trophy_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.viewModel});
  final ProfileViewModel viewModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel.getProfileCommand,
          builder: (context, child) {
            if (widget.viewModel.getProfileCommand.running) {
              return Center(child: CircularProgressIndicator());
            }
            if (widget.viewModel.getProfileCommand.error || widget.viewModel.profile == null) {
              return ErrorIndicator(
                title: "Error loading profile",
                label: "Retry",
                onPressed: widget.viewModel.getProfileCommand.execute,
              );
            }
            
            return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Image.network(
                      widget.viewModel.profile?.avatarUrl ?? "",
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Text(
                  widget.viewModel.profile?.fullName ?? "",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.viewModel.profile?.username ?? "",
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                ListenableBuilder(listenable: widget.viewModel.getTrophySummaryCommand, builder: (context, child) {
                  if (widget.viewModel.getTrophySummaryCommand.running) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (widget.viewModel.getTrophySummaryCommand.error || widget.viewModel.trophySummary == null) {
                    return Text("Error loading trophy summary",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    );
                 }
                  
                  return TrophyContainer(trophySummary: widget.viewModel.trophySummary!);
                }),
                ListTile(
                  leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                  title: Text('Logout', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  )),
                )
              ],
            ),
          );
          },
        ),
      ),
    );
  }
  
}
