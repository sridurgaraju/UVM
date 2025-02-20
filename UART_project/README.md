# 🔍 UART Protocol Verification using UVM  

This project implements a **Universal Verification Methodology (UVM)** testbench to verify a **Universal Asynchronous Receiver-Transmitter (UART) design**. The testbench ensures that the UART **transmitter (TX) and receiver (RX)** function correctly by simulating **various baud rates, data lengths, parity modes, and stop bits**, using **constrained-random stimulus, functional coverage, and self-checking mechanisms**.  

---

## 📌 **Project Overview**  

### 🔹**UART Design**  

The **UART Top Module (`uart_top.sv`)** integrates the following components:  

✔ **Clock Generator (`clk_gen.sv`)**  
   - Generates UART clock signals (`tx_clk` & `rx_clk`) based on configurable **baud rates** (4800, 9600, 115200, etc.).  

✔ **UART Transmitter (`uart_tx.sv`)**  
   - Sends serial data based on **start bits, data length, parity, and stop bits**.  
   - Supports **odd/even parity** and **1 or 2 stop bits**.  
   - Signals **tx_done** when transmission is complete.  

✔ **UART Receiver (`uart_rx.sv`)**  
   - Receives serial data, extracts the bits, and reconstructs the **original message**.  
   - Checks **start/stop bits, parity**, and reports **rx_error** if mismatches occur.  
   - Signals **rx_done** when reception is complete.  

The **Top Module (`uart_top.sv`)** connects the **TX & RX modules**, allowing full-duplex UART communication for testing.  

---

### 🔹 **UVM Testbench**  

The UVM testbench verifies the UART TX & RX communication using a **self-checking environment**. It consists of:  

✔ **Testbench (`uart_tb.v`)**  
   - The **top-level testbench** responsible for:  
     - Instantiating the **UART interface (`uart_if`)** and connecting it to the UVM testbench components.  
     - Setting up the **DUT (`uart_top.sv`)**, including the transmitter, receiver, and clock generator.  
     - Launching the **UVM environment** and running test sequences.  
     - Handling **UVM reports, assertions, and test completion status**.  
     - Ensuring **data integrity between TX and RX** by checking that transmitted data matches received data.  

✔ **UVM Agent**  
   - Includes the **Driver, Monitor, and Sequencer** to generate UART transactions.  
   - The **Driver** sends stimulus to the UART transmitter.  
   - The **Monitor** collects transaction data for analysis.  

✔ **UVM Scoreboard**  
   - Compares **expected vs. actual** UART transactions.  
   - Detects errors in data transmission (mismatched baud rate, parity, stop bits, etc.).  

✔ **UVM Environment**  
   - Instantiates **UVM Agent, Scoreboard, and Testbench Components**.  
   - Provides a scalable setup for **UART protocol verification**.  

✔ **Test Sequences**  
   - Defines **stimulus** to verify different UART configurations (baud rate, parity, stop bits).  
   - Uses **constrained-random verification** to test multiple scenarios.  

---

## 🔧 **Running the Testbench**  

To compile and run this testbench, follow the **general simulation setup** provided in the **[UVM README](../README.md)**.  

🔗 **UVM Repository Simulation Guide**: [Click here](../README.md)  

This project is structured to work seamlessly within the **UVM environment**, so refer to the **main UVM repository documentation** for simulator-specific commands and setup instructions.  

---

## 📊 **Key UVM Features Used**  

✔ **UVM Agent** – Includes **Driver, Monitor, and Sequencer** to generate UART transactions.  
✔ **UVM Scoreboard** – Compares expected vs. actual data to check correctness.  
✔ **UVM Coverage** – Measures functional coverage for UART communication scenarios.  
✔ **Randomization** – Tests multiple UART configurations dynamically.  

---

## 📌 Future Enhancements  

✔ Extend the testbench to support **full-duplex communication** (simultaneous TX & RX).  
✔ Improve **functional coverage metrics** for different configurations.  

---

### 📬 Contact  
📧 Email: sridurgaraju07@gmail.com
🔗 LinkedIn: https://www.linkedin.com/in/sri-durga-raju/ 

---

Happy Verifying! 🚀🔬  

