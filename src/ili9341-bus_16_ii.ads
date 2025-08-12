--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  ILI9341 with 8080 MCU 16-bit bus interface Ⅱ mapped to the memory

with Interfaces;
with System;

generic
   Command : System.Address;
   Data    : System.Address;
package ILI9341.Bus_16_II is
   pragma Pure;

   use type Interfaces.Unsigned_16;

   procedure Column_Address_Set
     (SC : Interfaces.Unsigned_16;
      EC : Interfaces.Unsigned_16)
     with Pre => SC <= EC;
   --
   --  This command is used to define area of frame memory where MCU can
   --  access. This command makes no change on the other driver status. The
   --  values of SC and EC are referred when RAMWR command comes. Each value
   --  represents one column line in the Frame Memory.
   --
   --  SC always must be equal to or less than EC.
   --
   --  Note 1: When SC or EC is greater than 239 (When MADCTL’s B5 = 0) or
   --  319 (When MADCTL’s B5 = 1), data of out of range will be ignored.

   procedure Page_Address_Set
     (SP : Interfaces.Unsigned_16;
      EP : Interfaces.Unsigned_16)
     with Pre => SP <= EP;
   --
   --  This command is used to define area of frame memory where MCU can
   --  access. This command makes no change on the other driver status. The
   --  values of SP and EP are referred when RAMWR command comes. Each value
   --  represents one page line in the Frame Memory.
   --
   --  SP always must be equal to or less than EP.
   --
   --  Note 1: When SP or EP is greater than 319 (When MADCTL’s B5 = 0) or
   --  239 (When MADCTL’s B5 = 1), data of out of range will be ignored.

   procedure Write_Memory;
   --  This command is used to transfer data from MCU to frame memory. This
   --  command makes no change to the other driver status. When this command
   --  is accepted, the column register and the page register are reset to the
   --  Start Column/Start Page positions. The Start Column/Start Page positions
   --  are different in accordance with MADCTL setting.) Then data is
   --  stored in frame memory and the column register and the page register
   --  incremented. Sending any other command can stop frame Write.

   procedure Software_Reset;
   --  When the Software Reset command is written, it causes a software reset.
   --  It resets the commands and parameters to their S/W Reset default values.
   --  The Frame Memory contents are unaffected by this command.
   --
   --  It will be necessary to wait 5msec before sending new command following
   --  software reset. The display module loads all display supplier factory
   --  default values to the registers during this 5ms. If Software Reset
   --  is applied during Sleep Out mode, it will be necessary to wait 120ms
   --  before sending Sleep out command. Software Reset Command cannot be sent
   --  during Sleep Out sequence.

   procedure Display_Off;
   --  This command is used to enter into DISPLAY OFF mode. In this mode,
   --  the output from Frame Memory is disabled and blank page inserted. This
   --  command makes no change of contents of frame memory. This command does
   --  not change any other status. There will be no abnormal visible effect
   --  on the display.

   procedure Display_On;
   --  This command is used to recover from DISPLAY OFF mode. Output from the
   --  Frame Memory is enabled. This command makes no change of contents of
   --  frame memory. This command does not change any other status.

   procedure Sleep_In;
   --  This command causes the LCD module to enter the minimum power
   --  consumption mode. In this mode e.g. the DC/DC converter is stopped,
   --  Internal oscillator is stopped, and panel scanning is stopped. MCU
   --  interface and memory are still working and the memory keeps its
   --  contents.

   procedure Sleep_Out;
   --  This command turns off sleep mode. In this mode e.g. the DC/DC converter
   --  is enabled, Internal oscillator is started, and panel scanning is
   --  started.
   --
   --  This command has no effect when module is already in sleep out mode.
   --  Sleep Out Mode can only be left by the Sleep In Command (10h). It will
   --  be necessary to wait 5ms before sending next command, this is to allow
   --  time for the supply voltages and clock circuits stabilize. The display
   --  module loads all display supplier’s factory default values to the
   --  registers during this 5ms and there cannot be any abnormal visual effect
   --  on the display image if factory default and register values are same
   --  when this load is done and when the display module is already Sleep Out
   --  –mode. The display module is doing self-diagnostic functions during
   --  this 5ms. It will be necessary to wait 120ms after sending Sleep In
   --  command (when in Sleep Out mode) before Sleep Out command can be sent.

   procedure Pixel_Format_Set
     (DPI : Bits_Per_Pixel := 18;
      DBI : Bits_Per_Pixel := 18);
   --  This command sets the pixel format for the RGB image data used by the
   --  interface. DPI is the pixel format select of RGB interface and DBI is
   --  the pixel format of MCU interface. If a particular interface, either
   --  RGB interface or MCU interface, is not used then the corresponding
   --  bits in the parameter are ignored.

   procedure Power_Control_A
     (V_Core : Core_Mili_Volt  := 1_600;
      DDVDH  : DDVDH_Mili_Volt := 5_600);
   --  @param V_Core - core voltage control
   --  @param DDVDH  - output voltage of 1st step up circuit

   procedure Power_Control_B
     (PCEQ : Boolean := False;
      DRV  : Boolean := False);
   --  @param PCEQ - PC and EQ operation for power saving
   --  @param DRV  - For VCOM driving ability enhancement

   procedure Driver_Timing_Control_A
     (NOW : Zero_To_1  := 0;
      EQ  : Minus_1_To_0 := 0;
      CR  : Minus_1_To_0 := 0;
      PC  : Minus_2_To_0 := 0);
   --  EQ timing for Internal clock
   --
   --  @param NOW - non-overlap time (+/- offset in units)
   --  @param EQ - EQ timing control (+/- offset in units)
   --  @param CR - CR timing control (+/- offset in units)
   --  @param PC - pre-charge timing control

   procedure Driver_Timing_Control_B
     (T1 : Zero_To_3  := 0;
      T2 : Zero_To_3  := 0;
      T3 : Zero_To_3  := 0;
      T4 : Zero_To_3  := 0);
   --  gate driver timing control
   --
   --  @param T1 - EQ to GND
   --  @param T2 - EQ to DDVDH
   --  @param T3 - EQ to DDVDH
   --  @param T4 - EQ to GND

end ILI9341.Bus_16_II;
