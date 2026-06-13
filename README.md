<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=0,2,2,5,30&height=200&section=header&text=ONSLAUGHT&fontSize=80&fontColor=fff&animation=fadeIn&fontAlignY=38&desc=⚡%20Windows%20Power%20Tuning%20—%20CPU%20%7C%20GPU%20%7C%20AC%20%7C%20DC&descAlignY=60&descAlign=50"/>

<div align="center">

# ⚡ ONSLAUGHT

### *Unleash your Windows machine. Every core. Every watt. Every frame.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-blue)](https://github.com/tanvirbinzahid/onslaught)
[![CPU](https://img.shields.io/badge/Tuned-Intel%20Core%20i7--10510U-0071C5)](https://www.intel.com)
[![GPU](https://img.shields.io/badge/GPU-Intel%20UHD%20%2B%20NVIDIA%20GTX%201650-brightgreen)](https://www.nvidia.com)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

**Fine-tune your CPU and GPU power profiles for maximum performance (AC) or maximum battery life (DC).**  
No bloatware. No sketchy overclocking tools. Just `powercfg`, the Windows registry, and science.

<br>

```ascii
                 ╔══════════════════════════════════════╗
                 ║    PLUGGED IN → UNLEASHED           ║
                 ║    BATTERY     → OPTIMIZED           ║
                 ║    IDLE        → DEEP SLEEP          ║
                 ║    LOAD        → INSTANT FURY        ║
                 ╚══════════════════════════════════════╝
```

</div>

---

## 📋 Table of Contents

- [Philosophy](#-philosophy)
- [Hardware Target](#-hardware-target)
- [Quick Start](#-quick-start)
- [AC Profile — Fastest + Efficient](#-ac-profile--fastest--efficient)
- [DC Profile — Battery Efficient](#-dc-profile--battery-efficient)
- [GPU Tuning](#-gpu-tuning)
- [Profile Comparison](#-profile-comparison)
- [Toggle Scripts](#-toggle-scripts)
- [Verification](#-verification)
- [Pitfalls & Notes](#-pitfalls--notes)

---

## 🎯 Philosophy

```
WORK  ═══╗         ╔══════ RAMP
         ║         ║
         ▼         ▼
    ┌─────────────────────┐
    │   MAX PERFORMANCE   │  ← Full turbo, zero hesitation
    └─────────────────────┘
         ▲         ▲
         ║         ║
IDLE ═══╝         ╚══════ DROP
                    (fast, no coasting)
```

Two complementary modes for two very different situations:

| Mode | When | Vibe |
|------|------|------|
| **AC — Fastest + Efficient** | Plugged in | Instant turbo on any load, drops to deep sleep the moment work finishes. Fastest possible response without wasting heat at idle. |
| **DC — Battery Efficient** | On battery | Smart ramp filtering — ignores micro-bursts (scrolling, typing) to save power, but still delivers full turbo for sustained work. |

---

## 💻 Hardware Target

This tuning was developed and tested on:

| Component | Spec |
|-----------|------|
| **CPU** | Intel Core i7-10510U (Comet Lake-U, 4C/8T, 1.8 GHz base / 4.9 GHz turbo) |
| **iGPU** | Intel UHD Graphics (Comet Lake) |
| **dGPU** | NVIDIA GeForce GTX 1650 with Max-Q Design (4GB VRAM, ~30W TDP) |
| **OS** | Windows 10 (also compatible with Windows 11) |
| **Power Plan** | Balanced (`381b4222-f694-41f0-9685-ff5bb260df2e`) |

> **Compatibility:** These settings work on *any* Windows laptop or desktop.  
> Tune the values based on your CPU's boost behavior and your power/battery priorities.

---

## 🚀 Quick Start

Open **PowerShell as Administrator** and run the profile you want:

### 🔥 AC — Full Send

```powershell
# =============================================
#  AC PROFILE — Fastest + Efficient
#  Instant turbo, instant drop, deep sleep idle
# =============================================

# ── CPU ──────────────────────────────────────
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTPOL 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFEPP 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCTHRESHOLD 5
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECTHRESHOLD 90
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCTIME 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECTIME 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCPOL1 3
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECPOL 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFCHECK 15
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR THROTTLING 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFHISTORY 1

# ── GPU ──────────────────────────────────────
powercfg /SETACVALUEINDEX SCHEME_CURRENT 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0

Write-Host "✅ AC profile applied — unleash mode"
```

### 🔋 DC — Battery Efficient

```powershell
# =============================================
#  DC PROFILE — Battery Efficient
#  Filters micro-bursts, drops fast, deep idle
# =============================================

# ── CPU ──────────────────────────────────────
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 3
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTPOL 25
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFEPP 75
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCTHRESHOLD 80
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECTHRESHOLD 25
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCTIME 3
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECTIME 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100

# ── GPU ──────────────────────────────────────
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PCIEXPRESS ASPM 2

Write-Host "✅ DC profile applied — battery mode"
```

---

## ⚡ AC Profile — Fastest + Efficient

*For when you're plugged in and want **zero compromise** on responsiveness, but don't want your laptop sounding like a jet engine at idle.*

### CPU Settings

| Setting | Value | Effect | Why |
|---------|-------|--------|-----|
| `PERFBOOSTMODE` | **2** (Aggressive) | Max turbo always available | No artificial boost limits |
| `PERFBOOSTPOL` | **100%** | Full boost eagerness | Any boost headroom → use it |
| `PERFEPP` | **0%** | Pure performance bias | Never sacrifice speed for efficiency |
| `PERFINCTHRESHOLD` | **5%** | Any tiny load triggers turbo | Responds instantly to clicks |
| `PERFDECTHRESHOLD` | **90%** | Only drops freq when truly idle | No downclocking under load |
| `PERFINCTIME` | **1** | Zero ramp delay | Turbo activates immediately |
| `PERFDECTIME` | **2** | Brief hold then release | Avoids bounce oscillation |
| `PERFINCPOL1` | **3** (IdealAggressive) | Aggressive frequency increase | Pounces on any load increase |
| `PERFDECPOL` | **2** (Rocket) | Instant frequency drop | No power wasted coasting |
| `PERFCHECK` | **15ms** | Polls load every 15ms | 2× faster response than stock 30ms |
| `PROCTHROTTLEMIN` | **5%** | Deep idle when unused | Cores can sleep between bursts |
| `PROCTHROTTLEMAX` | **100%** | Full frequency headroom | No artificial cap |
| `SYSCOOLPOL` | **1** (Active) | Fan spins up under load | Keeps temps in check |
| `THROTTLING` | **0** | Disable throttlestates | No performance capping |
| `PERFHISTORY` | **1** | Minimum history window | Reacts to current load, not past |

### GPU Settings (AC)

| Component | Setting | Value | Effect |
|-----------|---------|-------|--------|
| **Intel Graphics** | Power Plan | **2** (Max Performance) | iGPU runs at full speed |
| **PCI Express** | ASPM | **0** (Off) | No PCIe link power gating — zero latency |

### NVHDA Setting (AC — requires Admin)

```powershell
# Prefer Maximum Performance for NVIDIA GPU
New-Item -Path 'HKLM:\SOFTWARE\NVIDIA Corporation\Global\NvCplApi\Policies' -Force | Out-Null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\NVIDIA Corporation\Global\NvCplApi\Policies' `
  -Name 'PowerManagementMode' -Value 1 -Type DWord -Force
```

---

## 🔋 DC Profile — Battery Efficient

*For when you're on battery and want **hours of runtime** without feeling sluggish.*

### Design Philosophy

The DC profile uses a technique called **burst filtering**:

```
Timeline:  Click →    task →   done →  idle
           │         │         │       │
Stock:     ┌─────────┴────┬────┘       │
           │  🔥 turbo    │  🔥 coast  │       ← wastes battery
           └──────────────┴────────────┘

ONSLAUGHT: ┌─────────────┐             │
           │  🔥 turbo   │  💤 sleep   │       ← saves battery
           └─────────────┴─────────────┘
```

### CPU Settings

| Setting | Value | Effect | Why |
|---------|-------|--------|-----|
| `PERFBOOSTMODE` | **3** (Efficient Enabled) | Smart turbo | Boosts when needed, not always |
| `PERFBOOSTPOL` | **25%** | Conservative boost | Only boosts for meaningful work |
| `PERFEPP` | **75%** | Efficiency-biased | Prefers lower frequencies |
| `PERFINCTHRESHOLD` | **80%** | High bar for ramp-up | Ignores micro-bursts (scrolling, typing) |
| `PERFDECTHRESHOLD` | **25%** | Quick drop-off | Downclocks fast after burst |
| `PERFINCTIME` | **3** | Filters short spikes | Waits for sustained load before boosting |
| `PERFDECTIME` | **2** | Brief hold then release | Avoids oscillation |
| `SYSCOOLPOL` | **0** (Passive) | Throttle instead of fan | Silent cooling on battery |
| `PROCTHROTTLEMIN` | **5%** | Deep idle | Maximum sleep state savings |
| `PROCTHROTTLEMAX` | **100%** | Full frequency available | Turbo still there when you need it |

### GPU Settings (DC)

| Component | Setting | Value | Effect |
|-----------|---------|-------|--------|
| **Intel Graphics** | Power Plan | **0** (Max Battery) | iGPU uses lowest power states |
| **GPU Preference** | Low Power | **1** | Prefers iGPU over dGPU on battery |
| **PCI Express** | ASPM | **2** (Max Savings) | Deepest link power state |

### NVIDIA Setting (DC — requires Admin)

```powershell
# Optimal Power for NVIDIA GPU on battery
New-Item -Path 'HKLM:\SOFTWARE\NVIDIA Corporation\Global\NvCplApi\Policies' -Force | Out-Null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\NVIDIA Corporation\Global\NvCplApi\Policies' `
  -Name 'PowerManagementMode' -Value 2 -Type DWord -Force
```

---

## 📊 Profile Comparison

```
          PLUGGED IN (AC)                    ON BATTERY (DC)
     ┌─────────────────────┐           ┌─────────────────────┐
     │                     │           │                     │
     │   🔥  Aggressive    │           │   🌿  Efficient     │
     │     5% threshold    │           │     80% threshold   │
     │     15ms polling    │           │     3-cycle delay   │
     │     0% EPP          │           │     75% EPP         │
     │     Rocket drop     │           │     Fast drop       │
     │                      │           │                     │
     │  INSTANT ON DEMAND  │           │  SMART ON DEMAND    │
     │  DEEP SLEEP AT IDLE │           │  DEEP SLEEP AT IDLE │
     │                     │           │                     │
     └─────────────────────┘           └─────────────────────┘
                   │                               │
                   └───────────┬───────────────────┘
                               │
                     ┌─────────▼─────────┐
                     │  5% Min State     │
                     │  100% Max State   │
                     │  Deep C-State     │
                     └───────────────────┘
```

### Side-by-Side

| Parameter | 🔥 AC (Fastest+Efficient) | 🔋 DC (Battery Efficient) |
|-----------|--------------------------|--------------------------|
| Boost Mode | Aggressive (2) | Efficient Enabled (3) |
| Boost Policy | 100% | 25% |
| Energy Perf | 0% (pure speed) | 75% (efficiency) |
| Inc Threshold | 5% (any load) | 80% (sustained load) |
| Dec Threshold | 90% (high bar) | 25% (quick drop) |
| Inc Time | 1 (instant) | 3 (filter bursts) |
| Dec Time | 2 | 2 |
| Inc Policy | IdealAggressive | — |
| Dec Policy | Rocket (fast drop) | — |
| Check Interval | 15ms | Default |
| Min State | 5% | 5% |
| Intel GPU | Max Perf (2) | Max Battery (0) |
| PCIe ASPM | Off (0) | Max Savings (2) |
| NVIDIA | Max Perf (1) | Optimal (2) |
| Cooling | Active (fan) | Passive (throttle) |

---

## 🔄 Toggle Scripts

Save these as `.ps1` files for one-click switching between modes.

### `toggle-ac.ps1` — Plugin in, blast off

```powershell
param([switch]$Ultimate)

Write-Host "⚡ Applying AC profile..." -ForegroundColor Cyan

# Boost
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTPOL 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFEPP 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCTHRESHOLD 5
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECTHRESHOLD 90
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCTIME 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECTIME 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCPOL1 3
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECPOL 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFCHECK 15
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR THROTTLING 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFHISTORY 1

# GPU
powercfg /SETACVALUEINDEX SCHEME_CURRENT 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 2
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0

Write-Host "✅ AC profile active — full send!" -ForegroundColor Green
```

### `toggle-dc.ps1` — Unplug, extend

```powershell
Write-Host "🔋 Applying DC profile..." -ForegroundColor Cyan

# CPU
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 3
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTPOL 25
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFEPP 75
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCTHRESHOLD 80
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECTHRESHOLD 25
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFINCTIME 3
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PERFDECTIME 2
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100

# GPU
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_PCIEXPRESS ASPM 2

Write-Host "✅ DC profile active — battery mode!" -ForegroundColor Green
```

---

## 🔍 Verification

Check your settings took effect:

```powershell
# ── Quick CPU check ──
$settings = @{
    'Boost Mode'      = 'be337238-0d82-4146-a960-4f3749d470c7'
    'Boost Policy'    = '45bcc044-d885-43e2-8605-ee0ec6e96b59'
    'Energy Perf'     = '36687f9e-e3a5-4dbf-b1dc-15eb381c6863'
    'Inc Threshold'   = '06cadf0e-64ed-448a-8927-ce7bf90eb35d'
    'Dec Threshold'   = '12a0ab44-fe28-4fa9-b3bd-4b64f44960a6'
    'Min State'       = '893dee8e-2bef-41e0-89c6-b55d0929964c'
    'Max State'       = 'bc5038f7-23e0-4960-96da-33abaf5935ec'
    'Inc Time'        = '984cf492-3bed-4488-a8f9-4286c97bf5aa'
    'Dec Time'        = 'd8edeb9b-95cf-4f95-a73c-b061973693c8'
}
Write-Host "`n📊 CPU Settings:" -ForegroundColor Cyan
$settings.Keys | ForEach-Object {
    $ac = (powercfg /QUERY SCHEME_CURRENT SUB_PROCESSOR $settings[$_] | Select-String 'AC Power Setting Index') -replace '.*Index: 0x', ''
    $dc = (powercfg /QUERY SCHEME_CURRENT SUB_PROCESSOR $settings[$_] | Select-String 'DC Power Setting Index') -replace '.*Index: 0x', ''
    Write-Host "  $_ → AC: 0x$ac  |  DC: 0x$dc"
}

# ── Quick GPU check ──
Write-Host "`n📊 GPU Settings:" -ForegroundColor Cyan
powercfg /QUERY SCHEME_CURRENT 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 | Select-String 'Power Setting Index' | ForEach-Object { Write-Host "  Intel GPU: $_" }
powercfg /QUERY SCHEME_CURRENT SUB_PCIEXPRESS ee12f906-d277-404b-b6da-e5fa1a576df5 | Select-String 'Power Setting Index' | ForEach-Object { Write-Host "  PCIe ASPM: $_" }

# ── Check current turbo frequency ──
Write-Host "`n📊 Current CPU Speed:" -ForegroundColor Cyan
$cpu = Get-CimInstance Win32_Processor
Write-Host "  $($cpu.Name) @ $($cpu.CurrentClockSpeed) MHz / $($cpu.MaxClockSpeed) MHz max"
```

---

## ⚠️ Pitfalls & Notes

### ❗ Important

| Issue | Note |
|-------|------|
| **No admin required for powercfg** | All `powercfg` commands work as regular user |
| **NVIDIA registry needs admin** | `HKLM` changes require elevated PowerShell |
| **Changes take effect immediately** | No reboot needed |
| **Power plan resets on driver update** | Intel/NVIDIA driver updates may reset GPU power settings |
| **BIOS can override** | Some BIOS settings (SpeedStep, C-States) override Windows power policies |
| **Max-Q power limit** | NVIDIA Max-Q cards have a hardware power cap (~30W) — `nvidia-smi -pl` requires Admin |

### 💡 Tips

- **Save your settings** — run `powercfg /QUERY SCHEME_CURRENT > power-profile-backup.txt` to keep a record
- **Create custom plans** — `powercfg /DUPLICATESCHEME` to clone the Balanced plan for each profile
- **Undo anytime** — switching to another Windows power plan (High Performance, Power Saver) resets all values
- **Check temps** — aggressive AC settings produce more heat; monitor with HWMonitor or OpenHardwareMonitor

---

## 🧠 Science Behind the Settings

```
Powercfg Internal Governor Flow:

┌──────────┐    Check every N ms ───→  ┌──────────────┐
│   Load   │                           │  Governor    │
│   ↓      │                           │  Decision    │
│   > Inc  │    ──→  Increase Freq     │              │
│   Thresh │                           │  ↑ Policy    │
│          │                           │  (IdealAggr) │
│   < Dec  │    ──→  Decrease Freq     │              │
│   Thresh │                           │  ↓ Policy    │
│          │                           │  (Rocket)    │
│  Time >  │    ──→  Wait N checks     │              │
│  Inc/Dec │                           │              │
│  Time    │                           └──────────────┘
└──────────┘
```

The governor checks processor utilization at `PERFCHECK` intervals (15ms on AC, 30ms default) and decides whether to ramp up, ramp down, or hold based on:

1. **Thresholds** — how loaded the CPU needs to be to change frequency
2. **Timers** — how many check intervals to wait before acting (filters noise)
3. **Policies** — *how* to change frequency (IdealAggressive = fast up, Rocket = fast down)
4. **Energy Preference** — the bias between performance and efficiency

---

## 📜 License

MIT — use it, share it, tweak it, roast it.

---

<div align="center">

**Crafted with ⚡, ☕, and way too much time tweaking powercfg**

[Report Issue](https://github.com/tanvirbinzahid/onslaught/issues) · [Contribute](https://github.com/tanvirbinzahid/onslaught/pulls)

</div>

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=0,2,2,5,30&height=120&section=footer"/>
