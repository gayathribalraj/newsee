// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:newsee/AppData/app_forms.dart';
// import 'package:newsee/widgets/drop_down.dart';
// import 'package:newsee/widgets/integer_text_field.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:newsee/widgets/sysmo_alert.dart';
// import 'package:go_router/go_router.dart';

// class AuditlogDatetimeForm extends StatelessWidget {
//   const AuditlogDatetimeForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//       final FormGroup customDateForm = AppForms.AUDIT_LOG_FORM();


//     return ReactiveForm(
//       formGroup: customDateForm,

//       child: Column(
//         children: [
//                              Dropdown(
//                               controlName: 'todayAndThisweek',
//                               label: 'SelectDays',
//                               items: ['Today', 'ThisWeek'],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: ReactiveTextField<String>(
//                                 formControlName: 'startDate',
//                                 validationMessages: {
//                                   ValidationMessage.required:
//                                       (error) => 'startDate is required',
//                                 },
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   labelText: 'Start Date',
//                                   suffixIcon: Icon(Icons.calendar_today),
//                                 ),
//                                 onTap: (control) async {
//                                   final DateTime? pickedDate =
//                                       await showDatePicker(
//                                         context: context,
//                                         initialDate: DateTime.now(),
//                                         firstDate: DateTime(1900),
//                                         lastDate: DateTime.now(),
//                                       );
//                                   if (pickedDate != null) {
//                                     final formatted =
//                                         "${pickedDate.day.toString().padLeft(2, '0')}/"
//                                         "${pickedDate.month.toString().padLeft(2, '0')}/"
//                                         "${pickedDate.year}";
//                                     customDateForm.control('startDate').value =
//                                         formatted;
//                                   }
//                                 },
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: ReactiveTextField<String>(
//                                 formControlName: 'endDate',
//                                 validationMessages: {
//                                   ValidationMessage.required:
//                                       (error) => 'EndDate is required',
//                                 },
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   labelText: 'End Date',
//                                   suffixIcon: Icon(Icons.calendar_today),
//                                 ),
//                                 onTap: (control) async {
//                                   final DateTime? pickedDate =
//                                       await showDatePicker(
//                                         context: context,
//                                         initialDate: DateTime.now(),
//                                         firstDate: DateTime(1900),
//                                         lastDate: DateTime(2026),
//                                       );
//                                   if (pickedDate != null) {
//                                     final formatted =
//                                         "${pickedDate.day.toString().padLeft(2, '0')}/"
//                                         "${pickedDate.month.toString().padLeft(2, '0')}/"
//                                         "${pickedDate.year}";
//                                     customDateForm.control('endDate').value =
//                                         formatted;
//                                   }
//                                 },
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: ReactiveTextField<TimeOfDay>(
//                                 formControlName: 'startTime',
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   labelText: 'Start Time',
//                                   suffixIcon: Icon(Icons.access_time),
//                                 ),
//                                 onTap: (control) async {
//                                   final TimeOfDay? pickedTime =
//                                       await showTimePicker(
//                                         context: context,
//                                         initialTime:
//                                             control.value ?? TimeOfDay.now(),
//                                       );
//                                   if (pickedTime != null) {
//                                     control.updateValue(pickedTime);
//                                   }
//                                 },
//                                 valueAccessor: TimeOfDayValueAccessor(),
//                               ),
//                             ),
//                             SizedBox(height: 20),

//                             Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: ReactiveTextField<TimeOfDay>(
//                                 formControlName: 'endTime',
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   labelText: 'End Time',
//                                   suffixIcon: Icon(Icons.access_time),
//                                 ),
//                                 onTap: (control) async {
//                                   final TimeOfDay? pickedTime =
//                                       await showTimePicker(
//                                         context: context,
//                                         initialTime:
//                                             control.value ?? TimeOfDay.now(),
//                                       );
//                                   if (pickedTime != null) {
//                                     control.updateValue(pickedTime);
//                                   }
//                                 },
//                                 valueAccessor: TimeOfDayValueAccessor(),
//                               ),
//                             ),
                          
                       
//                           Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: ElevatedButton(
//                   style: const ButtonStyle(
//                     backgroundColor: WidgetStatePropertyAll<Color>(
//                       Color.fromARGB(255, 2, 59, 105),
//                     ),
//                     foregroundColor: WidgetStatePropertyAll(Colors.white),
//                     minimumSize: WidgetStatePropertyAll(Size(150, 40)),
//                   ),
//                   onPressed: () async {
//                     try {
//                       if (customDateForm.valid) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Fetching data')),
//                         );
//                         final selectedDay =
//                             customDateForm
//                                 .control('todayAndThisweek')
//                                 .value
//                                 ?.toString() ??
//                             '';

//                         if (selectedDay == 'Today') {
//                           final now = DateTime.now();
//                           final startDate = DateTime(
//                             now.year,
//                             now.month,
//                             now.day,
//                           );
//                           final endDate = DateTime(
//                             now.year,
//                             now.month,
//                             now.day,
//                             23,
//                             59,
//                             59,
//                           );

//                           final start = DateFormat(
//                             'yyyy-MM-dd HH:mm:ss',
//                           ).format(startDate);
//                           final end = DateFormat(
//                             'yyyy-MM-dd HH:mm:ss',
//                           ).format(endDate);
//                           await fetchAuditLogsForDate(
//                             startDateStr: start,
//                             endDateStr: end,
//                           );
//                         } else if (selectedDay == 'ThisWeek') {
//                           final today = DateTime.now();
//                           final now = DateTime(
//                             today.year,
//                             today.month,
//                             today.day,
//                           );
//                           final int weekday = now.weekday;
//                           final DateTime startOfWeek = now.subtract(
//                             Duration(days: weekday - 1),
//                           );
//                           final DateTime endDate = startOfWeek.add(
//                             const Duration(days: 6),
//                           );

//                           final endOfWeek = DateTime(
//                             endDate.year,
//                             endDate.month,
//                             endDate.day,
//                             23,
//                             59,
//                             59,
//                           );

//                           final start = DateFormat(
//                             'yyyy-MM-dd HH:mm:ss',
//                           ).format(startOfWeek);
//                           final end = DateFormat(
//                             'yyyy-MM-dd HH:mm:ss',
//                           ).format(endOfWeek);
//                           await fetchAuditLogsForDate(
//                             startDateStr: start,
//                             endDateStr: end,
//                           );
//                         }

//                         final startDate =
//                             customDateForm.control('startDate').value ?? '';
//                         final endDate =
//                             customDateForm.control('endDate').value ?? '';
//                         final TimeOfDay? startTime =
//                             customDateForm.control('startTime').value;
//                         final TimeOfDay? endTime =
//                             customDateForm.control('endTime').value;

//                         if (startDate.isEmpty ||
//                             endDate.isEmpty ||
//                             startTime == null ||
//                             endTime == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please select all date and time'),
//                             ),
//                           );
//                           return;
//                         }

//                         final DateTime startdata = DateFormat(
//                           "dd/MM/yyyy",
//                         ).parse(startDate);
//                         final DateTime enddata = DateFormat(
//                           "dd/MM/yyyy",
//                         ).parse(endDate);

//                         // final formatedTime = formatTime(context, startTime);
//                         // final formatedEndTime = formatTime(context, endTime);

//                         final startDateTime = combineDateAndTime(
//                           startdata,
//                           startTime,
//                         );
//                         final endDateTime = combineDateAndTime(
//                           enddata,
//                           endTime,
//                         );

//                         final start = DateFormat(
//                           'yyyy-MM-dd HH:mm:ss',
//                         ).format(startDateTime);
//                         final end = DateFormat(
//                           'yyyy-MM-dd HH:mm:ss',
//                         ).format(endDateTime);

//                         await fetchAuditLogsForDate(
//                           startDateStr: start,
//                           endDateStr: end,
//                         );
//                       } else {
//                         customDateForm.markAllAsTouched();
//                       }
//                     } catch (e) {
//                       print("auditlog customtime pressed => $e");
//                     }
//                   },
//                   child: const Text('Generate custom Log'),
//                 ),
//               ),
//     );
  
    

//   }
// }
