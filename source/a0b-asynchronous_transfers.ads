--
--  Copyright (C) 2025-2026, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with System;

with A0B.Storage;
with A0B.Types;

package A0B.Asynchronous_Transfers
  with Preelaborate, SPARK_Mode => On
is

   use type A0B.Storage.Address;
   use type A0B.Storage.Storage_Offset;

   type Operation_State is
     (Inactive,  --  Not active
      Active,    --  Active
      Success,   --  Completed successfully
      Failure);  --  Failed
   --  Status of the requested operation.

   type Transfer_Descriptor is limited record
      Buffer      : A0B.Storage.Address;
      Length      : A0B.Storage.Storage_Count;
      Transferred : A0B.Storage.Storage_Count := 0;
      State       : Operation_State           := Inactive;
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

   type Transfer_Descriptor_Access is access all Transfer_Descriptor;

   type Transfer_Descriptor_Array is
     array (A0B.Types.Unsigned_32 range <>) of Transfer_Descriptor_Access;
   --  Sequence of transfer descriptors for massive operations.

   procedure Initialize
     (Self   : out Transfer_Descriptor;
      Data   : System.Address;
      Length : A0B.Storage.Storage_Count)
     with Inline,
          Global  => null,
          Depends => (Self => (Data, Length)),
          Post    => Self.Buffer = A0B.Storage.As_Address (Data)
            and then Self.Length = Length
            and then Self.Transferred = 0
            and then Self.Transferred <= Self.Length
            and then Self.State = Inactive;
   --  Initialize `Self` to describe a transfer of `Length` bytes starting at
   --  `Data`. Reset amount of transfered data to zero and state to inactive.

   procedure Set_Active (Self : in out Transfer_Descriptor)
     with Inline,
          Global  => null,
          Depends => (Self => (Self)),
          Pre     => Self.State = Inactive,
          Post    => Self.Buffer = Self.Buffer'Old
            and then Self.Length = Self.Length'Old
            and then Self.Transferred = 0
            and then Self.State = Active;

   procedure Set_Success
     (Self        : in out Transfer_Descriptor;
      Transferred : A0B.Storage.Storage_Count)
     with Inline,
          Global  => null,
          Depends => (Self => (Self, Transferred)),
          Pre     => Self.State = Active
            and then Transferred <= Self.Length,
          Post    => Self.Buffer = Self.Buffer'Old
            and then Self.Length = Self.Length'Old
            and then Self.Transferred = Transferred
            and then Self.Transferred <= Self.Length
            and then Self.State = Success;
   --  Change state to `Success` and set the number of bytes transferred by the
   --  operation.
   --  Requires an active operation and an amount not exceeding `Self.Length`.
   --  Successful completion may transfer fewer than `Self.Length` bytes.

   procedure Set_Failure
     (Self        : in out Transfer_Descriptor;
      Transferred : A0B.Storage.Storage_Count)
     with Inline,
          Global  => null,
          Depends => (Self => (Self, Transferred)),
          Pre     => Self.State = Active
            and then Transferred <= Self.Length,
          Post    => Self.Buffer = Self.Buffer'Old
            and then Self.Length = Self.Length'Old
            and then Self.Transferred = Transferred
            and then Self.Transferred <= Self.Length
            and then Self.State = Failure;
   --  Change state to `Failure` and set the number of bytes transferred before
   --  the failure.
   --  Requires an active operation and an amount not exceeding `Self.Length`.

end A0B.Asynchronous_Transfers;
