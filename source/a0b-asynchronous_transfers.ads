--
--  Copyright (C) 2025-2026, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with System.Storage_Elements;

with A0B.Types;

package A0B.Asynchronous_Transfers
  with Pure
is

   type Operation_State is
     (Inactive,  --  Not active
      Active,    --  Active
      Success,   --  Completed successfully
      Failure);  --  Failed
   --  Status of the requested operation.

   type Transfer_Descriptor is limited record
      Buffer      : System.Address;
      Length      : System.Storage_Elements.Storage_Count;
      Transferred : System.Storage_Elements.Storage_Count := 0;
      State       : Operation_State                       := Inactive;
   end record;
   --  Descriptor of the data transfer.
   --
   --  @component Buffer       Address of the first byte of the buffer
   --  @component Length       Number of bytes in the buffer to be processed
   --  @component Transferred  Number of bytes transferred by the operation
   --  @component State        State of the operation
   --
   --  `Buffer` and `Length` components should be setup by the application,
   --  while `Transferred` and `State` are updated by the operation.

   type Transfer_Descriptor_Array is
     array (A0B.Types.Unsigned_32 range <>) of access Transfer_Descriptor;
   --  Sequence of transfer descriptors for massive operations.

   procedure Initialize
     (Self   : out Transfer_Descriptor;
      Data   : System.Address;
      Length : System.Storage_Elements.Storage_Count) with Inline;
   --  Initialize `Self` to describe a transfer of `Length` bytes starting at
   --  `Data`. Reset amount of transfered data to zero and state to inactive.

   procedure Set_Success
     (Self        : in out Transfer_Descriptor;
      Transferred : System.Storage_Elements.Storage_Count) with Inline;
   --  Change state to `Success` and set the number of bytes transferred by the
   --  operation.

   procedure Set_Failure
     (Self        : in out Transfer_Descriptor;
      Transferred : System.Storage_Elements.Storage_Count) with Inline;
   --  Change state to `Failure` and set the number of bytes transferred before
   --  the failure.

end A0B.Asynchronous_Transfers;
