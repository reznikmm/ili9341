--  SPDX-FileCopyrightText: 2025 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------
--  pragma Ada_2022;

with Interfaces;

package ILI9341 is
   pragma Pure;

   subtype Byte is Interfaces.Unsigned_8;

   type Byte_Array is array (Positive range <>) of Byte;

   type Core_Mili_Volt is range 1_400 .. 1_700
     with Static_Predicate => Core_Mili_Volt in
     1_400 | 1_500 | 1_550 | 1_600 | 1_650 | 1_700;
   --  Core voltage to REG_VD

   type DDVDH_Mili_Volt is range 5_200 .. 5_800
     with Static_Predicate => DDVDH_Mili_Volt in
       5_200 | 5_300 | 5_400 | 5_500 | 5_600 | 5_700 | 5_800;
   --  DDVDH voltage for VBC

   type Bits_Per_Pixel is range 16 .. 18
     with Static_Predicate => Bits_Per_Pixel in 16 | 18;

   subtype Zero_To_3 is Integer range 0 .. 3;
   subtype Zero_To_1 is Integer range 0 .. 1;
   subtype Minus_1_To_0 is Integer range -1 .. 0;
   subtype Minus_2_To_0 is Integer range -2 .. 0;

end ILI9341;
