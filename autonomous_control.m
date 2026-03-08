% ============================================================
% Project Spyn — LEGO Autonomous Wheelchair-Accessible Car
% Team: The Akatsuki Group | Arizona State University
% Course: FSE 100 — Introduction to Engineering
% ============================================================
% PROGRAM OVERVIEW:
%   This program controls a LEGO Mindstorms EV3 car designed
%   to assist individuals with mobility impairments.
%
%   The car operates in THREE modes:
%     1. AUTONOMOUS MODE (black line detected)
%        -> Uses ultrasonic + touch sensors to navigate
%     2. MANUAL MODE (colored line detected)
%        -> Driver controls car via keyboard arrow keys
%     3. STOP MODE (red detected)
%        -> Car brakes automatically like a traffic light
%
% SENSOR CONFIGURATION:
%   Port 1 -> Touch Sensor      (detects front wall/obstacle)
%   Port 2 -> Color Sensor      (detects line color on ground)
%   Port 3 -> Ultrasonic Sensor (measures distance to left wall)
%
% MOTOR CONFIGURATION:
%   Motor A -> Left wheel
%   Motor B -> Right wheel
%   Motor C -> Wheelchair ramp (lifts up / lowers down)
%
% KEYBOARD CONTROLS (Manual Mode):
%   Up Arrow    -> Move forward
%   Down Arrow  -> Move backward
%   Left Arrow  -> Turn left
%   Right Arrow -> Turn right
%   W           -> Lift wheelchair ramp up
%   S           -> Lower wheelchair ramp down
%   B           -> Emergency stop
%   E           -> Exit program
%   K           -> Re-initialize keyboard
% ============================================================

% ── Initialization ──────────────────────────────────────────
global key;
InitKeyboard();                  % Start listening for keyboard input
brick.SetColorMode(2, 2);        % Set Port 2 color sensor to COLOR mode
                                 % Mode 2 = returns a color code number

% ── COLOR CODE REFERENCE (LEGO EV3) ─────────────────────────
% 0 = No color   1 = Black   2 = Blue    3 = Green
% 4 = Yellow     5 = Red     6 = White   7 = Brown

% ── Main Control Loop ───────────────────────────────────────
while 1
    pause(0.1);                       % Small delay to prevent CPU overload
    color = brick.ColorCode(2);       % Read color from sensor on Port 2
    display(color);                   % Print color code to console for debugging

    % ────────────────────────────────────────────────────────
    % MODE 1: MANUAL MODE
    % Triggered when: Blue(2), Green(3), Yellow(4), or Brown(7) detected
    % Purpose: These colors mark zones where human control is needed
    %          e.g. tight spaces, drop-off areas, ramps
    % ────────────────────────────────────────────────────────
    if (color == 2 || color == 3 || color == 4 || color == 7)
        disp("Switching to Manual Mode")

        brick.StopMotor('AB');        % Stop both motors before reading key
        pause(0.1);

        switch key
            case 'uparrow'
                % Move forward (negative = forward on this motor setup)
                brick.MoveMotor('AB', -25);

            case 'leftarrow'
                % Turn left: Motor A forward, Motor B backward = pivot left
                brick.MoveMotor('A',  40);
                brick.MoveMotor('B', -40);

            case 'rightarrow'
                % Turn right: Motor B forward, Motor A backward = pivot right
                brick.MoveMotor('B',  35);
                brick.MoveMotor('A', -35);

            case 'downarrow'
                % Move backward
                brick.MoveMotor('AB', 25);

            case 'w'
                % Lift wheelchair ramp UP using Motor C
                brick.MoveMotor('C', 20);
                pause(0.9);           % Run for 0.9s to reach full lift
                brick.StopMotor('C');

            case 's'
                % Lower wheelchair ramp DOWN using Motor C
                brick.MoveMotor('C', -20);
                pause(0.9);           % Run for 0.9s to fully lower
                brick.StopMotor('C');

            case 'b'
                % Emergency stop - halt both drive motors immediately
                brick.StopMotor('AB');

            case 'e'
                % Exit program gracefully
                brick.StopMotor('AB');
                CloseKeyboard();
                break;

            case 'k'
                % Re-initialize keyboard if listener drops
                InitKeyboard();
        end
    end

    % ────────────────────────────────────────────────────────
    % MODE 2: STOP MODE (Traffic Light Logic)
    % Triggered when: Red (5) detected
    % Purpose: Simulates a red traffic light - automatic safety brake
    % ────────────────────────────────────────────────────────
    if color == 5
        disp("Red light — applying brakes, hold tight!")
        brick.MoveMotor('AB', 0);     % Brake - stop motors
        pause(4);                     % Wait 4 seconds (red light duration)
        brick.MoveMotor('AB', -50);   % Slowly resume forward movement
        pause(1);
    end

    % ────────────────────────────────────────────────────────
    % MODE 3: AUTONOMOUS MODE
    % Triggered when: Black (1) detected
    % Purpose: Car navigates on its own using two sensors
    %
    % TWO SENSORS WORK TOGETHER:
    %   Ultrasonic (Port 3): distance to LEFT wall in cm
    %   Touch Sensor (Port 1): 1 = front blocked, 0 = front clear
    %
    % FOUR SCENARIOS:
    %   dis<=65, tt=0  -> Clear ahead + aligned    -> Drive forward
    %   dis<=65, tt=1  -> Blocked + aligned        -> Back up + turn RIGHT
    %   dis>65,  tt=1  -> Blocked + not aligned    -> Back up + turn LEFT
    %   dis>65,  tt=0  -> Clear + not aligned      -> Turn LEFT to re-align
    % ────────────────────────────────────────────────────────
    if (color == 1)
        disp("Switching to Autonomous Mode")
        brick.StopMotor('AB');                  % Brief stop before deciding

        dis = brick.UltrasonicDist(3);          % Distance to left wall (cm)
        tt  = brick.TouchPressed(1);            % Front obstacle: 1=yes, 0=no

        % Scenario 1: Path clear + aligned with wall -> Go forward
        if (dis <= 65 && tt == 0)
            brick.MoveMotor('AB', -70);

        % Scenario 2: Front blocked + aligned -> Back up then turn RIGHT
        elseif (dis <= 65 && tt == 1)
            brick.MoveMotor('A', 50);           % Back up to create turning room
            brick.MoveMotor('B', 50);
            pause(1);
            brick.MoveMotor('B',  100);         % Pivot RIGHT
            brick.MoveMotor('A', -100);
            pause(2.3);                         % ~90 degree turn
            brick.StopMotor('AB');

        % Scenario 3: Front blocked + not aligned -> Back up then turn LEFT
        elseif (dis > 65 && tt == 1)
            brick.MoveMotor('A', 50);           % Back up to create turning room
            brick.MoveMotor('B', 50);
            pause(1);
            brick.MoveMotor('B', -100);         % Pivot LEFT
            brick.MoveMotor('A',  100);
            pause(2.2);                         % ~90 degree turn
            brick.StopMotor('AB');
            brick.MoveMotor('AB', -50);         % Move forward to avoid double rotation
            pause(2);
            brick.StopMotor('AB');

        % Scenario 4: Path open + not aligned -> Turn LEFT to re-align
        elseif (dis > 65 && tt == 0)
            brick.MoveMotor('B', -100);         % Pivot LEFT to re-align
            brick.MoveMotor('A',  100);
            pause(2.2);
            brick.MoveMotor('AB', -50);         % Move forward to stabilize
            pause(2);
        end
    end

end % End of main control loop
