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
              size = "16G";
              content = {
                type = "swap";
              };
            };
            nix = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                extraArgs = ["-F"];
                mountpoint = "/nix";
                mountOptions = ["noatime"];
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
                mountOptions = ["rw"];
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
