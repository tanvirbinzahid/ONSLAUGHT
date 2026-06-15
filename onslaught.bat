@echo off
setlocal enabledelayedexpansion

:: ╔══════════════════════════════════════════════════════════════╗
:: ║                   ONSLAUGHT — Power Tuner                  ║
:: ║  Windows CPU/GPU power profile manager via powercfg         ║
:: ║  https://github.com/tanvirbinzahid/ONSLAUGHT               ║
:: ╚══════════════════════════════════════════════════════════════╝

set VERSION=1.0.0
set GUID_SCHEME=SCHEME_CURRENT
set GUID_PROC=SUB_PROCESSOR
set GUID_INTELGPU=44f3beca-a7c0-460e-9df2-bb8b99e0cba6
set GUID_INTELGPU_SETTING=3619c3f2-afb2-4afc-b0e9-e7fef372de36
set GUID_GPUPREF=5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c
set GUID_GPUPREF_SETTING=dd848b2a-8a5d-4451-9ae2-39cd41658f6c

:: ── Detect Admin ──
net session >nul 2>&1
if %ERRORLEVEL%==0 ( set ADMIN=1 ) else ( set ADMIN=0 )

:menu
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║                    ⚡ ONSLAUGHT v%VERSION%                  ║
echo  ║           Windows Power Profile Commander              ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
if %ADMIN%==1 ( echo  [✓] Administrator ) else ( echo  [!] Not elevated — NVIDIA registry skipped )
echo.
echo  PRESETS:
echo    [1] 🔥 AC — Fastest + Efficient    (daily driver, turbo + deep idle)
echo    [2] ⚡ AC — Ultimate / Pinned       (100%% min, max aggression)
echo    [3] 🎮 AC — Gaming                  (1%% threshold, 10ms poll)
echo    [4] 🔋 DC — Battery Efficient       (balanced, filter bursts)
echo    [5] 🌿 DC — Max Battery Saver       (99%% max, no turbo)
echo.
echo  CUSTOM:
echo    [6] 🛠️  Custom CPU Tuning          (every parameter)
echo    [7] 🎨 Custom GPU Tuning           (Intel + NVIDIA + PCIe)
echo.
echo  TOOLS:
echo    [8] 📊 View Current Settings
echo    [9] 💾 Export Profile to .pow
echo    [0] ❌ Exit
echo.
choice /c:1234567890 /n /m "  Select [0-9]: "
set CH=%ERRORLEVEL%

if %CH%==1  call :preset_ac_fast
if %CH%==2  call :preset_ac_ultimate
if %CH%==3  call :preset_ac_gaming
if %CH%==4  call :preset_dc_balanced
if %CH%==5  call :preset_dc_maxbattery
if %CH%==6  call :custom_cpu
if %CH%==7  call :custom_gpu
if %CH%==8  call :view_settings
if %CH%==9  call :export_profile
if %CH%==10 exit /b 0

echo.
echo  Press any key for menu...
pause >nul
goto menu

:: ====================================================================
::  PRESETS — AC
:: ====================================================================

:preset_ac_fast
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  🔥 AC — Fastest + Efficient                           ║
echo  ║  Instant turbo on load, deep idle on release           ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
echo  CPU:
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTMODE 2     >nul && echo  [✓] Boost Mode = 2 (Aggressive)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTPOL 100    >nul && echo  [✓] Boost Policy = 100%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFEPP 0           >nul && echo  [✓] EPP = 0 (Max Perf)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTHRESHOLD 5  >nul && echo  [✓] Inc Threshold = 5%% (any load ^= turbo)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTHRESHOLD 90 >nul && echo  [✓] Dec Threshold = 90%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTIME 1       >nul && echo  [✓] Inc Time = 1 (instant)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTIME 2       >nul && echo  [✓] Dec Time = 2
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCPOL1 3       >nul && echo  [✓] Inc Policy = 3 (IdealAggressive)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECPOL 2        >nul && echo  [✓] Dec Policy = 2 (Rocket)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFCHECK 15        >nul && echo  [✓] Check Interval = 15ms
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMIN 5   >nul && echo  [✓] Min State = 5%% (deep idle)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMAX 100 >nul && echo  [✓] Max State = 100%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% SYSCOOLPOL 1        >nul && echo  [✓] Cooling = Active
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% THROTTLING 0        >nul && echo  [✓] Throttle = Disabled
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFHISTORY 1       >nul && echo  [✓] History = 1
echo.
echo  GPU:
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_INTELGPU% %GUID_INTELGPU_SETTING% 2 >nul && echo  [✓] Intel GPU = Max Perf
powercfg /SETACVALUEINDEX %GUID_SCHEME% SUB_PCIEXPRESS ASPM 0                     >nul && echo  [✓] PCIe ASPM = Off
if %ADMIN%==1 (
    echo  [✓] NVIDIA = Prefer Max Perf
    reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NvCplApi\Policies" /f /v PowerManagementMode /t REG_DWORD /d 1 >nul 2>&1
)
echo.
echo  ✅ AC Fastest+Efficient applied!
goto :eof


:preset_ac_ultimate
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  ⚡ AC — Ultimate / Pinned                             ║
echo  ║  Cores pinned at max, zero hesitation, max heat       ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTMODE 2     >nul && echo  [✓] Boost Mode = 2
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTPOL 100    >nul && echo  [✓] Boost Policy = 100%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFEPP 0           >nul && echo  [✓] EPP = 0
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTHRESHOLD 10 >nul && echo  [✓] Inc Threshold = 10%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTHRESHOLD 90 >nul && echo  [✓] Dec Threshold = 90%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTIME 1       >nul && echo  [✓] Inc Time = 1
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTIME 5       >nul && echo  [✓] Dec Time = 5 (hold freq)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMIN 100 >nul && echo  [✓] Min State = 100%% (PINNED!)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMAX 100 >nul && echo  [✓] Max State = 100%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% SYSCOOLPOL 1        >nul && echo  [✓] Cooling = Active
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% THROTTLING 0        >nul && echo  [✓] Throttle = Disabled
echo.
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_INTELGPU% %GUID_INTELGPU_SETTING% 2 >nul && echo  [✓] Intel GPU = Max Perf
powercfg /SETACVALUEINDEX %GUID_SCHEME% SUB_PCIEXPRESS ASPM 0                     >nul && echo  [✓] PCIe ASPM = Off
echo.
echo  ✅ AC Ultimate applied!
goto :eof


:preset_ac_gaming
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  🎮 AC — Gaming                                       ║
echo  ║  Max aggression — 1%% threshold, 10ms poll             ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTMODE 4     >nul && echo  [✓] Boost Mode = 4 (Efficient Aggressive)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTPOL 100    >nul && echo  [✓] Boost Policy = 100%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFEPP 0           >nul && echo  [✓] EPP = 0
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTHRESHOLD 1  >nul && echo  [✓] Inc Threshold = 1%% (instant)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTHRESHOLD 95 >nul && echo  [✓] Dec Threshold = 95%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTIME 1       >nul && echo  [✓] Inc Time = 1
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTIME 5       >nul && echo  [✓] Dec Time = 5
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCPOL1 3       >nul && echo  [✓] Inc Policy = IdealAggressive
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECPOL 2        >nul && echo  [✓] Dec Policy = Rocket
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFCHECK 10        >nul && echo  [✓] Check Interval = 10ms
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMIN 100 >nul && echo  [✓] Min State = 100%% (no idle!)
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMAX 100 >nul && echo  [✓] Max State = 100%%
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% SYSCOOLPOL 1        >nul && echo  [✓] Cooling = Active
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% THROTTLING 0        >nul && echo  [✓] Throttle = Disabled
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFHISTORY 1       >nul && echo  [✓] History = 1
echo.
echo  GPU:
powercfg /SETACVALUEINDEX %GUID_SCHEME% %GUID_INTELGPU% %GUID_INTELGPU_SETTING% 2 >nul && echo  [✓] Intel GPU = Max Perf
powercfg /SETACVALUEINDEX %GUID_SCHEME% SUB_PCIEXPRESS ASPM 0                     >nul && echo  [✓] PCIe ASPM = Off
if %ADMIN%==1 (
    echo  [✓] NVIDIA = Prefer Max Perf
    reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NvCplApi\Policies" /f /v PowerManagementMode /t REG_DWORD /d 1 >nul 2>&1
)
echo.
echo  ✅ AC Gaming applied!
goto :eof


:: ====================================================================
::  PRESETS — DC
:: ====================================================================

:preset_dc_balanced
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  🔋 DC — Battery Efficient                             ║
echo  ║  Filters micro-bursts, drops fast, deep idle          ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTMODE 3     >nul && echo  [✓] Boost Mode = 3 (Efficient Enabled)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTPOL 25    >nul && echo  [✓] Boost Policy = 25%%
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFEPP 75          >nul && echo  [✓] EPP = 75 (efficiency)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTHRESHOLD 80 >nul && echo  [✓] Inc Threshold = 80%% (high bar)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTHRESHOLD 25 >nul && echo  [✓] Dec Threshold = 25%% (drop fast)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTIME 3       >nul && echo  [✓] Inc Time = 3 (filter bursts)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTIME 2       >nul && echo  [✓] Dec Time = 2
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% SYSCOOLPOL 0        >nul && echo  [✓] Cooling = Passive
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMIN 5   >nul && echo  [✓] Min State = 5%% (deep idle)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMAX 100 >nul && echo  [✓] Max State = 100%%
echo.
echo  GPU:
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_INTELGPU% %GUID_INTELGPU_SETTING% 0 >nul && echo  [✓] Intel GPU = Max Battery
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_GPUPREF% %GUID_GPUPREF_SETTING% 1   >nul && echo  [✓] GPU Preference = Low Power
powercfg /SETDCVALUEINDEX %GUID_SCHEME% SUB_PCIEXPRESS ASPM 2                     >nul && echo  [✓] PCIe ASPM = Max Savings
if %ADMIN%==1 (
    echo  [✓] NVIDIA = Optimal Power
    reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NvCplApi\Policies" /f /v PowerManagementMode /t REG_DWORD /d 2 >nul 2>&1
)
echo.
echo  ✅ DC Battery Efficient applied!
goto :eof


:preset_dc_maxbattery
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  🌿 DC — Max Battery Saver                             ║
echo  ║  Ultra efficient — no turbo, max savings              ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTMODE 1     >nul && echo  [✓] Boost Mode = 1 (Enabled, no aggressive)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFBOOSTPOL 10    >nul && echo  [✓] Boost Policy = 10%%
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFEPP 99          >nul && echo  [✓] EPP = 99 (max efficiency)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTHRESHOLD 95 >nul && echo  [✓] Inc Threshold = 95%% (very high bar)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTHRESHOLD 10 >nul && echo  [✓] Dec Threshold = 10%% (drop fast)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFINCTIME 5       >nul && echo  [✓] Inc Time = 5 (heavy filtering)
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PERFDECTIME 1       >nul && echo  [✓] Dec Time = 1
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% SYSCOOLPOL 0        >nul && echo  [✓] Cooling = Passive
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMIN 5   >nul && echo  [✓] Min State = 5%%
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMAX 99  >nul && echo  [✓] Max State = 99%% (turbo OFF)
echo.
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_INTELGPU% %GUID_INTELGPU_SETTING% 0 >nul && echo  [✓] Intel GPU = Max Battery
powercfg /SETDCVALUEINDEX %GUID_SCHEME% %GUID_GPUPREF% %GUID_GPUPREF_SETTING% 1   >nul && echo  [✓] GPU Preference = Low Power
powercfg /SETDCVALUEINDEX %GUID_SCHEME% SUB_PCIEXPRESS ASPM 2                     >nul && echo  [✓] PCIe ASPM = Max Savings
echo.
echo  ⚠ Turbo disabled (Max State=99%%)
echo  ✅ DC Max Battery Saver applied!
goto :eof


:: ====================================================================
::  CUSTOM CPU
:: ====================================================================

:custom_cpu
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  🛠️  Custom CPU Tuning                                ║
echo  ║  Press Enter to keep default for each param           ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
choice /c:AD /n /m "  Apply to [A]C or [D]C? "
if %ERRORLEVEL%==1 ( set PREFIX=SETACVALUEINDEX & set MODE=AC ) else ( set PREFIX=SETDCVALUEINDEX & set MODE=DC )
echo.

echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Boost Mode [0=Disabled 1=Enabled 2=Aggressive              │
echo  │            3=Efficient Enabled 4=Efficient Aggressive]     │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Boost Mode [0-4, default=2]: "
if not defined CUSTOM set CUSTOM=2
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFBOOSTMODE %CUSTOM% >nul && echo  [✓] Boost Mode = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Boost Policy — %% of turbo headroom to use (higher=eager)   │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Boost Policy [0-100, default=100]: "
if not defined CUSTOM set CUSTOM=100
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFBOOSTPOL %CUSTOM% >nul && echo  [✓] Boost Policy = %CUSTOM%%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ EPP — Energy Performance Preference (0=max perf, 100=eff)  │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  EPP [0-100, default=0]: "
if not defined CUSTOM set CUSTOM=0
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFEPP %CUSTOM% >nul && echo  [✓] EPP = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Increase Threshold — CPU load %% to start ramping up       │
echo  │   Low = turbo eagerly       High = filters light loads    │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Inc Threshold [0-100, default=5]: "
if not defined CUSTOM set CUSTOM=5
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFINCTHRESHOLD %CUSTOM% >nul && echo  [✓] Inc Threshold = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Decrease Threshold — load %% below which frequency drops    │
echo  │   High = holds frequency longer    Low = drops fast        │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Dec Threshold [0-100, default=90]: "
if not defined CUSTOM set CUSTOM=90
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFDECTHRESHOLD %CUSTOM% >nul && echo  [✓] Dec Threshold = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Increase Time — check intervals before ramping up          │
echo  │   1=instant   3=filter bursts   5+=heavy filter           │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Inc Time [1-10, default=1]: "
if not defined CUSTOM set CUSTOM=1
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFINCTIME %CUSTOM% >nul && echo  [✓] Inc Time = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Decrease Time — check intervals before dropping freq       │
echo  │   1=instant drop   5+=holds to avoid bouncing             │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Dec Time [1-10, default=2]: "
if not defined CUSTOM set CUSTOM=2
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFDECTIME %CUSTOM% >nul && echo  [✓] Dec Time = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Increase Policy — HOW to ramp up (0=Ideal 1=Single         │
echo  │   2=Rocket 3=IdealAggressive)                              │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Inc Policy [0-3, default=3]: "
if not defined CUSTOM set CUSTOM=3
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFINCPOL1 %CUSTOM% >nul && echo  [✓] Inc Policy = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Decrease Policy — HOW to drop freq (0=Ideal 1=Single       │
echo  │   2=Rocket)                                                 │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Dec Policy [0-2, default=2]: "
if not defined CUSTOM set CUSTOM=2
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFDECPOL %CUSTOM% >nul && echo  [✓] Dec Policy = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Check Interval — governor poll rate in ms                  │
echo  │   10=3x stock  15=2x stock  30=stock  60=relaxed          │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Check Interval [10-100ms, default=15]: "
if not defined CUSTOM set CUSTOM=15
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFCHECK %CUSTOM% >nul && echo  [✓] Check Interval = %CUSTOM%ms

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Min State — minimum frequency %% (5=deep idle, 100=pinned)  │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Min State [1-100, default=5]: "
if not defined CUSTOM set CUSTOM=5
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMIN %CUSTOM% >nul && echo  [✓] Min State = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Max State — maximum frequency %% (100=turbo, 99=no turbo)   │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Max State [1-100, default=100]: "
if not defined CUSTOM set CUSTOM=100
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMAX %CUSTOM% >nul && echo  [✓] Max State = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Cooling Policy   0=Passive (throttle)  1=Active (fan)      │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Cooling [0-1, default=1]: "
if not defined CUSTOM set CUSTOM=1
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% SYSCOOLPOL %CUSTOM% >nul && echo  [✓] Cooling = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Throttle States   0=Disabled  1=Enabled  2=Automatic       │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Throttle States [0-2, default=0]: "
if not defined CUSTOM set CUSTOM=0
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% THROTTLING %CUSTOM% >nul && echo  [✓] Throttle States = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ History Count — samples for governor decisions (1=instant) │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  History [1-10, default=1]: "
if not defined CUSTOM set CUSTOM=1
powercfg /%PREFIX% %GUID_SCHEME% %GUID_PROC% PERFHISTORY %CUSTOM% >nul && echo  [✓] History Count = %CUSTOM%

echo.
echo  ✅ Custom %MODE% CPU profile applied!
echo.
choice /m "  Also configure GPU? "
if %ERRORLEVEL%==1 call :custom_gpu
goto :eof


:: ====================================================================
::  CUSTOM GPU
:: ====================================================================

:custom_gpu
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  🎨 Custom GPU Tuning                                 ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
choice /c:AD /n /m "  Apply to [A]C or [D]C? "
if %ERRORLEVEL%==1 ( set PREFIX=SETACVALUEINDEX & set MODE=AC ) else ( set PREFIX=SETDCVALUEINDEX & set MODE=DC )
echo.

echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ Intel Graphics Power Plan                                  │
echo  │   0=Max Battery  1=Balanced  2=Max Performance             │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  Intel GPU [0-2, default=2]: "
if not defined CUSTOM set CUSTOM=2
powercfg /%PREFIX% %GUID_SCHEME% %GUID_INTELGPU% %GUID_INTELGPU_SETTING% %CUSTOM% >nul && echo  [✓] Intel GPU = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ GPU Preference   0=None (apps decide)   1=Low Power (iGPU) │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  GPU Preference [0-1, default=0]: "
if not defined CUSTOM set CUSTOM=0
powercfg /%PREFIX% %GUID_SCHEME% %GUID_GPUPREF% %GUID_GPUPREF_SETTING% %CUSTOM% >nul && echo  [✓] GPU Preference = %CUSTOM%

echo.
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ PCI Express ASPM — link power management for GPU           │
echo  │   0=Off  1=Moderate  2=Max Savings                         │
echo  └─────────────────────────────────────────────────────────────┘
set CUSTOM=& set /p CUSTOM="  PCIe ASPM [0-2, default=0]: "
if not defined CUSTOM set CUSTOM=0
powercfg /%PREFIX% %GUID_SCHEME% SUB_PCIEXPRESS ASPM %CUSTOM% >nul && echo  [✓] PCIe ASPM = %CUSTOM%

if %ADMIN%==1 (
    echo.
    echo  ┌─────────────────────────────────────────────────────────────┐
    echo  │ NVIDIA Power Mgmt   1=Max Perf  2=Optimal Power           │
    echo  └─────────────────────────────────────────────────────────────┘
    set CUSTOM=& set /p CUSTOM="  NVIDIA [1-2, default=1]: "
    if not defined CUSTOM set CUSTOM=1
    reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\NvCplApi\Policies" /f /v PowerManagementMode /t REG_DWORD /d %CUSTOM% >nul 2>&1 && echo  [✓] NVIDIA = %CUSTOM%
) else (
    echo.
    echo  [!] Not Admin — skip NVIDIA. Run as Admin to set NVIDIA mode.
)
echo.
echo  ✅ Custom %MODE% GPU profile applied!
goto :eof


:: ====================================================================
::  VIEW CURRENT
:: ====================================================================

:view_settings
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  📊 Current Power Settings                             ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
echo  Active Power Plan:
powercfg /GETACTIVESCHEME
echo.
echo  ── CPU ──
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFBOOSTMODE     | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFBOOSTPOL      | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFEPP           | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFINCTHRESHOLD  | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFDECTHRESHOLD  | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFINCTIME       | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFDECTIME       | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFINCPOL1       | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFDECPOL        | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFCHECK         | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMIN   | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PROCTHROTTLEMAX   | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% SYSCOOLPOL        | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% THROTTLING        | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_PROC% PERFHISTORY       | findstr "Current"
echo.
echo  ── GPU ──
powercfg /QUERY %GUID_SCHEME% %GUID_INTELGPU% %GUID_INTELGPU_SETTING%   | findstr "Current"
powercfg /QUERY %GUID_SCHEME% %GUID_GPUPREF% %GUID_GPUPREF_SETTING%     | findstr "Current"
powercfg /QUERY %GUID_SCHEME% SUB_PCIEXPRESS ASPM                       | findstr "Current"
echo.
goto :eof


:: ====================================================================
::  EXPORT
:: ====================================================================

:export_profile
cls
echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  💾 Export Profile                                    ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
:: Build filename: onslaught-YYYYMMDD.pow
set POWFILE=onslaught-%DATE:~-4%%DATE:~4,2%%DATE:~7,2%.pow
powercfg /EXPORT %GUID_SCHEME% "%CD%\%POWFILE%" >nul 2>&1
if %ERRORLEVEL%==0 (
    echo  [✓] Exported: %CD%\%POWFILE%
    echo  To restore: powercfg /IMPORT "%CD%\%POWFILE%"
) else (
    echo  [!] Export failed. Run as Administrator.
)
echo.
goto :eof
