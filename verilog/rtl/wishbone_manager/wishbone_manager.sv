/**
Wishbone Bus Manager
STARS 2024
Author: Matthew Erlichson
*/

//states for the 3 state bus state machine

module wishbone_manager(
    //clock and reset of course
    input logic nRST, CLK,
    
    //input from wishbone interconnect
    input logic [31:0] DAT_I,
    input logic        ACK_I,

    //input from user design
    input logic [31:0] CPU_DAT_I,
    input logic [31:0] ADR_I,
    input logic [3:0]  SEL_I,
    input logic        WRITE_I,
    input logic        READ_I,

    //output to wishbone interconnect
    output logic [31:0] ADR_O,
    output logic [31:0] DAT_O,
    output logic [3:0]  SEL_O,
    output logic        WE_O,
    output logic        STB_O,
    output logic        CYC_O,

    //output to user design
    output logic [31:0] CPU_DAT_O,
    output logic        BUSY_O
);

typedef enum logic[1:0] {
    IDLE,
    WRITE,
    READ
 } state;


state curr_state;
state next_state;

logic [31:0] next_ADR_O;
logic [31:0] next_DAT_O;
logic [3:0]  next_SEL_O;
logic        next_WE_O;
logic        next_STB_O;
logic        next_CYC_O;

logic [31:0] next_CPU_DAT_O;
logic        next_BUSY_O;


always_ff @(posedge CLK, negedge nRST) begin : All_ffs
    if(~nRST) begin
        //state machine
        curr_state <= IDLE;

        //registers for user project outputs
        CPU_DAT_O <= '0;
        BUSY_O    <= '0;

        //signals going to interconnect
        ADR_O     <= '0;
        DAT_O     <= '0;
        SEL_O     <= '0;
        WE_O      <= '0;
        STB_O     <= '0;
        CYC_O     <= '0;
    end
    else begin
        curr_state <= next_state;

        CPU_DAT_O  <= next_CPU_DAT_O;
        BUSY_O     <= next_BUSY_O;

        ADR_O      <= next_ADR_O;
        DAT_O      <= next_DAT_O;
        SEL_O      <= next_SEL_O;
        WE_O       <= next_WE_O;
        STB_O      <= next_STB_O;
        CYC_O      <= next_CYC_O;
    end
end


always_comb begin
    next_state = curr_state;

    next_ADR_O  = ADR_O;
    next_DAT_O  = DAT_O;
    next_SEL_O  = SEL_O;
    next_WE_O   = WE_O;
    next_STB_O  = STB_O;
    next_CYC_O  = CYC_O;
    next_BUSY_O = BUSY_O;    
    
    case(curr_state)
        IDLE: begin
            if(WRITE_I && !READ_I) begin
                next_BUSY_O = 1'b1;
                next_state  = WRITE;
            end
            if(!WRITE_I && READ_I) begin
                next_BUSY_O = 1'b1;
                next_state  = READ;
            end
        end     
        WRITE: begin
            next_ADR_O  = ADR_I;
            next_DAT_O  = CPU_DAT_I;
            next_SEL_O  = SEL_I;
            next_WE_O   = 1'b1;
            next_STB_O  = 1'b1;
            next_CYC_O  = 1'b1;
            next_BUSY_O = 1'b1;

            if(ACK_I) begin
                next_state = IDLE;

                next_ADR_O  = '0;
                next_DAT_O  = '0;
                next_SEL_O  = '0;
                next_WE_O   = '0;
                next_STB_O  = '0;
                next_CYC_O  = '0;
                next_BUSY_O = '0;
            end
        end
        READ: begin
            next_ADR_O  = ADR_I;
            next_DAT_O  = '0;
            next_SEL_O  = SEL_I;
            next_WE_O   = '0;
            next_STB_O  = 1'b1;
            next_CYC_O  = 1'b1;
            next_BUSY_O = 1'b1;

            if(ACK_I) begin
                next_state = IDLE;

                next_ADR_O  = '0;
                next_DAT_O  = '0;
                next_SEL_O  = '0;
                next_WE_O   = '0;
                next_STB_O  = '0;
                next_CYC_O  = '0;
                next_BUSY_O = '0;
            end
        end
        default: next_state = curr_state;
    endcase
end



logic prev_BUSY_O;
logic BUSY_O_edge;

always_ff @(posedge CLK, negedge nRST) begin : BUSY_O_edge_detector
    if(!nRST) begin
        prev_BUSY_O <= '0;
    end
    else begin
        prev_BUSY_O <= BUSY_O;
    end
end

//detects the falling edge of BUSY_O to indicate the end of a transaction
assign BUSY_O_edge = (!BUSY_O && prev_BUSY_O);

//this always comb is for the logic to latch the data input on a read transaction
always_comb begin
    next_CPU_DAT_O = 32'hBAD1BAD1;

    if((curr_state == READ) && ACK_I) begin
        next_CPU_DAT_O = DAT_I;
    end
    else if(BUSY_O_edge) begin
        next_CPU_DAT_O = CPU_DAT_O;
    end
end
endmodule