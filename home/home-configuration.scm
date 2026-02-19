;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services)
             (gnu home services shells)
             (gnu home services desktop)
             (gnu home services sound)
             (gnu home services niri))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (specifications->packages (list "chezmoi"
                                            "nushell"
                                            "jujutsu"
                                            "git"
                                            "podman"
                                            "kubectl"
                                            "rust"
                                            "rust:cargo"
                                            "rust-analyzer"
                                            "go@1.25.5"
                                            "gopls"
                                            "node")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (append (list (service home-bash-service-type
                          (home-bash-configuration
                           (aliases '(("grep" . "grep --color=auto")
                                      ("ip" . "ip -color=auto")
                                      ("ll" . "ls -l")
                                      ("ls" . "ls -p --color=auto")
                                      ("update-home" . "guix home reconfigure ~/guix-config/home/home-configuration.scm")
                                      ("update-system" . "sudo guix system reconfigure ~/guix-config/systems/stormrage.scm")))
                           (environment-variables '(("GUIX_PACKAGE_PATH" . "$HOME/guix-config")
                                                    ("EDITOR" . "emacs -nw")))))

                 ;; https://guix.gnu.org/manual/devel/en/html_node/Niri-window-manager.html
                 ;; Check %HOME/.local/share/wayland-sessions/niri.desktop for new entry after guix home reconfigure
                 (service home-niri-service-type)
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 (simple-service 'flatpak-env
                                 home-environment-variables-service-type
                                 `(("XDG_DATA_DIRS" . "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share"))))
           %base-home-services)))
