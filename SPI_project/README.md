# 🔍 SPI Protocol Verification using UVM  

This project implements a **Universal Verification Methodology (UVM)** testbench to verify a **Serial Peripheral Interface (SPI) design**. The verification environment ensures the SPI Master can correctly send and receive data using **constrained-random stimulus, functional coverage, and self-checking mechanisms**.  

---

## 📌 **Project Overview**  

### **🔹 SPI Design (`src/` Folder)**  

The **SPI Master (`spi_intf.sv`)** controls SPI communication by:  
✔ Receiving **write (`wr`) and read** commands from the processor.  
✔ Sending/receiving **8-bit data (`din/dout`)** through MOSI/MISO lines.  
✔ Using a **state machine** to handle SPI transactions (idle, load, send, read).  
✔ Generating **chip select (`cs`) signals** for proper SPI communication.  

The **SPI Memory (`spi_mem.sv`)** stores and retrieves data based on SPI transactions.  
✔ Writes data to memory when SPI Master sends a write request.  
✔ Reads data from memory and sends it to the SPI Master when requested.  

The **Top Module (`top.sv`)** connects the **SPI Master** to **SPI Memory** for full verification.  

---

### **🔹 UVM Testbench (`uvm_tb/` Folder)**  

The UVM testbench is designed to **verify the SPI Master using a self-checking environment**. It consists of:  

✔ **Testbench**  
   - Instantiates the **SPI interface and test environment**.  
   - Calls the **test sequences** to run different verification scenarios.  
   - Reports test results and coverage metrics.  

✔ **UVM Agent**  
   - Includes the **Driver, Monitor, and Sequencer** to generate SPI transactions.  
   - The **Driver** sends stimulus to the SPI Master.  
   - The **Monitor** collects transaction data for analysis.  

✔ **UVM Scoreboard**  
   - Compares **expected vs. actual** SPI transactions.  
   - Detects errors in data transmission.  

✔ **UVM Environment**  
   - Instantiates **UVM Agent, Scoreboard, and Testbench Components**.  
   - Provides a scalable setup for **SPI protocol verification**.  

✔ **Test Sequences**  
   - Defines **stimulus** to verify different SPI operations (write, read, error handling).  

---

## 🔧 **Running the Testbench**  

To compile and run this testbench, follow the **general simulation setup** provided in the **[UVM README](../README.md)**.  

🔗 **UVM Repository Simulation Guide**: [Click here](../README.md)  

This project is structured to work seamlessly within the **UVM environment**, so refer to the **main UVM repository documentation** for simulator-specific commands and setup instructions.  

---

## 📊 **Key UVM Features Used**  

✔ **UVM Agent** – Includes **Driver, Monitor, and Sequencer** to generate SPI transactions.  
✔ **UVM Scoreboard** – Compares expected vs. actual data to check correctness.  
✔ **UVM Coverage** – Measures functional coverage for SPI transactions.  
✔ **Randomization** – Tests multiple SPI configurations dynamically.  

---

## 📌 Future Enhancements  

✔ Add support for **SPI Slave** verification.  
✔ Extend testbench to include **error injection and recovery scenarios**.  
✔ Integrate formal verification for protocol compliance.  

---

### 📬 Contact  
📧 Email: [your-email@example.com](mailto:your-email@example.com)  
🔗 LinkedIn: [Your LinkedIn](https://www.linkedin.com/in/your-linkedin/)  

---

Happy Verifying! 🚀🔬  

