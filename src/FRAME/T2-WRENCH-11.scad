include <T2-FEET-11.inc>
BUILD_TIME_STAMP="clams";
fWrenchHeightMM=1.8*m3NutNominalHeightMM;
fWrenchBigHeadDiameterMM=1.55*fOuterHexNutDiameterMM;
fWrenchSmallHeadDiameterMM=1.55*fOuterHexNutDiameterMM;
fWrenchArmLengthMM=50;
fWrenchArmWidthMM=9;
fWrenchFemaleExpandXYPct=0.03;

module wrenchHead(d=fWrenchSmallHeadDiameterMM) {
     difference() {
          cylinder(h=fWrenchHeightMM,d=d,$fn=smoothishFaceCount);
          sxy=1+fWrenchFemaleExpandXYPct;
          rotate([0,0,30])
               scale([sxy,sxy,2]) maleHexNutSolid();
     }
}

module wrench() {
     offset=(fWrenchArmLengthMM/2+fWrenchSmallHeadDiameterMM/4
                  +(fWrenchBigHeadDiameterMM-fWrenchSmallHeadDiameterMM)/4+.7);
     translate([+offset,0,0]) wrenchHead(d=fWrenchBigHeadDiameterMM);
     translate([-offset,0,0]) wrenchHead(d=fWrenchSmallHeadDiameterMM);
     translate([-fWrenchArmLengthMM/2,-fWrenchArmWidthMM/2,0]) {
          cube([fWrenchArmLengthMM,fWrenchArmWidthMM,fWrenchHeightMM]);
     }
     #translate([0, 0, fWrenchHeightMM-0.1]) {
          rotate(0) {
               xyscale = .5;
               zscale = 1.0;
               scale([xyscale,xyscale,zscale]) {
                    linear_extrude(height=0.4)
                         text(BUILD_TIME_STAMP,direction="ltr",font="Impact",halign="center",valign="center");
               }
          }
     }
}

wrench();
