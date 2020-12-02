# SailfishOS Builds in Docker

The canonical home page of this project is https://git.sr.ht/~aerique/sfosbid

(The library is also pushed to GitLab and GitHub but those sites are not
monitored for support.)

## TL;DR

- `./download.sh`
- `./build.sh`
- `./run.sh`

## To Do

- [X] use `curl` instead of `wget`
- [X] optimize RPM-to-phone workflow
- [X] mount an external `projects` directory and add it to `.gitignore`?
- [ ] make getting specific versions of rootfs, tooling and targets easier

## Introduction

So here's yet another build environment for SailfishOS in Docker. Why?

Basically the others were either too dangerous or too complicated for me
or I just could not use them.

Here's hyperlinks to the alternatives that I know off and might be
better suited for you:

- https://github.com/SfietKonstantin/docker-sailfishos-sdk
- https://github.com/vranki/sailfishdockersdk
- https://github.com/evilJazz/sailfishos-buildengine
- https://github.com/CODeRUS/docker-sailfishos-buildengine

"Sailfish Builds in Docker" is inspired on SfietKonstantin's work. I
initially used his version but after I was not careful and blew my
`/dev` away I decided to roll my own after looking at the source of the
alternatives. I felt the `Dockerfile` and helper scripts could be much
simpler for my purposes.

vranki's version came the closest to what I was looking for but I only
found it after I was almost finished.

evilJazz's and CODeRUS's implementations look the most mature but they
require one to install the SDK and a lot of handywork. They will
probably work better for more serious and bigger projects but I cannot
install the SDK because it depends on a very old version of OpenSSL
which I'm not prepared to install (and then forget to remove
again). Also, for my Linux distro (Void Linux) it is not just a matter
of running the package manager since it only comes with LibreSSL.

## Goal

An environment for building SailfishOS projects in Docker, initially
specifically [eql5-sfos](https://redmine.casenave.fr/projects/eql5-sfos/)
and work from there.

The Dockerfile should be as simple as needed and not depend on bind
mounts and root access to system files on the host environment. It
should also not depend on installing the Sailfish SDK.

My goal is building Sailfish apps using Common Lisp (using the ECL
implementation that is available on OpenRepos).

## Testing

First download the root fs, tooling and targets using `./download.sh`
and then build the Docker image using `./build.sh`.

Start a Docker container from the build image with `./run.sh`, then:

```
[nemo@<<container-id>> ~]$ git clone https://github.com/sailfishos/cppqml-sample
[nemo@<<container-id>> ~]$ cd cppqml-sample/
[nemo@<<container-id>> cppqml-sample]$ mb2 -t SailfishOS-latest-armv7hl build
```

If successful you will have an RPM inside the `RPMS` directory of the
project. **Do not exit the Docker container but open a new shell.** To
copy this RPM to your phone do the following on the host in the new
shell (so **not** in the Docker container):

- `docker cp <<container-id>>:/home/nemo/cppqml-sample/RPMS/cppqml-1.0-1.armv7hl.rpm .` (the exact name of the RPM can differ)
    - the container ID is shown in the shell prompt when inside the
      container or can be obtained using `docker ps`
- `scp cppqml-1.0-1.armv7hl.rpm nemo@192.168.2.15:` (use whatever IP
  your phone is reachable on)
- `ssh nemo@192.168.2.15`
    - `devel-su pkcon install-local cppqml-1.0-1.armv7hl.rpm` (execute
      this on your phone)

You should now have `cppqml` in your app grid. It can be deleted through
the phone UI (same as how you remove other apps) or with `pkcon`.

## `eql5-sfos`

- https://redmine.casenave.fr/projects/eql5-sfos/repository/44/revisions/master/show

(Inside the Docker container:)

```
$ git clone https://redmine.casenave.fr/sfos/eql5-sfos.git
$ cd eql5-sfos
$ sb2 -t SailfishOS-latest-armv7hl -m sdk-install -R
    # rpm --import https://sailfish.openrepos.net/openrepos.key
    # zypper ar -f https://sailfish.openrepos.net/razcampagne/personal-main.repo
    # zypper in eql5
    # exit
$ sb2 -t SailfishOS-latest-armv7hl -m sdk-build -R
    # qmake
    # make
$ mb2 -t SailfishOS-latest-armv7hl build
```

If the `qmake` and `make` are not done above, the `mb2 build` errors
out.

One can save the current EQL5 state with `docker commit <<container-id>>
<<tag>>` from another shell.

## `deploy-rpm-to-phone.sh`

You can use this script to avoid most of the manual steps described in
"Testing". Run the script without any arguments to see its usage.

It's best to have another terminal open with an open SSH connection to
the phone and then do a plain `devel-su` in the directory where the RPM
is copied to. Have a `pkcon -y install-local RPM` command ready so you
can just get it from your commandline history and press Enter.

The holy gradle would be to have the `pkcon install-local` step
automated as well.

### SSH Public Key Authentication

Please see: https://www.ssh.com/ssh/public-key-authentication/
