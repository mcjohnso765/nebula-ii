

module wishbone_arbitrator #(
    parameter NUM_MANAGERS = 6
)(
    input logic CLK,
    input logic nRST,
    
    //input WB from multiple managers
    input logic [NUM_MANAGERS-1: 0][31:0] A_ADR_I,
    input logic [NUM_MANAGERS-1: 0][31:0] A_DAT_I,
    input logic [NUM_MANAGERS-1: 0][3:0]  A_SEL_I,
    input logic [NUM_MANAGERS-1: 0] A_WE_I,
    input logic [NUM_MANAGERS-1: 0] A_STB_I,
    input logic [NUM_MANAGERS-1: 0] A_CYC_I,

    //output WB to multiple managers
    output logic [NUM_MANAGERS-1: 0][31:0] A_DAT_O,
    output logic [NUM_MANAGERS-1: 0] A_ACK_O, 

    //input WB from single slave
    input logic [31:0] DAT_I,
    input logic ACK_I,

    //output WB to single slave
    output logic [31:0] ADR_O,
    output logic [31:0] DAT_O,
    output logic [3:0]  SEL_O,
    output logic WE_O,
    output logic STB_O,
    output logic CYC_O     
);


logic [NUM_MANAGERS: 0] curr_state;
logic [NUM_MANAGERS: 0] next_state;
//so the reason that this is NUM_MANAGERS and NOT NUM_MANAGERS-1 is simple
//for every other signal we wanted the number of wires to equal the number of managers
//for the state machine I want the number of bits to equal number of managers + 1 to include an idle state
//
// I'll do an example to help
// lets say we have 3 managers
//
// NUM_MANAGERS = 3
// IDLE means 
// curr state = [0, 0, 0, 1]
// 
// manager 1 doing a transaction means
// curr state = [0, 0, 1, 0]
//
// manager 2 doing a transaction means
// curr state = [0, 1, 0, 0]
//
// and so on etc....

always_ff @ (posedge CLK, negedge nRST) begin
    if(~nRST) begin
        curr_state <= 1;
    end
    else begin
        curr_state <= next_state;
    end
end

integer state_idx;   //idx to iterate through the states
integer req_idx;     //idx to check requests

always_comb begin
    next_state = curr_state;
    ADR_O = '0;
    DAT_O = '0;
    SEL_O = '0;
    WE_O  = '0;
    STB_O = '0;
    CYC_O = '0;
    A_DAT_O = '0;
    A_ACK_O = '0;
    
    for(state_idx = 0; state_idx <= NUM_MANAGERS; state_idx++) begin
        if(curr_state[state_idx]) begin //seeing if bit state_idx is on

            if(state_idx == 0) begin
                //we're in IDLE
                for(req_idx = 0; req_idx < NUM_MANAGERS; req_idx++) begin
                    
                    if(A_CYC_I[req_idx]) begin
                        //one of the managers is requesting something
                        next_state = 1 << (req_idx + 1);

                        //mealy setting the signals 
                        ADR_O = A_ADR_I[req_idx];
                        DAT_O = A_DAT_I[req_idx];
                        SEL_O = A_SEL_I[req_idx];
                        WE_O  = A_WE_I[req_idx];
                        STB_O = A_STB_I[req_idx];
                        CYC_O = A_CYC_I[req_idx];

                        req_idx = NUM_MANAGERS;
                    end
                end
            end
            else begin
                ADR_O = A_ADR_I[state_idx - 1];
                DAT_O = A_DAT_I[state_idx - 1];
                SEL_O = A_SEL_I[state_idx - 1];
                WE_O  = A_WE_I[state_idx - 1];
                STB_O = A_STB_I[state_idx - 1];
                CYC_O = A_CYC_I[state_idx - 1];

                A_DAT_O[state_idx - 1] = DAT_I;
                A_ACK_O[state_idx - 1] = ACK_I;

                if(ACK_I) begin
                    next_state = 1;
                end
            end
        end
    end
    
end
endmodule