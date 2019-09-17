# Code Profiling with ruby-prof

![KCachegrind](https://github.com/department-of-veterans-affairs/caseflow/raw/e80735d44228459472643820165f971b1146c06c/docs/img/Code-Profiling-KCachegrind.png)

## Overview

`ruby-prof` is one of a couple of options to profile Ruby code. It generates a document
that's viewable directly in your browser that provides a trace of a selected portion of code,
and a `callgrind` file that can be opened by an external application.

KCachegrind or QCachegrind is an alternate way to view the output of `ruby-prof`. There
are alternatives to KCachegrind and QCachegrind, but these tools are freely available and
open source. Any application that can read `callgrind` files should work! Using KCachegrind,
QCachegrind, or a similar tool is optional, but recommended!

## Installing KCachegrind / QCachegrind

### OS X

#### With brew

The easiest way to install is probably via. `brew` (untested):

```
brew install qcachegrind
```

#### Install from source

If you don't have `brew`, you can compile QCachegrind from source.

  1. Download the qt5 installer: https://download.qt.io/official_releases/qt/5.13/5.13.1/
  2. Go through the installer, and install qt5 to `/opt/Qt5.13.1`
  3. Create a soft link: `sudo ln -s /opt/Qt5.13.1/5.13.1/clang_64 /opt/qt`
  4. Download the kcachegrind source: https://github.com/KDE/kcachegrind/tree/ec8e308ddc41feeb21c84d98ef6818b3bd6aaa98
  5. Open a terminal to the kcachegrind source code, and run: `/opt/qt/bin/qmake -spec macx-clang -config release`
  6. Run `make` to build QCachegrind
  7. Copy the application to your applications directory: `cp -R qcachegrind/qcachegrind.app/ /Applications`

### Linux

#### On Ubuntu

Using apt (untested):

```
sudo apt-get install kcachegrind
```

#### On Fedora

Using dnf:

```
sudo dnf install kcachegrind
```

## Profiling a Route

## Reading the Output

## Examples

Here are some PRs that have utilized this approach to find places for performance improvements:

  - https://github.com/department-of-veterans-affairs/caseflow/pull/12084
  - https://github.com/department-of-veterans-affairs/caseflow/pull/12090
