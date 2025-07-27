# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer, RisingEdge


async def uart_send_byte(dut, byte):
    bit_time_ns = 104160  # 104.16 us = 9600 baud

    # Start bit
    dut.ui_in[0].value = 0
    await Timer(bit_time_ns, units="ns")

    # Data bits (LSB first)
    for i in range(8):
        dut.ui_in[0].value = (byte >> i) & 1
        await Timer(bit_time_ns, units="ns")

    # Stop bit
    dut.ui_in[0].value = 1
    await Timer(bit_time_ns, units="ns")


@cocotb.test()
async def test_uart_behavior(dut):
    dut._log.info("Starting test...")

    # Clock setup: 10 MHz = 100 ns period
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 1  # Idle state for UART RX
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # Send UART byte 0x01
    await uart_send_byte(dut, 0x01)
    while dut.uio_out[0].value.integer != 0:
        await RisingEdge(dut.clk)

    # Delay and send 0xA5
    await Timer(500, units="ns")
    await uart_send_byte(dut, 0xA5)
    while dut.uio_out[0].value.integer != 0:
        await RisingEdge(dut.clk)

    # Send 0x80
    await uart_send_byte(dut, 0x80)
    while dut.uio_out[0].value.integer != 0:
        await RisingEdge(dut.clk)

    dut._log.info("Test completed.")
