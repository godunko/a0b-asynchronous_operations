--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with System;

with A0B.Types;

package A0B.Asynchronous_Operations
  with Pure
is

   type Operation_State is
     (Active,    --  Active
      Success,   --  Completed successfully
      Failure);  --  Failed
   --  Status of the requested operation.

   type Transfer_Descriptor is tagged record
      Buffer      : System.Address;
      Length      : A0B.Types.Unsigned_32;
      Transferred : A0B.Types.Unsigned_32                       := 0;
      State       : A0B.Asynchronous_Operations.Operation_State := Active;
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
   --
   --  Sometimes, more information is necessary to do operation. Thus, type is
   --  declared as tagged and derived types can be used to extend descriptor
   --  for particular purpose.

end A0B.Asynchronous_Operations;
