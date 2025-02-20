# 🔍 I2C Protocol Verification using UVM  

This project implements a **Universal Verification Methodology (UVM)** testbench to verify an **I2C (Inter-Integrated Circuit) design**. The testbench ensures that the I2C Master correctly reads from and writes to an I2C Memory, using **constrained-random stimulus, functional coverage, and self-checking mechanisms**.  

---

## 📌 **Project Overview**  

### 🔹 **I2C Design**  

The **I2C Memory (`i2c_mem.sv`)**:  
✔ Implements a **128-byte memory** accessible via I2C transactions.  
✔ Supports **read and write operations** using I2C standard signals (`SDA`, `SCL`).  
✔ Uses a **state machine** to control data flow and acknowledge signals.  

---

### 🔹 **UVM Testbench**  

The UVM testbench is designed to **verify I2C communication using a self-checking environment**. It consists of:  

✔ **Testbench (`tb.sv`)**  
   - The **top-level testbench** responsible for setting up and running the UVM environment.  
   - Instantiates the **I2C interface (`i2c_i`)** and connects it to the UVM testbench components.  
   - Triggers **UVM test sequences** that generate read/write transactions.  
   - Captures and reports test results, including **pass/fail status and functional coverage**.  

✔ **UVM Agent**  
   - Includes the **Driver, Monitor, and Sequencer** to generate I2C transactions.  
   - The **Driver** sends stimulus to the I2C Master.  
   - The **Monitor** collects transaction data for analysis.  

✔ **UVM Scoreboard**  
   - Compares **expected vs. actual** I2C transactions.  
   - Detects errors in data transmission.  

✔ **UVM Environment**  
   - Instantiates **UVM Agent, Scoreboard, and Testbench Components**.  
   - Provides a scalable setup for **I2C protocol verification**.  

✔ **Test Sequences**  
   - Defines **stimulus** to verify different I2C operations (write, read, acknowledge handling).  
   - Uses **constrained-random verification** to test multiple scenarios - reset, read data, write data, read error, write error.  

---

## 🔧 **Running the Testbench**  

To compile and run this testbench, follow the **general simulation setup** provided in the **[UVM README](../README.md)**.  

🔗 **UVM Repository Simulation Guide**: [Click here](../README.md)  

This project is structured to work seamlessly within the **UVM environment**, so refer to the **main UVM repository documentation** for simulator-specific commands and setup instructions.  

---

## 📊 **Key UVM Features Used**  

✔ **UVM Agent** – Includes **Driver, Monitor, and Sequencer** to generate I2C transactions.  
✔ **UVM Scoreboard** – Compares expected vs. actual data to check correctness.  
✔ **UVM Coverage** – Measures functional coverage for I2C transactions.  
✔ **Randomization** – Tests multiple I2C configurations dynamically.  

---

## 📌 Future Enhancements  

✔ Add support for **multi-device I2C bus verification**.  
✔ Implement **functional coverage-driven random testing**.  

---

### 📬 Contact  
📧 Email: sridurgaraju07@gmail.com 
🔗 LinkedIn: https://www.linkedin.com/in/sri-durga-raju/

---

Happy Verifying! 🚀🔬  

