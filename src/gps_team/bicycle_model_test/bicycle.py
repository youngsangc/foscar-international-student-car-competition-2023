import numpy as np
import matplotlib.pyplot as plt
import random

# Initialize parameters
L = 2.0  # Wheelbase length
lr = 1.0  # Distance from center of mass to the rear axle
dt = 0.1  # Time step (s)
T = 10.0  # Total simulation time (s)
N = int(T / dt)  # Number of time steps

# Initialize state variables
x = np.zeros(N+1)
y = np.zeros(N+1)
psi = np.zeros(N+1)

# Initial conditions
x[0] = 0.0
y[0] = 0.0
psi[0] = 0.0

# Constant inputs for this example
# Velocity (m/s)
velocities = [random.random()*5 for _ in range(N)]
# Steering angle (rad)
deltas = [(-1)**(random.randint(0, 1))*(np.pi/random.randint(4, 10)) for _ in range(N)]

# Time-discretized equations of motion
for t, (v, delta) in enumerate(zip(velocities, deltas)):
    beta = np.arctan((lr / L) * np.tan(delta))
    x[t + 1] = x[t] + dt * v * np.cos(psi[t] + beta)
    y[t + 1] = y[t] + dt * v * np.sin(psi[t] + beta)
    psi[t + 1] = psi[t] + dt * (v / L) * np.cos(beta) * np.tan(delta)
    
# Plotting the trajectory
colors = np.arange(len(x))

# Create scatter plot with color gradation
plt.scatter(x, y, c=colors, cmap='jet')
plt.grid(True)
plt.colorbar(label='Index')
plt.xlabel('X Position (m)')
plt.ylabel('Y Position (m)')
plt.title('Vehicle Trajectory')
plt.show()

# Function to plot arrow
def plot_arrow(x, y, yaw, length=0.7, width=0.2):
    plt.arrow(x, y, length * np.cos(yaw), length * np.sin(yaw),
              head_length=width, head_width=width, fc='r', ec='r')

# Plotting the trajectory
plt.figure()
plt.plot(x, y)

# Plot arrows to indicate psi (yaw angle)
arrow_interval = 3
for i in range(0, len(psi), arrow_interval):
    plot_arrow(x[i], y[i], psi[i])


plt.xlabel('X Position (m)')
plt.ylabel('Y Position (m)')
plt.title('Vehicle Trajectory with Yaw Angles')
plt.grid(True)
plt.show()
