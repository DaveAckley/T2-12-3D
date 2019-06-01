//  -*- SCAD -*-
// T2-FEET-10+ snap connectors for tile<->frame attachment
// T2-FEET-11: Try no captive nut, female to tile side
// Copyright (C) 2019 The T2 Tile Project
// Licensed under GPL-3

smoothishFaceCount=128;
m3ScrewNominalHoleDiameterMM=3.4 + 0.1;  // According to internet, plus 0.1
m3ScrewNominalHeadDiameterMM=5.5 + 0.2;  // 5.5: socket cap; 5.6: narrow 'cheese head'; 5.7: +socket cap; 6: philips
m3ScrewNominalHeadCountersinkDepthMM=3.0 + 0.1;  // Makes 25mm screw into 28mm

m3ScrewNominalThreadOuterDiameterMM=2.9; // Outer edge of thread
m3ScrewNominalThreadInnerDiameterMM=2.7; // Inner edge of thread

m3NutNominalHeightMM = 2.5;
m3NutNominalDiameterMM = 5.41;

// Parameters
fScrewHoleDepthMM=m3NutNominalHeightMM+.5;
fScrewHoleOuterDiameterFrac=0.75;
fScrewHoleWidthMM=(fScrewHoleOuterDiameterFrac*m3ScrewNominalThreadOuterDiameterMM + 
                   (1-fScrewHoleOuterDiameterFrac)*m3ScrewNominalThreadInnerDiameterMM);
fScrewHoleTaperHeightMM=1;
fScrewHoleTaperWidthMM=2;

fScrewHoleSmoothStartDepthMM=0.6; // out of the total fScrewHoleDepthMM
fScrewHoleSmoothStartWidthMM=1.07*m3ScrewNominalThreadOuterDiameterMM;

fOuterHexNutDiameterMM=9.5;

fMaleShaftHeightMM=4;
fMaleWasherHeightMM=0.6;
fMaleWasherDiameterMM=fOuterHexNutDiameterMM+0.32;

fOuterShellDiameterMM=10.5;
fOuterShellHeightMM=12;
fOuterShellBaseThicknessMM=3.0;
fInnerShellDiameterMM=6;

fUngappedOuterShellHeightMM=2.0;
fOuterShellGapWidthMM=.50;

fOutsideEntranceBevelHeightMM=.25;
fOutsideEntranceBevelWidthMM=1.25;

fInsideEntranceBevelHeightMM=2.0;
fInsideEntranceBevelWidthMM=.25;

fBumpOutBevelHeightMM=.9;
fBumpOutBevelWidthMM=-0.4;     

fBumpInBevelHeightMM=1.5;
fBumpInBevelWidthMM=0.5;     

fStraightShaftBevelHeightMM=1.75;
fStraightShaftBevelWidthMM=0;

fTaperBevelHeightMM=3.2;
fTaperBevelWidthMM=1.5;

mExpandXFemale=.01;
mExpandYFemale=.01;

pairDistanceMM=11.50;  // Distance between x-adjacent case holes
pairToPairXDistanceMM=112.4;
pairToPairYDistanceMM=9;

// Derived measurements
m3ScrewNominalHoleRadiusMM=m3ScrewNominalHoleDiameterMM/2;
m3ScrewNominalHeadRadiusMM=m3ScrewNominalHeadDiameterMM/2;

m3ScrewNominalThreadOuterRadiusMM=m3ScrewNominalThreadOuterDiameterMM/2;
m3ScrewNominalThreadInnerRadiusMM=m3ScrewNominalThreadInnerDiameterMM/2;

m3NutNominalRadiusMM = m3NutNominalDiameterMM/2;

fOuterShellRadiusMM=fOuterShellDiameterMM/2;
fInnerShellRadiusMM=fInnerShellDiameterMM/2;

module hexNut(h = m3NutNominalHeightMM,
              d =  m3NutNominalDiameterMM,
              sd = m3ScrewNominalThreadInnerDiameterMM,
              removeHole=true) {
     difference() {
          cylinder(h=h,
                   d1 = d,
                   d2 = d,
                   center = false,
                   $fn=6);
          if (removeHole)
               cylinder(h=h,
                        d1 = sd,
                        d2 = sd,
                        $fn=smoothishFaceCount);
     }
}

module negativeCylinder(nr=10,h=1,r2=1,r1=1,center=false) {
     difference() {
          // The positive surround cylinder
          cylinder(h=h,r1=nr,r2=nr,center=center,$fn=smoothishFaceCount);
          // Minus the negative cylinder
          cylinder(h=h,r1=r1,r2=r2,center=center,$fn=smoothishFaceCount);
     }
}

module maleCore(flare = true) {
     // inner entrance bevel
     dh2 = fInsideEntranceBevelHeightMM;
     ah2 = fOuterShellHeightMM - dh2;
     aw2 = flare ?
          (fOuterShellRadiusMM - fOutsideEntranceBevelWidthMM) :
          (fOuterShellRadiusMM - fOutsideEntranceBevelWidthMM - fInsideEntranceBevelWidthMM) ;
     aw3 = flare ?
          (aw2 - fInsideEntranceBevelWidthMM) :
          (aw2 - fInsideEntranceBevelWidthMM + fInsideEntranceBevelWidthMM);
     translate([0,0,ah2]) {
          cylinder(h=dh2, r1=aw3, r2=aw2, center = false, $fn=smoothishFaceCount);
     }

     // inner bump-out bevel
     dh3 = fBumpOutBevelHeightMM;
     ah3 = ah2 - dh3;
     aw4 = aw3 - fBumpOutBevelWidthMM;
     translate([0,0,ah3]) {
          cylinder(h=dh3, r1=aw4, r2=aw3, center = false, $fn=smoothishFaceCount);
     }

     // inner bump-in bevel
     dh4 = fBumpInBevelHeightMM;
     ah4 = ah3 - dh4;
     aw5 = aw4 - fBumpInBevelWidthMM;
     translate([0,0,ah4]) {
          cylinder(h=dh4, r1=aw5, r2=aw4, center = false, $fn=smoothishFaceCount);
     }
          
     // inner straight shaft
     dh5 = fStraightShaftBevelHeightMM;
     ah5 = ah4 - dh5;
     aw6 = aw5 - fStraightShaftBevelWidthMM;
     translate([0,0,ah5]) {
          cylinder(h=dh5, r1=aw6, r2=aw5, center = false, $fn=smoothishFaceCount);
     }

     // inner taper
     dh6 = fTaperBevelHeightMM;
     ah6 = ah5 - dh6;
     aw7 = aw6 - fTaperBevelWidthMM;
     translate([0,0,ah6]) {
          cylinder(h=dh6, r1=aw7, r2=aw6, center = false, $fn=smoothishFaceCount);
     }

     // screw shaft
     *cylinder(h=fOuterShellBaseThicknessMM,
               r1 = m3ScrewNominalThreadOuterRadiusMM,
               r2 = m3ScrewNominalThreadOuterRadiusMM,
               center = false,
               $fn=smoothishFaceCount);
}

module femaleConnector() {
     difference() {
          cylinder(h=fOuterShellHeightMM,
                   r1 = fOuterShellRadiusMM,
                   r2 = fOuterShellRadiusMM,
                   center = false, $fn=smoothishFaceCount);

          // subtract outer top bevel
          ah1 = fOuterShellHeightMM-fOutsideEntranceBevelHeightMM;
          aw1 = fOuterShellRadiusMM;
          translate([0,0,ah1]) {
               negativeCylinder(h=fOutsideEntranceBevelHeightMM,
                                r1 = aw1,
                                r2 = aw1-fOutsideEntranceBevelWidthMM,
                                center = false);
          }

          // subtract a slightly oversized maleCore();
          scale([1+mExpandXFemale,1+mExpandYFemale,1])
               #maleCore();

          // cut flex gaps
          for (r = [0,120,240]) {
               h = fOuterShellHeightMM - fUngappedOuterShellHeightMM;
               rad = fOuterShellDiameterMM / 2;
               rotate([0,0,r]) {
                    translate([0,-fOuterShellGapWidthMM/2,fUngappedOuterShellHeightMM]) {
                         cube([rad,fOuterShellGapWidthMM,h],center=false);
                    }
               }
          }
     }
}

module maleHexNutSolid() {
     hexNut(h=m3NutNominalHeightMM, d=fOuterHexNutDiameterMM, removeHole=false);
}

module maleConnector() {
     difference() {
          union() {
               translate([0,0,-fMaleShaftHeightMM]) {
                    maleCore(false);
               }
               translate([0,0,fOuterShellHeightMM-fMaleShaftHeightMM]) {
                    shaftRadius=fOuterShellRadiusMM-fOutsideEntranceBevelWidthMM-fInsideEntranceBevelWidthMM;
                    cylinder(h=fMaleShaftHeightMM,r=shaftRadius,$fn=smoothishFaceCount);
               }
               translate([0,0,fOuterShellHeightMM-m3NutNominalHeightMM-fMaleWasherHeightMM])
                    maleHexNutSolid();
               translate([0,0,fOuterShellHeightMM-fMaleWasherHeightMM]) {
                    cylinder(h=fMaleWasherHeightMM,d=fMaleWasherDiameterMM,$fn=smoothishFaceCount);
               }
          }
          translate([0,0,fOuterShellHeightMM-fScrewHoleSmoothStartDepthMM]) {
               #cylinder(h=fScrewHoleSmoothStartDepthMM+.01,
                        d2=fScrewHoleSmoothStartWidthMM,
                        d1=fScrewHoleWidthMM,
                        $fn=smoothishFaceCount);
               translate([0,0,-fScrewHoleDepthMM+.1]) {
                    cylinder(h=fScrewHoleDepthMM,
                             d=fScrewHoleWidthMM,$fn=smoothishFaceCount);
                    translate([0,0,-fScrewHoleTaperHeightMM]) {
                         cylinder(fScrewHoleTaperHeightMM,
                                   d1=fScrewHoleWidthMM-fScrewHoleTaperWidthMM,
                                   d2=fScrewHoleWidthMM,
                                   $fn=smoothishFaceCount);
                    }
               }
          }
     }
}
