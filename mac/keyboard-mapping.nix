{
  enable = true;
  config = {
    Label = "org.user.keyboard-mapping";
    ProgramArguments = [
      "/usr/bin/hidutil"
      "property"
      "--set"
      (builtins.toJSON {
        UserKeyMapping = [
          {
            HIDKeyboardModifierMappingSrc = 30064771129; # Caps Lock
            HIDKeyboardModifierMappingDst = 30064771113; # Escape
          }
          {
            HIDKeyboardModifierMappingSrc = 30064771113; # Escape
            HIDKeyboardModifierMappingDst = 30064771129; # Caps Lock
          }
        ];
      })
    ];
    RunAtLoad = true;
    StandardErrorPath = "/tmp/keyboard-swap.err";
    StandardOutPath = "/tmp/keyboard-swap.out";
  };
}
