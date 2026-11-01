# A0B: Asynchronous Operations

[![Alire](https://img.shields.io/endpoint?url=https://alire.ada.dev/endpoint/a0b_asynchronous_operations.json)](https://alire.ada.dev/crates/a0b_asynchronous_operations)
[![License](https://img.shields.io/badge/license-Apache--2.0%20WITH%20LLVM--exception-blue)](LICENSE.txt)

A0B (Ada on Board) is a collection of low-level Ada packages designed for embedded development.

The `a0b_asynchronous_operations` crate provides core Ada types, abstractions, and transfer descriptors for managing non-blocking, asynchronous operations and batch transfers.

---

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

---

## Usage

### Helper procedures

- `Initialize` sets the buffer address and length, resets the transferred byte count to zero, and sets the state to `Inactive`.
- `Set_Active` sets buffer to active state, and sets trandserred byte count to zero.
- `Set_Success` records successful completion and the transferred byte count.
- `Set_Failure` records failure and the number of bytes transferred before the failure.

### Application

```ada
Buffer     : A0B.Types.Arrays.Unsigned_8_Array (1 .. 1024);
Descriptor : aliased A0B.Asynchronous_Transfers.Transfer_Descriptor;

procedure Initiate_Write
  (Callback : A0B.Callbacks.Callback;
   Success  : in out Boolean) is
begin
   A0B.Asynchronous_Operations.Initialize
     (Descriptor, Buffer'Address, Buffer'Length);
   Write (Device, Descriptor, Callback, Success);
end Initiate_Write;

procedure On_Callback is
begin
   Put_Line (Descriptor.Transferred'Image);
end On_Callback;
```

### Device driver

```ada
procedure Write
  (Self       : in out Device;
   Descriptor : aliased in out A0B.Asynchronous_Transfers.Transfer_Descriptor;
   Callback   : A0B.Callbacks.Callback;
   Success    : in out Boolean) is
begin
   A0B.Asynchronous_Transfers.Set_Active (Descriptor);
end Write;

procedure Interrupt_Handler is
begin
   A0B.Asynchronous_Transfers.Set_Success (Descriptor, Size);
   A0B.Callbacks.Emit_Once (Callback);
end Interrupt_Handler;
```

---

## Requirements

* **Compiler:** GNAT Ada compiler
* **Runtime:** compatible with any runtimes, including `light` and tasking profiles
* **Dependencies:**
  * `a0b_base`

---

## Installation via Alire

This package is part of the [Alire](https://alire.ada.dev/) ecosystem. You can easily add it to your project by running:

```bash
alr with a0b_asynchronous_operations
```

Or by adding the dependency directly into your project's `alire.toml`:

```toml
[dependencies]
a0b_asynchronous_operations = "*"
```

---

## License

Apache-2.0 WITH LLVM-exception. See [LICENSE.txt](LICENSE.txt).
