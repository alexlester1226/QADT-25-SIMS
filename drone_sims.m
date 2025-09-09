%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DESCRIPTION:
%   This script animates a "square-based cone" in 3D and adds random IR
%   markers on the ground within a circular area of radius 100. The markers
%   are plotted as red dots on the ground plane (z=0), and the animation
%   includes the movement of the apex and the rotating square.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1) Clear and Setup
clear all;
close all;
clc;

%% 2) Parameters
vel = 20;                % Movement speed (m/s or arbitrary units)
FOV_deg = 46;            % Field of view in degrees (controls square size)
FPS = 68;                % Frames per second for the animation
h = 30;                  % Height of the "cone" apex above the ground (z=0)
xAdj = 0;                % Initial x offset of the apex
yAdj = 0;                % Initial y offset of the apex



% arr of lines
arr_line = cell(1000, 1);
count = 1;               % count of lines in array


% Define parameter t for building lines
t = linspace(0, 1, 2); % Generates 2 evenly spaced values from 0 to 1

% The rotation angles (in radians) that will manipulate the square's shape.
xThe = 0;                % Rotation angle around the X-axis
xTheUp = 1;              % Whether xThe is increasing (1) or decreasing (0)
yThe = 0;                % Rotation angle around the Y-axis
yTheUp = 1;              % Whether yThe is increasing (1) or decreasing (0)

maxRotation = deg2rad(40);   % Maximum allowed rotation in radians (~40 deg)
stage = 1;                   % Apex movement stage

% Field of view in radians
FOV_rad = deg2rad(FOV_deg);

% Circle and marker parameters
circle_radius = 100;          % Ground circle radius
num_markers = randi([2,8]);             % Number of IR markers
marker_positions = circle_radius * (rand(num_markers, 2) - 0.5) * 2; % Random markers

%% 3) Figure Setup
figure('Color','white');         % Create a figure with a white background
hold on;
grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Square Cone + Random IR Markers on Ground'); 
view(45, 30);
% view(2);
xlim([-200, 200]);
ylim([-200, 200]);
zlim([0, 40]);

%% 4) Ground Circle and Markers
% Draw the circle outline
h_circle = drawCircle(0, 0, circle_radius, false);


% Generate random IR markers within the circular area
marker_radii = sqrt(rand(num_markers, 1)) * circle_radius;  % Ensure uniform distribution
marker_angles = rand(num_markers, 1) * 2 * pi;
marker_x = marker_radii .* cos(marker_angles);
marker_y = marker_radii .* sin(marker_angles);
arr_points = [marker_x, marker_y];


% Plot IR markers as red dots
scatter3(marker_x, marker_y, zeros(num_markers,1), 40, 'r', 'filled');

%% 5) Apex: a red marker at (xAdj, yAdj, h)
apex = plot3(xAdj, yAdj, h, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

%% 6) Lines from Apex to Square Corners
l1 = plot3([0,0], [0,0], [h,0], 'k-','LineWidth',1);
l2 = plot3([0,0], [0,0], [h,0], 'k-','LineWidth',1);
l3 = plot3([0,0], [0,0], [h,0], 'k-','LineWidth',1);
l4 = plot3([0,0], [0,0], [h,0], 'k-','LineWidth',1);

%% 7) Handle for the Animated Square
sqOutline = plot3(nan, nan, nan, 'k');


%% 8) Animation Loop
for t = 0 : (1/FPS) : 50
    %% (A) Calculate Square Parameters
    a = h * tan(FOV_rad/2) / cos(xThe);  % half-width in X
    b = h * tan(FOV_rad/2) / cos(yThe);  % half-width in Y
    c = h * tan(xThe);                   % offset in X
    d = h * tan(yThe);                   % offset in Y

    %% (B) Update Apex Position
    set(apex, 'XData', xAdj, 'YData', yAdj, 'ZData', h);

    %% (C) Draw Square

    % Get the current square vertices
    X = [xAdj + c - a, xAdj + c + a, xAdj + c + a, xAdj + c - a];
    Y = [yAdj + d - b, yAdj + d - b, yAdj + d + b, yAdj + d + b];
    Z = [0, 0, 0, 0];

    % Display the vertices to the terminal
    % fprintf('Square Vertices at t = %.2f:\n', t);
    % Display the vertices to the terminal
    % fprintf('Square Vertices at t = %.2f:\n', t);
    % fprintf('Vertex 1 (Bottom-Left):  (X = %.2f, Y = %.2f, Z = %.2f)\n', X(1), Y(1), Z(1));
    % fprintf('Vertex 2 (Bottom-Right): (X = %.2f, Y = %.2f, Z = %.2f)\n', X(2), Y(2), Z(2));
    % fprintf('Vertex 3 (Top-Right):    (X = %.2f, Y = %.2f, Z = %.2f)\n', X(3), Y(3), Z(3));
    % fprintf('Vertex 4 (Top-Left):     (X = %.2f, Y = %.2f, Z = %.2f)\n', X(4), Y(4), Z(4));
    % fprintf('\n');  % Add a newline for readability
    
    % plot3(X(1), Y(1), Z(1), 'ro', 'MarkerSize', 1, 'MarkerFaceColor', 'r'); % Start point
    % plot3(X(2), Y(2), Z(2), 'ro', 'MarkerSize', 1, 'MarkerFaceColor', 'r'); % Start point
    % plot3(X(3), Y(3), Z(3), 'ro', 'MarkerSize', 1, 'MarkerFaceColor', 'r'); % Start point
    % plot3(X(4), Y(4), Z(4), 'ro', 'MarkerSize', 1, 'MarkerFaceColor', 'r'); % Start point


    % draw square
    filledSq = drawSquare(xAdj + c, yAdj + d, a, b, true);
    set(filledSq,'FaceAlpha',0.2);
    delete(sqOutline);
    sqOutline = drawSquare(xAdj + c, yAdj + d, a, b, false);

    %% (D) Update Lines to Square Corners
    cx = xAdj + c;
    cy = yAdj + d;

    set(l1, 'XData',[xAdj, cx - a], 'YData',[yAdj, cy - b], 'ZData',[h, 0]);
    set(l2, 'XData',[xAdj, cx + a], 'YData',[yAdj, cy - b], 'ZData',[h, 0]);
    set(l3, 'XData',[xAdj, cx + a], 'YData',[yAdj, cy + b], 'ZData',[h, 0]);
    set(l4, 'XData',[xAdj, cx - a], 'YData',[yAdj, cy + b], 'ZData',[h, 0]);

    %% (E) Update Apex Movement and Angles
    if stage == 1
        yAdj = yAdj + vel/FPS;
        if xTheUp == 1
            xThe = xThe + 0.02;
            if xThe > maxRotation, xTheUp = 0; end
        else
            xThe = xThe - 0.02;
            if xThe < -maxRotation, xTheUp = 1; end
        end
        if yAdj > 100
            stage = 2; 
            disp("Stage 2")
            disp("X:")
            disp(xAdj)
            disp("Y:")
            disp(yAdj)
        end


    elseif stage == 2
       % Define turn parameters
        turn_radius = 30;  % Fixed turn radius
        turn_speed = vel / turn_radius;  % Angular velocity in rad/s
        turn_center_x = 0 - turn_radius;  % Center of turn (left turn)
        turn_center_y = 100;              % Same Y as start


        % Compute turn angle from start
        theta = (t - 100/vel) * turn_speed;  % Angle progression (radians)
        % Compute new position along a circular arc (Counterclockwise turn)
        xAdj = turn_center_x + turn_radius * cos(theta);
        yAdj = turn_center_y + turn_radius * sin(theta);

        % Check if turn is complete (theta reaches pi)
        if theta >= pi 
            stage = 3;
            disp("Stage 3")
            disp("X:")
            disp(xAdj)
            disp("Y:")
            disp(yAdj)
        end
    elseif stage == 3
        yAdj = yAdj - vel/FPS;
        if xTheUp == 1
             xThe = xThe - 0.02;
            if xThe < -maxRotation, xTheUp = 0; end
        else
            xThe = xThe + 0.02;
            if xThe > maxRotation, xTheUp = 1; end
        end
        if yAdj < -100 
            stage = 4; 
            disp("Stage 4")
            disp("X:")
            disp(xAdj)
            disp("Y:")
            disp(yAdj)
        end

    elseif stage == 4
        % Define turn parameters (mirrored from Stage 2)
        turn_radius = 30;  % Fixed turn radius
        turn_speed = vel / turn_radius;  % Angular velocity in rad/s
    
        % NEW Turn Center (for right turn at y=-100)
        turn_center_x = -turn_radius;  % Shifted turn center for right turn
        turn_center_y = -100;          % Adjusted for lower position
    
        % Compute initial theta based on the last known position
        theta_0 = atan2(yAdj - turn_center_y, xAdj - turn_center_x);  
    
        % Compute updated theta
        theta = theta_0 + (1/FPS) * turn_speed;  
    
        % Compute new position along a circular arc (Clockwise turn)
        xAdj = turn_center_x + turn_radius * cos(theta);  
        yAdj = turn_center_y + turn_radius * sin(theta);  
    
        % Check if turn is complete
        if theta >= 0  
            stage = 5;
            disp("Stage 5")
            disp("X:")
            disp(xAdj)
            disp("Y:")
            disp(yAdj)
        end
    elseif stage == 5
        yAdj = yAdj + vel/FPS;
        if xTheUp == 1
            xThe = xThe + 0.02;
            if xThe > maxRotation, xTheUp = 0; end
        else
            xThe = xThe - 0.02;
            if xThe < -maxRotation, xTheUp = 1; end
        end
        if yAdj > 100
            stage = 6;
            t_set = t;
            disp("Stage 6")
            disp("X:")
            disp(xAdj)
            disp("Y:")
            disp(yAdj)

        end
    elseif stage == 6
        % Define turn parameters
        turn_radius = 30;  % Fixed turn radius
        turn_speed = vel / turn_radius;  % Angular velocity in rad/s
        
        % Adjusted center for clockwise turn
        turn_center_x = 0 + turn_radius;  % Shift center to the right instead of left
        turn_center_y = 100;              % Same Y as start
        
        % Compute updated theta
        theta = (5 + (t - t_set) - 100/vel) * turn_speed;  % Negative sign for clockwise rotation
        
        % Compute new position along a circular arc (Clockwise turn)
        xAdj = turn_center_x + turn_radius * cos(pi-theta);
        yAdj = turn_center_y + turn_radius * sin(theta);  % Flip sin sign
        
        % Check if turn is complete (theta reaches -pi)
        if theta >= pi 
            stage = 7;
            disp("Stage 7")
            disp("X:")
            disp(xAdj)
            disp("Y:")
            disp(yAdj)
        end
    elseif stage == 7
        yAdj = yAdj - vel/FPS;
        if xTheUp == 1
             xThe = xThe - 0.02;
            if xThe < -maxRotation, xTheUp = 0; end
        else
            xThe = xThe + 0.02;
            if xThe > maxRotation, xTheUp = 1; end
        end
        if yAdj < -100 
            stage = 8; 
            t_set = t;
            disp("Stage 8")
            disp("X:")
            disp(xAdj)
            disp("Y:")
            disp(yAdj)
        end
    elseif stage == 8
        % Define turn parameters
        turn_radius = 30;  % Fixed turn radius
        turn_speed = vel / turn_radius;  % Angular velocity in rad/s
        
        % Adjusted center for clockwise turn
        turn_center_x = 0 - turn_radius;  % Shift center to the right instead of left
        turn_center_y = -100;              % Same Y as start
        
        % Compute updated theta
        theta = (5 + (t - t_set) - 100/vel) * turn_speed;  % Negative sign for clockwise rotation
        
        % Compute new position along a circular arc (Clockwise turn)
        xAdj = turn_center_x + turn_radius * -cos(theta);
        yAdj = turn_center_y + turn_radius * -sin(theta);  % Flip sin sign
        
        % Check if turn is complete (theta reaches -pi)
        % if theta >= pi 
        %     stage = 9;
        % end
    end

    % loop to check if marker is seen by camera 
    for i = 1:num_markers
        if (X(1) < arr_points(i,1)) && (arr_points(i,1) < X(2))
            if (Y(1) < arr_points(i, 2)) && (arr_points(i, 2) < Y(4))
                
                P1 = [xAdj; yAdj; h];   % Starting point (Column vector)
                x_rand = randi([-20, 20]);
                y_rand = randi([-20, 20]);

                P2 = [(arr_points(i, 1) + x_rand/10); (arr_points(i, 2) + y_rand/10); 0]; % IR Marker
                % disp(P2);
                Line = P1 + (P2 - P1) * t; % 3 × 2 matrix (each column is a point)
                
                
                arr_line{count} = Line;  % Store the matrix in a cell array
                
               
                % Draw the line on the plot
                plot3([P1(1), P2(1)], [P1(2), P2(2)], [P1(3), P2(3)], 'bo-', 'LineWidth', 2);
                

                % fprintf("%d: scaning", count);
                % fprintf("\n");
                
                % increment the count
                count = count + 1;

            end
        end
    end

  

    %% (F) Pause for Animation
    % pause(0.01);
    drawnow limitrate;  % Faster rendering

    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SUBFUNCTION 1: drawCircle
function h = drawCircle(cx, cy, r, filled)
    theta = linspace(0, 2*pi, 200);
    X = r*cos(theta) + cx;
    Y = r*sin(theta) + cy;
    Z = zeros(size(theta));
    if filled
        h = fill3(X, Y, Z, 'g', 'FaceAlpha', 0.3, 'EdgeColor','none');
    else
        h = plot3(X, Y, Z, 'k', 'LineWidth', 1);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SUBFUNCTION 2: drawSquare
function h = drawSquare(cx, cy, a, b, filled)
    X = [cx - a, cx + a, cx + a, cx - a];
    Y = [cy - b, cy - b, cy + b, cy + b];
    Z = [0, 0, 0, 0];
    if filled
        h = fill3(X, Y, Z, 'g', 'FaceAlpha', 0.5, 'EdgeColor','none');
    else
        h = plot3(X, Y, Z, 'k', 'LineWidth', 1);
    end
end


% 17 m turn radius
% 16 m/s speed

% Final Array
% disp(arr_line);
