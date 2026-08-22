--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

with ILI9341.Implementation_Read;
with ILI9341.Raw;

package body ILI9341.SPI_4_Wires_Read is

   function Receive_Command
     (Item : ILI9341.Raw.Read_Command) return Byte_Array
     with Inline;

   package Real is new ILI9341.Implementation_Read (Receive_Command);

   ----------------------
   -- Receive_Command --
   ----------------------

   function Receive_Command
     (Item : ILI9341.Raw.Read_Command) return Byte_Array
   is
      Reply : Byte_Array (1 .. Item.Reply_Size);
   begin
      Set_Data_Or_Command (Data => False);
      Send_Byte (Item.Command);
      Set_Data_Or_Command (Data => True);
      Receive_Bytes (Reply);
      Done;
      return Reply;
   end Receive_Command;

   -------------
   -- Read_ID --
   -------------

   function Read_ID return Byte_Array renames Real.Read_ID;

end ILI9341.SPI_4_Wires_Read;
