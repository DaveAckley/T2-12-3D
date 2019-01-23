// ITC Data-only / power block -*- C++ -*-
// Copyright (C) 2018-2019 The T2 Tile Project
// Licensed under GPL-3

function in2MM ( vec) = 25.4 * vec;
function max3 ( v ) = max(v[0],v[1],v[2]);

// Base measurements
boardWidthMM = 17.95;
boardLengthMM = 25.6;
boardSlotXStartMM = 7.4;
boardSlotXEndMM = 10.59;
boardSlot1YStartMM = 0.0;
boardSlot1YEndMM = 3.0;
boardSlot2YStartMM = 22;
boardHeightMM = 1.6;
boardBoxClearanceMM = 1.8;  // height from top of board to bottom of engaged box header
boardSolderClearanceMM = 1.5;  // height from bottom of board to top of solder posts
headerWidthMM = in2MM(.2);  // excluding key
headerLengthMM = in2MM(.8);
boxWidthMM = in2MM(.3);    // XXX placeholder
boxLengthMM = in2MM(1.2);  // XXX placeholder
boxGapMM = in2MM(.09);      // XXX placeholder
loopHeightMM = 16.25 + boardSolderClearanceMM;
keyWidthMM = 3.8;
interiorPillarWidthMM = 10.6;

nominalSlotWidth = 3.35;

grabTabHeightMM = 11;
grabBridgeHeightMM = -1;
capsuleRadiusMM=5;
capsuleHalfLenMM = 9.7;
flatWidth = .8*boardWidthMM;
flatHeight = 4;

expandPostPercent=15;
narrowPostPercent=32;
postHoleLength = (100+expandPostPercent)/100*2.85;
postHoleWidth = (100+expandPostPercent)/100*3.1;
postHoleInsertDepth = 7;
postHoleHeight = 14.25;
//postHoleCenterOffset = nominalSlotWidth-postHoleWidth;
postHoleCenterOffset = -.4;

keyInDepthFrac = 0.33;
keyInWidthMM = 1.5;


// Derived measurements
boardSlot2YEndMM = boardHeightMM;

baseplateWidthMM = 2*boxWidthMM + boxGapMM;
baseplateLengthMM = boxLengthMM;
baseplateHeightMM = boardBoxClearanceMM;

halfplateWidthMM = baseplateWidthMM;
halfplateLengthMM = baseplateLengthMM/2;
halfplateHeightMM = baseplateHeightMM;

keyInDepthMM = keyInDepthFrac * (boardSlotXEndMM - boardSlotXStartMM);

arcRad = 1.5;

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

module edgeRounder()
{
  difference() {
    cube(10,10,10);
    translate([-2,-2,-1])
      cylinder(h=12,r=8);
  }
}

module baseplate() {
  cube([baseplateLengthMM, baseplateWidthMM, baseplateHeightMM]);
}

module halfplate() {
  cube([halfplateLengthMM, halfplateWidthMM, halfplateHeightMM]);
}

module throughslot() {
  slotWidth = boardSlotXEndMM - boardSlotXStartMM;
  cube([slotWidth,1,boardHeightMM]);
}

// Build one full end of an itc tab
module tabend() {
  throughslot();
}

module itctab() {
  difference() {
    union() {
      // Basic additions
      baseplate();
      for (ends = [[[0,0,0],0],
                   [[boardWidthMM,boardLengthMM,0],180]]) {
        translate(ends[0]) {
          rotate([0,ends[1],0]) {
            tabend();
          }
        }
      }
    }

    // Basic subtractions
    {
      totalHeadersWidth = 2*headerWidthMM+boxGapMM; // XXX wrong gap
      headerXInset = (boardWidthMM - totalHeadersWidth)/2;
      headerYInset = (boardLengthMM - headerLengthMM)/2;
      translate([headerXInset,headerYInset,0]) {
        cube([headerLengthMM,headerWidthMM,boardBoxClearanceMM]);
      }
      translate([headerXInset,headerYInset+headerWidthMM+boxGapMM,0]) {
        cube([headerLengthMM,headerWidthMM,boardBoxClearanceMM]);
      }
    }
  }
}

// Half the loop running through the slots and under the board
// Polygon points:
//
//        h....i1
//        .      . 
//        .       i2
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
       halfSlotWidth = slotWidth/2,
       kHeight=boardHeightMM+1)
  let (BdX = -boardLengthMM/2-0.25,
       CdX = -.25,
       CdY = 0.25,
       DdY = 2+1.6,
       EdX = 1.25, 
       EdY = 0.75,
       FdX = 1.0,
       GdX = 0.0,
       GdY = 0.25,
       G1dY = -3, // down from loop height
       G2dX = 2.5,   
       I1dX = 3.9, // XXX dependent on slot width
       I2dX = 0.6, // XXX dependent on slot width
       I2dY = -1., 
       JdY = -13)
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
         i1 = [h[0]+I1dX, h[1]],
         i2 = [i1[0]+I2dX, h[1]+I2dY],
         j = [i2[0], i2[1]+JdY],
         k = [-halfSlotWidth, kHeight],
         l = [k[0], boardBoxClearanceMM],
         m = [a[0], l[1]])
//[0][1][2][3][4][5][6] [7] [8][9][10][11][12][13][14][15]
  [a, b, c, d, e, f, g, g1, g2, h, i1, i2,  j,  k,  l,  m];

module itchLoop(keyin) {
  slotWidth = boardSlotXEndMM - boardSlotXStartMM;
  pts = itchLoopPts();
  difference() {
    union() {
      linear_extrude(height = slotWidth)
        polygon(pts);
      narrowedPostWidth = (100-narrowPostPercent)/100*postHoleWidth;
      narrowedPostLength = (100-narrowPostPercent)/100*postHoleLength;
      narrowedPostHeight = boardHeightMM + boardBoxClearanceMM + postHoleInsertDepth;
      if (keyin) {
        translate([-narrowedPostWidth/2,0,0]) {
          union() {
            cube([narrowedPostWidth,narrowedPostHeight,narrowedPostLength]);
            translate([narrowedPostWidth/2,narrowedPostHeight,0])
              cylinder(h=narrowedPostLength,r=narrowedPostWidth/2);
          }
        }
      }
    }
#    for (j = [+1]) {
      scale([1,j,1]) {
        for (i = [-1]) {
          translate([i*12.44,i*-16.6,-2]) {
            rotate([0,0,i*-90])
              scale([.2,.2,1])
              edgeRounder();
          }
        }
      }
    }
    translate([0,0,0]) {
      halfKeyWidthMM = keyWidthMM/2;
      keyHeightMM = 0.7;
      translate([-halfKeyWidthMM,0,slotWidth-keyHeightMM]) {
        cube([halfKeyWidthMM,pts[15][1],3]);
      }
    }
  }
}

module itch10()
{
  scale([1,1,1]) itchLoop(false);
  scale([-1,1,1]) itchLoop(true);

}
module thumb10() {
  slotWidth = boardSlotXEndMM - boardSlotXStartMM;
  tabWidth = 7.8;
//  flangeWidth = 1.85*tabWidth;
  flangeWidth = 0.95*boardWidthMM;
  radius = tabWidth/2;
  union() {
    difference() {
      union() {

        // Grab tab
        linear_extrude(height=grabTabHeightMM) {
          union() {
            translate([-boardLengthMM/2,-tabWidth/2]) {
              square([boardLengthMM,tabWidth]);
            }
          }
        }
        // Symmetry-breaking key-out extension (taller to punch into curveout)
        linear_extrude(height=grabTabHeightMM+1) {
          translate([0,.6,0]) {
            square([keyWidthMM,tabWidth],center=true);
          }
        }

        // Top rounding
       capsule();

        // Base flange
        flangeThickness=7.7;
       difference() {
         linear_extrude(height=flangeThickness) {
           translate([0,0,0]) {
             square([boardLengthMM,.93*boardWidthMM],center=true);
           }
         }

         // Drop arcs on sides for finger clearance
         translate([0.0,10,9]) rotate([90,0,0]) 
           scale([1.8,1.4,1])
           linear_extrude(height=20) 
           arc(.1,4.5,180,-90);
          
         //
         for (j = [-1,+1]) {
           scale([1,j,1]) {
             for (i = [-1,+1]) {
               translate([i*11.7,i*-7.4,-2]) {
                 rotate([0,0,i*-90])
                   scale([.2,.2,1])
                   edgeRounder();
               }
             }
           }
         }
       }

      // raise top of inner pillar
     translate([-(interiorPillarWidthMM+.2)/2,-1.2*nominalSlotWidth/2,grabTabHeightMM]) {
        cube([interiorPillarWidthMM+.2,1.2*nominalSlotWidth,1.1]);
      }


      }

      rotate([90,0,0])
        tabNotches(tabWidth/2);
    }
*    linear_extrude(height=grabTabHeightMM-grabBridgeHeightMM) {
      translate([0,0,0]) {
        square([interiorPillarWidthMM,7],center=true);
      }
    }
  }
}

module capsuleCap() {
  capRadius = .92*capsuleRadiusMM;
  capHalfLen = 1.01*capsuleHalfLenMM;
  slotWidth = boardSlotXEndMM - boardSlotXStartMM;

  difference() {
    union() {
      linear_extrude(height=slotWidth) {
        translate([capHalfLen,-capRadius]) {
          square([capRadius,capRadius]);
        }
        translate([-capHalfLen,-capRadius]) {
          rotate([0,0]) {
            square([2*capHalfLen,2.8*capRadius]);
          }
        }
        translate([-capHalfLen-capRadius,-capRadius]) {
          square([capRadius,capRadius]);
        }
      }
    }
    pillarGap = 1.05*interiorPillarWidthMM;
    pillarGapDrop = -2;
    translate([-pillarGap/2,-capRadius-pillarGapDrop,-1]) {
      cube([pillarGap,12,10]);
    }
    for (i = [-1,1]) {
      scale([i,1,1])
      translate([8.5,-0,-1]) {
        translate([9,0,0])
           cylinder(h=5,r=5);
        translate([-.50,-1.8,0])
          cube([6,10,10]);
        translate([4,3,0]) {
          cube([7,10,10]);
        }
        // Slightly angle the cap wedges to ease insertion
        translate([2.2,3.8,0]) {
          rotate([0,0,45])
            cube([5,8,6]);
        }
      }
    }
  }
}

module capsule() {
  height = grabTabHeightMM;
  flatOverhang = 2;
  length = boardLengthMM + flatOverhang;
  difference() {
    translate([-length/2,-flatWidth/2,height]) {
      cube([length,flatWidth,1.1*flatHeight]);
    }
    for (i = [-1,1]) {
      translate([-length/2,i*(-flatWidth/2-4.2),height/2+2.5]) {
       rotate([0,90,0]) {
          cylinder(h=length,r=8);
        }
      }
      translate([i*(length/2+7),(-flatWidth/2-4.6),height/2+5.2]) {
        rotate([0,90,90]) {
          cylinder(h=length,r=8);
        }
      }
    }
    for (j = [-1,+1]) {
      scale([1,j,1]) {
        for (i = [-1,+1]) {
          translate([i*12.7,i*-6.1,8]) {
            rotate([0,0,i*-90])
              scale([.2,.2,1])
              edgeRounder();
          }
        }
      }
    }
    translate([0,0,height]) {
      cube([2*capsuleHalfLenMM,1.20*nominalSlotWidth,30],center=true);
    }
  }
}

module tabNotches(zoffset) {
  cubeX = 5;
  //  cubeY = loopHeightMM;
  cubeY = 3;
  //  cubeZ = zoffset;
  cubeZ = 1.20*nominalSlotWidth;
  fudgeY = 1;
  tabLatchShelfOffset = 9.5;
  // Center post hole
  translate([0,0,postHoleCenterOffset])
    cube([postHoleLength,postHoleHeight,postHoleWidth],center=true);
  translate([-cubeX/2,0,0])
  for (i = [1, -1]) {
    translate([i*((boardLengthMM-cubeX)/2),-fudgeY,-zoffset/2]) {
      cube([cubeX,cubeY+fudgeY,cubeZ]);
      translate([cubeX/2,4.2,cubeZ/2]) {
        rotate([0,0,i*-45]) {
          cube([cubeX,2.6,cubeZ],center=true);
        }
      }
      translate([-cubeX/2,tabLatchShelfOffset,0]) {
        cube([2*cubeX,10,cubeZ]);
      }
      translate([-i*cubeX/2,0,0]) {
        cube([1*cubeX,25,cubeZ]);
      }
    }
  }
}

$fn=50;
translate([0,13,0]) {
  itch10();
}

thumb10();

translate([0,-18,0]) {
  rotate([0,0,180]) {
    capsuleCap(); 
  }
}

*translate([10,10,10]) edgeRounder();
