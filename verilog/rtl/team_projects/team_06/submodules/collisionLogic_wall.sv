module collisionLogic_wall (
    input logic [7:0] next_wall,
    input logic [24:0] [7:0] walls ,//[0:3],
    output logic collision );

logic [24:0] collision_array;

    always_comb begin
        for (integer i = 0; i <= 24; i++) begin
            collision_array[i] = 
            (walls[i][0] ~^ next_wall[0]) && 
            (walls[i][1] ~^ next_wall[1]) && 
            (walls[i][2] ~^ next_wall[2]) && 
            (walls[i][3] ~^ next_wall[3]) && 
            (walls[i][4] ~^ next_wall[4]) && 
            (walls[i][5] ~^ next_wall[5]) && 
            (walls[i][6] ~^ next_wall[6]) && 
            (walls[i][7] ~^ next_wall[7]);
        end
        collision = |collision_array;
    end
endmodule