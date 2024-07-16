/* Game Logic File
Descriuption: Controls the states of the game where the host can confirm the word.
Then the next state compares the user input with the different letters in the word.
Finally, once the user either guesses the word, or gets 6 wrong questions, the game
ends. 
*/

module game_logic_tb ();

typedef enum logic [2:0] { 
    SET = 0, L0 = 1, 
    L1 = 2, L2 = 3, 
    L3 = 4, L4 = 5, 
    STOP = 6, IDLE = 7
} state_t;

//Testbench parameters
localparam CLK_PERIOD = 10; //100 hz clk
logic tb_checking_outputs;
integer tb_test_num;
string tb_test_case;

//DUT ports
logic tb_clk, tb_nRst;
logic [7:0] tb_guess;
logic [39:0] tb_setWord;
logic tb_toggle_state, tb_gameEnd;
logic [7:0] tb_letter;
logic tb_red, tb_green, tb_mistake, tb_red_busy, tb_game_rdy;
logic [2:0] tb_incorrect, tb_correct;
logic [4:0] tb_indexCorrect;


//Reset DUT Task
task reset_dut;
    @(negedge tb_clk);
    tb_nRst = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
endtask

//task that presses the button once
task single_button_press;
begin
    @(negedge tb_clk);
    tb_toggle_state = 1'b1;
    @(negedge tb_clk);
    tb_toggle_state = 1'b0;
    @(posedge tb_clk);
end
endtask

//task to check mistake output
task check_mistake;
input logic[2:0] expected_mistakes;
input string string_mistakes;
begin
    @(negedge tb_clk);
    tb_checking_outputs = 1'b1;
    if(tb_incorrect == expected_mistakes)
        $info("Correct Mistakes: %s.", string_mistakes);
    else
        $error("Incorrect Mistakes. Expected: %s. Actual: %s.", string_mistakes, tb_incorrect);
end
endtask

//task to check correct output
task check_correct;
input logic[2:0] expected_correct;
input string string_correct;
begin
    @(negedge tb_clk);
    tb_checking_outputs = 1'b1;
    if(tb_correct == expected_correct)
        $info("Correct guess: %s.", string_correct);
    else
        $error("Incorrect Correct value. Expected: %s. Actual: %s.", string_correct, tb_correct);
end
endtask

//task to check if the letter guess changed
task guess_change;
input logic[7:0] expected_guess;
input string string_guess;
begin
    @(negedge tb_clk);
    tb_checking_outputs = 1'b1;
    if(tb_guess == expected_guess)
        $info("Guess Changed!: %s.", string_guess);
    else
        $error("Guess has not changed. Expected: %s. Actual: %s.", string_guess, tb_guess);
end
endtask

always begin
    tb_clk = 1'b0;
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1;
    #(CLK_PERIOD / 2.0);
end

//DUT Portmap
Game_logic DUT(.clk(tb_clk),
            .nRst(tb_nRst),
            .gameEnd(tb_gameEnd),
            .guess(tb_guess),
            .setWord(tb_setWord),
            .toggle_state(tb_toggle_state),
            .letter(tb_letter),
            .red(tb_red), .green(tb_green),
            .mistake(tb_mistake), .red_busy(tb_red_busy),
            .game_rdy(tb_game_rdy), .incorrect(tb_incorrect),
            .correct(tb_correct), .indexCorrect(tb_indexCorrect));

//Main test bench process
initial begin
    //Signal dump
    $dumpfile("dump.vcd");
    $dumpvars;

    //initialize test bench signals
    tb_toggle_state = 1'b0;
    tb_nRst = 1'b1;
    tb_checking_outputs = 1'b0;
    tb_test_num = -1;
    tb_test_case = "Initializing";
    $display("/n/n%s", tb_test_case);

    //Wait some time before starting first test case
    #(0.1);

    //****************************************************
    //Test Case 0: Power-on-Reset of the DUT
    //****************************************************
    tb_test_num += 1;
    tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
    $display("/n/n%s", tb_test_case);

    tb_toggle_state = 1'b1;
    tb_nRst = 1'b0;

    #(2);
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;

    tb_toggle_state = 1'b0;

    //****************************************************
    //Test Case 1: Testing incorrect guesses and loss
    //****************************************************
    tb_test_num += 1;
    reset_dut();
    tb_test_case = "Test Case 1: Testing incorrect guesses";
    $display("/n/n%s", tb_test_case);

    tb_setWord = 40'b0100000101010000010100000100110001000101; //Word: APPLE
    tb_guess = 8'b01000011; //Guess: "C"

    single_button_press();
    #(CLK_PERIOD * 10);
    check_mistake(1, "1");

    tb_guess = 8'b01001010; //Guess: "J"
    #(CLK_PERIOD * 25);

    check_mistake(2, "2");

    tb_guess = 8'b01010001; //Guess: "Q"
    #(CLK_PERIOD * 25);

    check_mistake(3, "3");

    tb_guess = 8'b01010010; //Guess: "R"
    #(CLK_PERIOD * 25);

    check_mistake(4, "4");

    tb_guess = 8'b01001011; //Guess: "K"
    #(CLK_PERIOD * 25);

    check_mistake(5, "5");

    tb_guess = 8'b01001101; //Guess: "M"
    #(CLK_PERIOD * 25);

    check_mistake(6, "6");

    check_correct(0, "0");

    //****************************************************
    //Test Case 2: Testing correct guesses and win
    //****************************************************
    tb_test_num += 1;
    reset_dut();
    tb_test_case = "Test Case 2: Testing correct guesses";
    $display("/n/n%s", tb_test_case);

    tb_setWord = 40'b0100000101010000010100000100110001000101; //Word: APPLE
    tb_guess = 8'b01000001; //Guess: "A"

    single_button_press();
    #(CLK_PERIOD * 25);

    check_correct(1, "1");

    tb_guess = 8'b01010000; //Guess: "P"
    #(CLK_PERIOD * 25);

    check_correct(3, "3");

    tb_guess = 8'b01001100; //Guess: "L"
    #(CLK_PERIOD * 25);

    check_correct(4, "4");

    tb_guess = 8'b01000101; //Guess: "E"
    #(CLK_PERIOD * 25);

    check_correct(5, "5");

    check_mistake(0, "0");

    //****************************************************
    //Test Case 3: Testing Guess Change and correct/incorrect
    //****************************************************
    tb_test_num += 1;
    reset_dut();
    tb_test_case = "Test Case 3: Testing Guess Change with incorrect/correct answers";
    $display("/n/n%s", tb_test_case);

    tb_setWord = 40'b0100110101001111010011110101001001000101; //Word: MOORE
    tb_guess = 8'b01001101; //Guess: "M"

    single_button_press();
    #(CLK_PERIOD * 25);

    check_correct(1, "1");

    tb_guess = 8'b01000001; //Guess: "A"
    #(CLK_PERIOD * 25);

    check_mistake(1,"1");

    $finish;
end

endmodule