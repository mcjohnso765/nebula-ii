module request_unit(
    input logic clk, rst, memread, memwrite, 
    // CPU side signals
    input logic [31:0] data_to_write, 
    // address of the variable we are trying to write data into (memory wise); computed from the ALU  
    input logic [31:0] instruction_address, data_address, 
    // instruction address should just be the program counter and the 
    // alu result is just the result from the alu we are trying to 
    input logic busy_o, 
    // wish bone
    input logic [31:0] cpu_dat_o, 
    // wishbone side signals as inputs
    output logic read_i, write_i, 
    output logic [31:0] cpu_dat_i,
    output logic [31:0] instruction,
    output logic [31:0] adr_i,
    output logic [31:0] data_read,
    output logic [3:0] sel_i,
    output logic i_hit // pc enable signal 
);

typedef enum logic [1:0] {
    IDLE, MEM_READ, MEM_WRITE, INSTRUCTION_READ
} state_t;

logic [31:0] next_adr, next_cpu_dat, next_instruction;
state_t state, next_state;
logic d_hit, next_read, next_write;
logic [31:0] next_data_read;
logic request_type, next_request_type, next_i_hit, next_d_hit; // if 1, we are requesting data from memory (like IF or DF so on and so forth so yeah)

always_ff @(posedge clk, posedge rst) begin
    if(rst) begin
        state <= IDLE;
        // TO wishbone signals
        //read_i <= 1'b0; // read request
        //write_i <= 1'b0; // write request
        adr_i <= 32'b0; // address to the wishbone
        cpu_dat_i <= 32'b0; // cpu data to wish bone
        sel_i <= 4'b0; // number of bits per transfer to wishbone
        // TO CPU 
        instruction <= 32'b0; // instruction to CPU
        data_read <= 32'b0;
        i_hit <= 1'b0; // Instruction hit
        state <= IDLE; 
        //i_request = 1'b0;
        d_hit <= 1'b0; // DATA HIT
    end else begin
        state <= next_state; 
        //read_i <= next_read;
        //write_i <= next_write;
        adr_i <= next_adr;
        cpu_dat_i <= next_cpu_dat;
        sel_i <= 4'd15;
        instruction <= next_instruction;
        d_hit <= next_d_hit;
        state <= next_state;
        i_hit <= next_i_hit;
        //i_request <= next_i_request;
    end
end

always_comb begin
    next_state = state;
    read_i = 1'b0;
    write_i = 1'b0;
    next_adr = 32'b0;
    next_cpu_dat = 32'b0;
    next_i_hit = 1'b0;
    next_d_hit = 1'b0;
    next_data_read = 32'b0;
    next_instruction = (memread || memwrite) ? instruction : 32'b0;
    case(state) 
        IDLE: begin
                if(memwrite && !d_hit) begin
                    next_state = MEM_WRITE;
                    read_i = 1'b0;
                    write_i = 1'b1;
                    next_adr = data_address;
                    next_cpu_dat = data_to_write;
                    next_instruction = instruction;
                end else if (memread && !d_hit) begin
                    next_state = MEM_READ;
                    read_i = 1'b1;
                    write_i = 1'b0;
                    next_adr = data_address;
                    next_cpu_dat = 32'b0;
                    next_instruction = instruction;
                end else if (!i_hit) begin
                    next_state = INSTRUCTION_READ;
                    read_i = 1'b1;
                    write_i = 1'b0;
                    next_adr = instruction_address;
                    //next_cpu_dat = '0;
           end 
        end
        MEM_WRITE : begin
            next_instruction = instruction;
            next_adr = adr_i;
            next_cpu_dat = cpu_dat_i;
            if(!busy_o) begin
                next_state = IDLE;
                next_d_hit = 1'b1; // registered
                next_cpu_dat = 32'b0;
                next_adr = 32'b0;
            end 
        end
        MEM_READ : begin
            next_instruction = instruction;
            next_adr = adr_i;
            //next_cpu_dat = '0;
            if(!busy_o) begin
                next_adr = 32'b0;
                next_data_read  = cpu_dat_o;
                next_state = IDLE;    
                next_d_hit = 1'b1; // registered?  
            end
        end
        INSTRUCTION_READ : begin
            //next_instruction = '0; // NOP
            next_adr = adr_i;
            //next_cpu_dat = '0;
            if(!busy_o) begin
                next_adr = 32'b0;
                next_instruction = cpu_dat_o;
                next_state = IDLE;
                next_i_hit = 1'b1;
            end
        end
    endcase
end

endmodule
