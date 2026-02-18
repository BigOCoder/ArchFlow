// lib/features/team/presentation/screens/create_team_screen.dart

// ignore_for_file: unused_field

import 'package:archflow/shared/widgets/app_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  String _teamName = '';
  String _teamDescription = '';

  @override
  Widget build(BuildContext context) {
    // ✅ Fixed - build was broken (missing return Scaffold)
    return Scaffold(
      // ✅ Removed backgroundColor - uses theme
      appBar: AppBar(
        title: Text(
          'Create Team',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team Details',
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  // ✅ Fixed - uses theme
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                decoration: appInputDecoration(
                  context: context,
                  label: 'Team Name',
                  hint: 'Engineering Team',
                  icon: Icons.groups,
                ),
                onChanged: (v) => _teamName = v,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Team name required' : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                decoration: appInputDecoration(
                  context: context,
                  label: 'Description',
                  hint: 'Building the future...',
                  icon: Icons.description,
                ),
                maxLines: 3,
                onChanged: (v) => _teamDescription = v,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  // ✅ Removed style - uses theme
                  child: Text(
                    'Create Team',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
