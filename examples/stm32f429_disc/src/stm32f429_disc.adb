--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with Interfaces;

with STM32.GPIO;
with STM32.SPI.Polling_SPI_5;
with ILI9341.SPI_4_Wires;

procedure Stm32f429_Disc is

   RST : constant STM32.Pin := (STM32.PA, 7);
   CS : constant STM32.Pin := (STM32.PC, 2);
   DC : constant STM32.Pin := (STM32.PD, 13);
   --  SPI5
   package SPI renames STM32.SPI.Polling_SPI_5;
   --  PF7 - SCL
   --  PF8 - MISO
   --  PF9 - MOSI

   procedure Set_Data_Or_Command (Data : Boolean);
   procedure Send_Byte (Data : Interfaces.Unsigned_8) renames SPI.Send;
   procedure Done;

   procedure Set_Data_Or_Command (Data : Boolean) is
   begin
      STM32.GPIO.Set_Output (Pin => CS, Value => 0);  --  Set CS low

      while SPI.Status.Busy loop
         null;
      end loop;

      STM32.GPIO.Set_Output (DC, Boolean'Pos (Data));
   end Set_Data_Or_Command;

   procedure Done is
   begin
      STM32.GPIO.Set_Output (Pin => CS, Value => 1);  --  Set CS high
   end Done;

   package TFT is new ILI9341.SPI_4_Wires
     (Set_Data_Or_Command, Send_Byte, Done);

begin
   STM32.GPIO.Configure_Output (Pin => RST);
   STM32.GPIO.Set_Output (Pin => RST, Value => 1);
   STM32.GPIO.Configure_Output (Pin => CS);
   STM32.GPIO.Set_Output (Pin => CS, Value => 1);
   STM32.GPIO.Configure_Output (Pin => DC);
   STM32.GPIO.Set_Output (Pin => DC, Value => 1);

   --  Reset display
   STM32.GPIO.Set_Output (Pin => RST, Value => 0);
   delay 0.05;
   STM32.GPIO.Set_Output (Pin => RST, Value => 1);
   delay 0.02;

   SPI.Configure
     (SCK   => (STM32.PF, 7),
      MISO  => (STM32.PF, 8),
      MOSI  => (STM32.PF, 9),
      Speed => 22_000_000,
      Mode  => 0);

   TFT.Pixel_Format_Set (DBI => 16, DPI => 16);

   TFT.Sleep_Out;
   delay 0.2;
   TFT.Display_On;
   TFT.Write_Memory;

   STM32.GPIO.Set_Output (Pin => CS, Value => 0);  --  Set CS low

   for J in 1 .. 240 * 320 loop
      SPI.Send (Interfaces.Unsigned_8'Mod (J / 256));
      SPI.Send (Interfaces.Unsigned_8'Mod (J));
   end loop;

   STM32.GPIO.Set_Output (Pin => CS, Value => 1);  --  Set CS high

   loop
      delay 1.0;
   end loop;

end Stm32f429_Disc;
