_:

{
  programs.niri.settings.animations = {
    slowdown = 1.2;

    workspace-switch.kind.spring = {
      damping-ratio = 0.7;
      stiffness = 1200;
      epsilon = 0.0001;
    };

    window-open.kind.easing = {
      duration-ms = 350;
      curve = "ease-out-expo";
    };

    window-close.kind.easing = {
      duration-ms = 250;
      curve = "ease-out-cubic";
    };

    horizontal-view-movement.kind.spring = {
      damping-ratio = 0.8;
      stiffness = 1000;
      epsilon = 0.0001;
    };

    window-movement.kind.spring = {
      damping-ratio = 0.75;
      stiffness = 900;
      epsilon = 0.0001;
    };

    window-resize.kind.spring = {
      damping-ratio = 0.8;
      stiffness = 1100;
      epsilon = 0.0001;
    };

    config-notification-open-close.kind.spring = {
      damping-ratio = 0.5;
      stiffness = 1200;
      epsilon = 0.001;
    };

    screenshot-ui-open.kind.easing = {
      duration-ms = 300;
      curve = "ease-out-cubic";
    };

    overview-open-close.kind.spring = {
      damping-ratio = 0.75;
      stiffness = 1000;
      epsilon = 0.0001;
    };
  };
}
