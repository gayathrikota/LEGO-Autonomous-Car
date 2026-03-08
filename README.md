# Project Spyn — LEGO Autonomous Wheelchair-Accessible Car
### MATLAB · LEGO Mindstorms EV3 · Ultrasonic Sensors · Color Sensor · Robotics | ASU FSE 100

> **Objective:** Design and program a LEGO Mindstorms EV3 vehicle that can autonomously navigate an obstacle course while also supporting individuals with mobility impairments through a motorized wheelchair ramp and wireless keyboard control.

---

## 👥 Team — The Akatsuki Group

| Name |
|------|
| Gayathri Kota |
| Rakshith Reddy Mudigolam |
| Mukesh Tulluru |
| Naga Sathvik Kommareddy |
| Mrudula Eluri |

---

## Demo Video

▶️ **[Watch the full car demonstration on YouTube](https://youtu.be/BWAP3AxwybM)**

---

## Project Overview

Project Spyn is an autonomous LEGO EV3 vehicle built for **FSE 100 — Introduction to Engineering** at Arizona State University. The car was designed with accessibility in mind — it features a **motorized sliding wheelchair ramp** and can be operated both autonomously and via **wireless keyboard control**.

The system uses real-time sensor data to switch between three operating modes automatically, making it capable of navigating complex environments without human input.

---

## How It Works — Three Operating Modes

The car reads its **color sensor** every 0.1 seconds and switches modes based on what color it detects on the ground:

| Color Detected | Color Code | Mode Activated |
|----------------|-----------|----------------|
| ⚫ Black | 1 | **Autonomous Mode** — sensors take over navigation |
| 🔵 Blue / 🟢 Green / 🟡 Yellow / 🟤 Brown | 2, 3, 4, 7 | **Manual Mode** — keyboard control |
| 🔴 Red | 5 | **Stop Mode** — automatic brake (traffic light) |

---

## ⚙️ Hardware Configuration

### Sensors
| Port | Sensor | Purpose |
|------|--------|---------|
| Port 1 | Touch Sensor | Detects if the front is blocked by an obstacle |
| Port 2 | Color Sensor | Reads ground color to determine operating mode |
| Port 3 | Ultrasonic Sensor | Measures distance to the left wall (in cm) |

### Motors
| Motor | Purpose |
|-------|---------|
| Motor A | Left drive wheel |
| Motor B | Right drive wheel |
| Motor C | Wheelchair ramp (lift up / lower down) |

---

## Autonomous Mode — Navigation Logic

When **black** is detected, the car uses **two sensors together** to decide how to move:

```
Ultrasonic (Port 3) → distance to LEFT wall
Touch Sensor (Port 1) → is the FRONT blocked? (1=yes, 0=no)
```

| Scenario | Distance | Touch | Action |
|----------|----------|-------|--------|
| Clear ahead, aligned with wall | ≤ 65 cm | Not pressed | Drive straight forward |
| Front blocked, aligned | ≤ 65 cm | Pressed | ⬅️ Back up → Turn RIGHT 90° |
| Front blocked, not aligned | > 65 cm | Pressed | ⬅️ Back up → Turn LEFT 90° → Move forward |
| Path open, not aligned | > 65 cm | Not pressed | ↩️ Turn LEFT → Move forward to re-align |

---

## ⌨️ Manual Mode — Keyboard Controls

When a colored line (blue/green/yellow/brown) is detected, the driver takes over:

| Key | Action |
|-----|--------|
| `↑` Up Arrow | Move forward |
| `↓` Down Arrow | Move backward |
| `←` Left Arrow | Turn left |
| `→` Right Arrow | Turn right |
| `W` | Lift wheelchair ramp **up** |
| `S` | Lower wheelchair ramp **down** |
| `B` | Emergency stop |
| `E` | Exit program |
| `K` | Re-initialize keyboard |

---

## 🚦 Stop Mode — Traffic Light Logic

When **red** is detected, the car:
1. Immediately brakes (`MoveMotor('AB', 0)`)
2. Waits **4 seconds** (simulating a red light)
3. Slowly resumes forward movement

---

## Repository Structure

```
project-spyn/
├── autonomous_control.m     # Full MATLAB control program (all 3 modes)
└── README.md
```

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **MATLAB** | Programming language for EV3 control |
| **LEGO Mindstorms EV3** | Hardware platform |
| **Ultrasonic Sensor** | Real-time obstacle detection |
| **Color Sensor** | Mode switching via color detection |
| **Touch Sensor** | Front obstacle detection |
| **InitKeyboard() / CloseKeyboard()** | MATLAB keyboard listener for wireless control |

---

## Key Engineering Decisions

**Why color-based mode switching?**  
Using colored tape on the ground is a simple, reliable way to define zones — no complex path-planning needed. Black = autonomous zone, colored = manual zone, red = stop zone.

**Why two sensors in autonomous mode?**  
A single sensor would not give enough information to make smart turning decisions. Combining the ultrasonic (left wall distance) with the touch sensor (front obstacle) gives the car four distinct scenarios to handle — covering all possible navigation situations.

**Why Motor C for the ramp?**  
Keeping the ramp motor separate from the drive motors (A and B) means the ramp can be operated at any time without interrupting movement — critical for real-world accessibility use.

---

## 👩‍💻 Author

**Gayathri Kota**  
B.S. Data Science | Arizona State University  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-gayathrikota-blue?style=flat&logo=linkedin)](https://linkedin.com/in/gayathrikota)
[![GitHub](https://img.shields.io/badge/GitHub-gayathrikota-black?style=flat&logo=github)](https://github.com/gayathrikota)
