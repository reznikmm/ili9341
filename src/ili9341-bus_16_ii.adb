--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with ILI9341.Raw;

package body ILI9341.Bus_16_II is

   procedure Send_Command (Item : ILI9341.Raw.Command)
     with Inline;

   ------------------------
   -- Column_Address_Set --
   ------------------------

   procedure Column_Address_Set
     (SC : Interfaces.Unsigned_16;
      EC : Interfaces.Unsigned_16) is
   begin
      Send_Command (Raw.Column_Address_Set (SC, EC));
   end Column_Address_Set;

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

   ------------------
   -- Write_Memory --
   ------------------

   procedure Write_Memory is
   begin
      Send_Command (Raw.Write_Memory);
   end Write_Memory;

end ILI9341.Bus_16_II;
