(define-module (packages pulumi)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages elf)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module ((guix build utils)
                #:select (modify-phases ))
  #:use-module ((guix licenses)
                #:prefix license:))

(define-public pulumi
  (package
    (name "pulumi")
    (version "3.219.0")
    (source
     (origin
       (method url-fetch/tarbomb)
       (uri (string-append "https://get.pulumi.com/releases/sdk/pulumi-v"
                           version "-linux-x64.tar.gz"))
       (sha256
        (base32 "1mr8qyzsk4chd7yqmzi7azz0nqn75fdrcbkfca4vds36bppqc3fk"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("pulumi/" "bin/"))
       #:phases (modify-phases %standard-phases
                  (add-after 'install 'patch-rpath
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (libgcc (assoc-ref inputs "libgcc")))
                        (invoke "patchelf" "--set-rpath"
                                (string-append libgcc "/lib:" out "/lib")
                                (string-append out "/bin/pulumi-watch"))))))))
    (inputs `(("libgcc" ,gcc "lib")))
    (native-inputs `(("patchelf" ,patchelf)))
    (synopsis "Pulumi CLI for infrastructure as code")
    (description
     "Pulumi is an infrastructure as code tool that allows you to define cloud resources using general-purpose programming languages.")
    (home-page "https://www.pulumi.com/")
    (license license:expat)))

pulumi
