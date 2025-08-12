--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------
pragma Ada_2022;

package ILI9341.Raw is
   pragma Pure;

   use type Interfaces.Unsigned_8;
   use type Interfaces.Unsigned_16;

   subtype Parameter_Count is Natural range 0 .. 6;

   type Command (Size : Parameter_Count) is record
      Command    : Byte;
      Parameters : Byte_Array (1 .. Size);
   end record;

   subtype Command_0P is Command (0);
   subtype Command_1P is Command (1);
   subtype Command_2P is Command (2);
   subtype Command_3P is Command (3);
   subtype Command_4P is Command (4);
   subtype Command_5P is Command (5);

   function MSB (Value : Interfaces.Unsigned_16) return Byte is
      (Byte (Value / 256));

   function LSB (Value : Interfaces.Unsigned_16) return Byte is
      (Byte (Value and 16#FF#));

   function Column_Address_Set
     (SC : Interfaces.Unsigned_16;
      EC : Interfaces.Unsigned_16) return Command_4P is
       (Size       => 4,
        Command    => 16#2A#,
        Parameters => [MSB (SC), LSB (SC), MSB (EC), LSB (EC)])
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

   function Page_Address_Set
     (SP : Interfaces.Unsigned_16;
      EP : Interfaces.Unsigned_16) return Command_4P is
       (Size       => 4,
        Command    => 16#2B#,
        Parameters => [MSB (SP), LSB (SP), MSB (EP), LSB (EP)])
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

   function Write_Memory return Command_0P is
     (Size       => 0,
      Command    => 16#2C#,
      Parameters => <>);
   --  This command is used to transfer data from MCU to frame memory. This
   --  command makes no change to the other driver status. When this command
   --  is accepted, the column register and the page register are reset to the
   --  Start Column/Start Page positions. The Start Column/Start Page positions
   --  are different in accordance with MADCTL setting.) Then data is
   --  stored in frame memory and the column register and the page register
   --  incremented. Sending any other command can stop frame Write.

   function Software_Reset return Command_0P is
     (Size       => 0,
      Command    => 16#01#,
      Parameters => <>);
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

   --  Power control A
   --------------------------------------------------------------------------

   function REG_VD (V_Core : Core_Mili_Volt := 1_600) return Byte is
     (16#30# +
       (if    V_Core = 1_550 then 0
        elsif V_Core = 1_400 then 1
        elsif V_Core = 1_500 then 2
        elsif V_Core = 1_650 then 3
        elsif V_Core = 1_600 then 4
        elsif V_Core = 1_700 then 5
        else 6))
     with Static;
   --  Convert core voltage to REG_VD

   function VBC (DDVDH : DDVDH_Mili_Volt := 5_600) return Byte is
     (if    DDVDH = 5_800 then 0
      elsif DDVDH = 5_700 then 1
      elsif DDVDH = 5_600 then 2
      elsif DDVDH = 5_500 then 3
      elsif DDVDH = 5_400 then 4
      elsif DDVDH = 5_300 then 5
      elsif DDVDH = 5_200 then 6
      else 7)
     with Static;
   --  Convert core voltage to VBC

   function Power_Control_A
     (V_Core : Core_Mili_Volt  := 1_600;
      DDVDH  : DDVDH_Mili_Volt := 5_600) return Command_5P is
       (Size       => 5,
        Command    => 16#CB#,
        Parameters => [16#39#, 16#2C#, 16#00#, REG_VD (V_Core), VBC (DDVDH)]);
   --  @param V_Core - core voltage control
   --  @param DDVDH  - output voltage of 1st step up circuit

   --  Power control B
   --------------------------------------------------------------------------

   function Power_Control_B
     (PCEQ : Boolean := False;
      DRV  : Boolean := False) return Command_3P is
       (Size       => 3,
        Command    => 16#CF#,
        Parameters =>
          [16#00#,
           16#81#
           + (if PCEQ then 16#40# else 0)
           + (if DRV  then 16#20# else 0),
           16#30#]);
   --  @param PCEQ - PC and EQ operation for power saving
   --  @param DRV  - For VCOM driving ability enhancement

   function Driver_Timing_Control_A
     (NOW : Zero_To_1  := 0;
      EQ  : Minus_1_To_0 := 0;
      CR  : Minus_1_To_0 := 0;
      PC  : Minus_2_To_0 := 0) return Command_3P is
       (Size       => 3,
        Command    => 16#E8#,
        Parameters =>
          [16#84# + Byte (NOW),
           16#0#
           + (if EQ = 0 then 16#10# else 0)
           + (if CR = 0 then 16#01# else 0),
           16#30# + Byte (2 + PC)]);
   --  EQ timing for Internal clock
   --
   --  @param NOW - non-overlap time (+/- offset in units)
   --  @param EQ - EQ timing control (+/- offset in units)
   --  @param CR - CR timing control (+/- offset in units)
   --  @param PC - pre-charge timing control

   function Driver_Timing_Control_B
     (T1 : Zero_To_3  := 0;
      T2 : Zero_To_3  := 0;
      T3 : Zero_To_3  := 0;
      T4 : Zero_To_3  := 0) return Command_2P is
       (Size       => 2,
        Command    => 16#EA#,
        Parameters =>
          [Byte (T1) + 4 * Byte (T2) + 16 * Byte (T3) + 64 * Byte (T4),
           16#0#]);
   --  gate driver timing control
   --
   --  @param T1 - EQ to GND
   --  @param T2 - EQ to DDVDH
   --  @param T3 - EQ to DDVDH
   --  @param T4 - EQ to GND

   function Pixel_Format_Set
     (DPI : Bits_Per_Pixel := 18;
      DBI : Bits_Per_Pixel := 18) return Command_1P is
       (Size       => 1,
        Command    => 16#3A#,
        Parameters =>
          [(if DPI = 16 then 16#50# else 16#60#) +
           (if DBI = 16 then 16#05# else 16#06#)]);
   --  This command sets the pixel format for the RGB image data used by the
   --  interface. DPI is the pixel format select of RGB interface and DBI is
   --  the pixel format of MCU interface. If a particular interface, either
   --  RGB interface or MCU interface, is not used then the corresponding
   --  bits in the parameter are ignored.

   function Display_Off return Command_0P is
     (Size       => 0,
      Command    => 16#28#,
      Parameters => []);
   --  This command is used to enter into DISPLAY OFF mode. In this mode,
   --  the output from Frame Memory is disabled and blank page inserted. This
   --  command makes no change of contents of frame memory. This command does
   --  not change any other status. There will be no abnormal visible effect
   --  on the display.

   function Display_On return Command_0P is
     (Size       => 0,
      Command    => 16#29#,
      Parameters => []);
   --  This command is used to recover from DISPLAY OFF mode. Output from the
   --  Frame Memory is enabled. This command makes no change of contents of
   --  frame memory. This command does not change any other status.

   function Sleep_In return Command_0P is
     (Size       => 0,
      Command    => 16#10#,
      Parameters => []);
   --  This command causes the LCD module to enter the minimum power
   --  consumption mode. In this mode e.g. the DC/DC converter is stopped,
   --  Internal oscillator is stopped, and panel scanning is stopped. MCU
   --  interface and memory are still working and the memory keeps its
   --  contents.

   function Sleep_Out return Command_0P is
     (Size       => 0,
      Command    => 16#11#,
      Parameters => []);
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

end ILI9341.Raw;
