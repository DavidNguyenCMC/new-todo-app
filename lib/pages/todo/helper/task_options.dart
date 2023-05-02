import 'package:flutter/material.dart';

import '../../../common/resources/index.dart';
import '../../../models/task.dart';
import '../../widgets/detail_option_widget.dart';

enum OptionType { edit, delete }

enum SortOption { sortByTitle, sortByDesc, sortByDate }

List<DetailOption<OptionType>> getTaskOptions(TaskStatus? status) {
  return [
    if (status != TaskStatus.complete)
      DetailOption<OptionType>(
        icon: AssetImages.iconEdit.toSvg(),
        key: OptionType.edit,
        title: 'Edit',
        color: AppColors.black,
      ),
    DetailOption<OptionType>(
      icon: AssetImages.iconTrash.toSvg(color: AppColors.red500),
      key: OptionType.delete,
      title: 'Delete',
      color: AppColors.red500,
    ),
  ];
}

List<DetailOption<SortOption>> getSortTaskOptions() {
  return [
    DetailOption<SortOption>(
      icon: Icon(Icons.sort_by_alpha),
      key: SortOption.sortByTitle,
      title: Strings.localized.sortByTitle,
      color: AppColors.black,
    ),
    DetailOption<SortOption>(
      icon: Icon(Icons.sort_by_alpha),
      key: SortOption.sortByDesc,
      title: Strings.localized.sortByDesc,
      color: AppColors.black,
    ),
    DetailOption<SortOption>(
      icon: Icon(Icons.access_time),
      key: SortOption.sortByDate,
      title: Strings.localized.sortByDate,
      color: AppColors.black,
    ),
  ];
}
