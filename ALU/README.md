# ALU Design and UVM-Based Verification (Based on RISC-V RV32I)

## 📌 Overview

This project implements and verifies a 32-bit Arithmetic Logic Unit (ALU) using **SystemVerilog** and **Universal Verification Methodology (UVM)**. The ALU is based on the **RV32I** base integer instruction set of the **RISC-V processor architecture**.

The UVM-based testbench includes:
- Constrained-random stimulus generation
- Assertions for functional correctness
- Functional coverage collection
- A scoreboard with a reference model for result checking

---

## ⚙️ RISC-V RV32I Compliance

The ALU design follows the operation semantics defined in the **RV32I** instruction set of the RISC-V architecture. Supported operations include:

- Arithmetic: ADD, SUB
- Logical: AND, OR, XOR
- Shifts: SLL, SRL, SRA
- Comparisons: SLT (signed), SLTU (unsigned)

This makes the ALU suitable for integration into a RISC-V-based CPU pipeline or standalone verification environments.

---

## 🧠 ALU Operations Supported

| ALU Control | Operation | Description |
|-------------|-----------|-------------|
| `0000` | AND | Bitwise AND |
| `0001` | OR | Bitwise OR |
| `0010` | ADD | Addition |
| `0011` | XOR | Bitwise XOR |
| `0100` | SLL | Logical left shift |
| `0101` | SRL | Logical right shift |
| `0110` | SUB | Subtraction |
| `0111` | SRA | Arithmetic right shift |
| `1000` | SLT | Set if less than (signed) |
| `1001` | SLTU | Set if less than (unsigned) |

---

## 🧪 UVM Testbench Architecture

This project uses a **Universal Verification Methodology (UVM)** testbench with modular components that verify ALU functionality through dynamic and reusable verification strategies.

### 🚀 UVM Components Used

- **Transaction (sequence item)**: Encapsulates operand_a, operand_b, alu_control, result, zero_flag.
- **Sequence**: Generates randomized operations across the RV32I ALU control space.
- **Driver**: Drives interface signals from sequence items to the DUT.
- **Monitor**: Observes interface activity, checks assertions, and collects coverage.
- **Scoreboard**: Compares DUT outputs to the expected result using a reference model.
- **Environment**: Instantiates and connects agent, scoreboard, and test components.
- **Test**: Runs the sequence and raises objections.

---

## 📈 Included Output Files

- 📸 **Waveform Snapshot**:  
  The waveform output is saved as [`alu_output.png`](./alu_output.png), showing simulation signals including operands, control signals, result, and zero_flag.

- 📊 **Coverage Report**:  
  A full functional coverage log is included as [`cov.txt`](./cov.txt), summarizing which ALU operations and operand ranges were exercised.

---

## 📊 Coverage Highlights

The testbench collects coverage for:

- ALU control signals (each operation)
- Operand ranges (e.g., low/high value bins)
- Zero-flag conditions
- Assertion checks (e.g., valid opcode, zero_flag correctness)

For more detail, refer to [`cov.txt`](./cov.txt).

---

## ✔️ Features Covered

- ✅ **RV32I-compliant ALU operation modeling**  
  ALU design follows the RISC-V RV32I specification for integer operations.

- ✅ **UVM-based self-checking testbench**  
  A modular UVM testbench architecture with driver, monitor, scoreboard, sequencer, and reusable test components.

- ✅ **Functional and assertion-based verification**  
  Assertions check correctness of zero flag and valid operation codes during runtime.

- ✅ **Constrained-random test generation**  
  Randomized operands and operations ensure wide input space coverage.

- ✅ **Coverage-driven analysis**  
  Functional coverage is collected and summarized to assess verification completeness.

---

## 🔧 **Running the Testbench**  

To compile and run this testbench, follow the **general simulation setup** provided in the **[UVM README](../README.md)**.  

🔗 **UVM Repository Simulation Guide**: [Click here](../README.md)  

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to propose.


