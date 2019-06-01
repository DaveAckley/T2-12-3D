include <T2-FEMALE-11.inc>

footFemale();
translate([pairDistanceMM,0,0]) rotate([0,0,180]) footFemale();
     
*for (y = [-11,11]) {
     translate([pairDistanceMM/2,y,fOuterShellHeightMM]) {
          rotate([180,0,30]) {
               maleConnector();
          }
     }
}


