import subprocess, os, json

BASE_DIR = os.path.dirname(__file__)
SIM_DIR = os.path.abspath(os.path.join(BASE_DIR, "..", "sim"))
EXAMPLES_DIR = os.path.abspath(os.path.join(BASE_DIR, "..", "examples"))
CHAIN_LEN = 8

def run(cmd):
    p = subprocess.run(cmd, cwd=SIM_DIR, capture_output=True, text=True)
    if p.returncode != 0:
        raise RuntimeError(p.stderr)
    return p.stdout

def extract_so(stdout):
    so = []
    for line in stdout.splitlines():
        if line.startswith("SO="):
            so.append(line.split("=")[1].strip())
    return so

def compare_skip_x(golden, faulty):
    """Return True if mismatch exists on any non-X golden sample."""
    for g, f in zip(golden, faulty):
        if g.lower() == "x":
            continue
        if g != f:
            return True
    return False

def main():
    os.makedirs(EXAMPLES_DIR, exist_ok=True)

    print("▶ Running GOLDEN simulation...")
    run(["iverilog", "-g2012", "-o", "sim_out",
         "../rtl/dut_scan_golden.v", "tb_scan_golden.v"])
    golden_out = run(["vvp", "sim_out"])
    golden_so = extract_so(golden_out)

    faults = [(i, sa) for i in range(CHAIN_LEN) for sa in (0, 1)]
    detected, undetected = [], []

    for idx, sa in faults:
        print(f"▶ Fault q[{idx}] SA{sa}")

        run(["iverilog", "-g2012", "-o", "sim_out",
             "../rtl/fault_injector.v", "../rtl/dut_scan_faulty.v", "tb_scan_faulty.v"])

        faulty_out = run(["vvp", "sim_out", f"+FAULT_IDX={idx}", f"+FAULT_SA={sa}"])
        faulty_so = extract_so(faulty_out)

        if compare_skip_x(golden_so, faulty_so):
            detected.append(f"q[{idx}]_SA{sa}")
        else:
            undetected.append(f"q[{idx}]_SA{sa}")

    coverage = {
        "chain_length": CHAIN_LEN,
        "total_faults": len(faults),
        "detected_faults": detected,
        "undetected_faults": undetected,
        "coverage_percent": round(100 * len(detected) / len(faults), 2),
    }

    out_file = os.path.join(EXAMPLES_DIR, "coverage.json")
    with open(out_file, "w") as f:
        json.dump(coverage, f, indent=2)

    print("\n✅ Fault sweep complete")
    print(json.dumps(coverage, indent=2))
    print("📄 Coverage written to:", out_file)

if __name__ == "__main__":
    main()
