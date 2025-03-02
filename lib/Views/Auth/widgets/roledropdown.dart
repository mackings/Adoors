import 'package:flutter/material.dart';

class RoleDropdown extends StatefulWidget {

  final double borderRadius;
  final Color? borderColor;
  final String? initialValue;
  final ValueChanged<String>? onChanged; // Callback to send selected value to the parent

  const RoleDropdown({
    Key? key,
    this.borderRadius = 12.0,
    this.borderColor = Colors.grey,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoleDropdownState createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {

  String? selectedRole;
  
  final List<String> roles = [
    "Select Role", 
    "Parent",
    "Student",
    "Teacher",
    "Driver",
  ];

  @override
  void initState() {
    super.initState();
    selectedRole = widget.initialValue ?? roles[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor ?? Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              selectedRole = newValue;
              widget.onChanged?.call(newValue!); // Notify the parent of the new value
            });
          },
          items: roles.map((role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(
                role,
                style: const TextStyle(fontSize: 14.0),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
