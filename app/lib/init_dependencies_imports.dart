import 'package:get_it/get_it.dart';

import 'core/data/api_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/source/auth_remote_data_source.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/use_cases/user_get_user.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/domain/use_cases/user_login.dart';
import 'features/auth/domain/use_cases/user_logout.dart';
import 'core/common/cubit/user/user_cubit.dart';
import 'features/user_actions/data/repositories/user_actions_repository_impl.dart';
import 'features/user_actions/data/source/user_actions_remote_data_source.dart';
import 'features/user_actions/domain/repositories/user_actions_repository.dart';
import 'features/user_actions/domain/use_cases/user_get_user_by_user_name.dart';
import 'features/user_actions/domain/use_cases/user_register_user.dart';
import 'features/user_actions/domain/use_cases/user_update_profile.dart';
import 'features/user_actions/presentation/blocs/user_actions_bloc.dart';
import 'features/user_actions/presentation/blocs/user_request_bloc.dart';

part 'init_dependencies.dart';
