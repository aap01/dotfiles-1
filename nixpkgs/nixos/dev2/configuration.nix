{ config, lib, pkgs, common, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ../configuration-common.nix
  ];

  # Use GRUB2 as the boot loader.
  # We don't use systemd-boot because Hetzner uses BIOS legacy boot.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    devices = [ "/dev/nvme0n1" "/dev/nvme1n1" ];
  };

  # Increase the amount of inotify watchers
  # Note that inotify watches consume 1kB on 64-bit machines.
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576; # default:  8192
    "fs.inotify.max_user_instances" = 1024; # default:   128
    "fs.inotify.max_queued_events" = 32768; # default: 16384
  };

  # The mdadm RAID1s were created with 'mdadm --create ... --homehost=hetzner',
  # but the hostname for each machine may be different, and mdadm's HOMEHOST
  # setting defaults to '<system>' (using the system hostname).
  # This results mdadm considering such disks as "foreign" as opposed to
  # "local", and showing them as e.g. '/dev/md/hetzner:root0'
  # instead of '/dev/md/root0'.
  # This is mdadm's protection against accidentally putting a RAID disk
  # into the wrong machine and corrupting data by accidental sync, see
  # https://bugzilla.redhat.com/show_bug.cgi?id=606481#c14 and onward.
  # We do not worry about plugging disks into the wrong machine because
  # we will never exchange disks between machines, so we tell mdadm to
  # ignore the homehost entirely.
  environment.etc."mdadm.conf".text = ''
    HOMEHOST <ignore>
  '';
  # The RAIDs are assembled in stage1, so we need to make the config
  # available there.
  boot.initrd.services.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;

  networking.hostName = "dev2";
  # Network (Hetzner uses static IP assignments, and we don't use DHCP here)
  networking.useDHCP = false;
  networking.interfaces."enp7s0".ipv4.addresses = [
    {
      address = "195.201.193.171";
      prefixLength = 24;
    }
  ];
  networking.interfaces."enp7s0".ipv6.addresses = [
    {
      address = "2a01:4f8:13a:194a::1";
      prefixLength = 64;
    }
  ];
  networking.defaultGateway = "195.201.193.129";
  networking.defaultGateway6 = { address = "fe80::1"; interface = "enp7s0"; };
  networking.nameservers = [ "8.8.8.8" ];
  networking.firewall = {
    enable = true;
    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];
    # allow you to SSH in over the public internet
    allowedTCPPorts = [ 22 ];
    # Needed by Tailscale to allow for exit nodes and subnet routing
    checkReversePath = "loose";

    # Needed to stop Docker from exposing ports despite the firewall
    # See https://github.com/NixOS/nixpkgs/issues/111852
    extraCommands = ''
      iptables -N DOCKER-USER || true
      iptables -F DOCKER-USER
      iptables -A DOCKER-USER -i enp7s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
      iptables -A DOCKER-USER -i enp7s0 -j DROP
    '';
  };


  # only allow access via tailscale
  services.openssh.openFirewall = false;

  users.users.schickling = {
    isNormalUser = true;
    home = "/home/schickling";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      # "podman"
    ];
    openssh.authorizedKeys.keys = common.sshKeys;
  };

  virtualisation.docker = {
    enable = true;
  };

  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   dockerSocket.enable = true;
  # };

  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryFlavor = "tty";
  # };

  # needed for nix-direnv
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true

    experimental-features = nix-command flakes
  '';

  # enable the tailscale daemon; this will do a variety of tasks:
  # 1. create the TUN network device
  # 2. setup some IP routes to route through the TUN
  services.tailscale.enable = true;

  # FIXME
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?

}
