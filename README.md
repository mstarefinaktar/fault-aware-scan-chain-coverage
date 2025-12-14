# fault-aware-scan-chain-coverage

# Fault-Aware Scan Chain Coverage Analyzer

A Python-driven, fault-aware scan test and coverage analysis framework built using **Verilog**, **Icarus Verilog**, and **Python**.

This project demonstrates how **scan chains**, **stuck-at faults**, and **fault coverage** are modeled, simulated, and analyzed in a DFT/ATE-style workflow.

---

## 🚀 Project Overview

The repository implements a **mini ATPG-style flow**:

1. A scan-chain DUT written in Verilog  
2. A fault-free (golden) model and a fault-injected model  
3. Python automation to:
   - Run simulations
   - Sweep stuck-at faults (SA0 / SA1)
   - Compare golden vs faulty scan-out data
   - Compute fault coverage

The focus is on **observability and coverage reasoning**, not brute-force pattern generation.

---

## 🧠 Key Concepts Demonstrated

- Scan chain modeling
- Stuck-at fault injection
- Golden vs faulty simulation comparison
- Fault observability limitations
- Python-driven EDA automation
- DFT-oriented design thinking

---

## 📁 Repository Structure

```
stil/
├── rtl/
│ ├── dut_scan_golden.v # Fault-free scan chain
│ ├── dut_scan_faulty.v # Fault-aware scan chain
│ └── fault_injector.v # Stuck-at fault modeling
│
├── sim/
│ ├── tb_scan_golden.v # Golden testbench
│ └── tb_scan_faulty.v # Fault-injected testbench
│
├── tools/
│ └── fault_sweep.py # Fault sweep & coverage tool
│
├── examples/
│ └── coverage.json # Generated coverage report
│
└── README.md

```


---

## ⚙️ How the Flow Works

### 1️⃣ Golden Simulation
Runs scan patterns on the fault-free DUT and captures reference scan-out (`SO`) data.

### 2️⃣ Fault Sweep
Iterates over all scan FFs and stuck-at conditions, injects faults via plusargs, and re-runs simulation.

### 3️⃣ Coverage Analysis
Compares faulty vs golden scan-out streams, ignores unknown (`X`) values, and computes detection coverage.

---

## 📊 Example Coverage Output

```json
{
  "chain_length": 8,
  "total_faults": 16,
  "detected_faults": [
    "q[7]_SA0",
    "q[7]_SA1"
  ],
  "coverage_percent": 12.5
}

Low coverage here is intentional and correct, reflecting real scan-chain observability limits.

🔍 Why Coverage Is Not 100%

Only faults at the scan-out flip-flop (MSB) are directly observable in this design.

This illustrates a core DFT principle:

Fault coverage depends on observability, not just fault existence.

The framework can be extended to:

Propagate internal faults

Add more scan patterns

Model capture cycles

Support transition or delay faults

▶️ How to Run
cd stil
python tools/fault_sweep.py


Coverage results are written to:

examples/coverage.json

🛠️ Requirements

Python 3.10+

Icarus Verilog (iverilog, vvp)

Windows or Linux

🎯 Learning Outcomes

Understand scan-chain fault behavior

Learn how coverage tools reason about detection

Bridge RTL design with Python-based tooling

Gain hands-on DFT / ATE automation experience

📌 Disclaimer

This project is educational and non-proprietary.
All RTL and patterns are simplified to focus on concepts, not silicon IP.


---


