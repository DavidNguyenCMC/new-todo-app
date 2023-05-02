import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/common/resources/index.dart';
import 'package:todo_app/common/utils/extensions/extension.dart';
import 'package:todo_app/common/widgets/default_app_bar.dart';
import 'package:todo_app/common/widgets/spacing.dart';
import 'package:todo_app/common/widgets/toast/toast.dart';
import 'package:todo_app/pages/create_task/controller/create_task_controller.dart';

import '../../common/enums/status.dart';
import '../../common/widgets/date_time_field.dart';
import '../../common/widgets/default_image_widget.dart';
import '../../common/widgets/dialogs/loading_dialog.dart';
import '../../common/widgets/platform_image_picker.dart';
import '../../common/widgets/title_text_field.dart';
import '../../models/task.dart';
import 'controller/create_task_state.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  bool _isCreate = true;
  GlobalKey<FormState> _formKey = GlobalKey();

  final CreateTaskController _controller = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Task? task = context.getRouteArguments();
      _controller.initData(task);
    });

    _controller.state.listen((state) {
      _handleStateListener(state);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Task? task = context.getRouteArguments();
    _isCreate = task == null;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: DefaultAppBar(
          titleText: _isCreate ? 'Create Task' : 'Edit Task',
          // trailingActions: [
          //   IconButton(
          //     icon: Icon(Icons.save_outlined),
          //     onPressed: () => _onSaveTapped(context),
          //   )
          // ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileImage(context, task, _controller.state.value),
                        TitleTextField(
                          title: Strings.localized.name,
                          initialValue: task?.name,
                          onChanged: (text) => _controller.changeTaskName(text),
                          validator: (text) {
                            if ((text ?? '').isEmpty) {
                              return 'Name is required';
                            }
                          },
                        ),
                        const Spacing(),
                        TitleTextField(
                          title: Strings.localized.description,
                          initialValue: task?.desc,
                          onChanged: (text) => _controller.changeTaskDesc(text),
                          maxLines: 4,
                        ),
                        const Spacing(),
                        DateTimeInput(
                          title: Strings.localized.expiredAt,
                          initialValue: task?.expiredAt,
                          dateFormat: DateTimeFormat.DD_MMM_YYYY_HH_MM,
                          onDateTimeSelected: (date) => _controller.changeTaskExpiredDate(date),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  child: Text(
                    Strings.localized.submit,
                    style: TextStyles.whiteNormalRegular,
                  ),
                  onPressed: () => _onSaveTapped(context),
                  style: TextButton.styleFrom(backgroundColor: AppColors.primaryColor),
                ),
              ),
            ),
            const Spacing(),
          ],
        ),
      ),
    );
  }

  Align _profileImage(BuildContext context, Task? task, CreateTaskState state) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: DefaultImageWidget(
              task?.image,
              imageFile: state.image,
              height: 100,
              width: 100,
              radius: 50,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () => _onChangeProfileImageTapped(context),
              child: AssetImages.imgCameraPrimary.toSvg(height: 35, width: 35),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onChangeProfileImageTapped(BuildContext context) async {
    try {
      final XFile? image = await PlatformImagePicker.show(context);
      if (image != null) {
        _controller.changeTaskImage(File(image.path));
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _handleStateListener(state) {
    switch (state.status) {
      case RequestStatus.initial:
        break;
      case RequestStatus.requesting:
        IgnoreLoadingIndicator().show(context);
        break;
      case RequestStatus.success:
        IgnoreLoadingIndicator().hide(context);
        Navigator.pop(context);
        break;
      case RequestStatus.failed:
        IgnoreLoadingIndicator().hide(context);
        showFailureMessage(context, state.message ?? '');
        break;
    }
  }

  void _onSaveTapped(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isCreate) {
        _controller.createTask();
      } else {
        _controller.updateTask();
      }
    }
  }
}
