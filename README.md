![b31a66bb47d3f056444aec6f792bd33e](https://github.com/user-attachments/assets/49593954-8c76-415b-af66-0381a8044ce6)# 4-Bit NanoProcessor - VHDL FPGA Implementation

<div align="center">
  ![Processor Architecture](![b31a66bb47d3f056444aec6f792bd33e](https://github.com/user-attachments/assets/2b6063a9-3536-4383-86e7-754295f7e85c)
    )
</div>

---

<div align="center">
  <p>Processor implementation featuring an extended instruction set, designed in VHDL and deployed on the BASYS 3 FPGA development board.</p>
</div>

---

## 🚀 Project Overview
This project implements a complete 4-bit nanoprocessor system with both original and extended instruction sets. The processor features a modular architecture with comprehensive ALU operations, register management, and program control capabilities. Developed as part of the CS1050 coursework, this design has been synthesized, simulated, and deployed on the BASYS 3 FPGA.

## 🎯 Key Achievements
- ✅ **Complete ISA Extension** – Expanded from 4 to 14 instructions while maintaining backward compatibility.  
- ✅ **Modular Design** – Reusable VHDL components for educational purposes.  
- ✅ **FPGA Validation** – Successfully deployed and tested on BASYS 3 hardware.  
- ✅ **Comprehensive Documentation** – Full design report with timing analysis.  
- ✅ **Signed Arithmetic** – Proper two’s-complement operations with overflow detection.  

---

## 📋 Instruction Set Architecture

### Original Instructions (4)
| Instruction  | Description                          | Format                  |
|--------------|--------------------------------------|-------------------------|
| `MOVI R, d`  | Move immediate value to register     | `10 RRR 000 dddd`       |
| `ADD Ra, Rb` | Add registers Ra and Rb              | `00 RaRaRa RbRbRb 0000` |
| `NEG R`      | Two’s-complement negation            | `01 RRR 0000000`        |
| `JZR R, d`   | Jump if register is zero             | `11 RRR 0000 ddd`       |

### Extended Instructions (14 total)
| Instruction   | Description                             | Format                  |
|---------------|-----------------------------------------|-------------------------|
| `SUB Ra, Rb`  | Subtract Rb from Ra                     | `00 RaRaRa RbRbRb 0001` |
| `AND Ra, Rb`  | Bitwise AND operation                   | `00 RaRaRa RbRbRb 0010` |
| `OR Ra, Rb`   | Bitwise OR operation                    | `00 RaRaRa RbRbRb 0011` |
| `XOR Ra, Rb`  | Bitwise XOR operation                   | `00 RaRaRa RbRbRb 0100` |
| `MUL Ra, Rb`  | Multiply registers                      | `00 RaRaRa RbRbRb 0101` |
| `CMP Ra, Rb`  | Compare registers (sets flags)          | `00 RaRaRa RbRbRb 0111` |

> **Note:** In the extended design, the instruction set expands to a total of 14 instructions. Six other opcodes (e.g., shift operations, immediate variants, etc.) are implemented in the full VHDL source; refer to `InstructionDecoder_Extended.vhd` for the complete encoding table.

---

## 📈 Performance Metrics

| **Metric**                 | **Original Design** | **Extended Design** |
|----------------------------|---------------------|---------------------|
| **Instructions Supported** | 4                   | 14                  |
| **FPGA Slices Used**       | 28                  | 42                  |
| **Maximum Frequency**      | 85 MHz              | 75 MHz              |
| **Power Consumption**      | 0.8 W               | 1.2 W               |

---

## 🖼️ Hardware Photos

_Add your FPGA board setup photos in the `images/` directory, then update paths below if needed._

<div align="center">
  ![BASYS 3 Board Setup](images/basys3-setup.jpg)
</div>

---

## 📁 Project Structure

```text
VHDL-4bit-NanoProcessor-FPGA/
├── Nanoprocessor/
│   ├── ALU.vhd
│   ├── ControlUnit.vhd
│   ├── InstructionDecoder.vhd
│   ├── Multiplexer.vhd
│   ├── ProgramCounter.vhd
│   ├── RegisterBank.vhd
│   └── TopLevel.vhd
├── Nanoprocessor-Extended/
│   ├── ALU_Extended.vhd
│   ├── ControlUnit_Extended.vhd
│   ├── InstructionDecoder_Extended.vhd
│   ├── Multiplexer_Extended.vhd
│   ├── ProgramCounter_Extended.vhd
│   ├── RegisterBank_Extended.vhd
│   └── TopLevel_Extended.vhd
├── Presentation/
│   ├── NanoProcessor_Presentation.pdf
│   └── NanoProcessor_Presentation.pptx
├── NanoProcessor_Project_Report.pdf
├── README.md
└── .gitignore
```
---

## 🔧 Getting Started

1. **Prerequisites**
   - Xilinx Vivado Design Suite (version 2020.2 or later recommended)
   - Basys 3 FPGA Board (Artix-7)

2. **Setup & Synthesis**
   ```bash
   git clone https://github.com/HimathX/VHDL-4bit-NanoProcessor-FPGA.git
   cd VHDL-4bit-NanoProcessor-FPGA
   Open Vivado → Create New Project → Add sources from Nanoprocessor/ (for original design) or Nanoprocessor-Extended/ (for extended design).
   
   Specify Basys 3 (xc7a35tcpg236-1) as the target device.
   
   Run synthesis → implementation → generate bitstream.
   
   Program the FPGA with the generated .bit file.

---

## 🖥️ Simulation

Use your preferred VHDL simulator (e.g., ModelSim, Vivado Simulator).

1. Compile all `.vhd` files in either `Nanoprocessor/` (original design) or `Nanoprocessor-Extended/` (extended design).  
2. Run the corresponding testbench to verify functionality before FPGA programming:
   - `Nanoprocessor/Testbench_NanoProcessor.vhd`
   - `Nanoprocessor-Extended/Testbench_NanoProcessor_Extended.vhd`

---

## 📚 Documentation & Reporting

- Refer to `NanoProcessor_Project_Report.pdf` for:
  - Block-by-block schematics
  - Timing diagrams
  - Performance analysis
- Presentation slides in `Presentation/` cover:
  - High-level architecture
  - Design trade-offs

---

<div align="center">
  <p>Built with ❤️ for learning computer architecture.</p>
</div>
