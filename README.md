# SPI Protocol verification using UVM


This project is a complete UVM testbench I built to verify **SPI Protocol** using the RTL of the SPI controller.
The main objective in the RTL was to program the internal registers of the controller which are mainly three controller:
 - **Adress register** : Address where in the slave the master will initiate the transaction.
 - **Data Register**   : Data to store the location selected by the master to store the data.
 - **Control Register**: It stores the control information like number of transactions, pending transactions, control pins for the state machine.

The function of the testbench is to let a processor (Master UVC -using APB) easily configure and control a peripheral device(Slave UVC) that communicates using the SPI serial protocol (MOSI/MISO). My objective was to ensure that SPI protocol sends data to the slave as the program register were programmed using the APB protocol and this translation from parallel (APB) to serial (SPI) happens flawlessly.



---

### My Verification Strategy

This testbench was built using **SystemVerilog** and **UVM**. The most interesting part is the two-agent approach I used to perform a true end-to-end check.

* **1. The APB Agent**:
  -This active UVM agent acts like a processor. It sends high-level commands on the APB bus like to program the internal registers and the control information.
  -It also monitors the transactions through the monitor and verify them using the Scoreboard.

* **2. The SPI Agent (The "Low-Level Inspector")**:
  -This passive UVM agent doesn't drive any signals. Its only job is to watch the SPI pins (MOSI, MISO, SCLK, CS) and monitor through the monitor and sends them into the scoreboard.

* **3. The Scoreboard**:
    This is the core of the testbench. It verifies that SPI signals works in sync with the program registers in the controller.
    1.  It gets the trasactions through master monitor from the **APB agent**.
    2.  It also gets the modified bundles of transactions from the slave monitor which contains the SPI signals.
    3.  Then it compares the both transactions and checks if the SPI Protocol sends the data as per the control registers of the controllers.

    If they match, the test passes! This proves that the bridge is translating the commands correctly.
    (Also there are two analysis ports declared in the monitor, so they are being managed by the analysis port `uvm_analysis_imp_decl(_apb) and `uvm_analysis_imp_decl(_spi) macro.)

---

### Key Features I Verified

* **End-to-End Data Integrity**: Confirmed that data written via the APB bus comes out correctly on the SPI `MOSI` line, and data received on `MISO` can be read back accurately from the APB bus.
* **Register Programming**: Ensured all the internal configuration registers of the bridge could be written to and read from correctly.
* **SPI Protocol Compliance**: Verified that the clock (`SCLK`), chip select (`CS`), and data lines all followed the proper SPI timing rules.

---

### How I Proved It Worked

I confirmed the success of the verification through multiple checks:
* **Passing Scoreboard**: The scoreboard reported zero mismatches across all tests.
* **Monitor Logs**: The transaction logs from both the APB and SPI monitors showed the expected behavior.
* **Waveform Analysis**: I visually inspected the waveforms to manually confirm key transactions and timing.
