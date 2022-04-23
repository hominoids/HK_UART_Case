/*
    HK Console UART Case Copyright 2020 Edward A. Kisiel
    hominoid @ www.forum.odroid.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    Code released under GPLv3: http://www.gnu.org/licenses/gpl.html

    20210204 Version 1.0.0  Hard Kernel Console UART Case

*/

use <./fillets.scad>;

fillet = 2;                     // edge fillets
c_fillet = 2;                   // corner fillets
wall_thick = 1.5;
floor_thick = 3;
width = 14 + (wall_thick*2);
depth = 24 + (wall_thick*2);
height = 6.25;
tolerance = 2.625;              // top fit, working range 2.5-2.75, smaller is a tighter fit

adjust = .01;
$fn=90;

//translate([14,0,9]) rotate([0,180,0]) uart_top();
translate([25,0,0]) uart_top();
uart_bottom();

module uart_top() {
    difference() {
        union() {
            difference() {
                translate([(width/2)-wall_thick,(depth/2)-wall_thick,height/2]) 
                    cube_fillet_inside([width+(wall_thick*2),depth,height], 
                        vertical=[c_fillet,c_fillet,c_fillet,c_fillet], 
                            top=[0,0,0,0],bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
                translate([(width/2)-wall_thick,(depth/2),(height/2)+wall_thick]) 
                    cube_fillet_inside([width,depth,height], 
                        vertical=[0,0,0,0],top=[0,0,0,0],bottom=[0,0,0,0], $fn=90);
                // usb hole
                translate([2.5,0,wall_thick+1]) microusb();
                // front trim
                translate([-wall_thick,-wall_thick-adjust,wall_thick+1.5]) 
                    cube([width,wall_thick+(adjust*2),height]);
                // connector cutout
                translate([0,depth-(wall_thick*2)-8,-adjust]) cube([14,12,10]);
            }    
            // side rails
            translate([-wall_thick-adjust-tolerance,-wall_thick,height-.75]) rotate([-90,0,0]) 
                cylinder(d=6,h=depth);
            translate([width-wall_thick-adjust+tolerance,-wall_thick,height-.75]) rotate([-90,0,0]) 
                cylinder(d=6,h=depth);
            translate([-2,-adjust,wall_thick-adjust]) cube([2,depth-wall_thick-adjust,1.5]);
            translate([width-(wall_thick*2)-adjust,-adjust,wall_thick-adjust]) 
                cube([2,depth-wall_thick,1.5]);
        }
        // side trim
        translate([-(wall_thick*2)-10+adjust,-5,0]) cube([10,depth+10,20]);
        translate([width-adjust,-5,0]) cube([10,depth+10,20]);
        // clean outside of fillets
        translate([(width/2)-wall_thick,(depth/2)-wall_thick,(height/2)])     
            cube_negative_fillet([width+(wall_thick*2),depth,20], radius=-1, 
                vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], 
                    bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
    }
}

module uart_bottom() {
    difference() {
        translate([(width/2)-wall_thick,(depth/2)-wall_thick,height/2]) 
            cube_fillet_inside([width,depth,height], 
                vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], 
                    bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
        translate([(width/2)-wall_thick,(depth/2)-wall_thick,(height/2)+floor_thick]) 
            cube_fillet_inside([width-(wall_thick*2),depth-(wall_thick*2),height], 
                vertical=[0,0,0,0],top=[0,0,0,0],bottom=[0,0,0,0], $fn=90);
        //pin slot
        translate([1.5,15.5,.5]) cube([11,1,5]);
        //component bed
        translate([1.5,1.5,floor_thick-1]) cube ([11,13,2]);
        // connector trim
        translate([0,depth-(wall_thick*2)-adjust,floor_thick+1.5]) cube([14,10,10]);
        // capacitor opening
        translate([6.5,14,floor_thick-1]) cube([2,2.1,2]);
        // usb hole
        translate([2.5,0,floor_thick+1.5]) microusb();
        // side indents
        translate([-wall_thick-adjust-2.5,-wall_thick-adjust,3.5]) rotate([-90,0,0]) cylinder(d=6,h=depth+adjust);
        translate([width-wall_thick-adjust+2.5,-wall_thick-adjust,3.5]) rotate([-90,0,0]) cylinder(d=6,h=depth+adjust);
    }    
}

// micro-usb cutout
module microusb() {
    rotate([90,0,0])
    hull() {
        translate([7,1,-5]) cylinder(d=3,h=10);
        translate([2,1,-5]) cylinder(d=3,h=10);
    }
}