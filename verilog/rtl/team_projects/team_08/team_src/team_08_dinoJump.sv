
module team_08_dinoJump( 
  input logic clk, nRst, button, 
  input state_t state,
  input logic drawDoneDino,
  output logic [7:0] dinoY,
  output logic dinoJumpGood,
  output logic [7:0] v,
  output logic dinoMovement
); 

  logic n_dinoMovement;

  logic [7:0] floorY = 8'd100; 
  logic [7:0] onFloor = 8'd101; 
  logic en, en2;

  logic [20:0] count, next_count, dinoDelay, next_dinoDelay; 
  logic [7:0] next_v, next_dinoY;  
  logic at_max, maxdinoDelay;

  always_ff @(posedge clk, negedge nRst) begin  
    if (~nRst) begin  
      v <= 8'd0;
      dinoY <= 8'd101;  
    end  

    else begin  
      v <= next_v;
      dinoY <= next_dinoY;  
    end  
  end 

  always_ff @(posedge clk, negedge nRst) begin  
    if (~nRst) begin  
      count <= 0;
      dinoDelay <= 0;
    end 

    else begin
      count <= next_count;
      dinoDelay <= next_dinoDelay;
    end  
  end  

  always_comb begin 
    if(dinoY == onFloor) begin 
      en = 1'b1; 
    end 
    else begin 
      en = 1'b0; 
    end 

    if(next_dinoY == onFloor) begin 
      en2 = 1'b1; 
    end 
    else begin 
      en2 = 1'b0; 

    end 
  end

  always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
      dinoMovement <= 0;
    end

    else begin
      dinoMovement <= n_dinoMovement;
    end
  end

  always_comb begin
    if(next_dinoY != dinoY) begin
        n_dinoMovement = 1;
    end
    else if(drawDoneDino) begin
        n_dinoMovement = 0;
    end
    else begin
        n_dinoMovement = dinoMovement;
    end
  end
  

//counter for at max 2 based on button
always_comb begin
  next_dinoDelay = dinoDelay;
  maxdinoDelay = 0;
  case(state)

  IDLE: begin
    maxdinoDelay = 0;
    next_dinoDelay = 0;
  end

  RUN: begin

    maxdinoDelay = 0;

    if(!button) begin
      next_dinoDelay = 0;
      maxdinoDelay = 0;
    end

    else begin
      if(button) begin
        next_dinoDelay = dinoDelay + 1;

        if(dinoDelay == 300000) begin
          next_dinoDelay = 0;
          maxdinoDelay = 1;
        end

        else if(at_max) begin
          next_dinoDelay = 0;
        end

        else begin
          maxdinoDelay = 0;
        end
      end

      else begin
        next_dinoDelay = dinoDelay;
        maxdinoDelay = maxdinoDelay;
      end
    end 
  end

  WIN: begin
    maxdinoDelay = 0;
    next_dinoDelay = 0;
  end

  OVER: begin
    maxdinoDelay = 0;
    next_dinoDelay = 0;
  end
   
  default: next_dinoDelay = 0;

  endcase

end

logic n_dinoJumpGood;
always_ff @(posedge clk, negedge nRst) begin
  if(!nRst) begin
    dinoJumpGood <= 0;
  end
  else begin
    dinoJumpGood <= n_dinoJumpGood;
  end
end

always_comb begin
  if(en && maxdinoDelay) begin
    n_dinoJumpGood = 1;
  end
  else if (next_v == 0) begin
    n_dinoJumpGood = 0;
  end
  else begin
    n_dinoJumpGood = dinoJumpGood;
  end
end  

always_comb begin   
  next_dinoY = 101;
  next_count = count;
  next_v = v;
  at_max = 0;

  case(state)

  IDLE: begin
    next_dinoY = 101;
    at_max = 0;
  end

  RUN: begin
      next_count = 0;  
      at_max = 0;  
      
      if(en && maxdinoDelay) begin
        next_count = 0;
      end
      else if (count == 400000) begin  
        next_count = 0;  
        at_max = 1;  
      end 
      else begin
        next_count = count + 1;  
      end

      if(en && maxdinoDelay) begin 
          next_v = 8'd10;
          next_dinoY = dinoY + 11;
      end 
      else if (at_max) begin 
        next_dinoY = dinoY + v; 
      
        if (en2 && !maxdinoDelay) begin 
          next_v = 8'd0; 
        end

        else begin 
          next_v = v - 1; 
        end 
      end

      else begin 
        next_dinoY = dinoY; 
        next_v = v; 
      end
  end

  OVER: begin
    next_dinoY = 0;
    at_max = 0;
  end

  WIN: begin
    next_dinoY = 0;
    at_max = 0;
  end

  default: next_dinoY = 0;

endcase

end 

endmodule
