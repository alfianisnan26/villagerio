import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:villagerio/internal/data/enum/filter_game_role.dart';
import 'package:villagerio/internal/data/enum/game_role_type.dart';
import 'package:villagerio/internal/data/enum/sort_game_role_type.dart';
import 'package:villagerio/internal/data/model/game_role.dart';
import 'package:villagerio/internal/pkg/logger/logger.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/services/list_of_role.dart';
import 'package:villagerio/internal/ui/modules/role_card.dart';

final _log = InternalLogger.instance;

class ListOfRolePage extends StatefulWidget {
  final List<GameRoleStats>? roles;
  final BuildContext? parentContext;
  const ListOfRolePage({super.key, this.parentContext, this.roles});

  @override
  State<ListOfRolePage> createState() => _ListOfRolePageState();
}

class _ListOfRolePageState extends State<ListOfRolePage> {
  bool _isDescending = false;
  bool _isGrid = false;
  SortGameRoleType _sortType = SortGameRoleType.name;
  FilterGameRoleType _filterType = FilterGameRoleType.all;
  late TextEditingController _tec;

  @override
  void initState() {
    _tec = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _tec.dispose();
    super.dispose();
  }

  Widget _buildFilteredListCarousel(
      BuildContext context, List<GameRoleStats> data, double height) {
    final str = LanguageService.str(context);
    final filteredList = data.where((element) {
      final search = element.role
          .getName(str)
          .toLowerCase()
          .contains(_tec.text.toLowerCase());

      bool filter = true;
      switch (_filterType) {
        case FilterGameRoleType.independent:
          filter = element.role.type == GameRoleType.independent;
          break;
        case FilterGameRoleType.myFavorite:
          filter = element.isUserFavorite;
          break;
        case FilterGameRoleType.otherTeam:
          filter = element.role.type == GameRoleType.otherTeam;
          break;
        case FilterGameRoleType.villagerTeam:
          filter = element.role.type == GameRoleType.villagerTeam;
          break;

        case FilterGameRoleType.werewolfTeam:
          filter = element.role.type == GameRoleType.werewolfTeam;
          break;
        case FilterGameRoleType.all:
        default:
      }

      return (_tec.text.isNotEmpty ? search : true) && filter;
    }).toList();
    filteredList.sort((i, j) {
      GameRoleStats a, b;

      if (_isDescending) {
        b = i;
        a = j;
      } else {
        a = i;
        b = j;
      }

      switch (_sortType) {
        case SortGameRoleType.played:
          return a.countUsed.compareTo(b.countUsed);
        case SortGameRoleType.points:
          return a.role.point.compareTo(b.role.point);
        case SortGameRoleType.favorite:
          return a.countFavorite.compareTo(b.countFavorite);
        case SortGameRoleType.name:
        default:
      }
      return a.role.getName(str).compareTo(b.role.getName(str));
    });

    if (filteredList.isEmpty) {
      return SizedBox(
          height: height, child: Center(child: Text(str.awSnapNotFound)));
    }

    return CarouselSlider.builder(
        itemCount: filteredList.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            RoleCardModal(card: filteredList[itemIndex]),
        options: CarouselOptions(
            padEnds: false,
            enableInfiniteScroll: false,
            aspectRatio: 3 / 4,
            enlargeCenterPage: false,
            scrollDirection: Axis.vertical,
            height: height));
  }

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);

    // filter and sort here
    return Scaffold(
        appBar: widget.parentContext != null ? null : AppBar(),
        body: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: Column(
              children: [
                Material(
                  elevation: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tec,
                            onChanged: (v) => setState(() {}),
                            maxLength: 50,
                            decoration: InputDecoration(
                                hintText: "${str.searchSomething}...",
                                border: InputBorder.none,
                                counterText: "",
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: _tec.text.isEmpty
                                      ? null
                                      : () => setState(() {
                                            _tec.clear();
                                          }),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        PopupMenuButton<FilterGameRoleType>(
                            position: PopupMenuPosition.under,
                            onSelected: (v) => setState(() {
                                  _filterType = v;
                                }),
                            tooltip: str.filter,
                            icon: const Icon(Icons.filter_alt),
                            itemBuilder: (context) {
                              return FilterGameRoleType.values
                                  .map((e) => PopupMenuItem(
                                      value: e,
                                      child: Text(e.toStringLang(str))))
                                  .toList(growable: false);
                            }),
                        const SizedBox(
                          width: 10,
                        ),
                        PopupMenuButton(
                            position: PopupMenuPosition.under,
                            onSelected: (v) {
                              if (v is bool) {
                                setState(() {
                                  _isDescending = !_isDescending;
                                });
                              } else if (v is SortGameRoleType) {
                                setState(() {
                                  _sortType = v;
                                });
                              }
                            },
                            tooltip: str.sort,
                            icon: const Icon(Icons.sort),
                            itemBuilder: (context) {
                              final options = SortGameRoleType.values
                                  .map<PopupMenuEntry>((e) => PopupMenuItem(
                                      value: e,
                                      child: Text(e.toStringLang(str))))
                                  .toList();
                              options.add(const PopupMenuDivider());
                              options.add(PopupMenuItem(
                                  value: true,
                                  enabled: _isDescending,
                                  child: Text(str.ascending)));
                              options.add(PopupMenuItem(
                                  value: true,
                                  enabled: !_isDescending,
                                  child: Text(str.descending)));
                              return options;
                            }),
                        IconButton(
                            onPressed: null, // not yet available
                            icon: Icon(
                              !_isGrid ? Icons.grid_on : Icons.list,
                            ))
                      ],
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: widget.roles != null
                      ? _buildFilteredListCarousel(
                          context, widget.roles!, constraints.maxHeight - 50)
                      : FutureBuilder(
                          future: ListRoleService.getRoleStats(),
                          builder: (context, ss) {
                            final height = constraints.maxHeight - 50;
                            if (!ss.hasData) {
                              return SizedBox(
                                height: height,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            }

                            return _buildFilteredListCarousel(
                                context, ss.data!, height);
                          }),
                ),
              ],
            ),
          );
        }));
  }
}
