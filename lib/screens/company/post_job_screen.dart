import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';
import '../search/map_location_picker_screen.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  final _locationC = TextEditingController();
  final _salaryC = TextEditingController();
  
  LatLng? _selectedCoords;
  String _jobType = 'Full-time';
  String _workMode = 'On-site';
  bool _isLoading = false;

  final List<String> _jobTypes = ['Full-time', 'Part-time', 'Contract', 'Internship'];
  final List<String> _workModes = ['On-site', 'Remote', 'Hybrid'];

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapLocationPickerScreen()),
    );

    if (result != null && result is Map) {
      setState(() {
        _selectedCoords = result['position'];
        _locationC.text = result['address'] ?? "";
      });
    }
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCoords == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please pick a location on the map')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dbService = Provider.of<DatabaseService>(context, listen: false);
      await dbService.postJob({
        'title': _titleC.text.trim(),
        'description': _descC.text.trim(),
        'location': _locationC.text.trim(),
        'latitude': _selectedCoords!.latitude,
        'longitude': _selectedCoords!.longitude,
        'salary': _salaryC.text.trim(),
        'jobType': _jobType,
        'workMode': _workMode,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job posted successfully!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to post job: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Post a New Job', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Job Title'),
              _buildTextField(_titleC, 'e.g. Senior Flutter Developer', Icons.work_outline_rounded),
              
              const SizedBox(height: 20),
              _buildLabel('Job Description'),
              TextFormField(
                controller: _descC,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe the role...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (v) => v!.isEmpty ? 'Description is required' : null,
              ),

              const SizedBox(height: 20),
              _buildLabel('Location & Mapping'),
              InkWell(
                onTap: _pickLocation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _selectedCoords != null ? const Color(0xFF1B4332) : Colors.transparent),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.map_rounded, color: _selectedCoords != null ? const Color(0xFF1B4332) : Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedCoords == null ? 'Select exact location on map' : _locationC.text,
                          style: TextStyle(color: _selectedCoords == null ? Colors.grey : Colors.black87, fontSize: 14),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Job Type'),
                        _buildDropdown(_jobType, _jobTypes, (val) => setState(() => _jobType = val!)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Work Mode'),
                        _buildDropdown(_workMode, _workModes, (val) => setState(() => _workMode = val!)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _buildLabel('Salary Range (Optional)'),
              _buildTextField(_salaryC, 'e.g. PKR 100k - 150k', Icons.payments_outlined),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4332),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Post Job Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1B4332)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (v) => v!.isEmpty ? 'This field is required' : null,
    );
  }

  Widget _buildDropdown(String value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
