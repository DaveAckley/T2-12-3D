    include <T2-FEET-11.inc>

module footFemale() {
     rotate([0,0,0]) femaleConnector();
     #cylinder(h=0.75*fUngappedOuterShellHeightMM,d=1.5*fOuterShellDiameterMM,$fn=32);
}

footFemale();
     

