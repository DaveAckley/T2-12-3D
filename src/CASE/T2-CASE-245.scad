// T2-12-12+ case -*- C++ -*-
// Copyright (C) 2018-2019 The T2 Tile Project
// Licensed under GPL-3

echo("This is going to take a while");
echo( BUILD_TIME_STAMP );
function in2MM ( vec) = 25.4 * vec;
function max3 ( v ) = max(v[0],v[1],v[2]);
function easeRadius ( vec, pct) = pct * max3(vec) / 100;

// Master offsets for mounting hole positions
m3HoleShiftXMM = -1.0;
m3HoleShiftYMM = 2.0;

m3ScrewHoleDiameterMM=3.4 + 0.1;  // According to internet, plus 0.1
m3ScrewHoleRadiusMM=m3ScrewHoleDiameterMM/2;
m3ScrewHeadDiameterMM=5.5 + 0.2;  // 5.5: socket cap; 5.6: narrow 'cheese head'; 5.7: also? socket cap; 6: philips
m3ScrewHeadRadiusMM=m3ScrewHeadDiameterMM/2;
m3ScrewHeadCountersinkDepthMM=3.0 + 0.1;  // Makes 25mm screw into 28mm

m3MountingHoleOffsetsMM =
  [ // X      Y
   [  4.83,  4.76], //NE
   [105.12,  4.77], //NW
   [  4.81, 80.15], //SE
   [105.16, 80.21] // SW
   ];
                           
////
// Base measurements
//
postHeightInches = .92;  //Standing height above mainboard
postDepthInches = .2;    // Post 'feet' depth below top of mainboard
switchHeightInches = .13; // Height of tact switch above mainboard

boardShrinkInches=0.04;
//boardShrinkInches=0.05;

//We're indenting the board by boardShrinkInches" all around x and y
//to provide more ITC clearance, but then shrinking the shroud side
//walls and moving the main posts outward to compensate.

fullboardDimInches = [4.327, 3.342, 0.062];
boardDimInches = fullboardDimInches-2*[boardShrinkInches, boardShrinkInches, 0];
boardEasePct = 3.6;


mainPostOutsetInches = 0;
carveOutOutsetInches = -0.50;
coneCarveOutOutsetInches = 0.09;
fullpostOffsetInches = [0.112, 0.112, -postHeightInches];
postOffsetInches = fullpostOffsetInches+[boardShrinkInches, boardShrinkInches, 0];

extraBoardDepthInches = .01;

displayDimInches = [3.390, 2.235, 0.218];
displayOffsetInches = [0.410, 0.658, .0];  // Lower left corner offset relative to board
//displayOffsetInches = [0.410, 0.670, .0];  // Lower left corner offset relative to board
//displayOffsetInches = [0.410, 0.700, .0];  // Lower left corner offset relative to board
displayEasePct = .1;
displayVizDimInches = [2.957, 2.008, 0.025];
displayVizOffsetInches = [0.257, 0.087, -.044];   // Lower left corner offset relative to display

// Shrouded 2x8 0.1" pin header with polarizing key
//  pinHeaderFootprintInches = [.945, .285]
fullpinHeaderDimInches = [1.16, 0.355, 0.360];
//fullpinHeaderDimInches = [1.12, 0.355, 0.345];
pinHeaderDimInches = fullpinHeaderDimInches-[0, boardShrinkInches, 0];

pinHeaderWallThicknessInches = 0.04;
pinHeaderKeyWidthInches = 0.175;
pinHeaderKeyOffsetInches = [0.47, 0, pinHeaderWallThicknessInches]; // Relative to pinHeaderDimInches

// Shrouded header positions and rotations
pinHeaderInfoInches =
  [
   //0DX   1DY  2ROT 3KY 4RE+ 5RE-   RE->RoundEdge
   [2.49,   0.0,   0,  1,  1,  1],     // NE_FRED: dx, dy, rot, keyside (1==key-in-wall, 0==no-key-in-wall)
   [0.53,   0.0,   0, 0, 1, 1],     // NW_GINGER: dx, dy, rot, keyside
   [-0.25-pinHeaderDimInches[0], 0.0, -90, 0, 1, 1],     // WT_GINGER: dx, dy, rot, keyside
   [+0.25, -boardDimInches[0],  90, 1, 1, 1],     // ET_FRED: dx, dy, rot, keyside
   [-boardDimInches[0]+0.385,   -boardDimInches[1],   180, 1, 1, 1],     // SE_FRED: dx, dy, rot, keyside
   [-boardDimInches[0]+2.87,  -boardDimInches[1],   180, 0, 1, 0],     // SW_GINGER: dx, dy6, rot, keyside
   ];

// 1x6 debug uart
// + open sky for the light sensor
fullDebugHeaderDimInches = [0.83, 0.22, 0.12];
debugHeaderDimInches = fullDebugHeaderDimInches-[0, boardShrinkInches, 0];

debugHeaderWallThicknessInches = 0.04;
debugHeaderInfoInches =
  [
   [+2.06, -boardDimInches[0],  90]     // Debug header east: dx, dy, rot
   ];

// curtain walls
curtainWallThicknessInches = 0.034;
curtainWallExtraOutsetInches = 0.01;
curtainWallHeightInches = postHeightInches-0.03;
curtainWallInfoInches =
  [
   // South curtain wall: x, y, len, rot, emboss, atscale, erot, font
   [1.365, boardDimInches[1]-curtainWallThicknessInches+curtainWallExtraOutsetInches, 1.355, 0, 
    "MFM", 1.25, 17.1, 9.1, "BitStream Vera Sans Mono:style=bold"], 
   [boardDimInches[0]-.15-.24, boardDimInches[1]-curtainWallThicknessInches, 0.24, 0], // South east curtain wall: x, y, len, rot
   [0.15, boardDimInches[1]-curtainWallThicknessInches, 0.067, 0], // South west curtain wall: x, y, len, rot
   [1.68, 0.001, .81, 0],     // North curtain wall: x, y, len, rot
   [0.15, 0, .399, 0],     // North west curtain wall: x, y, len, rot
   [boardDimInches[0]-.46-.15, 0, .46, 0],     // North east curtain wall: x, y, len, rot
   [-2.15, boardDimInches[0]-curtainWallThicknessInches, .83, -90, 
    "T2", 1.25, 10.4, 8.6, "Impact"],     // East curtain wall: x, y, len, rot
   [0.15, -boardDimInches[0], .104, 90],     // East north curtain wall: x, y, len, rot
   [boardDimInches[1]-.23-.15, -boardDimInches[0], .23, 90],     // East south curtain wall: x, y, len, rot
   [-boardDimInches[1]+.15, 0, 1.15, -90],     // West curtain wall: x, y, len, rot
   [0.15, -curtainWallThicknessInches, .101, 90],     // West north curtain wall: x, y, len, rot
   [.0, 1.963, .38, 0],     // West enet entry curtain wall: x, y, len, rot

   [4.01, boardDimInches[1]-curtainWallThicknessInches+0.1177, .08, 0], // SE blocking wall curtain, S face
   [3.11, -boardDimInches[0], .12, 90],     // SE blocking wall curtain, E face

   [.03, -boardDimInches[0], .12, 90],     // NE blocking wall curtain, E face

   [-boardDimInches[1]+2.2, 0.0001, 1.05, -90],     // NW blocking wall curtain, W face

   [-3.24, 0.000, .15, -90],     // SW blocking wall curtain, W face
   ];


////
// Info for the pushbutton shafts and the trapped pushbuttons

buttonShaftInfoInches =
  [ // X    Y    DIAMETER
   [ 1.96, 3.11], // wake button
   [ 0.14, 2.71], // pwr button
   ];
buttonShaftHoleThicknessInches = 0.16;
buttonShaftWallThicknessInches = 0.035;
buttonShaftLengthInches = postHeightInches - switchHeightInches;
buttonSurfaceProtrusionInches = 0.13;

buttonShaftDiameterInches = 0.80 * buttonShaftHoleThicknessInches;

buttonPlateDiameterMM=in2MM(0.24);
buttonPlateThicknessMM=in2MM(0.06);

buttonLockXOffsetMM = 1.3;
buttonLockZOffsetMM = 8.0;
buttonLockEdgeMM = 2;

//// Power LED light pipe seats
glowHoleInfoInches =
  [
   [2.36, .13,  0.99*(1/8.0)], // +-few% off 1/8"  Not sure why the two holes don't print
   [0.14, 2.35, 1.01*(1/8.0)], // +-few% off 1/8" the same!  W runs tighter than N!
   ];
glowHoleDepthInches = 0.1;
glowHoleBoxInches = [0.2, 0.2, 2.27, .09];

////
// Derived measurements
boardDimMM = in2MM(boardDimInches);
extraBoardDepthMM = in2MM(extraBoardDepthInches);


mainPostOutsetMM = in2MM(mainPostOutsetInches);
carveOutOutsetMM = in2MM(carveOutOutsetInches);
coneCarveOutOutsetMM = in2MM(coneCarveOutOutsetInches);
postOffsetMM = in2MM(postOffsetInches);
postHeightMM = in2MM(postHeightInches);
postDepthMM = in2MM(postDepthInches);
displayDimMM = in2MM(displayDimInches);
displayOffsetMM = in2MM(displayOffsetInches);
displayVizDimMM = in2MM(displayVizDimInches);
displayVizOffsetMM = in2MM(displayVizOffsetInches);
//displayVizOffsetMM = [0,0,-.2];

//// Face perforation data
// size and rotation of perforations
perforationEdge1MM = 110/12;
perforationEdge2MM = 85/12;
perforationIndentMM = 1.3;
perforationRotationDegrees = 90-50.6;
perforationInfoMM =
  //  SX     SY    IX    IY    WD    HT    ROT
  // [0]    [1]   [2]   [3]   [4]   [5]    [6]
  [   perforationEdge1MM,
      perforationEdge2MM,
      perforationIndentMM,
      perforationIndentMM,
      perforationEdge1MM-2*perforationIndentMM,
      perforationEdge2MM-2*perforationIndentMM,
      perforationRotationDegrees];

//Perforation bounds
perfOutMinXMM = 9.5;
perfOutMinYMM = 9.2;
perfOutMaxXMM = 99.0;
perfOutMaxYMM = 74.0;

perfInnerBezelMM = 2;

perfInMinXMM = displayOffsetMM[0] + displayVizOffsetMM[0] - perfInnerBezelMM;
perfInMinYMM = displayOffsetMM[1] + displayVizOffsetMM[1] - perfInnerBezelMM;
perfInMaxXMM = displayOffsetMM[0] + displayVizOffsetMM[0] + displayVizDimMM[0] + perfInnerBezelMM;
perfInMaxYMM = displayOffsetMM[1] + displayVizOffsetMM[1] + displayVizDimMM[1] + perfInnerBezelMM;

// Rectangles to scaffold-perforate within
perforationZonesMM =
  [//X             Y              W                             H
   [perfOutMinXMM, perfOutMinYMM, perfInMinXMM - perfOutMinXMM, perfOutMaxYMM - perfOutMinYMM], // W 
   [perfInMinXMM,  perfOutMinYMM, perfOutMaxXMM - perfInMinXMM, perfInMinYMM - perfOutMinYMM ], // S
   [perfInMinXMM,  perfInMaxYMM,  perfOutMaxXMM - perfInMinXMM, perfOutMaxYMM - perfInMaxYMM ], // N
   [perfInMaxXMM,  perfInMinYMM,  perfOutMaxXMM - perfInMaxXMM, perfInMaxYMM - perfInMinYMM ]   // E
   ];


throughBoardMM = .98*1.6; // board thickness less 2% to snug up

pinHeaderDimMM = in2MM(pinHeaderDimInches);
pinHeaderWallThicknessMM = in2MM(pinHeaderWallThicknessInches);
pinHeaderKeyWidthMM = in2MM(pinHeaderKeyWidthInches);
pinHeaderKeyOffsetMM = in2MM(pinHeaderKeyOffsetInches);


faceplateMM = [boardDimMM[0], boardDimMM[1], displayDimMM[2] + displayVizDimMM[2] + extraBoardDepthMM];
displaySupportDimMM = 1.1*displayDimMM;

// postRadiusMM = easeRadius(faceplateMM, boardEasePct);
postRadiusMM = 4.5;
belowBoardMM = 4;

manyMM = 5000; // A large value for object dimensions used in subtractions

module edgeRounder()
{
  difference() {
    cube(10,10,10);
    translate([-2,-2,-1])
      cylinder(h=12,r=8);
  }
}


module keyedPinHeader()
{
  thick = pinHeaderWallThicknessMM;
  ix = pinHeaderDimMM[0] - 2*thick;
  iy = pinHeaderDimMM[1] - 2*thick;
  iz = pinHeaderDimMM[2] - 1*thick;  //open on top..
  kox = pinHeaderKeyOffsetMM[0];
  koy = pinHeaderKeyOffsetMM[1]-0.01;
  koz = pinHeaderKeyOffsetMM[2];
  difference() {
    cube(pinHeaderDimMM);
    translate([thick, thick, thick])
      cube([ix,iy,iz+0.01]);
    translate([kox,koy,koz])
      linear_extrude(height=pinHeaderDimInches[2]-pinHeaderKeyOffsetMM[2]+0.01)
      square(pinHeaderKeyWidthMM,pinHeaderWallThicknessMM+0.01);
  }
}

module keyedShaftHole(height,depth, onpos = true, onneg = true)
{
  thick = pinHeaderWallThicknessMM;
  ix = pinHeaderDimMM[0] - 2*thick;
  iy = pinHeaderDimMM[1] - 2*thick;
  kox = pinHeaderKeyOffsetMM[0];
  koy = pinHeaderKeyOffsetMM[1]-0.01;
  koz = pinHeaderKeyOffsetMM[2];
  extraThickness = 8;
  netWidth = iy+thick+extraThickness+0.01;
  linear_extrude(height=height+depth) {
    union() {
      translate([thick,-extraThickness-.01]) {
        square([ix,netWidth]);
      }
      translate([kox,koy]) {
        square(pinHeaderKeyWidthMM,pinHeaderWallThicknessMM+0.01);
      }
    }
  }
  translate([thick+ix/2,0,0])
    for (j=[-1,1]) {
      if ((j < 0 && onneg) || (j > 0 && onpos)) {
        scale([j,1,1]) {
          translate([-ix/2-thick-.1,1.1,0]) {
            scale([.2,.2,3]) {
              rotate([0,0,-90]) {
                edgeRounder();
              }
            }
          }
        }
      }
    }
}

module keyedShaftWall(height,keyinwall)
{
  thick = pinHeaderWallThicknessMM;
  ix = pinHeaderDimMM[0] - 2*thick;
  iy = pinHeaderDimMM[1] - 2*thick;
  kox = pinHeaderKeyOffsetMM[0];
  koy = pinHeaderKeyOffsetMM[1]-0.444+4;
  koz = pinHeaderKeyOffsetMM[2];
  linear_extrude(height=height)
    difference() {
    square([pinHeaderDimMM[0],pinHeaderDimMM[1]]);
    translate([thick,0]) square([ix,iy+thick]);
    if (keyinwall!=0)
      translate([kox,koy])
        square(pinHeaderKeyWidthMM,pinHeaderWallThicknessMM+0.01);
  }
}

module debugShaftWall(height,keyinwall)
{
  thick = in2MM(debugHeaderWallThicknessInches);
  ix = in2MM(debugHeaderDimInches[0]) - 2*thick;
  iy = in2MM(debugHeaderDimInches[1]) - 2*thick;
  difference() {
    linear_extrude(height=height) {
      difference() {
        square([in2MM(debugHeaderDimInches[0]),in2MM(debugHeaderDimInches[1])]);
        translate([thick,0]) square([ix,iy+thick]);
      }
    }
  }
}

module debugShaftHole(height,depth)
{
  thick = in2MM(debugHeaderWallThicknessInches);
  ix = in2MM(debugHeaderDimInches[0]) - 2*thick;
  iy = in2MM(debugHeaderDimInches[1]) - 2*thick;
  linear_extrude(height=height+depth)
    union() {
    translate([thick,-0.01]) square([ix,iy+thick+0.01]);
  }
}

module curtainWall(widthMM,emboss,embscale,x,y,rot,font)
{
  //  echo ("curtainWall ",widthMM,emboss,embscale,x,y,rot);
  thickness = in2MM(curtainWallThicknessInches);
  height = in2MM(curtainWallHeightInches);
  fudge = 10;
  difference() {
    cube([widthMM,thickness,height]);
    if (emboss != undef) {
      zscale = 1.1;
      translate([x, -fudge/2, y]) {
        rotate([0,90,90]) {
          rotate([180,180,90]) {
            xyscale = embscale;
            scale([xyscale,-xyscale,zscale]) {
              linear_extrude(height=thickness+fudge)
                text(emboss,direction="ltr",font=font,halign="center",valign="center");
            }
          }
        }
      }
    }
  }

  if (emboss != undef) {
    gap = 1.6;
    for (x = [0+gap : gap : widthMM-gap/2]) {
      translate([x,0,0]) {
        cube([gap/2,thickness,height]);
      }
    }
    for (y = [0+gap : gap : height-gap/2]) {
      translate([0,0,y]) {
        cube([widthMM,gap/2,gap/2]);
      }
    }
  }
}



module buttonShaft(innerDiameterMM)
{
  thick = in2MM(buttonShaftWallThicknessInches);
  height = in2MM(buttonShaftLengthInches);
  outerDiameterMM = innerDiameterMM+2*thick;
  translate([0,0,-height]) {
    linear_extrude(height=height) {
      circle(d=outerDiameterMM);
    }
  }
}

module bevelHole(innerDiameterMM,diamPct,depthPct)
{
  thick = in2MM(buttonShaftWallThicknessInches);
  height = in2MM(buttonShaftLengthInches);
  fudge = in2MM(0.1);
  lowerRadius = (100+diamPct)*innerDiameterMM/2/100.0;
  upperRadius = lowerRadius*depthPct/100.0;
  translate([0,0,0]) {
    cylinder(h=height*depthPct/100.0,r1=lowerRadius,r2=upperRadius);
  }
}

module buttonHole(innerDiameterMM,lockNotch=false)
{
  thick = in2MM(buttonShaftWallThicknessInches);
  height = in2MM(buttonShaftLengthInches);
  fudge = in2MM(0.1);
  outerDiameterMM = innerDiameterMM+2.2*thick;
  translate([0,0,-height-fudge/2]) {
    union() {
      linear_extrude(height=height+4*fudge) {
        circle(r=innerDiameterMM/2);
      }
      if (lockNotch) {
        // Cut a slot for button notch
        translate([innerDiameterMM/2,0,height/2]) {
          linear_extrude(height=height/3) {
            square([.6*innerDiameterMM,.65*innerDiameterMM],center=true);
          }
        }
        translate([innerDiameterMM/2,0,.1]) {
          linear_extrude(height=height/2) {
            square([.6*innerDiameterMM,.3*innerDiameterMM],center=true);
          }
#          translate([-.5,0,8.7]) {
            rotate([45,0,0]) {
              cubeMM=.43*innerDiameterMM;
              cube([cubeMM,cubeMM,cubeMM]);
            }
          }
        }
      }
    }
  }
}

// roundedRect is centered by default
module roundedRect(size, radius, centered = true)
{
  x = size[0];
  y = size[1];
  z = size[2];
  r = radius;

  translate(centered ? [0, 0, -z/2] : [x/2, y/2, 0])
    linear_extrude(height=z) hull()
    {
      // corner circles indented so the radius hits the desired size
      translate([(-x/2)+r, (-y/2)+r, 0]) circle(r=r);
      translate([(+x/2)-r, (-y/2)+r, 0]) circle(r=r);
      translate([(-x/2)+r, (+y/2)-r, 0]) circle(r=r);
      translate([(+x/2)-r, (+y/2)-r, 0]) circle(r=r);
    }
}

module rcube(size=[30, 20, 10], radius=[3, 2, 1], center=true)
{
  hull() {
    translate( center ? [0,0,0] : size/2 ) {
      cube(size-2*radius+[2*radius[0],0,0],center=true);
      cube(size-2*radius+[0,2*radius[1],0],center=true);
      cube(size-2*radius+[0,0,2*radius[2]],center=true);

      for(x = [-0.5,0.5], y = [-0.5,0.5], z = [-0.5,0.5])
        translate([x * ( size[0] - 2*radius[0]),
                   y * ( size[1] - 2*radius[1]),
                   z * ( size[2] - 2*radius[2])])
          scale([radius[0], radius[1], radius[2]])
          sphere(1.0,$fn=4*4);
    }
  }
}

module displaySupportTab(thickness,rotation)
{
  rotate(45+rotation,[0,0,1])
    linear_extrude(height=thickness)
    square([8,16], center=true);
}

//Like a donut but with a cone-shaped hole
module conut(rd1,rd2,rd3,ht,fudge=0.1) {
  difference() {
    cylinder(r=rd1,h=ht);
    translate([0,0,-fudge/2])
      cylinder(r1=rd2,r2=rd3,ht+fudge);
  }
}

module threequarterconut(rd1,rd2,rd3,ht) {
  difference() {
    conut(rd1,rd2,rd3,ht);
    fudge=.1;
    edge=max(rd1,rd2,rd3);
    translate([0,0,-fudge/2]) {
      cube([edge,edge,ht+fudge]);
    }
  }
}

/* The board notch is like this:
   0,0         ax................G
   .                 .
   .                 .
   r,r    by                .
   .                  .
   .                   .
   D.......cx,cy                .
   .                            .
   .                            .
   .                            .
   .                            .
   E............................F
   Mapped so that its origin is at r,r

*/

function boardNotchPointsMM(radius) =
  let (xinf = 100,
       yinf = 100,
       ax = 4.8,
       by = 2.5,
       cx = 2.5,
       cy = 4.8)
  let (a = [ax, 0],
       b = [a[0], by],
       c = [cx,cy],
       d = [0, cy],
       e = [0, yinf],
       f = [xinf, yinf],
       g = [xinf, 0],
       r = [radius,radius]
       )
  [a-r,b-r,c-r,d-r,e-r,f-r,g-r];

legConutR1 = 4.9;
legConutR2 = 3.9;
legConutR3 = 2.5;
legConutHt = 5;
module legConut(r1=legConutR1) {
  threequarterconut(r1,legConutR2,legConutR3,legConutHt);
}
cornerLatchZRotation = 30;
cornerLatchYRotation = 20;
cornerLatchPoleXInset = 1.7;
cornerLatchStretcherXInset = 1.9;
module throughHoleCornerPost(radius, zrot, reverse, finalsubtract)
{
  toBoardMM = postHeightMM;
  flip = reverse ? 1 : -1;
  scale([1,flip,1]) {
    rotate([0,0,zrot]) {
      union() {
        translate([0,-3,0]) {
          difference() {
            if (finalsubtract) {
              // screw hole itself
              translate([0,0,-2]) {
                linear_extrude(height=toBoardMM+4) {
                  circle(r=m3ScrewHoleRadiusMM);
                }
              }
              // screw head countersink
             translate([0,0,toBoardMM-m3ScrewHeadCountersinkDepthMM]) {
                linear_extrude(height=m3ScrewHeadCountersinkDepthMM+1) {
                  circle(r=m3ScrewHeadRadiusMM);
                }
                // slope hole bottom to help bridging
                translate([0,0,-.9]) {
              cylinder(r1=1,r2=1.1*m3ScrewHeadRadiusMM,ht=1);
            }
             }
            } else {
              linear_extrude(height=toBoardMM) {
                circle(r=radius);
                translate([-radius,0]) {
                  square([1.5*radius,1.6*radius]);
                }
              }
            }
          }
        }
      }
    }
  }
}

module cornerSnapPosts(xmax, ymax, zmax, width)
{
  inset = sqrt((width*width)/2);
  //echo(inset);
  translate([inset/2,inset/2,0])
    rotate([0,180,90+45])
    snapleg(zmax,width);
  translate([xmax-inset/2,inset/2,0])
    translate([0,0,0])
    rotate([0,180,90+90+45])
    snapleg(zmax,width);
  translate([xmax-inset/2,ymax-inset/2,0])
    translate([0,0,0])
    rotate([0,180,90+90+90+45])
    snapleg(zmax,width);
  translate([inset/2,ymax-inset/2,0])
  translate([0,0,0])
    rotate([0,180,45])
    snapleg(zmax,width);
  /*
    linear_extrude(height=z)
    {
    // corner circles indented so the radius hits the desired size
    *      translate([(-x/2)+r, (-y/2)+r, 0]) circle(r=r);
    translate([(+x/2)-r, (-y/2)+r, 0]) circle(r=r);
    translate([(-x/2)+r, (+y/2)-r, 0]) circle(r=r);
    translate([(+x/2)-r, (+y/2)-r, 0]) circle(r=r);
    }
  */
}

module throughHoleCornerPosts(rect, radius, centered = true, finalsubtract = false)
{
  x = rect[0];
  y = rect[1];
  z = rect[2];
  r = radius;

  translate(centered ? [0, 0, -z/2] : [x/2, y/2, 0]) {
    // posts indented so the radius hits the desired size
    translate([(-x/2)+r, (-y/2)+r, 0]) throughHoleCornerPost(r,0,true,finalsubtract);
    translate([(+x/2)-r, (-y/2)+r, 0]) throughHoleCornerPost(r,180,false,finalsubtract);
    translate([(-x/2)+r, (+y/2)-r, 0]) throughHoleCornerPost(r,0,false,finalsubtract);
    translate([(+x/2)-r, (+y/2)-r, 0]) throughHoleCornerPost(r,180,true,finalsubtract);
  }
}

module stretcher(thickness,mirror) {
  stretcherExtraLength = -0.1;
  mainLength = faceplateMM[1]-2*postRadiusMM+stretcherExtraLength;
  //echo(2*postRadiusMM);
  flip = mirror ? 1 : -1;

  trenchMM = in2MM(.2-0.01);
  trenchXOffsetMM = trenchMM/2.8;
  trenchYInsetPlusMM = 6;
  trenchYInsetMinusMM =11.5;

  translate([0,-mainLength/2,0]) {
    scale([flip,1,1]) {
      difference() {
        union() {
          cube([2*postRadiusMM,mainLength,thickness]);
          translate([-trenchXOffsetMM,trenchYInsetPlusMM/2,0]) {
            cube([trenchMM,mainLength-trenchYInsetPlusMM,thickness]);
          }
          for (i = [[[1.0*postRadiusMM,0,0], -1],
                    [[postRadiusMM,mainLength,0], 1]]) {
            translate(i[0]) {
              scale([1,i[1],1]) {
                linear_extrude(height=thickness) {
                  difference() {
                    circle(r=postRadiusMM);
                    translate([-.3,1.8])
                      square([2.5,20]);
                  }
                }
              }
            }
          }
        }
        translate([2*postRadiusMM-trenchMM,trenchYInsetMinusMM/2,-0.1]) {
          cube([trenchMM+0.1,mainLength-trenchYInsetMinusMM,thickness+0.8]);
        }

        /*
          translate([postRadiusMM/2-cornerLatchStretcherXInset,-3*postRadiusMM,3]) {
          rotate([-cornerLatchYRotation,0,-cornerLatchZRotation])
          cube([2*postRadiusMM,3*postRadiusMM,2*thickness]);
          }
        */
        for (i = [[[postRadiusMM/2-cornerLatchStretcherXInset,mainLength+2*postRadiusMM,0], 1],
                  [[postRadiusMM/2-cornerLatchStretcherXInset,0-2*postRadiusMM,0], -1]]) {
          translate(i[0]) {
            scale([1,i[1],1]) {
              translate([0.80*postRadiusMM,-1.58*postRadiusMM,-0.1]) 
                *              cube([1.0*postRadiusMM,postRadiusMM,thickness+2*0.1]);
              rotate([cornerLatchYRotation,0,cornerLatchZRotation]) {
                translate([0,-2*postRadiusMM,0]) {
                  cube([2*postRadiusMM,2*postRadiusMM,2*thickness]);
                }
              }
            }
          }
        }
      }
    }
  }
}

module case10()
{
  topRad = postRadiusMM/5;
  //  echo(faceplateMM+[2*mainPostOutsetMM, 2*mainPostOutsetMM, postHeightMM-topRad]);
  union()
  {

    difference() {

      ////
      // Early additions

      union() {

        rect = [faceplateMM[0]+2*mainPostOutsetMM,
                faceplateMM[1]+2*mainPostOutsetMM,
                postHeightMM];

        // Add the main corner posts
        //echo ("ZOG",[-mainPostOutsetMM,-mainPostOutsetMM,faceplateMM[2]-postHeightMM]);
        translate([-mainPostOutsetMM,-mainPostOutsetMM,faceplateMM[2]-postHeightMM]) {
          throughHoleCornerPosts(rect, postRadiusMM, false, false);

          // Add the single asymmetric SE blocking post

          x = rect[0];
          y = rect[1];
          z = rect[2];
          r = postRadiusMM;
          translate([x/2-2.1, y/2+3.0, 0]) {
            translate([(+x/2)-r, (+y/2)-r, 0]) {
              toBoardMM = postHeightMM;
              linear_extrude(height=toBoardMM) {
                circle(r=r);
              }
            }
          }
        }

        // Add the button shafts
        for (i = buttonShaftInfoInches) {
          translate([in2MM(i[0]),in2MM(i[1]),faceplateMM[2]])
            buttonShaft(in2MM(buttonShaftHoleThicknessInches));
        }

        // Add the faceplate itself, minus header holes
        difference() {
          roundedRect(faceplateMM, postRadiusMM, false);

          // Subtract the shrouded headers walls with no keys
          for (i = pinHeaderInfoInches) {
            rotate(i[2],[0,0,1]) {
              translate([0,0,0]) { // z origin to top of faceplate
                translate([in2MM(i[0]),in2MM(i[1]),-(postHeightMM-pinHeaderDimMM[2])+faceplateMM[2]]) { // down by wall height
                  keyedShaftWall(postHeightMM-pinHeaderDimMM[2],0); // here's the wall
                }
              }
            }
          }
        }
        
        // Add the keyed shrouded headers walls
        for (i = pinHeaderInfoInches) {
          rotate(i[2],[0,0,1]) {
            translate([0,0,0]) { // z origin to top of faceplate
              translate([in2MM(i[0]),in2MM(i[1]),-(postHeightMM-pinHeaderDimMM[2])+faceplateMM[2]]) { // down by wall height
                keyedShaftWall(postHeightMM-pinHeaderDimMM[2],i[3]); // here's the wall
              }
            }
          }
        }

        // Add the debug header walls
        for (i = debugHeaderInfoInches) {
          rotate(i[2],[0,0,1]) {
            translate([0,0,faceplateMM[2]]) { // z origin to top of faceplate
              translate([in2MM(i[0]),in2MM(i[1]),-(postHeightMM-in2MM(debugHeaderDimInches[2]))]) { // down by wall height
                debugShaftWall(postHeightMM-in2MM(debugHeaderDimInches[2])); // here's the wall
              }
            }
          }
        }

        // Add the side curtain walls
        for (i = curtainWallInfoInches) {
          rotate(i[3],[0,0,1]) {
            translate([0,0,faceplateMM[2]]) { // z origin to top of faceplate
              translate([in2MM(i[0]),in2MM(i[1]),-in2MM(curtainWallHeightInches)]) { // down by wall height
                curtainWall(in2MM(i[2]),i[4],i[5],i[6],i[7],i[3],i[8]);
              }
            }
          }
        }
        // Add a few special reinforcement ribs on the weak N curtain wall
        {
          translate([0,0,faceplateMM[2]]) { // z origin to top of faceplate
            translate([in2MM(2.07),in2MM(0.03),-in2MM(curtainWallHeightInches)]) { // down by wall height
              cube([1.7,1,in2MM(curtainWallHeightInches)]);
            }
            translate([in2MM(2.43),in2MM(0.03),-in2MM(curtainWallHeightInches)]) { // down by wall height
              cube([1.7,1,in2MM(curtainWallHeightInches)]);
            }
            #translate([in2MM(1.69),in2MM(0.03),-in2MM(curtainWallHeightInches)]) { // down by wall height
              cube([1.7,1,in2MM(curtainWallHeightInches)]);
            }
          }
        }

        // Some special reinforcement ribs for the weak S curtain wall too
        {
          translate([0,0,faceplateMM[2]]) { // z origin to top of faceplate
            translate([46.2,81.4,-in2MM(curtainWallHeightInches)+0.0]) { // down by wall height
              cube([1.4,0.9,in2MM(curtainWallHeightInches)]);
              translate([10,0,0]) {
                #cube([1.4,0.9,in2MM(curtainWallHeightInches)]);
              }
              translate([21,0,1.5]) {
                #cube([1.4,0.9,in2MM(curtainWallHeightInches)-1.5]);
              }
              translate([-11.3,0,1.5]) {
                #cube([1.4,0.9,in2MM(curtainWallHeightInches)-1.5]);
              }
            }
          }
        }

        // Extra-disgusting side-wall fill-in before drilling screw holes
        {
*          translate([5.5,75,-16.9]) {
            cube([1,10,23.1]);
          }
        }
        // End of additions
      }

      ////
      // Subtractions

      ////
      // corner post screw holes
      if (1) {
        for (i = m3MountingHoleOffsetsMM) {
          translate([-mainPostOutsetMM + i[0] + m3HoleShiftXMM,
                     -mainPostOutsetMM + i[1] + m3HoleShiftYMM,
                     faceplateMM[2]-postHeightMM]) {
            throughHoleCornerPost(m3ScrewHoleRadiusMM, 0, true, true);
          }
        }
      } else
      {
        rect = [faceplateMM[0]+2*mainPostOutsetMM,
                faceplateMM[1]+2*mainPostOutsetMM,
                postHeightMM];

        translate([-mainPostOutsetMM,-mainPostOutsetMM,faceplateMM[2]-postHeightMM]) {
          throughHoleCornerPosts(rect, postRadiusMM, false, true);
        }
      }

      ////
      // fingernail clearance cutout for ethernet access.
      translate([12,42.8,-11.]) {
        rotate([0,-60,0])
          cylinder(h=20,r=6.9);
      }

      ////
      // Display hole
      translate(displayOffsetMM) {
        // Subtract space for the display body
        translate([0, 0, -manyMM])
          roundedRect(displayDimMM + [0, 0, manyMM], easeRadius(displayDimMM, displayEasePct), false);

        // Subtract the display face opening
        translate(displayVizOffsetMM  + [0, 0, -2])
          roundedRect(displayVizDimMM  + [0, 0, manyMM], easeRadius(displayVizDimMM, displayEasePct), false);
      }

      // Subtract the keyed ITC holes
      for (i = pinHeaderInfoInches) {
        rotate(i[2],[0,0,1]) {
          translate([in2MM(i[0]),in2MM(i[1]),-postHeightMM]) {
            keyedShaftHole(10,30,i[4],i[5]);
          }
        }
      }

      // Subtract the airspace below the ITC holes
      for (i = pinHeaderInfoInches) {
        rotate(i[2],[0,0,1]) {
          translate([0,0,faceplateMM[2]-(postHeightMM-pinHeaderDimMM[2])]) { 
            translate([in2MM(i[0]),in2MM(i[1]),-(postHeightMM-pinHeaderDimMM[2])]) { 
              union() {
                keyedShaftWall(postHeightMM-pinHeaderDimMM[2],0); // here's the wall
                // something is blowing my manifold!  :( maybe in here somewhere! 
                translate([1,0,0]) {
                  cube([3,6,30]);
                }
              }
            }
          }
        }
      }

      // Subtract the debug hole
      for (i = debugHeaderInfoInches) {
        rotate(i[2],[0,0,1])
          translate([in2MM(i[0]),in2MM(i[1]),-postHeightMM])
          debugShaftHole(100,100);
      }
      
      // Subtract the pushbutton shafts
      for (i = buttonShaftInfoInches) {
        translate([in2MM(i[0]),in2MM(i[1]),0])
          buttonHole(in2MM(buttonShaftHoleThicknessInches),true);
      }

      // Subtract the power light shaft
      for (i = glowHoleInfoInches) {
        translate([in2MM(i[0]),in2MM(i[1]),0]) {
          buttonHole(in2MM(i[2]));
#          linear_extrude(height=10) {
            shrinkFrac = 0.7;
            circle(in2MM(shrinkFrac*i[2]),$fn=3);
            rotate([0,0,60])
              circle(in2MM(shrinkFrac*i[2]),$fn=3);
          }
          bevelHole(in2MM(i[2]),13,65); // Ease glowrod insertion a bit
        }
      }

      // Subtract the embossed labels
      if (1) {
        nsoffset = .5;
        embossDepth = 1.0;
        zscale = 1.1;
        translate([52.0-nsoffset, 6.4, faceplateMM[2]-embossDepth]) {
          rotate(0) {
            xyscale = .75;
            scale([xyscale,-xyscale,zscale]) {
              linear_extrude(height=embossDepth)
                text("N",direction="ttb",font="Gillius ADF",halign="center",valign="center");
            }
          }
        }

        translate([54.5+nsoffset, 80, faceplateMM[2]-embossDepth]) {
          rotate(0) {
            xyscale = .70;
            scale([xyscale,-xyscale,zscale]) {
              linear_extrude(height=embossDepth+1)
                text("S",direction="ttb",font="Gillius ADF",halign="center",valign="center");
            }
          }
        }

        translate([4.9, 47, faceplateMM[2]-embossDepth]) {
          rotate(0) {
            xyscale = 0.75;
            scale([xyscale,-xyscale,zscale]) {
              linear_extrude(height=embossDepth+1)
                text("W",direction="ttb",font="Gillius ADF",halign="center",valign="center");
            }
          }
        }

        translate([104.0, 47.0, faceplateMM[2]-embossDepth]) {
          xyscale = .75;
          scale([xyscale,-xyscale,zscale]) {
            linear_extrude(height=embossDepth+1)
              text("E",direction="ttb",font="Gillius ADF",halign="center",valign="center");
          }
        }
      }
      
      // Subtract the scaffolding perforations

      if (1) {
        intersection() {
          union() {
            for (r = perforationZonesMM) {
              translate([r[0],r[1],-50]) {
                cube([r[2],r[3],100]);
              }
            }
          }
          perfShiftXMM = 2.5;
          perfShiftYMM = 0;
          union() {
            translate([perfShiftXMM,perfShiftYMM,0]) {
            rotate([0,0,perforationInfoMM[6]]) {
              x = -10; y = -80; w = 150; h = 150;
              for (xs = [x : perforationInfoMM[0] : x + w]) {
                for (ys = [y : perforationInfoMM[1] : y + h]) {
                  translate([xs,ys,-50]) {
                    translate([perforationInfoMM[2],perforationInfoMM[3],0]) {
                      cube([perforationInfoMM[4],perforationInfoMM[5],100]);
                    }
                  }
                }
              }
            }
          }
          }
        }
      }
    }
  }

  ////
  // Late additions

  union() {
    // Add the version time stamp
    #translate([102.8, 55.2, -0.75]) {
      rotate(0) {
        xyscale = .4;
        zscale = 1.1;
        scale([xyscale,xyscale,zscale]) {
          linear_extrude(height=3)
            text(BUILD_TIME_STAMP,direction="ttb",font="Impact",halign="center",valign="center");
        }
      }
    }

  }

  union() {
    // Add the pushbuttons in the middle
    for (i = [0 : 1]) {
      translate(faceplateMM/2+[in2MM((2*i-1)),0,faceplateMM[2]/2]) {
        scale([1,1,-1]) {
          linear_extrude(height=buttonPlateThicknessMM) {
            circle(d=buttonPlateDiameterMM);
          }
#          linear_extrude(height=in2MM(buttonShaftLengthInches+buttonSurfaceProtrusionInches)) {
            circle(d=in2MM(buttonShaftDiameterInches));
          }
          translate([buttonLockXOffsetMM,0,buttonLockZOffsetMM]) {
            rotate([0,45,0]) {
              edge=buttonLockEdgeMM;
              cube([edge,edge,edge],center=true);
            }
          }
        }
      }
    }
  }

  *union() {
    // Add the bottom stretchers outside the edges they will stretch
    stretcherThickMM = belowBoardMM * 1.05; // 105% of nominal clearance so we take the load

    for (i = [0 : 1]) {
      translate(faceplateMM/2+[in2MM((2*i-1)*2.3),0,faceplateMM[2]/2]) {
        rotate([0,0,0]) {
          scale([1,1,-1]) {
            stretcher(stretcherThickMM,i>0);
          }
        }
      }
    }
  }
}

module singleStrap(strapConutR1,armlen,flip,cup) {
  scale([flip,1,1]) {
    if (cup) {
      difference() {
        rotate([0,0,90]) {
          legConut(strapConutR1);
        }
        translate([-3.91,-0.98,-1]) {
          #translate([-1.1,-.9,0]) {
            rotate([-45,0,0]) 
            cube([4,1,3]);
          }
          scale([.12,.17,1]) {
            rotate([0,0,90]) {
              edgeRounder();
            }
          }
        }
      }
    }
    translate([0,3.5,0]) {
      cube([3,armlen,5]);
    }
  }
}


function strapLegInfo() =
  let (slen = faceplateMM[1]-2*postRadiusMM+legConutR1,
       llen = faceplateMM[0]-3*postRadiusMM+legConutR1)
  [/*
   [cup,x,y,flip,rotation,armlength]*/

   [  1,0,0,    1,     -50,       16.85], // NW cup 

   [  1,0,slen,-1,     228,       20], // SW cup
   [  1,llen,0,-1,      30,       10], // NE cup
   [  1,llen,slen,1,  180-27,       20], // SE cup

   [  0, 91.77,6.7  ,1,    0,       16.4], //E-NE seam ripper


   [  0, 80.6,56.2  ,1,    -56.7,       6.4], //NW-SE cross stem 2

   [  0, 29.44,53.7  ,1,    48.5,       15.4], //NE-SW cross stem

   ////  [  0, 20.5, 19  ,1,    -90,       65], //NW-NE lateral

   [  0, 23.3, 59 ,1,    -90,       58.0], //SW-SE lateral

  [  0, llen-11.1, 23.57 ,1,    -30,       20.70], //NE-E lateral 1

   [  0, llen+3.8, 38.8 ,1,    50,       24], //SE-E lateral 2

   [  0, 16, 7.0,1,    29,     33.7], //NW-W lateral 1

    [  0, -3.55, 36.4 ,1,    -26,       34.0], //SW-W lateral 2

   [  0, 7.0,  8 ,1,    -90,       32], //NW free support
   [  0, 98.5, 5 ,1,    90,       38], //NE free support

   [  0, 39.6, 10.3 ,1,    -130,       12.1], //NW free joiner
   [  0, 61.6, 8.0 ,1,    130,       12], //NE free joiner

   [  0, 4.2, 76 ,1,    -90,      30], //SW free support
   [  0, 99.5,73 ,1,    90,       40.5], //SE free support

   [  0, 33.2, 73.95 ,1,    -61,       11.8], //SW free joiner
   [  0, 58.6, 71.3 ,1,     61,       11.9], //SE free joiner

   ];

$fn=50;

translate([0,0,6.45]) {
  scale([1,1,-1])  // Flip for printing face down
    case10();
}


