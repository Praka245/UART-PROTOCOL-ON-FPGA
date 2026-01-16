# Implementation of UART Protocol on FPGA (Verilog HDL)

## 📌 Project Overview

- This project focuses on the **design and implementation of the UART (Universal Asynchronous Receiver Transmitter) protocol** using **Verilog HDL**.  

- UART is a widely used **asynchronous serial communication protocol**, and this project aims to provide a **clear understanding of its working, timing, and hardware implementation**.

- The design includes **UART Transmitter, UART Receiver, and Baud Rate Generator modules**, verified through simulation and waveform analysis.  
This project is intended for **learning, academic practice, and FPGA-based digital design understanding**.

---

## 🔍 What is UART?

UART (Universal Asynchronous Receiver Transmitter) is a **serial communication protocol** that transfers data **bit-by-bit** without a shared clock.

### Key Characteristics
- Asynchronous communication (no clock line)
- Full-duplex communication
- Simple hardware interface
- Widely used in embedded systems, FPGAs, and microcontrollers

  <img width="450" height="583" alt="image" src="https://github.com/user-attachments/assets/fa54c35e-9dfd-402b-a975-e31676857483" />



---

## 🧱 UART Frame Format

Each UART data frame consists of:

| Field      | Description |
|-----------|------------|
| Start Bit | Indicates start of transmission (logic 0) |
| Data Bits | D0 - D7 bits (commonly 8 bits) |
| Parity    | Optional error checking |
| Stop Bit | Indicates end of transmission (logic 1) |

---
<img width="500" height="766" alt="image" src="https://github.com/user-attachments/assets/400703f0-0e0f-4837-9421-d1dbec74cba4" />


**Frame Example (8N1):**
- 1 Start bit  
- 8 Data bits  
- No parity  
- 1 Stop bit  

---

## 🛠 Modules Implemented

### 1️⃣ Baud Rate Generator
- Generates timing ticks based on system clock
- Controls bit duration for TX and RX
- Example: 100 MHz clock → 115200 baud

### 2️⃣ UART Transmitter (TX)
- Converts parallel data to serial format
- Adds start and stop bits automatically
- Sends data LSB first

### 3️⃣ UART Receiver (RX)
- Detects start bit
- Samples incoming serial data
- Reconstructs parallel data output

- Finally the **Top Module** has the combination of all Modules

---

## ⚙️ Design Features

- Parameterized baud rate
- Modular and reusable Verilog code
- Supports standard UART configurations
- Clean FSM-based implementation
- Simulation-verified using waveform analysis

---

## 🧪 Verification & Testing

- Testbench written for TX and RX modules
- Verified:
  - Start bit detection
  - Correct baud timing
  - Accurate data transmission and reception
- Waveforms analyzed to confirm protocol timing

---

## 🎯 Project Objectives

- Understand UART protocol fundamentals
- Learn asynchronous serial communication
- Implement UART using Verilog HDL
- Practice FSM-based digital design
- Gain hands-on experience with timing and baud rate generation

---

## 📂 Files Included

- UART Transmitter (TX) module  
- UART Receiver (RX) module  
- Baud Rate Generator  
- Testbench files  
- Simulation waveforms  

---

## 🚀 WHY THE BAUD RATE GENERATOR IS NEEDED ?


### A baud rate generator is a circuit that:
- Takes a high-frequency system clock (for example, 50 MHz or 100 MHz)
- Divides it down to the required UART baud rate
- Produces a bit-time enable pulse (clken, tick, or baud_tick)
- This enable pulse tells the UART when to transmit or sample one bit.

---

### Problem Without a Baud Rate Generator

**Assume:**

System clock = 50 MHz
Baud rate = 115200 bps

**Bit time:**
Tbit = 1 / 115200 ≈ 8.68 µs

**Clock period:**

Tclk = 1 / 50 MHz = 20 ns

- One UART bit lasts about 434 clock cycles.

### Without a baud rate generator:

- UART would change bits every clock cycle
- Data would be transmitted much faster than required
- The receiver would not be able to decode the data

**Solution: Baud Rate Generator**

---
### The baud rate generator:

- Counts system clock cycles
- Generates a pulse exactly once per bit period
- Uses that pulse to control the UART FSM

**Example logic:**

```
if (baud_cnt == BAUD_DIV-1) begin
    baud_cnt <= 0;
    clken <= 1;
end
````
- Here, clken means advance the UART by one bit.
---

### Why 8× or 16× Oversampling?

- UART often uses oversampling instead of one tick per bit.
- Common oversampling rates: 8× per bit, 16x per bit

---
**Advantages:**

- Better timing accuracy
- Improved noise immunity
- Tolerance to clock mismatch between TX and RX
- 16× Oversampling Explanation
- One UART bit = 16 baud ticks
- The bit is sampled at the center (8th tick)

---

### Why sample in the middle?

- The start bit edge may not align perfectly
- Sampling at the center avoids jitter and noise

### This is why timing diagrams show:
- Tick count = 16
- Sampling point at the middle of the bit
- Role of Baud Rate Generator in TX FSM

### Example from TX FSM:
```
STATE_START:
begin
    if (clken) begin
        tx <= 1'b0;
        state <= STATE_DATA;
    end
end
```
### Key points:

- FSM waits for clken
- clken is generated by the baud rate generator
- One clken corresponds to one UART bit time
- TX output changes only on clken

### Signal Summary for Baud Rate generator:

| Signal name       | Purpose                              |
| ----------------- | ------------------------------------ |
| clk_50m           | High-frequency system clock          |
| baud_tick / clken | Controls UART bit timing             |
| FSM               | Handles start, data, and stop states |
| tx                | UART serial output                   |

---

## 🚀 FSM FOR TX

| State Name    | Function                      |
| ------------- | ----------------------------- |
| `STATE_IDLE`  | Waits for data to transmit    |
| `STATE_START` | Sends the start bit           |
| `STATE_DATA`  | Sends 8 data bits (LSB first) |
| `STATE_STOP`  | Sends the stop bit            |
---

- **KEY SIGNALS USED FOR TX**

| Signal    | Direction | Description                                              |
| --------- | --------- | -------------------------------------------------------- |
| `clk_50m` | Input     | System clock (50 MHz) used for synchronous FSM operation |
| `clken`   | Input     | Baud-rate enable pulse; goes HIGH once per bit time      |
| `wr_en`   | Input     | Write enable signal to start transmission                |
| `din`     | Input     | 8-bit parallel data input to be transmitted              |
| `tx`      | Output    | Serial transmit line                                     |
| `state`   | Internal  | Current FSM state (IDLE, START, DATA, STOP)              |
| `bitpos`  | Internal  | Tracks current data bit position (0–7)                   |
| `data`    | Internal  | Latched copy of input data (`din`)                       |

---

## 🚀 FSM FOR RX

| State Name       | Function                                  |
| ---------------- | ----------------------------------------- |
| `RX_STATE_START` | Detects and validates start bit           |
| `RX_STATE_DATA`  | Samples and stores 8 data bits            |
| `RX_STATE_STOP`  | Validates stop bit and signals data ready |

---

- **KEY SIGNALS USED FOR RX**

| Signal    | Description                               |
| --------- | ----------------------------------------- |
| `clk_50m` | System clock (50 MHz)                     |
| `clken`   | Oversampling clock enable (16× baud)      |
| `rx`      | Serial receive input                      |
| `sample`  | 4-bit counter for oversampling            |
| `bitpos`  | Tracks received data bit position         |
| `scratch` | Temporary register to store received data |
| `data`    | Final received parallel data              |
| `rdy`     | Data ready flag                           |
| `rdy_clr` | Clears data ready flag                    |
| `state`   | Current RX FSM state                      |
---

## **PIN CONFIGURATION**

| Signal Name | FPGA Pin | I/O Standard       | Description                         |
| ----------- | -------- | ------------------ | ----------------------------------- |
| `clk_50m`   | Y9       | LVCMOS18 (default) | 50 MHz system clock input           |
| `btn`       | N15      | LVCMOS18 (default) | Push button input (reset / control) |
| `tx`        | Y11      | **LVCMOS18**       | UART transmit output                |
| `rx`        | AA11     | LVCMOS18 (default) | UART receive input                  |

---

## 🚀 APPLICATIONS

- FPGA ↔ PC, PC ↔ MCus serial communication
- Debugging and logging interfaces
- Embedded system communication
- Bootloaders and configuration interfaces

---


## 🙋‍♂️ CONTRIBUTOR

**Prakadeesh N**  
Electronics and Communication Engineering (ECE)  
Interested in Digital Design, VLSI, and FPGA Development

