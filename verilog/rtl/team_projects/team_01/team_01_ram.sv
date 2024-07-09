// DONE

module ram (
    input logic clk, nRST,
    // From Request Unit
    input logic         read_i, write_i,
    input logic [31:0]  cpu_dat_i,
    input logic [11:0]  adr_i,
    input logic [3:0]   sel_i,
    // To Request Unit
    output logic [31:0] cpu_dat_o,
    output logic        busy_o
);
    // Memory [Adjusted to FPGA's size]
    reg [31:0] memory [4095:0];
    initial begin
        $readmemh("fill.txt", memory);
    end
    // RAM states
    typedef enum logic [1:0] {IDLE, READ, WRITE} StateType;
    StateType state, next_state;
    // Busy_o signals
    logic prev_busy_o, next_busy_o;
    // Falling Edge of Busy_o
    logic edge_det;
    // Acknowledge Signals indicating transaction complete
    logic read_ack, write_ack;
    // Data going in and out
    logic [31:0] next_cpu_dat_o, next_dat_o, data_i, dat_o;
    // Address for indexing through memory
    logic [11:0] adr, next_adr;
    // Read and Write Enable Signals
    logic next_read_enable, read_en;
    logic next_write_enable, write_en;

    // Stores last busy_o value
    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            prev_busy_o <= 1'b0;
        end else begin
            prev_busy_o <= busy_o;
        end
    end

    // Falling edge detection
    assign edge_det = (!busy_o && prev_busy_o);

    // Assigns Data to be sent
    always_comb begin
        next_cpu_dat_o = 32'hBAD1BAD1;
        if ((state == READ) && read_ack) begin
            next_cpu_dat_o = data_i;
        end else if (edge_det) begin
            next_cpu_dat_o = cpu_dat_o;
        end
    end

    // All next combinational logic
    always_comb begin
        next_state          = state;
        next_busy_o         = busy_o;
        next_adr            = adr;
        next_dat_o          = dat_o;
        next_read_enable    = read_en;
        next_write_enable   = write_en;
        case (state)
            IDLE: begin
                // Write Request
                if (write_i && !read_i) begin
                    next_busy_o     = 1'b1;
                    next_state      = WRITE;
                end
                // Read Request
                if (read_i && !write_i) begin
                    next_busy_o     = 1'b1;
                    next_state      = READ;
                end 
            end 
            READ: begin
                // Keep trying to read until acknowledged
                next_read_enable        = 1'b1;
                next_adr                = adr_i;
                next_dat_o              = 32'b0;
                next_busy_o             = 1'b1;
                if (read_ack) begin
                    next_read_enable    = 1'b0;
                    next_adr            = 12'b0;
                    next_busy_o         = 1'b0;
                    next_state          = IDLE;
                end 
            end
            WRITE: begin
                // Keep trying to write until acknowledged
                next_write_enable       = 1'b1;
                next_adr                = adr_i;
                next_dat_o              = cpu_dat_i;
                next_busy_o             = 1'b1;
                if (write_ack) begin
                    next_write_enable   = 1'b0;
                    next_adr            = 12'b0;
                    next_dat_o          = 32'b0;
                    next_busy_o         = 1'b0;
                    next_state          = IDLE;
                end
            end
            default: next_state = state;
        endcase
    end

    // All flip flops
    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            state       <= IDLE;
            
            busy_o      <= 1'b0;
            cpu_dat_o   <= 32'b0;

            dat_o       <= 32'b0;
            write_en    <= 1'b0;
            read_en     <= 1'b0;
            adr         <= 12'b0;
        end else begin
            state       <= next_state;

            busy_o      <= next_busy_o;
            cpu_dat_o   <= next_cpu_dat_o;

            dat_o       <= next_dat_o;
            write_en    <= next_write_enable;
            read_en     <= next_read_enable;
            adr         <= next_adr;
        end
    end

    // Write Transaction
    always @(posedge clk) begin
        if (write_en) begin
            memory[adr] <= dat_o;
            write_ack   <= 1'b1;
        end else begin
            write_ack   <= 1'b0;
        end
    end

    // Read Transaction
    always @(posedge clk) begin
        if (read_en) begin
            read_ack    <= 1'b1;
            data_i      <= memory[adr];
        end else begin
            read_ack    <= 1'b0;
            data_i      <= 32'b0;
        end
    end

endmodule