{
  # std:rolling-begin
  version = "UMU-Proton-11.0-2e";
  # std:variants-begin
  variants = {
    aarch64 = {
      url = "https://github.com/Open-Wine-Components/umu-proton/releases/download/UMU-Proton-11.0-2e/UMU-Proton-11.0-2e-aarch64.tar.gz";
      hash = "sha256-iInuj27X6lbe+FbGLcdWQLeb/7bmrsSzzix+dgV78hA=";
    };
    x86_64 = {
      url = "https://github.com/Open-Wine-Components/umu-proton/releases/download/UMU-Proton-11.0-2e/UMU-Proton-11.0-2e-x86_64.tar.gz";
      hash = "sha256-j7tUrflsrJd8/c1RJJfnZyD0EZU86++nG2Y8RcGRG7Y=";
    };
  };
  # std:variants-end
  # std:rolling-end
  pins = {
    # std:pins-begin
    "UMU-Proton-10.0-4" = {
      variants = {
        x86_64 = "sha256-//emjsT3goOFPv+wZ450uqh3Y3PNW4v+SAYFNkW13UE=";
      };
    };
    "UMU-Proton-9.0-4e" = {
      variants = {
        x86_64 = "sha256-YwrDmdNEeqE4DCnfEgo1bQv0GnMqaP0PcbVyV2JLbEE=";
      };
    };
    "ULWGL-Proton-8.0-5-3" = {
      variants = {
        x86_64 = "sha256-nVs/ZOutCHYm49nT//NnjCpCHFJhh5ImQmW2YwHiQNw=";
      };
    };
    # std:pins-end
  };
}
