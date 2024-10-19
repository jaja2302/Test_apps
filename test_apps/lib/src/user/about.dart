import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class AboutSection extends StatefulWidget {
  final String token;

  const AboutSection({
    Key? key,
    required this.token,
    required bool isExpanded,
    required Null Function() onToggle,
  }) : super(key: key);

  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
                hasIcon: false,
              ),
              header: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Builder(
                          builder: (context) {
                            final controller = ExpandableController.of(context,
                                required: true)!;
                            return controller.expanded
                                ? TextButton(
                                    onPressed: () {
                                      // TODO: Implement save functionality
                                      controller.toggle();
                                    },
                                    child: const Text(
                                      'Save & Update',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 14),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white),
                                    onPressed: () => controller.toggle(),
                                  );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add in your to help others know you better',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              collapsed: const SizedBox.shrink(),
              expanded: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddImageButton(),
                    _buildTextField(nameController, 'Display name'),
                    _buildDropdownField('Gender', ['Select Gender']),
                    _buildTextField(birthdayController, 'Birthday',
                        hintText: 'DD MM YYYY'),
                    _buildDropdownField('Horoscope', ['-']),
                    _buildDropdownField('Zodiac', ['-']),
                    _buildTextField(heightController, 'Height',
                        hintText: 'Add height'),
                    _buildTextField(weightController, 'Weight',
                        hintText: 'Add weight'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.add, color: Colors.grey[400], size: 40),
          const SizedBox(height: 8),
          Text('Add image', style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {String? hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400])),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText ?? 'Enter $label',
              hintStyle: TextStyle(color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400])),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: items.first,
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // TODO: Implement dropdown functionality
                },
                dropdownColor: Colors.grey[800],
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
