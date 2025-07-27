import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _customSkillController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Map<String, dynamic>> allSkills = [];
  Map<String, List<Map<String, dynamic>>> groupedSkills = {};

  final List<String> skillsOffered = [];
  final List<String> skillsNeeded = [];

  @override
  void initState() {
    super.initState();
    loadSkills();
  }

  Future<void> loadSkills() async {
    try {
      final skills = await ApiService().getAllSkills();
      setState(() {
        allSkills = skills;
      });
      groupSkills();
    } catch (e) {
      debugPrint('Error fetching skills: $e');
    }
  }

  void groupSkills() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final skill in allSkills) {
      final category = (skill['category'] ?? '').toString().trim();
      grouped.putIfAbsent(category, () => []).add(skill);
    }
    setState(() {
      groupedSkills = grouped;
    });
  }

  void toggleSkill(String skill, bool offered) {
    setState(() {
      final list = offered ? skillsOffered : skillsNeeded;
      if (list.contains(skill)) {
        list.remove(skill);
      } else {
        list.add(skill);
      }
    });
  }

  void addCustomSkill(bool offered) {
    final skill = _customSkillController.text.trim();
    if (skill.isEmpty) return;

    setState(() {
      if (offered && !skillsOffered.contains(skill)) {
        skillsOffered.add(skill);
      } else if (!offered && !skillsNeeded.contains(skill)) {
        skillsNeeded.add(skill);
      }
      _customSkillController.clear();
    });
  }

  Future<void> handleRegister() async {
    if (_nameController.text.isEmpty) return;

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('Could not get location: $e');
    }

    final profile = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text.trim(),
      'password': _passwordController.text.trim(),
      'email': _nameController.text.trim().toLowerCase().replaceAll(' ', '_'),
      'bio': _bioController.text.trim(),
      'skillsOffered': skillsOffered,
      'skillsNeeded': skillsNeeded,
      'longitude': position?.longitude ?? 0.0,
      'latitude': position?.latitude ?? 0.0,
    };

    try {
      final backendUser = await ApiService().registerUser(profile);
      debugPrint('User registered!');
      context.read<UserProvider>().setProfile(backendUser);
      Navigator.pushReplacementNamed(context, '/swipe');
    } catch (e) {
      debugPrint('Failed to register: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed! Try again.')),
      );
    }
  }

  Widget buildSkillChips(bool offered, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSkills.keys.map((category) {
        final skills = groupedSkills[category]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.isNotEmpty ? category : 'Other',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: skills.map((skill) {
                final name = skill['name'] as String;
                final selected = offered
                    ? skillsOffered.contains(name)
                    : skillsNeeded.contains(name);

                return FilterChip(
                  label: Text(name),
                  selected: selected,
                  onSelected: (_) => toggleSkill(name, offered),
                  selectedColor: color.withOpacity(0.3),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget buildSkillCard({
    required String title,
    required bool offered,
    required Color color,
    required List<String> selectedSkills,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            buildSkillChips(offered, color),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customSkillController,
                    decoration: const InputDecoration(
                      hintText: 'Add custom skill',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => addCustomSkill(offered),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: selectedSkills
                  .map(
                    (s) => Chip(
                      label: Text(s),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => toggleSkill(s, offered),
                      backgroundColor: color.withOpacity(0.5),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('SkillSwap')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Your Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 8),
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio (optional)',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          buildSkillCard(
            title: 'Skills I Can Offer',
            offered: true,
            color: Colors.green,
            selectedSkills: skillsOffered,
          ),
          const SizedBox(height: 16),
          buildSkillCard(
            title: 'Skills I Need Help With',
            offered: false,
            color: Colors.blue,
            selectedSkills: skillsNeeded,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: handleRegister,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              backgroundColor: Colors.orange,
            ),
            child: const Text(
              'Start Connecting!',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
