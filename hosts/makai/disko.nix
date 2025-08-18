{
  disko.devices = {
    disk = {
      nvme0n1 = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            swap = {
              size = "40G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            nix = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                extraArgs = ["-f"];
                mountpoint = "/nix";
                mountOptions = ["compress=zstd"];
              };
            };
          };
        };
      };

      sda = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/data";
              };
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["defaults" "size=16G" "mode=755"];
    };
  };
}
