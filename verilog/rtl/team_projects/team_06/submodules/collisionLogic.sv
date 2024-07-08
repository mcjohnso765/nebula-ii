
module collisionLogic (
    input logic [7:0] next_head,
    input logic [MAX_LENGTH - 1:0] [3:0]body_x ,//[0:3],
    input logic [MAX_LENGTH - 1:0] [3:0]body_y ,//[0:3],
    output logic collision );

logic [MAX_LENGTH - 1:0] collision_array;
parameter MAX_LENGTH = 30;

    always_comb begin
        collision_array = 0;
        for (integer i = 1; i <= (MAX_LENGTH - 1); i++) begin
            collision_array[i] = 
            (body_x[i][0] ~^ next_head[0]) && 
            (body_x[i][1] ~^ next_head[1]) && 
            (body_x[i][2] ~^ next_head[2]) && 
            (body_x[i][3] ~^ next_head[3]) && 
            (body_y[i][0] ~^ next_head[4]) && 
            (body_y[i][1] ~^ next_head[5]) && 
            (body_y[i][2] ~^ next_head[6]) && 
            (body_y[i][3] ~^ next_head[7]);
        end
        collision = |collision_array;
    end
endmodule