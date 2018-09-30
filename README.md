# macOS on the ThinkPad X220

because who can afford a new MacBook nowadays

## Introduction (and warnings!)

This guide specifically has not been tested extensively nor is it written to be an exhaustive guide for installing macOS. This works on my personal X220. YMMV.

A more complete guide can be found at [John McDonnell's page][mcdonnell] dedicated to installing macOS on the X220. Huge props to him for supporting the X220 all these years.

Also, a lot of things don't work: iMessage, FaceTime, Continuity, Handoff, Metal, among others.

### My X220 specs

* Intel Core i5-2540M @ 2.6GHz

* 8 GB DDR3 RAM

* SanDisk SSD PLUS 120 GB

* Intel HD Graphics 3000

* Atheros AR5B95 (AR9285)

## Installing macOS Mojave

### What you'll need:

* A >=16GB USB flash drive
* [dosdude1's macOS Mojave Patcher][dosdude1]
* Install macOS Mojave.app (optional!)
* [John McDonnell's ThinkPad X220 macOS 10.13 Utility and Kext Pack][mcdonnell]
* [Clover Configurator][clover-configurator]

### Prepare the patched macOS Mojave installer

(A better guide for this can be found [here][dosdude1]!)

#### Create the patched installer

1. Launch the **macOS Mojave Patcher**

2. Point the app to your **Install macOS Mojave.app** or download it on demand from the app

3. Set the destination drive to your USB flash drive

4. Copy over Clover Configurator to the flash drive in case your X220 won't natively have Internet connection after install

#### Prepare the EFI partition

1. Mount the USB flash drive's EFI partition

2. Copy over the EFI folder from the `mojave` directory in this repository

### Install macOS Mojave

1. Go through the normal install process (Erase the disk with Disk Utility, install and wait until it finishes)

2. When the machine reboots, instead of booting from the internal drive, boot back into the installer USB flash drive

3. Open up the **macOS Post Install...** under **Utilities**

4. Select **MacBookPro8,1** and your internal drive as the target volume

5. Hit **Patch**

6. When the patch finishes, make sure to select **Force Cache Rebuild** and **Reboot**

7. You should be able to boot into macOS Mojave through your USB installer's Clover EFI

### Post-install

#### Configure internal drive's EFI partition

1. Open **Clover Configurator** and mount your internal drive's EFI partition

2. Copy over the EFI folder from the `mojave` directory in this repository

3. Include other kexts you might need under `/Volumes/EFI/EFI/CLOVER/kexts/Other`

4. Run `sudo spctl --master-disable` to allow apps from unidentified developers

5. Run `/Volumes/EFI/EFI/CLOVER/kexts/_kext-install.command`

#### Optimize CPU power management

(A better guide for this can be found [here][mcdonnell]!)

1. Open **Clover Configurator** and mount your internal drive's EFI partition

2. Run `common/ssdtprgen/ssdtPRGen.sh`

3. Answer `N` to all questions

4. Copy the generated `SSDT.aml` from `~/Library/ssdtPRGen` to `/Volumes/EFI/EFI/CLOVER/ACPI/patched`

5. Reboot

#### Change hibernatemode for better sleep defaults

(A better guide for this can be found [here][mcdonnell]!)

1. Run `sudo pmset -a hibernatemode 0` on a terminal

#### Fix broken screen brightness controls

(A better guide for this can be found [here][mcdonnell]!)

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
