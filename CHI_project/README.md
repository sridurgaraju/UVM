# CHI Protocol Implementation in SystemVerilog

This repository contains a simplified implementation of the **ARM AMBA Coherent Hub Interface (CHI)** protocol using SystemVerilog.

> 🔧 **Note:** This project is currently a work in progress. I'm in the process of building out a full verification environment using UVM and functional coverage.

---

## ✅ Current Status

- Implemented basic CHI modules: **Request Node (RN)**, **Home Node (HN)**, and **Slave Node (SN)**
- Developed a **basic SystemVerilog testbench** (`CHI_tb.sv`) to validate:
  - Memory write transactions
  - Memory read transactions
  - Cache coherence state transitions (MESI/MOESI - conceptual)

> View the `CHI_tb.sv` file for the current working testbench code.

---

## 🚧 Upcoming Features

- [ ] Full **UVM-based testbench** to test:
  - Coherent transactions between nodes
  - MESI/MOESI cache state handling
  - Protocol correctness under different transaction orders
- [ ] **Functional coverage** model to verify:
  - Address range coverage
  - Cache state transitions
  - Transaction types (read/write/invalidate/clean)
- [ ] Modular testcases using **UVM sequences**
- [ ] Integration with **Vivado/ModelSim/Questa** for simulation and coverage analysis

---

## 🧪 Test Scenarios (Implemented)

The following scenarios are covered in the basic testbench:

1. **Write to Memory**
   - Address: `0x10`
   - Data: `0xABCD1234`

2. **Read from Memory**
   - Same address to validate data consistency

3. **Cache Coherence**
   - Re-read to simulate MESI state change (Expected: Exclusive/Shared)

---

## 📌 Requirements

- **Simulation Tools**:  
  - Xilinx Vivado  
  - ModelSim / QuestaSim  
  - Any SystemVerilog-compatible simulator

- **Optional**:  
  - [GTKWave](http://gtkwave.sourceforge.net/) for viewing waveform dumps (`*.vcd`)

---

## 🔗 Future Improvements

If you’re interested in collaborating or have ideas on expanding this protocol implementation (e.g., adding AXI, trace-based testing, memory models), feel free to reach out or open an issue.

---

## 🙌 Acknowledgements

- **ARM AMBA CHI documentation** — for protocol specification and design reference  
- **Open-source communities** — for educational resources on SoC design, cache coherence, and UVM verification methodologies


