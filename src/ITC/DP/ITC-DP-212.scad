// ITC Holder -*- C -*-
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
boardSlot1YEndMM = 6.0;
boardSlot2YStartMM = 19.85;
boardHeightMM = 1.6;
boardBoxClearanceMM = 1.6;  // height from top of board to bottom of engaged box header
boardSolderClearanceMM = 1.5;  // height from bottom of board to top of solder posts
headerWidthMM = in2MM(.2);  // excluding key
headerLengthMM = in2MM(.8);
boxWidthMM = in2MM(.3);    // XXX placeholder
boxLengthMM = in2MM(1.2);  // XXX placeholder
boxGapMM = in2MM(.09);      // XXX placeholder
loopHeightMM = 22.10;
keyWidthMM = 4.0;
interiorPillarWidthMM = 6.5;
grabTabHeightMM = 15.;
grabBridgeHeightMM = -1;
capsuleRadiusMM=5;
capsuleHalfLenMM = 9.7;

keyInDepthFrac = 0.33;
keyInWidthMM = 1.5;


// Derived measurements
boardSlot2YEndMM = boardHeightMM;

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
       halfSlotWidth = slotWidth/2)
  let (BdX = -boardLengthMM/2-0.25,
       CdX = -.25,
       CdY = 0.25,
       DdY = 4.3,
       EdX = 2, 
       EdY = 0.25,
       FdX = 0.9,
       GdX = 0.25,
       GdY = 0.25,
       G1dY = -3.3, // down from loop height
       G2dX = 2.0,   
       I1dX = 5.0, // XXX dependent on slot width
       I2dX = 0.6, // XXX dependent on slot width
       I2dY = -1., 
       JdY = -loopHeightMM-I2dY+3.5,
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
         i1 = [h[0]+I1dX, h[1]],
         i2 = [i1[0]+I2dX, h[1]+I2dY],
         j = [i2[0], i2[1]+JdY],
         k = [-halfSlotWidth, boardBoxClearanceMM+boardHeightMM],
         l = [k[0], boardBoxClearanceMM],
         m = [a[0], l[1]])
//[0][1][2][3][4][5][6] [7] [8][9][10][11][12][13][14][15]
  [a, b, c, d, e, f, g, g1, g2, h, i1, i2,  j,  k,  l,  m];

module keyInSlot(length) {
  cube([keyInWidthMM+.01,length,keyInDepthMM]);
}

module itchLoop(keyin) {
  slotWidthInternal = boardSlotXEndMM - boardSlotXStartMM - 0.2;
  pts = itchLoopPts();
  difference() {
    linear_extrude(height = slotWidthInternal)
      polygon(pts);
    if (keyin) {
      translate([pts[12][0]-keyInWidthMM,pts[13][1],slotWidthInternal-keyInDepthMM]) {
        keyInSlot(pts[10][1]-pts[13][1]);
      }
    }
    translate([0,0,0]) {
      halfKeyWidthMM = keyWidthMM/2;
      keyHeightMM = 0.8;
      translate([-halfKeyWidthMM,0,slotWidthInternal-keyHeightMM]) {
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
  tabWidth = 7.4;
  flangeWidth = 1.85*tabWidth;
  radius = tabWidth/2;
  union() {
    difference() {
      union() {

        // Grab tab
        linear_extrude(height=grabTabHeightMM) {
          difference() {
            union() {
              square([boardLengthMM,tabWidth],center=true);
              // Symmetry-breaking key-out extension
              translate([0,.6,0]) {
                square([keyWidthMM,tabWidth],center=true);
              }
            }
          }
        }

        // Top rounding
        capsule();

        // Base flange
        flangeThickness=7.8;
        difference() {
          linear_extrude(height=flangeThickness) {
            translate([0,0,0]) {
              square([boardLengthMM,.93*boardWidthMM],center=true);
            }
          }
          // Drop arcs on sides for finger clearance
          translate([0.0,10,9]) rotate([90,0,0]) {
            scale([1.8,1.4,1])
            linear_extrude(height=20) 
            arc(.1,4.5,180,-90);
          }
          // And ease the finger arc edges 
          for (i = [-1,1]) {
            translate([i*9.185,10,6.3]) rotate([90,0,0]) {
              scale([i*1.,1.,1])
              linear_extrude(height=20) 
              arc(arcRad,2*arcRad,63,123);
            }
          }

          // ease flange vertical edges
          distanceOut = 6.85;
          for (i = [1,-1]) {
            translate([i*11.3,distanceOut,-1]) rotate([0,0,0]) 
              linear_extrude(height=flangeThickness+2) 
                arc(arcRad,3,90,1*(45+(1-i)/2*90));
            translate([i*11.3,-distanceOut,-1]) rotate([0,0,0]) 
              linear_extrude(height=flangeThickness+2) 
                arc(arcRad,3,90,-1*(45+(1-i)/2*90));
          }
        }
      }
      rotate([90,0,0])
        tabNotch(tabWidth/2);
    }
    linear_extrude(height=grabTabHeightMM-grabBridgeHeightMM) {
      translate([0,0,0]) {
        square([interiorPillarWidthMM,7],center=true);
      }
    }
    fudgeEase = 0.2;
    translate([interiorPillarWidthMM/2-fudgeEase,keyInDepthMM-radius/2-fudgeEase,0]) {
      rotate([90,0,0]) {
        keyInSlot(grabTabHeightMM-grabBridgeHeightMM-6);
      }
    }
  }
}

module capsuleCap() {
  capRadius = .92*capsuleRadiusMM;
  capHalfLen = 1.01*capsuleHalfLenMM;
  difference() {
    union() {
      linear_extrude(height=3.35) {
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
        // Slightly angle the cap wedges to ease insertion
        translate([1.2,3,0]) {
          rotate([0,0,30])
            cube([5,5,6]);
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
#  translate([-cubeX/2,-fudgeY,-zoffset/2]) {
    cube([cubeX,cubeY+fudgeY,cubeZ]);
    translate([-cubeX/2,tabLatchShelfOffset,0]) {
      cube([2*cubeX,10,cubeZ]);
    }
  }
}

$fn=50;
translate([0,10,0]) {
  itch10();
}

thumb10();

translate([0,28,0]) {
  rotate([0,0,90]) {
    capsuleCap(); 
  }
}

