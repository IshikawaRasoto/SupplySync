import 'package:get_it/get_it.dart';
import 'package:supplysync/core/api/api_service.dart';
import 'package:supplysync/auth/data/repositories/auth_repository_impl.dart';
import 'package:supplysync/user_actions/domain/use_cases/user_get_user_by_user_name.dart';
import 'package:supplysync/user_actions/domain/use_cases/user_update_profile.dart';

import 'auth/data/source/auth_remote_data_source.dart';
import 'auth/domain/repositories/auth_repository.dart';
import 'auth/presentation/blocs/auth_bloc.dart';
import 'auth/domain/use_cases/user_login.dart';
import 'auth/domain/use_cases/user_logout.dart';
import 'core/common/cubit/user/user_cubit.dart';
import 'user_actions/data/repositories/user_actions_repository_impl.dart';
import 'user_actions/data/source/user_actions_remote_data_source.dart';
import 'user_actions/domain/repositories/user_actions_repository.dart';
import 'user_actions/presentation/blocs/user_actions_bloc.dart';
import 'user_actions/presentation/blocs/user_request_bloc.dart';

part 'init_dependencies.dart';
