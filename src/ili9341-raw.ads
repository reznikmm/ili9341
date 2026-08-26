--  SPDX-FileCopyrightText: 2025-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
---------------------------------------------------------------------
pragma Ada_2022;

package ILI9341.Raw is
   pragma Pure;

   use type Interfaces.Unsigned_8;
   use type Interfaces.Unsigned_16;

   subtype Parameter_Count is Natural range 0 .. 15;

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
   subtype Command_15P is Command (15);

   function MSB (Value : Interfaces.Unsigned_16) return Byte is
      (Byte (Value / 256)) with Static;

   function LSB (Value : Interfaces.Unsigned_16) return Byte is
      (Byte (Value and 16#FF#)) with Static;

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

   --  Pump ratio control
   --------------------------------------------------------------------------

   function Pump_Ratio_Control (Ratio : Byte) return Command_1P is
     (Size       => 1,
      Command    => 16#F7#,
      Parameters => [Ratio]);
   --  Sets the ratio factor used by the step-up circuit that generates
   --  VGH/VGL. Raw register byte -- only the opcode and framing are
   --  modeled here; see the ILI9341 datasheet's "Pump Ratio Control"
   --  section for the bit layout. TFT_eSPI's ILI9341/ILI9341_2 init
   --  tables both use 16#20#.

   --  Power control 1 / 2 (VRH / BT)
   --------------------------------------------------------------------------

   function Power_Control_1 (VRH : Byte) return Command_1P is
     (Size       => 1,
      Command    => 16#C0#,
      Parameters => [VRH]);
   --  Sets the GVDD reference level, which sets the grayscale voltage
   --  level (VRH[5:0]). Raw register byte, same caveat as
   --  Pump_Ratio_Control -- see the datasheet's "Power Control 1"
   --  section for the VRH-to-GVDD voltage mapping.

   function Power_Control_2 (BT : Byte) return Command_1P is
     (Size       => 1,
      Command    => 16#C1#,
      Parameters => [BT]);
   --  Sets the factor used by the step-up circuits (SAP[2:0]:BT[3:0]).
   --  Raw register byte, same caveat as Power_Control_1.

   --  VCOM control 1 / 2
   --------------------------------------------------------------------------

   function VCOM_Control_1
     (VMH : Byte;
      VML : Byte) return Command_2P is
     (Size       => 2,
      Command    => 16#C5#,
      Parameters => [VMH, VML]);
   --  Sets the VCOMH (VMH) and VCOML (VML) voltages. Raw register
   --  bytes, same caveat as Power_Control_1.

   function VCOM_Control_2 (VMF : Byte) return Command_1P is
     (Size       => 1,
      Command    => 16#C7#,
      Parameters => [VMF]);
   --  Sets the VCOM offset voltage (VMF), used for VCOM drive-ability
   --  adjustment / flicker tuning. Raw register byte, same caveat as
   --  Power_Control_1.

   --  Memory Access Control (MADCTL)
   --------------------------------------------------------------------------

   function Memory_Access_Control
     (MY  : Boolean := False;
      MX  : Boolean := False;
      MV  : Boolean := False;
      ML  : Boolean := False;
      BGR : Boolean := False;
      MH  : Boolean := False) return Command_1P is
     (Size       => 1,
      Command    => 16#36#,
      Parameters =>
        [(if MY  then 16#80# else 0) +
         (if MX  then 16#40# else 0) +
         (if MV  then 16#20# else 0) +
         (if ML  then 16#10# else 0) +
         (if BGR then 16#08# else 0) +
         (if MH  then 16#04# else 0)]);
   --  Sets the row/column address order (MY/MX), row/column exchange
   --  (MV, swaps width and height -- landscape vs. portrait), vertical
   --  refresh order (ML), RGB/BGR pixel order (BGR, True selects BGR),
   --  and horizontal refresh order (MH). Used both for screen
   --  orientation (plan.md step 6) and to select the pixel byte order
   --  (`Swapped` in `ESP32.ILI9341.Bitmap`, plan.md step 5).

   --  Frame Rate Control (Normal Mode/Full Colors)
   --------------------------------------------------------------------------

   function Frame_Rate_Control_Normal
     (DIVA : Frame_Rate_Division := 0;
      RTNA : Frame_Rate_Clocks   := 27) return Command_2P is
     (Size       => 2,
      Command    => 16#B1#,
      Parameters => [Byte (DIVA), Byte (RTNA)]);
   --  DIVA selects the division ratio for the internal clock (fosc);
   --  RTNA sets the number of clocks per line, which sets the normal
   --  mode frame rate. Byte encoding only (raw DIVA[1:0]/RTNA[4:0]
   --  sub-fields) -- see the ILI9341 datasheet's "Frame Rate Control"
   --  section for the resulting Hz formula.

   --  Display Function Control
   --------------------------------------------------------------------------

   function Display_Function_Control
     (P1 : Byte;
      P2 : Byte;
      P3 : Byte) return Command_3P is
     (Size       => 3,
      Command    => 16#B6#,
      Parameters => [P1, P2, P3]);
   --  Sets gate driver polarity/scan direction, source/gate driver
   --  timing, and interval-scan settings (the PT/GS/SS/SM/ISC/NL/PCDIV
   --  bit fields spread across 3 bytes). Kept as raw register bytes
   --  rather than decomposed -- see the ILI9341 datasheet's "Display
   --  Function Control" section for the full bit layout.

   --  Gamma control
   --------------------------------------------------------------------------

   function Gamma_Function_Enable
     (Enable : Boolean := False) return Command_1P is
     (Size       => 1,
      Command    => 16#F2#,
      Parameters => [(if Enable then 1 else 0)]);
   --  Enables/disables gamma adjustment via the interpolated 3-gamma
   --  curve (GC0-GC3, bit 0). When disabled, the fixed curve selected
   --  by Gamma_Set is used directly.

   function Gamma_Curve_Code (Curve : Gamma_Curve) return Byte is
     (case Curve is
        when Curve_1 => 16#01#,
        when Curve_2 => 16#02#,
        when Curve_4 => 16#04#,
        when Curve_8 => 16#08#)
     with Static;
   --  Encodes the one-hot GC[3:0] curve selector per the datasheet.

   function Gamma_Set (Curve : Gamma_Curve := Curve_1) return Command_1P is
     (Size       => 1,
      Command    => 16#26#,
      Parameters => [Gamma_Curve_Code (Curve)]);
   --  Selects one of the 4 predefined gamma curves.

   function Positive_Gamma_Correction
     (Table : Gamma_Correction_Table) return Command_15P is
     (Size       => 15,
      Command    => 16#E0#,
      Parameters => Table);
   --  Sets the 15 gray-scale voltage adjustment points (interpolated
   --  between V0 and V63) of the positive-polarity gamma curve.

   function Negative_Gamma_Correction
     (Table : Gamma_Correction_Table) return Command_15P is
     (Size       => 15,
      Command    => 16#E1#,
      Parameters => Table);
   --  Sets the 15 gray-scale voltage adjustment points of the
   --  negative-polarity gamma curve.

   --  Display Inversion
   --------------------------------------------------------------------------

   function Display_Inversion_On return Command_0P is
     (Size       => 0,
      Command    => 16#21#,
      Parameters => []);
   --  Enters display inversion mode: every bit is inverted from frame
   --  memory to the display, contents unaffected. Needed by panels
   --  (e.g. the CYD/ESP32-2432S028R) whose glass requires
   --  TFT_INVERSION_ON to show correct, non-inverted colors -- see
   --  TFT_eSPI's handling of the TFT_INVERSION_ON build flag.

   function Display_Inversion_Off return Command_0P is
     (Size       => 0,
      Command    => 16#20#,
      Parameters => []);
   --  Recovers from display inversion mode. Contents of frame memory
   --  unaffected, no other status changed.

end ILI9341.Raw;
