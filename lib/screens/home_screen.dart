import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/task_controller.dart';
import '../models/notification.dart';
import '../models/task.dart';
import '../models/theme.dart';
import 'package:get/get.dart';

import '../widget/button.dart';
import '../widget/task_tile.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

DateTime _selectedDate = DateTime.now();
final taskController = Get.put(TaskController());

String day = DateFormat.yMd().format(_selectedDate);
List<Task>? tasks;

Future<void> getData() async {
  tasks = await taskController.getTaskOfDay();
}

class _HomeScreenState extends State<HomeScreen> {
  var notifyHelper = NotifyHelper();

  @override
  void initState() {
    super.initState();
    notifyHelper.initializeNotification();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            setState(() {
              Themes().switchTheme();
            });

            // notifyHelper.scheduledNotification();

            notifyHelper.displayNotification(
                title: 'Theme Changed',
                body: Get.isDarkMode
                    ? 'Activated Light Theme'
                    : 'Activated Dark Theme');
          },
          child: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_outlined,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 22,
          ),
        ),
        actions: const [
          CircleAvatar(backgroundImage: AssetImage('assets/images/he.jpg')),
          SizedBox(width: 20),
        ],
      ),
      body: Column(children: [
        AddTask(dark: Get.isDarkMode),
        // const AddDateBar(),
        Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 95,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryColor,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onDateChange: (date) async {
                setState(() {
                  _selectedDate = date;
                  day = DateFormat.yMd().format(_selectedDate);
                });
                getData();
                //Todo take data
              },
            )),
        const SizedBox(height: 10),
        if (tasks != null)
          Expanded(
            child: ListView.builder(
                itemCount: tasks!.length,
                itemBuilder: (_, index) {
                  if (tasks![index].repeat == 'Daily') {
                    DateTime date = DateFormat.jm()
                        .parse(tasks![index].startTime.toString());

                    var myTime = DateFormat('HH:mm').format(date);

                    notifyHelper.scheduledNotification(
                        int.parse(myTime.toString().split(':')[0]),
                        int.parse(myTime.toString().split(':')[1]),
                        tasks![index]);
                    // notifyHelper.scheduledNotification(10, 35, tasks![index]);

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () async {
                              await _showBottomSheet(context, tasks![index]);
                              getData();
                              setState(() {});
                              print('tapped');
                            },
                            child: TaskTile(tasks![index]),
                          ),
                        ),
                      ),
                    );
                  }
                  if (tasks![index].dateTime == day) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () async {
                              await _showBottomSheet(context, tasks![index]);
                              getData();
                              setState(() {});
                              print('tapped');
                            },
                            child: TaskTile(tasks![index]),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                  // AnimationConfiguration.staggeredList(
                  //   position: index,
                  //   child: SlideAnimation(
                  //     child: FadeInAnimation(
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           print('tapped');
                  //         },
                  //         // child: TaskTile(widget.tasks![index]),
                  //       ),
                  //     ),
                  //   ));
                }),
          ),
      ]),
    );
  }
}

Future<void> _showBottomSheet(BuildContext context, Task task) async {
  final sizeDevice = MediaQuery.of(context).size;
  await Get.bottomSheet(Container(
    color: Get.isDarkMode
        ? Colors.grey[900]!.withOpacity(.9)
        : Colors.white.withOpacity(.8),
    padding: const EdgeInsets.only(top: 5),
    // height: task.isComplete == 0
    //     ? sizeDevice.height * 0.32
    //     : sizeDevice.height * 0.24,
    constraints: BoxConstraints(
      minHeight: task.isComplete == 0
          ? sizeDevice.height * 0.32
          : sizeDevice.height * 0.24,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (task.isComplete == 0)
          BottomSheetButton(
              onTab: () async {
                await TaskController()
                    .updateTaskState(int.parse(task.id.toString()));
                getData();

                Get.back();
              },
              color: bluishClr,
              title: 'Task Completed',
              sizeDevice: sizeDevice),
        const SizedBox(height: 10),
        BottomSheetButton(
            color: pinkClr,
            onTab: () async {
              await TaskController().delete(int.parse(task.id.toString()));
              getData();
              Get.back();
            },
            title: 'Delete Task',
            sizeDevice: sizeDevice),
        const SizedBox(height: 25),
        BottomSheetButton(
            onTab: () {
              Get.back();
            },
            color: Colors.white,
            colorTitle: Colors.black,
            title: 'Close',
            sizeDevice: sizeDevice),
        const SizedBox(height: 10),
      ],
    ),
  ));
}

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    Key? key,
    required this.color,
    this.onTab,
    this.colorTitle = Colors.white,
    required this.title,
    required this.sizeDevice,
  }) : super(key: key);

  final Size sizeDevice;
  final Color color;
  final String title;
  final void Function()? onTab;
  final Color colorTitle;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTab,
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: .5,
                  color:
                      Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!),
              borderRadius: BorderRadius.circular(20)),
          primary: title == 'Close'
              ? Get.isDarkMode
                  ? Colors.white
                  : Colors.grey[900]!
              : color,
          minimumSize: Size(sizeDevice.width * 0.9, 50)),
      child: Text(
        title,
        style: GoogleFonts.lato(
            color: title == 'Close'
                ? Get.isDarkMode
                    ? Colors.grey[900]!
                    : Colors.white
                : colorTitle,
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

// class AddDateBar extends StatefulWidget {
//   const AddDateBar({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<AddDateBar> createState() => _AddDateBarState();
// }
//
// class _AddDateBarState extends State<AddDateBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.only(top: 20, left: 20),
//         child: DatePicker(
//           DateTime.now(),
//           height: 95,
//           width: 80,
//           initialSelectedDate: DateTime.now(),
//           selectionColor: primaryColor,
//           selectedTextColor: Colors.white,
//           dateTextStyle: GoogleFonts.lato(
//             textStyle: const TextStyle(
//               color: Colors.grey,
//               fontSize: 23,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           dayTextStyle: GoogleFonts.lato(
//             textStyle: const TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           monthTextStyle: GoogleFonts.lato(
//             textStyle: const TextStyle(
//               color: Colors.grey,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           onDateChange: (date) async {
//             _selectedDate = date;
//             final day = DateFormat.yMd().format(_selectedDate);
//             tasks = await taskController.getTaskOfDay(day);
//             setState(() {});
//             //Todo take data
//           },
//         ));
//   }
// }

class AddTask extends StatelessWidget {
  const AddTask({Key? key, required this.dark}) : super(key: key);
  final bool dark;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 20, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: dark ? Colors.white : Colors.black,
                  )),
                ),
              ],
            ),
          ),
          MyButton(
              onTap: () async {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (ctx) => const AddTaskScreen()));
                await Get.to(() => const AddTaskScreen());
                await taskController.getTaskOfDay();
              },
              label: '+ Add Task'),
        ],
      ),
    );
  }
}
