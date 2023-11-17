import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmationModal extends StatelessWidget {
  final String? title, description;
  final Function()? onPressed;
  const ConfirmationModal({
    super.key,
    this.title,
    this.description,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(title ?? 'Logout Akun',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4.0),
              Text(description ?? 'Anda yakin ingin keluar?'),
              const SizedBox(height: 24.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.red,
                        fixedSize: const Size(100, 10)),
                    child: const Text('No',
                        style: TextStyle(color: Colors.white))),
                const SizedBox(width: 16.0),
                ElevatedButton(
                    onPressed: onPressed ??
                        () {
                          AuthLocalStorage().removeToken();
                          GoRouter.of(context)
                              .goNamed(MyRouterConstant.rootRouterName);
                        },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.white,
                        fixedSize: const Size(100, 10)),
                    child: const Text('Yes',
                        style: TextStyle(color: Colors.black)))
              ])
            ])));
  }
}
