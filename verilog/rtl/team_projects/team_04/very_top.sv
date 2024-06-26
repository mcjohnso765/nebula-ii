module CPU_request_unit (
    input logic clk, nRST,
    
    // From Bus 
    input logic busy_o,
    input logic [31:0] cpu_dat_o,
    // From CPU
    input logic MemRead,            // = MemRead    from data memory
    input logic MemWrite,           // = MemWrite   from data memory
    input logic [3:0] sel_from_CPU,        
    input logic [31:0] address_DM,  // = address    from data memory
    input logic [31:0] address_IM,  // = address    from instruction memory
    input logic [31:0] data_DM,     // = write data from data memory
    // To Bus
    output logic write_i,
    output logic read_i,
    output logic [3:0] sel_i,
    output logic [31:0] adr_i,
    output logic [31:0] cpu_dat_i,
    // To CPU
    output logic enable,        // = enable         to Program Counter
    output logic [31:0] instr,  // = Instruction    to Instruction Memory
    output logic [31:0] data    // = Read Data      to Data Memory
);
    typedef enum logic {IDLE, BUSY} StateType;

    StateType state, next_state;
    logic next_write_i, next_read_i, rtype, next_rtype, next_enable, dhit, next_dhit;
    logic [31:0] next_adr_i, next_cpu_dat_i, next_instr, next_data;
    logic [3:0] next_sel_i;

    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            instr       <= 32'b0;
            data        <= 32'b0;
            write_i     <= 1'b0;
            read_i      <= 1'b0;
            sel_i       <= 4'b0;
            adr_i       <= 32'b0;
            cpu_dat_i   <= 32'b0; 
            state       <= IDLE;
            rtype       <= 1'b0;
            enable      <= 1'b0;
            dhit        <= 1'b0;
        end else begin
            instr       <= next_instr;
            data        <= next_data;
            write_i     <= next_write_i;
            read_i      <= next_read_i;
            sel_i       <= next_sel_i;
            adr_i       <= next_adr_i;
            cpu_dat_i   <= next_cpu_dat_i;
            state       <= next_state;
            rtype       <= next_rtype;
            enable      <= next_enable;
            dhit        <= next_dhit;
        end
    end

    always_comb begin
        next_dhit       = dhit;
        next_enable     = 1'b0;
        next_instr      = instr;
        next_data       = data;
        next_read_i     = read_i;
        next_write_i    = write_i;
        next_adr_i      = adr_i;
        next_sel_i      = sel_i;
        next_cpu_dat_i  = cpu_dat_i;
        next_state      = state;
        next_rtype      = rtype;
        case (state)
            IDLE: begin
                next_state      = BUSY;
                if (MemRead && !dhit) begin
                    next_read_i     = 1'b1; 
                    next_write_i    = 1'b0;
                    next_adr_i      = address_DM;
                    next_sel_i      = sel_from_CPU;
                    next_rtype      = 1'b1;              
                end else if (MemWrite && !dhit) begin
                    next_read_i     = 1'b0;
                    next_write_i    = 1'b1;
                    next_adr_i      = address_DM;
                    next_sel_i      = sel_from_CPU;
                    next_cpu_dat_i  = data_DM;
                    next_rtype      = 1'b1;          
                end else begin
                    next_read_i     = 1'b1;
                    next_write_i    = 1'b0;
                    next_adr_i      = address_IM;
                    next_sel_i      = 4'b1111;
                    next_rtype      = 1'b0;
                    next_dhit       = 1'b0;          
                end
            end
            BUSY: begin
                if (!busy_o) begin
                    next_enable     = rtype == 1'b0;
                    next_dhit       = rtype == 1'b1;
                    next_read_i     = 1'b0;
                    next_write_i    = 1'b0;
                    next_sel_i      = 4'b0;
                    next_adr_i      = 32'b0;
                    next_cpu_dat_i  = 32'b0;
                    next_rtype      = 0;
                    next_state      = IDLE;
                end else begin
                    if (rtype == 0) begin
                        next_instr  = cpu_dat_o;
                        next_data   = 32'b0;
                    end else begin
                        next_instr  = 32'b0;
                        next_data   = cpu_dat_o;
                    end
                end
            end 
            default: begin
                next_dhit       = dhit;
                next_enable     = 1'b0;
                next_instr      = instr;
                next_data       = data;
                next_read_i     = read_i;
                next_write_i    = write_i;
                next_sel_i      = sel_i;
                next_adr_i      = adr_i;
                next_cpu_dat_i  = cpu_dat_i;
                next_state      = state;
            end
        endcase
    end
endmodule


typedef enum logic [1:0] {
  NONE = 2'd0,
  CPU = 2'd1,
  VGA = 2'd2,
  UART = 2'd3
} current_client_t;

typedef enum logic [1:0] {
  INACTIVE = 2'b0,
  READY = 2'b1,
  ACTIVE = 2'b10
} VGA_state_t;

module request_handler (
  input logic nRst, clk,

  //signals for determining data flow control
  input VGA_state_t VGA_state, //0 = inactive, 1 = about to be active, 2 = active
  output logic CPU_enable, UART_enable,
  //NOTE: VGA should always have access to memory when it needs it, so VGA_state will dictate memory access

  //signals from CPU
  input logic write_from_CPU, read_from_CPU,
  input logic [31:0] adr_from_CPU, data_from_CPU,
  input logic [3:0] sel_from_CPU,

  //signal to CPU
  output logic [31:0] data_to_CPU,


  //signals from VGA
  input logic write_from_VGA, read_from_VGA, //NOTE: write_from_VGA and data_from_VGA is probably unnecessary 
  input logic [31:0] adr_from_VGA, data_from_VGA,
  input logic [3:0] sel_from_VGA,

  //signal to VGA
  output logic [31:0] data_to_VGA,


  //signals from UART
  input logic write_from_UART, read_from_UART, //NOTE: read_from_UART and data_to_UART is unused (future use might be considered)
  input logic [31:0] adr_from_UART, data_from_UART,
  input logic [3:0] sel_from_UART,

  //signal to UART
  output logic [31:0] data_to_UART,


  //signals to memory
  output logic write_to_mem, read_to_mem,
  output logic [31:0] adr_to_mem, data_to_mem,
  output logic [3:0] sel_to_mem,

  //signals from memory
  input logic [31:0] data_from_mem,
  input logic mem_busy
);

  current_client_t current_client; //00 for CPU, 01 for VGA, 10 for UART
  logic [31:0] CPU_UART_cycle_counter;

  always_ff @( posedge clk, negedge nRst ) begin //current client control
    if(~nRst) begin
      current_client <= NONE;
    end else begin
      if (VGA_state == READY | VGA_state == ACTIVE) begin
        current_client <= VGA;
      end else begin
        if(current_client == VGA) begin
          current_client <= UART;
        end else begin
          current_client <= CPU;
        end
      end
    end
  end

  always_comb begin  //make connects based on current client
    if(mem_busy) begin
      CPU_enable = 1'b0;
      UART_enable = 1'b0;
      data_to_CPU = 32'b0;
      data_to_VGA = 32'b0;
      data_to_UART = 32'b0;

      write_to_mem = 1'b0;
      read_to_mem = 1'b0;
      adr_to_mem = 32'b0;
      data_to_mem = 32'b0;
      sel_to_mem = 4'b0;
    end else begin
      case (current_client)
        NONE: begin
            CPU_enable = 1'b0;
            UART_enable = 1'b0;
            data_to_CPU = 32'b0;
            data_to_VGA = 32'b0;
            data_to_UART = 32'b0;

            write_to_mem = 1'b0;
            read_to_mem = 1'b0;
            adr_to_mem = 32'b0;
            data_to_mem = 32'b0;
            sel_to_mem = 4'b0;
        end

        VGA: begin
          CPU_enable = 1'b0;
          UART_enable = 1'b0;
          data_to_CPU = 32'b0;
          data_to_VGA = data_from_mem;
          data_to_UART = 32'b0;

          write_to_mem = write_from_VGA;
          read_to_mem = read_from_VGA;
          adr_to_mem = adr_from_VGA;
          data_to_mem = data_from_VGA;
          sel_to_mem = sel_from_VGA;
        end

        CPU: begin
          CPU_enable = 1'b1;
          UART_enable = 1'b0;
          data_to_CPU = data_from_mem;
          data_to_VGA = 32'b0;
          data_to_UART = 32'b0;

          write_to_mem = write_from_CPU;
          read_to_mem = read_from_CPU;
          adr_to_mem = adr_from_CPU;
          data_to_mem = data_from_CPU;
          sel_to_mem = sel_from_CPU;
        end

        UART: begin
          CPU_enable = 1'b0;
          UART_enable = 1'b1;
          data_to_CPU = 32'b0;
          data_to_VGA = 32'b0;
          data_to_UART = data_from_mem;

          write_to_mem = write_from_UART;
          read_to_mem = read_from_UART;
          adr_to_mem = adr_from_UART;
          data_to_mem = data_from_UART;
          sel_to_mem = sel_from_UART;
        end
      endcase
    end
      
  end

endmodule