//  -*- SCAD -*-
include <T2-FEET-11.inc>

module footFemale() {
     rotate([0,0,0]) femaleConnector();
     cylinder(h=m3NutNominalHeightMM,d=1.5*fOuterShellDiameterMM,$fn=32);
}


     

