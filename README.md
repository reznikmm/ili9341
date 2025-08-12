# ILI9341

[![Build status](https://github.com/reznikmm/ili9341/actions/workflows/alire.yml/badge.svg)](https://github.com/reznikmm/ili9341/actions/workflows/alire.yml)
[![Alire](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/ili9341.json)](https://alire.ada.dev/crates/ili9341.html)
[![REUSE status](https://api.reuse.software/badge/github.com/reznikmm/ili9341)](https://api.reuse.software/info/github.com/reznikmm/ili9341)

> Driver for ILI9341 TFT LCD display.

- [Datasheet](https://cdn-shop.adafruit.com/datasheets/ILI9341.pdf)

The ILI9341 is a single-chip driver for 240x320 TFT displays, featuring
262,144 colors. It integrates a source and gate driver, as well as an internal
GRAM for storing display data. The controller supports multiple interfaces,
including parallel (8-/9-/16-/18-bit) and serial (3-/4-line SPI), making
it suitable for a wide range of microcontrollers. The driver's ability
to update specific windowed areas of the screen allows for efficient,
partial redraws, which is ideal for portable devices where power
consumption is a key concern.

The display is available as a module for DIY projects from various
manufacturers, such as
[SparkFun](https://www.sparkfun.com/color-320x240-touchscreen-3-2-inch-ili9341-controller.html),
[DfRobot](https://www.dfrobot.com/product-2106.html)
or [AliExpress](https://www.aliexpress.com/item/1005006935859647.html).

An ILI9341 driver enables the following functionalities:

- ~~Detect and initialize the display~~ (TBD).
- Configure various interface modes, such as ~~SPI, RGB~~ (TBD) or parallel.
- Define a display window for selective, high-speed updates.
- Write pixel data to the internal GRAM.

## Install

Add `ili9341` as a dependency to your crate with Alire:

    alr with ili9341

## Usage

The driver implements two usage models: the generic package, which is more
convenient when dealing with a single sensor, and the tagged type, which
allows easy creation of objects for any number of sensors and uniform handling.

Generic instantiation looks like this:

```ada
declare
   package TFT is new ILI9341.Bus_16_II
     (Command => System'To_Address (16#6C00_0000#),
      Data    => System'To_Address (16#6C00_0080#));

   VRAM : Interfaces.Unsigned_16
     with
       Import,
       Address => System'To_Address (16#6C00_0080#),
       Volatile;
begin
   TFT.Pixel_Format_Set (DBI => 16);
   TFT.Sleep_Out;
   delay 0.005;
   TFT.Display_On;
   TFT.Write_Memory;

   for J in 1 .. 240 * 320 loop
      VRAM := Interfaces.Unsigned_16'Mod (J);
   end loop;
```

## Examples

Example use [aa_stm32_drivers](https://github.com/reznikmm/aa_stm32_drivers/)
with [STM32F4XX Pro](https://stm32-base.org/boards/STM32F407ZGT6-STM32F4XX-Pro).
Run Alire to build:

    alr -C examples/stm32_f4xx_pro build

### GNAT Studio

Launch GNAT Studio with Alire:

    alr -C examples/stm32_f4xx_pro exec gnatstudio

### VS Code

Make sure `alr` in the `PATH`.
Open the `examples/stm32_f4xx_pro` folder in VS Code.
Use pre-configured tasks to build
projects and flash (openocd or st-util). Install Cortex Debug extension
to launch pre-configured debugger targets.

- [Simple example for STM32F4XX Pro board](examples/stm32_f4xx_pro/) - complete
  example for the generic instantiation.
