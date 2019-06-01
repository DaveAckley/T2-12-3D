// T2-12-12+ case -*- SCAD -*-
// T2-FEET-10+ snap connectors for tile<->frame attachment
// T2-FEET-11: Try no captive nut, female to tile side
// Copyright (C) 2019 The T2 Tile Project
// Licensed under GPL-3

m3ScrewNominalHoleDiameterMM=3.4 + 0.1;  // According to internet, plus 0.1
m3ScrewNominalHeadDiameterMM=5.5 + 0.2;  // 5.5: socket cap; 5.6: narrow 'cheese head'; 5.7: +socket cap; 6: philips
m3ScrewNominalHeadCountersinkDepthMM=3.0 + 0.1;  // Makes 25mm screw into 28mm

m3ScrewNominalThreadOuterDiameterMM=2.9; // Outer edge of thread
m3ScrewNominalThreadInnerDiameterMM=2.7; // Inner edge of thread

m3NutNominalHeightMM = 2.5;
m3NutNominalDiameterMM = 5.41;

// Parameters
fScrewHoleDepthMM=3;
fScrewHoleWidthMM=m3ScrewNominalThreadInnerDiameterMM;
fScrewHoleTaperHeightMM=2;
fScrewHoleTaperWidthMM=2;

fMaleShaftHeightMM=2;

fOuterShellDiameterMM=10;
fOuterShellHeightMM=10;
fOuterShellBaseThicknessMM=3.0;
fInnerShellDiameterMM=6;

fUngappedOuterShellHeightMM=3;
fOuterShellGapWidthMM=0.5;

fOutsideEntranceBevelHeightMM=2;
fOutsideEntranceBevelWidthMM=1.25;

fInsideEntranceBevelHeightMM=.5;
fInsideEntranceBevelWidthMM=.25;

fInsideEntranceBevelWidthMM=.25;

fBumpOutBevelHeightMM=.7;
fBumpOutBevelWidthMM=-0.3;     

fBumpInBevelHeightMM=.9;
fBumpInBevelWidthMM=0.35;     

fStraightShaftBevelHeightMM=1.5;
fStraightShaftBevelWidthMM=0;

fTaperBevelHeightMM=3.75;
fTaperBevelWidthMM=2.25;

mExpandXFemale=.01;
mExpandYFemale=.01;

// Derived measurements
m3ScrewNominalHoleRadiusMM=m3ScrewNominalHoleDiameterMM/2;
m3ScrewNominalHeadRadiusMM=m3ScrewNominalHeadDiameterMM/2;

m3ScrewNominalThreadOuterRadiusMM=m3ScrewNominalThreadOuterDiameterMM/2;
m3ScrewNominalThreadInnerRadiusMM=m3ScrewNominalThreadInnerDiameterMM/2;

m3NutNominalRadiusMM = m3NutNominalDiameterMM/2;

fOuterShellRadiusMM=fOuterShellDiameterMM/2;
fInnerShellRadiusMM=fInnerShellDiameterMM/2;

module hexNut(removeHole=true) {
     difference() {
          cylinder(h=m3NutNominalHeightMM,
                   r1 = m3NutNominalRadiusMM,
                   r2 = m3NutNominalRadiusMM,
                   center = false,
                   $fn=6);
          cylinder(h=m3NutNominalHeightMM,
                   r1 = m3ScrewNominalThreadRadiusMM,
                   r2 = m3ScrewNominalThreadRadiusMM,
                   $fn=128);
     }
}

module negativeCylinder(nr=10,h=1,r2=1,r1=1,center=false) {
     difference() {
          // The positive surround cylinder
          cylinder(h=h,r1=nr,r2=nr,center=center,$fn=128);
          // Minus the negative cylinder
          cylinder(h=h,r1=r1,r2=r2,center=center,$fn=128);
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
          cylinder(h=dh2, r1=aw3, r2=aw2, center = false, $fn=128);
     }

     // inner bump-out bevel
     dh3 = fBumpOutBevelHeightMM;
     ah3 = ah2 - dh3;
     aw4 = aw3 - fBumpOutBevelWidthMM;
     translate([0,0,ah3]) {
          cylinder(h=dh3, r1=aw4, r2=aw3, center = false, $fn=128);
     }

     // inner bump-in bevel
     dh4 = fBumpInBevelHeightMM;
     ah4 = ah3 - dh4;
     aw5 = aw4 - fBumpInBevelWidthMM;
     translate([0,0,ah4]) {
          cylinder(h=dh4, r1=aw5, r2=aw4, center = false, $fn=128);
     }
          
     // inner straight shaft
     dh5 = fStraightShaftBevelHeightMM;
     ah5 = ah4 - dh5;
     aw6 = aw5 - fStraightShaftBevelWidthMM;
     translate([0,0,ah5]) {
          cylinder(h=dh5, r1=aw6, r2=aw5, center = false, $fn=128);
     }

     // inner taper
     dh6 = fTaperBevelHeightMM;
     ah6 = ah5 - dh6;
     aw7 = aw6 - fTaperBevelWidthMM;
     translate([0,0,ah6]) {
          cylinder(h=dh6, r1=aw7, r2=aw6, center = false, $fn=128);
     }

     // screw shaft
     *cylinder(h=fOuterShellBaseThicknessMM,
               r1 = m3ScrewNominalThreadOuterRadiusMM,
               r2 = m3ScrewNominalThreadOuterRadiusMM,
               center = false,
               $fn=128);
}

module femaleConnector() {
     difference() {
          cylinder(h=fOuterShellHeightMM,
                   r1 = fOuterShellRadiusMM,
                   r2 = fOuterShellRadiusMM,
                   center = false, $fn=128);

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
               maleCore();

          // cut flex gaps
          for (r = [0,120,240]) {
               h = fOuterShellHeightMM - fUngappedOuterShellHeightMM;
               rad = fOuterShellDiameterMM / 2;
               rotate([0,0,r]) {
                    translate([0,-fOuterShellGapWidthMM/2,fUngappedOuterShellHeightMM]) {
                         #cube([rad,fOuterShellGapWidthMM,h],center=false);
                    }
               }
          }
     }
}

module maleConnector() {
     difference() {
          union() {
               translate([0,0,-fMaleShaftHeightMM]) {
                    maleCore(false);
               }
               translate([0,0,fOuterShellHeightMM-fMaleShaftHeightMM]) {
                    shaftRadius=fOuterShellRadiusMM-fOutsideEntranceBevelWidthMM-fInsideEntranceBevelWidthMM;
                    cylinder(h=fMaleShaftHeightMM,r=shaftRadius,$fn=128);
               }
          }
          translate([0,0,fOuterShellHeightMM-fScrewHoleDepthMM]) {
               #cylinder(h=fScrewHoleDepthMM,d=fScrewHoleWidthMM,$fn=128);
               translate([0,0,-fScrewHoleTaperHeightMM]) {
                    #cylinder(fScrewHoleTaperHeightMM,
                             d1=fScrewHoleWidthMM-fScrewHoleTaperWidthMM,
                             d2=fScrewHoleWidthMM,
                              $fn=128);
               }
          }
     }
}

femaleConnector();
#cylinder(h=0.75*fUngappedOuterShellHeightMM,d=1.5*fOuterShellDiameterMM,$fn=32);

//maleCore();
translate([13,0,fOuterShellHeightMM]) {
     rotate([180,0,0]) {
          maleConnector();
     }
}

     
