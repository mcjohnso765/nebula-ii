/*
write_i = enabling the write port for the bus
read_i = enabling the read port for the bus
adr_i = addres we are trying to access from memory
cpu_dat_i = the data we are trying to write into memory based on the address of the instruction
sel_i = just permanently set to 15 since we are always trying to get 32 bits of data
cpu_dat_o = data that was read from memory (could be instruction fetch or could be the value loaded from the memory in sram)
busy_o = the bus is busy
*/
/*
module request_unit(
    input logic clk, rst, memread, memwrite, // CPU side signals
    input logic [4:0] data_address, 
    input logic [31:0] instruction_address, alu_result, 
    input logic busy_o, // wish bone
    input logic [31:0] cpu_dat_o, // wishbone side signals as inputs
    output logic read_i, write_i, 
    output logic [31:0] cpu_dat_i,
    output logic [31:0] instruction,
    output logic [4:0] adr_i,
    output logic [31:0] data_read,
    output logic [3:0] sel_i,
    output logic i_hit // pc enable signal 
);

typedef enum logic [1:0] {
    IDLE, BUSY
} state_t;

state_t state, next_state;
logic request_type, next_request_type, next_i_hit; // if 1, we are requesting data from memory (like IF or DF so on and so forth so yeah)

always_ff @(posedge clk, negedge rst) begin
    if(!rst) begin
        read_i <= 1'b0; // read request
        write_i <= 1'b0; // write request
        adr_i <= '0; // address
        cpu_dat_i <= '0; // cpu data
        sel_i <= '0;
        instruction <= '0;
        i_hit <= 1'b0;
        state <= IDLE;
        i_request = 1'b0;
        d_hit <= 1'b0;
    end else begin
        read_i <= next_read;
        write_i <= next_write;
        adr_i <= next_adr;
        cpu_dat_i <= next_cpu_dat;
        sel_i <= 4'd15;
        instruction <= next_instruction;
        d_hit <= next_d_hit;
        i_hit <= next_i_hit;
        state <= next_state;
        i_request <= next_i_request;
    end
end

    always_comb begin
        // if we are busy, we want to retain our current values below
        next_adr = adr_i;
        next_read = read_i;
        next_write = write_i;
        next_cpu_dat = cpu_dat_i;
        next_instruction = instruction;
        next_i_hit = i_hit;
        next_d_hit = d_hit;
        next_state = state;
        next_i_request = i_request;
        case(state)
            IDLE : begin
                next_state = (!busy_o) ? BUSY : IDLE; 
                if(memread && !d_hit) begin // reading data from memory to write back

                    // settings to the wishbone interface bus

                    next_read = 1'b1; // enabling read
                    next_write = 1'b0; // disabling write
                    next_adr = alu_result; // setting the address to the address computed by the alu
                    next_request_type = 1'b0; 

                end else if (memwrite &&  !d_hit) begin // writing data into memory

                    // settings to the wishbone interface bus

                    next_read = 1'b0; // disabling read
                    next_write = 1'b1; // enabling write
                    next_adr = data_address; // address of the data we want to write into
                    next_cpu_dat = alu_result; // data we are writing into
                    next_i_request = 1'b0; // we are not requesting data

                end else begin // instruction fetching from the memory

                    // settings to the wishbone interface bus

                    next_read = 1'b1; // enabling read
                    next_write = 1'b0; // disabling write
                    next_adr = data_address; // setting the address of the instruction we are trying to fetch currently
                    next_i_request = 1'b1; // requesitng from memory
                end
            end
            
            BUSY : begin
                if(!busy_o) begin
                    next_d_hit = !i_request;
                    next_i_hit = i_request; // We only want pc counter to increment when we get an instruction fetch hit
                    // Note, we might not need to register the i_hit at all now, might need to double check the timing of this
                    next_state = IDLE;

                    if(memread) begin
                        data_read = cpu_dat_o; // data to be written back into the register                        
                    end else begin
                        next_instruction = cpu_dat_o; // The next instruction
                    end
                end
            end
        endcase
   end

endmodule
*/ 