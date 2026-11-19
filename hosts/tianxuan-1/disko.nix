{
  disko.devices = {
    disk = {
      ssd = {
        device = "/dev/disk/by-id/ata-Micron_1300_SATA_256GB_2031298C49FA";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
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

      hdd = {
        device = "/dev/disk/by-id/ata-ST2000DM008-2FR102_ZFL2BVB3";
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
