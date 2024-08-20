
//BUFFER TESTBENCH
`timescale 1ms/10ns
  module tb_decoder;
    localparam CLK_PERIOD         = 10;  // 400 MHz     
    localparam  RESET_OUTPUT_VALUE = 8'b0;
    logic [7:0]keycode;
    logic [7:0]keycode_previous;
    logic [1:0]key_count;
    logic mode;
    logic upper;
    logic [127:0]data_received;



    // logic 
    
    // DUT Inputs
    logic tb_clk;
    logic tb_rst;

        always begin
        tb_clk = 1; // set clock initially to be 0 so that they are no time violations at the rising edge 
        #(CLK_PERIOD / 2);
        tb_clk = 0;
        #(CLK_PERIOD / 2);

    end
    
    
decoder dut(.clk(tb_clk), .rst(tb_rst), .keycode(keycode), .keycode_previous(keycode_previous), .key_count(key_count), .mode(mode), 
            .upper(upper), .data_received(data_received));

      initial begin 
        $dumpfile("sim.vcd");
        $dumpvars(0,tb_decoder);
        
      // TESTCASES
        //test 1: 911
          tb_rst = 1;
          upper = 0;
          mode = 0;
          key_count = 0;
          #(CLK_PERIOD * 1);
          tb_rst = 0;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000100; //9
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000;  //C
          keycode_previous = 8'b01000100   ;
          key_count = 2'b00;  
          #(CLK_PERIOD * 1);          
          keycode = 8'b00010001; //1
          keycode_previous = 8'b01001000;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000;  //C
          keycode_previous = 8'b00010001   ;
          key_count = 2'b00;  
          #(CLK_PERIOD * 1);          
          keycode = 8'b00010001; //1
          keycode_previous = 8'b01001000;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C
          keycode_previous = 8'b00010001;
          #(CLK_PERIOD * 1);
          keycode = 8'b10001000; //D
          keycode_previous = 8'b01001000;
          #(CLK_PERIOD * 3);

        //test 2: Hello


          mode = 1;
          tb_rst = 0;
          key_count = 2'b00;
          keycode = 8'b00101000; //button B
          keycode_previous = 8'b0;
          #(CLK_PERIOD * 1);
          keycode = 8'b10000100; //button # to activate shift
          keycode_previous = 8'b00101000;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          upper = 1;
          keycode = 8'b00100001; //4 G
          keycode_previous = 8'b10000100;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          upper = 1;
          keycode = 8'b00100001; //4 H
          keycode_previous = 8'b00100001;
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          upper = 0;
          keycode = 8'b01001000; //C 
          keycode_previous = 8'b00100001;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3 d
          keycode_previous = 8'b01001000;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3 e
          keycode_previous = 8'b00010100;
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          upper = 0;
          keycode = 8'b01001000; //C
          keycode_previous = 8'b00100001;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100010; //5 j    
          keycode_previous = 8'b00010100;        
          key_count = 2'b00;
          #(CLK_PERIOD * 1);        
          keycode = 8'b00100010; //5  k
          key_count = 2'b01;
          keycode_previous = 8'b00100010;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100010; //5  l
          keycode_previous = 8'b00100010;
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C
          keycode_previous = 8'b00100010;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100010; //5   j
          keycode_previous = 8'b01001000;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);        
          keycode = 8'b00100010; //5 k
          keycode_previous = 8'b00100010;
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100010; //5  l
          keycode_previous = 8'b00100010;
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C  
          keycode_previous = 8'b00100010;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100100; //6  m
          keycode_previous = 8'b01001000;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100100; //6  n
          keycode_previous = 8'b00100100;
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100100; //6  o
          keycode_previous = 8'b00100100;
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C 
          keycode_previous = 8'b00100100;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b10001000; //D send
          key_count = 2'b00;
          #(CLK_PERIOD * 3);


        //test 3: 1 fish 2 fish

          tb_rst = 0;
          mode = 0;
          key_count = 2'b0;
          keycode_previous = 8'b0;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010001; //1 
          keycode_previous = 8'b0;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000;  //C
          keycode_previous = 8'b00010001   ;
          key_count = 2'b00;  
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C space
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;      
          #(CLK_PERIOD * 1);
          keycode = 8'b00101000; //B
          keycode_previous = 8'b01001000;
          mode = 1;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3  d
          keycode_previous = 8'b00101000    ;  
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3  e
          keycode_previous = 8'b00010100 ;   
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3  f
          keycode_previous = 8'b00010100 ;
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000;  //C
          keycode_previous = 8'b00010100   ;
          key_count = 2'b00;    
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4 g
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4  h
          keycode_previous = 8'b00100001   ; 
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4  i
          keycode_previous = 8'b00100001   ; 
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //4  C
          keycode_previous = 8'b00100001  ;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000001; //7 p
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000001; //7 q
          keycode_previous = 8'b01000001    ;
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000001; //7 r
          keycode_previous = 8'b01000001   ; 
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000001; //s
          keycode_previous = 8'b01000001  ;
          key_count = 2'b11;
            
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000;  //C
          keycode_previous = 8'b01000001  ;  
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4 g
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4 h
          keycode_previous = 8'b00100001   ; 
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b00100001   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);

          keycode = 8'b01001000; //C space
          keycode_previous = 8'b00101000   ; 
          key_count = 2'b01;          
          #(CLK_PERIOD * 1);
          keycode = 8'b00101000; //B
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          mode = 0;

          #(CLK_PERIOD * 1);
          keycode = 8'b00010010; //2
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000;  //C confirm
          keycode_previous = 8'b00010010   ;
          key_count = 2'b00;  
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C space
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b01;         
          #(CLK_PERIOD * 1);
          keycode = 8'b00101000; //B
          keycode_previous = 8'b01001000    ;
          mode = 1;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3  d
          keycode_previous = 8'b00101000    ;  
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3  e
          keycode_previous = 8'b00010100 ;   
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3  f
          keycode_previous = 8'b00010100 ;
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000;  //C
          keycode_previous = 8'b00010100   ;
          key_count = 2'b00;    
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4 g
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4  h
          keycode_previous = 8'b00100001   ; 
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4  i
          keycode_previous = 8'b00100001   ; 
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //4  C
          keycode_previous = 8'b00100001  ;
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000001; //7 p
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000001; //7 q
          keycode_previous = 8'b01000001    ;
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000001; //7 r
          keycode_previous = 8'b01000001   ; 
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b01000001; //s
          keycode_previous = 8'b01000001  ;
          key_count = 2'b11;
            
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000;  //C
          keycode_previous = 8'b01000001  ;  
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4 g
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00100001; //4h
          keycode_previous = 8'b00100001   ; 
          key_count = 2'b01;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C
          keycode_previous = 8'b00100001   ; 
          key_count = 2'b00;
          #(CLK_PERIOD * 1);
          keycode = 8'b00101000; //B
          keycode_previous = 8'b01001000   ; 
          key_count = 2'b00;
          mode = 0;
          #(CLK_PERIOD * 1);
          keycode = 8'b10001000; //D
          keycode_previous = 8'b00101000   ; 
          key_count = 2'b00;
          mode = 0;          
        //test backspace
          tb_rst = 1;
          upper = 0;
          mode = 0;
          key_count = 0;
          #(CLK_PERIOD * 1);
          tb_rst = 0;
          #(CLK_PERIOD * 1);
          keycode = 8'b00010100; //3
          keycode_previous = 8'b0;
          key_count = 2'b0;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b00010100;
          key_count = 2'b0;          
          #(CLK_PERIOD * 1);
          keycode = 8'b10000001; //*
          keycode_previous = 8'b01001000;
          key_count = 2'b0;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b10000001;
          key_count = 2'b0;            
          #(CLK_PERIOD * 1);
          keycode = 8'b00100100; //6
          keycode_previous = 8'b01001000;
          key_count = 2'b0;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b00100100;
          key_count = 2'b0;  
          #(CLK_PERIOD * 1);
          keycode = 8'b00101000; //B
          keycode_previous = 8'b01001000;
          key_count = 2'b0;   
          mode = 1;                   
          #(CLK_PERIOD * 1);
          keycode = 8'b10000001; // * +
          keycode_previous = 8'b00101000;
          key_count = 2'b0; 
          #(CLK_PERIOD * 1);
          keycode = 8'b10000001; // * -
          keycode_previous = 8'b10000001;
          key_count = 2'b01;               
          #(CLK_PERIOD * 1);
          keycode = 8'b10000001; // * /
          keycode_previous = 8'b10000001;
          key_count = 2'b10;
          #(CLK_PERIOD * 1);
          keycode = 8'b10000001; // * =
          keycode_previous = 8'b10000001;
          key_count = 2'b11;
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b10000001;
          key_count = 2'b0;  
          #(CLK_PERIOD * 1);
          keycode = 8'b00101000; //B
          keycode_previous = 8'b01001000;
          key_count = 2'b0;   
          mode = 0;     
          #(CLK_PERIOD * 1);
          keycode = 8'b00010010; //2
          keycode_previous = 8'b01001000;
          key_count = 2'b0;  
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b00010010;
          key_count = 2'b0;  
          #(CLK_PERIOD * 1);
          keycode = 8'b00100010; //5
          keycode_previous = 8'b01001000;
          key_count = 2'b0;  
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b00100010;
          key_count = 2'b0;  
          #(CLK_PERIOD * 1);
          keycode = 8'b00011000; //A
          keycode_previous = 8'b01001000;
          key_count = 2'b0;            
          #(CLK_PERIOD * 1);
          keycode = 8'b00011000; //A
          keycode_previous = 8'b00011000;
          key_count = 2'b0;     
          #(CLK_PERIOD * 1);
          keycode = 8'b00010001; //1
          keycode_previous = 8'b00011000;
          key_count = 2'b0;   
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b00010001;
          key_count = 2'b0;  
          #(CLK_PERIOD * 1);
          keycode = 8'b01000010; //8
          keycode_previous = 8'b01001000;
          key_count = 2'b0;   
          #(CLK_PERIOD * 1);
          keycode = 8'b01001000; //C confirm
          keycode_previous = 8'b01000010;
          key_count = 2'b0;  
          #(CLK_PERIOD * 1);
          keycode = 8'b00010001; //D 
          keycode_previous = 8'b01001000;
          key_count = 2'b0;  


        $finish;
      end 


  endmodule