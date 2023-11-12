import 'package:flutter/material.dart';
import 'package:villagerio/internal/data/enum/game_role_type.dart';
import 'package:villagerio/internal/data/model/game_role.dart';
import 'package:villagerio/internal/services/language.dart';
import 'package:villagerio/internal/services/list_of_role.dart';

class RoleCardModal extends StatefulWidget {
  final GameRoleStats card;
  const RoleCardModal({super.key, required this.card});

  @override
  State<RoleCardModal> createState() => _RoleCardModalState();
}

class _RoleCardModalState extends State<RoleCardModal> {
  void _switchFavorite() {
    if (widget.card.isUserFavorite) {
      ListRoleService.unsetFavorite(widget.card);
    } else {
      ListRoleService.setFavorite(widget.card);
    }
  }

  Widget _buildTextLabelBadge(Color color, Widget child,
      {bool withoutRight = false}) {
    return Padding(
      padding:
          const EdgeInsets.all(10).copyWith(right: withoutRight ? 0 : null),
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final str = LanguageService.str(context);
    final role = widget.card.role;
    final colorOpaque = Colors.black.withOpacity(0.5);
    Color typeColor;
    switch (role.type) {
      case GameRoleType.independent:
        typeColor = Colors.yellow.withOpacity(0.5);
      case GameRoleType.villagerTeam:
        typeColor = Colors.blue.withOpacity(0.5);
      case GameRoleType.werewolfTeam:
        typeColor = Colors.red.withOpacity(0.5);
      case GameRoleType.otherTeam:
        typeColor = Colors.green.withOpacity(0.5);
      default:
        typeColor = colorOpaque;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 850),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              _switchFavorite();
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              color: Colors.cyan,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTextLabelBadge(
                          typeColor, Text(role.type.getName(str))),
                      Row(
                        children: [
                          _buildTextLabelBadge(
                              colorOpaque,
                              Text((role.point >= 0 ? "+" : "") +
                                  role.point.toString()),
                              withoutRight: true),
                          _buildTextLabelBadge(
                            colorOpaque,
                            Text((role.isMultiple) ? str.multiple : str.single),
                            withoutRight: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: IconButton(
                              tooltip: str.favorite,
                              icon: Icon(
                                widget.card.isUserFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () {
                                setState(() {
                                  _switchFavorite();
                                });
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    color: colorOpaque,
                    height: 150,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            role.getName(str),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Text(
                                role.getDescription(str),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
