typedef enum logic [1:0] {BYTE, HALFWORD, WORD} data_width;

module t01_data_memory (
    input logic         clk, nRST,
    input logic [31:0]  address, writedata, data_i,
    input logic         MemRead, MemWrite, dhit, ihit,
    input data_width    datawidth,
    output logic [31:0] readdata, address_DM, writedata_o,
    output logic        DataRead, DataWrite, enable
);
    assign address_DM = address;
    logic next_enable;
    typedef enum logic [1:0] {IDLE, READ, WRITE} StateType;
    StateType state, next_state;
    logic [31:0] next_readdata;

    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            state       <= IDLE;
            readdata    <= 32'b0;
            enable      <= 1'b0;
        end else begin
            state       <= next_state;
            readdata    <= next_readdata;
            enable      <= next_enable;
        end
    end

    always_comb begin
        case(datawidth)
            BYTE:     writedata_o = {{24{writedata[7]}},  writedata[7:0]};
            HALFWORD: writedata_o = {{16{writedata[15]}}, writedata[15:0]};
            WORD:     writedata_o = writedata;
            default:  writedata_o = writedata;
        endcase
    end

    always_comb begin
        DataRead        = 1'b0;
        DataWrite       = 1'b0;
        next_state      = state;
        next_readdata   = readdata;
        next_enable     = 1'b0;
        case (state)
            IDLE: begin
                if (MemRead && !enable) begin
                    DataRead   = 1'b1;
                    next_state = READ;
                end else if (MemWrite && !enable) begin
                    DataWrite  = 1'b1;
                    next_state = WRITE;
                end
            end 
            READ: begin
                DataRead   = 1'b1;
                if (dhit) begin
                    case(datawidth)
                        BYTE:     next_readdata = {{24{data_i[7]}}, data_i[7:0]};
                        HALFWORD: next_readdata = {{16{data_i[15]}}, data_i[15:0]};
                        WORD:     next_readdata = data_i;
                        default:  next_readdata = data_i;
                    endcase
                    // next_readdata   = data_i;
                    next_enable     = 1'b1;
                    next_state      = IDLE;
                end 
                
                // if (ihit) begin
                //     // next_readdata   = 32'b0;
                //     next_enable     = 1'b0;
                //     next_state      = IDLE;
                //     DataRead        = 1'b0;
                // end
            end
            WRITE: begin
                DataWrite = 1'b0;
                if (dhit) begin
                    next_state = IDLE;
                end
            end
            default:;
        endcase
    end
endmodule