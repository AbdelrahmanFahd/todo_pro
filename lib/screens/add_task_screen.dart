import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_pro_app/widget/button.dart';
import '../models/task.dart';
import '../controller/task_controller.dart';
import '../models/theme.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

int _selectedColor = 0;

class _AddTaskScreenState extends State<AddTaskScreen> {
  final taskController = Get.put(TaskController());

  //get Date
  _getDateFromUser() async {
    final _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  //get Time
  _getTimeFromUser(bool isStartTime) async {
    final _pickedTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay.now());
    if (_pickedTime != null) {
      String formatTime = _pickedTime.format(context);
      if (isStartTime) {
        setState(() {
          _startTime = formatTime;
        });
      } else {
        setState(() {
          _endTime = formatTime;
        });
      }
    }
  }

  bool valid() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      _showSnackBar();
      return false;
    } else {
      return true;
    }
  }

  void _createTask() async {
    final isValid = valid();
    if (isValid) {
      // add to database
      final id = await taskController.addTask(
          task: Task(
        title: _titleController.text,
        note: _noteController.text,
        repeat: _selectedRepeat,
        reminder: _selectedReminder,
        startTime: _startTime,
        color: _selectedColor,
        endTime: _endTime,
        dateTime: DateFormat.yMd().format(_selectedDate),
        isComplete: 0,
      ));
      Get.back();
    }
  }

  void _showSnackBar() {
    Get.snackbar('Required', 'All fields are required !',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        colorText: pinkClr);
  }

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now());
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(hours: 6)));
  int _selectedReminder = 5;
  List<int> reminder = [5, 10, 15, 20];

  String _selectedRepeat = 'None';
  List<String> repeat = ['None', 'Daily', 'Weekly', 'Monthly'];

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 22,
          ),
        ),
        actions: const [
          CircleAvatar(backgroundImage: AssetImage('assets/images/he.jpg')),
          SizedBox(width: 20),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              DefaultTextFieldForm(
                  controller: _titleController,
                  title: 'Title',
                  hint: 'Enter title here'),
              DefaultTextFieldForm(
                title: 'Note',
                hint: 'Enter note here',
                controller: _noteController,
              ),
              DefaultTextFieldForm(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey[700],
                    ),
                    onPressed: _getDateFromUser),
              ),
              Row(
                children: [
                  Expanded(
                    child: DefaultTextFieldForm(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {
                            _getTimeFromUser(true);
                          }),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: DefaultTextFieldForm(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {
                            _getTimeFromUser(false);
                          }),
                    ),
                  ),
                ],
              ),
              DefaultTextFieldForm(
                title: 'Reminder',
                hint: '$_selectedReminder minutes early',
                widget: DropdownButton(
                  underline: const SizedBox(),
                  items: reminder
                      .map((e) => DropdownMenuItem(
                          value: e.toString(), child: Text(e.toString())))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReminder = int.parse(value.toString());
                    });
                  },
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              DefaultTextFieldForm(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: DropdownButton(
                  underline: const SizedBox(),
                  items: repeat
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRepeat = value.toString();
                    });
                  },
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ChooseColor(),
                    MyButton(onTap: _createTask, label: 'Create Task')
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class DefaultTextFieldForm extends StatelessWidget {
  const DefaultTextFieldForm(
      {Key? key,
      required this.title,
      this.valid,
      this.controller,
      required this.hint,
      this.widget})
      : super(key: key);
  final String title;
  final String hint;
  final Widget? widget;
  final TextEditingController? controller;
  final String? Function(String?)? valid;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 14, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Row(children: [
              Expanded(
                child: TextFormField(
                  validator: valid,
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                  controller: controller,
                  style: subtitleStyle,
                  decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subtitleStyle,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: context.theme.backgroundColor,
                        width: 0,
                      ))),
                ),
              ),
              if (widget != null) Container(child: widget),
            ]),
          ),
        ],
      ),
    );
  }
}

class ChooseColor extends StatefulWidget {
  const ChooseColor({Key? key}) : super(key: key);

  @override
  State<ChooseColor> createState() => _ChooseColorState();
}

class _ChooseColorState extends State<ChooseColor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(height: 8),
        Wrap(
            children: List.generate(
                3,
                (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: colors[index],
                          child: _selectedColor == index
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      ),
                    ))),
      ],
    );
  }
}
