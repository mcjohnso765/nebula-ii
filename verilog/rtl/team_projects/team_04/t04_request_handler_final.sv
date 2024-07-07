typedef enum logic [1:0] {
    INACTIVE = 2'd0,
    READY = 2'd1,
    ACTIVE = 2'd2
} VGA_state_t;

typedef enum logic [1:0] {
    VGA = 2'd0,
    CPU_INSTR = 2'd2,
    CPU_DATA = 2'd3
} client_t;

module t04_request_handler_final #(parameter UART_ADDRESS = 500)(
    input logic clk,
    input logic nRst,

    //signals for controlling inputs/outputs
    input logic mem_busy,
    input VGA_state_t VGA_state,
    output logic CPU_enable,
    output logic VGA_enable,

    //signals to/from VGA
    input logic VGA_read,
    input logic [31:0] VGA_adr,
    output logic [31:0] data_to_VGA,

    //signals to/from UART
    input logic [31:0] data_from_UART,

    //signals to/from CPU
    input logic [31:0] CPU_instr_adr,
    input logic [31:0] CPU_data_adr,
    input logic CPU_read,
    input logic CPU_write,
    input logic [31:0] data_from_CPU,
    input logic [3:0] CPU_sel,
    output logic [31:0] instr_data_to_CPU,
    output logic [31:0] data_to_CPU,

    //signals to/from memory/Wishbone
    input logic [31:0] data_from_mem,
    output logic mem_read,
    output logic mem_write,
    output logic [31:0] adr_to_mem,
    output logic [31:0] data_to_mem,
    output logic [3:0] sel_to_mem

);
    // handler_state_t handler_state, next_handler_state;
    client_t current_client, next_client, current_client_next, next_client_next;
    logic [31:0] instruction, next_instruction;
    always_ff @( posedge clk, negedge nRst ) begin
        if(~nRst) begin
            // handler_state <= WAITING;

            current_client <= VGA;
            next_client <= VGA;

            instruction <= 32'b0;
        end else begin
            // handler_state <= next_handler_state;

            current_client <= current_client_next;
            next_client <= next_client_next;

            instruction <= next_instruction;
        end
    end

    always_comb begin
        current_client_next = next_client;
        if (mem_busy) begin
            next_client_next = next_client;
        end else begin
            if (next_client == VGA) begin
                if (VGA_state == ACTIVE | VGA_state == READY) begin
                    next_client_next = VGA;
                end else begin
                    next_client_next = CPU_INSTR;
                end
            end else if (next_client == CPU_INSTR) begin
                next_client_next = CPU_DATA;
            end else begin //current_client == CPU_DATA
                if (VGA_state == INACTIVE) begin
                    next_client_next = CPU_INSTR;
                end else begin
                    next_client_next = VGA;
                end
            end
        end


        //logic for sending data to mem
        if (mem_busy) begin
            mem_read =      1'b0;
            mem_write =     1'b0;
            adr_to_mem =    32'b0;
            data_to_mem =   32'b0;
            sel_to_mem =    4'b0;
        end else begin
            if (next_client == VGA) begin
                mem_read =      VGA_read;
                mem_write =     1'b0;
                adr_to_mem =    VGA_adr;
                data_to_mem =   32'b0;
                sel_to_mem =    4'b1111;
            end else if (next_client == CPU_INSTR) begin
                mem_read =      1'b1;
                mem_write =     1'b0;
                adr_to_mem =    CPU_instr_adr;
                data_to_mem =   32'b0;
                sel_to_mem =    4'b1111;
            end else begin // next_client == CPU_DATA
                if (CPU_data_adr == UART_ADDRESS) begin
                    mem_read =      1'b0;
                    mem_write =     1'b0;
                    adr_to_mem =    32'h0;
                    data_to_mem =   32'h0;
                    sel_to_mem =    4'b0;
                end else begin
                    mem_read =      CPU_read;
                    mem_write =     CPU_write;
                    adr_to_mem =    CPU_data_adr;
                    data_to_mem =   data_from_CPU;
                    sel_to_mem =    CPU_sel;
                end
            end    
        end
        
        

        //logic for sending data to other parts (VGA,CPU)
        instr_data_to_CPU = instruction;
        if (mem_busy) begin
            data_to_VGA =       32'b0;
            next_instruction =  instruction;
            data_to_CPU =       32'b0;
        end else begin
            if (current_client == VGA) begin
                data_to_VGA =       data_from_mem;
                next_instruction =  32'b0;
                data_to_CPU =       32'b0;
            end else if (current_client == CPU_INSTR) begin
                data_to_VGA =       32'b0;
                next_instruction =  data_from_mem;
                data_to_CPU =       32'b0;
            end else begin // current_client == CPU_DATA
                data_to_VGA =       32'b0;
                next_instruction =  instruction;
                if (CPU_data_adr == UART_ADDRESS) begin
                    data_to_CPU = data_from_UART;
                end else begin
                    data_to_CPU = data_from_mem;
                end
            end    
        end


        //logic for controlling enable signals
        if(~mem_busy & current_client == CPU_DATA) begin
            CPU_enable = 1'b1;
        end else begin
            CPU_enable = 1'b0;
        end
        if(~mem_busy & current_client == VGA) begin
            VGA_enable = 1'b1;
        end else begin
            VGA_enable = 1'b0;
        end
        
    end



endmodule