--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

package body ILI9341.Implementation_Read is

   -------------
   -- Read_ID --
   -------------

   function Read_ID return Byte_Array is
      Reply : constant Byte_Array := Receive_Command (Raw.Read_ID);
   begin
      return Reply (Reply'First + 1 .. Reply'Last);
   end Read_ID;

end ILI9341.Implementation_Read;
