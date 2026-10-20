--
--  Copyright (C) 2025-2026, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body A0B.Asynchronous_Operations is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Self   : out Transfer_Descriptor;
      Data   : System.Address;
      Length : System.Storage_Elements.Storage_Count) is
   begin
      Self.Buffer      := Data;
      Self.Length      := Length;
      Self.Transferred := 0;
      Self.State       := Inactive;
   end Initialize;

   -----------------
   -- Set_Failure --
   -----------------

   procedure Set_Failure
     (Self        : in out Transfer_Descriptor;
      Transferred : System.Storage_Elements.Storage_Count) is
   begin
      Self.Transferred := Transferred;
      Self.State       := Failure;
   end Set_Failure;

   -----------------
   -- Set_Success --
   -----------------

   procedure Set_Success
     (Self        : in out Transfer_Descriptor;
      Transferred : System.Storage_Elements.Storage_Count) is
   begin
      Self.Transferred := Transferred;
      Self.State       := Success;
   end Set_Success;

end A0B.Asynchronous_Operations;
