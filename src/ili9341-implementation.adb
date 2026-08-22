--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with ILI9341.Raw;

package body ILI9341.Implementation is

   ------------------------
   -- Column_Address_Set --
   ------------------------

   procedure Column_Address_Set
     (SC : Interfaces.Unsigned_16;
      EC : Interfaces.Unsigned_16) is
   begin
      Send_Command (Raw.Column_Address_Set (SC, EC));
   end Column_Address_Set;

   -------------------------------
   -- Display_Function_Control --
   -------------------------------

   procedure Display_Function_Control
     (P1 : Byte;
      P2 : Byte;
      P3 : Byte) is
   begin
      Send_Command (Raw.Display_Function_Control (P1, P2, P3));
   end Display_Function_Control;

   ----------------------------
   -- Display_Inversion_Off --
   ----------------------------

   procedure Display_Inversion_Off is
   begin
      Send_Command (Raw.Display_Inversion_Off);
   end Display_Inversion_Off;

   ---------------------------
   -- Display_Inversion_On --
   ---------------------------

   procedure Display_Inversion_On is
   begin
      Send_Command (Raw.Display_Inversion_On);
   end Display_Inversion_On;

   -----------------
   -- Display_Off --
   -----------------

   procedure Display_Off is
   begin
      Send_Command (Raw.Display_Off);
   end Display_Off;

   ----------------
   -- Display_On --
   ----------------

   procedure Display_On is
   begin
      Send_Command (Raw.Display_On);
   end Display_On;

   -----------------------------
   -- Driver_Timing_Control_A --
   -----------------------------

   procedure Driver_Timing_Control_A
     (NOW : Zero_To_1  := 0;
      EQ  : Minus_1_To_0 := 0;
      CR  : Minus_1_To_0 := 0;
      PC  : Minus_2_To_0 := 0) is
   begin
      Send_Command (Raw.Driver_Timing_Control_A (NOW, EQ, CR, PC));
   end Driver_Timing_Control_A;

   -----------------------------
   -- Driver_Timing_Control_B --
   -----------------------------

   procedure Driver_Timing_Control_B
     (T1 : Zero_To_3  := 0;
      T2 : Zero_To_3  := 0;
      T3 : Zero_To_3  := 0;
      T4 : Zero_To_3  := 0) is
   begin
      Send_Command (Raw.Driver_Timing_Control_B (T1, T2, T3, T4));
   end Driver_Timing_Control_B;

   --------------------------------
   -- Frame_Rate_Control_Normal --
   --------------------------------

   procedure Frame_Rate_Control_Normal
     (DIVA : Frame_Rate_Division := 0;
      RTNA : Frame_Rate_Clocks   := 27) is
   begin
      Send_Command (Raw.Frame_Rate_Control_Normal (DIVA, RTNA));
   end Frame_Rate_Control_Normal;

   ----------------------------
   -- Gamma_Function_Enable --
   ----------------------------

   procedure Gamma_Function_Enable (Enable : Boolean := False) is
   begin
      Send_Command (Raw.Gamma_Function_Enable (Enable));
   end Gamma_Function_Enable;

   ---------------
   -- Gamma_Set --
   ---------------

   procedure Gamma_Set (Curve : Gamma_Curve := Curve_1) is
   begin
      Send_Command (Raw.Gamma_Set (Curve));
   end Gamma_Set;

   ------------------------------
   -- Memory_Access_Control --
   ------------------------------

   procedure Memory_Access_Control
     (MY  : Boolean := False;
      MX  : Boolean := False;
      MV  : Boolean := False;
      ML  : Boolean := False;
      BGR : Boolean := False;
      MH  : Boolean := False) is
   begin
      Send_Command (Raw.Memory_Access_Control (MY, MX, MV, ML, BGR, MH));
   end Memory_Access_Control;

   --------------------------------
   -- Negative_Gamma_Correction --
   --------------------------------

   procedure Negative_Gamma_Correction (Table : Gamma_Correction_Table) is
   begin
      Send_Command (Raw.Negative_Gamma_Correction (Table));
   end Negative_Gamma_Correction;

   ----------------------
   -- Page_Address_Set --
   ----------------------

   procedure Page_Address_Set
     (SP : Interfaces.Unsigned_16;
      EP : Interfaces.Unsigned_16) is
   begin
      Send_Command (Raw.Page_Address_Set (SP, EP));
   end Page_Address_Set;

   ----------------------
   -- Pixel_Format_Set --
   ----------------------

   procedure Pixel_Format_Set
     (DPI : Bits_Per_Pixel := 18;
      DBI : Bits_Per_Pixel := 18) is
   begin
      Send_Command (Raw.Pixel_Format_Set (DBI => DBI, DPI => DPI));
   end Pixel_Format_Set;

   --------------------------------
   -- Positive_Gamma_Correction --
   --------------------------------

   procedure Positive_Gamma_Correction (Table : Gamma_Correction_Table) is
   begin
      Send_Command (Raw.Positive_Gamma_Correction (Table));
   end Positive_Gamma_Correction;

   ---------------------
   -- Power_Control_1 --
   ---------------------

   procedure Power_Control_1 (VRH : Byte) is
   begin
      Send_Command (Raw.Power_Control_1 (VRH));
   end Power_Control_1;

   ---------------------
   -- Power_Control_2 --
   ---------------------

   procedure Power_Control_2 (BT : Byte) is
   begin
      Send_Command (Raw.Power_Control_2 (BT));
   end Power_Control_2;

   ---------------------
   -- Power_Control_A --
   ---------------------

   procedure Power_Control_A
     (V_Core : Core_Mili_Volt  := 1_600;
      DDVDH  : DDVDH_Mili_Volt := 5_600) is
   begin
      Send_Command (Raw.Power_Control_A (V_Core, DDVDH));
   end Power_Control_A;

   ---------------------
   -- Power_Control_B --
   ---------------------

   procedure Power_Control_B
     (PCEQ : Boolean := False;
      DRV  : Boolean := False) is
   begin
      Send_Command (Raw.Power_Control_B (PCEQ, DRV));
   end Power_Control_B;

   -------------------------
   -- Pump_Ratio_Control --
   -------------------------

   procedure Pump_Ratio_Control (Ratio : Byte) is
   begin
      Send_Command (Raw.Pump_Ratio_Control (Ratio));
   end Pump_Ratio_Control;

   --------------
   -- Sleep_In --
   --------------

   procedure Sleep_In is
   begin
      Send_Command (Raw.Sleep_In);
   end Sleep_In;

   ---------------
   -- Sleep_Out --
   ---------------

   procedure Sleep_Out is
   begin
      Send_Command (Raw.Sleep_Out);
   end Sleep_Out;

   --------------------
   -- Software_Reset --
   --------------------

   procedure Software_Reset is
   begin
      Send_Command (Raw.Software_Reset);
   end Software_Reset;

   ----------------------
   -- VCOM_Control_1 --
   ----------------------

   procedure VCOM_Control_1
     (VMH : Byte;
      VML : Byte) is
   begin
      Send_Command (Raw.VCOM_Control_1 (VMH, VML));
   end VCOM_Control_1;

   ----------------------
   -- VCOM_Control_2 --
   ----------------------

   procedure VCOM_Control_2 (VMF : Byte) is
   begin
      Send_Command (Raw.VCOM_Control_2 (VMF));
   end VCOM_Control_2;

   ------------------
   -- Write_Memory --
   ------------------

   procedure Write_Memory is
   begin
      Send_Command (Raw.Write_Memory);
   end Write_Memory;

end ILI9341.Implementation;
