import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/todo.dart';
import '../../../data/repositories/todos_repository.dart';

part 'add_todo_event.dart';
part 'add_todo_state.dart';

class AddTodoBloc extends Bloc<AddTodoEvent, AddTodoState> {
  AddTodoBloc({
    required TodosRepository todosRepository,
    required Todo? initialTodo,
  })  : _todosRepository = todosRepository,
        super(
          AddTodoState(
            initialTodo: initialTodo,
            title: initialTodo?.title ?? '',
            deadline: initialTodo?.deadline,
            category: initialTodo?.category,
          ),
        ) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditSelectedCategory>(_onCategoryChanged);
    on<EditTodoDeadlineChanged>(_onDeadlineChanged);
    on<EditTodoSubmitted>(_onSubmitted);
  }

  final TodosRepository _todosRepository;

  void _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<AddTodoState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onCategoryChanged(
    EditSelectedCategory event,
    Emitter<AddTodoState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  void _onDeadlineChanged(
    EditTodoDeadlineChanged event,
    Emitter<AddTodoState> emit,
  ) {
    emit(state.copyWith(deadline: event.deadline));
  }

  Future<void> _onSubmitted(
    EditTodoSubmitted event,
    Emitter<AddTodoState> emit,
  ) async {
    emit(state.copyWith(status: EditTodoStatus.loading));

    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
        title: state.title,
        deadline: state.deadline,
        category: state.category,
        isCompleted: state.isCompleted);

    try {
      await _todosRepository.saveTodo(todo);
        emit(const AddTodoState(status: EditTodoStatus.success,
            title: "", category: null, deadline: null, initialTodo: null));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}
