--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Generic implementation ILI9341 driver

with Interfaces;
with System;

with ILI9341.Raw;

generic
   with procedure Send_Command (Item : ILI9341.Raw.Command);
package ILI9341.Implementation is
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

   procedure Pump_Ratio_Control (Ratio : Byte);
   --  Sets the ratio factor used by the step-up circuit that generates
   --  VGH/VGL. Raw register byte -- see ILI9341.Raw.Pump_Ratio_Control.

   procedure Power_Control_1 (VRH : Byte);
   --  Sets the GVDD reference level (VRH[5:0]). Raw register byte --
   --  see ILI9341.Raw.Power_Control_1.

   procedure Power_Control_2 (BT : Byte);
   --  Sets the step-up circuit factor (SAP[2:0]:BT[3:0]). Raw
   --  register byte -- see ILI9341.Raw.Power_Control_2.

   procedure VCOM_Control_1
     (VMH : Byte;
      VML : Byte);
   --  Sets the VCOMH/VCOML voltages. Raw register bytes -- see
   --  ILI9341.Raw.VCOM_Control_1.

   procedure VCOM_Control_2 (VMF : Byte);
   --  Sets the VCOM offset voltage. Raw register byte -- see
   --  ILI9341.Raw.VCOM_Control_2.

   procedure Memory_Access_Control
     (MY  : Boolean := False;
      MX  : Boolean := False;
      MV  : Boolean := False;
      ML  : Boolean := False;
      BGR : Boolean := False;
      MH  : Boolean := False);
   --  Sets row/column address order, row/column exchange, refresh
   --  order and RGB/BGR pixel order -- see
   --  ILI9341.Raw.Memory_Access_Control.

   procedure Frame_Rate_Control_Normal
     (DIVA : Frame_Rate_Division := 0;
      RTNA : Frame_Rate_Clocks   := 27);
   --  Sets the normal-mode frame rate -- see
   --  ILI9341.Raw.Frame_Rate_Control_Normal.

   procedure Display_Function_Control
     (P1 : Byte;
      P2 : Byte;
      P3 : Byte);
   --  Raw register bytes -- see ILI9341.Raw.Display_Function_Control.

   procedure Gamma_Function_Enable (Enable : Boolean := False);
   --  Enables/disables the interpolated 3-gamma curve -- see
   --  ILI9341.Raw.Gamma_Function_Enable.

   procedure Gamma_Set (Curve : Gamma_Curve := Curve_1);
   --  Selects one of the 4 predefined gamma curves -- see
   --  ILI9341.Raw.Gamma_Set.

   procedure Positive_Gamma_Correction (Table : Gamma_Correction_Table);
   --  Sets the positive-polarity gamma curve -- see
   --  ILI9341.Raw.Positive_Gamma_Correction.

   procedure Negative_Gamma_Correction (Table : Gamma_Correction_Table);
   --  Sets the negative-polarity gamma curve -- see
   --  ILI9341.Raw.Negative_Gamma_Correction.

   procedure Display_Inversion_On;
   --  Enters display inversion mode -- see
   --  ILI9341.Raw.Display_Inversion_On.

   procedure Display_Inversion_Off;
   --  Recovers from display inversion mode -- see
   --  ILI9341.Raw.Display_Inversion_Off.

end ILI9341.Implementation;
