include <T2-FEMALE-11.inc>

BUILD_TIME_STAMP = "99unset42";
     
module pair() {
     translate([-pairDistanceMM/2,0,0]) rotate([0,0,180]) footFemale();
     translate([pairDistanceMM/2,0,0]) rotate([0,0,180]) footFemale();
}

translate([-pairToPairXDistanceMM/2,0,0]) pair();
translate([pairToPairXDistanceMM/2,0,0]) pair();
translate([0,pairToPairYDistanceMM,0]) pair();
translate([-pairToPairXDistanceMM/2,-pairToPairYDistanceMM/2,0]) {
     cube([pairToPairXDistanceMM,pairToPairYDistanceMM,m3NutNominalHeightMM]);
}
translate([0, -1, -0.0]) {
     rotate(0) {
          xyscale = .5;
          zscale = 1.0;
          scale([xyscale,xyscale,zscale]) {
               linear_extrude(height=1.2*m3NutNominalHeightMM)
                    text(BUILD_TIME_STAMP,direction="ltr",font="Impact",halign="center",valign="center");
          }
     }
}

footDistMM = 12;
for (x = [-3 : 2]) {
     translate([(x+0.5)*footDistMM,-10,fOuterShellHeightMM]) {
          rotate([180,0,30]) {
               maleConnector();
          }
     }
}


