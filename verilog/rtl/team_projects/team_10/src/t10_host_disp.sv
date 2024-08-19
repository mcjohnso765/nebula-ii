module t10_host_disp (
    input logic clk, nRst,
    input logic [4:0] indexCorrect,
    input logic [7:0] letter, setLetter,
    input logic [2:0] incorrect, correct,
    input logic [39:0] temp_word,
    input logic toggle_state,
    input logic mistake,
    input logic gameEnd_host, 
    output logic [127:0] top, bottom
);
    logic [127:0] nextTop;
    logic [127:0] nextBottom;
    logic [47:0] next_curr_guesses;
    logic [23:0] win = {8'b01010111, 8'b01101001, 8'b01101110};  // Win in ASCII MAKE IT BINARY
    logic [31:0] lose = {8'b01001100, 8'b01101111, 8'b01110011, 8'b01100101}; // Lose in ASCII MAKE IT BINARY
    logic [39:0] curr_word, next_curr_word; // _ _ _ _ _ in ASCII
    logic [47:0] curr_guesses; // _ _ _ _ _ _ in ASCII
    logic [39:0] space5 = {8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000};
    logic [7:0] space1 = 8'b00100000;

    typedef enum logic { 
        SET = 1'b0, COMPARE = 1'b1
    } casestate;
    casestate Cstate, next_state;


always_ff @(posedge clk, negedge nRst) begin
    if(~nRst) begin
        top <= 0;
        bottom <= 0;
        Cstate <= SET;

        curr_guesses <= {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111};
        curr_word <= {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111};
    end else begin
        top <= nextTop;
        bottom <= nextBottom;
        curr_guesses <= next_curr_guesses;
        curr_word <= next_curr_word;
        Cstate <= next_state;
    end
end

always_comb begin
next_curr_guesses = curr_guesses;
next_curr_word = curr_word;
next_state = Cstate;
nextTop = top;
nextBottom = bottom;

if(gameEnd_host) begin
    next_curr_word = {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ _ _ _ _ in ASCII
    next_curr_guesses = {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ _ _ _ _ _ in ASCII
    nextTop = {space5, space1, space5, space5}; // split evenly by 8
    nextBottom = {space5, space5, space1, space5}; // split evenly by 8
    next_state = SET;
end

    case (Cstate)
        SET: begin
            nextTop = {space5, space1, space1, space1, setLetter, space5, space1, space1};
            nextBottom = {space5, temp_word, space1, space5};

            if (toggle_state)
                next_state = COMPARE;
        end
        COMPARE: begin
        case(mistake)
            0: begin
                    if(correct == 5) begin
                        nextTop = {space5, space1, space1, win, space5, space1}; // split evenly by 8
                        nextBottom = {space5, space1, temp_word, space5}; // split evenly by 8
                    end else begin
                        if(indexCorrect[4] & next_curr_word[39:32] == 8'b01011111) begin
                        next_curr_word[39:32] = letter;
                        end               
                        if(indexCorrect[3] & next_curr_word[31:24] == 8'b01011111) begin
                        next_curr_word[31:24] = letter;
                        end
                        if(indexCorrect[2] & next_curr_word[23:16] == 8'b01011111) begin
                        next_curr_word[23:16] = letter;
                        end
                        if(indexCorrect[1] & next_curr_word[15:8] == 8'b01011111) begin
                        next_curr_word[15:8] = letter;
                        end
                        if(indexCorrect[0] & next_curr_word[7:0] == 8'b01011111) begin
                        next_curr_word[7:0] = letter;
                        end

                        nextTop = {space5, space1, curr_word, space5}; // split evenly by 8
                        nextBottom = {space5, curr_guesses, space5};
                    end
                if(incorrect == 6) begin
                    nextTop = {space5, space1, lose, space5, space1}; // split evenly by 8
                    nextBottom = {space5, space1, temp_word, space5}; // split evenly by 8
                end
            end 
            1: begin
                if(incorrect == 6) begin
                    nextTop = {space5, space1, lose, space5, space1}; // split evenly by 8
                    nextBottom = {space5, space1, temp_word, space5}; // split evenly by 8
                end else begin
                    next_curr_guesses = {letter, curr_guesses[47:8]};//bottom row in position bit index becomes the guess letter
                    nextBottom = {space5, curr_guesses, space5}; // split evenly by 8
                end
            end
            default: begin
                next_curr_word = {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ _ _ _ _ in ASCII
                next_curr_guesses = {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ _ _ _ _ _ in ASCII
                nextTop = {space5, space1, curr_word, space5}; // split evenly by 8
                nextBottom = {space5, curr_guesses, space5}; // split evenly by 8
            end 
        endcase
        end
    endcase
end
endmodule
