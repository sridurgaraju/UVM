# 🧠 Memory Controller with CSR Interface

This project implements a **Memory Controller** hardware module in SystemVerilog along with a **UVM-based testbench** that uses **RAL (Register Abstraction Layer)** to access and verify register behavior.

The controller provides a **CSR (Control and Status Register)** interface to manage memory operations (like reads/writes).

Rather than interacting directly with the memory, users set values in registers — and the controller uses those values to perform operations.

---

## 🧩 Interface Overview

Communication with the memory controller is done using a **CSR interface**:

- `csr_wr_en`: Write Enable  
- `csr_rd_en`: Read Enable  
- `csr_addr`: Address of the register  
- `csr_wr_data`: Data to write  
- `csr_rd_data`: Data read back  

---

## 🗂 Register Map

| Register Name   | Address | Purpose                               | Access     |
|-----------------|---------|----------------------------------------|------------|
| `mem_ctrl_reg`  | 0x00    | Start and select memory operation mode | Read/Write |
| `mem_status_reg`| 0x04    | Shows whether controller is busy       | Read-Only  |
| `mem_cfg_reg`   | 0x08    | Configure burst length and latency     | Read/Write |
| `mem_error_reg` | 0x0C    | Indicates errors                       | Read-Only  |
| `mem_id_reg`    | 0x10    | Controller ID (hardcoded)              | Read-Only  |

---

## 🛠 How Does It Work?

### ✅ Writing to a Register

To perform a write:
- Set `csr_wr_en = 1`
- Set `csr_addr` to the register address
- Set `csr_wr_data` to the value to write

Only writable registers will accept writes.  
Writing to read-only registers is ignored.

### 🔎 Reading a Register

To read from a register:
- Set `csr_rd_en = 1`
- Set `csr_addr` to the register address
- The value will appear on `csr_rd_data`

Invalid addresses return a default value: `0x00000000`.

---

## 🧮 Register Bit Descriptions

### 1. `mem_ctrl_reg` (0x00)
- **Bit [0]** → `start` bit: starts memory operation when set to `1`
- **Bits [4:1]** → `mode`: selects operation mode
  
### 2. `mem_cfg_reg` (0x08)
- **Bits [7:0]** → Burst Length
- **Bits [11:8]** → Latency

### 3. `mem_status_reg` (0x04)
- **Bit [0]** → `busy` bit  
  Indicates whether the controller is currently operating.

### 4. `mem_error_reg` (0x0C)
- **Bit [0]** → `error_flag`  
  Set to 1 if an error occurs during operation - when both the `csr_wr_en` and `csr_rd_en` are enabled at the same time.

### 5. `mem_id_reg` (0x10)
- Hardcoded to `0x1234ABCD` to identify the memory controller.

---

## 🎯 Output Signal Mapping

| Output Signal      | Source Field          | Description                          |
|--------------------|------------------------|--------------------------------------|
| `mem_start`        | `mem_ctrl_reg[0]`      | Initiates memory access              |
| `mem_mode`         | `mem_ctrl_reg[4:1]`    | Selects access mode                  |
| `mem_burst_length` | `mem_cfg_reg[7:0]`     | Number of words to transfer          |
| `mem_latency`      | `mem_cfg_reg[11:8]`    | Response delay                       |
| `error_flag`       | `mem_error_reg[0]`     | Indicates if an error occurred       |

---

## 🧪 UVM Testbench (RAL-Based)

This project uses a **UVM Register Abstraction Layer (RAL)** model to streamline and abstract register-level operations in the testbench.

### 🚀 UVM Features Used

- **Register Abstraction Layer (RAL):**
  - Abstracts memory-mapped register accesses.
  - Simplifies CSR programming and checking.
  - Includes `uvm_reg_block`, register models, and adapter.

- **Sequence and Sequencer Architecture:**
  - Enables modular and reusable test scenarios.
  - Includes standard and RAL-based sequences.

- **Scoreboard:**
  - Checks functional correctness of DUT output.
  - Compares expected vs actual data transactions.

- **Monitor:**
  - Passive component that observes bus transactions.
  - Used for coverage and functional checking.

- **Driver:**
  - Converts sequence items into pin-level activity on the interface.
  - Communicates with sequencer and DUT.

- **Coverage Collection:**
  - Collects functional coverage for stimulus and register access.

- **Test and Environment Structure:**
  - Modular `env`, `test`, and config-driven architecture.
  - Promotes reuse across multiple testbenches or DUT variants.

These features together ensure maintainability, reusability, and thorough verification of the memory controller.

---

## Coverage Analysis

Detailed functional coverage results are provided in the [`cov.txt`](./cov.txt) file located in this repository.

The coverage analysis includes:

- Register-level coverage for:
  - `mem_cntrl_reg`
  - `mem_cfg_reg`
  - `mem_status_reg`
  - `mem_error_reg`
- Address coverage using `csr_addr` to track the exercised register addresses during simulation.

Each register was monitored using a UVM register model with appropriate covergroups defined for its fields. The address coverage ensures that all relevant CSR addresses were accessed as expected. The report captures bin hits, functional scenarios, and helps identify any untested conditions.

---

## 📦 What's Included

### RTL + Interface
- `memory_controller.sv`  

### UVM Testbench 
- `tb.sv`

### UVM Testbench + Coverage 
- `testbench.sv`

---

## 🔧 **Running the Testbench**  

To compile and run this testbench, follow the **general simulation setup** provided in the **[UVM README](../README.md)**.  

🔗 **UVM Repository Simulation Guide**: [Click here](../README.md)  

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to propose.
