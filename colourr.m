global key;
InitKeyboard();
brick.SetColorMode(2,2);

while 1
  pause(0.1);
  color = brick.ColorCode(2);%color sensor in the second port.
  display(color);
    
    if (color==2 || color==3 || color==4 || color==7) %for colors green yellow(4,7) and blue..
        disp("Switching to Manual Mode")
        
            brick.StopMotor('AB')
            pause (0.1)
            switch key 
            case 'uparrow' 
            brick.MoveMotor ('AB',-25);%moves forward.
            case 'leftarrow'
            brick. MoveMotor ( 'A', 40); %moves left.
            brick. MoveMotor ('B', -40);
            case 'rightarrow'
            brick.MoveMotor ('B',35);%moves right.
            brick. MoveMotor ('A', -35);
            case 'downarrow'
            brick. MoveMotor ( 'AB',25);%moves backward.
            case 'w'
            brick.MoveMotor('C',20) %lifts up the wheel chair.
            pause(0.9)
            brick.StopMotor('C')
            case 's'
            brick.MoveMotor('C',-20) %downs the wheel chair.
            pause(0.9)
            brick.StopMotor('C')
            case 'b'
            brick.StopMotor('AB');%motors get stopped.
            case 'e'
            brick.StopMotor('AB');%close the program.
            CloseKeyboard();
            break;
                case 'k'
                InitKeyboard(); %close keyboard.

    
            end
    end

    if color==5 % color red detection.
        disp("red light, applying breakss; hold tight")
        brick. MoveMotor ('AB', 0); %stops motors.
        pause(4);
        brick. MoveMotor ('AB', -50) %gives small velocity.
        pause(1)
        
    end

    if (color==1) %black colour detection.
        disp("changing to autonomus");
        brick.StopMotor('AB');
        dis = brick.UltrasonicDist(3);
        tt = brick.TouchPressed(1);
   
         
        if(dis<=65 && tt==0) %if front is empty and parallel to the left wall
            brick.MoveMotor ('AB',-70); %moves forward.
            
        end

        if(dis<=65 && tt==1) %if front is blocked and parallel to left wall
                    brick.MoveMotor('A', 50); %moves a little bit backward to provide the space to rotate the car.
                    brick.MoveMotor('B', 50);
                    pause(1);

                    brick.MoveMotor ('B',100);%moves right.
                    brick. MoveMotor ('A', -100);
                    pause(2.3);
                    brick.StopMotor('AB');
        end
         
        
        if(dis>65 && tt==1) %if front is blocked and non paralellel to wall
                    brick.MoveMotor('A', 50);%moves a little bit backward to provide the space to rotate the car.
                    brick.MoveMotor('B', 50);
                    pause(1);
                    
                    brick.MoveMotor ('B',-100);%moves left
                    brick. MoveMotor ('A', 100);
                    pause(2.2);
                    brick.StopMotor('AB');
                    
                    brick.MoveMotor('AB', -50); % moves front a bit to avoid double rotation.
                    pause(2); 
                    brick.StopMotor('AB');

                    
         end
         if(dis>65 && tt==0) %if front is open and non paralellel to wall
            
                    brick.MoveMotor ('B',-100);%moves left
                    brick. MoveMotor ('A', 100);
                    pause(2.2);

                    brick.MoveMotor('AB', -50);%moves a little bit backward to provide the space to rotate the car.
                    pause(2);
                  
                    
        end

           
 

    end


end