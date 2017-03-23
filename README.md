# FreeBSD-Custom-ThinkPad

Customized FreeBSD 11 for ThinkPad laptops 🐅

As was [once said by someone on the OpenBSD mailing lists](http://marc.info/?l=openbsd-misc&m=145358748924473&w=4);

>Customization breeds bugs and hurts interoperability.

## PRE-RELEASE ⚠️

Not ready for the general public.

## Download

[![Download custom memstick image PRE-RELEASE][msimgdl]][msimg]

## Targeted ThinkPad models

* Lenovo ThinkPad T520
  - http://www.thinkwiki.org/wiki/Category:T520
  - https://support.lenovo.com/us/en/solutions/pd015761

* Lenovo ThinkPad X220 Tablet
  - http://www.thinkwiki.org/wiki/Category:X220_Tablet
  - https://support.lenovo.com/us/en/solutions/pd015807

## Installation procedure

1. [Download custom memstick image][msimg], or [build the custom memstick image from source yourself](docs/build.md).
2. Write custom memstick image to memory stick using e.g. `dd if=eriknstr-bsd-0.0.0-memstick.img of=/dev/xxx bs=16m`, where `xxx` is the device id of your memory stick as found by for example `gpart show` on FreeBSD.
3. Boot your ThinkPad from the memory stick.
4. The installer will guide you through the rest. Further documentation on the installation process is [available should you need it](docs/guided_install.md).

## Copyright and license

The FreeBSD source tree which is included in this repository as a subtree
under the `FreeBSD` directory under the root of this repository
has it's copyright and license details available in the `COPYRIGHT`
file in the root of the `FreeBSD` directory.

Subportions of the FreeBSD source tree have copyright and license details
that differ from the information given in the above mentioned `COPYRIGHT`
file. In such cases the files in question are marked with the relevant
copyright and license details either inside of the files themselves
or in license files in a parent directory.

Everything else in this repository outside of the above metioned directory
has it's copyright and license details available in the file `LICENSE`
in the root of the repository.

[msimgdl]: https://github.com/eriknstr/FreeBSD-Custom-ThinkPad/releases/download/v0.0.0/msimgdl.png
[msimg]: https://github.com/eriknstr/FreeBSD-Custom-ThinkPad/releases/download/v0.0.0/eriknstr-bsd-0.0.0-memstick.img
