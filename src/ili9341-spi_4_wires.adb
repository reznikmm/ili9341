--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with ILI9341.Implementation;
with ILI9341.Raw;

package body ILI9341.SPI_4_Wires is

   procedure Send_Command (Item : ILI9341.Raw.Command)
     with Inline;

   procedure Receive_Command
     (Item  : ILI9341.Raw.Read_Command;
      Reply : out Byte_Array)
     with Inline;

   package Real is new ILI9341.Implementation
     (Send_Command             => Send_Command,
      Receive_Command          => Receive_Command,
      Receive_Command_Is_Null  => False);
   --  Always False, a static literal, not Receive_Bytes_Is_Null
   --  itself -- ILI9341.Implementation is pragma Pure, and a Pure
   --  unit's own generic instantiations need static actuals for
   --  formal objects (RM 4.9(5)), so a non-static generic formal like
   --  Receive_Bytes_Is_Null cannot be threaded through here. The real
   --  check on Receive_Bytes_Is_Null happens below, in Read_ID/
   --  Read_Memory themselves, before they ever reach Real.

   ------------------------
   -- Column_Address_Set --
   ------------------------

   procedure Column_Address_Set
     (SC : Interfaces.Unsigned_16;
      EC : Interfaces.Unsigned_16) renames Real.Column_Address_Set;

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

   -------------
   -- Read_ID --
   -------------

   function Read_ID return Byte_Array renames Real.Read_ID;

   -----------------
   -- Read_Memory --
   -----------------

   function Read_Memory return Byte_Array renames Real.Read_Memory;

   ------------------------
   -- Receive_Command --
   ------------------------

   procedure Receive_Command
     (Item  : ILI9341.Raw.Read_Command;
      Reply : out Byte_Array) is
   begin
      Set_Data_Or_Command (Data => False);
      Send_Byte (Item.Command);
      Set_Data_Or_Command (Data => True);
      Receive_Bytes (Reply);
      Done;
   end Receive_Command;

   ------------------
   -- Send_Command --
   ------------------

   procedure Send_Command (Item : ILI9341.Raw.Command) is
   begin
      Set_Data_Or_Command (Data => False);
      Send_Byte (Item.Command);
      Set_Data_Or_Command (Data => True);

      for Parameter of Item.Parameters loop
         Send_Byte (Parameter);
      end loop;

      Done;
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

   ------------------
   -- Write_Memory --
   ------------------

   procedure Write_Memory renames Real.Write_Memory;

end ILI9341.SPI_4_Wires;
