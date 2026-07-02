import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      // padding: const EdgeInsets.all(2),
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _itemMenu(
            icon: SvgPicture.asset(
              AppAssetIcon.favourite,
              width: 40,
              height: 40,
            ),
            title: 'Yêu thích',
            onTap: () {},
          ),
          _itemMenu(
            icon: SvgPicture.asset(
              AppAssetIcon.bookopenIcon,
              width: 40,
              height: 40,
            ),
            title: 'Tra lỗi sai',
            onTap: () {},
          ),
          _itemMenu(
            icon: SvgPicture.asset(
              AppAssetIcon.statisticsIcon,
              width: 40,
              height: 40,
            ),
            title: 'Thống kê',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _itemMenu({
    required Widget icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      // borderRadius: BorderRadius.circular(16),

      // elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),

        // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
