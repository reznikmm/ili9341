--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with ILI9341.Implementation;
with ILI9341.Raw;

package body ILI9341.Bus_16_II is

   procedure Send_Command (Item : ILI9341.Raw.Command)
     with Inline;

   package Real is new ILI9341.Implementation (Send_Command);

   ------------------------
   -- Column_Address_Set --
   ------------------------

   procedure Column_Address_Set
     (SC : Interfaces.Unsigned_16;
      EC : Interfaces.Unsigned_16) renames Real.Column_Address_Set;

   -------------------------------
   -- Display_Function_Control --
   -------------------------------

   procedure Display_Function_Control
     (P1 : Byte;
      P2 : Byte;
      P3 : Byte) renames Real.Display_Function_Control;

   ----------------------------
   -- Display_Inversion_Off --
   ----------------------------

   procedure Display_Inversion_Off renames Real.Display_Inversion_Off;

   ---------------------------
   -- Display_Inversion_On --
   ---------------------------

   procedure Display_Inversion_On renames Real.Display_Inversion_On;

   -----------------
   -- Display_Off --
   -----------------

   procedure Display_Off renames Real.Display_Off;

   ----------------
   -- Display_On --
   ----------------

   procedure Display_On renames Real.Display_On;

   -----------------------------
   -- Driver_Timing_Control_A --
   -----------------------------

   procedure Driver_Timing_Control_A
     (NOW : Zero_To_1  := 0;
      EQ  : Minus_1_To_0 := 0;
      CR  : Minus_1_To_0 := 0;
      PC  : Minus_2_To_0 := 0) renames Real.Driver_Timing_Control_A;

   -----------------------------
   -- Driver_Timing_Control_B --
   -----------------------------

   procedure Driver_Timing_Control_B
     (T1 : Zero_To_3  := 0;
      T2 : Zero_To_3  := 0;
      T3 : Zero_To_3  := 0;
      T4 : Zero_To_3  := 0) renames Real.Driver_Timing_Control_B;

   --------------------------------
   -- Frame_Rate_Control_Normal --
   --------------------------------

   procedure Frame_Rate_Control_Normal
     (DIVA : Frame_Rate_Division := 0;
      RTNA : Frame_Rate_Clocks   := 27) renames Real.Frame_Rate_Control_Normal;

   ----------------------------
   -- Gamma_Function_Enable --
   ----------------------------

   procedure Gamma_Function_Enable
     (Enable : Boolean := False) renames Real.Gamma_Function_Enable;

   ---------------
   -- Gamma_Set --
   ---------------

   procedure Gamma_Set
     (Curve : Gamma_Curve := Curve_1) renames Real.Gamma_Set;

   ------------------------------
   -- Memory_Access_Control --
   ------------------------------

   procedure Memory_Access_Control
     (MY  : Boolean := False;
      MX  : Boolean := False;
      MV  : Boolean := False;
      ML  : Boolean := False;
      BGR : Boolean := False;
      MH  : Boolean := False) renames Real.Memory_Access_Control;

   --------------------------------
   -- Negative_Gamma_Correction --
   --------------------------------

   procedure Negative_Gamma_Correction
     (Table : Gamma_Correction_Table) renames Real.Negative_Gamma_Correction;

   ----------------------
   -- Page_Address_Set --
   ----------------------

   procedure Page_Address_Set
     (SP : Interfaces.Unsigned_16;
      EP : Interfaces.Unsigned_16) renames Real.Page_Address_Set;

   ----------------------
   -- Pixel_Format_Set --
   ----------------------

   procedure Pixel_Format_Set
     (DPI : Bits_Per_Pixel := 18;
      DBI : Bits_Per_Pixel := 18) renames Real.Pixel_Format_Set;

   --------------------------------
   -- Positive_Gamma_Correction --
   --------------------------------

   procedure Positive_Gamma_Correction
     (Table : Gamma_Correction_Table) renames Real.Positive_Gamma_Correction;

   ---------------------
   -- Power_Control_1 --
   ---------------------

   procedure Power_Control_1 (VRH : Byte) renames Real.Power_Control_1;

   ---------------------
   -- Power_Control_2 --
   ---------------------

   procedure Power_Control_2 (BT : Byte) renames Real.Power_Control_2;

   ---------------------
   -- Power_Control_A --
   ---------------------

   procedure Power_Control_A
     (V_Core : Core_Mili_Volt  := 1_600;
      DDVDH  : DDVDH_Mili_Volt := 5_600) renames Real.Power_Control_A;

   ---------------------
   -- Power_Control_B --
   ---------------------

   procedure Power_Control_B
     (PCEQ : Boolean := False;
      DRV  : Boolean := False) renames Real.Power_Control_B;

   -------------------------
   -- Pump_Ratio_Control --
   -------------------------

   procedure Pump_Ratio_Control (Ratio : Byte) renames Real.Pump_Ratio_Control;

   ------------------
   -- Send_Command --
   ------------------

   procedure Send_Command (Item : ILI9341.Raw.Command) is
      Cmd : Interfaces.Unsigned_16
        with Import, Address => Command, Volatile;

      RAM : Interfaces.Unsigned_16
        with Import, Address => Data, Volatile;
   begin
      Cmd := Interfaces.Unsigned_16 (Item.Command);

      for Parameter of Item.Parameters loop
         RAM := Interfaces.Unsigned_16 (Parameter);
      end loop;
   end Send_Command;

   --------------
   -- Sleep_In --
   --------------

   procedure Sleep_In renames Real.Sleep_In;

   ---------------
   -- Sleep_Out --
   ---------------

   procedure Sleep_Out renames Real.Sleep_Out;

   --------------------
   -- Software_Reset --
   --------------------

   procedure Software_Reset renames Real.Software_Reset;

   ----------------------
   -- VCOM_Control_1 --
   ----------------------

   procedure VCOM_Control_1
     (VMH : Byte;
      VML : Byte) renames Real.VCOM_Control_1;

   ----------------------
   -- VCOM_Control_2 --
   ----------------------

   procedure VCOM_Control_2 (VMF : Byte) renames Real.VCOM_Control_2;

   ------------------
   -- Write_Memory --
   ------------------

   procedure Write_Memory renames Real.Write_Memory;

end ILI9341.Bus_16_II;
