`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 16:16:42
// Design Name: 
// Module Name: little_digit_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//20230617 19:19 V1

module little_digit_rom(
	input wire clk,
	input wire [10:0] addr,//11bit addr
	output reg [7:0] data
    );
	
	//数据结构：{[6:0],[0],[2:0]} {ASCII[6:0],ROW[0],COL[2:0]}
	//ASCII:0X30-0X39  ROW:0-5!!!!!  COL:0-23
	reg [10:0] addr_reg;
	
	always@(posedge clk)begin
		addr_reg<=addr;
	end
	
	always@(*)begin
		case(addr_reg)
11'h0300:data=8'h00;
11'h0301:data=8'hE0;
11'h0302:data=8'h10;
11'h0303:data=8'h08;
11'h0304:data=8'h08;
11'h0305:data=8'h10;
11'h0306:data=8'hE0;
11'h0307:data=8'h00;
11'h0308:data=8'h00;
11'h0309:data=8'h0F;
11'h030a:data=8'h10;
11'h030b:data=8'h20;
11'h030c:data=8'h20;
11'h030d:data=8'h10;
11'h030e:data=8'h0F;
11'h030f:data=8'h00;
11'h0310:data=8'h00;
11'h0311:data=8'h00;
11'h0312:data=8'h10;
11'h0313:data=8'h10;
11'h0314:data=8'hF8;
11'h0315:data=8'h00;
11'h0316:data=8'h00;
11'h0317:data=8'h00;
11'h0318:data=8'h00;
11'h0319:data=8'h00;
11'h031a:data=8'h20;
11'h031b:data=8'h20;
11'h031c:data=8'h3F;
11'h031d:data=8'h20;
11'h031e:data=8'h20;
11'h031f:data=8'h00;
11'h0320:data=8'h00;
11'h0321:data=8'h70;
11'h0322:data=8'h08;
11'h0323:data=8'h08;
11'h0324:data=8'h08;
11'h0325:data=8'h08;
11'h0326:data=8'hF0;
11'h0327:data=8'h00;
11'h0328:data=8'h00;
11'h0329:data=8'h30;
11'h032a:data=8'h28;
11'h032b:data=8'h24;
11'h032c:data=8'h22;
11'h032d:data=8'h21;
11'h032e:data=8'h30;
11'h032f:data=8'h00;
11'h0330:data=8'h00;
11'h0331:data=8'h30;
11'h0332:data=8'h08;
11'h0333:data=8'h08;
11'h0334:data=8'h08;
11'h0335:data=8'h88;
11'h0336:data=8'h70;
11'h0337:data=8'h00;
11'h0338:data=8'h00;
11'h0339:data=8'h18;
11'h033a:data=8'h20;
11'h033b:data=8'h21;
11'h033c:data=8'h21;
11'h033d:data=8'h22;
11'h033e:data=8'h1C;
11'h033f:data=8'h00;
11'h0340:data=8'h00;
11'h0341:data=8'h00;
11'h0342:data=8'h80;
11'h0343:data=8'h40;
11'h0344:data=8'h30;
11'h0345:data=8'hF8;
11'h0346:data=8'h00;
11'h0347:data=8'h00;
11'h0348:data=8'h00;
11'h0349:data=8'h06;
11'h034a:data=8'h05;
11'h034b:data=8'h24;
11'h034c:data=8'h24;
11'h034d:data=8'h3F;
11'h034e:data=8'h24;
11'h034f:data=8'h24;
11'h0350:data=8'h00;
11'h0351:data=8'hF8;
11'h0352:data=8'h88;
11'h0353:data=8'h88;
11'h0354:data=8'h88;
11'h0355:data=8'h08;
11'h0356:data=8'h08;
11'h0357:data=8'h00;
11'h0358:data=8'h00;
11'h0359:data=8'h19;
11'h035a:data=8'h20;
11'h035b:data=8'h20;
11'h035c:data=8'h20;
11'h035d:data=8'h11;
11'h035e:data=8'h0E;
11'h035f:data=8'h00;
11'h0360:data=8'h00;
11'h0361:data=8'hE0;
11'h0362:data=8'h10;
11'h0363:data=8'h88;
11'h0364:data=8'h88;
11'h0365:data=8'h90;
11'h0366:data=8'h00;
11'h0367:data=8'h00;
11'h0368:data=8'h00;
11'h0369:data=8'h0F;
11'h036a:data=8'h11;
11'h036b:data=8'h20;
11'h036c:data=8'h20;
11'h036d:data=8'h20;
11'h036e:data=8'h1F;
11'h036f:data=8'h00;
11'h0370:data=8'h00;
11'h0371:data=8'h18;
11'h0372:data=8'h08;
11'h0373:data=8'h08;
11'h0374:data=8'h88;
11'h0375:data=8'h68;
11'h0376:data=8'h18;
11'h0377:data=8'h00;
11'h0378:data=8'h00;
11'h0379:data=8'h00;
11'h037a:data=8'h00;
11'h037b:data=8'h3E;
11'h037c:data=8'h01;
11'h037d:data=8'h00;
11'h037e:data=8'h00;
11'h037f:data=8'h00;
11'h0380:data=8'h00;
11'h0381:data=8'h70;
11'h0382:data=8'h88;
11'h0383:data=8'h08;
11'h0384:data=8'h08;
11'h0385:data=8'h88;
11'h0386:data=8'h70;
11'h0387:data=8'h00;
11'h0388:data=8'h00;
11'h0389:data=8'h1C;
11'h038a:data=8'h22;
11'h038b:data=8'h21;
11'h038c:data=8'h21;
11'h038d:data=8'h22;
11'h038e:data=8'h1C;
11'h038f:data=8'h00;
11'h0390:data=8'h00;
11'h0391:data=8'hF0;
11'h0392:data=8'h08;
11'h0393:data=8'h08;
11'h0394:data=8'h08;
11'h0395:data=8'h10;
11'h0396:data=8'hE0;
11'h0397:data=8'h00;
11'h0398:data=8'h00;
11'h0399:data=8'h01;
11'h039a:data=8'h12;
11'h039b:data=8'h22;
11'h039c:data=8'h22;
11'h039d:data=8'h11;
11'h039e:data=8'h0F;
11'h039f:data=8'h00;
		endcase
	end
	
endmodule
