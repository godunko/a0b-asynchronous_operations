# A0B: Asynchronous Operations

Common Ada types and utilities for describing asynchronous data transfers in the A0B embedded framework.

## Transfer descriptors

The `A0B.Asynchronous_Transfers` package provides a limited type `Transfer_Descriptor` with the following fields:

| Field | Description |
| --- | --- |
| `Buffer` | Address of the first byte of the buffer |
| `Length` | Number of bytes to transfer |
| `Transferred` | Number of bytes transferred |
| `State` | Operation state: `Inactive`, `Active`, `Success`, or `Failure` |

The application supplies the buffer address and requested length.
The operation updates the transferred byte count and state.

`Transfer_Descriptor_Array` represents a sequence of references to transfer descriptors for batch operations.

## Helper procedures

- `Initialize` sets the buffer address and length, resets the transferred byte count to zero, and sets the state to `Inactive`.
- `Set_Success` records successful completion and the transferred byte count.
- `Set_Failure` records failure and the number of bytes transferred before the failure.

## Dependencies

- `a0b_base`

## License

Apache-2.0 WITH LLVM-exception. See [LICENSE.txt](LICENSE.txt).
