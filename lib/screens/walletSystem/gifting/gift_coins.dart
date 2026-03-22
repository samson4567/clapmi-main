import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/Models/search/user_search.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/brag_video_control/data/models/user_model.dart';
import 'package:clapmi/features/search/presentation/blocs/search_bloc.dart';
import 'package:clapmi/features/wallet/domain/entities/gift_user.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_bloc.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_event.dart';
import 'package:clapmi/features/wallet/presentation/blocs/user_bloc/wallet_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class GiftCoins extends StatefulWidget {
  const GiftCoins({super.key});

  @override
  State<GiftCoins> createState() => _GiftCoinsState();
}

class _GiftCoinsState extends State<GiftCoins> {
  final TextEditingController _searchController = TextEditingController();
  String paymentMethod = 'Debit Card';
  int selectedPoint = 50;
  late FocusNode _focusNode;
  List<UserModel> filteredUserList = [];
  List<UserSearch> searchedUsers = [];
  String selectedPId = '';
  String currentAmount = '0.00';
  String selectedName = '';
  bool isLoading = false;

  bool filterUser(UserModel userModel) {
    return ((userModel.name?.contains(_searchController.text) ?? false) ||
        (userModel.username?.contains(_searchController.text) ?? false) ||
        (userModel.email?.contains(_searchController.text) ?? false));
  }

  @override
  void initState() {
    context.read<WalletBloc>().add(GetAvailableCoinEvent());
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchLoaded) {
          print('searchLoaded is the thing ${state.users}');
          searchedUsers = state.users;
        }
      },
      builder: (context, state) {
        return BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is GiftUserErrorState) {
              setState(() {
                isLoading = false;
              });
            }
            if (state is GiftUserSuccessState) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
              searchedUsers.clear();
              context.push(MyAppRouteConstant.giftingSuccessful,
                  extra: {'name': selectedName, 'coin': selectedPoint});
            }

            if (state is AvailableClappCoinLoaded) {
              currentAmount = state.amount;
            }
            if (state is GiftUserLoadingState) {
              setState(() {
                isLoading = true;
              });
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(MediaQuery.paddingOf(context).top + 16),
                    Row(
                      children: [
                        InkWell(
                          onTap: context.pop,
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                          ),
                        ),
                        const Gap(8),
                        Image.asset(
                          'assets/images/gift.png',
                          height: 40,
                          width: 40,
                        ),
                        const Gap(8),
                        Text(
                          'Gift ',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          ' Points',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 8),
                            child: Row(
                              children: [
                                //**THE SESSION THAT HAS THE PROFILE PICTURES AND THE LIKES */
                                profileModelG?.myAvatar != null
                                    ? Container(
                                        height: 40.w,
                                        width: 40.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: MemoryImage(
                                                    profileModelG!.myAvatar!))),
                                      )
                                    : CustomImageView(
                                        height: 35.w,
                                        width: 35.w,
                                        radius: BorderRadius.circular(25),
                                        imagePath: profileModelG?.image ?? '',
                                      ),

                                // Image.asset(
                                //     'assets/images/buy_points.png'),

                                const Gap(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${profileModelG?.name ?? profileModelG?.username}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 13,
                                            color: const Color(0xFF8F9090),
                                          ),
                                    ),
                                    const Gap(8),
                                    Row(children: [
                                      ClipOval(
                                        child: Image.asset(
                                          'assets/images/coin_big.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                      const Gap(2),
                                      Text(
                                        '${double.tryParse(currentAmount)?.toStringAsFixed(2) ?? 0.00}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 23,
                                            ),
                                      ),
                                      Text(
                                        'CAPP',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 23,
                                            ),
                                      )
                                    ]),
                                    const Gap(8),
                                    Text(
                                      '\$ ${(double.tryParse(currentAmount)!.toDouble() / 100).toStringAsFixed(2)} USD',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 13,
                                            color: const Color(0xFF8F9090),
                                          ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Gap(16),
                          Text(
                            'Select points',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.greyTextColorVariant,
                                    ),
                          ),
                          const Gap(20),
                          Row(
                            children: [
                              _pointWidget(
                                context,
                                onTap: () {
                                  setState(() {
                                    selectedPoint = 50;
                                  });
                                },
                                point: 50,
                                amount: 50 / 100,
                                isSelected: selectedPoint == 50,
                              ),
                              const Gap(12),
                              _pointWidget(
                                context,
                                onTap: () {
                                  setState(() {
                                    selectedPoint = 200;
                                  });
                                },
                                point: 200,
                                amount: 200 / 100,
                                isSelected: selectedPoint == 200,
                              ),
                              const Gap(12),
                              _pointWidget(
                                onTap: () {
                                  setState(() {
                                    selectedPoint = 450;
                                  });
                                },
                                context,
                                point: 450,
                                amount: 450 / 100,
                                isSelected: selectedPoint == 450,
                              ),
                            ],
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              _pointWidget(
                                context,
                                onTap: () {
                                  setState(() {
                                    selectedPoint = 700;
                                  });
                                },
                                point: 700,
                                amount: 700 / 100,
                                isSelected: selectedPoint == 700,
                              ),
                              const Gap(12),
                              _pointWidget(
                                context,
                                onTap: () {
                                  setState(() {
                                    selectedPoint = 1400;
                                  });
                                },
                                point: 1400,
                                amount: 1400 / 100,
                                isSelected: selectedPoint == 1400,
                              ),
                              const Gap(12),
                              _pointWidget(
                                onTap: () {
                                  setState(() {
                                    selectedPoint = 3500;
                                  });
                                },
                                context,
                                point: 3500,
                                amount: 3500 / 100,
                                isSelected: selectedPoint == 3500,
                              ),
                            ],
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              _pointWidget(
                                context,
                                onTap: () {
                                  setState(() {
                                    selectedPoint = 7000;
                                  });
                                },
                                point: 7000,
                                amount: 7000 / 100,
                                isSelected: selectedPoint == 7000,
                              ),
                              const Gap(12),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedPoint = 0;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        width: 1.5,
                                        color: selectedPoint == 0
                                            ? AppColors.primaryColor
                                            : const Color(0xFF3D3D3D),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/coin_big.png',
                                              height: 24,
                                              width: 24,
                                            ),
                                            const Gap(8),
                                            Text(
                                              'Custom',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                            ),
                                          ],
                                        ),
                                        const Gap(12),
                                        Container(
                                          height: 30,
                                          padding: const EdgeInsets.fromLTRB(
                                              24, 0, 24, 12),
                                          child: TextField(
                                            focusNode: _focusNode,
                                            //controller: s,
                                            onTapOutside: (_) {
                                              _focusNode.unfocus();
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                selectedPoint =
                                                    int.tryParse(value) ?? 0;
                                              });
                                            },
                                            onTap: () {
                                              setState(() {
                                                selectedPoint = 0;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Enter Amount',
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors
                                                        .greyTextColorVariant,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.greyTextColorVariant,
                                    ),
                              ),
                              const Gap(8),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF121212),
                                    border: Border.all(
                                        color: const Color(0xFF3D3D3D),
                                        width: .25),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      print(
                                          'This is the value in the textField $value');
                                      context
                                          .read<SearchBloc>()
                                          .add(SearchUsersEvent(value));
                                    },
                                  )),
                              if (searchedUsers.isNotEmpty)
                                SizedBox(
                                  width: double.infinity,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: searchedUsers.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    searchedUsers[index].image),
                                          ),
                                          title: Text(
                                            searchedUsers[index].username,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          subtitle:
                                              Text(searchedUsers[index].name),
                                          onTap: () {
                                            setState(() {
                                              _searchController.text =
                                                  searchedUsers[index].username;
                                              selectedPId =
                                                  searchedUsers[index].pid;
                                              selectedName =
                                                  searchedUsers[index].username;
                                              searchedUsers.clear();
                                            });
                                          },
                                        );
                                      }),
                                ),
                              Gap(8),
                            ],
                          ),
                          const Gap(30),
                          InkWell(
                            onTap: () {
                              context.read<WalletBloc>().add(GiftUserEvent(
                                  giftClapPointRequestEntity: GiftUserEntity(
                                      type: 'standard',
                                      to: selectedPId,
                                      amount: selectedPoint,
                                      password: '')));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: AppColors.primaryColor),
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator.adaptive(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Gift',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                            ),
                          ),
                          const Gap(30),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget _pointWidget(
  BuildContext context, {
  int point = 0,
  double amount = 0,
  bool isCustom = false,
  bool isSelected = false,
  required Function() onTap,
}) =>
    Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1.5,
              color:
                  isSelected ? AppColors.primaryColor : const Color(0xFF3D3D3D),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/coin_big.png',
                    height: 24,
                    width: 24,
                  ),
                  const Gap(8),
                  Text(
                    isCustom ? 'Custom' : point.toString(),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
              const Gap(12),
              Text(
                isCustom ? 'Enter Amount' : '\$$amount USD',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 13,
                      color: const Color(0xFF8F9090),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
