--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
----------------------------------------------------------------

--  Read-direction counterpart of ILI9341.SPI_4_Wires: a separate
--  generic, not an extra formal bolted onto SPI_4_Wires itself, so
--  write-only instantiations (the common case -- most applications
--  never read the panel back) don't have to supply a Receive_Bytes
--  they don't need. Instantiate both over the same Set_Data_Or_Command
--  / Send_Byte pair (and the same underlying bus) when reads are
--  needed.
--
--  Receive_Bytes takes the whole reply in one call rather than one
--  byte at a time: unlike writes (where each byte is naturally
--  self-contained -- the opcode, then each parameter), the panel needs
--  CS held continuously across a multi-byte reply. A module wired
--  through hardware CS that auto-asserts/deasserts per bus transaction
--  (e.g. HAL.SPI.SPI_Port implementations) would otherwise drop CS
--  between bytes and desync the read -- confirmed on real hardware
--  while building this: a one-byte-at-a-time Receive_Byte formal
--  turned a working RDID read into all-zero replies.

with Interfaces;

generic
   with procedure Set_Data_Or_Command (Data : Boolean);
   with procedure Send_Byte (Data : Interfaces.Unsigned_8);
   with procedure Receive_Bytes (Data : out Byte_Array);
   with procedure Done is null;
package ILI9341.SPI_4_Wires_Read is
   pragma Pure;

   function Read_ID return Byte_Array;
   --  See ILI9341.Implementation_Read.Read_ID.

   function Read_Memory return Byte_Array;
   --  See ILI9341.Implementation_Read.Read_Memory.

end ILI9341.SPI_4_Wires_Read;
