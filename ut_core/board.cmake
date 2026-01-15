# STM32CubeProgrammer: Configure the official ST tool to use the SWD interface 
# and perform a hardware reset to ensure a clean state.
board_runner_args(stm32cubeprogrammer "--port=swd" "--reset-mode=hw")

# OpenOCD: Set a custom TCL port (6666) to avoid conflicts with other running instances.
# Enable GDB data abort reporting to help debug memory access violations (Hard Faults).
board_runner_args(openocd "--tcl-port=6666")
board_runner_args(openocd --cmd-pre-init "gdb_report_data_abort enable")
board_runner_args(openocd "--no-halt")

# OpenOCD: Define the hardware setup using an ST-Link via SWD transport,
# targeting the specific STM32U5 architecture config.
board_runner_args(openocd
  "-f" "interface/stlink.cfg"
  "-c" "transport select swd"
  "-f" "target/stm32u5x.cfg"
)

# PyOCD: specific target string required for flash algorithms and memory map.
board_runner_args(pyocd "--target=stm32u5a5rjtx")

# J-Link: Specify the exact silicon device and force a reset after flashing
# so the application starts immediately.
board_runner_args(jlink "--device=STM32U5A5RJ" "--reset-after-load")

# Load the Zephyr scripts that execute the actual flashing commands using the args above.
include(${ZEPHYR_BASE}/boards/common/stm32cubeprogrammer.board.cmake)
include(${ZEPHYR_BASE}/boards/common/openocd-stm32.board.cmake)
include(${ZEPHYR_BASE}/boards/common/pyocd.board.cmake)
include(${ZEPHYR_BASE}/boards/common/jlink.board.cmake)