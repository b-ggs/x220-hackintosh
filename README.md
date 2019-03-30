# macOS Mojave on the ThinkPad X220

a.k.a. macOS budget meal

![img][img]

## Introduction (and warnings!)

This guide specifically has not been tested extensively nor is it written to be an exhaustive guide for installing macOS Mojave. This works on my personal X220. YMMV.

A more complete guide can be found at [John McDonnell's page][mcdonnell] dedicated to installing macOS High Sierra on the X220. Huge props to him for supporting the X220 all these years.

Also, a lot of things don't work (at least not without additional configuration): iMessage, FaceTime, Continuity, Handoff, Metal, among others.

### Versions tested

* macOS Mojave 10.14.4

* [dosdude1's macOS Mojave Patcher 1.3.0][dosdude1]

* [Clover Configurator 5.4.1.1][clover-configurator]

* [John McDonnell's ThinkPad X220 macOS 10.13 Utility and Kext Pack 12.09.2018][mcdonnell]

### My X220 specs

* Intel Core i5-2540M @ 2.6GHz

* 8 GB DDR3 RAM

* SanDisk SSD PLUS 120 GB

* Intel HD Graphics 3000

* Atheros AR5B95 (AR9285)

## Installing macOS Mojave

### What you'll need:

* A computer running macOS

* A >=16GB USB flash drive

* Install macOS Mojave.app

* [macOS Mojave Patcher 1.3.0][dosdude1]

* [Clover Configurator 5.4.1.1][clover-configurator]

* A copy of this repository

### Prepare the patched macOS Mojave installer ([detailed guide][dosdude1])

#### Create the patched installer

1. Launch the **macOS Mojave Patcher**

2. Point the app to your **Install macOS Mojave.app**

3. Set the destination drive to your USB flash drive

4. Copy over Clover Configurator to the flash drive (in case your X220 won't natively have networking hardware configured after a fresh install)

#### Prepare the EFI partition

1. Mount the **USB flash drive's EFI partition** with Clover Configurator

2. Copy over the EFI folder from the `mojave` directory in this repository

### Install macOS Mojave

1. Go through the normal install process (Erase the disk with Disk Utility, install and wait until it finishes)

2. When the machine reboots, instead of booting from the internal drive, boot back into the installer USB flash drive

3. On the menu bar, go to **Utilities > macOS Post Install**

4. Choose **MacBookPro8,1**

5. Set the target volume to your internal drive

6. Hit **Patch**

7. When the patch finishes, make sure to select **Force Cache Rebuild** and **Reboot**

8. You should be able to boot into macOS Mojave through your USB installer's Clover EFI

### Post-install

#### Configure internal drive's EFI partition

1. Mount your **internal hard drive's EFI partition** with Clover Configurator

2. Copy over the EFI folder from the `mojave` directory in this repository

3. Include other kexts you might need under `/Volumes/EFI/EFI/CLOVER/kexts/Other` _(note to self: you probably want to install your AR5B95 kexts under `common/ar5b95-mojave` here)_

4. Run `sudo spctl --master-disable` to allow apps from unidentified developers

5. Run `/Volumes/EFI/EFI/CLOVER/kexts/_kext-install.command`

#### Optimize CPU power management ([detailed guide][mcdonnell])

1. Mount your **internal hard drive's EFI partition** with Clover Configurator

2. Run `common/ssdtprgen/ssdtPRGen.sh` in this repository

3. Answer `N` to all questions

4. Copy the generated `SSDT.aml` from `~/Library/ssdtPRGen` to `/Volumes/EFI/EFI/CLOVER/ACPI/patched`

5. Reboot

#### Change hibernatemode for better sleep defaults ([detailed guide][mcdonnell])

1. Run `sudo pmset -a hibernatemode 0` on a terminal

#### Fix broken screen brightness controls ([detailed guide][mcdonnell])

1. Delete `/Library/Extensions/AppleBacklightInjector.kext`

2. Reboot

#### Install Smart Scroll for better TrackPoint gestures

1. Download and install **Smart Scroll** from [here][smartscroll]

2. My personal preferences are as follows:

```
Scroll Wheel+: disabled
Multi-Touch+: disabled
Hover Scroll: disabled
Auto Scroll: disabled
Grab Scroll:
  Grab Scroll with:
    Button 3 (Middle)
  Suppress button's usual action:
    false
  Disable with:
    none
  Scroll faster:
    2x; with: Option, 8x
  Scroll without moving cursor:
    true
  Reverse X-axis:
    true
  Reverse Y-axis:
    true
  Inertia:
    false
Scroll Keys: disabled
Vector Scroll: disabled
```

## Credits

* [John McDonnell for his High Sierra kexts][mcdonnell]
* [dosdude1 for their macOS Mojave Patcher][dosdude1]
* [Piker-Alpha's ssdtPRGen][ssdtprgen]

[mcdonnell]: http://x220.mcdonnelltech.com
[dosdude1]: http://dosdude1.com/mojave/
[ssdtprgen]: https://github.com/Piker-Alpha/ssdtPRGen.sh
[clover-configurator]: https://mackie100projects.altervista.org/download-clover-configurator/
[smartscroll]: https://www.marcmoini.com/sx_en.html
[img]: https://i.imgur.com/MKHYxM6.jpg
