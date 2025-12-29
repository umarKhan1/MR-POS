import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mrpos/core/models/reservation.dart';
import 'package:mrpos/features/reservations/presentation/cubit/reservations_cubit.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class AddReservationModal extends StatefulWidget {
  final Reservation? reservation;

  const AddReservationModal({super.key, this.reservation});

  @override
  State<AddReservationModal> createState() => _AddReservationModalState();
}

class _AddReservationModalState extends State<AddReservationModal> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);
  int _numberOfGuests = 2;
  ReservationStatus _status = ReservationStatus.confirmed;

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      _firstNameController.text = widget.reservation!.firstName;
      _lastNameController.text = widget.reservation!.lastName;
      _phoneController.text = widget.reservation!.phoneNumber;
      _emailController.text = widget.reservation!.emailAddress;
      _selectedDate = widget.reservation!.reservationDate;
      _selectedTime = widget.reservation!.reservationTime;
      _numberOfGuests = widget.reservation!.numberOfGuests;
      _status = widget.reservation!.status;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryRed,
              onPrimary: Colors.white,
              surface: Color(0xFF2A2A2A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryRed,
              onPrimary: Colors.white,
              surface: Color(0xFF2A2A2A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveReservation() {
    if (_formKey.currentState!.validate()) {
      final reservation = Reservation(
        id:
            widget.reservation?.id ??
            'res_${DateTime.now().millisecondsSinceEpoch}',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        emailAddress: _emailController.text.trim(),
        reservationDate: _selectedDate,
        reservationTime: _selectedTime,
        numberOfGuests: _numberOfGuests,
        status: _status,
        createdAt: widget.reservation?.createdAt ?? DateTime.now(),
      );

      if (widget.reservation == null) {
        context.read<ReservationsCubit>().addReservation(reservation);
      } else {
        context.read<ReservationsCubit>().updateReservation(reservation);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      width: 450,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: (isDark ? Colors.grey[800] : Colors.grey[200])!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.reservation == null
                        ? 'Add New Reservation'
                        : 'Edit Reservation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black54,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Details Section
                    _buildSectionTitle(context, 'Customer Details'),
                    16.h,
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            context: context,
                            controller: _firstNameController,
                            label: 'First Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        16.w,
                        Expanded(
                          child: _buildTextField(
                            context: context,
                            controller: _lastNameController,
                            label: 'Last Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    16.h,
                    _buildTextField(
                      context: context,
                      controller: _phoneController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    16.h,
                    _buildTextField(
                      context: context,
                      controller: _emailController,
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (!value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                    32.h,
                    // Reservation Details Section
                    _buildSectionTitle(context, 'Reservation Details'),
                    16.h,
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateTimePicker(
                            context: context,
                            label: 'Date',
                            value: DateFormat(
                              'MMM dd, yyyy',
                            ).format(_selectedDate),
                            icon: Icons.calendar_today,
                            onTap: _selectDate,
                          ),
                        ),
                        16.w,
                        Expanded(
                          child: _buildDateTimePicker(
                            context: context,
                            label: 'Time',
                            value: _selectedTime.format(context),
                            icon: Icons.access_time,
                            onTap: _selectTime,
                          ),
                        ),
                      ],
                    ),
                    16.h,
                    Row(
                      children: [
                        Expanded(child: _buildGuestSelector(context)),
                        16.w,
                        Expanded(child: _buildStatusDropdown(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Footer Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[50],
                border: Border(
                  top: BorderSide(
                    color: (isDark ? Colors.grey[800] : Colors.grey[200])!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : Colors.black87,
                        side: BorderSide(
                          color: (isDark
                              ? Colors.grey[700]
                              : Colors.grey[300])!,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  16.w,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveReservation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Save Reservation',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = context.isDarkMode;
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = context.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.h,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorStyle: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.h,
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  Icon(icon, color: AppColors.primaryRed, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestSelector(BuildContext context) {
    final isDark = context.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Guests',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.h,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: isDark ? Colors.white : Colors.black87,
                  size: 18,
                ),
                onPressed: () {
                  if (_numberOfGuests > 1) {
                    setState(() => _numberOfGuests--);
                  }
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '$_numberOfGuests ${_numberOfGuests == 1 ? 'person' : 'persons'}',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: isDark ? Colors.white : Colors.black87,
                  size: 18,
                ),
                onPressed: () {
                  setState(() => _numberOfGuests++);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    final isDark = context.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.h,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<ReservationStatus>(
            value: _status,
            isExpanded: true,
            dropdownColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            underline: const SizedBox(),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            items: ReservationStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _status = value);
              }
            },
          ),
        ),
      ],
    );
  }
}
