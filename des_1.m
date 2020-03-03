%*************************************************************************%
%                                                       by CHENG JIAXIANG %
% NANYANG TECHNOLOGICAL UNIVERSITY, SINGAPORE                             %
% EE6226 - DISCRETE EVENT SYSTEM                                          %
% March 3rd, 2020                                                         %
%*************************************************************************%

clear all

%% Initialization

% Initialize the queue and state:
queue = [0 0 0 0 0 0];
current_state = 0;
next_state = 0;

% Initialize the display board:
load display
for m = 2 : 12
    for n = 2 : 5
        display{m,n} = '';
    end
end

%% Generate the simulation:
while 1
    % Receive the call from both internal and external:
    call = input("Call (0 - 15):");
    if call == -1
        break
    end % Input -1 to stop the iteration.
    
    % Use the projection table to generate the service call:
    load table1
    sig_1 = table1(call+1, current_state+1);
    if call > -1
        unser_call = call;
    end % Make a record only when the call is valid.
    
    if ~isempty(sig_1) && (unser_call < 6) && (sig_1 ~= -1)
        switch unser_call % Display valid call from internal.
            case 0
                display{12,3} = 'x';
            case 1
                display{10,3} = 'x';
            case 2
                display{8,3} = 'x';
            case 3
                display{6,3} = 'x';
            case 4
                display{4,3} = 'x';
            case 5
                display{2,3} = 'x';
            otherwise
                disp('other value')
        end
    elseif ~isempty(sig_1) && (unser_call < 11) && (sig_1 ~= -1)
        switch unser_call % Display valid UP-call from external.
            case 6
                display{12,4} = 'x';
            case 7
                display{10,4} = 'x';
            case 8
                display{8,4} = 'x';
            case 9
                display{6,4} = 'x';
            case 10
                display{4,4} = 'x';
        end
    elseif ~isempty(sig_1) && (unser_call < 16) && (sig_1 ~= -1)
        switch unser_call % Display valid DOWN-call from external.
            case 11
                display{10,5} = 'x';
            case 12
                display{8,5} = 'x';
            case 13
                display{6,5} = 'x';
            case 14
                display{4,5} = 'x';
            case 15
                display{2,5} = 'x';
            otherwise
                disp('other value')
        end
    end

    current_state = next_state;
    % Mark the unserviced call as serviced when reach the floor:
        switch current_state
        case 0
            display{12,3} = '';
            display{12,4} = '';
        case 1
            display{10,3} = '';
            display{10,4} = '';
            display{10,5} = '';
        case 2
            display{8,3} = '';
            display{8,4} = '';
            display{8,5} = '';
        case 3
            display{6,3} = '';
            display{6,4} = '';
            display{6,5} = '';
        case 4
            display{4,3} = '';
            display{4,4} = '';
            display{4,5} = '';
        case 5
            display{2,3} = '';
            display{2,5} = '';
        otherwise
            disp('other value')
    end
    % Mark the unserviced and serviced calls in queue:
    sig_S = current_state;
    for i = 0 : 5
        if sig_1 == i
            queue(1,6-i) = 1;
        end
        if sig_S == i
            queue(1,6-i) = 0;
        end
    end
    
    % Generate the queue from binary to decimal:
    queue_label = 0;
    for k = 0 : 5
        queue_label = queue_label + queue(1,k+1)*(2^(5-k));
    end
    
    % Use projection table to generate the control command:
    load table2;
    command = table2(queue_label+1, current_state+1);
    
    % Use command and transition matrix to get the next state:
    if command ~= -1
        load state_transition;
        next_state = state_transition(command+1, current_state+1);
    else
        next_state = current_state;
    end
   
    % Display the next state (current cage location):
    switch next_state
        case 0
            display{12,2} = 'x';
        case 1
            display{10,2} = 'x';
        case 2
            display{8,2} = 'x';
        case 3
            display{6,2} = 'x';
        case 4
            display{4,2} = 'x';
        case 5
            display{2,2} = 'x';
        case 6
            display{11,2} = 'x';
        case 7
            display{9,2} = 'x';
        case 8
            display{7,2} = 'x';
        case 9
            display{5,2} = 'x';
        case 10
            display{3,2} = 'x';
        case 11
            display{11,2} = 'x';
        case 12
            display{9,2} = 'x';
        case 13
            display{7,2} = 'x';
        case 14
            display{5,2} = 'x';
        case 15
            display{3,2} = 'x';
        otherwise
            disp('other value')
    end
    
    % Erase the past state (past cage location):
    switch current_state
        case 0
            display{12,2} = '';
        case 1
            display{10,2} = '';
        case 2
            display{8,2} = '';
        case 3
            display{6,2} = '';
        case 4
            display{4,2} = '';
        case 5
            display{2,2} = '';
        case 6
            display{11,2} = '';
        case 7
            display{9,2} = '';
        case 8
            display{7,2} = '';
        case 9
            display{5,2} = '';
        case 10
            display{3,2} = '';
        case 11
            display{11,2} = '';
        case 12
            display{9,2} = '';
        case 13
            display{7,2} = '';
        case 14
            display{5,2} = '';
        case 15
            display{3,2} = '';
        otherwise
            disp('other value')
    end
   
    disp(display) % Show the simulation!
    
end
