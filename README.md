# Implementation of UART Protocol on FPGA (Verilog HDL)

## 📌 Project Overview

This project focuses on the **design and implementation of the UART (Universal Asynchronous Receiver Transmitter) protocol** using **Verilog HDL**.  
UART is a widely used **asynchronous serial communication protocol**, and this project aims to provide a **clear understanding of its working, timing, and hardware implementation**.

The design includes **UART Transmitter, UART Receiver, and Baud Rate Generator modules**, verified through simulation and waveform analysis.  
This project is intended for **learning, academic practice, and FPGA-based digital design understanding**.

---

## 🔍 What is UART?

UART (Universal Asynchronous Receiver Transmitter) is a **serial communication protocol** that transfers data **bit-by-bit** without a shared clock.

### Key Characteristics
- Asynchronous communication (no clock line)
- Full-duplex communication
- Simple hardware interface
- Widely used in embedded systems, FPGAs, and microcontrollers

  <img width="1087" height="583" alt="image" src="https://github.com/user-attachments/assets/fa54c35e-9dfd-402b-a975-e31676857483" />



---

## 🧱 UART Frame Format

Each UART data frame consists of:

| Field      | Description |
|-----------|------------|
| Start Bit | Indicates start of transmission (logic 0) |
| Data Bits | 5–9 bits (commonly 8 bits) |
| Parity    | Optional error checking |
| Stop Bit | Indicates end of transmission (logic 1) |

<img width="1492" height="766" alt="image" src="https://github.com/user-attachments/assets/400703f0-0e0f-4837-9421-d1dbec74cba4" />


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

## 🚀 FSM

| State Name    | Function                      |
| ------------- | ----------------------------- |
| `STATE_IDLE`  | Waits for data to transmit    |
| `STATE_START` | Sends the start bit           |
| `STATE_DATA`  | Sends 8 data bits (LSB first) |
| `STATE_STOP`  | Sends the stop bit            |





- FPGA ↔ PC serial communication
- Debugging and logging interfaces
- Embedded system communication
- Bootloaders and configuration interfaces

---

## 📜 License

This project is intended for **educational and academic purposes only**.

---

## 🙋‍♂️ Author

**Prakadeesh N**  
Electronics and Communication Engineering (ECE)  
Interested in Digital Design, VLSI, and FPGA Development

