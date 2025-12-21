(define-module (systems stormrage)
  #:use-module (gnu)
  #:use-module (guix)
  #:use-module (nongnu packages linux))

(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "Europe/Paris")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "stormrage")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "malfurion")
                  (comment "Malfurion")
                  (group "users")
                  (home-directory "/home/malfurion")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "openssh")
                          (specification->package "openssl")
                          (specification->package "emacs")
                          (specification->package "emacs-meow")
                          (specification->package "niri")
                          (specification->package "fuzzel")
                          (specification->package "waybar")
                          (specification->package "flatpak")
                          ) %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service gnome-desktop-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           %desktop-services))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "5cdc3555-3cc4-460c-873f-ea3419bf72ec"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "DCD8-134A"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems)))
