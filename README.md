# Zyn-Fusion Build Scripts

These are the build scripts used to generate the Zyn-Fusion packages.

These build scripts (and only these build scripts) are licensed under the
WTFPL.

-----

> [!IMPORTANT]
> This is a fork of the [Zyn-Fusion-Build](https://github.com/zynaddsubfx/zyn-fusion-build) repo,
> customized to successfully build using Ubuntu 24.04 LTS running under Windows WSL. The resulting
> package was successfully installed and tested in FL Studio running on Windows 11. This test was
> only to verify that the VST loaded and would play sounds from multiple patches.
>
> It is possible that some of the adjustments I made were unnecessary or redundant (I'm not a
> professional programmer) but the changes I made allowed the build process to complete, so I
> consider that a win!

-----

> [!IMPORTANT]
> The sections below referring to [Linux (native build)](#building-for-linux-native-build) and
> [Windows (native build via Msys2)](#building-for-windows-native-build-via-msys2) have
> **NOT** been altered from the `master` repo! This fork was created specifically for building
> using WSL (and optionally, Docker), and only the files associated with this build method have
> been modified (and tested).

-----

## Fetch repositories

> [!NOTE]
> The build process is designed to work from a `bash` shell. You will need to have a functional
> `bash` shell (using WSL on Windows, a native Linux installation, or the `Msys2` `Mingw64` terminal).

You need to fetch this repo first. In a `bash` prompt:

```shell
git clone https://github.com/djs-zmtc/zyn-fusion-build zyn-fusion-build
```
```shell
cd zyn-fusion-build
```

## How to build

Zyn-Fusion now uses Makefile. Each platform has a corresponding Makefile (`Makefile.<platform>.mk`):

| Makefile              | Target platform (Where Zyn runs) | Host platform (where compilers run) |
| --------------------- | -------------------------------- | ----------------------------------- |
| `Makefile.windows.mk` | [Windows](#building-for-windows-cross-compile-on-linux-or-wsl) | [Linux **(cross compile)**](#building-for-windows-cross-compile-on-linux-or-wsl) |
| `Makefile.mingw64.mk` | [Windows](#building-for-windows-native-build-via-msys2) | [Msys2 Mingw-w64 64 bit](#building-for-windows-native-build-via-msys2) |
| `Makefile.linux.mk`   | [Linux (native build)](#building-for-linux-native-build) | [Linux](#building-for-linux-native-build)  |

Since they are not in the default Makefile name, you need to explicitly specify them via parameter`-f` when invoking `make`.

Makefiles will automatically download ZynAddSubFX and Zest, as well as their dependencies. Then, automatically build them altogether.

**Built packages are put in directory `./build/` :**

- `./build/zyn-fusion`: Ready-to-use Zyn-Fusion files. You can directly use them as you wish, or copy this folder into your DAW's search-path.
- `./build/zyn-fusion/zyn-fusion-*.{tar.gz|zip}`:  Compressed package(s) ready for distribution.

-----

### Building for Windows (cross-compile on Linux or WSL)

> [!NOTE]
> This was tested using WSL2 on Windows 11 with Ubuntu 24.04 LTS. I have **NOT** tested
> this on a native Linux installation so I don't know if that will work properly.

```bash
# Install build dependencies
make -f Makefile.windows.mk install_deps

# Start building (creates a log file in the ./tmp folder of the build process)
PARALLEL=1 make -f Makefile.windows.mk all 2>&1 | tee -a ./tmp/compilelog-$(date "+%Y%m%dT%H%M").txt

# OR, you can also build a specific component,
# then finally use `package` to get a package file
PARALLEL=1 make -f Makefile.windows.mk zynaddsubfx
PARALLEL=1 make -f Makefile.windows.mk zest
PARALLEL=1 make -f Makefile.windows.mk package
```

-----

### Building for Windows (cross-compile using Docker)

> [!NOTE]
> This was tested using WSL2 on Windows 11 with Ubuntu 24.04 LTS and Windows Docker Desktop installed and running.

Make sure you can run docker commands from the `bash` shell:

```bash
docker version
```

Run the `build-windows.sh` script:

```bash
bash ./docker-builders/build-windows.sh
```

The resulting release ZIP will be placed in the root of the repo.

-----

### Building for Windows (native build via Msys2)

> [!IMPORTANT]
> At the time of this fork, this method doesn't seem to work!

#### Msys2 installation

You must install [Msys2](https://www.msys2.org/) first.
**Remember to always use the `Mingw64` terminal** (you can find it in Start Menu).
Any other terminal will not work.

Then finish updating the Msys installation by running in the
Mingw64 terminal: `pacman -Suy` (twice).
See https://www.msys2.org/docs/updating/ for details and https://archlinux.org/pacman/pacman.8.html for `pacman`.

#### Bootstrapping

Checking out the code:

```
pacman -S git make
git clone https://github.com/djs-zmtc/zyn-fusion-build zyn-fusion-build
cd zyn-fusion-build
```

Then install the required tools through pacman:

```
make -f Makefile.mingw64.mk install_deps
```

#### Compile ZynFusion

To compile everything:

```
make -f Makefile.mingw64.mk all
```

Alternatively you can also build a specific component, then finally use `package` to get a package file:

```
make -f Makefile.mingw64.mk zynaddsubfx
make -f Makefile.mingw64.mk zest
make -f Makefile.mingw64.mk package
```

-----

### Building for Linux (native build)

> [!NOTE]
> No changes have been made to the `Makefile.linux.mk` nor have I tested if this works on a native Linux installation.

#### Generic

```bash
# Install build dependencies
make -f Makefile.linux.mk install_deps

# Start building
PARALLEL=1 make -f Makefile.linux.mk all

# Or, you can also build a specific component,
# then finally use `package` to get a package file
PARALLEL=1 make -f Makefile.linux.mk zynaddsubfx
PARALLEL=1 make -f Makefile.linux.mk zest
make -f Makefile.linux.mk package
```

> **NOTICE:** You need to run `install-linux.sh` within the built folder to install Zyn-Fusion properly, or it won't run, moreover you'll only see a black window in your host.

-----

### Moreover

- **Build types (modes):** You can choose either `demo` or `release`, and `release` is the default. Demo build will automatically mute after 10 minutes.

  You can explicitly specify build type:

  ```bash
  make MODE=demo -f Makefile.<platform>.mk <target>
  ```

- **Get help:** You can get a list of `make` targets by invoking:

  ```bash
  make -f Makefile.<platform>.mk help
  ```
