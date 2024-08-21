// Empty top module
localparam MAX_IDX = 20;
typedef enum logic [3:0] { 
    INIT = 0, 
    SET,
    SEND,
    DONE
} state_t_img; 

typedef enum logic [3:0] {
    INITI = 0,
    DRAW_OBJECTS = 1,
    CHECK_MOVE = 2,
    ERASE_DINO = 3,
    ERASE_CACTUS_1 = 4,
    ERASE_CACTUS_2 = 5,
    DRAW_DINO = 6,
    DRAW_CACTUS_1 = 7,
    DRAW_CACTUS_2 = 8,
    DRAW_DINO_FULL = 9,
    ERASE_BUGS = 10,
    DONES = 11
} state_d;

module team_08_parallelDisplay (
    input logic clk,
    input logic rst,
    input logic [1:0] move_enable, // Enable signals for movement of each object
    input logic [7:0] dinoY,
    input logic [8:0] cactusX1, x_dist,
    input logic [7:0] cactusH1, cactusH2,
    input logic [7:0] v,
    output logic cs,
    output logic cd,
    output logic wr,
    output logic rd,
    output logic [7:0] data,
    output logic [1:0] received //returns to move_enabled sent module
);

logic init_done;
logic [1:0] current_object;
logic block_done;
state_d state;

logic [8:0] x_start, x_end, cactusX2;
logic [7:0] y_start, y_end;
logic [15:0] color;

logic [8:0] d_x_start, d_x_end;
logic [7:0] d_y_start, d_y_end;
logic [15:0] d_color;

logic [8:0] c1_x_start, c1_x_end;
logic [7:0] c1_y_start, c1_y_end;
logic [15:0] c1_color;

logic [8:0] c2_x_start, c2_x_end;
logic [7:0] c2_y_start, c2_y_end;
logic [15:0] c2_color;

logic cs_init;
logic cd_init;
logic wr_init;
logic rd_init;
logic [7:0] data_init;

logic cs_draw;
logic cd_draw;
logic wr_draw;
logic rd_draw;
logic [7:0] data_draw;

// Instantiate the initialization module
    tft_init init_module (
        .clk(clk),
        .rst(rst),
        .cs(cs_init),
        .cd(cd_init),
        .wr(wr_init),
        .rd(rd_init),
        .data(data_init),
        .init_done(init_done),
        .state()
    );

    // Instantiate the draw block module
    draw_block drawBlock (
        .clk(clk),
        .rst(rst),
        .init_done(init_done),
        .x_start(x_start),
        .x_end(x_end),
        .y_start(y_start),
        .y_end(y_end),
        .color(color),
        .cs(cs_draw),
        .cd(cd_draw),
        .wr(wr_draw),
        .rd(rd_draw),
        .data(data_draw),
        .block_done(block_done),
        .state(),
        // .counter(right),
        .idx()
    );

     // Select signals based on init_done status
    assign {cs, cd, wr, rd, data} = init_done ? {cs_draw, cd_draw, wr_draw, rd_draw, data_draw} : 
    {cs_init, cd_init, wr_init, rd_init, data_init};

always_comb begin
    cactusX2 = cactusX1 + x_dist;
    d_x_start = 9'd280;
    d_x_end = 9'd300;
    d_y_start = dinoY;
    d_y_end = dinoY + 8'd40;
    d_color = 16'h0000;

    c1_x_start = cactusX1;
    c1_x_end = cactusX1 + 9'd20; 
    c1_y_start = 8'd101; 
    c1_y_end = 8'd101 + cactusH1; 
    c1_color= 16'h07E0; 

    c2_x_start = cactusX2;
    c2_x_end = cactusX2 + 9'd20; 
    c2_y_start = 8'd101; 
    c2_y_end = 8'd101 + cactusH2; 
    c2_color= 16'h001F; 
end

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        state <= INITI;
        current_object <= 0;
        received <= 2'b0;
    end else begin
        state <= state;
        received <= 2'b0;
        x_start <= 1;
        x_end <= 1;
        y_start <= 1;
        y_end <= 1;
        color <= 16'hEEEE;  
        case (state)
            INITI: begin
                    x_start <= 9'd0;
                    x_end <= 9'd320;
                    y_start <= 8'b0;
                    y_end <= 8'd240;
                    color <= 16'hEEEE;
                    if (block_done) begin
                        state <= DRAW_OBJECTS;
                        current_object <= 0;
                    end
            end

            DRAW_OBJECTS: begin

                x_start <= d_x_start;
                x_end <= d_x_end;
                y_start <= d_y_start;
                y_end <= d_y_end;
                color <= d_color;

                    
                if (block_done) begin
                    state <= CHECK_MOVE;
                end
            end

            CHECK_MOVE: begin
                // x_start <= d_x_start;
                // x_end <= d_x_end;
                // y_start <= d_y_end + 1;
                // y_end <= 239;
                // color <= 16'hEEEE;  
                if (move_enable[0] && block_done) begin
                    current_object <= 0;
                    state <= ERASE_DINO;
                end else if(move_enable[1] && block_done) begin

                        state <= ERASE_CACTUS_1;
                
                end else begin
                    state <= CHECK_MOVE;
                end
            end

            ERASE_DINO: begin
                // Erase the current object by drawing over it with the background color (assuming background is black)
                //erase the unnecessary blocks
                if(v == 0 && dinoY == 8'd101) begin
                    x_start <= d_x_start;
                    x_end <= d_x_end;
                    y_start <= d_y_end + 1;
                    y_end <= d_y_end + 12;
                    color <= 16'hEEEE; // white color
                end else if (v >= 0 && v < 12) begin
                    x_start <= d_x_start;
                    x_end <= d_x_end;
                    y_start <= d_y_start - v - 1;
                    y_end <= d_y_start - 1;
                    color <= 16'hEEEE; // white color
                
                end else begin
                    x_start <= d_x_start;
                    x_end <= d_x_end;
                    y_start <= d_y_end + 1;
                    y_end <= d_y_end - v + 2;
                    color <= 16'hEEEE; // white color
                end 
                
                received <= 2'b1;//detected the move)enable signal
                
                if (block_done) begin
                    state <= DRAW_DINO;
                    current_object <= 0;
                end
            end

            ERASE_CACTUS_1: begin
                // Erase the current object by drawing over it with the background color (assuming background is black)
                if(c1_x_start - 12 > c1_x_start - 1)
                    state <= DRAW_CACTUS_1;
                else begin
                x_start <= c1_x_start - 12;
                x_end <= c1_x_start - 1;
                y_start <= c1_y_start;
                y_end <= c1_y_start + 40;
                color <= 16'hEEEE; // white color
                end

                if (block_done) begin
                    state <= DRAW_CACTUS_1;
                    current_object <= 1;
                end
            end

            ERASE_CACTUS_2: begin
                // Erase the current object by drawing over it with the background color (assuming background is black)
                if(c2_x_start - 12 > c2_x_start - 1)
                    state <= DRAW_CACTUS_2;
                else begin
                x_start <= c2_x_start - 12;
                x_end <= c2_x_start - 1;
                y_start <= c2_y_start;
                y_end <= c2_y_start + 40;
                color <= 16'hEEEE; // white color
                end
                if (block_done) begin
                    state <= DRAW_CACTUS_2;
                    current_object <= 1;
                end
            end

            DRAW_DINO: begin
                // Draw the object at the new position
                // calculate the next position of dino
                if (v == 0 && dinoY == 8'd101) begin
                    x_start <= d_x_start;
                    x_end <= d_x_end;
                    y_start <= dinoY;
                    y_end <= dinoY + 12;
                    color <= d_color;
                end else if( v >= 0 && v < 12) begin
                    x_start <= d_x_start;
                    x_end <= d_x_end;
                    y_start <= d_y_end - v;
                    y_end <= d_y_end;
                    color <= d_color;
                end else begin
                    x_start <= d_x_start;
                    x_end <= d_x_end;
                    y_start <= dinoY;
                    y_end <= dinoY - v;
                    color <= d_color;
                end
                
                if (block_done) begin
                    state <= CHECK_MOVE;
                    current_object <= 0;
                end        
            end

            DRAW_CACTUS_1: begin
                if(c1_x_end + 4 < c1_x_end - 7)
                    state <= ERASE_CACTUS_2;
                else begin
                    x_start <= c1_x_end - 7;
                    x_end <= c1_x_end + 4;
                    y_start <= c1_y_start;
                    y_end <= c1_y_end;
                    color <= c1_color; // Black color
                end
                if (block_done) begin
                    state <= ERASE_CACTUS_2;
                    current_object <= 1;
                end     
            end
 
            DRAW_CACTUS_2: begin
                if(c2_x_end + 4 < c2_x_end - 7)
                    state <= DRAW_DINO_FULL;
                else begin
                x_start <= c2_x_end - 7;
                x_end <= c2_x_end + 4;
                y_start <= c2_y_start;
                y_end <= c2_y_end;
                color <= 16'h0000; // Black color
                end
                if (block_done) begin
                    state <= DRAW_DINO_FULL;
                    current_object <= 2;
                end      
            end
            DRAW_DINO_FULL: begin
                    x_start <= d_x_start;
                    x_end <= d_x_end;
                    y_start <= d_y_start;
                    y_end <= d_y_end;
                    color <= d_color;
                    received <= 2'b10;//detected the move)enable signal
                    if (block_done) begin
                        state <= CHECK_MOVE;
                        current_object <= 2;
                    end      
            end
        endcase
    end
end

endmodule



module draw_block( 
  input logic clk, 
  input logic rst, 
  input logic init_done,
  input logic [8:0] x_start, x_end, 
  input logic [7:0] y_start, y_end,
  input logic [15:0] color,
  output logic cs, 
  output logic cd, 
  output logic wr, 
  output logic rd, 
  output logic [7:0] data,
  output logic block_done,
  output state_t_img state,
//   output logic [7:0] counter,
  output logic [4:0] idx
  // output logic [8:0] counter
); 

//state_t_img state; 
//logic [15:0] color; 
// Declare additional variables for pixel coordinates
logic [20:0] counter;

logic [1:0] pixel_state; // State variable to control pixel write sequence
// logic [4:0] idx;


always_ff @(posedge clk, negedge rst) begin 
    if (!rst) begin 
        state <= INIT; 
        wr <= 1;
        counter <= 0;
        block_done <= 0;
        idx <= 0;
        //counter <= 0;

    end else if (init_done) begin 
        block_done <= 0;
        counter <= counter;
        idx <= idx;
        case (state) 
            INIT: begin 
                state <= SET; 
            end 
            SET:begin
                wr <= 0;
                if (idx <= 12) begin
                    idx <= idx + 1;
                end 
                else if (idx == 13) begin
                    idx <= 12;
                    counter <= counter + 1;
                end
                if (counter == (x_end - x_start + 1) * (y_end - y_start + 1))
                    state <= DONE;
                else
                    state <= SEND;
            end
            SEND: begin
                wr <= 1;
                state <= SET;
            end
            DONE: begin
                block_done <= 1;
                counter <= 0;
                idx <= 0;
                state <= INIT;
            end
        endcase
        if (x_start > x_end || y_start > y_end)
            state <= DONE;
    end 
end 


always_comb begin
    cs = 0;
    cd = 0;
    rd = 1;
    data = 8'b0;
    case (idx) 
        default: begin
            cs = 0;
            cd = 0;
            rd = 1;
            data = 8'b0;
        end
        5'd0: begin
            cs = 0; // reset 
            cd = 0;
            rd = 1;
            data = 8'b0;
        end
        5'd1: begin
            cs = 0; // SET_COLUMN_ADDR state
            cd = 0;
            rd = 1;
            data = 8'h2A;
        end
        5'd2: begin
            // SET_COLUMN_DATA
            cd = 1;
            rd = 1;
            data = 8'h00;
        end
        5'd3: begin
            cd = 1;
            data = y_start;
        end
        5'd4: begin
            cd = 1;
            data = 8'h00;
        end
        5'd5: begin
            cd = 1;
            data = y_end;
        end
        5'd6: begin
            cs = 0; // SET_ROW_ADDR state
            cd = 0;
            rd = 1;
            data = 8'h2B;
        end
        5'd7: begin
            cd = 1;
            rd = 1;
            data = {7'b0, x_start[8]};
        end
        5'd8: begin
            cd = 1;
            data = x_start[7:0];
        end
        5'd9: begin
            cd = 1;
            data = {7'b0, x_end[8]};
        end
        5'd10: begin
            cd = 1;
            data = x_end[7:0];
        end
        5'd11: begin
            cs = 0; // MEMORY_WRITE state
            cd = 0;
            rd = 1;
            data = 8'h2C;
        end
        5'd12: begin
            cd = 1;
            rd = 1;
            data = color[15:8]; // High byte of color
        end
        5'd13: begin
            cd = 1;
            data = color[7:0]; // Low byte of color
        end
    endcase
end
endmodule 



module tft_init(
    input logic clk,
    input logic rst,
    output logic cs,
    output logic cd,
    output logic wr,
    output logic rd,
    output logic [7:0] data,
    output logic init_done,
    output state_t_img state
);


    // state_t_img state;
    logic [5:0] idx;
    logic [23:0] delay_counter; // Counter for delay

    always_ff @(posedge clk, negedge rst) begin
        if (!rst) begin
            state <= INIT;
            wr <= 1;
            delay_counter <= 0;
            init_done <= 0;
            idx <= 0;
        end else begin
            init_done <= 0;
            idx <= idx;
            case (state)
                INIT: begin
                    state <= SET;
                end
                SET: begin
                    wr <= 0;
                    delay_counter <= 0;
                    if (idx == 2 || idx == 6)begin
                        state <= SET;
                        delay_counter <= delay_counter + 1;
                        if (delay_counter >= 24'd200000) begin
                            state <= SEND;
                            idx <= idx + 1;
                        end
                    end
                    else if (idx < 6) begin
                        idx <= idx + 1;
                        state <= SEND;
                    end else begin
                        state <= DONE;
                    end
                end
                SEND: begin
                    wr <= 1;
                    state <= SET;
                end
                DONE: begin
                    init_done <= 1;
                    state <= DONE;
                    idx <= 6;
                end
                default: state <= INIT;
            endcase
        end
    end

    always_comb begin
        cs = 0;
        cd = 0;
        rd = 1;
        data = 8'b0;
        case (idx)
            0: begin
                cs = 0;
                cd = 0; 
                rd = 1;
                data = 8'b0;
            end
            1: begin
                cs = 0;
                cd = 0;
                rd = 1;
                data = 8'h01; // Software Reset command
            end
            2: begin
                cs = 0;
                cd = 0;
                rd = 1;
                data = 8'h28; // Display Off command
            end
            3: begin
                cd = 0;
                rd = 1;
                data = 8'h3A; // COLMOD: Pixel Format Set
            end
            4: begin
                cd = 1;
                data = 8'h55; // Set to 16-bit color mode
            end
            5: begin
                cs = 0;
                cd = 0;
                rd = 1;
                data = 8'h11; // Sleep Out command
            end
            6: begin
                cs = 0;
                cd = 0;
                rd = 1;
                data = 8'h29; // Display On command
            end
            7: begin
              cs = 0;
              cd = 0;
              rd = 1;
              data = 8'b0;
            end
            default: begin
            cs = 0;
            cd = 0;
            rd = 1;
            data = 8'b0;
            end
        endcase
    end
endmodule

