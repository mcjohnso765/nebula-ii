
/////////////////////////////////
//     Integrate with VGA to see if we need to make the push count 63 instead of 62


module VGA_data_controller (
    input logic clk, nrst,
    input logic [31:0] VGA_request_address, data_from_SRAM,
    input logic [9:0] h_count,
    input logic [1:0] VGA_state,
    input logic data_en, // Can be used for the read 
    input logic [3:0] byte_select_in, // directly tied to the data_en output
    output logic [3:0] byte_select_out, // directly tied to the data_en output
    output logic read,
    output logic [31:0] data_to_VGA, SRAM_address
);
    // logic [31:0] data_hold;
    // logic data_send_enable;

    // assign data_send_enable = &h_count[5:0];

    assign byte_select_out = byte_select_in;
    assign read = data_en;

    typedef enum logic [1:0] {
        IDLE,
        PREPARE_DATA,
        LOAD_NEW_REGISTER
    } state_type;

    state_type state;

    always_ff @(posedge clk or negedge nrst) begin
        if (~nrst) begin
            state <= IDLE;
            data_to_VGA <= data_from_SRAM;
        end else begin
            case (state)
                IDLE: begin
                    data_to_VGA <= data_from_SRAM;
                    state <= LOAD_NEW_REGISTER;
                end

                LOAD_NEW_REGISTER: begin
                    data_to_VGA <= data_from_SRAM;
                    SRAM_address <= SRAM_address;
                    state <= PREPARE_DATA;
                end

                PREPARE_DATA: begin
                    if (VGA_state == 1) begin // preparing first word 
                      //SRAM_address <= 32'h3E80; // base of SRAM storage
                        SRAM_address <= 32'h0; // TESTBENCH CASE
                        data_to_VGA <= data_from_SRAM;
                        state <= LOAD_NEW_REGISTER;
                    end
                    
                    else if (h_count[5:0] == 63) begin
                        state <= LOAD_NEW_REGISTER;
                    end else begin
                        SRAM_address <= VGA_request_address + 1; // preparing next word 
                        data_to_VGA <= data_to_VGA;
                        state <= PREPARE_DATA;
                    end

                end

                default: state <= IDLE;
            endcase
        end
    end






endmodule
