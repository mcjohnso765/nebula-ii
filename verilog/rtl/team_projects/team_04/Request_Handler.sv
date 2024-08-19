`default_nettype none

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

module t04_request_handler (
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