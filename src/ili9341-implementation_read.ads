--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Generic implementation of ILI9341 read commands, transport-agnostic
--  the same way ILI9341.Implementation is for writes: any transport
--  that can clock Item.Reply_Size bytes back for a given opcode (4-wire
--  SPI, the 8080 parallel bus, ...) instantiates this with a
--  Receive_Command of its own.

with ILI9341.Raw;

generic
   with function Receive_Command
     (Item : ILI9341.Raw.Read_Command) return Byte_Array;
package ILI9341.Implementation_Read is
   pragma Pure;

   function Read_ID return Byte_Array;
   --  Returns the 3 real ID bytes (manufacturer, driver version,
   --  driver ID) -- RDID's leading dummy byte (ILI9341.Raw.Read_ID)
   --  is already stripped.

   function Read_Memory return Byte_Array;
   --  Returns the 3 real 18-bit-expanded RGB bytes -- RAMRD's leading
   --  dummy byte (ILI9341.Raw.Read_Memory) is already stripped. See
   --  ILI9341.Raw.Read_Memory for the byte layout; converting to a
   --  specific pixel type is left to the caller.

end ILI9341.Implementation_Read;
