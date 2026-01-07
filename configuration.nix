{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.kernelParams = [ "console=ttyS0,115200n8" ];
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.miguel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$6$AsTOJpwTSLO/njOS$uovfoCmMk5oX27igKI2PRlfFB/Wukz.lacJjrMHixPRUmytsng.m4pzvQmIGB2xD0agc1CjhahcTJhNAT/vxa0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNcUSkx11fiGy0VjQD1vr+6kWmXdXxB88lG/6OycxDe somekey"
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxR0UVuMvg66qPSp2jgvzt2AllaOXnSuv7oiXiLuAoy miguel@nixos"
  ] ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "25.11";
}
