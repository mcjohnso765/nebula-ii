module t10_game_logic (
    input logic clk, nRst, gameEnd,
    input logic [7:0] guess,
    input logic [39:0] setWord,
    input logic toggle_state,
    output logic [7:0] letter,
    output logic red, green, mistake, game_rdy,
    output logic [2:0] incorrect, correct,
    output logic [4:0] indexCorrect
);
    typedef enum logic [3:0] { 
        SET = 0, L0 = 1, L1 = 2, L2 = 3, L3 = 4, L4 = 5, STOP = 6, IDLE = 7, FIRST = 8
    } state_t;

    logic [7:0] placehold;
    state_t nextState, state;
    logic [2:0] correctCount, mistakeCount;
    logic [4:0] nextIndexCorrect;
    logic [2:0] rights, nRight;
    logic tempRed, tempGreen;
    logic pulse;

    always_ff @(posedge clk, negedge nRst) begin
        if(~nRst) begin
            state <= SET;
            incorrect <= 0;
            correct <= 0;
            indexCorrect <= 0;
            letter <= 0;
            rights <= 0;
            red <= 0;
            green <= 0;
        end else begin
            state <= nextState;
            incorrect <= mistakeCount;
            correct <= correctCount;
            indexCorrect <= nextIndexCorrect;
            letter <= placehold;
            rights <= nRight;
            red <= tempRed;
            green <= tempGreen;
        end
    end

    always_comb begin
        nextState = state;
        correctCount = correct; //for latch
        mistakeCount = incorrect; //for latch
        nextIndexCorrect = indexCorrect; //for latch
        nRight = rights; //for latch
        tempRed = red;//for latch 
        tempGreen = green;//for latch
        placehold = letter;//for latch

        mistake = 0;
        game_rdy = 0;
        pulse = 0;

        case(state)
            SET: begin
                tempRed = 0;
                tempGreen = 0;
                nRight = 0;
                correctCount = 0;
                mistakeCount = 0;
                //flip flop will set the word using a shift register
                nextIndexCorrect = 0;
                if(toggle_state) begin
                    nextState = FIRST;
                end else
                    nextState = SET;
            end
            FIRST: begin
                game_rdy = 1;
                if(guess != 0)begin
                    placehold = guess;
                    nextState = L0;
                end else begin
                    nextState = FIRST;
                end               
            end
            L0: begin
                game_rdy = 0;
                if(letter == setWord[39:32] & indexCorrect[4] != 1)begin
                    nextIndexCorrect[4] = 1;
                    nRight = nRight + 1;
                end 

                nextState = L1;
            end
            L1: begin
                game_rdy = 0;
                if(letter == setWord[31:24] & indexCorrect[3] != 1)begin
                    nextIndexCorrect[3] = 1;
                    nRight = nRight + 1;
                end 

                nextState = L2;
            end
            L2: begin
                game_rdy = 0;
                if(letter == setWord[23:16] & indexCorrect[2] != 1)begin
                    nextIndexCorrect[2] = 1;
                    nRight = nRight + 1;
                end 

                nextState = L3;
            end
            L3: begin
                game_rdy = 0;
                if(letter == setWord[15:8] & indexCorrect[1] != 1)begin
                    nextIndexCorrect[1] = 1;
                    nRight = nRight + 1;
                end 

                nextState = L4;
            end
            L4: begin
                game_rdy = 0;
                if(letter == setWord[7:0] & indexCorrect[0] != 1)begin
                    nextIndexCorrect[0] = 1;
                    nRight = nRight + 1;
                end 

                nextState = STOP;
            end
            STOP: begin
                if(correct <= 4 & incorrect <= 5) begin
                if(rights > 0) begin
                    mistake = 0;
                    correctCount = correctCount + rights;
                end 
                else begin
                    mistake = 1;
                    mistakeCount = mistakeCount + 1;
                end
                end
                game_rdy = 1;
                nextState = IDLE;
            end
            IDLE: begin
                nRight = 0;
                game_rdy = 1;
                if(guess != 0)begin
                    placehold = guess;
                    pulse = 1;
                end else begin
                    placehold = letter;
                    pulse = 0;
                end
            if(correct == 5 | incorrect == 6) begin
                if(correct == 5) begin
                    tempGreen = 1;
                    tempRed = 0;
                    //LCD DISPLAY WIN
                end else if(incorrect == 6) begin
                    tempGreen = 0;
                    tempRed = 1;
                    //LCD DISPLAY FAIL
                end
            end
                if(gameEnd) begin
                    tempGreen = 0;
                    tempRed = 0;
                    correctCount = 0;
                    mistakeCount = 0;
                    nextIndexCorrect = 0;
                    placehold = 0;
                    nRight = 0;
                    nextState = SET;
                end
                else if((pulse) & !(correct == 5 | incorrect == 6)) begin
                    nextState = L0;
                end else begin
                    nextState = IDLE;
                end
            end
            default: begin
                game_rdy = 0;
                nextState = SET;
                correctCount = 0;
                mistakeCount = 0;
            end
        endcase
    end
endmodule
