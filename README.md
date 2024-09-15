*Spacecraft Power Management System*
<img width="691" alt="Power Management System" src="https://github.com/user-attachments/assets/02368da7-b1cb-47aa-84d7-723e71de5451">

*Description*

This project simulates a basic spacecraft power management system using MATLAB Simulink. The simulation models the interaction between solar panels, batteries, and varying electrical loads to ensure efficient power balance in a spacecraft during orbit. The system takes into account solar radiation, eclipse conditions, battery charging and discharging, and fluctuating power demands from the spacecraft’s systems. The results of the power management system are visualized using a scope, showing the net power balance over time.

*Aim*

The aim of this project is to develop and simulate a spacecraft power management system that dynamically manages power generation, storage, and consumption in varying environmental and operational conditions.

*Objectives*

Model the Power Generation Subsystem (Solar Panel): Simulate the energy generation from solar radiation, adjusting for eclipse conditions using a sine wave to represent orbital shadows.
Model the Power Storage Subsystem (Battery): Simulate the battery system that charges when excess power is available and discharges when there is a power deficit.
Model the Power Consumption Subsystem (Load): Represent the spacecraft's electrical loads with varying demands, including both base load and periodic peak loads.
Manage Power Balance: Calculate the net power generated versus consumed, with battery charging or discharging to maintain balance.
Visualization: Use a Simulink scope to plot the real-time power balance and monitor the system’s performance under changing conditions.

*System Overview*

1. Solar Panel Subsystem:
Takes inputs such as solar radiation and an eclipse factor to simulate the power output of solar panels.
Efficiency is set at 30%.
2. Battery Subsystem:
Represents the battery's state of charge, charging when excess power is available and discharging when there's a deficit.
Battery has upper and lower limits to prevent overcharge or deep discharge.
3. Load Subsystem:
Simulates the base power consumption of the spacecraft and periodic peak loads.
4. Power Balance Calculation:
Computes the net power available by subtracting load consumption from power generated by the solar panel and battery.
5. Scope Output:
The PowerScope block visualizes the power balance, showing how the system performs over time, including when the spacecraft is in and out of sunlight.

*Model Details*

Solar Panel: The solar panel produces power based on the given solar radiation and the eclipse factor.
Battery: The battery stores excess power and discharges when there’s a power deficit.
Load: The load consists of a constant base load and a peak load which occurs at regular intervals.
Power Balance: The power balance calculation determines whether the system has a surplus or deficit of power, which is visualized using a scope block.

*Usage*

To run the model:
Open MATLAB and Simulink.
Download the project files and load the Simulink model (SpacecraftPowerManagement.mdl).
Run the simulation for a duration of 3 hours (simulated time).
Visualize the net power on the PowerScope block.

*Requirements:*
MATLAB R2023a or later
Simulink toolbox
