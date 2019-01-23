// ITC Power Plug          -*- C++ -*-
function in2MM ( vec) = 25.4 * vec;
function max3 ( v ) = max(v[0],v[1],v[2]);

// Base measurements
boardWidthMM = 17.95;
boardLengthMM = 25.6;
boardSlotXStartMM = 7.4;
boardSlotXEndMM = 10.59;
boardSlot1YStartMM = 0.0;
boardSlot1YEndMM = 6.0;
boardSlot2YStartMM = 19.85;
boardHeightMM = 1.6;
boardBoxClearanceMM = 1.8;  // height from top of board to bottom of engaged box header
boardSolderClearanceMM = 1.5;  // height from bottom of board to top of solder posts
headerWidthMM = in2MM(.2);  // excluding key
headerLengthMM = in2MM(.8);
boxWidthMM = in2MM(.3);    // XXX placeholder
boxLengthMM = in2MM(1.2);  // XXX placeholder
boxGapMM = in2MM(.09);      // XXX placeholder
loopHeightMM = 11.00;
fingerHeightMM = 22.10;
keyWidthMM = 4.0;
interiorPillarWidthMM = 6.5;
grabTabHeightMM = 15.;
grabBridgeHeightMM = -1;
capsuleRadiusMM=5;
capsuleHalfLenMM = 9.7;

keyInDepthFrac = 1.0;
keyInWidthMM = 0.80;


// Derived measurements
boardSlot2YEndMM = boardHeightMM;
slotWidth = boardSlot2YStartMM - boardSlot1YEndMM;
halfSlotWidth = slotWidth/2;

keyInDepthMM = keyInDepthFrac * (boardSlotXEndMM - boardSlotXStartMM);

$fn=32;

// arc module based on code by chickenchuck040, licensed under CC-BY,
// found at http://www.thingiverse.com/thing:1092611
module arc(radius, thick, angle,start_angle){
  rotate([0,0,start_angle])
    intersection(){
    union(){
      rights = floor(angle/90);
      remain = angle-rights*90;
      if(angle > 90){
        for(i = [0:rights-1]){
          rotate(i*90-(rights-1)*90/2){
            polygon([[0, 0], 
                     [radius+thick, (radius+thick)*tan(90/2)], 
                     [radius+thick, -(radius+thick)*tan(90/2)]]);
          }
        }
        rotate(-(rights)*90/2)
          polygon([[0, 0], 
                   [radius+thick, 0], 
                   [radius+thick, -(radius+thick)*tan(remain/2)]]);
        rotate((rights)*90/2)
          polygon([[0, 0], 
                   [radius+thick, (radius+thick)*tan(remain/2)], 
                   [radius+thick, 0]]);
      }else{
        polygon([[0, 0], 
                 [radius+thick, (radius+thick)*tan(angle/2)], 
                 [radius+thick, -(radius+thick)*tan(angle/2)]]);
      }
    }
    difference(){
      circle(radius+thick);
      circle(radius);
    }
  }
}

module throughslot() {
  slotWidth = boardSlotXEndMM - boardSlotXStartMM;
  cube([slotWidth,1,boardHeightMM]);
}

// Build one full end of an itc tab
module tabend() {
  throughslot();
}

// Half the loop running through the slots and under the board
// Polygon points:
//
//        h.......i
//        .       .
//       g2...g1  .
//            .   .
//            .   .
//            .   .
//            .   .
//            .   .
//            .   .
//            g   .
//           .    .
//     e....f     .
//    .           .
//   d            .
//   .            j
//   .           .
//   .          k
//   .          .
//   .          l...........m
//   c                      .
//    .                     .
//     b....................a
//

function itchLoopPts() =
  let (slotWidth = boardSlot2YStartMM-boardSlot1YEndMM,
       halfSlotWidth = slotWidth/2)
  let (BdX = -boardLengthMM/2-0.25,
       CdX = -.25,
       CdY = 0.25,
       DdY = 4.3,
       EdX = 2, 
       EdY = 0.25,
       FdX = 0.5,
       shaftThinnerHack = 1,
       GdX = 0.25+shaftThinnerHack,
       GdY = 0.25,
       G1dY = -3, // down from loop height
       G2dX = 1.5,   
       IdX = 5.6-shaftThinnerHack, // XXX dependent on slot width
       JdY = -loopHeightMM+3.5,
       KdY = -0.25)
  let (a = [0,0],
       b = [a[0]+BdX, a[1]],
       c = [b[0]+CdX, b[1]+CdY],
       d = [c[0], c[1]+DdY],
       e = [d[0]+EdX, d[1]+EdY],
       f = [e[0]+FdX, e[1]],
       g = [f[0]+GdX, f[1]+GdY],
       g1 = [g[0], loopHeightMM+G1dY],
       g2 = [g1[0]-G2dX, g1[1]],
       h = [g2[0], loopHeightMM],
       i = [h[0]+IdX, h[1]],
       j = [i[0], i[1]+JdY],
       k = [-halfSlotWidth, boardBoxClearanceMM+boardHeightMM],
       l = [k[0], boardBoxClearanceMM],
       m = [a[0], l[1]])
  //[0][1][2][3][4][5][6] [7] [8][9][10][11][12][13][14]
  [a, b, c, d, e, f, g, g1, g2, h,  i,  j,  k,  l,  m];

module keyInSlot(length) {
  pts = itchLoopPts();
  cube([keyInWidthMM+.01,length,keyInDepthMM]);
}

module itchLoop(keyin) {
  slotWidth = boardSlotXEndMM - boardSlotXStartMM;
  pts = itchLoopPts();
  difference() {
    linear_extrude(height = slotWidth) {
      polygon(pts);
    }
    if (keyin) {
      translate([pts[11][0]-keyInWidthMM,pts[12][1],slotWidth-keyInDepthMM]) {
        keyInSlot(pts[10][1]-pts[12][1]);
      }
    }
#    translate([0,0,0]) {
      halfKeyWidthMM = keyWidthMM/2;
      keyHeightMM = 0.6;
      translate([-halfKeyWidthMM,0,slotWidth-keyHeightMM]) {
        cube([halfKeyWidthMM,pts[14][1],3]);
      }
    }
  }
}

module itch10()
{
  scale([1,1,1]) itchLoop(false);
  scale([-1,1,1]) itchLoop(true);
}

//// Cubist WireSnake segments
function snakeShafts(shaftRW) =
  [ // w, l, h, x, y
   [9,   5,   shaftRW,    -5.,    0],    // Base wire inlet from board soldering
   [4,   3,   shaftRW,    1.25,    2.5],       // First horizontal
   [3.5,   9,   shaftRW,    2.0,    4],     // First riser
   [6.5,   3,   shaftRW,    -0.9,    11.75],   // Second horizontal
   [3.5,   5,   shaftRW,    -3.0,    8.5],    // First sinker
   [5,   3.5,   shaftRW,    -5.2,    7],      // Third horizontal
   [3.3,   10.0,   shaftRW, -7.8,    8],      // Second riser
   [14,  2.7,   shaftRW,    -6,   16.25],      // Final horizontal
   [2.5,   6.0,   shaftRW, 7.2,   16.25],      // Final riser
    ];

/*
  
  shaft0Width = 6;
  shaft0Thickness = 7;
  shaft0Height = 2.5;

  shaft1Width = 2.75;
  shaft1Thickness = 6;
  shaft1Height = 12;

  shaft2Width = 7.5;
  shaft2Thickness = 7;
  shaft2Height = 2.75;

  shaft3Width = 2.75;
  shaft3Thickness = 7;
  shaft3Height = 7;
  shaft3X = 4.5;
  shaft3Y = 7;

  shaft4Width = 4;
  shaft4Thickness = 7;
  shaft4Height = 3;
  shaft4X = 5;
  shaft4Y = 4;
*/

module asymmetricWireSnake(snakeDepth) {

  union() {
    for (shaft = snakeShafts(snakeDepth)) {
      translate([shaft[3],shaft[4],0]) {
        cube([shaft[0],shaft[1],shaft[2]]);
      }
    }
  }
}

module smoothSnake(h) {
  translate([0,0,0]) {
    linear_extrude(height=h) {
      r=.9;
      thick=3.2;
      angle1=180;
      angle2=90;
      // Main cavity (first horizontal)
      translate([-5.1,0]) square([10.4,5]);
      // First riser
      translate([2.1,5]) square([3.2,6.0]);
      translate([1.2,0]) {
        // First arc
        translate([0,11]) {  arc(r,thick,angle1,90);    }
        
        // First sinker
        translate([-4.1,9.74]) square([3.2,1.26]);

        // Second arc
        translate([-2*r-thick,9.75]) {  arc(r,thick,angle1,angle1+angle2);    } 
        
        // Second riser
        translate([-9.1,9.75]) square([3.2,3.6]);

        // Third arc
        translate([-3.2,13.3]) {  arc(2.7,thick,90,45+90);    } 

        //Second horizontal
        translate([-3.2,16]) square([12,thick]);

        // Third riser (exit relief)
        translate([5.9,16.0]) square([3.0,6.6]);

        // Fourth arc (exit relief)
        translate([4.4,20.68]) { arc(1.48,thick,180,0);    } 

        // Fifth arc (exit relief)
        translate([7.7,15.2]) { arc(.8,2,90,45);    } 


      }
    }
  }
}

flangeRadius = 3.1;
flangeThickness = 7;
tabWidth = boardLengthMM - 2*flangeRadius;
tabLength = fingerHeightMM;
tabHeight = boardWidthMM/2;
keyAntislotWidth = 4;
keyAntislotThickness = 0.3;

arcRad = 1.5;
module pwrtab10() {
  // tab body, center cut face down on build plate
  // length = full board length - 2 * cinch strap thickness
  // width = full tab height (loopHeightMM)
  // height = half board width + offsetToSlotEdge

  difference() {
    union() {
      difference() {
        cube([tabWidth,tabLength,tabHeight]);
        // Ease the edges by hand urrrgh
        // Top width corner
        translate([tabWidth,tabLength,tabHeight]) {
        translate([0,-arcRad,-arcRad]) {
          rotate([0,-90,0])
            { linear_extrude(height=tabWidth) arc(arcRad,3,90,45); } } }

        // Top right corner
        translate([tabWidth,tabLength,0]) {
        translate([1,-8.6,-1]) {
          rotate([0,0,26])
            //            { linear_extrude(height=tabHeight) arc(arcRad,2,90,45); } } }
            { linear_extrude(height=2*tabHeight) square([10,15]); } } }

        // Top right corner 2
        translate([tabWidth,tabLength,0]) {
        translate([-3.9,-1.5,-1]) {
          rotate([0,0,0])
            { linear_extrude(height=2*tabHeight) arc(arcRad,2,90,45); } } }

        // Top left corner
        translate([0,tabLength,0]) {
        translate([arcRad,-arcRad,0]) {
          rotate([0,0,0])
            { linear_extrude(height=tabHeight) arc(arcRad,2,90,180-45); } } }

        // Left edge
        translate([0,tabLength,tabHeight]) {
        translate([arcRad,0,-arcRad]) {
          rotate([90,0,0])
            { linear_extrude(height=tabWidth) arc(arcRad,2,90,180-45); } } }

        // right edge
        translate([tabWidth,tabLength,tabHeight]) {
        translate([-arcRad,0,-arcRad]) {
          rotate([90,0,0])
            { linear_extrude(height=tabWidth) arc(arcRad,2,90,45); } } }

      }
#      difference() {
        translate([-flangeRadius,0,0]) {
//          echo("WIFF",boardWidthMM/2+flangeRadius);
          cube([boardLengthMM,flangeThickness,boardWidthMM/2+flangeRadius]);
        }
        // flange long edge
        *translate([-flangeRadius,tabHeight,flangeThickness]) {
        translate([0,-3,4.05]) {
          rotate([0,90,0])
            { linear_extrude(height=boardLengthMM) arc(1.06,1,90,180-45); } } }

        // flange top left edge
        *translate([boardLengthMM,tabHeight,0]) {
        translate([-4.12,-3.0,.0]) {
          rotate([0,0,0])
            { linear_extrude(height=boardWidthMM/2+flangeRadius) arc(1.06,1,90,0+45); } } }

        // flange top right edge
        *translate([0,tabHeight,0]) {
        translate([-2.07,-3.0,.0]) {
          rotate([0,0,0])
            { linear_extrude(height=boardWidthMM/2+flangeRadius) arc(1.06,1,90,180-45); } } }


        // flange side right edge
        translate([0,tabHeight,10]) {
        translate([-arcRad-.1,.0,.6]) {
          rotate([90,0,0])
            { linear_extrude(height=boardWidthMM/2+flangeRadius) arc(arcRad,2,90,180-45); } } }

        // flange side left edge
        translate([tabLength,tabHeight,10]) {
        translate([-arcRad+.4,.0,0.6]) {
          rotate([90,0,0])
            { linear_extrude(height=boardWidthMM/2+flangeRadius) arc(arcRad,1,90,90-45); } } }
      }
      translate([tabWidth/2-keyAntislotWidth/2,0,tabHeight]) {
        cube([keyAntislotWidth,tabLength-2,keyAntislotThickness]);
      }
    }
    translate([tabWidth/2,0,0]) {
      //asymmetricWireSnake(6.5);
      smoothSnake(6.5);
    }
    enlargeBy = 0.320;
    endeepenBy = 1.75;
    for (z = [0,endeepenBy]) {
      translate([9.7,-6,z+3]) {
        rotate([180,0,180]) {
          //          itch10();
          translate([enlargeBy,0,0]) itch10();
          translate([-enlargeBy,0,0]) itch10();
          translate([0,enlargeBy,0]) itch10();
          translate([0,-enlargeBy,0]) itch10();
        }
      }
    }       
  }
}

coverThickness = 3;
snakeDepth = .9;

module pwrmate10() {
  difference() {
    union() {
      difference() {
        cube([tabWidth,tabLength,coverThickness]);
        // cover side left edge
        translate([tabWidth,24,0]) {
        translate([-arcRad,0,arcRad]) {
          rotate([90,0,0])
            { linear_extrude(height=18) arc(arcRad,1,90,-45); } } }

        // cover side right edge
        translate([0,24,0]) {
        translate([arcRad,0,arcRad]) {
          rotate([90,0,0])
            { linear_extrude(height=18) arc(arcRad,1,90,180+45); } } }

        // cover long edge
        translate([0,tabLength,0]) {
        translate([0,-arcRad,arcRad]) {
          rotate([0,90,0])
            { linear_extrude(height=20) arc(arcRad,1,90,0+45); } } }

        // cover right top edge
        translate([0,tabWidth-.3,0]) {
        translate([arcRad,arcRad,0]) {
          rotate([0,0,0])
            { linear_extrude(height=20) arc(arcRad,1,90,180-45); } } }

        // cover left top edge
        translate([tabWidth,tabLength,0]) {
        translate([-arcRad,-arcRad,0]) {
          rotate([0,0,0])
            { linear_extrude(height=21) arc(arcRad,1,90,+45); } } }

      }
      translate([-flangeRadius,0,0]) {
        cube([boardLengthMM,flangeThickness,coverThickness]);
      }
      intersection() {
        difference() {
          cube([tabWidth,tabLength,2*coverThickness]); // crop at cover xy boundaries

          // cover left top edge extended for cropping
          translate([tabWidth,tabLength,0]) {
            translate([-arcRad,-arcRad,0]) {
              rotate([0,0,0])
                { linear_extrude(height=21) arc(arcRad,1,90,+45); } } }
        }
        shift = 0.5;
        intersection_for (off 
                          = [[0,shift],
                             [0,-shift],
                             [shift,0],
                             [-shift,0]]) {
          translate([tabWidth/2+off[0],off[1],coverThickness]) {
            //asymmetricWireSnake(snakeDepth);
            smoothSnake(snakeDepth);
          }
        }
      }


      // Just spot little cubes to drive the strap arms down
      cubeIndentX = 1.2;
      cubeIndentY = 1.2;
      cubeEdge = 1.6;
      translate([cubeIndentX,cubeIndentY,coverThickness]) {
        cube([cubeEdge,cubeEdge,snakeDepth]);
      }
      translate([tabWidth-cubeIndentX-cubeEdge,cubeIndentY,coverThickness]) {
        cube([cubeEdge,cubeEdge,snakeDepth]);
      }
    }

        // cover side left corner cut
        translate([tabWidth-2.4,24,0]) {
        translate([-arcRad,0,0]) {
          rotate([90,0,26])
            { linear_extrude(height=50) square([15,10]); } } }

  }
}

tabLoopWidthMM = flangeRadius;

module pwrloop10() {
  fullTabLoopLength = boardLengthMM;
  fullTabLoopWidth = coverThickness+tabHeight+2*tabLoopWidthMM;
  loopThicknessMM = 2.5;
  difference() {
    translate([-tabLoopWidthMM,0,0]) {
      cube([fullTabLoopLength,fullTabLoopWidth,loopThicknessMM]);
      translate([0,0,loopThicknessMM]) {
        cube([fullTabLoopLength,tabLoopWidthMM,flangeThickness]);
      }
    }
    
    union() {
      // Ease loop edges by hand urrrgh

      // Right tall
      *translate([fullTabLoopLength,0,0]) {
        translate([-3*arcRad,arcRad,-8]) {
          rotate([0,0,-90])
            { linear_extrude(height=tabWidth) arc(arcRad,3,90,45); } 
        }
      }

      // left tall
      *translate([0,0,0]) {
        translate([-arcRad-.1,arcRad,-8]) {
          rotate([0,0,-90])
            { linear_extrude(height=tabWidth) arc(arcRad,3,90,-45); } 
        }
      }

      // left short
      translate([0,fullTabLoopWidth,0]) {
        translate([-arcRad-.1,-arcRad,-8]) {
          rotate([0,0,-90])
            { linear_extrude(height=tabWidth) arc(arcRad,3,90,180+45); } 
        }
      }

      // right short
      translate([fullTabLoopLength,fullTabLoopWidth,0]) {
        translate([-3*arcRad-0.1,-arcRad,-8]) {
          rotate([0,0,-90])
            { linear_extrude(height=tabWidth) arc(arcRad,3,90,90+45); } 
        }
      }

      // short bottom long
      translate([-1,fullTabLoopWidth,0]) {
        translate([-2*arcRad,-arcRad,arcRad]) {
          rotate([0,90,0])
            { linear_extrude(height=fullTabLoopLength+2.0) arc(arcRad,3,90,+45); } 
        }
      }

      // long bottom long
      translate([-1,0,0]) {
        translate([-2*arcRad,arcRad,arcRad]) {
          rotate([0,90,0])
            { linear_extrude(height=fullTabLoopLength+2.0) arc(arcRad,3,90,-45); } 
        }
      }

      // right bottom short
      translate([0,fullTabLoopWidth,0]) {
        translate([-arcRad-.1,arcRad,arcRad]) {
          rotate([90,0,0])
            { linear_extrude(height=fullTabLoopWidth+2.0) arc(arcRad,3,90,180+45); } 
        }
      }

      // left bottom short
      translate([fullTabLoopLength,fullTabLoopWidth,0]) {
        translate([-3*arcRad,arcRad,arcRad]) {
          rotate([90,0,0])
            { linear_extrude(height=fullTabLoopWidth+2.0) arc(arcRad,3,90,0-45); } 
        }
      }

      // left long vertical
      translate([-.1,0,0]) {
        translate([-arcRad+0.0,arcRad-0.01,-8]) {
          rotate([0,0,-90])
            { linear_extrude(height=tabWidth) arc(arcRad,3,90,-45); } 
        }
      }

      // right long vertical
      translate([fullTabLoopLength,0,0]) {
        translate([-3*arcRad-0.095,arcRad-0.01,-8]) {
          rotate([0,0,-90])
            { linear_extrude(height=tabWidth) arc(arcRad,3,90,+45); } 
        }
      }


      translate([tabWidth/2-keyAntislotWidth/2,fullTabLoopWidth-tabLoopWidthMM,0]) {
        cube([keyAntislotWidth,keyAntislotThickness,loopThicknessMM]);
      }

      fudgeX = .4;
      fudgeY = .4;
      translate([-fudgeX/2,tabLoopWidthMM-fudgeY/2,0]) {
        cube([fullTabLoopLength-2*tabLoopWidthMM+fudgeX,
              coverThickness+tabHeight+fudgeY,
              loopThicknessMM]);
      }
    }
  }
}

module capsuleCap() {
  capRadius = .92*capsuleRadiusMM;
  capHalfLen = 1.01*capsuleHalfLenMM;
  difference() {
    union() {
      linear_extrude(height=4) {
        translate([capHalfLen,0]) {
          circle(r=capRadius);
        }
        translate([-capHalfLen,-capRadius]) {
          rotate([0,0]) {
            square([2*capHalfLen,2*capRadius]);
          }
        }
        translate([-capHalfLen,0]) {
          circle(r=capRadius);
        }
      }
    }
    pillarGap = 1.10*interiorPillarWidthMM;
    pillarGapDrop = -2;
    translate([-pillarGap/2,-capRadius-pillarGapDrop,-1]) {
      cube([pillarGap,12,10]);
    }
    for (i = [-1,1]) {
      scale([i,1,1])
      translate([5,-2,-1]) {
        cube([7,10,10]);
        translate([4,3,0]) {
          cube([7,10,10]);
        }
      }
    }
  }
}

module capsule() {
  height = grabTabHeightMM;
  translate([capsuleHalfLenMM,0,height]) {
    sphere(r=capsuleRadiusMM);
  }
  translate([-capsuleHalfLenMM,0,height]) {
    rotate([0,90,0]) {
      cylinder(h=2*capsuleHalfLenMM,r=capsuleRadiusMM);
    }
  }
  translate([-capsuleHalfLenMM,0,height]) {
    sphere(r=capsuleRadiusMM);
  }
}

module tabNotch(zoffset) {
  cubeX = 20.6;
  cubeY = loopHeightMM;
  cubeZ = zoffset;
  fudgeY = 1;
  tabLatchShelfOffset = 14.2;
  translate([-cubeX/2,-fudgeY,-zoffset/2]) {
    cube([cubeX,cubeY+fudgeY,cubeZ]);
    translate([-cubeX/2,tabLatchShelfOffset,0]) {
      cube([2*cubeX,10,cubeZ]);
    }
  }
}

translate([10,-15,0]) {
      itch10();
}

pwrtab10();

translate([30,0,0]) {
  pwrmate10();
}

translate([50,-2,0]) {
  rotate([0,0,180]) {
    pwrloop10();
  }
}





