import 'package:auto_route/auto_route.dart';
import 'package:brunstadtv_app/api/brunstadtv.dart';
import 'package:brunstadtv_app/graphql/client.dart';
import 'package:brunstadtv_app/helpers/router/redirect.dart';
import 'package:brunstadtv_app/helpers/router/router_utils.dart';
import 'package:brunstadtv_app/helpers/router/special_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class KidsSpecialRoutesHandler implements SpecialRoutesHandler {
  Ref ref;
  KidsSpecialRoutesHandler(this.ref);

  @override
  Future<bool> handle(BuildContext context, String path) async {
    if (!path.startsWith('/')) return false;
    var uri = Uri.tryParse('https://web.brunstad.tv$path');
    if (uri == null || uri.pathSegments.isEmpty) return false;

    bool handleRedirect() {
      final code = uri.pathSegments.elementAtOrNull(1);
      if (code == null) {
        throw Exception("Couldn't handle /r/ special route, missing path segments. Path: $path");
      }
      performRedirect(code: code, gqlClient: ref.read(gqlClientProvider));
      return true;
    }

    bool handleLegacy({required bool isSeriesId}) {
      final legacyIdString = uri.pathSegments.elementAtOrNull(1);
      final legacyId = int.tryParse(legacyIdString ?? '');
      if (legacyId == null) {
        debugPrint("Couldn't handle legacy program/series route, missing valid path segments. Path: $path");
        return false;
      }
      final newIdFuture = ref.read(apiProvider).legacyIdLookup(
            legacyEpisodeId: isSeriesId ? legacyId : null,
            legacyProgramId: isSeriesId ? null : legacyId,
          );
      newIdFuture.then((newId) {
        if (newId != null && context.mounted) {
          context.router.navigateNamedFromRoot('/episode/$newId?${uri.query}');
        }
      });
      return true;
    }

    switch (uri.pathSegments[0]) {
      case 'r':
        return handleRedirect();
      case 'series':
        return handleLegacy(isSeriesId: true);
      case 'program':
        return handleLegacy(isSeriesId: false);
    }
    return false;
  }
}
