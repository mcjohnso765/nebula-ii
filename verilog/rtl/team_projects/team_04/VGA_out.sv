//
//      VGA Output Module, outputs to VGA and send information to monitor
//



module t04_VGA_out(
    input logic [31:0] SRAM_data_in, // These are 32 bits that the VGA receives from memory that gets sent as pixel_data
    input logic SRAM_busy,          // SRAM busy flag, acts as an enable to send pixel_data
    input logic clk, nrst,
    output logic data_en, // Can be used for the read signal sent to the wishbone
    output logic h_out, v_out, pixel_data,   // outputs to the VGA plug in
    output logic [31:0] word_address_dest, // 32 bit address line that points to memory, VGA will only ever use 12 bits
    output logic [3:0] byte_select, // directly tied to the data_en output, says that it wants 4 bytes of data
    output logic [1:0] VGA_state, // 0 = inactive, 1 = about to be active, 2 = active

    //OUTPUTS ONLY FOR TEST BENCHING
    output logic [9:0] h_count,
    output logic [8:0] v_count,
    
    output logic [1:0] h_state, // can be eliminated after test benching
    output logic [1:0] v_state // can be eliminated after tesbenching
);
    logic [31:0] word_address_base; // A set value for the base address of the VGA memory information. 
    logic [8:0] word_address_offset; // points to the address range of 0x000 to 0x180
    logic change_state_h, change_state_v, v_count_toggle; 
    
    logic [9:0] h_next_count; // 0 to 640 // FOR TESTBENCHING ONLY /////////////////////////////////////////////
    logic [8:0] v_next_count; // 0 to 480 // FOR TESTBENCHING ONLY /////////////////////////////////////////////
   
//    logic [9:0] h_count, h_next_count; // 0 to 640 // FOR ACTUAL USE /////////////////////////////////////////
//    logic [8:0] v_count, v_next_count; // 0 to 480 // FOR ACTUAL USE /////////////////////////////////////////
    logic [8:0] h_offset; // h count math for appropriate word address offset
    logic [8:0] v_offset; // v count math for appropriate word address offset
    logic [4:0] x_coord; // address for the 32 bit of information received from SRAM
    logic [31:0] current_word, next_word; // used for calling the next line of info from SRAM and having it on standby
    
    //assign word_address_base = 32'h3E80; // Word address base for the actual SRAM
    assign word_address_base = 32'h0; // Word address base for test benching purposes

    // Enum for H_STATES
    typedef enum logic [1:0] {
            h_sync = 2'b00,
            h_backporch =  2'b01,
            h_active = 2'b10,
            h_frontporch = 2'b11
    } h_mode; 

    // Enum for STATES
    typedef enum logic [1:0] {
            v_sync = 2'b00,
            v_backporch =  2'b01,
            v_active = 2'b10,
            v_frontporch = 2'b11
    } v_mode; 


    h_mode h_current_state, h_next_state;
    // HSYNC Counter
    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            h_current_state <= h_sync;
            h_count <= 0;
        end else begin
            h_current_state <= h_next_state;
            h_count <= h_next_count;
        end

    end

        v_mode v_current_state, v_next_state;
    // VSYNC Counter
    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            v_current_state <= v_sync;
            v_count <= 0;
        end else begin
            v_current_state <= v_next_state;
            v_count <= v_next_count;
        end
    end


        // Changes the VGA_State signal to notify 'Request Handler' the current active state of the VGA
    always_comb begin
        if ((v_current_state == v_active) & (v_count < 384)) begin
            VGA_state = 2'b10;
        end else if ((v_current_state == v_backporch) & (v_count == 9'd32)) begin
            VGA_state = 2'b01;
        end else begin
            VGA_state = 2'b00;
        end
    end


    // HSYNC State Machine
    always_comb begin
        h_next_count = h_count;
        case (h_current_state) 
            h_sync: begin
                h_state = 2'b00; // can be eliminated after tesbenching
                v_count_toggle = 0;
                if (h_count < 37) begin //OG 95
                    h_next_count = h_next_count + 1'b1;
                    h_out = 0;
                    h_next_state = h_sync;
                end else begin
                    h_next_count = 0;
                    h_out = 1;
                    h_next_state = h_backporch;
                end
            end
            

            h_backporch: begin
                h_state = 2'b01; // can be eliminated after tesbenching
                h_out = 1;
                v_count_toggle = 0;
                if (h_count < 18) begin // OG 47
                    h_next_count = h_next_count + 1'b1;
                    h_next_state = h_backporch;
                end else begin
                    h_next_count = 0;
                    h_next_state = h_active;
                end
            end

            h_active: begin
                h_state = 2'b10; // can be eliminated after tesbenching
                h_out = 1;
                v_count_toggle = 0;
                if (h_count < 253) begin // OG 639
                    h_next_count = h_next_count + 1'b1;
                    h_next_state = h_active;
                end else begin
                    h_next_count = 0;
                    h_next_state = h_frontporch;
                end

            end

            h_frontporch: begin
                h_state = 2'b11; // can be eliminated after tesbenching
                h_out = 1;
                if (h_count < 5) begin // OG 15
                    h_next_count = h_next_count + 1'b1;
                    h_next_state = h_frontporch;
                    v_count_toggle = 0;
                end else begin
                    h_next_count = 0;
                    h_next_state = h_sync;
                    v_count_toggle = 1;
                end
            end
        endcase
    end



    // VSYNC State Machine
    always_comb begin
        v_next_count = v_count;
        if (v_count_toggle) begin
            v_next_count = v_next_count + 1'b1;
        end
        case (v_current_state) 
            v_sync: begin
                v_state = 2'b00; // can be eliminated after tesbenching
                if (v_count < 2) begin
                    v_out = 0;
                    v_next_state = v_sync;
                end else begin
                    v_next_count = 0;
                    v_out = 1;
                    v_next_state = v_backporch;
                end
            end
            

            v_backporch: begin
                v_state = 2'b01; // can be eliminated after tesbenching
                v_out = 1;
                if (v_count < 33) begin
                    v_next_state = v_backporch;
                end else begin
                    v_next_count = 0;
                    v_next_state = v_active;
                end
            end

            v_active: begin
                v_state = 2'b10;// can be eliminated after tesbenching
                v_out = 1;
                if (v_count < 480) begin
                    v_next_state = v_active;
                end else begin
                    v_next_count = 0;
                    v_next_state = v_frontporch;
                end

            end

            v_frontporch: begin
                v_state = 2'b11;// can be eliminated after tesbenching
                v_out = 1;
                if (v_count < 10) begin
                    v_next_state = v_frontporch;
                end else begin
                    v_next_count = 0;
                    v_next_state = v_sync;
                end
            end
        endcase
    end


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // WE CAN WORRY ABOUT HOW WE ARE GOING TO WORK WITH OUR TIMING TO MAKE SURE THAT OUR DATA BIT COMES WHEN WE WANT IT TO //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Correct Pixel data only sends if enable and ~busy flag are toggled
    always_comb begin
        if (~SRAM_busy & data_en) begin
            pixel_data = SRAM_data_in[x_coord];
        end else begin
            pixel_data = 0;
        end
    end

    // IF BOTH STATES ARE ACTIVE AND THE COUNT IS WITHIN OUR DISPLAY DIMENSIONS, DATA TRANSACTION IS ENABLED
    always_comb begin                                                       // 256 for 2 pixels ber pit, 384 for 4 lines before new data
        if ((h_current_state == h_active) & (v_current_state == v_active) & (h_count < 256) & (v_count < 384)) begin
            data_en = 1;
        end else begin
            data_en = 0;
        end 
    end

    // BYTE SELECT TOGGLES ALL BYTES IF DATA TRANSACTION IS ENABLED, OTHERWISE IT NEVER REQUESTS ANY BITS  
    assign byte_select = {data_en, data_en, data_en, data_en};



    always_comb begin
    ////////////////////////////////////POTENTIAL FOR ADDING AN ENABLE HERE TO OPTIMIZE/////////////////////////////////////////
        h_offset = {7'b0, h_count[6:5]};  // sets h offset to hcount up until 32
        v_offset = 7'd4 * v_count[8:2];            // sets v offset to vcount * 4 // [8:2] accounts for after 4 lines we get a new offset of info
        word_address_offset = h_offset + v_offset; // sets word offset to the total of h and v offsets
    end

    assign word_address_dest = word_address_base + {23'b0, word_address_offset}; 

    // setting up X coordinate logic for reading from our SRAM Bytes
    // the first 5 bits just loop after every multiple of 32
    //assign x_coord = h_count[4:0]; // READING FROM RIGHT TO LEFT
    assign x_coord = 5'b11111 - h_count[5:1]; // READING FROM LEFT TO RIGHT, every 2 pixel, next bit


endmodule


