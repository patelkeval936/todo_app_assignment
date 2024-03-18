import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/add_todo/add_todo_bloc.dart';

final _formKey = GlobalKey<FormState>();

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({super.key, required this.isViewOnly});

  final bool isViewOnly;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTodoBloc, AddTodoState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == EditTodoStatus.success,
        listener: (context, state) => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _TitleField(isViewOnly),
                _DescriptionField(isViewOnly),
                _DeadlinePicker(isViewOnly),
                if (!isViewOnly) const _Submit(),
                if (isViewOnly)
                  const SizedBox(
                    height: 40,
                  )
              ],
            ),
          ),
        ));
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField(this.isReadOnly);

  final bool isReadOnly;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AddTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Select Title',
        ),
        Form(
          key : _formKey,
          child: TextFormField(
            initialValue: state.title,
            decoration: InputDecoration(
              enabled: isReadOnly ? false : true,
              hintText: hintText,
            ),
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            validator: (value) {
              if (value == null || value.trim() == "") {
                return "Title can not be empty";
              }else{
                return null;
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
            ],
            onChanged: (value) {
              context.read<AddTodoBloc>().add(EditTodoTitleChanged(value));
            },
          ),
        ),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField(this.isReadOnly);
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AddTodoBloc>().state;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Select Category',
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Work', 'Personal', 'Shopping', 'Other'].map(
                (String value) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(value),
                      selected: state.category == value,
                      onSelected: (bool selected) {
                        if (!isReadOnly) {
                          context
                              .read<AddTodoBloc>()
                              .add(EditSelectedCategory(value));
                        }
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeadlinePicker extends StatelessWidget {
  const _DeadlinePicker(this.isReadOnly);
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AddTodoBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Select Deadline',
          ),
        ),
        CalendarDatePicker(
          initialDate:
              isReadOnly ? state.deadline ?? DateTime.now() : DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 1),
          lastDate: DateTime(DateTime.now().year + 1),
          currentDate: state.deadline,
          onDateChanged: (value) {
            if (!isReadOnly) {
              context.read<AddTodoBloc>().add(EditTodoDeadlineChanged(value));
            }
          },
        ),
      ],
    );
  }
}

class _Submit extends StatelessWidget {
  const _Submit();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  context.read<AddTodoBloc>().add(const EditTodoSubmitted());
                }
              },
              child: const Text('Submit')),
        ),
      ],
    );
  }
}
