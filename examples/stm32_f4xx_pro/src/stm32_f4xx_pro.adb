--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;
with System;

with STM32.GPIO;
with STM32.FSMC;

with ILI9341.Bus_16_II;

procedure Stm32_F4xx_Pro is
   --  function "+"
   --    (Left : System.Address;
   --     Right : System.Storage_Elements.Storage_Offset) return System.Address
   --      renames System.Storage_Elements."+";

   --  Data_Addr : System.Address := System'To_Address (0);
   --  is (STM32.FSMC.Bank_1_Start (Subbank => 4) + 2**7);

   Data : Interfaces.Unsigned_16
     with
       Import,
       Address => System'To_Address (16#6C00_0080#),
       Volatile;

   package TFT is new ILI9341.Bus_16_II
     (Command => STM32.FSMC.Bank_1_Start (Subbank => 4),
      Data    => Data'Address);

   LED : constant STM32.Pin := (STM32.PF, 9);
   LCD_Back_Light : constant STM32.Pin := (STM32.PB, 15);

   FSMC : constant STM32.FSMC.Pin_Array :=
     ((STM32.PD, 14), (STM32.PD, 15), (STM32.PD, 0), (STM32.PD, 1),
      (STM32.PE, 7), (STM32.PE, 8),  (STM32.PE, 9), (STM32.PE, 10),
      (STM32.PE, 11), (STM32.PE, 12), (STM32.PE, 13), (STM32.PE, 14),
      (STM32.PE, 15), (STM32.PD, 8),  (STM32.PD, 9), (STM32.PD, 10),
      --  Data pins (D0 .. D15)
      (STM32.PF, 12),  -- A6
      --  Only one address pin is connected to the TFT header
      (STM32.PG, 12),  -- NE4, Chip select pin for TFT LCD
      (STM32.PD, 4),   --  NOE, Output enable pin
      (STM32.PD, 5));  --  NWE, Write enable pin

begin
   STM32.FSMC.Initialize (FSMC);

   STM32.FSMC.Configure
     (Bank_1 =>
        (4 =>  --  TFT is connected to sub-bank 4
             (Is_Set => True,
              Value  =>
                (Write_Enable  => True,
                 Bus_Width     => STM32.FSMC.Half_Word,
                 Memory_Type   => STM32.FSMC.SRAM,
                 Bus_Turn      => 15,  --  90ns
                 Data_Setup    => 57, --  342ns
                 Address_Setup => 0,
                 Extended      =>
                   (STM32.FSMC.Mode_A,
                    Write_Bus_Turn      => 3,  --  18ns
                    Write_Data_Setup    => 2,  --  12ns
                    Write_Address_Setup => 0),
                 others        => <>)),
         others => <>));

   STM32.GPIO.Configure_Output (LED);
   STM32.GPIO.Configure_Output (LCD_Back_Light);
   STM32.GPIO.Set_Output (LCD_Back_Light, 1);

   TFT.Pixel_Format_Set (DBI => 16);

   TFT.Sleep_Out;
   delay 0.005;
   TFT.Display_On;
   TFT.Write_Memory;

   for J in 1 .. 240 * 320 loop
      Data := Interfaces.Unsigned_16'Mod (J);
   end loop;

   for J in 1 .. 1E9 loop
      STM32.GPIO.Set_Output (LED, STM32.Bit (J mod 2));
      delay 1.0;
   end loop;
end Stm32_F4xx_Pro;
