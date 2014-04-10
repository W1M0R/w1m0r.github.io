// Temporary, please follow:
// https://github.com/angular/angular.dart/issues/476
// https://code.google.com/p/dart/issues/detail?id=14686

// I really have no idea how to use this, even after reading the various docs online.
/*@MirrorsUsed(
targets: const ['angular_dynamic'],
override: '*')
import 'dart:mirrors';*/

/*
@MirrorsUsed(targets: const[
    'angular.core.annotation', // Does not resolve NgOneWayOneTime error.
    'angular.core_dynamic', // Resolves DynamicMetadataExtractor error.
  ],
  override: '*')
import 'dart:mirrors';
*/

/*
@MirrorsUsed(targets: const[
    'angular.app.dynamic',
    'dirty_checking_change_detector_dynamic',                   
    'angular.core.parser_dynamic',
    'angular.core_dynamic', // Resolves DynamicMetadataExtractor error.
  ],
  override: '*')
import 'dart:mirrors';
*/

import 'package:angular/angular.dart';
import 'package:angular/angular_dynamic.dart';

import 'package:logging/logging.dart';

import 'dart:html';
import 'dart:js' as js;
import 'dart:math' as Math;

import 'dart:async';

class AppNgModule extends Module {
  AppNgModule() {
    type(AppNgCtrlMain);
    type(AppNgCtrlAnimSvg);
    type(RouteInitializerFn, implementedBy: AppNgRouteInitializer);
    factory(NgRoutingUsePushState, (_) => new NgRoutingUsePushState.value(false));
  }
}

class AppNgRouteInitializer {

  AppNgRouteInitializer();

  call(Router router, RouteViewFactory views) {
    views.configure({
        'default': ngRoute(
            defaultRoute: true,
            enter: (RouteEnterEvent e) => router.go('welcome', {}, startingFrom: router.root, replace: true)
            ),
        'welcome': ngRoute(      
            path: '/welcome',
            view: 'routes/welcome.html'
            ),
      });
  }
}

@NgController(selector: '[app-ng-ctrl-main]', publishAs: 'index')
class AppNgCtrlMain {
  AppNgCtrlMain();
}

@NgController(selector: '[app-ng-ctrl-anim-svg]', publishAs: 'svg')
class AppNgCtrlAnimSvg {
  Element _svg;
  AppNgCtrlAnimSvg(Element element) {
    this._svg = element;
    new Timer.periodic(new Duration(seconds: 10), (Timer t) => animate());
  }

  animate() {
    animateJsSvg(_svg, 0.5, 0.03);
  }
  
  onClick() {
    animate();
  }
  
  animateJsSvg(var svg, ratio1, ratio2) {
    Logger.root.log(Level.FINEST, "let's animate");
    js.context.callMethod("svgAnimate", [svg, (path, whoknows1, whoknows2) {
      var length = path.getTotalLength();
      return Math.pow(length, ratio1) * ratio2;
    }]);
  }
  
}

void main() {
  //Logger.root..level = Level.FINEST..onRecord.listen((LogRecord r) { print(r.message); });
  dynamicApplication().addModule(new AppNgModule()).run();
}